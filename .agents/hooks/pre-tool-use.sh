#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./lib.sh
source "$SCRIPT_DIR/lib.sh"

PROJECT_ROOT="$(resolve_project_root)"
TOOL_NAME="${AGENT_HARNESS_TOOL_NAME:-}"
INPUT_TEXT="${AGENT_HARNESS_TOOL_INPUT:-}"
TRUST_TIER="${AGENT_HARNESS_TRUST_TIER:-T0}"

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
        --trust-tier=*)
            TRUST_TIER="${1#*=}"
            shift
            ;;
        *)
            shift
            ;;
    esac
done

if ! flag_is_enabled hooks_enabled "$PROJECT_ROOT"; then
    printf 'pre-tool-use: hooks disabled\n'
    exit 0
fi

RULES_FILE="$(approved_rules_file "$PROJECT_ROOT")"
TRUST_RANK="$(trust_tier_rank "$TRUST_TIER")"
COMMAND_TEXT="$(sanitize_text "$INPUT_TEXT")"

if [ -z "$COMMAND_TEXT" ]; then
    printf 'pre-tool-use: no input provided\n'
    exit 0
fi

if flag_is_enabled dangerous_op_detection "$PROJECT_ROOT" && is_dangerous_command "$COMMAND_TEXT"; then
    printf 'pre-tool-use: blocked dangerous operation: %s\n' "$COMMAND_TEXT" >&2
    exit 1
fi

if command_requires_network "$COMMAND_TEXT" && [ "$TRUST_RANK" -lt 2 ]; then
    printf 'pre-tool-use: blocked network operation at trust tier %s\n' "$TRUST_TIER" >&2
    exit 1
fi

if [ "$TRUST_RANK" -eq 0 ]; then
    if command_looks_mutating "$COMMAND_TEXT"; then
        printf 'pre-tool-use: blocked mutating command at trust tier %s\n' "$TRUST_TIER" >&2
        exit 1
    fi

    if ! command_prefix_allowed "$COMMAND_TEXT" "$RULES_FILE"; then
        printf 'pre-tool-use: command requires allow rule or higher trust tier: %s\n' "$COMMAND_TEXT" >&2
        exit 1
    fi
fi

if [ "$TRUST_RANK" -eq 1 ] && command_requires_network "$COMMAND_TEXT"; then
    printf 'pre-tool-use: blocked external command at trust tier %s\n' "$TRUST_TIER" >&2
    exit 1
fi

printf 'pre-tool-use: allowed tool=%s trust_tier=%s\n' "${TOOL_NAME:-unknown}" "$TRUST_TIER"
