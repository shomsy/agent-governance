#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=.agents/hooks/lib.sh
source "$SCRIPT_DIR/lib.sh"

ROOT="$(resolve_project_root)"
SESSION="$(session_id)"
TASK_ID="${AGENT_HARNESS_TASK_ID:-}"
PROMPT=""
PROMPT_FILE=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --prompt)
            PROMPT="${2:-}"
            shift 2
            ;;
        --prompt-file)
            PROMPT_FILE="${2:-}"
            shift 2
            ;;
        --task-id)
            TASK_ID="${2:-}"
            shift 2
            ;;
        --session-id)
            SESSION="${2:-}"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 2
            ;;
    esac
done

if [ -z "$PROMPT" ] && [ -z "$PROMPT_FILE" ]; then
    echo "pre-task.sh requires --prompt or --prompt-file" >&2
    exit 2
fi

ensure_learning_layout "$ROOT"
ensure_memory_layout "$ROOT"
ensure_session_layout "$ROOT" "$SESSION"
ensure_trace_layout "$ROOT"
set_current_session_id "$ROOT" "$SESSION"

if [ -z "$TASK_ID" ]; then
    if [ -n "$PROMPT" ]; then
        TASK_ID="task-$(hash_string "$PROMPT")"
    else
        TASK_ID="task-$(date +%Y%m%d%H%M%S)"
    fi
fi

mkdir -p "$(task_dir "$ROOT" "$SESSION" "$TASK_ID")"
set_current_task_id "$ROOT" "$SESSION" "$TASK_ID"

JSON_PATH="$(task_context_json_path "$ROOT" "$SESSION" "$TASK_ID")"
MARKDOWN_PATH="$(task_context_markdown_path "$ROOT" "$SESSION" "$TASK_ID")"

RESOLVER_ARGS=(
    "$SCRIPT_DIR/resolve-task-context.py"
    --project-root "$ROOT"
    --session-id "$SESSION"
    --task-id "$TASK_ID"
    --write-json "$JSON_PATH"
    --write-markdown "$MARKDOWN_PATH"
)

if [ -n "$PROMPT" ]; then
    RESOLVER_ARGS+=(--prompt "$PROMPT")
else
    RESOLVER_ARGS+=(--prompt-file "$PROMPT_FILE")
fi

python3 "${RESOLVER_ARGS[@]}" >/dev/null

TRACE_ID="$(json_get "$JSON_PATH" "trace_id" || true)"
PRIMARY_LANE="$(json_get "$JSON_PATH" "routing.primary_lane" || true)"
PIPELINE="$(json_get "$JSON_PATH" "routing.pipeline" || true)"
STARTING_ROLE="$(json_get "$JSON_PATH" "routing.starting_role" || true)"
TRUST_TIER="$(json_get "$JSON_PATH" "routing.trust_tier" || true)"
APPROVAL_MODE="$(json_get "$JSON_PATH" "routing.approval_mode" || true)"
MUST_READ="$(json_get "$JSON_PATH" "governance_pack.must_read" || true)"

append_task_event "$ROOT" "$SESSION" "$TASK_ID" "AGENTSLoaded" "Resolved root contract and reusable rules"
append_task_event "$ROOT" "$SESSION" "$TASK_ID" "TaskReady" "lane=$PRIMARY_LANE pipeline=$PIPELINE role=$STARTING_ROLE tier=$TRUST_TIER"

{
    printf '\n## Task Route — %s\n\n' "$(iso_timestamp)"
    printf -- '- Task ID: `%s`\n' "$TASK_ID"
    printf -- '- Trace ID: `%s`\n' "$TRACE_ID"
    printf -- '- Primary Lane: `%s`\n' "$PRIMARY_LANE"
    printf -- '- Pipeline: `%s`\n' "$PIPELINE"
    printf -- '- Starting Role: `%s`\n' "$STARTING_ROLE"
    printf -- '- Trust Tier: `%s`\n' "$TRUST_TIER"
    printf -- '- Approval Mode: `%s`\n' "$APPROVAL_MODE"
} >> "$(session_dir "$ROOT" "$SESSION")/session_memory.md"

{
    printf -- '- %s | trace=%s | task=%s | lane=%s | pipeline=%s | tier=%s | artifact=`%s` | outcome=routed\n' \
        "$(iso_timestamp)" "$TRACE_ID" "$TASK_ID" "$PRIMARY_LANE" "$PIPELINE" "$TRUST_TIER" "$JSON_PATH"
} >> "$(trace_reports_file "$ROOT")"

echo "[Agent OS PreTask] Task routed."
echo "[Agent OS PreTask] task=$TASK_ID trace=$TRACE_ID lane=$PRIMARY_LANE pipeline=$PIPELINE role=$STARTING_ROLE tier=$TRUST_TIER"
echo "[Agent OS PreTask] context_json=$JSON_PATH"
echo "[Agent OS PreTask] must_read=$MUST_READ"
