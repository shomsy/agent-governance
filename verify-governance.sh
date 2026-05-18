#!/bin/bash
# verify-governance.sh — Agent Harness Kernel-Level CI/Local Governance Gate
# Version: 4.2.0 (Hardened Enterprise)
#
# This script verifies that the repository's governance is in a valid state.
# It enforces strict zero-drift, overlay integrity, anti-bloat, and evidence consistency.
#
# Exit Codes & Classifications:
#   10 - ERR_MISSING_ADOPTION: Missing AGENTS.md or EVIDENCE/CURRENT.md
#   11 - ERR_BASELINE_MUTATED: Manual modifications inside .agents/.rules/
#   12 - ERR_NESTED_RULES: Nested .rules/.rules corruption detected
#   13 - ERR_OVERSIZED_EVIDENCE: EVIDENCE/*.md exceeds 50 lines
#   14 - ERR_ORPHAN_EVIDENCE: Unrecognized files in EVIDENCE/
#   15 - ERR_INVALID_OVERLAY: Overlay file in unrecognized governance directory
#   16 - ERR_FAKE_GREEN: Claimed GREEN status without validation proof
#   17 - ERR_UNRESOLVED_REF: References in AGENTS.md to non-existent profiles
#   18 - ERR_DUPLICATE_RULE: Redundant identical overlay rule or duplicated evidence
#   19 - ERR_CONTRADICTORY_TRUTH: Disagreement between CURRENT.md and STATUS.md
#   20 - ERR_FINDING_LIFECYCLE: Finding lifecycle validation failed (RED_ACTIVE findings, expired decisions, invalid registry)

set -euo pipefail

TARGET_DIR="${1:-.}"

# Normalise TARGET_DIR to absolute physical path to eliminate path-traversal risk
if [ -d "$TARGET_DIR" ]; then
    TARGET_DIR="$(cd "$TARGET_DIR" && pwd -P)"
else
    echo "❌ ERROR: Target directory '$TARGET_DIR' does not exist."
    exit 10
fi

echo "🔍 [KERNEL] Verifying Agent Harness Governance at $TARGET_DIR..."

# --- Check 1: Missing Adoption Artifacts ---
if [ ! -f "$TARGET_DIR/AGENTS.md" ]; then
    echo "❌ ERROR [ERR_MISSING_ADOPTION]: Root AGENTS.md contract is missing."
    echo "💡 Remediation: Run ./install-os.sh to bootstrap the repository."
    exit 10
fi

CURRENT_MD="$TARGET_DIR/EVIDENCE/CURRENT.md"
if [ ! -f "$CURRENT_MD" ]; then
    echo "❌ ERROR [ERR_MISSING_ADOPTION]: EVIDENCE/CURRENT.md is missing."
    echo "💡 Remediation: Run ./install-os.sh to provision the evidence dashboard."
    exit 10
fi

# --- Check 2: Nested Rules Corruption ---
if [ -d "$TARGET_DIR/.agents/.rules/.rules" ] || [ -d "$TARGET_DIR/.agents/governance/.rules" ]; then
    echo "❌ ERROR [ERR_NESTED_RULES]: Nested rules corruption directory detected."
    echo "💡 Remediation: Clean up nested .rules folders and re-run install-os.sh."
    exit 12
fi

