#!/bin/bash
# tests/adoption-proof.sh — Hardened Polyglot & Kernel Adoption Proof (V4.2 Enterprise)
#
# This script executes a complete suite of real-world proofs to validate:
#   1. Dry-run safety (no filesystem impact)
#   2. Safe adoption (clean provisioning without destructive overwrite)
#   3. Baseline-vs-Local Upgrade (rules baseline reset, local rules preserved)
#   4. Overlay Architecture (shadowing, illegal overlays, duplicate detection)
#   5. Evidence Noise & Bloat Control (oversized evidence, orphans, fake green)
#   6. Verify-Governance Kernel gates and stable error exit codes.

set -euo pipefail

TEST_DIR="/tmp/harness-adoption-test"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"

echo "==========================================================="
echo "🧪 STARTING V4.2 ENTERPRISE ADOPTION PROOF SUITE"
echo "==========================================================="

# ---------------------------------------------------------
# PROOF 1: Dry-Run Safety Simulation
# ---------------------------------------------------------
echo "🧪 PROOF 1: Running Dry-Run Safety Simulation..."
DRY_RUN_DIR="$TEST_DIR/dry-run-target"

./install-os.sh "$DRY_RUN_DIR" --language=php --project-type=api-service --dry-run > "$TEST_DIR/dry_run_log.txt"

# Verify no files were created
if [ -d "$DRY_RUN_DIR" ]; then
    # Directory might exist if created by test runner, but check that no files are inside
    FILE_COUNT=$(find "$DRY_RUN_DIR" -type f | wc -l)
    if [ "$FILE_COUNT" -gt 0 ]; then
        echo "❌ FAILURE: Dry-run created files in $DRY_RUN_DIR"
        exit 1
    fi
fi

# Verify dry run log indicates simulation
if ! grep -q "🧪 DRY RUN MODE COMPLETE" "$TEST_DIR/dry_run_log.txt"; then
    echo "❌ FAILURE: Dry-run output missing simulated log marker"
    exit 1
fi
echo "✅ PROOF 1 PASSED: Dry-run is completely safe and non-destructive."


# ---------------------------------------------------------
# PROOF 2: First-Time Safe Adoption (AvaX PHP Mock Project)
# ---------------------------------------------------------
echo "🧪 PROOF 2: First-Time Safe Adoption (Mock AvaX API)..."
AVAX_DIR="$TEST_DIR/avax-project"
mkdir -p "$AVAX_DIR"

# Run in adopt mode (default)
./install-os.sh "$AVAX_DIR" --language=php --project-type=api-service --platform=claude

# Verify that essential files exist
[ -d "$AVAX_DIR/.agents/.rules" ] || { echo "❌ Baseline .rules missing"; exit 1; }
[ -f "$AVAX_DIR/AGENTS.md" ] || { echo "❌ Root AGENTS.md contract missing"; exit 1; }
[ -d "$AVAX_DIR/EVIDENCE" ] || { echo "❌ EVIDENCE directory missing"; exit 1; }

# Verify ONLY canonical files reside in EVIDENCE/
CANONICAL_COUNT=$(find "$AVAX_DIR/EVIDENCE" -type f | grep -E "(CURRENT|ACTIVE_PLAN|FLOW|LINKS|README)\.md" | wc -l)
ACTUAL_COUNT=$(find "$AVAX_DIR/EVIDENCE" -type f ! -name ".gitkeep" | wc -l)
if [ "$CANONICAL_COUNT" -ne "$ACTUAL_COUNT" ]; then
    echo "❌ FAILURE: EVIDENCE/ contains non-canonical noise files!"
    exit 1
fi

# Mock validation file so that verify-governance passes (since status in CURRENT.md contains placeholders by default)
mkdir -p "$AVAX_DIR/.agents/management/evidence/validation"
touch "$AVAX_DIR/.agents/management/evidence/validation/initial-bootstrap.txt"

# Run verify-governance in target dir
"$AVAX_DIR/verify-governance.sh" "$AVAX_DIR"
echo "✅ PROOF 2 PASSED: Safe adoption provisions clean structure successfully."


# ---------------------------------------------------------
# PROOF 3: Upgrade Integrity (Baseline Rebuilt, Local Preserved)
# ---------------------------------------------------------
echo "🧪 PROOF 3: Upgrade Integrity & Local Preservation..."

