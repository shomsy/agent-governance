#!/bin/bash
# proof-of-execution.sh — Agent Harness Executed Flow Proof
# Proves that the agent uses skills, writes evidence, and follows governance.

set -e

echo "🎬 Starting Executed Flow Proof..."

# 1. Using Skill: Create and Verify Checksum
echo "⚙️  STEP 1: Using 'verify-checksum' skill..."
echo "Important Truth" > truth.txt
EXPECTED=$(sha256sum truth.txt | cut -d' ' -f1)
.agents/skills/bin/verify-checksum.sh truth.txt "$EXPECTED"

# 2. Using Skill: Update Evidence (Structured Artifact)
echo "⚙️  STEP 2: Using 'update-evidence' skill (Structured Artifact)..."
.agents/skills/bin/update-evidence.py phase '{"name": "checksum-validation", "status": "SUCCESS", "details": "Verified truth.txt integrity"}'

# 3. Running Memory Lifecycle
echo "⚙️  STEP 3: Running Memory Lifecycle..."
.agents/management/hooks/memory-lifecycle.py .

# 4. Running Recursive Review (Deterministic Gate)
echo "⚙️  STEP 4: Running Recursive Review..."
.agents/management/hooks/recursive-review-engine.sh .

# 5. Observability Check
echo "⚙️  STEP 5: Checking Observability Metrics..."
.agents/management/hooks/governance-observability.py .

echo "🏁 Executed Flow Proof: COMPLETE."
