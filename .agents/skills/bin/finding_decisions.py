#!/usr/bin/env python3
# finding_decisions.py — Finding Lifecycle Decision Registry
#
# Manages machine-verifiable decisions for scanner-detected findings.
# Prevents Markdown-only closure anti-pattern.
#
# Usage:
#   python3 finding_decisions.py validate [--dir <dir>]
#   python3 finding_decisions.py list [--dir <dir>] [--status active] [--decision FIXED]
#   python3 finding_decisions.py explain <id> [--dir <dir>]
#   python3 finding_decisions.py add --tool <tool> --file <file> --decision <decision> --reason <reason> [--dir <dir>]
#   python3 finding_decisions.py expire-check [--dir <dir>]
#   python3 finding_decisions.py match --fingerprint <fp> [--dir <dir>]
#
# Exit codes:
#   0 = All valid / no blocking issues
#   1 = Warnings (non-blocking expired, etc.)
#   2 = Blocking issues (invalid schema, expired blocking decision, RED_ACTIVE)

import argparse
import hashlib
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

VALID_DECISIONS = [
    "FIXED",
    "ACCEPTED_EXCEPTION",
    "DEFERRED",
    "FALSE_POSITIVE",
    "COMPOSITION_ROOT_ALLOWED",
    "SCAFFOLD_DEFERRED",
    "TOOLING_BUG",
    # Legacy AvaX scanner formats
    "INFO_ALLOWED",
    "YELLOW_ACCEPTED",
    "YELLOW_DEFERRED",
]

VALID_DECISION_SEVERITIES = ["RED", "YELLOW", "INFO", "GREEN", "critical", "high", "medium", "low", "info"]
VALID_STATUSES = ["active", "expired", "revoked", "superseded"]
VALID_ORIGINAL_SEVERITIES = ["critical", "high", "medium", "low", "info", "BLOCKER", "HIGH", "MEDIUM", "LOW", "INFO"]

REQUIRED_FIELDS = [
    "id", "tool", "findingFingerprint", "decision",
    "decisionSeverity", "classification", "reason",
    "createdAt", "updatedAt", "status",
]

BLOCKING_DECISIONS = ["FIXED", "ACCEPTED_EXCEPTION", "DEFERRED",
                      "COMPOSITION_ROOT_ALLOWED", "SCAFFOLD_DEFERRED",
                      "FALSE_POSITIVE", "TOOLING_BUG"]

REGISTRY_FILENAME = "finding-decisions.json"
SCHEMA_FILENAME = "finding-decision.schema.json"


# ---------------------------------------------------------------------------
# Fingerprint
# ---------------------------------------------------------------------------

class FindingFingerprint:
    """Generates deterministic SHA-256 fingerprints for findings."""

    @staticmethod
    def generate(tool: str, file: str, line: int | None = None, pattern: str | None = None) -> str:
        canonical = f"{tool}:{file}:{line or ''}:{pattern or ''}"
        return hashlib.sha256(canonical.encode("utf-8")).hexdigest()


# ---------------------------------------------------------------------------
# Schema Validator (lightweight, no external deps)
# ---------------------------------------------------------------------------

def _load_schema(schema_path: Path) -> dict | None:
    if not schema_path.is_file():
        return None
    with open(schema_path) as f:
        return json.load(f)