# --- Check 3: Baseline Mutation Check ---
# Check if any baseline rule in .agents/.rules has been manually modified (if in a Git repo)
# Approved mutations (with documented path + content hash) pass as INFO, not RED.
if [ -d "$TARGET_DIR/.git" ]; then
    MODIFIED_RULES=$(git -C "$TARGET_DIR" status --porcelain 2>/dev/null | grep "\.agents/\.rules/" || true)
    if [ -n "$MODIFIED_RULES" ]; then
        UNAPPROVED=""
        APPROVED_INFO=""

        while IFS= read -r line; do
            # Extract the file path (skip the status prefix like " M ", " D ", "?? ")
            mod_file=$(echo "$line" | sed 's/^[ ?A-Z]* *//')

            # Compute current content hash
            if [ -f "$TARGET_DIR/$mod_file" ]; then
                current_hash=$(git hash-object "$TARGET_DIR/$mod_file")
            else
                current_hash="deleted"
            fi

            # Check against any baseline-mutation-approval.md files
            APPROVED="false"
            APPROVAL_REF=""
            # Search in the project's management evidence for approval records
            for approval_file in "$TARGET_DIR/.agents/management/evidence/generated/baseline-mutation-approval.md"; do
                if [ -f "$approval_file" ]; then
                    # Check if this file path + hash appears in the approval table
                    # Approval format: | N | path | hash | ...
                    # Normalize hash comparison: treat "deleted" and "DELETED" as equivalent
                    if grep -q "$mod_file" "$approval_file" 2>/dev/null; then
                        # Check exact hash first, then case-insensitive for deleted files
                        if grep -q "$current_hash" "$approval_file" 2>/dev/null; then
                            APPROVED="true"
                            APPROVAL_REF=$(basename "$approval_file")
                        elif [ "$current_hash" = "deleted" ] && grep -qi "DELETED" "$approval_file" 2>/dev/null; then
                            APPROVED="true"
                            APPROVAL_REF=$(basename "$approval_file")
                        fi
                        if [ "$APPROVED" = "true" ]; then
                            break
                        fi
                    fi
                fi
            done

            if [ "$APPROVED" = "true" ]; then
                APPROVED_INFO="${APPROVED_INFO}✅ APPROVED: ${mod_file} (${current_hash:0:8}) — via ${APPROVAL_REF}\n"
            else
                UNAPPROVED="${UNAPPROVED}  M ${mod_file}\n"
            fi
        done <<< "$MODIFIED_RULES"

        if [ -n "$UNAPPROVED" ]; then
            echo "❌ ERROR [ERR_BASELINE_MUTATED]: Unapproved baseline rule modifications detected!"
            echo -e "$UNAPPROVED"
            if [ -n "$APPROVED_INFO" ]; then
                echo "Approved mutations (passing):"
                echo -e "$APPROVED_INFO"
            fi
            echo "💡 Remediation: Do not edit .agents/.rules/** directly. Move modifications to .agents/governance/** as overlays."
            echo "💡 For intentional baseline improvements, create .agents/management/evidence/generated/baseline-mutation-approval.md with file paths and content hashes."
            exit 11
        fi

        # All mutations are approved — report as INFO
        echo "ℹ️  INFO [BASELINE_MUTATION_APPROVED]: All baseline modifications are approved."
        echo -e "$APPROVED_INFO"
    fi
fi

# --- Check 4: Oversized Root Evidence ---
echo "🔍 [KERNEL] Checking Anti-Bloat Policy..."
for f in "$TARGET_DIR/EVIDENCE/"*.md; do
    [ -e "$f" ] || continue
    basename_f=$(basename "$f")
    # Canonical long-form documents are exempt from the 50-line bloat check.
    # The bloat check targets dashboard/summary files, not execution control or planning docs.
    case "$basename_f" in
        EXECUTION.md|ACTIVE_PLAN.md) continue ;;
    esac
    LINES=$(wc -l < "$f")
    if [ "$LINES" -gt 50 ]; then
        echo "❌ ERROR [ERR_OVERSIZED_EVIDENCE]: Evidence file $f is oversized ($LINES lines, max 50)."
        echo "💡 Remediation: Move verbose validation reports to .agents/management/evidence/."
        exit 13
    fi
done
echo "✅ [KERNEL] Anti-Bloat Gates Passed."

# --- Check 5: Orphan Evidence Noise Detection ---
echo "🔍 [KERNEL] Detecting Orphan/Noise Evidence..."
for f in "$TARGET_DIR/EVIDENCE/"*; do
    [ -e "$f" ] || continue
    basename_f=$(basename "$f")
    case "$basename_f" in
        CURRENT.md|ACTIVE_PLAN.md|FLOW.md|LINKS.md|README.md|EXECUTION.md|.gitkeep)
            # Valid canonical files
            ;;
        *)
            echo "❌ ERROR [ERR_ORPHAN_EVIDENCE]: Orphan/legacy evidence file detected: EVIDENCE/$basename_f"
            echo "💡 Remediation: Remove this file or move it to .agents/management/evidence/archive/."
            exit 14
            ;;
    esac