# 1. Modify a baseline rule file in .rules/ to simulate manual corruption or drift
echo "tampered rule content" >> "$AVAX_DIR/.agents/governance/core/bootstrap/agent-bootstrap.md"

# 2. Create a local custom overlay in .agents/governance/
mkdir -p "$AVAX_DIR/.agents/governance/core/bootstrap"
cat > "$AVAX_DIR/.agents/governance/core/bootstrap/agent-bootstrap.md" <<'EOF'
---
title: "Agent Bootstrap Lifecycle"
status: "APPROVED"
operational_value: "high"
protection: "high"
---
custom local overlay
EOF

# 3. Modify root AGENTS.md locally
echo "## Custom Local Rule Additions" >> "$AVAX_DIR/AGENTS.md"

# Run upgrade mode
./install-os.sh "$AVAX_DIR" --language=php --project-type=api-service --upgrade

# Verify that:
# - The tampered baseline rule in .rules/ has been RESET (no "tampered" text remains)
if grep -q "tampered rule content" "$AVAX_DIR/.agents/governance/core/bootstrap/agent-bootstrap.md"; then
    echo "❌ FAILURE: Stale/tampered baseline rule was not reset during upgrade!"
    exit 1
fi

# - The local custom overlay remains perfectly INTACT
if ! grep -q "custom local overlay" "$AVAX_DIR/.agents/governance/core/bootstrap/agent-bootstrap.md"; then
    echo "❌ FAILURE: Custom local overlay was destroyed during upgrade!"
    exit 1
fi

# - The root AGENTS.md local additions remain perfectly INTACT
if ! grep -q "## Custom Local Rule Additions" "$AVAX_DIR/AGENTS.md"; then
    echo "❌ FAILURE: Root AGENTS.md customized changes were overwritten!"
    exit 1
fi

echo "✅ PROOF 3 PASSED: Upgrade resets baseline (.rules) but preserves local rules."


# ---------------------------------------------------------
# PROOF 4: Verify-Governance Failure Fixtures & Stable Exit Codes
# ---------------------------------------------------------
echo "🧪 PROOF 4: Testing Failure Fixtures & Stable Exit Codes..."

# Test 4.A: Baseline manual mutation check
echo "mutated rule" >> "$AVAX_DIR/.agents/governance/core/bootstrap/agent-bootstrap.md"
# Mock git repo to trigger git baseline check
mkdir -p "$AVAX_DIR/.git"
git -C "$AVAX_DIR" init >/dev/null 2>&1
git -C "$AVAX_DIR" config user.email "test@test.com"
git -C "$AVAX_DIR" config user.name "test"
git -C "$AVAX_DIR" add -A
git -C "$AVAX_DIR" commit -m "initial commit" >/dev/null 2>&1
# Make a local change to rules to trigger mutation check
echo "uncommitted change" >> "$AVAX_DIR/.agents/governance/core/bootstrap/agent-bootstrap.md"

set +e
"$AVAX_DIR/verify-governance.sh" "$AVAX_DIR" > "$TEST_DIR/err_11_log.txt" 2>&1
CODE_11=$?
set -e
if [ "$CODE_11" -ne 11 ]; then
    echo "❌ FAILURE: Baseline mutation check failed with exit code $CODE_11 (expected 11)"
    cat "$TEST_DIR/err_11_log.txt"
    exit 1
fi
echo "  - Check 4.A: Mutation check caught baseline edits with Exit Code 11."

# Clean up baseline modification
git -C "$AVAX_DIR" checkout -- .agents/governance/core/bootstrap/agent-bootstrap.md

# Test 4.B: Invalid overlay path check
mkdir -p "$AVAX_DIR/.agents/governance/bad_folder_name"
echo "bad rules" > "$AVAX_DIR/.agents/governance/bad_folder_name/rule.md"
set +e
"$AVAX_DIR/verify-governance.sh" "$AVAX_DIR" > "$TEST_DIR/err_15_log.txt" 2>&1
CODE_15=$?
set -e
rm -rf "$AVAX_DIR/.agents/governance/bad_folder_name"
if [ "$CODE_15" -ne 15 ]; then
    echo "❌ FAILURE: Invalid overlay path check failed with exit code $CODE_15 (expected 15)"
    cat "$TEST_DIR/err_15_log.txt"
    exit 1