def validate_decision_schema(decision: dict, schema: dict | None) -> list[str]:
    """Lightweight JSON schema validation without external deps."""
    errors = []

    # Check required fields
    if schema:
        required = schema.get("required", REQUIRED_FIELDS)
    else:
        required = REQUIRED_FIELDS

    for field in required:
        if field not in decision:
            errors.append(f"Missing required field: {field}")

    # Check additionalProperties
    if schema and not schema.get("additionalProperties", True):
        allowed = set(schema.get("properties", {}).keys())
        for key in decision:
            if key not in allowed:
                errors.append(f"Unknown field: {key}")

    # Check enum fields
    enum_fields = {
        "decision": VALID_DECISIONS,
        "decisionSeverity": VALID_DECISION_SEVERITIES,
        "status": VALID_STATUSES,
        "originalSeverity": VALID_ORIGINAL_SEVERITIES,
    }
    for field, allowed in enum_fields.items():
        if field in decision and decision[field] not in allowed:
            errors.append(f"Invalid {field}: {decision[field]} (must be one of {allowed})")

    # Check ID pattern
    if "id" in decision:
        import re
        if not re.match(r"^FD-[0-9]{8}-[0-9]{3}$", decision["id"]):
            errors.append(f"Invalid id format: {decision['id']} (expected FD-YYYYMMDD-NNN)")

    # Check fingerprint format (SHA-256 or tool-specific like avax:path:line:token)
    if "findingFingerprint" in decision:
        import re
        fp = decision["findingFingerprint"]
        if not re.match(r"^[a-f0-9]{64}$", fp) and not fp.startswith("avax:") and ":" not in fp:
            errors.append(f"Invalid findingFingerprint: {fp[:40]}... (must be SHA-256 hex or tool-specific format)")

    # Check date-time fields (allow non-date expiry like trigger conditions)
    for field in ("createdAt", "updatedAt"):
        if field in decision and decision[field] is not None:
            try:
                datetime.fromisoformat(decision[field].replace("Z", "+00:00"))
            except (ValueError, AttributeError):
                errors.append(f"Invalid {field}: {decision[field]}")

    # Semantic validation: ACCEPTED_EXCEPTION requires owner, reason, mitigation, expiry
    if decision.get("decision") == "ACCEPTED_EXCEPTION":
        if not decision.get("owner"):
            errors.append("ACCEPTED_EXCEPTION requires owner")
        if not decision.get("mitigation"):
            errors.append("ACCEPTED_EXCEPTION requires mitigation")
        if not decision.get("expiry"):
            errors.append("ACCEPTED_EXCEPTION requires expiry")

    # Semantic validation: BLOCKER/HIGH cannot be silently accepted
    if decision.get("originalSeverity") in ("critical", "high"):
        if decision.get("decision") == "FALSE_POSITIVE" and not decision.get("evidenceRefs"):
            errors.append("critical/high FALSE_POSITIVE requires evidenceRefs")

    return errors


# ---------------------------------------------------------------------------
# Registry
# ---------------------------------------------------------------------------

