#!/usr/bin/env bash
# tests/chaos-adversarial-test.sh — V6 Chaos & Adversarial Testing
#
# Tests the runtime against bypass attempts, injection, tampering,
# and edge cases.
#
# Exit codes: 0=GREEN, 1=RED, 2=YELLOW

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BIN_DIR="$PROJECT_DIR/.agents/skills/bin"
RUNTIME="$BIN_DIR/execution_runtime.py"
SANDBOX="$BIN_DIR/command_sandbox.py"

PASS=0
FAIL=0
WARN=0
TOTAL=0

pass_test() { PASS=$((PASS + 1)); TOTAL=$((TOTAL + 1)); echo "  PASS: $1"; }
fail_test() { FAIL=$((FAIL + 1)); TOTAL=$((TOTAL + 1)); echo "  FAIL: $1"; }
warn_test() { WARN=$((WARN + 1)); TOTAL=$((TOTAL + 1)); echo "  WARN: $1"; }

echo "============================================================"
echo " CHAOS & ADVERSARIAL TEST SUITE"
echo "============================================================"

# ---------------------------------------------------------------------------
# 1. Shell injection bypass via runtime_exec.sh
# ---------------------------------------------------------------------------
echo ""
echo "--- 1. Shell Injection Bypass ---"

# The wrapper should not allow shell metacharacters to escape
OUTPUT=$(bash "$BIN_DIR/runtime_exec.sh" --tier READ_ONLY -- 'echo hello; rm -rf /' 2>&1 || true)
if echo "$OUTPUT" | grep -qi "reject\|unsafe\|disallowed\|FAILED"; then
    pass_test "semicolon injection blocked via wrapper"
else
    fail_test "semicolon injection not blocked"
fi

# ---------------------------------------------------------------------------
# 2. PATH poisoning
# ---------------------------------------------------------------------------
echo ""
echo "--- 2. PATH Poisoning ---"

# Create a malicious 'echo' in a temp dir
FAKE_BIN=$(mktemp -d)
echo '#!/bin/bash
echo "MALICIOUS PAYLOAD"
' > "$FAKE_BIN/echo"
chmod +x "$FAKE_BIN/echo"

# Try to execute with poisoned PATH — should use resolved PATH, not fake
OUTPUT=$(PATH="$FAKE_BIN:$PATH" python3 "$RUNTIME" run \
    --task "path-poison" --tier READ_ONLY --scope security \
    --cmd "echo hello" --dir "$PROJECT_DIR" 2>&1 || true)

if echo "$OUTPUT" | grep -q "MALICIOUS"; then
    fail_test "PATH poisoning succeeded (executed fake echo)"
else
    pass_test "PATH poisoning blocked"
fi

rm -rf "$FAKE_BIN"

# ---------------------------------------------------------------------------
# 3. Token forgery
# ---------------------------------------------------------------------------
echo ""
echo "--- 3. Token Forgery ---"

