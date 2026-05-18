#!/usr/bin/env bash
# delegation-runtime-proof.sh — V6 Delegation Token Validation
#
# Validates that delegation tokens properly narrow permissions.
# Referenced by verify-governance.sh but was missing.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$SCRIPT_DIR"
RUNTIME="$BIN_DIR/execution_runtime.py"
TARGET_DIR="${RUNTIME_TARGET_DIR:-.}"
PASS=0
FAIL=0

echo "============================================================"
echo " DELEGATION RUNTIME PROOF"
echo "============================================================"

# Test 1: Parent token with broad scope delegates to child with narrow scope
echo ""
echo "--- 1. Narrowing Delegation ---"
PARENT_TOKEN=$(python3 -c "
import sys; sys.path.insert(0, '$BIN_DIR')
from execution_runtime import CapabilityToken
token = CapabilityToken(
    token_id='parent-test',
    lease_duration=3600,
    max_memory_mb=1024,
    allowed_tools=['view_file', 'write_to_file', 'search_web'],
    allowed_scopes=['security', 'operations', 'architecture'],
    trust_tier='GOVERNANCE_WRITE',
)
import json; print(json.dumps(token.to_dict()))
")

# Create child with narrower scope
CHILD_RESULT=$(python3 -c "
import sys, json; sys.path.insert(0, '$BIN_DIR')
from execution_runtime import CapabilityToken
parent = CapabilityToken.from_dict(json.loads('$PARENT_TOKEN'))
child = CapabilityToken(
    token_id='child-test',
    lease_duration=600,
    max_memory_mb=512,
    allowed_tools=['view_file'],
    allowed_scopes=['security'],
    trust_tier='READ_ONLY',
)
ok, msg = parent.validate_delegation(child)
print(json.dumps({'valid': ok, 'msg': msg}))
")

if echo "$CHILD_RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); assert d['valid']"; then
    echo "  PASS: Narrowing delegation validated"
    PASS=$((PASS + 1))
else
    echo "  FAIL: Narrowing delegation rejected"
    FAIL=$((FAIL + 1))
fi

# Test 2: Escalation attempt should be blocked
echo ""
echo "--- 2. Escalation Blocked ---"
ESCALATION_RESULT=$(python3 -c "
import sys, json; sys.path.insert(0, '$BIN_DIR')
from execution_runtime import CapabilityToken
parent = CapabilityToken(
    token_id='parent-esc',
    lease_duration=3600,
    max_memory_mb=512,
    allowed_tools=['view_file'],
    allowed_scopes=['security'],
    trust_tier='READ_ONLY',
)
child = CapabilityToken(
    token_id='child-esc',
    lease_duration=600,
    max_memory_mb=1024,
    allowed_tools=['view_file', 'write_to_file', 'admin'],
    allowed_scopes=['security', 'operations'],
    trust_tier='TRUSTED',
)
ok, msg = parent.validate_delegation(child)
print(json.dumps({'valid': ok, 'msg': msg}))
")

if echo "$ESCALATION_RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); assert not d['valid']"; then
    echo "  PASS: Escalation blocked"
    PASS=$((PASS + 1))
else
    echo "  FAIL: Escalation was allowed"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "============================================================"
echo " RESULTS: $PASS passed, $FAIL failed"
echo "============================================================"

if [ "$FAIL" -gt 0 ]; then
    echo "Status: RED"
    exit 1
else
    echo "Status: GREEN"
    exit 0
fi
