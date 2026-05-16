#!/bin/bash
# tests/validate-projects.sh — Agent Harness Real Project Validation
# Goal 8: AvaX pilot, Go pilot, Node pilot.

set -e

echo "🧪 Starting Real Project Validation..."

# 1. AvaX Pilot (PHP)
echo "🐘 Validating AvaX Pilot..."
./migrate-governance.sh projects/polymoly/ >/dev/null
./verify-governance.sh projects/polymoly/
echo "✅ AvaX Pilot Validated."

# 2. Go Pilot
echo "🐹 Validating Go Pilot..."
./migrate-governance.sh projects/step-by-step-lesson-engine/ >/dev/null
./verify-governance.sh projects/step-by-step-lesson-engine/
echo "✅ Go Pilot Validated."

# 3. Node Pilot
echo "🟢 Validating Node Pilot..."
./migrate-governance.sh projects/step-by-step-animator/ >/dev/null
./verify-governance.sh projects/step-by-step-animator/
echo "✅ Node Pilot Validated."

echo "🚀 ALL PILOTS VALIDATED."
