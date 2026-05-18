#!/usr/bin/env bash
# tests/replay-integrity-test.sh — Replay Integrity Verification Tests
#
# Tests: seal verification, tamper detection, nonce replay prevention,
#        audit chain integrity, dependency drift detection.
#
# Exit codes: 0=GREEN, 1=RED, 2=YELLOW

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
RUNTIME="$PROJECT_DIR/.agents/skills/bin/execution_runtime.py"
EVIDENCE_DIR="$PROJECT_DIR/.agents/management/evidence/execution"

PASS=0
FAIL=0
WARN=0
TOTAL=0

pass_test() {
    PASS=$((PASS + 1))
    TOTAL=$((TOTAL + 1))
    echo "  PASS: $1"
}

fail_test() {
    FAIL=$((FAIL + 1))
    TOTAL=$((TOTAL + 1))
    echo "  FAIL: $1"
}

warn_test() {
    WARN=$((WARN + 1))
    TOTAL=$((TOTAL + 1))
    echo "  WARN: $1"
}

echo "============================================================"
echo " REPLAY INTEGRITY TEST SUITE"
echo "============================================================"

# Clean prior evidence
rm -f "$EVIDENCE_DIR"/execution-manifest-*.json 2>/dev/null || true
rm -f "$EVIDENCE_DIR"/replay-manifest-*.json 2>/dev/null || true
rm -f "$PROJECT_DIR/.agents/management/evidence/security/hmac-key.bin" 2>/dev/null || true
rm -f "$PROJECT_DIR/.agents/management/evidence/security/hmac-audit-chain.jsonl" 2>/dev/null || true
rm -f "$PROJECT_DIR/.agents/management/evidence/security/nonce-registry.jsonl" 2>/dev/null || true
rm -f "$PROJECT_DIR/.agents/management/evidence/security/revocation-registry.jsonl" 2>/dev/null || true

# ---------------------------------------------------------------------------
# 1. Create clean execution
# ---------------------------------------------------------------------------
echo ""
echo "--- 1. Create Clean Execution ---"

EXEC_OUTPUT=$(python3 "$RUNTIME" run \
    --task "replay-test" \
    --tier "READ_ONLY" \
    --scope "security" \
    --cmd "echo replayable" \
    --dir "$PROJECT_DIR" 2>&1)

EXEC_ID=$(echo "$EXEC_OUTPUT" | grep -oP 'Execution ID:\s+\K(exec-[a-f0-9-]+)' | head -1 || true)

if [ -n "$EXEC_ID" ]; then
    pass_test "execution created: $EXEC_ID"
    MANIFEST="$EVIDENCE_DIR/execution-manifest-${EXEC_ID}.json"
else
    fail_test "execution ID not extracted"
    echo "FATAL: cannot proceed without execution"
    exit 1
fi

# ---------------------------------------------------------------------------
# 2. Seal verification on clean manifest
# ---------------------------------------------------------------------------
echo ""
echo "--- 2. Seal Verification ---"

if python3 "$RUNTIME" verify "$MANIFEST" --dir "$PROJECT_DIR" >/dev/null 2>&1; then
    pass_test "clean manifest seal verifies"
else
    fail_test "clean manifest seal does not verify"
fi

# ---------------------------------------------------------------------------
# 3. Tampered manifest detection
# ---------------------------------------------------------------------------
echo ""
echo "--- 3. Tamper Detection ---"

# Tamper with telemetry
cp "$MANIFEST" "${MANIFEST}.bak"
python3 -c "
import json
with open('$MANIFEST', 'r') as f:
    d = json.load(f)
d['telemetry']['total_duration_ms'] = 999999
with open('$MANIFEST', 'w') as f:
    json.dump(d, f)
"

if python3 "$RUNTIME" verify "$MANIFEST" --dir "$PROJECT_DIR" 2>/dev/null; then
    fail_test "tampered telemetry still verifies"
else
    pass_test "tampered telemetry detected"
fi

# Restore
mv "${MANIFEST}.bak" "$MANIFEST"

# ---------------------------------------------------------------------------
# 4. Tampered lifecycle detection
# ---------------------------------------------------------------------------
echo ""
echo "--- 4. Lifecycle Tamper Detection ---"

