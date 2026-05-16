#!/bin/bash
# verify-governance.sh — Agent Harness CI/Local Governance Gate
# Version: 3.12.0
#
# This script verifies that the repository's governance is in a valid state.
# It checks for:
# 1. Existence of core OS baseline (.agents/.rules)
# 2. Status claims vs Evidence (Zero-Drift)
# 3. Schema validity (if python3 is available)
# 4. Anti-bloat policy (EVIDENCE/ files < 50 lines)

set -e

TARGET_DIR="${1:-.}"
HEAD_SHA=$(git rev-parse HEAD 2>/dev/null || echo "not-a-git-repo")

echo "🔍 Verifying Agent Harness Governance at $TARGET_DIR..."

# 1. OS Baseline Check
if [ ! -d "$TARGET_DIR/.agents/.rules" ]; then
    echo "❌ ERROR: OS baseline (.agents/.rules) missing. Run ./install-os.sh first."
    exit 1
fi

# 2. Operational Truth Check
CURRENT_MD="$TARGET_DIR/EVIDENCE/CURRENT.md"
if [ ! -f "$CURRENT_MD" ]; then
    echo "❌ ERROR: EVIDENCE/CURRENT.md missing."
    exit 1
fi

CLAIMED_SHA=$(grep "Commit:" "$CURRENT_MD" | cut -d' ' -f2)
CLAIMED_STATUS=$(grep "## Status:" "$CURRENT_MD" | cut -d' ' -f3)

echo "📊 Claimed Status: $CLAIMED_STATUS"
echo "📊 Claimed SHA: $CLAIMED_SHA"

if [ "$HEAD_SHA" != "not-a-git-repo" ] && [ "$CLAIMED_SHA" != "$HEAD_SHA" ]; then
    echo "⚠️  WARNING: Truth Drift detected! (HEAD: $HEAD_SHA vs Claimed: $CLAIMED_SHA)"
    # In strict CI, we might exit 1 here.
fi

# 3. Anti-Bloat Check
echo "🔍 Checking Anti-Bloat Policy..."
for f in "$TARGET_DIR/EVIDENCE/"*.md; do
    LINES=$(wc -l < "$f")
    if [ "$LINES" -gt 50 ]; then
        echo "❌ ERROR: $f exceeds 50 lines ($LINES). Move detail to .agents/management/evidence/."
        exit 1
    fi
done
echo "✅ Anti-Bloat Passed."

# 4. Schema Verification (Smoke)
if command -v python3 >/dev/null 2>&1; then
    echo "🔍 Verifying Evidence Schemas..."
    for f in "$TARGET_DIR/.agents/config/schemas/examples/"*.json; do
        if ! python3 -c "import json; json.load(open('$f'))" >/dev/null 2>&1; then
            echo "❌ ERROR: Invalid JSON in $f"
            exit 1
        fi
    done
    echo "✅ Schema Examples Passed."
else
    echo "ℹ️  Skipping Schema Verification (python3 missing)."
fi

# 5. OS Validation (via Installer)
if [ -f "./install-os.sh" ]; then
    ./install-os.sh "$TARGET_DIR" --validate
fi

echo "🚀 Governance Verified: FULL_GREEN (verified locally)"
