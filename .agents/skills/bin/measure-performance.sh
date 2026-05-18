#!/usr/bin/env bash
# measure-performance.sh — V6 Performance Measurement through Runtime
#
# Runs basic performance benchmarks through the execution runtime.
# Referenced by verify-governance.sh but was missing.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$SCRIPT_DIR"
RUNTIME="$BIN_DIR/execution_runtime.py"
TARGET_DIR="${RUNTIME_TARGET_DIR:-.}"

echo "============================================================"
echo " PERFORMANCE MEASUREMENT (through runtime)"
echo "============================================================"

# Measure runtime overhead
echo ""
echo "--- Runtime Overhead ---"

# Direct execution (baseline)
DIRECT_START=$(date +%s%N)
echo "baseline" > /dev/null
DIRECT_END=$(date +%s%N)
DIRECT_MS=$(( (DIRECT_END - DIRECT_START) / 1000000 ))

# Runtime execution
RUNTIME_OUTPUT=$(python3 "$RUNTIME" run \
    --task "performance-measure" \
    --tier "READ_ONLY" \
    --scope "performance" \
    --cmd "echo benchmark" \
    --dir "$TARGET_DIR" 2>&1)

RUNTIME_MS=$(echo "$RUNTIME_OUTPUT" | grep -oP 'Duration:\s+\K[0-9.]+' || echo "0")
COMMAND_MS=$(echo "$RUNTIME_OUTPUT" | grep -oP 'Command Time:\s+\K[0-9.]+' || echo "0")
OVERHEAD_MS=$(echo "$RUNTIME_MS $COMMAND_MS" | awk '{printf "%.1f", $1 - $2}')

echo "  Direct baseline:   ${DIRECT_MS}ms"
echo "  Runtime total:     ${RUNTIME_MS}ms"
echo "  Command time:      ${COMMAND_MS}ms"
echo "  Governance overhead: ${OVERHEAD_MS}ms"

echo ""
echo "Status: YELLOW (baseline only — no performance targets set)"
exit 0
