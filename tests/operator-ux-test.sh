#!/usr/bin/env bash
# tests/operator-ux-test.sh — V7 Operator UX Validation
#
# Tests operator experience improvements:
# - --format human/json output
# - --quiet mode
# - Readable denied-command output
# - Concise execution summary

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

RUNTIME="$PROJECT_ROOT/.agents/skills/bin/execution_runtime.py"

if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' NC=''
fi

TOTAL=0
PASS=0
FAIL=0
WARN=0

pass_test() {
    PASS=$((PASS + 1))
    TOTAL=$((TOTAL + 1))
    echo -e "  [${GREEN}PASS${NC}] $1"
}

fail_test() {
    FAIL=$((FAIL + 1))
    TOTAL=$((TOTAL + 1))
    echo -e "  [${RED}FAIL${NC}] $1"
    echo "    Output: ${1:0:500}"
}

warn_test() {
    WARN=$((WARN + 1))
    TOTAL=$((TOTAL + 1))
    echo -e "  [${YELLOW}WARN${NC}] $1"
}

echo "============================================="
echo "OPERATOR UX VALIDATION"
echo "============================================="
echo ""

# ============================================================
# Section 1: --format json
# ============================================================
echo "--- Section 1: --format json ---"

JSON_OUTPUT=$(python3 "$RUNTIME" run \
    --task "json-test" \
    --tier "READ_ONLY" \
    --scope "security" \
    --cmd "echo json-format" \
    --dir "$PROJECT_ROOT" \
    --dry-run \
    --format json 2>&1) || true

echo "  Output: ${JSON_OUTPUT:0:200}"

if echo "$JSON_OUTPUT" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null; then
    pass_test "--format json produces valid JSON"
else
    fail_test "--format json did not produce valid JSON"
fi

if echo "$JSON_OUTPUT" | grep -q '"success"'; then
    pass_test "JSON includes success field"
else
    fail_test "JSON missing success field"
fi

echo ""

# ============================================================
# Section 2: --format human
# ============================================================
echo "--- Section 2: --format human ---"

HUMAN_OUTPUT=$(python3 "$RUNTIME" run \
    --task "human-test" \
    --tier "READ_ONLY" \
    --scope "security" \
    --cmd "echo human-format" \
    --dir "$PROJECT_ROOT" \
    --dry-run \
    --format human 2>&1) || true

if echo "$HUMAN_OUTPUT" | grep -q "session\|Session\|EXEC\|dry_run\|SUCCESS\|dry-run"; then
    pass_test "--format human produces readable output"
else
    fail_test "--format human output not recognizable"
fi

echo ""

# ============================================================
# Section 3: --quiet mode
# ============================================================
echo "--- Section 3: --quiet mode ---"

QUIET_OUTPUT=$(python3 "$RUNTIME" run \
    --task "quiet-test" \
    --tier "READ_ONLY" \
    --scope "security" \
    --cmd "echo quiet-test" \
    --dir "$PROJECT_ROOT" \
    --dry-run \
    --quiet 2>&1) || true

# Quiet mode should produce minimal output
QUIET_LINES=$(echo "$QUIET_OUTPUT" | grep -c "." || true)

if [ "$QUIET_LINES" -le 3 ]; then
    pass_test "--quiet mode produces minimal output ($QUIET_LINES lines)"
else
    fail_test "--quiet mode too verbose ($QUIET_LINES lines): ${QUIET_OUTPUT:0:200}"
fi

echo ""

# ============================================================
# Section 4: Denied command output
# ============================================================
echo "--- Section 4: Denied command output ---"

DENIED_OUTPUT=$(python3 "$RUNTIME" run \
    --task "denied-test" \
    --tier "READ_ONLY" \
    --scope "security" \
    --cmd "rm -rf /" \
    --dir "$PROJECT_ROOT" \
    --dry-run 2>&1) || true

echo "  Output: ${DENIED_OUTPUT:0:200}"

if echo "$DENIED_OUTPUT" | grep -qi "DENIED\|FORBIDDEN\|danger\|blocked\|FAILED"; then
    pass_test "Denied command produces clear denial message"
else
    fail_test "Denied command output unclear: ${DENIED_OUTPUT:0:200}"
fi

if echo "$DENIED_OUTPUT" | grep -qi "FORBIDDEN\|danger\|root\|deletion"; then
    pass_test "Denial explains reason (danger class or policy)"
else
    warn_test "Denial could be more explanatory"
fi

echo ""

# ============================================================
# Section 5: Execution summary
# ============================================================
echo "--- Section 5: Execution summary ---"

SUMMARY_FILE="$PROJECT_ROOT/.agents/management/evidence/generated/execution-summary.jsonl"

# Run a real execution to generate summary
python3 "$RUNTIME" run \
    --task "summary-test" \
    --tier "READ_ONLY" \
    --scope "security" \
    --cmd "echo summary-test" \
    --dir "$PROJECT_ROOT" \
    2>/dev/null || true

if [ -f "$SUMMARY_FILE" ]; then
    LAST_LINE=$(tail -1 "$SUMMARY_FILE")
    if echo "$LAST_LINE" | python3 -c "import sys,json; json.load(sys.stdin)" 2>/dev/null; then
        pass_test "Execution summary is valid JSONL"
    else
        fail_test "Execution summary is not valid JSONL"
    fi
else
    fail_test "Execution summary file not found at $SUMMARY_FILE"
fi

echo ""

# ============================================================
# Summary
# ============================================================
echo "============================================="
echo "OPERATOR UX SUMMARY"
echo "============================================="
echo "Total checks:  ${TOTAL}"
echo -e "Passed:        ${GREEN}${PASS}${NC}"
echo -e "Failed:        ${RED}${FAIL}${NC}"
echo -e "Warnings:      ${YELLOW}${WARN:-0}${NC}"
echo ""

if [ $FAIL -gt 0 ]; then
    echo "STATUS: RED"
    exit 1
else
    echo "STATUS: GREEN"
    exit 0
fi
