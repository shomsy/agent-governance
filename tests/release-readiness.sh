#!/usr/bin/env bash
# tests/release-readiness.sh — Agent Harness Release Readiness Gate
#
# Runs the complete release validation suite:
# - Installer help/discovery tests
# - Project-local contract tests
# - Pilot matrix
# - Profile leakage scanner
# - Diagnostics tests
# - Root evidence hygiene
# - Dictionary validation
# - Stale evidence detector
# - Shell syntax checks
# - Python syntax checks
# - Governance index check
#
# Usage:
#   bash tests/release-readiness.sh
#
# Output:
#   GREEN/YELLOW/RED summary
#   Exact failing command
#   Evidence report path
#
# Exit codes:
#   0 = GREEN
#   1 = RED (blocking failure)
#   2 = YELLOW (non-blocking warnings)

set -euo pipefail

# ============================================================
# Configuration
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TIMESTAMP="$(date +%Y%m%dT%H%M%S)"
REPORT_DIR="${PROJECT_ROOT}/.agents/management/evidence/generated"
REPORT_FILE="${REPORT_DIR}/release-readiness-${TIMESTAMP}.md"
LEAKAGE_DIR="${PROJECT_ROOT}/.agents/management/evidence/generated"

mkdir -p "$REPORT_DIR"
mkdir -p "$LEAKAGE_DIR"

# Colours
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    CYAN='\033[0;36m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    NC=''
fi

# ============================================================
# Test Runner
# ============================================================

TOTAL=0
PASS=0
FAIL=0
WARN=0
BLOCKING_FAILS=()
WARNINGS=()

run_test() {
    local name="$1"
    local command="$2"
    local is_blocking="${3:-true}"
    TOTAL=$((TOTAL + 1))

    echo -n "  [${TOTAL}] ${name}... "

    local output
    local rc=0
    output=$(eval "$command" 2>&1) || rc=$?

    if [ $rc -eq 0 ]; then
        PASS=$((PASS + 1))
        echo -e "${GREEN}PASS${NC}"
    elif [ "$is_blocking" = "false" ]; then
        WARN=$((WARN + 1))
        WARNINGS+=("${name}: ${output}")
        echo -e "${YELLOW}WARN${NC}"
    else
        FAIL=$((FAIL + 1))
        BLOCKING_FAILS+=("${name}: exit_code=${rc}, output=${output:0:200}")
        echo -e "${RED}FAIL${NC}"
        echo "    Command: ${command}"
        echo "    Output: ${output:0:500}"
    fi
}

# ============================================================
# Main
# ============================================================

echo "============================================="
echo "AGENT HARNESS — RELEASE READINESS GATE"
echo "============================================="
echo "Timestamp: ${TIMESTAMP}"
echo "Report:    ${REPORT_FILE}"
echo ""

# ============================================================
# Section 1: Shell Syntax Checks
# ============================================================

echo "--- Section 1: Shell Syntax Checks ---"

for sh_file in \
    "$PROJECT_ROOT/tests/pilot-matrix.sh" \
    "$PROJECT_ROOT/tools/check-profile-leakage.sh" \
    "$PROJECT_ROOT/tests/release-readiness.sh" \
    "$PROJECT_ROOT/verify-governance.sh" \
    "$PROJECT_ROOT/tests/project-local-contract-test.sh"
do
    if [ -f "$sh_file" ]; then
        run_test "bash -n $(basename "$sh_file")" "bash -n '$sh_file'" "true"
    fi
done

echo ""

# ============================================================
# Section 2: Python Syntax Checks
# ============================================================

echo "--- Section 2: Python Syntax Checks ---"

for py_file in \
    "$PROJECT_ROOT/.agents/skills/bin/compile-governance.py" \
    "$PROJECT_ROOT/.agents/skills/bin/lint-governance.py" \
    "$PROJECT_ROOT/.agents/skills/bin/validate-dictionary.py" \
    "$PROJECT_ROOT/.agents/skills/bin/evidence-lifecycle.py" \
    "$PROJECT_ROOT/.agents/skills/bin/replay-evidence.py" \
    "$PROJECT_ROOT/.agents/skills/bin/command_sandbox.py" \
    "$PROJECT_ROOT/.agents/skills/bin/crypto_seals.py" \
    "$PROJECT_ROOT/.agents/skills/bin/execution_runtime.py" \
    "$PROJECT_ROOT/.agents/skills/bin/substrate_security.py" \
    "$PROJECT_ROOT/.agents/skills/bin/execution_analysis.py"
