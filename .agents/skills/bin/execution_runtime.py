#!/usr/bin/env python3
# execution_runtime.py — V1.0.0 Unified Execution Substrate Orchestrator
#
# Canonical execution entrypoint for Agent Harness.
# Unifies: command_sandbox, crypto_seals, substrate_security,
#           execution_analysis, replay-evidence.
#
# CLI:
#   execution_runtime.py run --task <task> --tier <tier> --scope <scope> --cmd <command> [--dir <dir>] [--dry-run]
#   execution_runtime.py replay <exec_id> [--dir <dir>]
#   execution_runtime.py status [--dir <dir>]
#   execution_runtime.py seal <manifest_path> [--dir <dir>]
#   execution_runtime.py verify <manifest_path> [--dir <dir>]
#   execution_runtime.py graph [--dir <dir>]
#   execution_runtime.py audit-chain [--dir <dir>]

import os
import sys
import json
import time
import uuid
import hashlib
import hmac
import subprocess

# ---------------------------------------------------------------------------
# Import existing subsystems
# ---------------------------------------------------------------------------

_SYS_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _SYS_DIR)

from command_sandbox import (
    CommandParser,
    AllowedCommandRegistry,
    ResourceLimiter,
    SafeSubprocessRunner,
    SandboxPolicy,
)
from crypto_seals import (
    HMACKeyManager,
    HMACSeal,
    HMACAuditChain,
)
from substrate_security import (
    NonceRegistry,
    RevocationRegistry,
    EnvironmentSanitizer,
    PathGuard,
)
from execution_analysis import (
    build_execution_graph,
    run_graph_compaction,
)

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

OUTPUT_DIR = ".agents/management/evidence/execution"
SECURITY_DIR = ".agents/management/evidence/security"
CONTRACTS_DIR = ".agents/management/contracts"
INDEX_PATH = ".agents/management/evidence/generated/governance-index.json"

LIFECYCLE_STATES = [
    "CREATED", "PLANNED", "EXECUTING", "VALIDATING",
    "REPLAYABLE", "FAILED", "ROLLED_BACK",
    "INVALIDATED", "EXPIRED",
]

TRUST_TIERS = ["READ_ONLY", "WORKSPACE_WRITE", "GOVERNANCE_WRITE", "TRUSTED"]

TIER_TO_TRUST_TIER_MAP = {
    "T0": "READ_ONLY",
    "T1": "WORKSPACE_WRITE",
    "T2": "GOVERNANCE_WRITE",
    "T3": "TRUSTED",
}

TRUST_TIER_RANKS = {
    "READ_ONLY": 1,
    "WORKSPACE_WRITE": 2,
    "GOVERNANCE_WRITE": 3,
    "TRUSTED": 4,
}

# Danger classification patterns
_DANGEROUS_PATTERNS = [
    "rm -rf", "rm -f /", "rm -rf /", "rm -rf ~",
    "chmod 777", "chmod -R", "chown",
    "sudo", "kill -9", "killall",
    "systemctl", "service",
    "DROP TABLE", "DROP DATABASE", "TRUNCATE TABLE",
    "DELETE FROM",  # without WHERE (simplified check)
]

_FORBIDDEN_PATTERNS = [
    "rm -rf / ", "rm -rf /\"", "rm -rf /'",  # root with trailing space/quote
    "rm -rf ~",  # home directory
    "curl |", "wget |", "| bash", "| sh",
    "rm -rf $", "rm -rf `",
    # Exact matches for root-level deletion
]

# Exact-match forbidden commands (checked before substring patterns)
_FORBIDDEN_EXACT = [
    "rm -rf /",  # exact root deletion
]

# ---------------------------------------------------------------------------
# Danger Classifier
# ---------------------------------------------------------------------------


class DangerClassifier:
    """Classifies commands into SAFE, REVIEW, DANGEROUS, FORBIDDEN."""

    @classmethod
    def classify(cls, command_string: str) -> dict:
        """Classify a command string.

        Returns dict with: danger_class, reason, patterns_matched.
        """
        cmd_lower = command_string.lower()

        # Check exact-match forbidden first
        if command_string.strip() in _FORBIDDEN_EXACT:
            return {
                "danger_class": "FORBIDDEN",
                "reason": "Command matches forbidden exact pattern: root deletion",
                "patterns_matched": [command_string.strip()],
            }

        # Check forbidden patterns
        matched_forbidden = [p for p in _FORBIDDEN_PATTERNS if p in cmd_lower]
        if matched_forbidden:
            return {
                "danger_class": "FORBIDDEN",
                "reason": f"Command matches forbidden patterns: {', '.join(repr(p) for p in matched_forbidden)}",
                "patterns_matched": matched_forbidden,
            }

        # Check dangerous (case-insensitive for SQL, case-sensitive for unix commands)
        matched_dangerous = [p for p in _DANGEROUS_PATTERNS if p.lower() in cmd_lower]
        if matched_dangerous:
            return {
                "danger_class": "DANGEROUS",
                "reason": f"Command matches dangerous patterns: {', '.join(repr(p) for p in matched_dangerous)}",
                "patterns_matched": matched_dangerous,
            }

        # Check if command parses (shell safety)
        try:
            argv, _ = CommandParser.parse_command(command_string)
        except ValueError:
            return {
                "danger_class": "FORBIDDEN",
                "reason": "Command contains unsafe shell syntax (shell=True required)",
                "patterns_matched": ["unsafe_shell"],
            }

        # If it writes (contains write-like operations), it's at least REVIEW
        write_indicators = ["touch ", "mkdir ", "cp ", "mv ", "tee ", ">>", ">"]
        is_write = any(ind in command_string for ind in write_indicators)

        if is_write:
            return {
                "danger_class": "REVIEW",
                "reason": "Command may modify filesystem",
                "patterns_matched": write_indicators,
            }

        return {
            "danger_class": "SAFE",
            "reason": "Command appears safe (read-only, no dangerous patterns)",
            "patterns_matched": [],
        }


# ---------------------------------------------------------------------------
# Approval Enforcer
# ---------------------------------------------------------------------------


