#!/usr/bin/env bash
# project-local-contract-test.sh -- Project-Local Contract Standard Tests
#
# Exit codes: 0 = all pass, 1 = failures

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PASS=0
FAIL=0
TOTAL=0

pass() {
    PASS=$((PASS + 1))
    TOTAL=$((TOTAL + 1))
    echo "  [PASS] $1"
}

fail() {
    FAIL=$((FAIL + 1))
    TOTAL=$((TOTAL + 1))
    echo "  [FAIL] $1"
}

echo "============================================="
echo "PROJECT-LOCAL CONTRACT TESTS"
echo "============================================="

# Test 1: Template exists in .agents/templates
echo ""
echo "Test 1: Template exists in reusable templates"
if [ -f "$PROJECT_ROOT/.agents/templates/how-to-write-project.md" ]; then
    pass "Template exists at .agents/templates/how-to-write-project.md"
else
    fail "Template missing at .agents/templates/how-to-write-project.md"
fi

# Test 2: Profile resolution algorithm documents L4 project-local contract
echo ""
echo "Test 2: Profile resolution algorithm documents L4 project-local contract"
if grep -q "project-local contract\|Layer 4\|how-to-write-" "$PROJECT_ROOT/.agents/governance/core/resolution/profile-resolution-algorithm.md" 2>/dev/null; then
    pass "Profile resolution algorithm documents L4 contract"
else
    fail "Profile resolution algorithm does not document L4 contract"
fi

# Test 3: Template is not a placeholder
echo ""
echo "Test 3: Template has real content (not placeholder)"
NON_EMPTY=$(grep -cv '^\s*$' "$PROJECT_ROOT/.agents/templates/how-to-write-project.md" 2>/dev/null || echo "0")
if [ "$NON_EMPTY" -ge 10 ]; then
    pass "Template has $NON_EMPTY non-empty lines (>= 10)"
else
    fail "Template has only $NON_EMPTY non-empty lines (< 10)"
fi

# Test 4: AGENTS.md references templates directory
echo ""
echo "Test 4: AGENTS.md references templates/scaffolds"
if grep -q "templates\|scaffolds" "$PROJECT_ROOT/AGENTS.md" 2>/dev/null; then
    pass "AGENTS.md references templates/scaffolds"
else
    fail "AGENTS.md does not reference templates/scaffolds"
fi

# Test 5: Execution substrate governance docs exist
echo ""
echo "Test 5: Execution substrate governance docs exist"
if [ -f "$PROJECT_ROOT/.agents/governance/execution/execution-substrate-architecture.md" ]; then
    pass "execution-substrate-architecture.md exists"
else
    fail "execution-substrate-architecture.md missing"
fi

# Test 6: Sandbox boundary policy exists
echo ""
echo "Test 6: Sandbox boundary policy exists"
if [ -f "$PROJECT_ROOT/.agents/governance/execution/sandbox/sandbox-boundary-policy.md" ]; then
    pass "sandbox-boundary-policy.md exists"
else
    fail "sandbox-boundary-policy.md missing"
fi

# Summary
echo ""
echo "============================================="
echo "RESULTS: $PASS passed, $FAIL failed, $TOTAL total"
echo "============================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