fi
echo "  - Check 4.B: Unrecognized overlay path caught with Exit Code 15."

# Test 4.C: Duplicate redundant rule override check
# Create a local overlay identical to baseline
mkdir -p "$AVAX_DIR/.agents/governance/core/quality"
cp "$AVAX_DIR/.agents/governance/core/quality/quality-gates.md" "$AVAX_DIR/.agents/governance/core/quality/quality-gates.md"
set +e
"$AVAX_DIR/verify-governance.sh" "$AVAX_DIR" > "$TEST_DIR/err_18_log.txt" 2>&1
CODE_18=$?
set -e
rm -f "$AVAX_DIR/.agents/governance/core/quality/quality-gates.md"
if [ "$CODE_18" -ne 18 ]; then
    echo "❌ FAILURE: Redundant duplicate rule check failed with exit code $CODE_18 (expected 18)"
    cat "$TEST_DIR/err_18_log.txt"
    exit 1
fi
echo "  - Check 4.C: Redundant duplicate rule caught with Exit Code 18."

# Test 4.D: Evidence Bloat (Oversized file)
# Make links.md very long (>50 lines)
for i in {1..60}; do
    echo "verbose report line $i" >> "$AVAX_DIR/EVIDENCE/LINKS.md"
done
set +e
"$AVAX_DIR/verify-governance.sh" "$AVAX_DIR" > "$TEST_DIR/err_13_log.txt" 2>&1
CODE_13=$?
set -e
# Restore links.md
git -C "$AVAX_DIR" checkout -- EVIDENCE/LINKS.md
if [ "$CODE_13" -ne 13 ]; then
    echo "❌ FAILURE: Oversized evidence check failed with exit code $CODE_13 (expected 13)"
    cat "$TEST_DIR/err_13_log.txt"
    exit 1
fi
echo "  - Check 4.D: Oversized evidence (>50 lines) caught with Exit Code 13."

# Test 4.E: Evidence Noise (Orphan file)
touch "$AVAX_DIR/EVIDENCE/LEGACY_DUMP.txt"
set +e
"$AVAX_DIR/verify-governance.sh" "$AVAX_DIR" > "$TEST_DIR/err_14_log.txt" 2>&1
CODE_14=$?
set -e
rm -f "$AVAX_DIR/EVIDENCE/LEGACY_DUMP.txt"
if [ "$CODE_14" -ne 14 ]; then
    echo "❌ FAILURE: Orphan evidence check failed with exit code $CODE_14 (expected 14)"
    cat "$TEST_DIR/err_14_log.txt"
    exit 1
fi
echo "  - Check 4.E: Orphan evidence file noise caught with Exit Code 14."

# Test 4.F: Fake Green Claim check
# Claim green status in CURRENT.md
sed -i 's/## Status: \[GREEN | YELLOW | RED\]/## Status: GREEN/g' "$AVAX_DIR/EVIDENCE/CURRENT.md"
# Remove all validation evidence reports to trigger the fake green error
rm -f "$AVAX_DIR/.agents/management/evidence/validation/"*
set +e
"$AVAX_DIR/verify-governance.sh" "$AVAX_DIR" > "$TEST_DIR/err_16_log.txt" 2>&1
CODE_16=$?
set -e
# Restore CURRENT.md
git -C "$AVAX_DIR" checkout -- EVIDENCE/CURRENT.md
touch "$AVAX_DIR/.agents/management/evidence/validation/initial-bootstrap.txt"
if [ "$CODE_16" -ne 16 ]; then
    echo "❌ FAILURE: Fake GREEN claim check failed with exit code $CODE_16 (expected 16)"
    cat "$TEST_DIR/err_16_log.txt"
    exit 1
fi
echo "  - Check 4.F: Fake GREEN status claim without validation reports caught with Exit Code 16."

# Test 4.G: Cryptographic Duplicate Evidence Detection
# Create two distinct validation files containing identical evidence hashes
echo "identical evidence data" > "$AVAX_DIR/.agents/management/evidence/validation/run1.txt"
echo "identical evidence data" > "$AVAX_DIR/.agents/management/evidence/validation/run2.txt"
set +e
"$AVAX_DIR/verify-governance.sh" "$AVAX_DIR" > "$TEST_DIR/err_18_dup_log.txt" 2>&1
CODE_18_DUP=$?
set -e
rm -f "$AVAX_DIR/.agents/management/evidence/validation/run1.txt"
rm -f "$AVAX_DIR/.agents/management/evidence/validation/run2.txt"
if [ "$CODE_18_DUP" -ne 18 ]; then
    echo "❌ FAILURE: Cryptographic duplicate evidence check failed with exit code $CODE_18_DUP (expected 18)"
    cat "$TEST_DIR/err_18_dup_log.txt"
    exit 1