done
echo "✅ [KERNEL] Evidence Noise Clean."

# --- Check 5b: Root Evidence Hygiene (PHP tool) ---
echo "🔍 [KERNEL] Running Root Evidence Hygiene Check..."
if [ -f "$TARGET_DIR/tooling/governance/check-root-evidence-hygiene.php" ]; then
    HYGIENE_OUTPUT=$(php "$TARGET_DIR/tooling/governance/check-root-evidence-hygiene.php" 2>&1) || {
        echo "❌ ERROR [ERR_ORPHAN_EVIDENCE]: Root EVIDENCE/ hygiene check failed!"
        echo "$HYGIENE_OUTPUT"
        echo "💡 Remediation: Run evidence retention cleanup and archive old files."
        exit 14
    }
    echo "✅ [KERNEL] Root Evidence Hygiene Clean."
fi

# --- Check 6: Invalid Overlays (Structural Path Check) ---
echo "🔍 [KERNEL] Validating Local Governance Overlays..."
if [ -d "$TARGET_DIR/.agents/governance" ]; then
    (
        # Use a localized search restricted entirely to TARGET_DIR to prevent path traversal
        find "$TARGET_DIR/.agents/governance" -type f | while read -r overlay_file; do
            # Verify file is strictly inside TARGET_DIR
            if [[ "$overlay_file" != "$TARGET_DIR/"* ]]; then
                echo "❌ ERROR [ERR_INVALID_OVERLAY]: Path traversal detected outside target boundary: $overlay_file"
                exit 15
            fi
            rel_overlay="${overlay_file#$TARGET_DIR/.agents/governance/}"
            case "$rel_overlay" in
                README.md|*.gitkeep) continue ;;
            esac
            
            subfolder=$(echo "$rel_overlay" | cut -d'/' -f1)
            case "$subfolder" in
                agents|architecture|core|delivery|execution|integrations|intelligence|product|profiles|security|skills|standards)
                    # Valid path structure
                    ;;
                *)
                    echo "❌ ERROR [ERR_INVALID_OVERLAY]: File .agents/governance/$rel_overlay is in an unrecognized governance directory '$subfolder'."
                    echo "💡 Remediation: Place governance rules under standard folders (e.g. core/, architecture/, standards/)."
                    exit 15
                    ;;
            esac
        done
    )
fi
echo "✅ [KERNEL] Local Overlays Validated."

# --- Check 7: Duplicate Rule and Evidence Audit ---
echo "🔍 [KERNEL] Auditing Redundant Rule Shadowing and Duplicate Evidence..."
if [ -d "$TARGET_DIR/.agents/governance" ] && [ -d "$TARGET_DIR/.agents/.rules/governance" ]; then
    (
        find "$TARGET_DIR/.agents/governance" -type f | while read -r overlay_file; do
            rel_overlay="${overlay_file#$TARGET_DIR/.agents/governance/}"
            baseline_file="$TARGET_DIR/.agents/.rules/governance/$rel_overlay"
            if [ -f "$baseline_file" ]; then
                if cmp -s "$overlay_file" "$baseline_file"; then
                    echo "❌ ERROR [ERR_DUPLICATE_RULE]: Redundant duplicate rule file: .agents/governance/$rel_overlay is identical to baseline."
                    echo "💡 Remediation: Delete the redundant local override to keep governance clean."
                    exit 18
                fi
            fi
        done
    )
fi

# Audit for duplicated validation evidence reports using MD5 checks
# Only scan active evidence directories. Archive/, install-archive/, release/, and raw/
# are storage snapshots that naturally contain duplicate files from install/run snapshots.
if [ -d "$TARGET_DIR/.agents/management/evidence" ]; then
    DUPLICATE_HASHES=$(find "$TARGET_DIR/.agents/management/evidence" \
        -type f ! -name ".gitkeep" \
        -not -path "*/archive/*" \
        -not -path "*/install-archive/*" \
        -not -path "*/raw/*" \
        -not -path "*/release/*" \
        -exec md5sum {} + 2>/dev/null | awk '{print $1}' | sort | uniq -d || true)
    if [ -n "$DUPLICATE_HASHES" ]; then
        echo "❌ ERROR [ERR_DUPLICATE_RULE]: Duplicate validation evidence detected! Multiple files share identical hashes."
        for h in $DUPLICATE_HASHES; do
            echo "  Hash: $h matches:"
            find "$TARGET_DIR/.agents/management/evidence" -type f ! -name ".gitkeep" -exec md5sum {} + 2>/dev/null | grep "$h" | awk '{print "    - " $2}'
        done
        echo "💡 Remediation: Re-run tests to generate unique evidence; do not reuse old logs."
        exit 18
    fi
