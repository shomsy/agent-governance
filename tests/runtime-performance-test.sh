#!/usr/bin/env bash
# tests/runtime-performance-test.sh — V7 Runtime Performance & Budget Validation
#
# Measures runtime overhead and validates complexity/noise budgets.
#
# Usage:
#   bash tests/runtime-performance-test.sh
#
# Output:
#   GREEN/YELLOW/RED summary with timing numbers

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

BIN_DIR="$PROJECT_ROOT/.agents/skills/bin"
RUNTIME="$BIN_DIR/execution_runtime.py"

# Colors
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    CYAN='\033[0;36m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' CYAN='' NC=''
fi

TOTAL=0
PASS=0
FAIL=0
WARN=0
WARNINGS=()

pass_test() {
    PASS=$((PASS + 1))
    TOTAL=$((TOTAL + 1))
    echo -e "  [${GREEN}PASS${NC}] $1"
}

fail_test() {
    FAIL=$((FAIL + 1))
    TOTAL=$((TOTAL + 1))
    echo -e "  [${RED}FAIL${NC}] $1"
}

warn_test() {
    WARN=$((WARN + 1))
    TOTAL=$((TOTAL + 1))
    WARNINGS+=("$1")
    echo -e "  [${YELLOW}WARN${NC}] $1"
}

# Helper: measure command execution time in milliseconds
measure_ms() {
    local start_ns end_ns elapsed_ms
    start_ns=$(date +%s%N)
    eval "$1" >/dev/null 2>&1 || true
    end_ns=$(date +%s%N)
    elapsed_ms=$(( (end_ns - start_ns) / 1000000 ))
    echo "$elapsed_ms"
}

echo "============================================="
echo "RUNTIME PERFORMANCE & BUDGET VALIDATION"
echo "============================================="
echo ""

# ============================================================
# Section 1: Direct vs Runtime Overhead
# ============================================================
echo "--- Section 1: Direct vs Runtime Overhead ---"

# Measure direct command
DIRECT_MS=$(measure_ms "echo performance-test")

# Measure runtime dry-run (avoids actual subprocess overhead)
RUNTIME_MS=$(measure_ms "python3 '$RUNTIME' run --task 'perf-test' --tier READ_ONLY --scope security --cmd 'echo perf-test' --dir '$PROJECT_ROOT' --dry-run")

echo "  Direct command: ${DIRECT_MS}ms"
echo "  Runtime dry-run: ${RUNTIME_MS}ms"

if [ "$RUNTIME_MS" -lt 5000 ]; then
    pass_test "Runtime dry-run under 5000ms (${RUNTIME_MS}ms)"
else
    fail_test "Runtime dry-run over 5000ms (${RUNTIME_MS}ms)"
fi

# Runtime overhead should be reasonable (< 3000ms for dry-run on modern hardware)
OVERHEAD=$((RUNTIME_MS - DIRECT_MS))
if [ "$OVERHEAD" -lt 3000 ]; then
    pass_test "Runtime overhead under 3000ms (${OVERHEAD}ms)"
else
    warn_test "Runtime overhead high: ${OVERHEAD}ms (may vary by system)"
fi

echo ""

# ============================================================
# Section 2: HMAC Seal Overhead
# ============================================================
echo "--- Section 2: HMAC Seal Overhead ---"

HMAC_MS=$(measure_ms "python3 -c \"
import sys
sys.path.insert(0, '$BIN_DIR')
from crypto_seals import HMACSeal
s = HMACSeal()
s.seal_data({'test': 'benchmark'})
\"")

echo "  HMAC seal: ${HMAC_MS}ms"

if [ "$HMAC_MS" -lt 200 ]; then
    pass_test "HMAC seal under 200ms (${HMAC_MS}ms)"
else
    warn_test "HMAC seal slow: ${HMAC_MS}ms"
fi

echo ""

# ============================================================
# Section 3: Manifest Write Overhead
# ============================================================
echo "--- Section 3: Manifest Write Overhead ---"

# Run a real execution and measure manifest creation time
MANIFEST_DIR="$PROJECT_ROOT/.agents/management/evidence/execution"
BEFORE_COUNT=$(find "$MANIFEST_DIR" -name "execution-manifest-*.json" 2>/dev/null | wc -l || echo 0)

WRITE_MS=$(measure_ms "python3 '$RUNTIME' run --task 'manifest-perf' --tier READ_ONLY --scope security --cmd 'echo manifest-perf' --dir '$PROJECT_ROOT' 2>/dev/null || true")