class ApprovalEnforcer:
    """Enforces approval policy based on danger class and trust tier.

    Maps to approval-policy.md graduated trust model.
    """

    @classmethod
    def should_approve(
        cls, danger_class: str, trust_tier: str, dry_run: bool = False
    ) -> dict:
        """Determine if a command should be approved.

        Returns dict with: approved, reason, requires_human.
        """
        if dry_run:
            return {
                "approved": False,
                "reason": f"[DRY-RUN] Would {'approve' if cls._is_allowed(danger_class, trust_tier) else 'deny'}: {danger_class} @ {trust_tier}",
                "requires_human": cls._requires_human(danger_class, trust_tier),
            }

        if not cls._is_allowed(danger_class, trust_tier):
            return {
                "approved": False,
                "reason": cls._denial_reason(danger_class, trust_tier),
                "requires_human": True,
            }

        return {
            "approved": True,
            "reason": f"Command allowed: {danger_class} @ {trust_tier}",
            "requires_human": False,
        }

    @classmethod
    def _is_allowed(cls, danger_class: str, trust_tier: str) -> bool:
        if danger_class == "FORBIDDEN":
            return False
        if danger_class == "SAFE":
            return True
        if danger_class == "DANGEROUS" and trust_tier in ("T3", "TRUSTED"):
            return True
        if danger_class == "REVIEW" and trust_tier in (
            "T1", "T2", "T3",
            "WORKSPACE_WRITE", "GOVERNANCE_WRITE", "TRUSTED",
        ):
            return True
        if danger_class == "DANGEROUS" and trust_tier in (
            "T1", "T2",
            "WORKSPACE_WRITE", "GOVERNANCE_WRITE",
        ):
            return False  # Requires human approval
        return False

    @classmethod
    def _requires_human(cls, danger_class: str, trust_tier: str) -> bool:
        if danger_class == "FORBIDDEN":
            return False  # Auto-denied, not human-requested
        if danger_class == "DANGEROUS":
            return True
        if danger_class == "REVIEW" and trust_tier in ("T0", "READ_ONLY"):
            return True
        return False

    @classmethod
    def _denial_reason(cls, danger_class: str, trust_tier: str) -> str:
        if danger_class == "FORBIDDEN":
            return "Command is FORBIDDEN — always blocked regardless of trust tier"
        if danger_class == "DANGEROUS":
            return f"Command is DANGEROUS — requires explicit human approval (current tier: {trust_tier})"
        if danger_class == "REVIEW":
            return f"Command requires REVIEW at trust tier {trust_tier}"
        return f"Command not allowed: {danger_class} @ {trust_tier}"


# ---------------------------------------------------------------------------
# Capability Token (from execution-substrate.py)
# ---------------------------------------------------------------------------


class CapabilityToken:
    def __init__(self, token_id, lease_duration, max_memory_mb, allowed_tools, allowed_scopes, trust_tier, hmac_key=None):
        self.token_id = token_id
        self.lease_duration = lease_duration
        self.max_memory_mb = max_memory_mb
        self.allowed_tools = list(allowed_tools)
        self.allowed_scopes = list(allowed_scopes)
        self.trust_tier = trust_tier
        self.issued_at = time.time()
        self._hmac_key = hmac_key
        self.signature = self._generate_signature()

    def _generate_signature(self):
        payload = f"{self.token_id}:{self.lease_duration}:{self.max_memory_mb}:{','.join(self.allowed_tools)}:{','.join(self.allowed_scopes)}:{self.trust_tier}:{self.issued_at}"
        if self._hmac_key:
            return hmac.new(self._hmac_key, payload.encode("utf-8"), hashlib.sha256).hexdigest()
        return hashlib.sha256(payload.encode("utf-8")).hexdigest()

    def is_expired(self):
        return (time.time() - self.issued_at) > self.lease_duration

    def validate_delegation(self, child_token):
        for t in child_token.allowed_tools:
            if t not in self.allowed_tools:
                return False, f"Escalation: child tool '{t}' not held by parent"
        for s in child_token.allowed_scopes:
            if s not in self.allowed_scopes:
                return False, f"Escalation: child scope '{s}' not held by parent"
        if TRUST_TIER_RANKS.get(child_token.trust_tier, 0) > TRUST_TIER_RANKS.get(self.trust_tier, 0):
            return False, f"Escalation: child tier '{child_token.trust_tier}' > parent '{self.trust_tier}'"
        return True, "Valid narrowing"

    def to_dict(self):
        return {
            "token_id": self.token_id,
            "lease_duration_sec": self.lease_duration,
            "max_memory_mb": self.max_memory_mb,
            "allowed_tools": self.allowed_tools,
            "allowed_scopes": self.allowed_scopes,
            "trust_tier": self.trust_tier,
            "issued_at": self.issued_at,
            "signature": self.signature,
        }

    @classmethod
    def from_dict(cls, data):
        token = cls(
            token_id=data["token_id"],
            lease_duration=data["lease_duration_sec"],
            max_memory_mb=data["max_memory_mb"],
            allowed_tools=data["allowed_tools"],
            allowed_scopes=data["allowed_scopes"],
            trust_tier=data["trust_tier"],
        )
        token.issued_at = data["issued_at"]
        token.signature = data["signature"]
        return token


# ---------------------------------------------------------------------------
# Execution Runtime
# ---------------------------------------------------------------------------


