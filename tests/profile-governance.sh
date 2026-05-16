#!/bin/bash
# profile-governance.sh — Agent Harness Scale & Performance Profiler
# Version: 1.0.0
# Goal 3: Measure governance overhead at scale.

set -e

TARGET_DIR="/tmp/harness-profile"
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

echo "🧪 Starting Governance Performance Profiling..."

# 1. Setup Base Harness
./install-os.sh "$TARGET_DIR" --language=go --platform=claude >/dev/null

create_dummy_files() {
    local count=$1
    echo "📁 Creating $count dummy files..."
    # Faster way to create many files
    mkdir -p "$TARGET_DIR/src/scale_$count"
    seq $count | xargs -I{} -P 8 touch "$TARGET_DIR/src/scale_$count/file_{}.txt"
}

run_benchmarks() {
    local count=$1
    echo "⏱️  Benchmarking at $count files..."
    
    # Measure verify-governance.sh
    START=$(date +%s%N)
    ./verify-governance.sh "$TARGET_DIR" >/dev/null 2>&1
    END=$(date +%s%N)
    VERIFY_TIME=$(( (END - START) / 1000000 ))

    # Measure recursive-review-engine.sh
    START=$(date +%s%N)
    .agents/management/hooks/recursive-review-engine.sh "$TARGET_DIR" >/dev/null 2>&1
    END=$(date +%s%N)
    REVIEW_TIME=$(( (END - START) / 1000000 ))

    # Measure governance-observability.py
    START=$(date +%s%N)
    .agents/management/hooks/governance-observability.py "$TARGET_DIR" >/dev/null 2>&1
    END=$(date +%s%N)
    OBSERVE_TIME=$(( (END - START) / 1000000 ))

    echo "  - verify-governance.sh: ${VERIFY_TIME}ms"
    echo "  - recursive-review-engine.sh: ${REVIEW_TIME}ms"
    echo "  - governance-observability.py: ${OBSERVE_TIME}ms"
}

# Scenario A: Base (Small)
run_benchmarks "base"

# Scenario B: 10k files
create_dummy_files 10000
run_benchmarks 10000

# Scenario C: 50k files
create_dummy_files 40000 # Total 50k
run_benchmarks 50000

# Cleanup
echo "🧹 Cleaning up..."
rm -rf "$TARGET_DIR"

echo "🚀 Profiling Complete."
