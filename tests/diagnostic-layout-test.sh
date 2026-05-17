#!/bin/bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIAGNOSE="$ROOT/agent-harness-diagnose.py"

pass=0
fail=0

assert_json_field() {
    local json="$1" field="$2" expected="$3" label="$4"
    local actual
    actual=$(echo "$json" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('$field','MISSING'))")
    if [ "$actual" = "$expected" ]; then
        pass=$((pass + 1))
    else
        echo "FAIL: $label — expected '$expected', got '$actual'" >&2
        fail=$((fail + 1))
    fi
}

assert_json_check_field() {
    local json="$1" check="$2" field="$3" expected="$4" label="$5"
    local actual
    actual=$(echo "$json" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['checks']['$check']['metrics'].get('$field','MISSING'))")
    if [ "$actual" = "$expected" ]; then
        pass=$((pass + 1))
    else
        echo "FAIL: $label — expected '$expected', got '$actual'" >&2
        fail=$((fail + 1))
    fi
}

echo "=== Diagnostic Layout Tests ==="

# Test 1: Adopted layout detection
TMPDIR_ADOPTED=$(mktemp -d)
mkdir -p "$TMPDIR_ADOPTED/.agents/.rules/skills/bin"
mkdir -p "$TMPDIR_ADOPTED/.agents/.rules/governance"
mkdir -p "$TMPDIR_ADOPTED/.agents/management"
mkdir -p "$TMPDIR_ADOPTED/.agents/business-logic"
mkdir -p "$TMPDIR_ADOPTED/.agents/language-specific"
mkdir -p "$TMPDIR_ADOPTED/EVIDENCE"
touch "$TMPDIR_ADOPTED/AGENTS.md"
touch "$TMPDIR_ADOPTED/EVIDENCE/CURRENT.md"
touch "$TMPDIR_ADOPTED/.agents/.rules/skills/bin/test.py"

json=$(python3 "$DIAGNOSE" "$TMPDIR_ADOPTED" --json 2>&1)
assert_json_field "$json" "detected_layout" "adopted" "Adopted layout detected"

# Verify skills_bin_path in adopted layout references .rules
echo "$json" | python3 -c "
import sys, json
d = json.load(sys.stdin)
path = d['checks']['install_health']['metrics'].get('skills_bin_path', '')
assert '.rules/skills/bin' in path, f'Expected .rules in skills path, got: {path}'
" && pass=$((pass + 1)) || { echo "FAIL: Skills bin should reference .rules" >&2; fail=$((fail + 1)); }

rm -rf "$TMPDIR_ADOPTED"

# Test 2: Legacy layout detection
TMPDIR_LEGACY=$(mktemp -d)
mkdir -p "$TMPDIR_LEGACY/.agents/skills/bin"
mkdir -p "$TMPDIR_LEGACY/.agents/governance"
mkdir -p "$TMPDIR_LEGACY/.agents/management"
mkdir -p "$TMPDIR_LEGACY/.agents/business-logic"
mkdir -p "$TMPDIR_LEGACY/.agents/language-specific"
mkdir -p "$TMPDIR_LEGACY/EVIDENCE"
touch "$TMPDIR_LEGACY/AGENTS.md"
touch "$TMPDIR_LEGACY/EVIDENCE/CURRENT.md"
touch "$TMPDIR_LEGACY/.agents/skills/bin/test.py"

json=$(python3 "$DIAGNOSE" "$TMPDIR_LEGACY" --json 2>&1)
assert_json_field "$json" "detected_layout" "legacy" "Legacy layout detected"

rm -rf "$TMPDIR_LEGACY"

# Test 3: Adopted layout takes precedence when both exist
TMPDIR_BOTH=$(mktemp -d)
mkdir -p "$TMPDIR_BOTH/.agents/.rules/skills/bin"
mkdir -p "$TMPDIR_BOTH/.agents/.rules/governance"
mkdir -p "$TMPDIR_BOTH/.agents/skills/bin"
mkdir -p "$TMPDIR_BOTH/.agents/governance"
mkdir -p "$TMPDIR_BOTH/.agents/management"
mkdir -p "$TMPDIR_BOTH/.agents/business-logic"
mkdir -p "$TMPDIR_BOTH/.agents/language-specific"
mkdir -p "$TMPDIR_BOTH/EVIDENCE"
touch "$TMPDIR_BOTH/AGENTS.md"
touch "$TMPDIR_BOTH/EVIDENCE/CURRENT.md"
touch "$TMPDIR_BOTH/.agents/.rules/skills/bin/test.py"
touch "$TMPDIR_BOTH/.agents/skills/bin/test.py"

json=$(python3 "$DIAGNOSE" "$TMPDIR_BOTH" --json 2>&1)
assert_json_field "$json" "detected_layout" "adopted" "Adopted layout takes precedence"

# Verify it uses adopted skills bin, not workspace
echo "$json" | python3 -c "
import sys, json
d = json.load(sys.stdin)
path = d['checks']['install_health']['metrics'].get('skills_bin_path', '')
assert '.rules/skills' in path, f'Expected adopted .rules path when both exist, got: {path}'
" && pass=$((pass + 1)) || { echo "FAIL: Should prefer adopted .rules skills bin" >&2; fail=$((fail + 1)); }

rm -rf "$TMPDIR_BOTH"

# Test 4: Human-readable output shows layout
TMPDIR_HR=$(mktemp -d)
mkdir -p "$TMPDIR_HR/.agents/.rules/skills/bin"
mkdir -p "$TMPDIR_HR/.agents/.rules/governance"
mkdir -p "$TMPDIR_HR/.agents/management"
mkdir -p "$TMPDIR_HR/.agents/business-logic"
mkdir -p "$TMPDIR_HR/.agents/language-specific"
mkdir -p "$TMPDIR_HR/EVIDENCE"
touch "$TMPDIR_HR/AGENTS.md"
touch "$TMPDIR_HR/EVIDENCE/CURRENT.md"

output=$(python3 "$DIAGNOSE" "$TMPDIR_HR" 2>&1)
if echo "$output" | grep -qF "Detected Layout: adopted"; then
    pass=$((pass + 1))
else
    echo "FAIL: Human output should show detected layout" >&2
    fail=$((fail + 1))
fi

rm -rf "$TMPDIR_HR"

# Test 5: Current repo runs without crashes
json=$(python3 "$DIAGNOSE" "$ROOT" --json 2>&1)
if [ -n "$json" ]; then
    pass=$((pass + 1))
else
    echo "FAIL: Diagnose on current repo should produce output" >&2
    fail=$((fail + 1))
fi

echo ""
echo "Results: $pass passed, $fail failed"
[ "$fail" -eq 0 ] || exit 1
echo "diagnostic-layout-test: ok"
