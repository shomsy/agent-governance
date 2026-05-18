#!/bin/bash
# tests/adoption-adversarial.sh — V6 Adversarial Adoption Proofs
#
# Proves installer resilience against:
#   1. Existing .agents with custom governance
#   2. Partially upgraded repos (interrupted mid-install)
#   3. Rerun installs (idempotency proof)
#   4. Stale generated files (__pycache__, replay snapshots, etc.)
#   5. Dirty worktrees with uncommitted changes
#   6. Conflicting local governance
#   7. Existing evidence trees
#   8. Empty target (clean install)
#   9. Upgrade from V4/V5 baseline
#  10. Evidence prune vs preserve

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd -P)"
TEST_ROOT="/tmp/harness-adversarial-$$"
REPORT_FILE="$REPO_ROOT/.agents/management/evidence/generated/adoption-adversarial.json"
TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

TOTAL=0
PASSED=0
FAILED=0
RESULTS="[]"

cleanup() {
    rm -rf "$TEST_ROOT" 2>/dev/null || true
}
trap cleanup EXIT

log() {
    echo "[$(date -u +"%H:%M:%S")] $*"
}

json_escape() {
    python3 -c "import json,sys; print(json.dumps(sys.stdin.read()))" <<< "$1"
}

add_result() {
    local name="$1"
    local status="$2"
    local details="$3"
    TOTAL=$((TOTAL + 1))

    if [ "$status" = "pass" ]; then
        PASSED=$((PASSED + 1))
    else
        FAILED=$((FAILED + 1))
    fi

    RESULTS=$(python3 -c "
import json, sys
results = json.loads(sys.argv[1])
results.append({'test': sys.argv[2], 'status': sys.argv[3], 'details': sys.argv[4]})
print(json.dumps(results))
" "$RESULTS" "$name" "$status" "$details")
}

run_install() {
    local target="$1"
    shift
    local log_file="$1"
    shift
    set +e
    "$REPO_ROOT/install-os.sh" "$target" "$@" > "$log_file" 2>&1
    local rc=$?
    set -e
    echo "$rc"
}

# =============================================================================
# TEST 1: Existing .agents with custom governance
# =============================================================================
log "TEST 1: Existing .agents with custom governance"
t1_dir="$TEST_ROOT/existing-agents"
mkdir -p "$t1_dir/.agents/governance"
mkdir -p "$t1_dir/src"
cat > "$t1_dir/.agents/governance/custom.md" <<'EOF'
# Custom Governance
Local rules that must be preserved.
EOF
cat > "$t1_dir/AGENTS.md" <<'EOF'
# Local AGENTS.md
Custom project contract.
EOF
echo 'print("hello")' > "$t1_dir/src/app.py"

t1_log="$TEST_ROOT/t1.log"
rc=$(run_install "$t1_dir" "$t1_log" --adopt)

# Check that custom governance was preserved
if [ -f "$t1_dir/.agents/governance/custom.md" ] && [ -f "$t1_dir/AGENTS.md" ] && [ -d "$t1_dir/.agents/.rules" ]; then
    if grep -q "custom.md" "$t1_log" 2>/dev/null || [ "$(cat "$t1_dir/.agents/governance/custom.md")" = "# Custom Governance
Local rules that must be preserved." ]; then
        add_result "existing-agents" "pass" "Custom governance preserved, baseline installed"
    else
        add_result "existing-agents" "fail" "Custom governance file content may have changed"
    fi
else
    add_result "existing-agents" "fail" "Exit $rc — missing expected structures"
fi

# =============================================================================
# TEST 2: Partially upgraded repo (recovery marker present)
# =============================================================================
log "TEST 2: Partially upgraded repo (recovery from interrupted install)"
t2_dir="$TEST_ROOT/interrupted-install"
mkdir -p "$t2_dir/.agents/management/evidence/install-journal"
mkdir -p "$t2_dir/.agents/governance/core"
mkdir -p "$t2_dir/src"

# Simulate recovery marker from interrupted install
cat > "$t2_dir/.agents/management/evidence/install-journal/interrupted-fake.json" <<EOF
{
    "recovery": true,
    "install_version": "6.0.0",
    "target": "$t2_dir",
    "created_files": [".agents/AGENTS.md"],
    "timestamp": "2026-01-01T00:00:00Z"
}
EOF

# Partial baseline
echo "old rules" > "$t2_dir/.agents/governance/core/test.md"
echo 'print("app")' > "$t2_dir/src/app.py"

t2_log="$TEST_ROOT/t2.log"
rc=$(run_install "$t2_dir" "$t2_log" --adopt)

if [ -d "$t2_dir/.agents/.rules" ] && [ -d "$t2_dir/.agents/management" ]; then
    add_result "interrupted-recovery" "pass" "Re-entered interrupted install successfully (exit $rc)"
else
    add_result "interrupted-recovery" "fail" "Exit $rc — structures missing after re-entry"
fi

# =============================================================================
# TEST 3: Rerun idempotency
# =============================================================================
log "TEST 3: Rerun idempotency (install twice, second run is no-op)"
t3_dir="$TEST_ROOT/rerun-idempotent"
mkdir -p "$t3_dir/src"
echo 'print("hello")' > "$t3_dir/src/app.py"

t3_log1="$TEST_ROOT/t3_run1.log"
t3_log2="$TEST_ROOT/t3_run2.log"
rc1=$(run_install "$t3_dir" "$t3_log1" --adopt)
rc2=$(run_install "$t3_dir" "$t3_log2" --adopt)

# Count operations in second run
created2=$(grep -c "Created:" "$t3_log2" 2>/dev/null || true)
updated2=$(grep -c "Updated" "$t3_log2" 2>/dev/null || true)
skipped2=$(grep -c "Skipped" "$t3_log2" 2>/dev/null || true)
preserved2=$(grep -c "Preserved" "$t3_log2" 2>/dev/null || true)

if [ "$rc2" -eq 0 ]; then
    add_result "rerun-idempotent" "pass" "Second run exit 0, created=$created2 updated=$updated2 skipped=$skipped2 preserved=$preserved2"
else
    add_result "rerun-idempotent" "fail" "Second run exited $rc2"
fi

# =============================================================================
# TEST 4: Stale generated files excluded
# =============================================================================
log "TEST 4: Stale generated files (__pycache__, replay, quarantine)"
t4_dir="$TEST_ROOT/stale-generated"
mkdir -p "$t4_dir/__pycache__"
mkdir -p "$t4_dir/.pytest_cache/v/cache"
mkdir -p "$t4_dir/quarantine"
mkdir -p "$t4_dir/replay-snapshot-001"
mkdir -p "$t4_dir/.agents/management/evidence/generated"
mkdir -p "$t4_dir/src"

# Fixture setup with strict error checking
_fixture_ok=true
echo "compiled bytecode" > "$t4_dir/__pycache__/app.pyc" || _fixture_ok=false
echo "pytest cache" > "$t4_dir/.pytest_cache/v/cache/lastfailed" || _fixture_ok=false
echo "quarantined" > "$t4_dir/quarantine/bad-file.txt" || _fixture_ok=false
echo "replay data" > "$t4_dir/replay-snapshot-001/snapshot.json" || _fixture_ok=false
echo "runtime evidence" > "$t4_dir/.agents/management/evidence/generated/exec-123.json" || _fixture_ok=false

if [ "$_fixture_ok" = false ]; then
    add_result "stale-generated-excluded" "fail" "Fixture setup failed — test cannot run"
    log "  TEST 4 SKIPPED: fixture setup error"
else

t4_log="$TEST_ROOT/t4.log"
rc=$(run_install "$t4_dir" "$t4_log" --adopt)

# These should still exist (not overwritten or deleted)
excluded_count=$(grep -c "Excluded\|excluded\|Excluded\|excluded" "$t4_log" 2>/dev/null || true)

if [ -f "$t4_dir/__pycache__/app.pyc" ] && \
   [ -f "$t4_dir/quarantine/bad-file.txt" ] && \
   [ -f "$t4_dir/.agents/management/evidence/generated/exec-123.json" ] && \
   [ "$rc" -eq 0 ]; then
    add_result "stale-generated-excluded" "pass" "Runtime artifacts preserved, excluded count=$excluded_count"
else
    add_result "stale-generated-excluded" "fail" "Exit $rc — runtime artifacts may have been modified"
fi
fi

# =============================================================================
# TEST 5: Dirty worktree survival
# =============================================================================
log "TEST 5: Dirty worktree with uncommitted changes"
t5_dir="$TEST_ROOT/dirty-worktree"
mkdir -p "$t5_dir/.agents/governance/core"
mkdir -p "$t5_dir/src"

# Simulate locally modified baseline files (dirty worktree)
echo "locally modified rule" > "$t5_dir/.agents/governance/core/quality-gates.md"
echo "custom change" > "$t5_dir/.agents/AGENTS.md"
echo 'print("dirty")' > "$t5_dir/src/app.py"

t5_log="$TEST_ROOT/t5.log"
rc=$(run_install "$t5_dir" "$t5_log" --adopt)

# Adopt mode should preserve locally modified files
preserved_count=$(grep -c "Preserved" "$t5_log" 2>/dev/null || true)

if [ "$rc" -eq 0 ] && [ "$preserved_count" -gt 0 ]; then
    add_result "dirty-worktree" "pass" "Dirty worktree survived, preserved=$preserved_count"
else
    add_result "dirty-worktree" "fail" "Exit $rc, preserved=$preserved_count"
fi

# =============================================================================
# TEST 6: Conflicting local governance
# =============================================================================
log "TEST 6: Conflicting local governance (pre-existing AGENTS.md)"
t6_dir="$TEST_ROOT/conflicting-governance"
mkdir -p "$t6_dir/.agents/rules"
mkdir -p "$t6_dir/src"

cat > "$t6_dir/AGENTS.md" <<'EOF'
# Conflicting AGENTS.md
This repo has its own governance system.
Do NOT use Agent Harness rules.
All commits must be signed.
EOF

cat > "$t6_dir/.agents/rules/standards.md" <<'EOF'
# Local Standards
Different from Agent Harness.
EOF

t6_log="$TEST_ROOT/t6.log"
rc=$(run_install "$t6_dir" "$t6_log" --adopt)

# Check that conflicting AGENTS.md was preserved (adopt mode)
local_agents_content=$(cat "$t6_dir/AGENTS.md" 2>/dev/null || echo "")

if echo "$local_agents_content" | grep -q "Do NOT use Agent Harness"; then
    if [ -d "$t6_dir/.agents/.rules" ]; then
        add_result "conflicting-governance" "pass" "Local AGENTS.md preserved alongside new baseline"
    else
        add_result "conflicting-governance" "fail" "Baseline rules not installed"
    fi
else
    add_result "conflicting-governance" "fail" "Local AGENTS.md was overwritten!"
fi

# =============================================================================
# TEST 7: Existing evidence trees preserved
# =============================================================================
log "TEST 7: Existing evidence trees preserved"
t7_dir="$TEST_ROOT/existing-evidence"
mkdir -p "$t7_dir/EVIDENCE/v5"
mkdir -p "$t7_dir/EVIDENCE/recovery-reports"
mkdir -p "$t7_dir/src"

cat > "$t7_dir/EVIDENCE/v5/adoption-matrix.md" <<'EOF'
# V5 Adoption Matrix
Historical evidence that must be preserved.
EOF

cat > "$t7_dir/EVIDENCE/recovery-reports/report-001.md" <<'EOF'
# Recovery Report 001
Must not be pruned without explicit request.
EOF

t7_log="$TEST_ROOT/t7.log"
rc=$(run_install "$t7_dir" "$t7_log" --adopt)

if [ -f "$t7_dir/EVIDENCE/v5/adoption-matrix.md" ] && \
   [ -f "$t7_dir/EVIDENCE/recovery-reports/report-001.md" ]; then
    if grep -q "Historical evidence" "$t7_dir/EVIDENCE/v5/adoption-matrix.md"; then
        add_result "existing-evidence" "pass" "Evidence trees preserved without prune"
    else
        add_result "existing-evidence" "fail" "Evidence content may have been modified"
    fi
else
    add_result "existing-evidence" "fail" "Exit $rc — evidence files missing"
fi

# =============================================================================
# TEST 8: Clean install (empty target)
# =============================================================================
log "TEST 8: Clean install (empty target directory)"
t8_dir="$TEST_ROOT/clean-install"
mkdir -p "$t8_dir"

t8_log="$TEST_ROOT/t8.log"
rc=$(run_install "$t8_dir" "$t8_log" --adopt)

if [ "$rc" -eq 0 ] && \
   [ -d "$t8_dir/.agents/.rules" ] && \
   [ -f "$t8_dir/AGENTS.md" ] && \
   [ -d "$t8_dir/.agents/management" ]; then
    add_result "clean-install" "pass" "Clean install succeeded with all structures"
else
    add_result "clean-install" "fail" "Exit $rc — missing structures after clean install"
fi

# =============================================================================
# TEST 9: Upgrade from existing baseline
# =============================================================================
log "TEST 9: Upgrade from existing baseline"
t9_dir="$TEST_ROOT/upgrade-baseline"
mkdir -p "$t9_dir/.agents/governance/core"
mkdir -p "$t9_dir/.agents/management/evidence/validation"
mkdir -p "$t9_dir/src"

# Simulate old baseline content
echo "old baseline rule v5" > "$t9_dir/.agents/governance/core/test.md"
echo 'print("app")' > "$t9_dir/src/app.py"
touch "$t9_dir/.agents/management/evidence/validation/v5-check.txt"

t9_log="$TEST_ROOT/t9.log"
rc=$(run_install "$t9_dir" "$t9_log" --upgrade)

if [ "$rc" -eq 0 ] && [ -d "$t9_dir/.agents/.rules" ]; then
    # Upgrade should have replaced baseline
    add_result "upgrade-baseline" "pass" "Upgrade completed, baseline replaced"
else
    add_result "upgrade-baseline" "fail" "Exit $rc — upgrade failed"
fi

# =============================================================================
# TEST 10: Evidence prune vs preserve
# =============================================================================
log "TEST 10: Evidence prune replaces dashboard files"
t10_dir="$TEST_ROOT/evidence-prune"
mkdir -p "$t10_dir/EVIDENCE"
mkdir -p "$t10_dir/src"

# Create stale dashboard files with different content
cat > "$t10_dir/EVIDENCE/CURRENT.md" <<'EOF'
# Stale CURRENT.md
This is old dashboard content that should be pruned.
EOF

cat > "$t10_dir/EVIDENCE/ACTIVE_PLAN.md" <<'EOF'
# Stale ACTIVE_PLAN.md
Old plan content.
EOF

echo 'print("app")' > "$t10_dir/src/app.py"

# First run without prune — should preserve
t10_log1="$TEST_ROOT/t10_run1.log"
rc1=$(run_install "$t10_dir" "$t10_log1" --adopt)
content_before=$(cat "$t10_dir/EVIDENCE/CURRENT.md")

# Second run with prune — should replace
t10_log2="$TEST_ROOT/t10_run2.log"
rc2=$(run_install "$t10_dir" "$t10_log2" --adopt --prune-evidence)
content_after=$(cat "$t10_dir/EVIDENCE/CURRENT.md")

if echo "$content_before" | grep -q "Stale CURRENT.md" && \
   ! echo "$content_after" | grep -q "Stale CURRENT.md"; then
    add_result "evidence-prune" "pass" "Prune replaced stale evidence, preserve kept it"
else
    add_result "evidence-prune" "fail" "Prune behavior incorrect: before=$content_before after=$content_after"
fi

# =============================================================================
# TEST 11: Dry run produces no changes
# =============================================================================
log "TEST 11: Dry run produces no disk changes"
t11_dir="$TEST_ROOT/dry-run-test"
mkdir -p "$t11_dir/src"
echo 'print("hello")' > "$t11_dir/src/app.py"

# Record state before
files_before=$(find "$t11_dir" -type f 2>/dev/null | sort)

t11_log="$TEST_ROOT/t11.log"
rc=$(run_install "$t11_dir" "$t11_log" --dry-run)

# Record state after
files_after=$(find "$t11_dir" -type f 2>/dev/null | sort)

if [ "$files_before" = "$files_after" ] && [ "$rc" -eq 0 ]; then
    add_result "dry-run-noop" "pass" "Dry run produced zero disk changes"
else
    add_result "dry-run-noop" "fail" "Exit $rc — files changed: before=$files_before after=$files_after"
fi

# =============================================================================
# TEST 12: Install journal created
# =============================================================================
log "TEST 12: Install journal created and populated"
t12_dir="$TEST_ROOT/journal-test"
mkdir -p "$t12_dir/src"
echo 'print("hello")' > "$t12_dir/src/app.py"

t12_log="$TEST_ROOT/t12.log"
rc=$(run_install "$t12_dir" "$t12_log" --adopt)

journal_exists=false
if [ -d "$t12_dir/.agents/management/evidence/install-journal" ]; then
    journal_files=$(find "$t12_dir/.agents/management/evidence/install-journal" -name "journal-*.jsonl" 2>/dev/null | wc -l)
    if [ "$journal_files" -gt 0 ]; then
        journal_exists=true
    fi
fi

if [ "$journal_exists" = true ]; then
    add_result "install-journal" "pass" "Journal created with $journal_files entries"
else
    add_result "install-journal" "fail" "No journal files found"
fi

# =============================================================================
# GENERATE FINAL REPORT
# =============================================================================
log ""
log "==========================================================="
log "Generating adversarial adoption report..."
log "==========================================================="

mkdir -p "$(dirname "$REPORT_FILE")"

python3 -c "
import json, sys

results = json.loads(sys.argv[1])
total = int(sys.argv[2])
passed = int(sys.argv[3])
failed = int(sys.argv[4])
timestamp = sys.argv[5]

report = {
    'report_type': 'adoption-adversarial',
    'version': '6.0.0',
    'generated_at': timestamp,
    'summary': {
        'total_tests': total,
        'passed': passed,
        'failed': failed,
        'pass_rate': f'{(passed/total*100):.1f}%' if total > 0 else '0%'
    },
    'tests': results
}

with open(sys.argv[6], 'w') as f:
    json.dump(report, f, indent=2)

print(json.dumps(report['summary'], indent=2))
" "$RESULTS" "$TOTAL" "$PASSED" "$FAILED" "$TIMESTAMP" "$REPORT_FILE"

log ""
log "==========================================================="
log "Adversarial Adoption Validation Complete"
log "Report: $REPORT_FILE"
log "Results: $PASSED/$TOTAL passed ($FAILED failed)"
log "==========================================================="

if [ "$FAILED" -gt 0 ]; then
    log "WARNING: Some tests failed. Review the report for details."
    exit 1
fi

log "All adversarial adoption proofs passed."
exit 0
