#!/bin/bash
set -euo pipefail

# post-tool-use.sh
# Logs tool invocations for the Continuous Learning pipeline.

TOOL_NAME="${1:-unknown}"
TOOL_INPUT="${2:-}"
TOOL_OUTPUT="${3:-}"

# Ensure observations directory exists
mkdir -p .agents/management/learning

# Sanitize input/output for strict JSON single-line formatting (removing newlines)
CLEAN_INPUT=$(echo "$TOOL_INPUT" | tr '\n' ' ' | sed 's/"/\\"/g' || true)
CLEAN_OUTPUT=$(echo "$TOOL_OUTPUT" | tr '\n' ' ' | head -c 100 | sed 's/"/\\"/g' || true)

# Append to JSON Lines file
echo "{\"timestamp\": \"$(date -Iseconds)\", \"tool\": \"$TOOL_NAME\", \"input\": \"${CLEAN_INPUT}\", \"output_preview\": \"${CLEAN_OUTPUT}\"}" >> .agents/management/learning/observations.jsonl

echo "[Agent OS PostToolUse] Captured $TOOL_NAME usage for continuous learning."
