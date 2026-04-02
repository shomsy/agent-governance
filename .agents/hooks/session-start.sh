#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib.sh
source "$SCRIPT_DIR/lib.sh"

PROJECT_ROOT="$(resolve_project_root)"
CURRENT_SESSION_ID="$(session_id)"
CREATED_AT="$(iso_timestamp)"

while [ "$#" -gt 0 ]; do
    case "$1" in
        --project-root=*)
            PROJECT_ROOT="${1#*=}"
            shift
            ;;
        --session-id=*)
            CURRENT_SESSION_ID="${1#*=}"
            SESSION_DIR="$(repo_agent_runtime_dir "$PROJECT_ROOT")/sessions/$CURRENT_SESSION_ID"
            shift
            ;;
        *)
            shift
            ;;
    esac
done

CURRENT_PROJECT_ID="$(project_id "$PROJECT_ROOT")"
SESSION_DIR="$(repo_agent_runtime_dir "$PROJECT_ROOT")/sessions/$CURRENT_SESSION_ID"

ensure_learning_layout "$PROJECT_ROOT"
ensure_memory_layout "$PROJECT_ROOT"
ensure_session_layout "$PROJECT_ROOT" "$CURRENT_SESSION_ID"
mkdir -p "$SESSION_DIR"

cat > "$SESSION_DIR/context-budget.json" <<EOF
{
  "created_at": "$CREATED_AT",
  "session_id": "$CURRENT_SESSION_ID",
  "project_id": "$CURRENT_PROJECT_ID",
  "budgets": {
    "governance_pct": 10,
    "skills_pct": 15,
    "memory_pct": 10,
    "working_pct": 65
  }
}
EOF

cat > "$SESSION_DIR/session.env" <<EOF
AGENT_HARNESS_SESSION_ID=$CURRENT_SESSION_ID
AGENT_HARNESS_PROJECT_ID=$CURRENT_PROJECT_ID
AGENT_HARNESS_PROJECT_ROOT=$PROJECT_ROOT
EOF

if [ ! -s "$SESSION_DIR/session_memory.md" ]; then
    cat > "$SESSION_DIR/session_memory.md" <<EOF
# Session Memory

- Session ID: $CURRENT_SESSION_ID
- Project ID: $CURRENT_PROJECT_ID
- Started At: $CREATED_AT
EOF
fi

printf 'session-start: session_id=%s project_id=%s\n' "$CURRENT_SESSION_ID" "$CURRENT_PROJECT_ID"