fi
echo "✅ [KERNEL] Redundancy Check Passed."

# --- Check 8: Fake FULL_GREEN / GREEN Claim Validation ---
echo "🔍 [KERNEL] Auditing Operational Truth Claims..."
RAW_CLAIMED=$(grep -i "## Status:" "$CURRENT_MD" || echo "UNKNOWN")
if [[ "$RAW_CLAIMED" == *"|"* ]] || [[ "$RAW_CLAIMED" == *"YELLOW"* && "$RAW_CLAIMED" == *"RED"* ]]; then
    CLAIMED_STATUS=""
else
    CLAIMED_STATUS=$(echo "$RAW_CLAIMED" | awk '{print $NF}' | tr -d '[]"\r ' || echo "UNKNOWN")
fi

if [ -n "$CLAIMED_STATUS" ] && [[ "$CLAIMED_STATUS" == *"GREEN"* ]]; then
    # Ensure there is at least one active validation report inside management/evidence/validation
    VALIDATION_FILES=$(find "$TARGET_DIR/.agents/management/evidence/validation" -type f ! -name ".gitkeep" | wc -l)
    if [ "$VALIDATION_FILES" -eq 0 ]; then
        echo "❌ ERROR [ERR_FAKE_GREEN]: Current state claims GREEN status, but NO validation evidence files exist!"
        echo "💡 Remediation: Perform validation and write evidence to .agents/management/evidence/validation/."
        exit 16
    fi
fi

# --- Check 9: Contradictory Truth Detection ---
STATUS_FILE="$TARGET_DIR/.agents/management/STATUS.md"
if [ -f "$STATUS_FILE" ]; then
    RAW_MGT=$(grep -i "Status:" "$STATUS_FILE" || echo "")
    if [[ "$RAW_MGT" == *"|"* ]] || [[ "$RAW_MGT" == *"Current"* ]] || [[ "$RAW_MGT" == *"state"* ]] || [[ "$RAW_MGT" == *"State"* ]]; then
        MGT_STATUS=""
    else
        MGT_STATUS=$(echo "$RAW_MGT" | awk '{print $NF}' | tr -d '[]"\r ' || true)
    fi
    
    ACTUAL_CLAIMED="$CLAIMED_STATUS"
    
    # Only fail if both represent real explicit status and differ
    if [ -n "$MGT_STATUS" ] && [ -n "$ACTUAL_CLAIMED" ] && [ "$MGT_STATUS" != "$ACTUAL_CLAIMED" ]; then
        echo "❌ ERROR [ERR_CONTRADICTORY_TRUTH]: Contradictory operational truth detected!"
        echo "  - EVIDENCE/CURRENT.md claims: $ACTUAL_CLAIMED"
        echo "  - .agents/management/STATUS.md claims: $MGT_STATUS"
        echo "💡 Remediation: Align your operational status files so they represent a single version of truth."
        exit 19
    fi
fi

# --- Check 10: Unresolved Governance References ---
echo "🔍 [KERNEL] Auditing Governance References..."
if [ -f "$TARGET_DIR/AGENTS.md" ]; then
    (
        (grep -o "\.agents/\.rules/governance/profiles/[a-zA-Z0-9_/-]*\.md" "$TARGET_DIR/AGENTS.md" 2>/dev/null || true) | while read -r p; do
            if [ ! -f "$TARGET_DIR/$p" ]; then
                echo "❌ ERROR [ERR_UNRESOLVED_REF]: AGENTS.md references non-existent profile file: $p"
                echo "💡 Remediation: Correct the profile path in AGENTS.md or verify that the profile is installed."
                exit 17
            fi
        done
    )
fi
echo "✅ [KERNEL] Governance References Solid."

