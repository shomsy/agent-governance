#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib.sh
source "$SCRIPT_DIR/lib.sh"

PROJECT_ROOT="$(resolve_project_root)"
TOOL_NAME="${AGENT_HARNESS_TOOL_NAME:-unknown}"
INPUT_TEXT="${AGENT_HARNESS_TOOL_INPUT:-}"
OUTPUT_TEXT="${AGENT_HARNESS_TOOL_OUTPUT:-}"
CURRENT_SESSION_ID="${AGENT_HARNESS_SESSION_ID:-$(session_id)}"

while [ "$#" -gt 0 ]; do
    case "$1" in
        --project-root=*)
            PROJECT_ROOT="${1#*=}"
            shift
            ;;
        --tool=*)
            TOOL_NAME="${1#*=}"
            shift
            ;;
        --input=*)
            INPUT_TEXT="${1#*=}"
            shift
            ;;
        --output=*)
            OUTPUT_TEXT="${1#*=}"
            shift
            ;;
        --session-id=*)
            CURRENT_SESSION_ID="${1#*=}"
            shift
            ;;
        *)
            shift
            ;;
    esac
done

if ! flag_is_enabled hooks_enabled "$PROJECT_ROOT"; then
    printf 'post-tool-use: hooks disabled\n'
    exit 0
fi

if ! flag_is_enabled continuous_learning "$PROJECT_ROOT"; then
    printf 'post-tool-use: continuous learning disabled\n'
    exit 0
fi

case "${AGENT_HARNESS_LEARNING_MODE:-}" in
    analyze|observe-skip)
        printf 'post-tool-use: learning guard active\n'
        exit 0
        ;;
esac

ensure_learning_layout "$PROJECT_ROOT"

OBSERVATIONS_FILE="$(learning_dir "$PROJECT_ROOT")/observations.jsonl"
ARCHIVE_FILE="$(learning_dir "$PROJECT_ROOT")/observations.archive.jsonl"
CURRENT_PROJECT_ID="$(project_id "$PROJECT_ROOT")"
TIMESTAMP="$(iso_timestamp)"
INPUT_SUMMARY="$(summarize_text "$INPUT_TEXT" 200)"
OUTPUT_SUMMARY="$(summarize_text "$OUTPUT_TEXT" 200)"

if [ "$(wc -l < "$OBSERVATIONS_FILE")" -gt 50000 ]; then
    sed -n '1,25000p' "$OBSERVATIONS_FILE" >> "$ARCHIVE_FILE"
    tail -n +25001 "$OBSERVATIONS_FILE" > "$OBSERVATIONS_FILE.tmp"
    mv "$OBSERVATIONS_FILE.tmp" "$OBSERVATIONS_FILE"
fi

log_json_observation \
    "$TIMESTAMP" \
    "$TOOL_NAME" \
    "$INPUT_SUMMARY" \
    "$OUTPUT_SUMMARY" \
    "$CURRENT_PROJECT_ID" \
    "$CURRENT_SESSION_ID" >> "$OBSERVATIONS_FILE"

printf 'post-tool-use: logged tool=%s session_id=%s\n' "$TOOL_NAME" "$CURRENT_SESSION_ID"
