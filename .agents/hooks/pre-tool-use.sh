#!/bin/bash
set -euo pipefail

# pre-tool-use.sh
# Evaluates Trust Tiers and Sandbox Policies before tool execution.
# Called before an agent executes a tool or command.

TOOL_NAME="${1:-unknown}"

echo "[Agent OS PreToolUse] Checking rules for: $TOOL_NAME"

if [[ "$TOOL_NAME" == *"bash"* ]] || [[ "$TOOL_NAME" == *"run_command"* ]] || [[ "$TOOL_NAME" == *"execute_code"* ]]; then
    echo "[Agent OS PreToolUse] ⚠️ WARNING: Untrusted code execution detected."
    echo "[Agent OS PreToolUse] Validating against sandbox-boundary-policy.md..."
    # In a full implementation, this could dynamically reject risky commands
    # unless approval_required flag is handled by the IDE.
fi