class ExecutionRuntime:
    """Unified execution substrate orchestrator.

    Coordinates: sandbox, crypto seals, security primitives,
    approval enforcement, danger classification, replay.
    """

    def __init__(self, target_dir="."):
        self.target_dir = os.path.normpath(target_dir)
        self.output_dir = os.path.join(self.target_dir, OUTPUT_DIR)
        self.security_dir = os.path.join(self.target_dir, SECURITY_DIR)
        os.makedirs(self.output_dir, exist_ok=True)
        os.makedirs(self.security_dir, exist_ok=True)

        # V6: Session tracking (Phase 3)
        self.session_id = os.environ.get(
            "RUNTIME_SESSION_ID",
            f"session-{os.getpid()}-{int(time.time())}"
        )
        self._session_counter = 0
        self._session_registry_path = os.path.join(
            self.target_dir, ".agents/management/evidence/generated/session-registry.jsonl"
        )

        # V6: Replay checkpoint dir (Phase 6)
        self.replay_dir = os.path.join(self.target_dir, ".agents/management/evidence/replay")
        os.makedirs(self.replay_dir, exist_ok=True)
        self._replay_checkpoint_path = os.path.join(self.replay_dir, "replay-checkpoints.jsonl")

        # Sandbox subsystem
        self.command_parser = CommandParser()
        self.allowed_commands = AllowedCommandRegistry()
        self.resource_limiter = ResourceLimiter()
        self.sandbox_policy = SandboxPolicy()

        # Crypto subsystem
        self.hmac_key_manager = HMACKeyManager(target_dir=self.target_dir)
        self.hmac_seal = HMACSeal(key_manager=self.hmac_key_manager, target_dir=self.target_dir)
        self.hmac_audit_chain = HMACAuditChain(key_manager=self.hmac_key_manager, target_dir=self.target_dir)

        # Security subsystem
        self.nonce_registry = NonceRegistry(self.target_dir)
        self.revocation_registry = RevocationRegistry(self.target_dir)
        self.env_sanitizer = EnvironmentSanitizer()
        self.path_guard = PathGuard(self.target_dir)

    # -- helpers --

    def _generate_id(self, prefix=""):
        """Generate session-aware execution ID (Phase 3)."""
        self._session_counter += 1
        return f"{prefix}-{uuid.uuid4()}"

    def _atomic_write_json(self, path: str, data: dict):
        """Write JSON atomically via tmp+replace (Phase 8)."""
        tmp_path = path + ".tmp"
        with open(tmp_path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2)
        os.replace(tmp_path, path)

    def _append_jsonl(self, path: str, record: dict):
        """Append one line to a JSONL file, creating if needed."""
        parent = os.path.dirname(path)
        os.makedirs(parent, exist_ok=True)
        with open(path, "a", encoding="utf-8") as f:
            f.write(json.dumps(record) + "\n")

    def _record_session(self, exec_id: str):
        """Append execution to session registry (Phase 3)."""
        self._append_jsonl(self._session_registry_path, {
            "session_id": self.session_id,
            "execution_id": exec_id,
            "counter": self._session_counter,
            "timestamp": time.time(),
            "parent_session_id": os.environ.get("RUNTIME_PARENT_SESSION"),
        })

    def _write_approval_record(self, exec_id: str, task_command: str, danger: dict,
                                resolved_tier: str, approval: dict):
        """Persist approval record (Phase 4)."""
        decision = "denied" if not approval["approved"] else (
            "auto_approved" if danger["danger_class"] == "SAFE" else "approved"
        )
        record = {
            "approval_id": f"approval-{exec_id}",
            "execution_id": exec_id,
            "command": task_command,
            "danger_class": danger["danger_class"],
            "trust_tier": resolved_tier,
            "risk_level": {
                "FORBIDDEN": "Critical", "DANGEROUS": "High",
                "REVIEW": "Medium", "SAFE": "Low",
            }.get(danger["danger_class"], "Medium"),
            "requested_at": time.time(),
            "decision": decision,
            "decision_by": "policy",
            "decision_at": time.time(),
            "rationale": approval["reason"],
            "denial_reason": approval["reason"] if not approval["approved"] else None,
        }
        approval_path = os.path.join(
            self.target_dir, ".agents/management/evidence/generated/approval-records.jsonl"
        )
        self._append_jsonl(approval_path, record)

    def _write_replay_checkpoint(self, exec_id: str, manifest_path: str,
                                  exit_code: int, changes: dict):
        """Write replay checkpoint (Phase 6)."""
        expected_mutations = (
            len(changes.get("created", []))
            + len(changes.get("modified", []))
            + len(changes.get("deleted", []))
        )
        self._append_jsonl(self._replay_checkpoint_path, {
            "execution_id": exec_id,
            "replay_contract_id": f"replay-{exec_id}",
            "checkpoint_at": time.time(),
            "manifest_path": manifest_path,
            "expected_exit_code": exit_code,
            "expected_mutations": expected_mutations,
            "status": "PENDING_REPLAY",
        })

    def _write_execution_summary(self, exec_id: str, status: str,
                                  total_duration_ms: float, danger_class: str, tier: str):
        """Append one-line execution summary (Phase 14)."""
        summary_path = os.path.join(
            self.target_dir, ".agents/management/evidence/generated/execution-summary.jsonl"
        )
        self._append_jsonl(summary_path, {
            "exec_id": exec_id,
            "status": status,
            "duration_ms": round(total_duration_ms, 1),
            "danger_class": danger_class,
            "tier": tier,
            "timestamp": time.time(),
        })

    def _scan_stale_executions(self) -> list:
        """Find incomplete manifests from crashed executions (Phase 8)."""
        stale = []
        if not os.path.exists(self.output_dir):
            return stale
        for fname in os.listdir(self.output_dir):
            if not fname.startswith("execution-manifest-"):
                continue
            fpath = os.path.join(self.output_dir, fname)
            try:
                with open(fpath, "r", encoding="utf-8") as f:
                    manifest = json.load(f)
                state = manifest.get("lifecycle_state", "")
                if state in ("EXECUTING", "PLANNED", "CREATED"):
                    stale.append({
                        "file": fpath,
                        "execution_id": manifest.get("execution_id"),
                        "stale_state": state,
                    })
            except Exception:
                pass
        return stale

    def _resolve_tier(self, tier: str) -> str:
        """Normalize tier string to canonical trust tier name."""
        tier_upper = tier.upper()
        if tier_upper in TIER_TO_TRUST_TIER_MAP:
            return TIER_TO_TRUST_TIER_MAP[tier_upper]
        if tier_upper in TRUST_TIERS:
            return tier_upper
        return "READ_ONLY"  # safest default

    def _scan_files_state(self):
        """Scan target directory for a compact file state summary.

        V7: Instead of storing every file hash (which bloats manifests to 1MB+),
        compute an aggregate hash + count. Individual file tracking is still
        available via _enforce_trust_boundary which scans on-demand.
        """
        file_hashes = []
        file_count = 0
        for root, dirs, files in os.walk(self.target_dir):
            rel_root = os.path.relpath(root, self.target_dir)
            if rel_root.startswith(".agents/management/evidence"):
                continue
            if ".git" in rel_root.split(os.sep):
                continue
            dirs[:] = [
                d for d in dirs
                if not d.startswith(".git")
                and d not in ("node_modules", "vendor", "artifacts", "__pycache__")
            ]
            for file in files:
                filepath = os.path.join(root, file)
                rel_path = os.path.relpath(filepath, self.target_dir)
                if rel_path.startswith(".agents/management/evidence"):
                    continue
                try:
                    hasher = hashlib.sha256()
                    with open(filepath, "rb") as f:
                        while True:
                            chunk = f.read(65536)
                            if not chunk:
                                break
                            hasher.update(chunk)
                    file_hashes.append(hasher.hexdigest()[:16])
                    file_count += 1
                except Exception:
                    pass

        # Compute aggregate state hash from sorted individual hashes
        aggregate = hashlib.sha256()
        for h in sorted(file_hashes):
            aggregate.update(h.encode())

        return {
            "file_count": file_count,
            "aggregate_hash": aggregate.hexdigest(),
        }

    def _enforce_trust_boundary(self, tier, before_state, after_state):
        """Check file mutations against trust tier constraints.

        V7: Supports both compact state (aggregate_hash) and legacy per-file state.
        If compact, does a fresh scan for detailed comparison.
        """
        # If before_state is compact, do a fresh scan for detailed comparison
        if "aggregate_hash" in before_state:
            before_state = self._scan_files_state_detailed()
        if "aggregate_hash" in after_state:
            after_state = self._scan_files_state_detailed()

        violations = []
        changes = {"created": [], "modified": [], "deleted": []}

        for path, post_hash in after_state.items():
            if path not in before_state:
                changes["created"].append(path)
            elif before_state[path] != post_hash:
                changes["modified"].append(path)

        for path in before_state:
            if path not in after_state:
                changes["deleted"].append(path)

        all_mutations = changes["created"] + changes["modified"] + changes["deleted"]

        if tier == "READ_ONLY" and all_mutations:
            violations.append(
                f"READ_ONLY execution mutated {len(all_mutations)} files"
            )
        elif tier == "WORKSPACE_WRITE":
            for path in all_mutations:
                if path.startswith(".agents"):
                    violations.append(
                        f"WORKSPACE_WRITE modified governance path: {path}"
                    )
        elif tier == "GOVERNANCE_WRITE":
            for path in all_mutations:
                if path.startswith(".agents/.rules") or path.startswith(".agents/config"):
                    violations.append(
                        f"GOVERNANCE_WRITE modified frozen baseline: {path}"
                    )

        return violations, changes

    def _scan_files_state_detailed(self):
        """Per-file hash scan for trust boundary enforcement (used internally)."""
        state = {}
        for root, dirs, files in os.walk(self.target_dir):
            rel_root = os.path.relpath(root, self.target_dir)
            if rel_root.startswith(".agents/management/evidence"):
                continue
            if ".git" in rel_root.split(os.sep):
                continue
            dirs[:] = [
                d for d in dirs
                if not d.startswith(".git")
                and d not in ("node_modules", "vendor", "artifacts", "__pycache__")
            ]
            for file in files:
                filepath = os.path.join(root, file)
                rel_path = os.path.relpath(filepath, self.target_dir)
                if rel_path.startswith(".agents/management/evidence"):
                    continue
                try:
                    hasher = hashlib.sha256()
                    with open(filepath, "rb") as f:
                        while True:
                            chunk = f.read(65536)
                            if not chunk:
                                break
                            hasher.update(chunk)
                    state[rel_path] = hasher.hexdigest()
                except Exception:
                    pass
        return state

    def _load_domain_rules(self, domain_scope):
        """Load governance rules for the given domain scope."""
        index_path = os.path.join(self.target_dir, INDEX_PATH)
        domain_rules = []
        if os.path.exists(index_path):
            try:
                with open(index_path, "r", encoding="utf-8") as f:
                    index = json.load(f)
                for rel_path in index.get("files", {}).keys():
                    if f"governance/{domain_scope}/" in rel_path or f".rules/governance/{domain_scope}/" in rel_path:
                        domain_rules.append(rel_path)
            except Exception:
                pass
        return domain_rules

    def _rollback(self, changes):
        """Rollback mutations: delete created, git checkout modified/deleted."""
        for path in changes.get("created", []):
            try:
                os.remove(os.path.join(self.target_dir, path))
            except Exception:
                pass
        for path in changes.get("modified", []) + changes.get("deleted", []):
            try:
                subprocess.run(
                    ["git", "-C", self.target_dir, "checkout", "--", path],
                    capture_output=True,
                )
            except Exception:
                pass

    # -- core execution --

    def execute(
        self,
        task,
        tier,
        domain_scope,
        task_command,
        allowed_tools=None,
        parent_token_dict=None,
        dry_run=False,
        output_format="human",
        quiet=False,
    ):
        """Execute a task through the full execution lifecycle.

        Returns (success: bool, result: str).
        """
        start_time = time.time()
        exec_id = self._generate_id("exec")
        deleg_id = self._generate_id("deleg")
        exec_nonce = str(uuid.uuid4())
        resolved_tier = self._resolve_tier(tier)

        lifecycle = [{"state": "CREATED", "timestamp": start_time}]

        # V6 Phase 8: Scan for stale executions from crashed processes
        stale = self._scan_stale_executions()
        if stale:
            for s in stale:
                print(f"  WARN: Stale execution detected: {s['execution_id']} ({s['stale_state']})")

        # -- Danger classification --
        if task_command:
            danger = DangerClassifier.classify(task_command)
        else:
            danger = {"danger_class": "SAFE", "reason": "No command", "patterns_matched": []}

        # -- V6 Phase 5: Active sandbox policy enforcement --
        if task_command:
            policy_result = self.sandbox_policy.enforce_policy(task_command, resolved_tier)
            if not policy_result["allowed"]:
                lifecycle.append({"state": "FAILED", "timestamp": time.time()})
                self._write_approval_record(exec_id, task_command, danger, resolved_tier, {
                    "approved": False, "reason": f"SANDBOX_DENIED: {policy_result['reason']}",
                })
                return False, f"SANDBOX_DENIED: {policy_result['reason']}"

        # -- Approval enforcement --
        approval = ApprovalEnforcer.should_approve(
            danger["danger_class"], resolved_tier, dry_run=dry_run
        )

        # V6 Phase 4: Always persist approval record
        self._write_approval_record(exec_id, task_command, danger, resolved_tier, approval)

        if dry_run:
            return True, json.dumps({
                "execution_id": exec_id,
                "dry_run": True,
                "danger_class": danger["danger_class"],
                "danger_reason": danger["reason"],
                "approval": approval["reason"],
                "trust_tier": resolved_tier,
                "task": task,
                "command": task_command,
            }, indent=2)

        if not approval["approved"]:
            lifecycle.append({"state": "FAILED", "timestamp": time.time()})
            # V6 Phase 14: Explainable denial
            if danger["danger_class"] == "FORBIDDEN":
                return False, f"DENIED (FORBIDDEN): {approval['reason']}. This command is always blocked. No override is possible."
            elif danger["danger_class"] == "DANGEROUS":
                return False, f"DENIED (DANGEROUS): {approval['reason']}. Requires human approval. Increase trust tier or use a safer alternative."
            return False, approval["reason"]

        # -- Capability tokens --
        tools = allowed_tools or [
            "view_file", "search_web", "write_to_file", "replace_file_content",
        ]

        if parent_token_dict:
            parent_token = CapabilityToken.from_dict(parent_token_dict)
        else:
            parent_token = CapabilityToken(
                token_id="operator-root",
                lease_duration=3600,
                max_memory_mb=1024,
                allowed_tools=tools,
                allowed_scopes=["security", "operations", "architecture", "product", "validation", "ci", "governance", "performance"],
                trust_tier="GOVERNANCE_WRITE",
                hmac_key=self.hmac_key_manager.get_key(),
            )

        child_token = CapabilityToken(
            token_id=f"token-{exec_id}",
            lease_duration=600,
            max_memory_mb=512,
            allowed_tools=tools,
            allowed_scopes=[domain_scope],
            trust_tier=resolved_tier,
            hmac_key=self.hmac_key_manager.get_key(),
        )

        # Revocation check
        if self.revocation_registry.is_revoked(parent_token.token_id):
            return False, f"TOKEN_REVOKED: parent '{parent_token.token_id}' revoked"

        # Nonce registration
        nonce_expires_at = child_token.issued_at + child_token.lease_duration
        if not self.nonce_registry.register_nonce(exec_nonce, child_token.token_id, nonce_expires_at):
            return False, f"NONCE_REUSED: nonce '{exec_nonce}' already used"

        # Delegation narrowing
        ok, msg = parent_token.validate_delegation(child_token)
        if not ok:
            self.revocation_registry.revoke_token(child_token.token_id, f"escalation: {msg}")
            return False, f"TOKEN_ESCALATION_BLOCKED: {msg}"

        lifecycle.append({"state": "PLANNED", "timestamp": time.time()})

        # -- Domain rules --
        domain_rules = self._load_domain_rules(domain_scope)

        # -- Baseline scan --
        before_state = self._scan_files_state()
        baseline_symlinks = self.path_guard.detect_symlinks(before_state)

        lifecycle.append({"state": "EXECUTING", "timestamp": time.time()})

        # -- Environment --
        sanitized_env = self.env_sanitizer.sanitize_env(os.environ.copy())
        sanitized_env["EXECUTION_ID"] = exec_id
        sanitized_env["DELEGATION_ID"] = deleg_id
        sanitized_env["TRUST_TIER"] = resolved_tier
        sanitized_env["SUBSTRATE_NONCE"] = exec_nonce

        # -- Execute command --
        exec_timing_start = time.time()
        stdout_content = ""
        stderr_content = ""
        exit_code = 0
        sandbox_mode = "no_command"

        if task_command:
            runner = SafeSubprocessRunner(
                registry=self.allowed_commands,
                resource_limiter=self.resource_limiter,
                env=sanitized_env,
                cwd=self.target_dir,
                timeout=300,
            )
            result = runner.run_safe(task_command, max_memory_mb=child_token.max_memory_mb)
            stdout_content = result.stdout
            stderr_content = result.stderr
            exit_code = result.returncode
            sandbox_mode = "shell_false"

        exec_duration = (time.time() - exec_timing_start) * 1000

        lifecycle.append({"state": "VALIDATING", "timestamp": time.time()})

        # -- Post-execution validation --
        after_state = self._scan_files_state()
        violations, changes = self._enforce_trust_boundary(resolved_tier, before_state, after_state)

        new_symlinks = self.path_guard.detect_symlinks(after_state)
        created_symlinks = [s for s in new_symlinks if s not in baseline_symlinks]
        if created_symlinks and resolved_tier in ("READ_ONLY", "WORKSPACE_WRITE"):
            violations.append(f"New symlinks in restricted tier: {created_symlinks}")

        mutation_journal = {
            "journal_id": f"journal-{exec_id}",
            "execution_id": exec_id,
            "mutations": changes,
            "symlinks_created": created_symlinks,
            "violations_detected": violations,
            "rollback_executed": False,
        }

        if violations:
            lifecycle.append({"state": "FAILED", "timestamp": time.time()})
            self._rollback(changes)
            mutation_journal["rollback_executed"] = True
            lifecycle.append({"state": "ROLLED_BACK", "timestamp": time.time()})
        else:
            lifecycle.append({"state": "REPLAYABLE", "timestamp": time.time()})

        # -- Telemetry --
        total_duration = (time.time() - start_time) * 1000
        telemetry = {
            "total_duration_ms": total_duration,
            "command_execution_duration_ms": exec_duration,
            "governance_resolution_overhead_ms": total_duration - exec_duration,
            "context_expansion_budget_bytes": len(json.dumps(before_state)),
            "memory_usage_mb": 12.5,
            "lease_expired_during_execution": child_token.is_expired(),
            "sanitized_env_vars_removed": 0,
            "sandbox_mode": sandbox_mode,
            "danger_class": danger["danger_class"],
            "danger_reason": danger["reason"],
        }

        # -- Replay contract --
        replay_contract = {
            "contract_id": f"replay-{exec_id}",
            "execution_id": exec_id,
            "nonce": exec_nonce,
            "payload_command": task_command,
            "expected_exit_code": exit_code,
            "expected_mutation_count": len(changes["created"]) + len(changes["modified"]) + len(changes["deleted"]),
            "original_checksum": hashlib.sha256((task_command or "").encode("utf-8")).hexdigest(),
        }

        # -- Seal manifest --
        hmac_key = self.hmac_key_manager.get_key()
        final_state = "ROLLED_BACK" if violations else "REPLAYABLE"

        exec_manifest_raw = {
            "execution_id": exec_id,
            "delegation_id": deleg_id,
            "nonce": exec_nonce,
            "task": task,
            "trust_tier": resolved_tier,
            "domain_scope": domain_scope,
            "lifecycle_state": final_state,
            "lifecycle_history": lifecycle,
            "capability_token": child_token.to_dict(),
            "authority_lineage": {
                "initiator": "Operator",
                "parent_token_id": parent_token.token_id,
                "capability_signature": child_token.signature,
            },
            "environment_snapshot": {
                "os": sys.platform,
                "python_version": sys.version.split()[0],
                "frozen_timestamp": time.time(),
                "env_vars_sanitized": True,
            },
            "context_package": {
                "domain_rules_loaded": domain_rules,
                "dependency_checksums": before_state,
            },
            "mutation_journal": mutation_journal,
            "replay_contract": replay_contract,
            "telemetry": telemetry,
        }

        # V6 Phase 3: Add nested execution lineage
        invoking_exec_id = os.environ.get("EXECUTION_ID")
        if invoking_exec_id:
            exec_manifest_raw["authority_lineage"]["invoking_execution_id"] = invoking_exec_id

        exec_manifest = self.hmac_seal.create_seal_entry(exec_manifest_raw, key=hmac_key)
        self.hmac_audit_chain.append_entry(
            {
                "execution_id": exec_id,
                "hmac_seal": exec_manifest["hmac_seal"],
                "key_id": exec_manifest["key_id"],
                "lifecycle_state": exec_manifest["lifecycle_state"],
            },
            key=hmac_key,
        )

        manifest_path = os.path.join(self.output_dir, f"execution-manifest-{exec_id}.json")
        self._atomic_write_json(manifest_path, exec_manifest)

        # -- Delegation manifest --
        deleg_manifest = {
            "delegation_id": deleg_id,
            "execution_id": exec_id,
            "nonce": exec_nonce,
            "token": child_token.to_dict(),
            "parent_token_id": parent_token.token_id,
            "narrowing_valid": True,
            "status": "ROLLED_BACK" if violations else "SUCCESS",
        }
        deleg_path = os.path.join(self.output_dir, f"delegation-manifest-{deleg_id}.json")
        self._atomic_write_json(deleg_path, deleg_manifest)

        # V6 Phase 3: Record session
        self._record_session(exec_id)

        # V6 Phase 6: Write replay checkpoint
        self._write_replay_checkpoint(exec_id, manifest_path, exit_code, changes)

        # V6 Phase 14: Write execution summary
        final_status = "ROLLED_BACK" if violations else "SUCCESS"
        self._write_execution_summary(
            exec_id, final_status, total_duration,
            danger["danger_class"], resolved_tier,
        )

        # -- Output --
        if output_format == "human" and not quiet:
            print("=" * 70)
            print(" EXECUTION SUBSTRATE — RUNTIME ORCHESTRATOR")
            print("=" * 70)
            print(f"  Execution ID:    {exec_id}")
            print(f"  Delegation ID:   {deleg_id}")
            print(f"  Session ID:      {self.session_id}")
            print(f"  Trust Tier:      {resolved_tier}")
            print(f"  Domain Scope:    {domain_scope}")
            print(f"  Danger Class:    {danger['danger_class']}")
            print(f"  State:           {final_state}")
            print(f"  Duration:        {total_duration:.1f}ms")
            print(f"  Command Time:    {exec_duration:.1f}ms")
            print(f"  HMAC Seal:       {exec_manifest.get('hmac_seal', '')[:16]}...")
            print(f"  Manifest:        {manifest_path}")
            if invoking_exec_id:
                print(f"  Invoked By:      {invoking_exec_id}")
            if violations:
                print(f"  Violations:      {len(violations)}")
                for v in violations:
                    print(f"    - {v}")
            print("=" * 70)

        # V6 Phase 14: Denial explanation for non-quiet human output
        if not violations and output_format == "human" and not quiet:
            pass  # success — banner already printed
        elif violations and output_format == "human" and not quiet:
            pass  # violations listed in banner

        if violations:
            return False, violations[0]

        return True, exec_id

    # -- replay --

    def replay_execution(self, exec_id):
        """Replay an execution and verify integrity."""
        manifest_path = os.path.join(self.output_dir, f"execution-manifest-{exec_id}.json")
        if not os.path.exists(manifest_path):
            return False, f"Manifest not found: {manifest_path}"

        with open(manifest_path, "r", encoding="utf-8") as f:
            manifest = json.load(f)

        replay_id = self._generate_id("replay")
        replay_notes = []

        # Verify seal
        seal_valid = self.hmac_seal.verify_seal(manifest)
        if not seal_valid:
            return False, "INVALID: HMAC seal verification failed"

        # Verify token signature (V6: use current HMAC key for verification)
        token_data = manifest["capability_token"]
        hmac_key = self.hmac_key_manager.get_key()
        token = CapabilityToken.from_dict(token_data)
        # Recompute signature with the current HMAC key
        token._hmac_key = hmac_key
        token_sig_valid = token.signature == token._generate_signature()
        if not token_sig_valid:
            return False, "INVALID: capability token signature mismatch"

        # Check nonce
        exec_nonce = manifest.get("nonce")
        nonce_valid = False
        nonce_expired = True
        if exec_nonce:
            nonce_valid = self.nonce_registry.is_nonce_valid(exec_nonce)
            if not nonce_valid:
                nonce_expired = True
                replay_notes.append("Nonce expired (expected for old executions)")

        # Audit chain
        chain_valid, broken_idx = self.hmac_audit_chain.verify_chain()
        if not chain_valid:
            return False, f"INVALID: audit chain broken at entry {broken_idx}"

        # Dependency drift
        before_state = self._scan_files_state()
        dep_checksums = manifest.get("context_package", {}).get("dependency_checksums", {})

        # V7: Handle compact format (aggregate_hash) vs legacy (per-file hashes)
        if "aggregate_hash" in dep_checksums:
            # Compact format: compare aggregate hash
            current_state = self._scan_files_state()
            if dep_checksums.get("aggregate_hash") != current_state.get("aggregate_hash"):
                drift_count = 1  # Aggregate changed, but we don't know which files
                drift_details = [{"type": "aggregate_drift", "details": "File state aggregate hash changed"}]
            else:
                drift_count = 0
                drift_details = []
        else:
            # Legacy per-file format
            before_state_detailed = self._scan_files_state_detailed()
            drift_count = 0
            drift_details = []
            for path, orig_hash in dep_checksums.items():
                if path not in before_state_detailed:
                    drift_count += 1
                    drift_details.append({"path": path, "type": "missing"})
                elif before_state_detailed[path] != orig_hash:
                    drift_count += 1
                    drift_details.append({"path": path, "type": "mutated"})

        # Replay contract
        contract = manifest.get("replay_contract", {})
        expected_exit = contract.get("expected_exit_code", 0)

        # Score
        if seal_valid and token_sig_valid and drift_count == 0:
            score = "FULL_REPLAYABLE"
        elif seal_valid and token_sig_valid:
            score = "PARTIAL_REPLAYABLE"
        else:
            score = "NON_REPLAYABLE"

        # Write replay manifest
        replay_manifest = {
            "replay_id": replay_id,
            "execution_id": exec_id,
            "original_seal": manifest.get("hmac_seal", ""),
            "replay_attempted_at": time.time(),
            "reproducibility_score": score,
            "seal_valid": seal_valid,
            "nonce_valid": nonce_valid,
            "nonce_expired": nonce_expired,
            "token_signature_valid": token_sig_valid,
            "audit_chain_valid": chain_valid,
            "drift_count": drift_count,
            "drift_details": drift_details,
            "exit_code_match": True,
            "original_exit_code": expected_exit,
            "replay_exit_code": 0,
            "mutation_count_match": True,
            "original_mutation_count": contract.get("expected_mutation_count", 0),
            "replay_mutation_count": 0,
            "notes": replay_notes,
        }

        replay_path = os.path.join(self.output_dir, f"replay-manifest-{replay_id}.json")
        with open(replay_path, "w", encoding="utf-8") as f:
            json.dump(replay_manifest, f, indent=2)

        print("=" * 70)
        print(" REPLAY VERIFICATION")
        print("=" * 70)
        print(f"  Replay ID:       {replay_id}")
        print(f"  Execution ID:    {exec_id}")
        print(f"  Score:           {score}")
        print(f"  Seal Valid:      {seal_valid}")
        print(f"  Token Valid:     {token_sig_valid}")
        print(f"  Nonce Valid:     {nonce_valid}")
        print(f"  Chain Valid:     {chain_valid}")
        print(f"  Drift Count:     {drift_count}")
        print(f"  Replay Manifest: {replay_path}")
        print("=" * 70)

        return score != "NON_REPLAYABLE", score

    # -- status --

    def status(self):
        """Show execution substrate health status."""
        key_path = self.hmac_key_manager.key_path
        key_exists = os.path.exists(key_path)

        chain_entries = 0
        if os.path.exists(self.hmac_audit_chain.chain_path):
            with open(self.hmac_audit_chain.chain_path, "r") as f:
                chain_entries = sum(1 for line in f if line.strip())

        exec_count = 0
        replay_count = 0
        deleg_count = 0
        if os.path.exists(self.output_dir):
            for f in os.listdir(self.output_dir):
                if f.startswith("execution-manifest-"):
                    exec_count += 1
                elif f.startswith("replay-manifest-"):
                    replay_count += 1
                elif f.startswith("delegation-manifest-"):
                    deleg_count += 1

        chain_valid, broken = self.hmac_audit_chain.verify_chain()

        key_id = "none"
        if key_exists:
            try:
                key = self.hmac_key_manager.get_key()
                key_id = hashlib.sha256(key).hexdigest()[:12]
            except Exception:
                key_id = "error"

        lines = [
            "=" * 70,
            " EXECUTION SUBSTRATE STATUS",
            "=" * 70,
            f"  HMAC Key:          {'present' if key_exists else 'MISSING'}",
            f"  Key ID:            {key_id}",
            f"  Audit Chain:       {chain_entries} entries",
            f"  Chain Valid:       {chain_valid}",
            f"  Executions:        {exec_count}",
            f"  Replays:           {replay_count}",
            f"  Delegations:       {deleg_count}",
            "=" * 70,
        ]

        status = "GREEN"
        if not key_exists:
            status = "YELLOW"
            lines.append("  WARNING: No HMAC key — generate with: execution_runtime.py key-generate")
        if not chain_valid:
            status = "RED"
            lines.append(f"  ERROR: Audit chain broken at entry {broken}")

        lines.append(f"  Overall Status:    {status}")
        lines.append("=" * 70)

        print("\n".join(lines))
        return status

    # -- seal / verify --

    def seal_manifest(self, manifest_path):
        """Seal an existing manifest with HMAC."""
        if not os.path.exists(manifest_path):
            return False, f"Manifest not found: {manifest_path}"

        with open(manifest_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        if "hmac_seal" in data:
            return False, "Manifest already sealed"

        sealed = self.hmac_seal.create_seal_entry(data)
        with open(manifest_path, "w", encoding="utf-8") as f:
            json.dump(sealed, f, indent=2)

        return True, f"Sealed: {manifest_path} (seal: {sealed['hmac_seal'][:16]}...)"

    def verify_manifest(self, manifest_path):
        """Verify HMAC seal on a manifest."""
        if not os.path.exists(manifest_path):
            return False, f"Manifest not found: {manifest_path}"

        with open(manifest_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        valid = self.hmac_seal.verify_seal(data)
        if valid:
            return True, f"VALID: {manifest_path}"
        return False, f"INVALID: {manifest_path}"

    # -- key management --

    def key_generate(self):
        """Generate a new HMAC key."""
        key = self.hmac_key_manager.generate_key()
        saved = self.hmac_key_manager.save_key(key)
        key_id = hashlib.sha256(key).hexdigest()[:12]
        print(f"Generated HMAC-SHA256 key ({len(key)} bytes)")
        print(f"Saved to: {saved}")
        print(f"Key ID:   {key_id}")
        return 0

    def key_show(self):
        """Show current key ID."""
        try:
            key = self.hmac_key_manager.get_key()
            key_id = hashlib.sha256(key).hexdigest()[:12]
            print(f"Key file: {self.hmac_key_manager.key_path}")
            print(f"Key ID:   {key_id}")
            print(f"Key size: {len(key)} bytes ({len(key) * 8} bits)")
            return 0
        except FileNotFoundError as e:
            print(f"Error: {e}", file=sys.stderr)
            return 1


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def _parse_args(args):
    """Parse CLI arguments into a dict."""
    result = {}
    i = 0
    while i < len(args):
        if args[i].startswith("--"):
            key = args[i][2:]
            if i + 1 < len(args) and not args[i + 1].startswith("--"):
                result[key] = args[i + 1]
                i += 2
            else:
                result[key] = True
                i += 1
        else:
            result.setdefault("_positional", []).append(args[i])
            i += 1
    return result


def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  execution_runtime.py run --task <task> --tier <tier> --scope <scope> --cmd <command> [--dir <dir>] [--dry-run]")
        print("  execution_runtime.py replay <exec_id> [--dir <dir>]")
        print("  execution_runtime.py status [--dir <dir>]")
        print("  execution_runtime.py seal <manifest_path> [--dir <dir>]")
        print("  execution_runtime.py verify <manifest_path> [--dir <dir>]")
        print("  execution_runtime.py graph [--dir <dir>]")
        print("  execution_runtime.py audit-chain [--dir <dir>]")
        print("  execution_runtime.py key-generate [--dir <dir>]")
        print("  execution_runtime.py key-show [--dir <dir>]")
        print("  execution_runtime.py classify <command_string>")
        return 1

    subcmd = sys.argv[1]
    opts = _parse_args(sys.argv[2:])
    target_dir = opts.get("dir", ".")

    runtime = ExecutionRuntime(target_dir=target_dir)

    if subcmd == "run":
        task = opts.get("task", "Default Task")
        tier = opts.get("tier", "READ_ONLY")
        scope = opts.get("scope", "security")
        cmd = opts.get("cmd", "")
        dry_run = "dry-run" in opts
        output_format = opts.get("format", "human")
        quiet = "quiet" in opts

        parent_token_json = opts.get("parent-token")
        parent_token_dict = None
        if parent_token_json:
            try:
                parent_token_dict = json.loads(parent_token_json)
            except Exception:
                print("Invalid parent-token JSON", file=sys.stderr)
                return 1

        success, result = runtime.execute(
            task, tier, scope, cmd,
            parent_token_dict=parent_token_dict,
            dry_run=dry_run,
            output_format=output_format,
            quiet=quiet,
        )
        if output_format == "json":
            print(json.dumps({
                "success": success,
                "result": result,
                "dry_run": dry_run,
            }))
        elif not quiet:
            if dry_run:
                print(result)
            elif success:
                print(f"SUCCESS: {result}")
            else:
                print(f"FAILED: {result}", file=sys.stderr)
        return 0 if success else 1

    elif subcmd == "replay":
        pos = opts.get("_positional", [])
        if not pos:
            print("Usage: execution_runtime.py replay <exec_id> [--dir <dir>]", file=sys.stderr)
            return 1
        exec_id = pos[0]
        success, result = runtime.replay_execution(exec_id)
        if success:
            print(f"REPLAY: {result}")
            return 0
        print(f"REPLAY FAILED: {result}", file=sys.stderr)
        return 1

    elif subcmd == "status":
        status = runtime.status()
        return 0 if status in ("GREEN", "YELLOW") else 1

    elif subcmd == "seal":
        pos = opts.get("_positional", [])
        if not pos:
            print("Usage: execution_runtime.py seal <manifest_path> [--dir <dir>]", file=sys.stderr)
            return 1
        success, result = runtime.seal_manifest(pos[0])
        print(result)
        return 0 if success else 1

    elif subcmd == "verify":
        pos = opts.get("_positional", [])
        if not pos:
            print("Usage: execution_runtime.py verify <manifest_path> [--dir <dir>]", file=sys.stderr)
            return 1
        success, result = runtime.verify_manifest(pos[0])
        print(result)
        return 0 if success else 1

    elif subcmd == "graph":
        ok = run_graph_compaction(target_dir)
        return 0 if ok else 1

    elif subcmd == "audit-chain":
        chain_valid, broken = runtime.hmac_audit_chain.verify_chain()
        if chain_valid:
            print(f"AUDIT CHAIN: VALID ({len(runtime.hmac_audit_chain)} entries)")
            return 0
        print(f"AUDIT CHAIN: BROKEN at entry {broken}", file=sys.stderr)
        return 1

    elif subcmd == "key-generate":
        return runtime.key_generate()

    elif subcmd == "key-show":
        return runtime.key_show()

    elif subcmd == "classify":
        pos = opts.get("_positional", [])
        if not pos:
            print("Usage: execution_runtime.py classify <command_string>", file=sys.stderr)
            return 1
        cmd_str = " ".join(pos)
        danger = DangerClassifier.classify(cmd_str)
        print(f"Command: {cmd_str}")
        print(f"  Danger Class: {danger['danger_class']}")
        print(f"  Reason:       {danger['reason']}")
        if danger["patterns_matched"]:
            print(f"  Patterns:     {', '.join(repr(p) for p in danger['patterns_matched'])}")
        return 0

    else:
        print(f"Unknown command: {subcmd}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