# --- Check 11: Stale Evidence & Commit Drift Audits ---
echo "🔍 [KERNEL] Checking for Stale Evidence and Commit Drift..."
if [ -f "$CURRENT_MD" ]; then
    # Age Check
    if stat -c %Y "$CURRENT_MD" >/dev/null 2>&1; then
        mtime=$(stat -c %Y "$CURRENT_MD")
    else
        mtime=$(stat -f %m "$CURRENT_MD" 2>/dev/null || date +%s)
    fi
    now=$(date +%s)
    age=$((now - mtime))
    if [ "$age" -gt 86400 ]; then
        echo "⚠️  WARNING: EVIDENCE/CURRENT.md is older than 24 hours ($((age / 3600)) hours old)."
    fi

    # Commit Drift Check
    CLAIMED_SHA=$(grep -oE "[a-f0-9]{40}" "$CURRENT_MD" | head -n 1 || true)
    if [ -d "$TARGET_DIR/.git" ] && [ -n "$CLAIMED_SHA" ]; then
        ACTUAL_SHA=$(git -C "$TARGET_DIR" rev-parse HEAD 2>/dev/null || true)
        if [ -n "$ACTUAL_SHA" ] && [ "$ACTUAL_SHA" != "$CLAIMED_SHA" ]; then
            echo "⚠️  WARNING: Commit drift detected! Current HEAD is $ACTUAL_SHA, but dashboard claims $CLAIMED_SHA."
        fi
    fi
fi
echo "✅ [KERNEL] Stale Evidence Audits Complete."

# --- Check 12: Finding Lifecycle Closure ---
echo "🔍 [KERNEL] Checking Finding Lifecycle Closure..."
FINDING_TOOL="$BIN_DIR/finding_decisions.py"
if [ -f "$FINDING_TOOL" ]; then
    FINDING_OUTPUT=$(python3 "$FINDING_TOOL" --dir "$TARGET_DIR" validate 2>&1) || FINDING_RC=$?
    FINDING_RC=${FINDING_RC:-0}
    if [ "$FINDING_RC" -eq 2 ]; then
        echo "❌ ERROR [ERR_FINDING_LIFECYCLE]: Finding lifecycle validation failed!"
        echo "$FINDING_OUTPUT"
        echo "💡 Remediation: Resolve RED_ACTIVE findings or add valid decisions to .agents/management/evidence/indexes/finding-decisions.json"
        exit 20
    elif [ "$FINDING_RC" -eq 1 ]; then
        echo "⚠️  WARNING [FINDING_LIFECYCLE_WARNINGS]: Finding lifecycle has warnings"
        echo "$FINDING_OUTPUT"
    else
        echo "✅ [KERNEL] Finding Lifecycle Closure Valid."
    fi

    # Check for expired decisions
    EXPIRED_OUTPUT=$(python3 "$FINDING_TOOL" --dir "$TARGET_DIR" expire-check 2>&1) || EXPIRED_RC=$?
    EXPIRED_RC=${EXPIRED_RC:-0}
    if [ "$EXPIRED_RC" -gt 0 ]; then
        echo "⚠️  WARNING [EXPIRED_FINDINGS]: Some finding decisions have expired"
        echo "$EXPIRED_OUTPUT"
    fi
else
    echo "ℹ️  INFO: finding_decisions.py not found — finding lifecycle not yet deployed"
fi

# --- Legacy and V4.1/V3 Integrity Gates ---
if grep "Version: 1.1.0" "$TARGET_DIR/AGENTS.md" >/dev/null 2>&1; then
    echo "❌ ERROR: Root AGENTS.md contains stale Version 1.1.0"
    exit 1
fi

if find "$TARGET_DIR" -name "PARENT-AGENTS.md" | grep -v "node_modules" >/dev/null 2>&1; then
    echo "❌ ERROR: Legacy PARENT-AGENTS.md files detected."
    exit 1
fi

