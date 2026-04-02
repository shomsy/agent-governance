#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMPDIR"
}

trap cleanup EXIT

"$ROOT/install-os.sh" "$TMPDIR" --platform=codex >/dev/null
"$TMPDIR/.agents/hooks/session-start.sh" --session-id smoke-session >/dev/null

bugfix_summary="$(python3 "$ROOT/.agents/hooks/resolve-task-context.py" \
    --project-root "$ROOT" \
    --session-id smoke-session \
    --task-id bugfix-check \
    --prompt "Fix auth bug in login flow" \
    --summary)"

if [ "$bugfix_summary" != "coding | Bugfix Pipeline | reviewer | T1" ]; then
    echo "Unexpected bugfix routing summary: $bugfix_summary" >&2
    exit 1
fi

first_output="$("$TMPDIR/.agents/hooks/pre-task.sh" --session-id smoke-session --prompt "same prompt")"
second_output="$("$TMPDIR/.agents/hooks/pre-task.sh" --session-id smoke-session --prompt "same prompt")"

first_task="$(printf '%s\n' "$first_output" | sed -n 's/.*task=\([^ ]*\).*/\1/p' | tail -n 1)"
second_task="$(printf '%s\n' "$second_output" | sed -n 's/.*task=\([^ ]*\).*/\1/p' | tail -n 1)"

if [ -z "$first_task" ] || [ -z "$second_task" ] || [ "$first_task" = "$second_task" ]; then
    echo "Task ID collision detected: first=$first_task second=$second_task" >&2
    exit 1
fi

test -f "$TMPDIR/.agent/logs/session-starts.log"
test ! -f "$TMPDIR/.agents/management/memories/session-starts.log"

"$TMPDIR/.agents/hooks/pre-task.sh" \
    --session-id smoke-session \
    --task-id route-check \
    --prompt "Implement governance flow engine for AGENTS.md prompt routing" \
    >/dev/null

python3 - <<'PY' "$TMPDIR"
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
context = json.loads(
    (root / ".agent/sessions/smoke-session/tasks/route-check/context.json").read_text(
        encoding="utf-8"
    )
)

assert context["routing"]["primary_lane"] == "governance"
assert context["routing"]["pipeline"] == "Governance Pipeline"
assert context["routing"]["starting_role"] == "planner"
assert context["routing"]["trust_tier"] == "T1"
assert any(
    "prompt-to-governance-flow.md" in path
    for path in context["governance_pack"]["must_read"]
)
PY

"$TMPDIR/.agents/hooks/pre-tool-use.sh" bash "git status" >/dev/null
if "$TMPDIR/.agents/hooks/pre-tool-use.sh" bash "curl https://example.com" >/dev/null 2>&1; then
    echo "Network command should have been blocked for smoke-session route-check" >&2
    exit 1
fi

"$TMPDIR/.agents/hooks/post-tool-use.sh" bash "git status" "clean" >/dev/null
"$TMPDIR/.agents/hooks/post-task.sh" \
    --session-id smoke-session \
    --task-id route-check \
    --status completed \
    --summary validated \
    >/dev/null

test -f "$TMPDIR/.agent/sessions/smoke-session/tasks/route-check/result.json"
rg -q 'outcome=routed' "$TMPDIR/.agents/management/evidence/TRACE_REPORTS.md"
rg -q 'outcome=completed' "$TMPDIR/.agents/management/evidence/TRACE_REPORTS.md"

echo "smoke-routing-hooks: ok"