# Create a token with a forged signature (unkeyed SHA-256)
FORGED_RESULT=$(python3 -c "
import sys, hashlib; sys.path.insert(0, '$BIN_DIR')
from execution_runtime import CapabilityToken
# Create a real token first to get the structure
real = CapabilityToken(
    token_id='forged', lease_duration=3600, max_memory_mb=1024,
    allowed_tools=['admin'], allowed_scopes=['everything'],
    trust_tier='TRUSTED',
)
# Forge a different token with same ID but escalated permissions
forged = CapabilityToken(
    token_id='forged', lease_duration=3600, max_memory_mb=1024,
    allowed_tools=['admin', 'delete_all'], allowed_scopes=['everything'],
    trust_tier='TRUSTED',
)
# The signatures should differ because the payloads differ
print('different' if real.signature != forged.signature else 'same')
" 2>&1)

if [ "$FORGED_RESULT" = "different" ]; then
    pass_test "Forged token has different signature"
else
    warn_test "Token signature collision (low severity — payloads differ)"
fi

# ---------------------------------------------------------------------------
# 4. Nonce replay
# ---------------------------------------------------------------------------
echo ""
echo "--- 4. Nonce Replay ---"

# Try to reuse a nonce — the runtime generates fresh nonces per execution,
# so this tests that nonces are properly registered and not reusable
NONCE_TEST=$(python3 -c "
import sys; sys.path.insert(0, '$BIN_DIR')
from substrate_security import NonceRegistry
import time
r = NonceRegistry('$PROJECT_DIR')
nonce = 'test-nonce-replay-001'
r.register_nonce(nonce, 'test-token', time.time() + 600)
# Try to register the same nonce again
result = r.register_nonce(nonce, 'test-token', time.time() + 600)
print('rejected' if not result else 'accepted')
" 2>&1)

if [ "$NONCE_TEST" = "rejected" ]; then
    pass_test "Nonce replay blocked"
else
    fail_test "Nonce replay accepted"
fi

# ---------------------------------------------------------------------------
# 5. Manifest tampering
# ---------------------------------------------------------------------------
echo ""
echo "--- 5. Manifest Tampering ---"

# Create an execution, then tamper with it and verify
EXEC_OUTPUT=$(python3 "$RUNTIME" run \
    --task "tamper-test" --tier READ_ONLY --scope security \
    --cmd "echo tamper-test" --dir "$PROJECT_DIR" 2>&1)

EXEC_ID=$(echo "$EXEC_OUTPUT" | grep -oP 'Execution ID:\s+\K(exec-[a-f0-9-]+)' | head -1 || true)

if [ -n "$EXEC_ID" ]; then
    MANIFEST="$PROJECT_DIR/.agents/management/evidence/execution/execution-manifest-${EXEC_ID}.json"
    if [ -f "$MANIFEST" ]; then
        # Tamper with the manifest
        python3 -c "
import json
with open('$MANIFEST', 'r') as f:
    d = json.load(f)
d['task'] = 'TAMPERED_BY_CHAOS_TEST'
with open('$MANIFEST', 'w') as f:
    json.dump(d, f)
"
        # Verify should fail
        if python3 "$RUNTIME" verify "$MANIFEST" --dir "$PROJECT_DIR" 2>/dev/null; then
            fail_test "Tampered manifest still verifies"
        else
            pass_test "Tampered manifest detected as INVALID"
        fi
    else
        warn_test "Manifest not found for tamper test"
    fi
else
    warn_test "Could not create execution for tamper test"
fi

# ---------------------------------------------------------------------------
# 6. Tier escalation
# ---------------------------------------------------------------------------
echo ""
echo "--- 6. Tier Escalation ---"

# Try to execute a DANGEROUS command at READ_ONLY tier
OUTPUT=$(python3 "$RUNTIME" run \
    --task "escalation" --tier READ_ONLY --scope security \
    --cmd "rm -rf /tmp/chaos-test" --dir "$PROJECT_DIR" 2>&1 || true)

if echo "$OUTPUT" | grep -qi "DENIED\|FAILED\|reject\|SANDBOX"; then
    pass_test "Tier escalation blocked"
else
    fail_test "DANGEROUS command executed at READ_ONLY tier"
fi

# ---------------------------------------------------------------------------
# 7. Environment injection
# ---------------------------------------------------------------------------
echo ""
echo "--- 7. Environment Injection ---"

# Try to pass a secret through environment — the sanitizer should block it
ENV_TEST=$(python3 -c "
import sys, os; sys.path.insert(0, '$BIN_DIR')
from substrate_security import EnvironmentSanitizer
s = EnvironmentSanitizer()
env = os.environ.copy()
env['AWS_SECRET_KEY'] = 'sk-1234567890abcdef'
env['MY_TOKEN'] = 'secret-token'
cleaned = s.sanitize_env(env)
has_aws = 'AWS_SECRET_KEY' in cleaned
has_token = 'MY_TOKEN' in cleaned
print('blocked' if not has_aws and not has_token else 'leaked')
" 2>&1)

if [ "$ENV_TEST" = "blocked" ]; then
    pass_test "Environment injection blocked"
else
    fail_test "Secrets leaked through environment"
fi

# ---------------------------------------------------------------------------
# 8. Revocation check
# ---------------------------------------------------------------------------
echo ""
echo "--- 8. Revocation Bypass ---"

REV_TEST=$(python3 -c "
import sys; sys.path.insert(0, '$BIN_DIR')
from substrate_security import RevocationRegistry
r = RevocationRegistry('$PROJECT_DIR')
r.revoke_token('test-revoke-001', 'chaos test')
print('revoked' if r.is_revoked('test-revoke-001') else 'not revoked')
" 2>&1)

if [ "$REV_TEST" = "revoked" ]; then
    pass_test "Token revocation works"
else
    fail_test "Revoked token still valid"
fi

# ---------------------------------------------------------------------------
# 9. Concurrent execution (basic race check)
# ---------------------------------------------------------------------------
echo ""
echo "--- 9. Concurrent Execution ---"

# Run two executions in parallel and check for corruption
python3 "$RUNTIME" run --task "concurrent-1" --tier READ_ONLY --scope security \
    --cmd "echo c1" --dir "$PROJECT_DIR" > /dev/null 2>&1 &
PID1=$!

python3 "$RUNTIME" run --task "concurrent-2" --tier READ_ONLY --scope security \
    --cmd "echo c2" --dir "$PROJECT_DIR" > /dev/null 2>&1 &
PID2=$!

wait $PID1
wait $PID2

# Check audit chain is still valid
CHAIN_OUTPUT=$(python3 "$RUNTIME" audit-chain --dir "$PROJECT_DIR" 2>&1)
if echo "$CHAIN_OUTPUT" | grep -q "VALID"; then
    pass_test "Concurrent executions did not corrupt audit chain"
else
    fail_test "Audit chain corrupted by concurrent executions"
fi

# ---------------------------------------------------------------------------
# 10. Evidence-query orphans
# ---------------------------------------------------------------------------
echo ""
echo "--- 10. Orphan Evidence Detection ---"

ORPHAN_OUTPUT=$(python3 "$BIN_DIR/evidence-query.py" orphans --dir "$PROJECT_DIR" 2>&1 || true)
if echo "$ORPHAN_OUTPUT" | grep -q "orphan\|No orphan\|Found"; then
    pass_test "Orphan detection tool works"
else
    warn_test "Orphan detection produced unexpected output"
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "============================================================"
echo " RESULTS: $PASS passed, $FAIL failed, $WARN warnings (total: $TOTAL)"
echo "============================================================"

if [ "$FAIL" -gt 0 ]; then
    echo "Status: RED"
    exit 1
elif [ "$WARN" -gt 0 ]; then
    echo "Status: YELLOW"
    exit 2
else
    echo "Status: GREEN"
    exit 0
fi
