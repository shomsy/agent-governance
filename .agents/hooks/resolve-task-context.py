#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sys
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any


SCHEMA_VERSION = "1.0.0"


def iso_timestamp() -> str:
    return datetime.now().astimezone().isoformat(timespec="seconds")


def sha12(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()[:12]


def unique(items: list[str]) -> list[str]:
    seen: set[str] = set()
    ordered: list[str] = []
    for item in items:
        if not item or item in seen:
            continue
        seen.add(item)
        ordered.append(item)
    return ordered


def rules_root(project_root: Path) -> Path:
    mounted = project_root / ".agents" / ".rules"
    if mounted.is_dir():
        return mounted
    return project_root / ".agents"


def read_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except FileNotFoundError:
        return ""


def clean_scalar(raw: str | None) -> str | None:
    if raw is None:
        return None
    value = raw.strip()
    if not value:
        return None
    value = value.strip("`")
    if value in {"[replace]", "[declare explicitly]"}:
        return None
    if value.startswith("__") and value.endswith("__"):
        return None
    if value.lower() in {"none", "n/a"}:
        return None
    return value


def parse_list_field(raw: str | None) -> list[str]:
    value = clean_scalar(raw)
    if value is None:
        return []
    parts = [part.strip() for part in re.split(r",\s*", value) if part.strip()]
    normalized: list[str] = []
    for part in parts:
        item = part.strip("`")
        if item in {"[replace]", "[declare explicitly]"}:
            continue
        if item.startswith("__") and item.endswith("__"):
            continue
        if item.endswith(".md"):
            normalized.append(Path(item).stem)
        else:
            normalized.append(item)
    return unique(normalized)


FIELD_PATTERNS = {
    "validation_entrypoint": r"Canonical Validation Entrypoint",
    "dev_entrypoint": r"Canonical Local Development Entrypoint",
    "release_entrypoint": r"Canonical Release or Publish Entrypoint",
    "delivery_kind": r"Delivery Kind",
    "repository_profiles": r"Applied Repository Profiles",
    "languages": r"Languages",
    "frameworks": r"Frameworks Or Runtimes",
    "coding_profiles": r"Applied Coding Profiles",
    "architecture_profiles": r"Applied Architecture Profiles",
    "security_lanes": r"Security Lanes Required",
    "operations_lanes": r"Operations Lanes Required",
}


def extract_field(text: str, label_pattern: str) -> str | None:
    pattern = re.compile(
        rf"^\s*(?:[-*]|\d+\.)?\s*\*\*{label_pattern}\*\*:\s*(.+?)\s*$",
        re.IGNORECASE | re.MULTILINE,
    )
    match = pattern.search(text)
    if not match:
        return None
    return match.group(1).strip()


@dataclass
class StackState:
    delivery_kind: str | None
    repository_profiles: list[str]
    languages: list[str]
    frameworks: list[str]
    coding_profiles: list[str]
    architecture_profiles: list[str]
    security_lanes: list[str]
    operations_lanes: list[str]
    validation_entrypoint: str | None
    dev_entrypoint: str | None
    release_entrypoint: str | None


def parse_agents_stack(root_agents: Path) -> StackState:
    text = read_text(root_agents)
    raw: dict[str, str | None] = {
        key: extract_field(text, pattern) for key, pattern in FIELD_PATTERNS.items()
    }
    return StackState(
        delivery_kind=clean_scalar(raw["delivery_kind"]),
        repository_profiles=parse_list_field(raw["repository_profiles"]),
        languages=parse_list_field(raw["languages"]),
        frameworks=parse_list_field(raw["frameworks"]),
        coding_profiles=parse_list_field(raw["coding_profiles"]),
        architecture_profiles=parse_list_field(raw["architecture_profiles"]),
        security_lanes=parse_list_field(raw["security_lanes"]),
        operations_lanes=parse_list_field(raw["operations_lanes"]),
        validation_entrypoint=clean_scalar(raw["validation_entrypoint"]),
        dev_entrypoint=clean_scalar(raw["dev_entrypoint"]),
        release_entrypoint=clean_scalar(raw["release_entrypoint"]),
    )


def load_json(path: Path) -> dict[str, Any]:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return {}


def gather_repo_signals(project_root: Path, reusable_rules_root: Path) -> dict[str, Any]:
    signals: dict[str, Any] = {
        "languages": [],
        "frameworks": [],
        "repository_profiles": [],
        "architecture_profiles": [],
        "system_kind": None,
    }

    if (
        (project_root / ".agents" / "governance").is_dir()
        and (project_root / "scaffolds").is_dir()
        and (project_root / "install-os.sh").is_file()
    ):
        signals["repository_profiles"].append("governance-source")

    package_json = project_root / "package.json"
    if package_json.is_file():
        package_data = load_json(package_json)
        deps = {
            **package_data.get("dependencies", {}),
            **package_data.get("devDependencies", {}),
            **package_data.get("peerDependencies", {}),
        }
        if (project_root / "tsconfig.json").is_file() or any(project_root.rglob("*.ts")) or any(project_root.rglob("*.tsx")):
            signals["languages"].append("typescript")
        else:
            signals["languages"].append("javascript")
        signals["languages"].append("nodejs")
        if "react" in deps:
            signals["frameworks"].append("react")
        if "next" in deps:
            signals["frameworks"].append("nextjs")
        if "express" in deps:
            signals["frameworks"].append("express")
        if signals["system_kind"] is None:
            signals["system_kind"] = "web app" if "react" in deps or "next" in deps else "service"

    composer_json = project_root / "composer.json"
    if composer_json.is_file():
        composer_data = load_json(composer_json)
        deps = {
            **composer_data.get("require", {}),
            **composer_data.get("require-dev", {}),
        }
        signals["languages"].append("php")
        if "laravel/framework" in deps or (project_root / "artisan").is_file():
            signals["frameworks"].append("laravel")
            signals["system_kind"] = signals["system_kind"] or "web app"

    if any(project_root.rglob("*.css")):
        signals["languages"].append("css")

    for language in signals["languages"]:
        if (reusable_rules_root / "governance" / "architecture" / "profiles" / "languages" / f"{language}.md").is_file():
            signals["architecture_profiles"].append(language)

    for framework in signals["frameworks"]:
        if (reusable_rules_root / "governance" / "architecture" / "profiles" / "frameworks" / f"{framework}.md").is_file():
            signals["architecture_profiles"].append(framework)

    return {
        key: unique(value) if isinstance(value, list) else value
        for key, value in signals.items()
    }


LANE_KEYWORDS: dict[str, list[tuple[str, int]]] = {
    "governance": [
        ("agents.md", 5),
        ("governance", 5),
        ("policy", 4),
        ("rule", 4),
        ("profile", 4),
        ("precedence", 4),
        ("scaffold", 4),
        ("installer", 4),
        ("adapter", 4),
        ("hook", 4),
        ("workflow", 3),
        ("pipeline", 3),
    ],
    "review": [
        ("review", 5),
        ("audit", 4),
        ("inspect", 3),
        ("find issues", 5),
        ("code review", 5),
        ("strict review", 5),
    ],
    "documentation": [
        ("documentation", 5),
        ("document", 4),
        ("readme", 4),
        ("docs", 4),
        ("explain", 3),
        ("write up", 3),
    ],
    "security": [
        ("security", 5),
        ("secret", 4),
        ("token", 4),
        ("auth", 4),
        ("permission", 4),
        ("owasp", 4),
        ("cve", 4),
        ("vulnerability", 4),
        ("threat", 4),
    ],
    "release": [
        ("release", 5),
        ("deploy", 5),
        ("publish", 4),
        ("rollback", 4),
        ("ship", 3),
        ("tag", 3),
    ],
    "operations": [
        ("incident", 5),
        ("restore", 4),
        ("recovery", 4),
        ("backup", 3),
        ("runtime", 3),
        ("observability", 4),
        ("trace", 4),
        ("diagnose", 4),
        ("outage", 5),
    ],
    "planning": [
        ("plan", 5),
        ("implementation plan", 5),
        ("roadmap", 3),
        ("break down", 4),
        ("estimate", 4),
        ("organize", 3),
    ],
    "brainstorm": [
        ("brainstorm", 5),
        ("idea", 3),
        ("option", 3),
        ("approach", 3),
        ("tradeoff", 4),
        ("design direction", 4),
    ],
    "coding": [
        ("implement", 5),
        ("build", 4),
        ("add", 3),
        ("create", 3),
        ("change", 3),
        ("update", 3),
        ("fix", 4),
        ("refactor", 4),
    ],
}


def classify_prompt(prompt: str) -> dict[str, Any]:
    lower = prompt.lower()
    scores: dict[str, int] = {lane: 0 for lane in LANE_KEYWORDS}
    for lane, patterns in LANE_KEYWORDS.items():
        for needle, weight in patterns:
            if needle in lower:
                scores[lane] += weight

    if not any(scores.values()):
        scores["coding"] = 1

    primary_lane = max(scores, key=scores.get)
    primary_score = scores[primary_lane]
    secondary_lanes = [
        lane
        for lane, score in scores.items()
        if lane != primary_lane and score > 0 and score >= max(2, primary_score - 2)
    ]

    if primary_lane == "coding":
        if any(word in lower for word in ("bug", "fix", "broken", "regression", "issue", "defect")):
            task_kind = "bugfix"
        elif any(word in lower for word in ("refactor", "cleanup", "rename", "reorganize")):
            task_kind = "refactoring"
        elif any(word in lower for word in ("investigate", "analyze", "why", "root cause")):
            task_kind = "investigation"
        else:
            task_kind = "feature"
    elif primary_lane == "governance":
        task_kind = "governance"
    elif primary_lane == "documentation":
        task_kind = "documentation"
    elif primary_lane == "review":
        task_kind = "review"
    elif primary_lane == "release":
        task_kind = "release"
    elif primary_lane == "operations":
        task_kind = "operations"
    elif primary_lane == "planning":
        task_kind = "planning"
    elif primary_lane == "brainstorm":
        task_kind = "brainstorm"
    elif primary_lane == "security":
        task_kind = "security"
    else:
        task_kind = "investigation"

    intent_mode = "change"
    if any(word in lower for word in ("review", "audit", "analyze", "explain", "da li", "what", "why", "how")):
        intent_mode = "analysis"
    if any(word in lower for word in ("implement", "create", "add", "update", "fix", "refactor", "uradi")):
        intent_mode = "execute"

    return {
        "scores": scores,
        "primary_lane": primary_lane,
        "secondary_lanes": unique(secondary_lanes),
        "task_kind": task_kind,
        "intent_mode": intent_mode,
    }


PIPELINE_BY_KIND = {
    "brainstorm": "Brainstorm Flow",
    "planning": "Planning Pipeline",
    "feature": "Standard Feature Pipeline",
    "bugfix": "Bugfix Pipeline",
    "refactoring": "Refactoring Pipeline",
    "documentation": "Documentation Pipeline",
    "review": "Review Pipeline",
    "governance": "Governance Pipeline",
    "operations": "Operations Pipeline",
    "release": "Release Pipeline",
    "investigation": "Investigation Flow",
    "security": "Security Review Flow",
}

STARTING_ROLE_BY_PIPELINE = {
    "Brainstorm Flow": "planner",
    "Planning Pipeline": "planner",
    "Standard Feature Pipeline": "planner",
    "Bugfix Pipeline": "reviewer",
    "Refactoring Pipeline": "architect",
    "Documentation Pipeline": "planner",
    "Review Pipeline": "reviewer",
    "Governance Pipeline": "planner",
    "Operations Pipeline": "reviewer",
    "Release Pipeline": "releaser",
    "Investigation Flow": "reviewer",
    "Security Review Flow": "security-reviewer",
}

ROLE_CHAIN_BY_PIPELINE = {
    "Brainstorm Flow": ["planner", "architect"],
    "Planning Pipeline": ["planner", "architect", "planner"],
    "Standard Feature Pipeline": ["planner", "architect", "tester", "implementer", "reviewer", "documenter", "releaser"],
    "Bugfix Pipeline": ["reviewer", "tester", "implementer", "reviewer"],
    "Refactoring Pipeline": ["architect", "tester", "implementer", "reviewer"],
    "Documentation Pipeline": ["planner", "documenter", "reviewer", "implementer"],
    "Review Pipeline": ["reviewer"],
    "Governance Pipeline": ["planner", "architect", "implementer", "reviewer", "documenter"],
    "Operations Pipeline": ["reviewer", "implementer", "documenter"],
    "Release Pipeline": ["releaser", "reviewer", "documenter"],
    "Investigation Flow": ["reviewer", "architect"],
    "Security Review Flow": ["security-reviewer", "reviewer"],
}


def select_pipeline_and_roles(classification: dict[str, Any]) -> tuple[str, str, list[str]]:
    task_kind = classification["task_kind"]
    pipeline = PIPELINE_BY_KIND.get(task_kind, "Standard Feature Pipeline")
    starting_role = STARTING_ROLE_BY_PIPELINE[pipeline]
    role_chain = ROLE_CHAIN_BY_PIPELINE[pipeline]
    return pipeline, starting_role, role_chain


def select_trust(primary_lane: str, task_kind: str, prompt: str) -> tuple[str, str]:
    lower = prompt.lower()
    if task_kind == "release" or primary_lane == "release":
        tier = "T3"
    elif primary_lane == "operations":
        tier = "T2"
    elif primary_lane == "security":
        tier = "T2" if any(word in lower for word in ("fix", "patch", "rotate", "remediate", "update")) else "T0"
    elif any(word in lower for word in ("dependency", "npm install", "composer require", "package update", "ci", "infrastructure")):
        tier = "T2"
    elif primary_lane in {"brainstorm", "planning", "review"}:
        tier = "T0"
    else:
        tier = "T1"

    approval_mode = {
        "T0": "Never",
        "T1": "OnDangerous",
        "T2": "OnExternal",
        "T3": "Always",
    }[tier]
    return tier, approval_mode


def add_existing(paths: list[Path], path: Path) -> None:
    if path.is_file():
        paths.append(path.resolve())


def resolve_rule_files(
    project_root: Path,
    reusable_rules_root: Path,
    stack: StackState,
    signals: dict[str, Any],
    classification: dict[str, Any],
) -> tuple[list[str], list[str]]:
    must_read: list[Path] = []
    should_read: list[Path] = []

    lane = classification["primary_lane"]
    task_kind = classification["task_kind"]
    secondary_lanes = classification["secondary_lanes"]

    add_existing(must_read, project_root / "AGENTS.md")
    add_existing(must_read, reusable_rules_root / "AGENTS.md")

    base_rule_paths = [
        "governance/core/quality/quality-gates.md",
        "governance/core/resolution/profile-resolution-algorithm.md",
        "governance/execution/policy/execution-policy.md",
        "governance/execution/routing/prompt-to-governance-flow.md",
        "governance/execution/approvals/approval-policy.md",
        "governance/core/flags/feature-flags.md",
        "governance/delivery/workflows/workflow-pipelines.md",
        "governance/agents/roles/agent-roles.md",
        "governance/intelligence/context/context-management.md",
    ]
    for relative in base_rule_paths:
        add_existing(must_read, reusable_rules_root / relative)

    lane_paths = {
        "governance": [
            "governance/standards/governance/governance-authoring-standard.md",
            "governance/standards/governance/governance-evolution-policy.md",
            "governance/standards/documentation/how-to-document.md",
        ],
        "documentation": [
            "governance/standards/documentation/how-to-document-flow.md",
            "governance/standards/documentation/how-to-document.md",
        ],
        "review": [
            "governance/standards/review/how-to-code-review.md",
            "governance/standards/review/how-to-strict-review.md",
        ],
        "coding": [
            "governance/standards/coding/how-to-coding-standards.md",
            "governance/standards/coding/naming-standard.md",
            "governance/architecture/architecture-standard.md",
        ],
        "security": [
            "governance/security/README.md",
            "governance/security/threat-modeling-and-abuse-case-policy.md",
            "governance/security/owasp-web-and-api-baseline.md",
        ],
        "release": [
            "governance/delivery/release/release-and-rollback-policy.md",
            "governance/delivery/operations/security-launch-checklist.md",
            "governance/delivery/operations/staging-smoke-checklist.md",
        ],
        "operations": [
            "governance/delivery/operations/README.md",
            "governance/delivery/operations/observability-and-error-envelope.md",
            "governance/delivery/operations/runtime-handoff-contract.md",
            "governance/delivery/operations/backup-and-restore-runbook.md",
        ],
        "planning": [
            "governance/architecture/architecture-standard.md",
            "governance/standards/documentation/how-to-document-flow.md",
        ],
        "brainstorm": [
            "governance/architecture/architecture-standard.md",
        ],
    }

    for relative in lane_paths.get(lane, []):
        add_existing(must_read, reusable_rules_root / relative)

    if task_kind in {"feature", "bugfix", "refactoring"}:
        for relative in lane_paths["coding"]:
            add_existing(must_read, reusable_rules_root / relative)

    repository_profiles = unique(stack.repository_profiles + signals["repository_profiles"])
    languages = unique(stack.languages + signals["languages"])
    frameworks = unique(stack.frameworks + signals["frameworks"])
    architecture_profiles = unique(stack.architecture_profiles + signals["architecture_profiles"])

    for profile in repository_profiles:
        add_existing(must_read, reusable_rules_root / "governance" / "profiles" / "repository-kinds" / f"{profile}.md")
    for language in languages:
        add_existing(must_read, reusable_rules_root / "governance" / "profiles" / "languages" / f"{language}.md")
    for framework in frameworks:
        add_existing(must_read, reusable_rules_root / "governance" / "profiles" / "frameworks" / f"{framework}.md")
    for profile in architecture_profiles:
        add_existing(should_read, reusable_rules_root / "governance" / "architecture" / "profiles" / "languages" / f"{profile}.md")
        add_existing(should_read, reusable_rules_root / "governance" / "architecture" / "profiles" / "frameworks" / f"{profile}.md")

    if lane in {"security", "release", "operations"} or "security" in secondary_lanes or stack.security_lanes:
        add_existing(must_read, reusable_rules_root / "governance" / "security" / "README.md")
    if lane in {"operations", "release"} or "operations" in secondary_lanes or stack.operations_lanes:
        add_existing(must_read, reusable_rules_root / "governance" / "delivery" / "operations" / "README.md")

    local_support = [
        project_root / "README.md",
        project_root / ".agents" / "README.md",
        project_root / ".agents" / "management" / "README.md",
        project_root / ".agents" / "business-logic" / "README.md",
        project_root / ".agents" / "language-specific" / "README.md",
        project_root / ".agents" / "review" / "REVIEWS.md",
    ]
    for path in local_support:
        add_existing(should_read, path)

    return unique([str(path) for path in must_read]), unique([str(path) for path in should_read if path not in must_read])


def resolve_context_sources(project_root: Path, session_id: str) -> dict[str, list[str]]:
    session_dir = project_root / ".agent" / "sessions" / session_id
    sources = {
        "memory": [],
        "session": [],
        "project": [],
        "strategy": [],
    }

    for path in [
        project_root / ".agent" / "memory" / "MEMORY.md",
        project_root / ".agents" / "management" / "memories" / "memory_summary.md",
    ]:
        if path.is_file():
            sources["memory"].append(str(path.resolve()))

    for path in [
        session_dir / "session_memory.md",
        session_dir / "transcript.json",
    ]:
        if path.is_file():
            sources["session"].append(str(path.resolve()))

    for path in [
        project_root / ".agents" / "management" / "TODO.md",
        project_root / ".agents" / "management" / "BUGS.md",
        project_root / ".agents" / "management" / "ACTIVE.md",
        project_root / ".agents" / "management" / "DECISIONS.md",
    ]:
        if path.is_file():
            sources["project"].append(str(path.resolve()))

    for directory in [
        project_root / ".agent" / "context" / "product",
        project_root / ".agent" / "context" / "strategy",
        project_root / ".agent" / "context" / "stakeholders",
        project_root / ".agent" / "context" / "users",
    ]:
        if directory.is_dir():
            for candidate in sorted(directory.glob("*.md"))[:5]:
                sources["strategy"].append(str(candidate.resolve()))

    return sources


def resolve_evidence_targets(project_root: Path, primary_lane: str, task_kind: str, trust_tier: str) -> list[str]:
    candidates: list[Path] = []

    if task_kind == "bugfix":
        candidates.append(project_root / ".agents" / "management" / "BUGS.md")
    else:
        candidates.append(project_root / ".agents" / "management" / "TODO.md")

    if primary_lane == "review":
        candidates.append(project_root / ".agents" / "review" / "REVIEWS.md")
    if primary_lane in {"documentation", "governance", "release"}:
        candidates.append(project_root / ".agents" / "management" / "evidence" / "CHANGELOG.md")
    if primary_lane in {"security", "operations", "release"}:
        candidates.append(project_root / ".agents" / "management" / "evidence" / "RISK_REGISTER.md")
    if primary_lane == "release":
        candidates.append(project_root / ".agents" / "management" / "evidence" / "RELEASE_CHECKLIST.md")
    if trust_tier in {"T2", "T3"} or primary_lane in {"governance", "security", "operations", "release"}:
        candidates.append(project_root / ".agents" / "management" / "evidence" / "TRACE_REPORTS.md")

    return unique([str(path.resolve()) for path in candidates if path.is_file()])


def build_manifest(project_root: Path, prompt: str, session_id: str, task_id: str) -> dict[str, Any]:
    reusable_rules_root = rules_root(project_root)
    stack = parse_agents_stack(project_root / "AGENTS.md")
    signals = gather_repo_signals(project_root, reusable_rules_root)
    classification = classify_prompt(prompt)
    pipeline, starting_role, role_chain = select_pipeline_and_roles(classification)
    trust_tier, approval_mode = select_trust(classification["primary_lane"], classification["task_kind"], prompt)
    must_read, should_read = resolve_rule_files(project_root, reusable_rules_root, stack, signals, classification)
    context_sources = resolve_context_sources(project_root, session_id)
    evidence_targets = resolve_evidence_targets(project_root, classification["primary_lane"], classification["task_kind"], trust_tier)

    project_identifier = sha12(str(project_root.resolve()))
    trace_id = f"trace-{sha12(project_identifier + session_id + task_id + prompt)}"
    prompt_preview = re.sub(r"\s+", " ", prompt).strip()
    prompt_preview = prompt_preview[:220] + ("..." if len(prompt_preview) > 220 else "")

    session_dir = project_root / ".agent" / "sessions" / session_id
    task_dir = session_dir / "tasks" / task_id

    return {
        "schema_version": SCHEMA_VERSION,
        "timestamp": iso_timestamp(),
        "project_root": str(project_root.resolve()),
        "project_id": project_identifier,
        "session_id": session_id,
        "task_id": task_id,
        "trace_id": trace_id,
        "prompt": {
            "hash": sha12(prompt),
            "preview": prompt_preview,
        },
        "intent": {
            "mode": classification["intent_mode"],
            "task_kind": classification["task_kind"],
            "scores": classification["scores"],
        },
        "routing": {
            "primary_lane": classification["primary_lane"],
            "secondary_lanes": classification["secondary_lanes"],
            "pipeline": pipeline,
            "starting_role": starting_role,
            "role_chain": role_chain,
            "trust_tier": trust_tier,
            "approval_mode": approval_mode,
        },
        "stack": {
            "declared": {
                "delivery_kind": stack.delivery_kind,
                "repository_profiles": stack.repository_profiles,
                "languages": stack.languages,
                "frameworks": stack.frameworks,
                "coding_profiles": stack.coding_profiles,
                "architecture_profiles": stack.architecture_profiles,
                "security_lanes": stack.security_lanes,
                "operations_lanes": stack.operations_lanes,
                "validation_entrypoint": stack.validation_entrypoint,
                "dev_entrypoint": stack.dev_entrypoint,
                "release_entrypoint": stack.release_entrypoint,
            },
            "inferred": signals,
        },
        "governance_pack": {
            "rules_root": str(reusable_rules_root.resolve()),
            "must_read": must_read,
            "should_read": should_read,
        },
        "context_injection": context_sources,
        "evidence_targets": evidence_targets,
        "artifacts": {
            "session_dir": str(session_dir.resolve()),
            "task_dir": str(task_dir.resolve()),
            "context_json": str((task_dir / "context.json").resolve()),
            "context_markdown": str((task_dir / "context.md").resolve()),
            "events_log": str((task_dir / "events.log").resolve()),
            "result_json": str((task_dir / "result.json").resolve()),
            "trace_reports": str((project_root / ".agents" / "management" / "evidence" / "TRACE_REPORTS.md").resolve()),
        },
        "events": [
            "AGENTSLoaded",
            "PromptAnalyzed",
            "IntentClassified",
            "LaneResolved",
            "StackResolved",
            "GovernancePackSelected",
            "PipelineSelected",
            "StartingRoleSelected",
            "ContextAssembled",
            "TrustResolved",
            "EvidenceTargetsResolved",
            "TaskManifestWritten",
            "TaskReady",
        ],
    }


def markdown_manifest(manifest: dict[str, Any]) -> str:
    routing = manifest["routing"]
    stack = manifest["stack"]
    lines = [
        f"# Task Routing Summary — {manifest['task_id']}",
        "",
        f"- Timestamp: `{manifest['timestamp']}`",
        f"- Trace ID: `{manifest['trace_id']}`",
        f"- Prompt Hash: `{manifest['prompt']['hash']}`",
        f"- Prompt Preview: {manifest['prompt']['preview']}",
        "",
        "## Routing",
        "",
        f"- Intent Mode: `{manifest['intent']['mode']}`",
        f"- Task Kind: `{manifest['intent']['task_kind']}`",
        f"- Primary Lane: `{routing['primary_lane']}`",
        f"- Secondary Lanes: `{', '.join(routing['secondary_lanes']) or 'none'}`",
        f"- Pipeline: `{routing['pipeline']}`",
        f"- Starting Role: `{routing['starting_role']}`",
        f"- Role Chain: `{', '.join(routing['role_chain'])}`",
        f"- Trust Tier: `{routing['trust_tier']}`",
        f"- Approval Mode: `{routing['approval_mode']}`",
        "",
        "## Stack",
        "",
        f"- Delivery Kind: `{stack['declared']['delivery_kind'] or stack['inferred'].get('system_kind') or 'unknown'}`",
        f"- Repository Profiles: `{', '.join(unique(stack['declared']['repository_profiles'] + stack['inferred']['repository_profiles'])) or 'none'}`",
        f"- Languages: `{', '.join(unique(stack['declared']['languages'] + stack['inferred']['languages'])) or 'none'}`",
        f"- Frameworks: `{', '.join(unique(stack['declared']['frameworks'] + stack['inferred']['frameworks'])) or 'none'}`",
        "",
        "## Must Read",
        "",
    ]
    lines.extend([f"- `{path}`" for path in manifest["governance_pack"]["must_read"]] or ["- none"])
    lines.extend(["", "## Should Read", ""])
    lines.extend([f"- `{path}`" for path in manifest["governance_pack"]["should_read"]] or ["- none"])
    lines.extend(["", "## Context Injection", ""])
    for section, paths in manifest["context_injection"].items():
        lines.append(f"- {section}:")
        if paths:
            lines.extend([f"  - `{path}`" for path in paths])
        else:
            lines.append("  - none")
    lines.extend(["", "## Evidence Targets", ""])
    lines.extend([f"- `{path}`" for path in manifest["evidence_targets"]] or ["- none"])
    return "\n".join(lines) + "\n"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Resolve prompt-to-governance task context.")
    parser.add_argument("--project-root", default=os.getcwd())
    parser.add_argument("--prompt")
    parser.add_argument("--prompt-file")
    parser.add_argument("--session-id", required=True)
    parser.add_argument("--task-id", required=True)
    parser.add_argument("--write-json")
    parser.add_argument("--write-markdown")
    parser.add_argument("--summary", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if not args.prompt and not args.prompt_file:
        print("resolve-task-context.py requires --prompt or --prompt-file", file=sys.stderr)
        return 2

    prompt = args.prompt or read_text(Path(args.prompt_file))
    project_root = Path(args.project_root).resolve()
    manifest = build_manifest(project_root, prompt, args.session_id, args.task_id)

    if args.write_json:
        output_path = Path(args.write_json)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=True) + "\n", encoding="utf-8")

    if args.write_markdown:
        output_path = Path(args.write_markdown)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(markdown_manifest(manifest), encoding="utf-8")

    if args.summary:
        print(
            f"{manifest['routing']['primary_lane']} | {manifest['routing']['pipeline']} | "
            f"{manifest['routing']['starting_role']} | {manifest['routing']['trust_tier']}"
        )
        return 0

    print(json.dumps(manifest, indent=2, ensure_ascii=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
