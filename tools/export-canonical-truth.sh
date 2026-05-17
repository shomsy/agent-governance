#!/bin/bash
# export-canonical-truth.sh — Stable wrapper for generating the canonical truth dump
# Usage: ./tools/export-canonical-truth.sh [target_directory]

set -e

TARGET_DIR="${1:-.}"
MERGE_SCRIPT="$TARGET_DIR/merge-files.sh"

if [ ! -f "$MERGE_SCRIPT" ]; then
    echo "❌ ERROR: Cannot find merge-files.sh at $MERGE_SCRIPT"
    exit 1
fi

echo "🚀 Generating Canonical Truth Dump..."
"$MERGE_SCRIPT" "$TARGET_DIR" --canonical --pieces=1

echo "✅ Canonical truth exported to $TARGET_DIR/agent-harness.txt"