class FindingDecisionRegistry:
    """Loads, validates, saves, and queries the finding-decisions registry."""

    def __init__(self, registry_path: str | Path, schema_path: str | Path | None = None):
        self.registry_path = Path(registry_path)
        self.schema_path = Path(schema_path) if schema_path else None
        self._data: dict = {"decisions": []}
        self._schema: dict | None = None

    def load(self) -> list[dict]:
        if not self.registry_path.is_file():
            return []
        with open(self.registry_path) as f:
            self._data = json.load(f)
        if self.schema_path and self.schema_path.is_file():
            with open(self.schema_path) as f:
                self._schema = json.load(f)
        return self._data.get("decisions", [])

    def save(self) -> None:
        self.registry_path.parent.mkdir(parents=True, exist_ok=True)
        with open(self.registry_path, "w") as f:
            json.dump(self._data, f, indent=2)
            f.write("\n")

    def validate_all(self) -> tuple[bool, list[str]]:
        """Validate all decisions against schema. Returns (all_valid, errors)."""
        decisions = self.load()
        all_errors = []
        for i, d in enumerate(decisions):
            errors = validate_decision_schema(d, self._schema)
            for e in errors:
                all_errors.append(f"Decision {d.get('id', f'index-{i}')}: {e}")
        return len(all_errors) == 0, all_errors

    def add_decision(self, decision: dict) -> str:
        """Add a decision and return its ID."""
        self.load()
        if "decisions" not in self._data:
            self._data["decisions"] = []
        self._data["decisions"].append(decision)
        self._data["generatedAt"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
        self.save()
        return decision["id"]

    def find_by_fingerprint(self, fingerprint: str) -> dict | None:
        """Find an active decision by fingerprint."""
        decisions = self.load()
        for d in decisions:
            if d.get("findingFingerprint") == fingerprint and d.get("status") == "active":
                return d
        return None

    def find_by_id(self, decision_id: str) -> dict | None:
        """Find a decision by ID."""
        decisions = self.load()
        for d in decisions:
            if d.get("id") == decision_id:
                return d
        return None

    def find_active_by_tool(self, tool: str) -> list[dict]:
        decisions = self.load()
        return [d for d in decisions if d.get("tool") == tool and d.get("status") == "active"]

    def get_expired(self) -> list[dict]:
        """Return decisions that are past their expiry date."""
        decisions = self.load()
        now = datetime.now(timezone.utc)
        expired = []
        for d in decisions:
            if d.get("expiry") and d.get("status") == "active":
                try:
                    expiry = datetime.fromisoformat(d["expiry"].replace("Z", "+00:00"))
                    if expiry < now:
                        expired.append(d)
                except (ValueError, AttributeError):
                    pass
        return expired

    def mark_expired(self) -> int:
        """Mark expired decisions. Returns count."""
        expired = self.get_expired()
        if not expired:
            return 0
        self.load()
        count = 0
        now_str = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
        for exp in expired:
            for d in self._data["decisions"]:
                if d.get("id") == exp["id"]:
                    d["status"] = "expired"
                    d["updatedAt"] = now_str
                    count += 1
                    break
        if count > 0:
            self.save()
        return count


# ---------------------------------------------------------------------------
# Expiry Checker
# ---------------------------------------------------------------------------

class ExpiryChecker:
    """Checks for expired decisions and determines severity impact."""

    @staticmethod
    def check(registry: FindingDecisionRegistry) -> list[dict]:
        return registry.get_expired()

    @staticmethod
    def has_blocking_expired(registry: FindingDecisionRegistry) -> tuple[bool, list[dict]]:
        """Returns (has_blocking, expired_decisions)."""
        expired = registry.get_expired()
        blocking = [d for d in expired if d.get("decisionSeverity") in ("RED", "YELLOW")]
        return len(blocking) > 0, expired


# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

def _resolve_paths(args) -> tuple[Path, Path | None]:
    """Resolve registry and schema paths from args."""
    base = Path(getattr(args, "dir", ".")).resolve()
    registry = base / ".agents" / "management" / "evidence" / "indexes" / REGISTRY_FILENAME
    schema = base / ".agents" / "config" / "schemas" / SCHEMA_FILENAME
    if not schema.is_file():
        # Fallback: try relative to script
        script_dir = Path(__file__).resolve().parent
        repo_root = script_dir.parent.parent
        schema = repo_root / "config" / "schemas" / SCHEMA_FILENAME
        if not schema.is_file():
            schema = None
    return registry, schema


def cmd_validate(args):
    """Validate the entire registry."""
    registry_path, schema_path = _resolve_paths(args)
    if not registry_path.is_file():
        print(f"ERROR: Registry not found: {registry_path}", file=sys.stderr)
        sys.exit(2)

    registry = FindingDecisionRegistry(registry_path, schema_path)
    all_valid, errors = registry.validate_all()

    # Check expired
    has_blocking, expired = ExpiryChecker.has_blocking_expired(registry)

    if not all_valid:
        print("RED: Schema validation errors:")
        for e in errors:
            print(f"  - {e}")
        sys.exit(2)

    if has_blocking:
        print("RED: Expired blocking decisions:")
        for d in expired:
            if d.get("decisionSeverity") in ("RED", "YELLOW"):
                print(f"  - {d['id']}: {d['tool']} ({d['decision']}) expired {d['expiry']}")
        sys.exit(2)

    if expired:
        print("YELLOW: Non-blocking expired decisions:")
        for d in expired:
            print(f"  - {d['id']}: {d['tool']} expired {d['expiry']}")
        sys.exit(1)

    decisions = registry.load()
    print(f"GREEN: Registry valid ({len(decisions)} decisions, all active)")
    sys.exit(0)


def cmd_list(args):
    """List decisions with optional filters."""
    registry_path, schema_path = _resolve_paths(args)
    if not registry_path.is_file():
        print("No registry found.")
        sys.exit(0)

    registry = FindingDecisionRegistry(registry_path, schema_path)
    decisions = registry.load()

    # Apply filters
    status_filter = getattr(args, "status", None)
    decision_filter = getattr(args, "decision", None)
    tool_filter = getattr(args, "tool", None)

    if status_filter:
        decisions = [d for d in decisions if d.get("status") == status_filter]
    if decision_filter:
        decisions = [d for d in decisions if d.get("decision") == decision_filter]
    if tool_filter:
        decisions = [d for d in decisions if d.get("tool") == tool_filter]

    if getattr(args, "json_output", False):
        print(json.dumps(decisions, indent=2))
    else:
        if not decisions:
            print("No decisions found.")
            return
        print(f"{'ID':<20} {'Tool':<30} {'Decision':<25} {'Severity':<10} {'Status':<10} {'Expiry'}")
        print("-" * 120)
        for d in decisions:
            print(f"{d['id']:<20} {d['tool']:<30} {d['decision']:<25} {d['decisionSeverity']:<10} {d['status']:<10} {d.get('expiry', '') or 'permanent'}")
        print(f"\nTotal: {len(decisions)}")

    sys.exit(0)


def cmd_explain(args):
    """Explain a single decision."""
    registry_path, schema_path = _resolve_paths(args)
    if not registry_path.is_file():
        print(f"ERROR: Registry not found: {registry_path}", file=sys.stderr)
        sys.exit(2)

    registry = FindingDecisionRegistry(registry_path, schema_path)
    decision = registry.find_by_id(args.id)
    if not decision:
        print(f"ERROR: Decision not found: {args.id}", file=sys.stderr)
        sys.exit(1)

    if getattr(args, "json_output", False):
        print(json.dumps(decision, indent=2))
    else:
        for key, value in decision.items():
            print(f"  {key}: {value}")

    sys.exit(0)


def cmd_add(args):
    """Add a new decision."""
    registry_path, schema_path = _resolve_paths(args)
    if not registry_path.is_file():
        # Create registry if it doesn't exist
        registry_path.parent.mkdir(parents=True, exist_ok=True)
        with open(registry_path, "w") as f:
            json.dump({
                "schemaVersion": "1.0.0",
                "generatedAt": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
                "schemaRef": ".agents/config/schemas/finding-decision.schema.json",
                "decisions": [],
            }, f, indent=2)
            f.write("\n")

    # Generate ID
    now = datetime.now(timezone.utc)
    date_str = now.strftime("%Y%m%d")

    # Count existing decisions for sequence number
    registry = FindingDecisionRegistry(registry_path, schema_path)
    decisions = registry.load()
    seq = len(decisions) + 1
    decision_id = f"FD-{date_str}-{seq:03d}"

    # Generate fingerprint
    fingerprint = FindingFingerprint.generate(
        args.tool, args.file,
        getattr(args, "line", None),
        getattr(args, "pattern", None),
    )

    now_str = now.strftime("%Y-%m-%dT%H:%M:%SZ")

    decision = {
        "id": decision_id,
        "tool": args.tool,
        "findingFingerprint": fingerprint,
        "file": args.file,
        "line": getattr(args, "line", None),
        "pattern": getattr(args, "pattern", None),
        "originalSeverity": getattr(args, "original_severity", "medium"),
        "decision": args.decision,
        "decisionSeverity": getattr(args, "decision_severity", "YELLOW"),
        "classification": getattr(args, "classification", ""),
        "reason": args.reason,
        "owner": getattr(args, "owner", None),
        "expiry": getattr(args, "expiry", None),
        "mitigation": getattr(args, "mitigation", None),
        "evidenceRefs": getattr(args, "evidence_refs", []),
        "approvedBy": getattr(args, "approved_by", None),
        "createdAt": now_str,
        "updatedAt": now_str,
        "status": "active",
    }

    # Validate before saving
    errors = validate_decision_schema(decision, registry._schema)
    if errors:
        print("ERROR: Decision validation failed:", file=sys.stderr)
        for e in errors:
            print(f"  - {e}", file=sys.stderr)
        sys.exit(2)

    registry.add_decision(decision)
    print(f"Decision added: {decision_id}")
    print(f"  Fingerprint: {fingerprint}")
    sys.exit(0)


def cmd_expire_check(args):
    """Check for expired decisions."""
    registry_path, schema_path = _resolve_paths(args)
    if not registry_path.is_file():
        print("No registry found.")
        sys.exit(0)

    registry = FindingDecisionRegistry(registry_path, schema_path)
    has_blocking, expired = ExpiryChecker.has_blocking_expired(registry)

    if not expired:
        print("GREEN: No expired decisions")
        sys.exit(0)

    print(f"Found {len(expired)} expired decision(s):")
    for d in expired:
        sev = d.get("decisionSeverity", "UNKNOWN")
        print(f"  [{sev}] {d['id']}: {d['tool']} - {d['decision']} (expired {d['expiry']})")

    if has_blocking:
        print("\nRED: Blocking decisions expired")
        sys.exit(2)
    else:
        print("\nYELLOW: Non-blocking decisions expired")
        sys.exit(1)


def cmd_match(args):
    """Match a finding fingerprint against the registry."""
    registry_path, schema_path = _resolve_paths(args)
    if not registry_path.is_file():
        print(f"No registry found. Fingerprint: {args.fingerprint}")
        sys.exit(1)

    registry = FindingDecisionRegistry(registry_path, schema_path)
    decision = registry.find_by_fingerprint(args.fingerprint)

    if decision:
        if getattr(args, "json_output", False):
            print(json.dumps(decision, indent=2))
        else:
            print(f"Match found: {decision['id']}")
            print(f"  Tool: {decision['tool']}")
            print(f"  Decision: {decision['decision']}")
            print(f"  Severity: {decision['decisionSeverity']}")
            print(f"  Status: {decision['status']}")
        sys.exit(0)
    else:
        print(f"No active decision found for fingerprint: {args.fingerprint[:16]}...")
        sys.exit(1)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Finding Lifecycle Decision Registry — prevents Markdown-only closure",
    )
    parser.add_argument("--dir", default=".", help="Project root directory")
    parser.add_argument("--json", dest="json_output", action="store_true", help="Output JSON")

    sub = parser.add_subparsers(dest="command", required=True)

    # validate
    p_validate = sub.add_parser("validate", help="Validate entire registry")
    p_validate.set_defaults(func=cmd_validate)

    # list
    p_list = sub.add_parser("list", help="List decisions")
    p_list.add_argument("--status", help="Filter by status (active/expired/revoked/superseded)")
    p_list.add_argument("--decision", help="Filter by decision type")
    p_list.add_argument("--tool", help="Filter by tool name")
    p_list.set_defaults(func=cmd_list)

    # explain
    p_explain = sub.add_parser("explain", help="Explain a decision")
    p_explain.add_argument("id", help="Decision ID (e.g., FD-20260519-001)")
    p_explain.set_defaults(func=cmd_explain)

    # add
    p_add = sub.add_parser("add", help="Add a new decision")
    p_add.add_argument("--tool", required=True)
    p_add.add_argument("--file", required=True)
    p_add.add_argument("--decision", required=True, choices=VALID_DECISIONS)
    p_add.add_argument("--reason", required=True)
    p_add.add_argument("--line", type=int, default=None)
    p_add.add_argument("--pattern", default=None)
    p_add.add_argument("--original-severity", dest="original_severity", default="medium")
    p_add.add_argument("--decision-severity", dest="decision_severity", default="YELLOW")
    p_add.add_argument("--classification", default="")
    p_add.add_argument("--owner", default=None)
    p_add.add_argument("--expiry", default=None)
    p_add.add_argument("--mitigation", default=None)
    p_add.add_argument("--evidence-refs", dest="evidence_refs", nargs="*", default=[])
    p_add.add_argument("--approved-by", dest="approved_by", default=None)
    p_add.set_defaults(func=cmd_add)

    # expire-check
    p_expire = sub.add_parser("expire-check", help="Check for expired decisions")
    p_expire.set_defaults(func=cmd_expire_check)

    # match
    p_match = sub.add_parser("match", help="Match a fingerprint")
    p_match.add_argument("--fingerprint", required=True)
    p_match.set_defaults(func=cmd_match)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
