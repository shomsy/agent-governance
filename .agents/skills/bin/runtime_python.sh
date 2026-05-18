#!/usr/bin/env bash
# runtime_python.sh — V6 Python Execution Wrapper
#
# Routes Python script execution through execution_runtime.py.
# Validates script exists before routing.
#
# Usage:
#   runtime_python.sh --tier TIER -- script.py [args...]
#   runtime_python.sh --tier TIER --scope SCOPE -- script.py [args...]
#
# Environment defaults:
#   RUNTIME_TIER=READ_ONLY
#   RUNTIME_SCOPE=security
#   RUNTIME_TARGET_DIR=.

set -euo pipefail

BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${RUNTIME_TARGET_DIR:-.}"
TIER="${RUNTIME_TIER:-READ_ONLY}"
SCOPE="${RUNTIME_SCOPE:-security}"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --tier)    TIER="$2"; shift 2 ;;
        --scope)   SCOPE="$2"; shift 2 ;;
        --dir)     TARGET_DIR="$2"; shift 2 ;;
        --)        shift; break ;;
        *)         break ;;
    esac
done

SCRIPT="${1:-}"
shift || true
ARGS="$*"

if [ -z "$SCRIPT" ]; then
    echo "ERROR: No script provided" >&2
    echo "Usage: runtime_python.sh --tier TIER -- script.py [args...]" >&2
    exit 1
fi

if [ ! -f "$SCRIPT" ]; then
    echo "ERROR: Script not found: $SCRIPT" >&2
    exit 1
fi

# Resolve to absolute path
SCRIPT_ABS="$(cd "$(dirname "$SCRIPT")" && pwd)/$(basename "$SCRIPT")"

# Build the python command — route through runtime_exec.sh
exec "$BIN_DIR/runtime_exec.sh" \
    --tier "$TIER" \
    --scope "$SCOPE" \
    --task "python-exec" \
    --dir "$TARGET_DIR" \
    -- "python3 $SCRIPT_ABS $ARGS"
