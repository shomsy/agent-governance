#!/bin/bash
# measure-performance.sh — Governance Performance Budget Tool
# Measures execution latency of governance hot paths.

set -e

echo "📊 Measuring Governance Performance Budget..."

# 1. Bootstrap Time
start=$(date +%s%N)
./install-os.sh . --validate > /dev/null
end=$(date +%s%N)
bootstrap_time=$((($end - $start)/1000000))
echo "⏱️  Bootstrap Time: ${bootstrap_time}ms"

# 2. Compilation Time
start=$(date +%s%N)
.agents/skills/bin/compile-governance.py . > /dev/null
end=$(date +%s%N)
compile_time=$((($end - $start)/1000000))
echo "⏱️  Compilation Time: ${compile_time}ms"

# 3. Linting Time
start=$(date +%s%N)
.agents/skills/bin/lint-governance.py . > /dev/null
end=$(date +%s%N)
lint_time=$((($end - $start)/1000000))
echo "⏱️  Linting Time: ${lint_time}ms"

# 4. Evidence Generation Time (Replay/Event stream)
start=$(date +%s%N)
.agents/skills/bin/replay-evidence.py . > /dev/null
end=$(date +%s%N)
evidence_gen_time=$((($end - $start)/1000000))
echo "⏱️  Evidence Generation Time: ${evidence_gen_time}ms"

# Budget thresholds
if [ "$compile_time" -gt 500 ]; then
    echo "❌ ERROR: Compilation time exceeds 500ms budget."
    exit 1
fi

if [ "$lint_time" -gt 200 ]; then
    echo "❌ ERROR: Linting time exceeds 200ms budget."
    exit 1
fi

echo "✅ Performance Budget PASSED."