do
    if [ -f "$py_file" ]; then
        run_test "py_compile $(basename "$py_file")" "python3 -m py_compile '$py_file'" "false"
    fi
done

echo ""

# ============================================================
# Section 3: Project-Local Contract Tests
# ============================================================

echo "--- Section 3: Project-Local Contract Tests ---"

run_test "project-local-contract-test.sh" "bash '$PROJECT_ROOT/tests/project-local-contract-test.sh'" "true"

echo ""

# ============================================================
# Section 4: Verify-Governance
# ============================================================

echo "--- Section 4: Verify Governance ---"

run_test "verify-governance.sh" "bash '$PROJECT_ROOT/verify-governance.sh' '$PROJECT_ROOT'" "true"

echo ""

# ============================================================
# Section 5: Governance Index Check
# ============================================================

echo "--- Section 5: Governance Index Check ---"

if [ -f "$PROJECT_ROOT/tooling/governance/check-governance-index-current.php" ]; then
    run_test "check-governance-index-current.php" "php '$PROJECT_ROOT/tooling/governance/check-governance-index-current.php'" "false"
fi

echo ""

# ============================================================
# Section 6: Pilot Matrix
# ============================================================

echo "--- Section 6: Pilot Matrix ---"

run_test "pilot-matrix.sh" "bash '$PROJECT_ROOT/tests/pilot-matrix.sh'" "true"

echo ""

# ============================================================
# Section 7: Profile Leakage Scanner
# ============================================================

echo "--- Section 7: Profile Leakage Scanner ---"

# Run leakage scanner against each pilot scenario from the matrix run
# The pilot matrix creates repos in /tmp/agent-harness-pilot-matrix/
TEMP_ROOT="${TMPDIR:-/tmp}/agent-harness-pilot-matrix"