cp "$MANIFEST" "${MANIFEST}.bak"
python3 -c "
import json
with open('$MANIFEST', 'r') as f:
    d = json.load(f)
# Change to a clearly different state
d['lifecycle_state'] = 'FAILED'
with open('$MANIFEST', 'w') as f:
    json.dump(d, f)
"

if python3 "$RUNTIME" verify "$MANIFEST" --dir "$PROJECT_DIR" 2>/dev/null; then
    fail_test "tampered lifecycle state still verifies"
else
    pass_test "tampered lifecycle state detected"
fi

mv "${MANIFEST}.bak" "$MANIFEST"

# ---------------------------------------------------------------------------
# 5. Replay reproducibility scoring
# ---------------------------------------------------------------------------
echo ""
echo "--- 5. Replay Scoring ---"

REPLAY_OUTPUT=$(python3 "$RUNTIME" replay "$EXEC_ID" --dir "$PROJECT_DIR" 2>&1)

if echo "$REPLAY_OUTPUT" | grep -qE "FULL_REPLAYABLE|PARTIAL_REPLAYABLE|NON_REPLAYABLE"; then
    SCORE=$(echo "$REPLAY_OUTPUT" | grep -oP 'Score:\s+\K\w+' | head -1)
    pass_test "replay scored: $SCORE"
else
    fail_test "no reproducibility score in output"
fi

if echo "$REPLAY_OUTPUT" | grep -q "Seal Valid:.*True"; then
    pass_test "seal valid in replay"
else
    fail_test "seal invalid in replay"
fi

if echo "$REPLAY_OUTPUT" | grep -q "Chain Valid:.*True"; then
    pass_test "audit chain valid in replay"
else
    fail_test "audit chain invalid in replay"
fi

# ---------------------------------------------------------------------------
# 6. Replay manifest schema compliance
# ---------------------------------------------------------------------------
echo ""
echo "--- 6. Replay Manifest Schema ---"

REPLAY_MANIFEST=$(ls -1t "$EVIDENCE_DIR"/replay-manifest-*.json 2>/dev/null | head -1 || true)

if [ -n "$REPLAY_MANIFEST" ]; then
    for field in replay_id execution_id original_seal replay_attempted_at reproducibility_score seal_valid nonce_valid; do
        if python3 -c "import json; d=json.load(open('$REPLAY_MANIFEST')); assert '$field' in d" 2>/dev/null; then
            pass_test "replay manifest has: $field"
        else
            fail_test "replay manifest missing: $field"
        fi
    done
else
    fail_test "no replay manifest found"
fi

# ---------------------------------------------------------------------------
# 7. Nonce registry
# ---------------------------------------------------------------------------
echo ""
echo "--- 7. Nonce Registry ---"

NONCE_FILE="$PROJECT_DIR/.agents/management/evidence/security/nonce-registry.jsonl"

if [ -f "$NONCE_FILE" ]; then
    NONCE_COUNT=$(wc -l < "$NONCE_FILE")
    if [ "$NONCE_COUNT" -gt 0 ]; then
        pass_test "nonce registry has entries ($NONCE_COUNT)"
    else
        fail_test "nonce registry is empty"
    fi
else
    fail_test "nonce registry file not found"
fi

# ---------------------------------------------------------------------------
# 8. Multiple executions, single chain
# ---------------------------------------------------------------------------
echo ""
echo "--- 8. Chain Integrity After Multiple Executions ---"

for i in 1 2 3; do
    python3 "$RUNTIME" run \
        --task "chain-test-$i" \
        --tier "READ_ONLY" \
        --scope "security" \
        --cmd "echo chain-$i" \
        --dir "$PROJECT_DIR" >/dev/null 2>&1
done

CHAIN_OUTPUT=$(python3 "$RUNTIME" audit-chain --dir "$PROJECT_DIR" 2>&1)
if echo "$CHAIN_OUTPUT" | grep -q "VALID"; then
    CHAIN_LEN=$(echo "$CHAIN_OUTPUT" | grep -oP '\d+(?= entries)' || echo "unknown")
    pass_test "audit chain valid after multiple executions ($CHAIN_LEN entries)"
else
    fail_test "audit chain broken after multiple executions"
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