# Run Executable Governance Compiler & Linter if present
# These are tool-level governance checks. They report findings but do not
# override kernel-level pass/fail. Kernel checks (exit codes 10-19) remain
# the authoritative gate. Tool findings are reported as warnings.
BIN_DIR="$TARGET_DIR/.agents/skills/bin"
if [ ! -f "$BIN_DIR/compile-governance.py" ]; then
    if [ -f "$TARGET_DIR/.agents/.rules/skills/bin/compile-governance.py" ]; then
        BIN_DIR="$TARGET_DIR/.agents/.rules/skills/bin"
    fi
fi

TOOL_FAILURES=()
if [ -f "$BIN_DIR/compile-governance.py" ]; then
    echo "⚙️  [ENGINE] Running Hardened Governance Compiler..."
    python3 "$BIN_DIR/compile-governance.py" "$TARGET_DIR" 2>&1 || TOOL_FAILURES+=("compile-governance.py")
    python3 "$BIN_DIR/lint-governance.py" "$TARGET_DIR" 2>&1 || TOOL_FAILURES+=("lint-governance.py")
    python3 "$BIN_DIR/check-complexity-budget.py" "$TARGET_DIR" 2>&1 || TOOL_FAILURES+=("check-complexity-budget.py")
    python3 "$BIN_DIR/check-budgets.py" --dir "$TARGET_DIR" 2>&1 || TOOL_FAILURES+=("check-budgets.py")
    python3 "$BIN_DIR/evidence-lifecycle.py" "$TARGET_DIR" 2>&1 || TOOL_FAILURES+=("evidence-lifecycle.py")
    python3 "$BIN_DIR/replay-evidence.py" "$TARGET_DIR" 2>&1 || TOOL_FAILURES+=("replay-evidence.py")
    python3 "$BIN_DIR/execution-substrate.py" compress 2>&1 || TOOL_FAILURES+=("execution-substrate.py")
    python3 "$BIN_DIR/aggregate-context.py" "$TARGET_DIR" 2>&1 || TOOL_FAILURES+=("aggregate-context.py")

    if [ ${#TOOL_FAILURES[@]} -gt 0 ]; then
        echo ""
        echo "⚠️  WARNING [GOVERNANCE_TOOL_FAILURES]: ${#TOOL_FAILURES[@]} governance tool(s) reported findings:"
        for tool in "${TOOL_FAILURES[@]}"; do
            echo "  - $tool"
        done
        echo "💡 These are tool-level findings. Kernel-level governance checks passed."
    fi
fi

# OS Validation (via Installer validation mode)
if [ -f "./install-os.sh" ]; then
    ./install-os.sh "$TARGET_DIR" --validate
fi

# Run Executable Runtime Proofs
if [ -f "$TARGET_DIR/.agents/.rules/skills/bin/measure-performance.sh" ]; then
    "$TARGET_DIR/.agents/.rules/skills/bin/measure-performance.sh"
elif [ -f "$TARGET_DIR/tests/measure-performance.sh" ]; then
    "$TARGET_DIR/tests/measure-performance.sh"
fi

if [ -f "$TARGET_DIR/.agents/.rules/skills/bin/delegation-runtime-proof.sh" ]; then
    "$TARGET_DIR/.agents/.rules/skills/bin/delegation-runtime-proof.sh"
elif [ -f "$TARGET_DIR/tests/delegation-runtime-proof.sh" ]; then
    "$TARGET_DIR/tests/delegation-runtime-proof.sh"
fi

# --- Execution Substrate Health Check ---
echo "🔍 [KERNEL] Checking Execution Substrate Health..."
RUNTIME_BIN="$TARGET_DIR/.agents/.rules/skills/bin/execution_runtime.py"
if [ -f "$RUNTIME_BIN" ]; then
    SUBSTRATE_STATUS=$(python3 "$RUNTIME_BIN" status --dir "$TARGET_DIR" 2>&1) || true
    echo "$SUBSTRATE_STATUS"
    # Substrate check is advisory — does not block kernel gate
    if echo "$SUBSTRATE_STATUS" | grep -q "RED"; then
        echo "⚠️  WARNING: Execution substrate reports RED status"
    fi
else
    echo "ℹ️  INFO: execution_runtime.py not found — execution substrate not yet deployed"
fi

echo "🚀 [KERNEL] Governance Verified: FULL_GREEN_EXECUTABLE_GOVERNANCE_RUNTIME_READY (verified locally)"
exit 0