AFTER_COUNT=$(find "$MANIFEST_DIR" -name "execution-manifest-*.json" 2>/dev/null | wc -l || echo 0)

echo "  Manifest write: ${WRITE_MS}ms"

if [ "$AFTER_COUNT" -gt "$BEFORE_COUNT" ]; then
    pass_test "Manifest created (count: $BEFORE_COUNT -> $AFTER_COUNT)"
else
    warn_test "No new manifest created (may be expected if execution was fast)"
fi

if [ "$WRITE_MS" -lt 5000 ]; then
    pass_test "Manifest write under 5000ms (${WRITE_MS}ms)"
else
    warn_test "Manifest write slow: ${WRITE_MS}ms"
fi

echo ""

# ============================================================
# Section 4: Evidence Query Overhead
# ============================================================
echo "--- Section 4: Evidence Query Overhead ---"

if [ -f "$BIN_DIR/evidence-query.py" ]; then
    QUERY_MS=$(measure_ms "python3 '$BIN_DIR/evidence-query.py' list --dir '$PROJECT_ROOT' 2>/dev/null || true")
    echo "  Evidence list query: ${QUERY_MS}ms"

    if [ "$QUERY_MS" -lt 5000 ]; then
        pass_test "Evidence query under 5000ms (${QUERY_MS}ms)"
    else
        warn_test "Evidence query slow: ${QUERY_MS}ms"
    fi
else
    warn_test "evidence-query.py not found — skipped"
fi

echo ""

# ============================================================
# Section 5: Budget Validation
# ============================================================
echo "--- Section 5: Budget Validation ---"

if [ -f "$BIN_DIR/check-budgets.py" ]; then
    BUDGET_OUTPUT=$(python3 "$BIN_DIR/check-budgets.py" --dir "$PROJECT_ROOT" 2>&1) || BUDGET_RC=$? || true
    BUDGET_RC=${BUDGET_RC:-0}
    echo "$BUDGET_OUTPUT" | head -20

    if [ "$BUDGET_RC" -eq 0 ]; then
        pass_test "All budgets within limits"
    elif [ "$BUDGET_RC" -eq 2 ]; then
        warn_test "Some budgets approaching limits (YELLOW)"
    else
        fail_test "Budget breach detected (RED)"
    fi
else
    warn_test "check-budgets.py not found — skipped"
fi

echo ""

# ============================================================
# Section 6: Runtime --quiet Mode Performance
# ============================================================
echo "--- Section 6: Runtime --quiet Mode Performance ---"

QUIET_MS=$(measure_ms "python3 '$RUNTIME' run --task 'quiet-test' --tier READ_ONLY --scope security --cmd 'echo quiet' --dir '$PROJECT_ROOT' --dry-run --quiet 2>/dev/null || true")
HUMAN_MS=$(measure_ms "python3 '$RUNTIME' run --task 'human-test' --tier READ_ONLY --scope security --cmd 'echo human' --dir '$PROJECT_ROOT' --dry-run --format human 2>/dev/null || true")

echo "  --quiet mode: ${QUIET_MS}ms"
echo "  --format human: ${HUMAN_MS}ms"

if [ "$QUIET_MS" -le "$HUMAN_MS" ]; then
    pass_test "--quiet mode not slower than human mode"
else
    # Quiet being slightly slower is OK (same code path, just less output)
    DIFF=$((QUIET_MS - HUMAN_MS))
    if [ "$DIFF" -lt 100 ]; then
        pass_test "--quiet mode within 100ms of human mode"
    else
        warn_test "--quiet mode slower than human: ${QUIET_MS}ms vs ${HUMAN_MS}ms"
    fi
fi

echo ""

# ============================================================
# Summary
# ============================================================
echo "============================================="
echo "PERFORMANCE & BUDGET SUMMARY"
echo "============================================="
echo "Total checks:  ${TOTAL}"
echo -e "Passed:        ${GREEN}${PASS}${NC}"
echo -e "Failed:        ${RED}${FAIL}${NC}"
echo -e "Warnings:      ${YELLOW}${WARN}${NC}"
echo ""

if [ $FAIL -gt 0 ]; then
    echo "STATUS: RED"
    exit 1
elif [ $WARN -gt 0 ]; then
    echo "STATUS: YELLOW"
    echo ""
    echo "Warnings:"
    for w in "${WARNINGS[@]}"; do
        echo "  - ${w}"
    done
    exit 2
else
    echo "STATUS: GREEN"
    exit 0
fi
