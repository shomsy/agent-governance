#!/usr/bin/env bash
# runtime_exec.sh — V6 Universal Execution Wrapper
#
# Routes ALL shell commands through execution_runtime.py.
# Every invocation produces: execution identity, manifest, approval metadata,
# sandbox decision, evidence correlation, replay metadata, integrity seal.
#
# Usage:
#   runtime_exec.sh --tier TIER --scope SCOPE -- cmd [args...]
#   runtime_exec.sh --tier TIER --scope SCOPE --task "Task name" -- cmd [args...]
#   runtime_exec.sh --dry-run -- cmd [args...]
#
# Environment defaults:
#   RUNTIME_TIER=READ_ONLY
#   RUNTIME_SCOPE=security
#   RUNTIME_TARGET_DIR=.
#   RUNTIME_TASK=shell-command

set -euo pipefail

BIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUNTIME="$BIN_DIR/execution_runtime.py"
TARGET_DIR="${RUNTIME_TARGET_DIR:-.}"
TIER="${RUNTIME_TIER:-READ_ONLY}"
SCOPE="${RUNTIME_SCOPE:-security}"
TASK="${RUNTIME_TASK:-shell-command}"
DRY_RUN=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --tier)    TIER="$2"; shift 2 ;;
        --scope)   SCOPE="$2"; shift 2 ;;
        --task)    TASK="$2"; shift 2 ;;
        --dir)     TARGET_DIR="$2"; shift 2 ;;
        --dry-run) DRY_RUN="--dry-run"; shift ;;
        --)        shift; break ;;
        *)         break ;;
    esac
done

CMD="$*"
if [ -z "$CMD" ]; then
    echo "ERROR: No command provided" >&2
    echo "Usage: runtime_exec.sh --tier TIER --scope SCOPE -- cmd [args...]" >&2
    exit 1
fi

if [ ! -f "$RUNTIME" ]; then
    echo "ERROR: execution_runtime.py not found at $RUNTIME" >&2
    exit 1
fi

python3 "$RUNTIME" run \
    --task "$TASK" \
    --tier "$TIER" \
    --scope "$SCOPE" \
    --cmd "$CMD" \
    --dir "$TARGET_DIR" \
    $DRY_RUN

exit $?