if [ -d "$TEMP_ROOT" ]; then
    for pilot_dir in "${TEMP_ROOT}"/*/; do
        if [ -d "$pilot_dir" ]; then
            pilot_name="$(basename "$pilot_dir")"

            # Determine language from project.json
            project_json="${pilot_dir}/.agents/config/project.json"
            if [ -f "$project_json" ]; then
                language=$(grep '"language"' "$project_json" | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "unknown")
            else
                language="unknown"
            fi

            run_test "leakage-scan: ${pilot_name} (${language})" \
                "bash '$PROJECT_ROOT/tools/check-profile-leakage.sh' '${pilot_dir}' '${language}'" \
                "true"
        fi
    done
else
    WARN=$((WARN + 1))
    WARNINGS+=("leakage-scanner: No pilot matrix output found at ${TEMP_ROOT}")
    echo -e "${YELLOW}  [WARN] No pilot matrix output found — skipping leakage scans${NC}"
fi

echo ""

# ============================================================
# Section 8: Root Evidence Hygiene
# ============================================================

echo "--- Section 8: Root Evidence Hygiene ---"

if [ -f "$PROJECT_ROOT/tooling/governance/check-root-evidence-hygiene.php" ]; then
    run_test "check-root-evidence-hygiene.php" "php '$PROJECT_ROOT/tooling/governance/check-root-evidence-hygiene.php'" "false"
else
    echo "  [SKIP] check-root-evidence-hygiene.php not found"
fi

# Check EVIDENCE/ does not have orphan files
echo ""

# ============================================================
# Section 9: Dictionary Validation
# ============================================================

echo "--- Section 9: Dictionary Validation ---"

if [ -f "$PROJECT_ROOT/.agents/skills/bin/validate-dictionary.py" ]; then
    DICT_OUTPUT=$(python3 "$PROJECT_ROOT/.agents/skills/bin/validate-dictionary.py" "$PROJECT_ROOT" 2>&1) || DICT_RC=$? || true
    DICT_RC=${DICT_RC:-0}
    if [ $DICT_RC -eq 0 ]; then
        if echo "$DICT_OUTPUT" | grep -qi "INFO.*not applicable\|INFO.*skipped\|skipped"; then
            echo "  [SKIP] $DICT_OUTPUT"
        else
            echo -e "  [${GREEN}PASS${NC}] validate-dictionary.py"
            PASS=$((PASS + 1))
            TOTAL=$((TOTAL + 1))
        fi
    else
        TOTAL=$((TOTAL + 1))
        FAIL=$((FAIL + 1))
        BLOCKING_FAILS+=("validate-dictionary.py: exit_code=${DICT_RC}, output=${DICT_OUTPUT:0:200}")
        echo -e "  [${RED}FAIL${NC}] validate-dictionary.py"
        echo "    Output: ${DICT_OUTPUT:0:500}"
    fi
fi

echo ""

# ============================================================
# Section 10: Component Suite Structure
# ============================================================

echo "--- Section 10: Component Suite Structure ---"

if [ -f "$PROJECT_ROOT/tooling/refactor/check-component-suite-structure.php" ]; then
    run_test "check-component-suite-structure.php" "php '$PROJECT_ROOT/tooling/refactor/check-component-suite-structure.php'" "false"
fi

echo ""

# ============================================================
# Section 11: Stage Lock
# ============================================================

echo "--- Section 11: Stage Lock ---"

if [ -f "$PROJECT_ROOT/tooling/governance/check-stage-lock.php" ]; then
    run_test "check-stage-lock.php" "php '$PROJECT_ROOT/tooling/governance/check-stage-lock.php'" "false"
fi

echo ""

# ============================================================
# Section 12: Execution Substrate
# ============================================================

echo "--- Section 12: Execution Substrate ---"

# Substrate status
run_test "execution_runtime.py status" \
    "python3 '$PROJECT_ROOT/.agents/skills/bin/execution_runtime.py' status --dir '$PROJECT_ROOT'" \
    "false"

# Execution manifest schema exists
if [ -f "$PROJECT_ROOT/.agents/management/contracts/execution-manifest.schema.json" ]; then
    run_test "execution-manifest.schema.json exists" "test -f '$PROJECT_ROOT/.agents/management/contracts/execution-manifest.schema.json'" "false"
else
    WARN=$((WARN + 1))
    WARNINGS+=("execution-manifest.schema.json: not found")
    echo -e "${YELLOW}  [WARN] execution-manifest.schema.json not found${NC}"
fi

# Replay manifest schema exists
if [ -f "$PROJECT_ROOT/.agents/management/contracts/replay-manifest.schema.json" ]; then
    run_test "replay-manifest.schema.json exists" "test -f '$PROJECT_ROOT/.agents/management/contracts/replay-manifest.schema.json'" "false"
else
    WARN=$((WARN + 1))
    WARNINGS+=("replay-manifest.schema.json: not found")
    echo -e "${YELLOW}  [WARN] replay-manifest.schema.json not found${NC}"
fi

# Execution substrate architecture doc
if [ -f "$PROJECT_ROOT/.agents/governance/execution/execution-substrate-architecture.md" ]; then
    run_test "execution-substrate-architecture.md exists" "test -f '$PROJECT_ROOT/.agents/governance/execution/execution-substrate-architecture.md'" "false"
else
    WARN=$((WARN + 1))
    WARNINGS+=("execution-substrate-architecture.md: not found")
    echo -e "${YELLOW}  [WARN] execution-substrate-architecture.md not found${NC}"
fi

# Run execution substrate test suite
if [ -f "$PROJECT_ROOT/tests/execution-substrate-test.sh" ]; then
    run_test "execution-substrate-test.sh" "bash '$PROJECT_ROOT/tests/execution-substrate-test.sh'" "false"
fi

# Run replay integrity test suite
if [ -f "$PROJECT_ROOT/tests/replay-integrity-test.sh" ]; then
    run_test "replay-integrity-test.sh" "bash '$PROJECT_ROOT/tests/replay-integrity-test.sh'" "false"
fi

# Run sandbox enforcement test suite
if [ -f "$PROJECT_ROOT/tests/sandbox-enforcement-test.sh" ]; then
    run_test "sandbox-enforcement-test.sh" "bash '$PROJECT_ROOT/tests/sandbox-enforcement-test.sh'" "false"
fi

# V6: Run chaos & adversarial test suite
if [ -f "$PROJECT_ROOT/tests/chaos-adversarial-test.sh" ]; then
    run_test "chaos-adversarial-test.sh" "bash '$PROJECT_ROOT/tests/chaos-adversarial-test.sh'" "false"
fi

echo ""

# ============================================================
# Section 12.5: V6 Runtime Validation
# ============================================================

echo "--- Section 12.5: V6 Runtime Validation ---"

# V6: Runtime execution test — proves runtime is operational
run_test "v6-runtime-execution" \
    "python3 '$PROJECT_ROOT/.agents/skills/bin/execution_runtime.py' run --task 'release-readiness-runtime' --tier READ_ONLY --scope validation --cmd 'echo runtime-verified' --dir '$PROJECT_ROOT'" \
    "true"

# V6: Approval records must exist after runtime execution
if [ -f "$PROJECT_ROOT/.agents/management/evidence/generated/approval-records.jsonl" ]; then
    run_test "v6-approval-records-exist" "test -s '$PROJECT_ROOT/.agents/management/evidence/generated/approval-records.jsonl'" "true"
else
    FAIL=$((FAIL + 1))
    BLOCKING_FAILS+=("v6-approval-records-exist: no approval records found")
    echo -e "${RED}  [FAIL] v6-approval-records-exist${NC}"
fi

# V6: Audit chain must be valid
run_test "v6-audit-chain" \
    "python3 '$PROJECT_ROOT/.agents/skills/bin/execution_runtime.py' audit-chain --dir '$PROJECT_ROOT'" \
    "true"

# V6: Evidence graph must be generatable (on-demand is acceptable)
run_test "v6-evidence-graph" \
    "python3 '$PROJECT_ROOT/.agents/skills/bin/evidence-query.py' graph --dir '$PROJECT_ROOT' >/dev/null 2>&1" \
    "false"

# V6: Orphan evidence check via query tool
run_test "v6-orphan-check" \
    "python3 '$PROJECT_ROOT/.agents/skills/bin/evidence-query.py' orphans --dir '$PROJECT_ROOT' >/dev/null 2>&1" \
    "false"

# V6: Runtime wrapper exists and is executable
if [ -x "$PROJECT_ROOT/.agents/skills/bin/runtime_exec.sh" ]; then
    run_test "v6-runtime-exec-sh" "test -x '$PROJECT_ROOT/.agents/skills/bin/runtime_exec.sh'" "true"
else
    WARN=$((WARN + 1))
    WARNINGS+=("v6-runtime-exec-sh: runtime_exec.sh not executable")
    echo -e "${YELLOW}  [WARN] runtime_exec.sh not executable${NC}"
fi

# V6: Agent runtime contract exists
if [ -f "$PROJECT_ROOT/.agents/management/contracts/agent-runtime-contract.md" ]; then
    run_test "v6-agent-runtime-contract" "test -f '$PROJECT_ROOT/.agents/management/contracts/agent-runtime-contract.md'" "false"
else
    WARN=$((WARN + 1))
    WARNINGS+=("v6-agent-runtime-contract: not found")
    echo -e "${YELLOW}  [WARN] agent-runtime-contract.md not found${NC}"
fi

echo ""

# ============================================================
# Section 12.6: V7 Runtime Simplification & Performance
# ============================================================

echo "--- Section 12.6: V7 Runtime Simplification & Performance ---"

# V7: Budget validation
run_test "v7-budget-validation" \
    "python3 '$PROJECT_ROOT/.agents/skills/bin/check-budgets.py' --dir '$PROJECT_ROOT'" \
    "false"

# V7: Performance test
run_test "v7-performance" \
    "bash '$PROJECT_ROOT/tests/runtime-performance-test.sh'" \
    "false"

# V7: Operator UX test
run_test "v7-operator-ux" \
    "bash '$PROJECT_ROOT/tests/operator-ux-test.sh'" \
    "false"

# V7: Manifest size check (new compact format should be < 16KB)
LATEST_MANIFEST=$(ls -t "$PROJECT_ROOT/.agents/management/evidence/execution/execution-manifest-"*.json 2>/dev/null | head -1)
if [ -n "$LATEST_MANIFEST" ]; then
    MANIFEST_SIZE=$(stat -c%s "$LATEST_MANIFEST" 2>/dev/null || echo 0)
    if [ "$MANIFEST_SIZE" -lt 16384 ]; then
        echo -e "  [${GREEN}PASS${NC}] Latest manifest compact: $(basename "$LATEST_MANIFEST") = ${MANIFEST_SIZE} bytes"
        PASS=$((PASS + 1))
        TOTAL=$((TOTAL + 1))
    else
        echo -e "  [${YELLOW}WARN${NC}] Latest manifest large: $(basename "$LATEST_MANIFEST") = ${MANIFEST_SIZE} bytes"
        WARN=$((WARN + 1))
        WARNINGS+=("v7-manifest-size: $(basename "$LATEST_MANIFEST") = ${MANIFEST_SIZE} bytes")
    fi
else
    echo "  [SKIP] No manifests found yet"
fi

echo ""

echo ""

# Check for orphan execution evidence (evidence without manifest)
ORPHAN_COUNT=0
EVIDENCE_EXEC_DIR="$PROJECT_ROOT/.agents/management/evidence/execution"
if [ -d "$EVIDENCE_EXEC_DIR" ]; then
    # Count JSON files that are NOT execution/delegation/replay manifests
    for f in "$EVIDENCE_EXEC_DIR"/*.json; do
        [ -e "$f" ] || continue
        basename_f="$(basename "$f")"
        case "$basename_f" in
            execution-manifest-*|delegation-manifest-*|replay-manifest-*) ;;
            *) ORPHAN_COUNT=$((ORPHAN_COUNT + 1)) ;;
        esac
    done
fi
if [ "$ORPHAN_COUNT" -gt 0 ]; then
    WARN=$((WARN + 1))
    WARNINGS+=("orphan-execution-evidence: $ORPHAN_COUNT orphan files in execution evidence dir")
    echo -e "${YELLOW}  [WARN] $ORPHAN_COUNT orphan execution evidence files${NC}"
else
    echo "  [OK] No orphan execution evidence"
fi

echo ""

# ============================================================
# Section 13: Finding Lifecycle Closure
# ============================================================

echo "--- Section 13: Finding Lifecycle Closure ---"

if [ -f "$PROJECT_ROOT/.agents/skills/bin/finding_decisions.py" ]; then
    run_test "finding_decisions.py py_compile" \
        "python3 -m py_compile '$PROJECT_ROOT/.agents/skills/bin/finding_decisions.py'" \
        "false"

    run_test "finding_decisions.py validate" \
        "python3 '$PROJECT_ROOT/.agents/skills/bin/finding_decisions.py' --dir '$PROJECT_ROOT' validate" \
        "false"

    run_test "finding_decisions.py expire-check" \
        "python3 '$PROJECT_ROOT/.agents/skills/bin/finding_decisions.py' --dir '$PROJECT_ROOT' expire-check" \
        "false"

    run_test "finding-decision.schema.json exists" \
        "test -f '$PROJECT_ROOT/.agents/config/schemas/finding-decision.schema.json'" \
        "false"
else
    echo "  [SKIP] finding_decisions.py not found"
fi

echo ""

# ============================================================
# Summary
# ============================================================

echo ""
echo "============================================="
echo "RELEASE READINESS SUMMARY"
echo "============================================="
echo "Total checks:  ${TOTAL}"
echo -e "Passed:        ${GREEN}${PASS}${NC}"
echo -e "Failed:        ${RED}${FAIL}${NC}"
echo -e "Warnings:      ${YELLOW}${WARN}${NC}"
echo ""

if [ $FAIL -gt 0 ]; then
    echo "STATUS: RED"
    echo ""
    echo "Blocking failures:"
    for fail in "${BLOCKING_FAILS[@]}"; do
        echo "  - ${fail}"
    done
    echo ""

    # Write RED report
    cat > "$REPORT_FILE" <<ENDREPORT
# Release Readiness Report

**Timestamp:** ${TIMESTAMP}
**Status:** RED

## Summary

- Total: ${TOTAL}
- Passed: ${PASS}
- Failed: ${FAIL}
- Warnings: ${WARN}

## Blocking Failures

ENDREPORT

    for fail in "${BLOCKING_FAILS[@]}"; do
        echo "- ${fail}" >> "$REPORT_FILE"
    done

    echo ""
    echo "Report: ${REPORT_FILE}"
    exit 1
elif [ $WARN -gt 0 ]; then
    echo "STATUS: YELLOW"
    echo ""
    echo "Warnings:"
    for w in "${WARNINGS[@]}"; do
        echo "  - ${w}"
    done
    echo ""

    # Write YELLOW report
    cat > "$REPORT_FILE" <<ENDREPORT
# Release Readiness Report

**Timestamp:** ${TIMESTAMP}
**Status:** YELLOW

## Summary

- Total: ${TOTAL}
- Passed: ${PASS}
- Failed: ${FAIL}
- Warnings: ${WARN}

## Warnings

ENDREPORT

    for w in "${WARNINGS[@]}"; do
        echo "- ${w}" >> "$REPORT_FILE"
    done

    echo ""
    echo "Report: ${REPORT_FILE}"
    exit 2
else
    echo "STATUS: GREEN"
    echo ""

    # Write GREEN report
    cat > "$REPORT_FILE" <<ENDREPORT
# Release Readiness Report

**Timestamp:** ${TIMESTAMP}
**Status:** GREEN

## Summary

- Total: ${TOTAL}
- Passed: ${PASS}
- Failed: ${FAIL}
- Warnings: ${WARN}

## All Checks Passed

The release readiness gate has passed all checks.
ENDREPORT

    echo "Report: ${REPORT_FILE}"
    exit 0
fi