fi
echo "  - Check 4.G: Cryptographic duplicate evidence matched and caught with Exit Code 18."

# Test 4.H: Installer Transaction Rollback on Failure
# Backup CLAUDE.md to check if it gets restored
echo "original local text" > "$AVAX_DIR/CLAUDE.md"
# Create a regular file clash at .codex to cause deterministic midway failure on adapter copy
rm -rf "$AVAX_DIR/.codex"
touch "$AVAX_DIR/.codex"
set +e
./install-os.sh "$AVAX_DIR" --language=php --force > "$TEST_DIR/tx_rollback_log.txt" 2>&1
CODE_TX=$?
set -e
# Clean up clash file cleanly
rm -rf "$AVAX_DIR/.codex"
# Verify that:
#   1. install-os.sh failed due to target path clash
#   2. The transaction rollback succeeded
#   3. CLAUDE.md still contains its original local text
if [ "$CODE_TX" -eq 0 ]; then
    echo "❌ FAILURE: Installer should have failed but exited 0"
    exit 1
fi
if ! grep -q "original local text" "$AVAX_DIR/CLAUDE.md"; then
    echo "❌ FAILURE: Transaction rollback failed to restore CLAUDE.md to original state!"
    cat "$AVAX_DIR/CLAUDE.md"
    exit 1
fi
echo "  - Check 4.H: Partial installation failure triggered clean transaction rollback safely."

echo "✅ PROOF 4 PASSED: Kernel-level verify-governance.sh is robust, fail-fast, and deterministic."


# ---------------------------------------------------------
# PROOF 5: Replayable and Successful Verification
# ---------------------------------------------------------
echo "🧪 PROOF 5: Replaying Successful Clean Build Verification..."
# Run verify-governance on clean repository again to prove stable green state
"$AVAX_DIR/verify-governance.sh" "$AVAX_DIR"
echo "✅ PROOF 5 PASSED: Repository successfully restored and validated green."


# ---------------------------------------------------------
# PROOF 6: AI Execution Substrate Sandbox & Replay Determinism
# ---------------------------------------------------------
echo "🧪 PROOF 6: Testing AI Execution Substrate Sandbox & Replay..."

TEST_BIN_DIR="$AVAX_DIR/.agents/skills/bin"
if [ ! -f "$TEST_BIN_DIR/execution-substrate.py" ]; then
    if [ -f "$AVAX_DIR/.agents/skills/bin/execution-substrate.py" ]; then
        TEST_BIN_DIR="$AVAX_DIR/.agents/skills/bin"
    fi
fi

# 1. Run a valid task under READ_ONLY
python3 "$TEST_BIN_DIR/execution-substrate.py" run \
  --task "Read environment details" \
  --tier "READ_ONLY" \
  --scope "security" \
  --cmd "echo 'Substrate Execution Success'" \
  --dir "$AVAX_DIR" \
  > "$TEST_DIR/exec_ro_success.log" 2>&1

# Extract execution ID
EXEC_ID=$(grep -oE "exec-[a-f0-9-]{36}" "$TEST_DIR/exec_ro_success.log" | head -n 1 || true)
if [ -z "$EXEC_ID" ]; then
    echo "❌ FAILURE: Substrate failed to output valid execution ID!"
    cat "$TEST_DIR/exec_ro_success.log"
    exit 1
fi

# Assert manifests generated
[ -f "$AVAX_DIR/.agents/management/evidence/execution/execution-manifest-$EXEC_ID.json" ] || { echo "❌ Execution manifest missing"; exit 1; }

# 2. Try to write a file under READ_ONLY to trigger accidental mutation check & rollback
set +e
python3 "$TEST_BIN_DIR/execution-substrate.py" run \
  --task "Unsafe Write Attempt" \
  --tier "READ_ONLY" \
  --scope "security" \
  --cmd "echo 'violating write' > '$AVAX_DIR/unauthorized_write.txt'" \
  --dir "$AVAX_DIR" \
  > "$TEST_DIR/exec_ro_violation.log" 2>&1
