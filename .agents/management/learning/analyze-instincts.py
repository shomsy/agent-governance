#!/usr/bin/env python3
"""Analyze observations.jsonl and emit instinct markdown files."""

from __future__ import annotations

import argparse
import json
import os
import re
from collections import defaultdict
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable


SHELL_TOOLS = {
    "bash",
    "shell",
    "command",
    "exec_command",
}


@dataclass
class Pattern:
    instinct_id: str
    trigger: str
    action: str
    domain: str
    evidence: list[tuple[str, str, str]] = field(default_factory=list)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project-root", default=".", help="Repository root")
    parser.add_argument(
        "--observations",
        default=None,
        help="Optional path to observations.jsonl",
    )
    parser.add_argument(
        "--instincts-dir",
        default=None,
        help="Optional path to instincts directory",
    )
    parser.add_argument(
        "--min-occurrences",
        type=int,
        default=3,
        help="Minimum number of matching observations required",
    )
    parser.add_argument(
        "--max-evidence",
        type=int,
        default=5,
        help="Maximum evidence lines to store in each instinct",
    )
    return parser.parse_args()


def slugify(value: str) -> str:
    slug = re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")
    return slug or "pattern"


def confidence_for(occurrences: int) -> float:
    if occurrences >= 11:
        return 0.85
    if occurrences >= 6:
        return 0.7
    if occurrences >= 3:
        return 0.5
    return 0.3


def domain_for(prefix: str) -> str:
    if prefix.startswith("git"):
        return "git"
    if any(token in prefix for token in ("test", "lint", "pytest", "jest", "vitest")):
        return "testing"
    if any(token in prefix for token in ("audit", "security", "openssl", "trivy")):
        return "security"
    if any(token in prefix for token in ("readme", "docs", "markdown")):
        return "documentation"
    return "workflow"


def build_pattern(prefix: str) -> Pattern:
    instinct_id = f"use-{slugify(prefix)}"
    domain = domain_for(prefix)
    trigger = f"When a similar {domain} task appears in this project"
    action = (
        f"Prefer `{prefix}` as the repeated command pattern unless a more specific "
        "tool is required"
    )
    return Pattern(
        instinct_id=instinct_id,
        trigger=trigger,
        action=action,
        domain=domain,
    )


def extract_prefix(tool_name: str, input_summary: str) -> str | None:
    tool_key = tool_name.strip().lower()
    summary = input_summary.strip()

    if not summary:
        return None

    if tool_key in SHELL_TOOLS:
        tokens = summary.split()
        if not tokens:
            return None
        if tokens[0] in {"git", "npm", "pnpm", "yarn"} and len(tokens) >= 2:
            return " ".join(tokens[:2])
        return tokens[0]

    if tool_key in {"fileread", "open"}:
        return "file-read"
    if tool_key in {"filewrite", "apply_patch"}:
        return "file-write"

    return tool_key or None


def parse_existing_instinct(path: Path) -> dict[str, str]:
    if not path.exists():
        return {}

    content = path.read_text(encoding="utf-8")
    if not content.startswith("---\n"):
        return {}

    lines = content.splitlines()
    metadata: dict[str, str] = {}
    for line in lines[1:]:
        if line == "---":
            break
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        metadata[key.strip()] = value.strip()
    return metadata


def flag_default(flag_name: str) -> bool:
    defaults = {
        "continuous_learning": True,
        "instincts_enabled": True,
    }
    return defaults.get(flag_name, False)


def flag_is_enabled(project_root: Path, flag_name: str) -> bool:
    env_name = f"AGENT_HARNESS_FLAG_{flag_name.upper()}"
    env_value = os.environ.get(env_name)
    if env_value is not None:
        return env_value.strip().lower() in {"1", "true", "on", "yes"}

    agents_file = project_root / "AGENTS.md"
    if not agents_file.exists():
        return flag_default(flag_name)

    line_match = None
    for raw_line in agents_file.read_text(encoding="utf-8").splitlines():
        if not raw_line.lstrip().startswith("|"):
            continue
        parts = [part.strip().replace("`", "") for part in raw_line.split("|")]
        if len(parts) < 3:
            continue
        if parts[1] == flag_name:
            line_match = parts
    if line_match and len(line_match) >= 3:
        return line_match[2].upper() == "ON"

    return flag_default(flag_name)


