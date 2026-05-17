#!/bin/bash
# migrate-governance.sh — Agent Harness V1/V2 to V3 Migration Engine
# Version: 1.0.0
# Goal 5: Automated V1→V3 migration and stale profile detection.

set -e

TARGET_DIR="${1:-.}"

echo "🔄 Starting Governance Migration Engine for $TARGET_DIR..."

# 1. Detect Legacy docs/governance
if [ -d "$TARGET_DIR/docs/governance" ]; then
    echo "📂 Found legacy docs/governance. Moving to .agents/archive/legacy_docs..."
    mkdir -p "$TARGET_DIR/.agents/archive/legacy_docs"
    mv "$TARGET_DIR/docs/governance" "$TARGET_DIR/.agents/archive/legacy_docs/"
fi

# 2. Reconcile Version Markers
echo "🏷️  Reconciling Version Markers (1.1.0 -> 3.0.0)..."
find "$TARGET_DIR/.agents/governance" -type f -name "*.md" -exec sed -i "s/Version: 1.1.0/Version: 3.0.0/g" {} + 2>/dev/null || true

# 3. Detect Stale Profiles
echo "🔍 Detecting Stale Profiles..."
# Logic to check if AGENTS.md references profiles that don't exist in .rules
if [ -f "$TARGET_DIR/AGENTS.md" ]; then
    PROFILES=$(grep ".md" "$TARGET_DIR/AGENTS.md" 2>/dev/null | grep -o ".agents/.*\.md" || true)
    for p in $PROFILES; do
        if [ ! -f "$TARGET_DIR/$p" ]; then
            echo "⚠️  STALE PROFILE DETECTED: $p (referenced in AGENTS.md but missing in tree)"
        fi
    done
fi

# 4. Final Verification
if [ -f "./install-os.sh" ]; then
    echo "🔼 Upgrading to latest OS baseline..."
    ./install-os.sh "$TARGET_DIR" --upgrade >/dev/null
fi

echo "✅ Migration Complete. Run ./verify-governance.sh to confirm."