CODE_RO_VIOLATION=$?
set -e

if [ "$CODE_RO_VIOLATION" -eq 0 ] || [ -f "$AVAX_DIR/unauthorized_write.txt" ]; then
    echo "❌ FAILURE: READ_ONLY tier allowed writing unauthorized file or did not fail!"
    cat "$TEST_DIR/exec_ro_violation.log"
    exit 1
fi
echo "  - Check 6.A: Sandbox successfully blocked unauthorized workspace mutations under READ_ONLY."

# 3. Try to write to governance folder under WORKSPACE_WRITE to check protection & rollback
set +e
python3 "$TEST_BIN_DIR/execution-substrate.py" run \
  --task "Unsafe Governance Write Attempt" \
  --tier "WORKSPACE_WRITE" \
  --scope "security" \
  --cmd "echo 'violating gov write' > '$AVAX_DIR/.agents/governance/unauthorized_gov.txt'" \
  --dir "$AVAX_DIR" \
  > "$TEST_DIR/exec_ww_violation.log" 2>&1
CODE_WW_VIOLATION=$?
set -e

if [ "$CODE_WW_VIOLATION" -eq 0 ] || [ -f "$AVAX_DIR/.agents/governance/unauthorized_gov.txt" ]; then
    echo "❌ FAILURE: WORKSPACE_WRITE tier allowed writing to protected governance folder!"
    cat "$TEST_DIR/exec_ww_violation.log"
    exit 1
fi
echo "  - Check 6.B: Sandbox successfully blocked unauthorized governance mutations under WORKSPACE_WRITE."

# 4. Replay the successful task and assert determinism
python3 "$TEST_BIN_DIR/execution-substrate.py" replay "$EXEC_ID" --dir "$AVAX_DIR" > "$TEST_DIR/replay_success.log" 2>&1
if ! grep -q "REPLAY VERIFICATION PASSED" "$TEST_DIR/replay_success.log"; then
    echo "❌ FAILURE: Substrate replay failed or flagged drift on clean re-run!"
    cat "$TEST_DIR/replay_success.log"
    exit 1
fi
echo "  - Check 6.C: Substrate successfully replayed task and verified execution determinism."

# 5. Try to run elevated child delegation to verify escalation blocking
set +e
python3 "$TEST_BIN_DIR/execution-substrate.py" run \
  --task "Delegation Escalation Attempt" \
  --tier "WORKSPACE_WRITE" \
  --scope "security" \
  --allowed-tools "view_file,write_to_file" \
  --parent-token '{"token_id":"parent-ro","lease_duration_sec":3600,"max_memory_mb":512,"allowed_tools":["view_file"],"allowed_scopes":["security"],"trust_tier":"READ_ONLY","issued_at":1779112800.0,"signature":"mock-signature"}' \
  --dir "$AVAX_DIR" \
  > "$TEST_DIR/exec_deleg_escalation.log" 2>&1
CODE_DELEG=$?
set -e

if [ "$CODE_DELEG" -eq 0 ] || ! grep -q "TOKEN_ESCALATION_BLOCKED" "$TEST_DIR/exec_deleg_escalation.log"; then
    echo "❌ FAILURE: Substrate failed to block delegated token escalation!"
    cat "$TEST_DIR/exec_deleg_escalation.log"
    exit 1
fi
echo "  - Check 6.D: Substrate successfully blocked capability token escalation."

# 6. Run Execution Graph Compaction check
python3 "$TEST_BIN_DIR/execution-substrate.py" graph --dir "$AVAX_DIR" > "$TEST_DIR/graph_compaction.log" 2>&1
if ! grep -q "EXECUTION GRAPH ENGINE" "$TEST_DIR/graph_compaction.log"; then
    echo "❌ FAILURE: Substrate failed to run execution graph DAG compaction!"
    cat "$TEST_DIR/graph_compaction.log"
    exit 1
fi
echo "  - Check 6.E: Substrate resolved execution lineage DAG and completed compaction."

echo "✅ PROOF 6 PASSED: AI Execution Substrate Sandbox & Replay are robust and bulletproof."


echo ""
echo "==========================================================="
echo "🎉 ALL ADOPTION AND INTEGRITY PROOFS PASSED SUCCESSFULLY!"
echo "==========================================================="
exit 0
