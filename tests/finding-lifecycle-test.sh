#!/usr/bin/env bash
# finding-lifecycle-test.sh — Finding Lifecycle Decision Registry Tests
#
# Tests the finding_decisions.py tool and the finding lifecycle contract.
#
# Exit codes: 0 = GREEN, 1 = RED (blocking), 2 = YELLOW (warnings)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TOOL="$PROJECT_ROOT/.agents/skills/bin/finding_decisions.py"
REGISTRY="$PROJECT_ROOT/.agents/management/evidence/indexes/finding-decisions.json"
SCHEMA="$PROJECT_ROOT/.agents/config/schemas/finding-decision.schema.json"

TOTAL=0
PASSED=0
FAILED=0
WARNED=0

pass_test() {
    local name="$1"
    PASSED=$((PASSED + 1))
    TOTAL=$((TOTAL + 1))
    echo "  [PASS] $name"
}

fail_test() {
    local name="$1"
    local detail="${2:-}"
    FAILED=$((FAILED + 1))
    TOTAL=$((TOTAL + 1))
    echo "  [FAIL] $name"
    if [ -n "$detail" ]; then
        echo "    Detail: $detail"
    fi
}

warn_test() {
    local name="$1"
    WARNED=$((WARNED + 1))
    TOTAL=$((TOTAL + 1))
    echo "  [WARN] $name"
}

# Temporary directory for test modifications
TEST_TMP=""
cleanup() {
    if [ -n "$TEST_TMP" ] && [ -d "$TEST_TMP" ]; then
        rm -rf "$TEST_TMP"
    fi
}
trap cleanup EXIT

setup_test_registry() {
    TEST_TMP=$(mktemp -d)
    mkdir -p "$TEST_TMP/.agents/management/evidence/indexes"
    mkdir -p "$TEST_TMP/.agents/config/schemas"
    cp "$SCHEMA" "$TEST_TMP/.agents/config/schemas/"
    echo '{"schemaVersion":"1.0.0","generatedAt":"2026-05-19T00:00:00Z","schemaRef":".agents/config/schemas/finding-decision.schema.json","decisions":[]}' > "$TEST_TMP/.agents/management/evidence/indexes/finding-decisions.json"
}

echo "============================================="
echo "FINDING LIFECYCLE TEST SUITE"
echo "============================================="
echo ""

# ============================================================
# Test 1: Tool and schema exist, valid JSON
# ============================================================
echo "--- Test 1: Tool and Schema Existence ---"

if [ -f "$TOOL" ]; then
    pass_test "finding_decisions.py exists"
else
    fail_test "finding_decisions.py exists"
    echo "CRITICAL: Tool not found. Aborting."
    exit 1
fi

if [ -f "$SCHEMA" ]; then
    if python3 -c "import json; json.load(open('$SCHEMA'))" 2>/dev/null; then
        pass_test "Schema is valid JSON"
    else
        fail_test "Schema is valid JSON" "Invalid JSON"
    fi
else
    fail_test "Schema exists" "$SCHEMA not found"
fi

if python3 -m py_compile "$TOOL" 2>/dev/null; then
    pass_test "Python syntax valid"
else
    fail_test "Python syntax valid"
fi

# ============================================================
# Test 2: Empty registry validates (exit 0)
# ============================================================
echo ""
echo "--- Test 2: Empty Registry Validation ---"

setup_test_registry

OUTPUT=$(python3 "$TOOL" --dir "$TEST_TMP" validate 2>&1) || RC=$?
RC=${RC:-0}

if [ "$RC" -eq 0 ]; then
    pass_test "Empty registry validates (exit 0)"
else
    fail_test "Empty registry validates (exit 0)" "exit code: $RC"
fi

# ============================================================
# Test 3: Add a decision and validate
# ============================================================
echo ""
echo "--- Test 3: Add Decision + Validate ---"

ADD_OUTPUT=$(python3 "$TOOL" --dir "$TEST_TMP" add \
    --tool "test-scanner.sh" \
    --file "src/example.py" \
    --decision "FALSE_POSITIVE" \
    --reason "Test false positive for validation" \
    --pattern "test_pattern" \
    2>&1) || ADD_RC=$?
ADD_RC=${ADD_RC:-0}

if [ "$ADD_RC" -eq 0 ]; then
    pass_test "Add decision succeeds"
else
    fail_test "Add decision succeeds" "exit code: $ADD_RC, output: $ADD_OUTPUT"
fi

# Validate after add
VAL_OUTPUT=$(python3 "$TOOL" --dir "$TEST_TMP" validate 2>&1) || VAL_RC=$?
VAL_RC=${VAL_RC:-0}

if [ "$VAL_RC" -eq 0 ]; then
    pass_test "Validate passes after add"
else
    fail_test "Validate passes after add" "exit code: $VAL_RC"
fi

# List should show the decision
LIST_OUTPUT=$(python3 "$TOOL" --dir "$TEST_TMP" list 2>&1) || LIST_RC=$?
LIST_RC=${LIST_RC:-0}