def iter_observations(path: Path) -> Iterable[dict[str, str]]:
    if not path.exists():
        return []

    records: list[dict[str, str]] = []
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        raw_line = raw_line.strip()
        if not raw_line:
            continue
        try:
            parsed = json.loads(raw_line)
        except json.JSONDecodeError:
            continue
        records.append(parsed)
    return records


def main() -> int:
    args = parse_args()
    project_root = Path(args.project_root).resolve()

    if not flag_is_enabled(project_root, "continuous_learning"):
        print("analyze-instincts: continuous_learning is disabled")
        return 0

    if not flag_is_enabled(project_root, "instincts_enabled"):
        print("analyze-instincts: instincts_enabled is disabled")
        return 0

    observations_path = (
        Path(args.observations).resolve()
        if args.observations
        else project_root / ".agents" / "management" / "learning" / "observations.jsonl"
    )
    instincts_dir = (
        Path(args.instincts_dir).resolve()
        if args.instincts_dir
        else project_root / ".agents" / "management" / "learning" / "instincts"
    )

    instincts_dir.mkdir(parents=True, exist_ok=True)

    groups: dict[str, Pattern] = {}
    occurrences: defaultdict[str, int] = defaultdict(int)
    first_seen: dict[str, str] = {}
    last_seen: dict[str, str] = {}

    for observation in iter_observations(observations_path):
        tool = str(observation.get("tool", "")).strip()
        input_summary = str(observation.get("input_summary", "")).strip()
        prefix = extract_prefix(tool, input_summary)
        if not prefix:
            continue

        pattern = groups.setdefault(prefix, build_pattern(prefix))
        occurrences[prefix] += 1
        timestamp = str(observation.get("ts", "")).strip()
        output_summary = str(observation.get("output_summary", "")).strip()

        if prefix not in first_seen:
            first_seen[prefix] = timestamp
        last_seen[prefix] = timestamp

        if len(pattern.evidence) < args.max_evidence:
            pattern.evidence.append((timestamp, input_summary, output_summary))

    written = 0
    for prefix, count in sorted(occurrences.items()):
        if count < args.min_occurrences:
            continue

        pattern = groups[prefix]
        instinct_path = instincts_dir / f"{pattern.instinct_id}.md"
        existing = parse_existing_instinct(instinct_path)
        if existing.get("promoted", "").lower() == "true":
            continue

        instinct_path.write_text(
            render_instinct(
                pattern=pattern,
                occurrences=count,
                confidence=confidence_for(count),
                first_seen=existing.get("first_seen", first_seen[prefix]),
                last_seen=last_seen[prefix],
                promoted=existing.get("promoted", "false").lower() == "true",
                contradictions=existing.get("contradicts", "[]"),
            ),
            encoding="utf-8",
        )
        written += 1

    print(
        f"analyze-instincts: wrote {written} instinct file(s) from {sum(occurrences.values())} matching observation(s)"
    )
    return 0


def render_instinct(
    *,
    pattern: Pattern,
    occurrences: int,
    confidence: float,
    first_seen: str,
    last_seen: str,
    promoted: bool,
    contradictions: str,
) -> str:
    evidence_lines = []
    for ts, input_summary, output_summary in pattern.evidence:
        if output_summary:
            evidence_lines.append(f"- {ts}: `{input_summary}` -> {output_summary}")
        else:
            evidence_lines.append(f"- {ts}: `{input_summary}`")

    evidence_block = "\n".join(evidence_lines) if evidence_lines else "- No evidence recorded"

    return f"""---
id: {pattern.instinct_id}
trigger: "{pattern.trigger}"
action: "{pattern.action}"
confidence: {confidence}
domain: {pattern.domain}
scope: project
occurrences: {occurrences}
first_seen: {first_seen}
last_seen: {last_seen}
promoted: {str(promoted).lower()}
contradicts: {contradictions}
---

## Evidence

{evidence_block}

## Rationale

This instinct was generated from repeated observation patterns in
`observations.jsonl`. Review it before treating it as a promoted rule.
"""


if __name__ == "__main__":
    raise SystemExit(main())
