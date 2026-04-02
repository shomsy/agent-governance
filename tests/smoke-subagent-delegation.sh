#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMPDIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMPDIR"
}

trap cleanup EXIT

"$ROOT/install-os.sh" "$TMPDIR" --platform=opencode,cline >/dev/null

test -f "$TMPDIR/opencode.json"
test -f "$TMPDIR/.opencode/agents/harness-explore.md"
test -f "$TMPDIR/.opencode/agents/harness-review.md"
test -f "$TMPDIR/.clinerules/00-agent-harness.md"
test -f "$TMPDIR/.clinerules/10-subagents.md"
test -f "$TMPDIR/.clineignore"

"$TMPDIR/.agents/hooks/session-start.sh" --session-id delegate-session >/dev/null
"$TMPDIR/.agents/hooks/pre-task.sh" \
    --session-id delegate-session \
    --task-id broad-task \
    --prompt "Map auth, database, and deployment flow for this repository" \
    >/dev/null

python3 - <<'PY' "$TMPDIR"
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
task_dir = root / ".agent/sessions/delegate-session/tasks/broad-task"
context = json.loads((task_dir / "context.json").read_text(encoding="utf-8"))
manifest = json.loads((task_dir / "subagents/manifest.json").read_text(encoding="utf-8"))

assert context["delegation"]["recommended"] is True
assert context["delegation"]["mode"] in {"research", "parallel-build"}
assert len(context["delegation"]["subagents"]) >= 2
assert len(manifest["subagents"]) >= 2
assert any(client in context["delegation"]["preferred_clients"] for client in ("cline", "opencode"))
PY

test -f "$TMPDIR/.agent/sessions/delegate-session/tasks/broad-task/subagents/manifest.json"
find "$TMPDIR/.agent/sessions/delegate-session/tasks/broad-task/subagents" -name '*.md' | grep -q .

echo "smoke-subagent-delegation: ok"