if [ "$LIST_RC" -eq 0 ] && echo "$LIST_OUTPUT" | grep -q "FALSE_POSITIVE"; then
    pass_test "Decision appears in list"
else
    fail_test "Decision appears in list" "output: $LIST_OUTPUT"
fi

# ============================================================
# Test 4: Fingerprint matching
# ============================================================
echo ""
echo "--- Test 4: Fingerprint Matching ---"

# Get the fingerprint from the added decision
FP=$(python3 -c "
import json
with open('$TEST_TMP/.agents/management/evidence/indexes/finding-decisions.json') as f:
    data = json.load(f)
print(data['decisions'][0]['findingFingerprint'])
")

# Match should succeed
MATCH_OUTPUT=$(python3 "$TOOL" --dir "$TEST_TMP" match --fingerprint "$FP" 2>&1) || MATCH_RC=$?
MATCH_RC=${MATCH_RC:-0}

if [ "$MATCH_RC" -eq 0 ]; then
    pass_test "Known fingerprint matches (exit 0)"
else
    fail_test "Known fingerprint matches (exit 0)" "exit code: $MATCH_RC"
fi

# Unknown fingerprint should fail
UNKNOWN_FP="0000000000000000000000000000000000000000000000000000000000000000"
NOMATCH_OUTPUT=$(python3 "$TOOL" --dir "$TEST_TMP" match --fingerprint "$UNKNOWN_FP" 2>&1) || NOMATCH_RC=$?
NOMATCH_RC=${NOMATCH_RC:-0}

if [ "$NOMATCH_RC" -eq 1 ]; then
    pass_test "Unknown fingerprint returns not found (exit 1)"
else
    fail_test "Unknown fingerprint returns not found (exit 1)" "exit code: $NOMATCH_RC"
fi

# ============================================================
# Test 5: Expired decision detection
# ============================================================
echo ""
echo "--- Test 5: Expired Decision Detection ---"

# Add an expired decision
python3 "$TOOL" --dir "$TEST_TMP" add \
    --tool "expired-scanner" \
    --file "src/old.py" \
    --decision "DEFERRED" \
    --reason "Test expired decision" \
    --expiry "2020-01-01T00:00:00Z" \
    --decision-severity "RED" \
    2>/dev/null

EXPIRE_OUTPUT=$(python3 "$TOOL" --dir "$TEST_TMP" expire-check 2>&1) || EXPIRE_RC=$?
EXPIRE_RC=${EXPIRE_RC:-0}

if [ "$EXPIRE_RC" -eq 2 ]; then
    pass_test "Expired blocking decision detected (exit 2)"
else
    fail_test "Expired blocking decision detected (exit 2)" "exit code: $EXPIRE_RC"
fi

# validate should also fail
VAL_EXPIRED_OUTPUT=$(python3 "$TOOL" --dir "$TEST_TMP" validate 2>&1) || VAL_EXPIRED_RC=$?
VAL_EXPIRED_RC=${VAL_EXPIRED_RC:-0}

if [ "$VAL_EXPIRED_RC" -eq 2 ]; then
    pass_test "Validate flags expired blocking decision (exit 2)"
else
    fail_test "Validate flags expired blocking decision (exit 2)" "exit code: $VAL_EXPIRED_RC"
fi

# ============================================================
# Test 6: Schema validation rejects invalid entries
# ============================================================
echo ""
echo "--- Test 6: Schema Validation Rejects Invalid Entries ---"

setup_test_registry

# Try to add with invalid decision value (should be rejected by argparse choices)
INVALID_OUTPUT=$(python3 "$TOOL" --dir "$TEST_TMP" add \
    --tool "test" \
    --file "src/bad.py" \
    --decision "INVALID_DECISION" \
    --reason "Should fail" \
    2>&1) || INVALID_RC=$?
INVALID_RC=${INVALID_RC:-0}

if [ "$INVALID_RC" -ne 0 ]; then
    pass_test "Invalid decision enum rejected (exit non-zero)"
else
    fail_test "Invalid decision enum rejected" "should have failed"
fi

# Manually inject an invalid decision into the registry
python3 -c "
import json
with open('$TEST_TMP/.agents/management/evidence/indexes/finding-decisions.json') as f:
    data = json.load(f)
data['decisions'].append({
    'id': 'FD-20260519-999',
    'tool': 'test',
    'findingFingerprint': 'a' * 64,
    'decision': 'BOGUS_VALUE',
    'decisionSeverity': 'YELLOW',
    'classification': 'test',
    'reason': 'invalid',
    'createdAt': '2026-05-19T00:00:00Z',
    'updatedAt': '2026-05-19T00:00:00Z',
    'status': 'active'
})
with open('$TEST_TMP/.agents/management/evidence/indexes/finding-decisions.json', 'w') as f:
    json.dump(data, f)
"

SCHEMA_VAL_OUTPUT=$(python3 "$TOOL" --dir "$TEST_TMP" validate 2>&1) || SCHEMA_VAL_RC=$?
SCHEMA_VAL_RC=${SCHEMA_VAL_RC:-0}

if [ "$SCHEMA_VAL_RC" -eq 2 ]; then
    pass_test "Invalid enum in registry detected by validate (exit 2)"
else
    fail_test "Invalid enum in registry detected by validate (exit 2)" "exit code: $SCHEMA_VAL_RC"
fi

# ============================================================
# Test 7: Scanner contract compliance
# ============================================================
echo ""
echo "--- Test 7: Scanner Contract Compliance ---"

# Simulate scanner behavior by testing different decision scenarios

# RED_ACTIVE scenario: fingerprint with no decision
setup_test_registry
NO_DECISION_FP=$(python3 "$TOOL" --dir "$TEST_TMP" match --fingerprint "abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890" 2>&1) || NO_DEC_RC=$?
NO_DEC_RC=${NO_DEC_RC:-0}

if [ "$NO_DEC_RC" -eq 1 ]; then
    pass_test "RED_ACTIVE: No decision => match returns non-zero"
else
    fail_test "RED_ACTIVE: No decision => match returns non-zero" "exit code: $NO_DEC_RC"
fi

# YELLOW_ACCEPTED scenario: ACCEPTED_EXCEPTION decision
setup_test_registry
python3 "$TOOL" --dir "$TEST_TMP" add \
    --tool "test" \
    --file "src/accepted.py" \
    --decision "ACCEPTED_EXCEPTION" \
    --reason "Accepted for testing" \
    --owner "tester" \
    --expiry "2099-12-31T23:59:59Z" \
    --mitigation "None needed" \
    2>/dev/null

ACCEPTED_FP=$(python3 -c "
import json
with open('$TEST_TMP/.agents/management/evidence/indexes/finding-decisions.json') as f:
    data = json.load(f)
print(data['decisions'][0]['findingFingerprint'])
")

MATCH_ACCEPTED=$(python3 "$TOOL" --dir "$TEST_TMP" match --fingerprint "$ACCEPTED_FP" 2>&1) || MATCH_A_RC=$?
MATCH_A_RC=${MATCH_A_RC:-0}

if [ "$MATCH_A_RC" -eq 0 ]; then
    pass_test "YELLOW_ACCEPTED: Decision exists => match returns 0"
else
    fail_test "YELLOW_ACCEPTED: Decision exists => match returns 0" "exit code: $MATCH_A_RC"
fi

# GREEN_FIXED scenario: FIXED decision
setup_test_registry
python3 "$TOOL" --dir "$TEST_TMP" add \
    --tool "test" \
    --file "src/fixed.py" \
    --decision "FIXED" \
    --reason "Root cause resolved" \
    --decision-severity "GREEN" \
    2>/dev/null

FIXED_FP=$(python3 -c "
import json
with open('$TEST_TMP/.agents/management/evidence/indexes/finding-decisions.json') as f:
    data = json.load(f)
print(data['decisions'][0]['findingFingerprint'])
")

MATCH_FIXED=$(python3 "$TOOL" --dir "$TEST_TMP" match --fingerprint "$FIXED_FP" 2>&1) || MATCH_F_RC=$?
MATCH_F_RC=${MATCH_F_RC:-0}

if [ "$MATCH_F_RC" -eq 0 ]; then
    pass_test "GREEN_FIXED: Fixed decision => match returns 0"
else
    fail_test "GREEN_FIXED: Fixed decision => match returns 0" "exit code: $MATCH_F_RC"
fi

# Expired => non-zero
setup_test_registry
python3 "$TOOL" --dir "$TEST_TMP" add \
    --tool "test" \
    --file "src/expired.py" \
    --decision "DEFERRED" \
    --reason "Test" \
    --expiry "2020-01-01T00:00:00Z" \
    --decision-severity "RED" \
    2>/dev/null

EXPIRED_MATCH=$(python3 "$TOOL" --dir "$TEST_TMP" expire-check 2>&1) || EXP_M_RC=$?
EXP_M_RC=${EXP_M_RC:-0}

if [ "$EXP_M_RC" -eq 2 ]; then
    pass_test "Expired decision => expire-check returns non-zero"
else
    fail_test "Expired decision => expire-check returns non-zero" "exit code: $EXP_M_RC"
fi

# ============================================================
# Summary
# ============================================================
echo ""
echo "============================================="
echo " FINDING LIFECYCLE RESULTS"
echo "============================================="
echo " Total:   $TOTAL"
echo " Passed:  $PASSED"
echo " Failed:  $FAILED"
echo " Warnings: $WARNED"
echo ""

if [ "$FAILED" -gt 0 ]; then
    echo "Status: RED"
    exit 1
elif [ "$WARNED" -gt 0 ]; then
    echo "Status: YELLOW"
    exit 2
else
    echo "Status: GREEN"
    exit 0
fi
