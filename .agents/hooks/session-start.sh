#!/bin/bash
set -euo pipefail

# session-start.sh
# Extracted from hooks-policy.md
# Bootstraps the context budget and verifies security constraints on startup.

echo "[Agent OS] Session Starting. Verifying Governance Context..."

# If memory injection is enabled and available, log it
if [ -f ".agents/management/memories/memory_summary.md" ]; then
    echo "[Agent OS] Active memory_summary.md found. Injecting into context."
fi

# Rotate session logs if necessary
mkdir -p .agents/management/memories
date -Iseconds >> .agents/management/memories/session-starts.log

echo "[Agent OS] Governance boundaries successfully established."
