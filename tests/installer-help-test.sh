#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER="$ROOT/install-os.sh"

pass=0
fail=0

assert_contains() {
    local output="$1" expected="$2" label="$3"
    if echo "$output" | grep -qF -- "$expected"; then
        pass=$((pass + 1))
    else
        echo "FAIL: $label — expected '$expected' not found in output" >&2
        fail=$((fail + 1))
    fi
}

assert_starts_with() {
    local output="$1" expected="$2" label="$3"
    if [[ "$output" == "$expected"* ]]; then
        pass=$((pass + 1))
    else
        echo "FAIL: $label — expected output to start with '$expected'" >&2
        fail=$((fail + 1))
    fi
}

echo "=== Installer Help Tests ==="

# Test 1: --help exits 0 and starts with title
output=$("$INSTALLER" --help 2>&1)
assert_starts_with "$output" "Agent Harness OS Installer" "Help starts with title"

# Test 2: --help contains key sections
assert_contains "$output" "USAGE:" "Help contains USAGE"
assert_contains "$output" "--language" "Help contains --language flag"
assert_contains "$output" "--dry-run" "Help contains --dry-run flag"
assert_contains "$output" "EXAMPLES:" "Help contains EXAMPLES"
assert_contains "$output" "INSTALL MODES" "Help contains INSTALL MODES"
assert_contains "$output" "PROFILE SELECTION" "Help contains PROFILE SELECTION"
assert_contains "$output" "PLATFORM ADAPTERS" "Help contains PLATFORM ADAPTERS"
assert_contains "$output" "DISCOVERY:" "Help contains DISCOVERY"

# Test 3: --help lists real profile values
assert_contains "$output" "php" "Help lists php language"
assert_contains "$output" "typescript" "Help lists typescript language"
assert_contains "$output" "laravel" "Help lists laravel framework"
assert_contains "$output" "api-service" "Help lists api-service project type"
assert_contains "$output" "governance-source" "Help lists governance-source repo kind"

# Test 4: --list-languages
output=$("$INSTALLER" --list-languages 2>&1)
assert_contains "$output" "php" "List languages contains php"
assert_contains "$output" "typescript" "List languages contains typescript"
assert_contains "$output" "go" "List languages contains go"

# Test 5: --list-project-types
output=$("$INSTALLER" --list-project-types 2>&1)
assert_contains "$output" "api-service" "List project-types contains api-service"
assert_contains "$output" "web-app" "List project-types contains web-app"
assert_contains "$output" "cli" "List project-types contains cli"

# Test 6: --list-repo-kinds
output=$("$INSTALLER" --list-repo-kinds 2>&1)
assert_contains "$output" "governance-source" "List repo-kinds contains governance-source"

# Test 7: --list-frameworks
output=$("$INSTALLER" --list-frameworks 2>&1)
assert_contains "$output" "laravel" "List frameworks contains laravel"
assert_contains "$output" "nextjs" "List frameworks contains nextjs"

# Test 8: --list-overlays
output=$("$INSTALLER" --list-overlays 2>&1)
assert_contains "$output" "strict-security" "List overlays contains strict-security"

# Test 9: --help without target dir still works
output=$("$INSTALLER" --help 2>&1) && rc=0 || rc=$?
if [ "$rc" -ne 0 ]; then
    echo "FAIL: --help should work without target dir (exit $rc)" >&2
    fail=$((fail + 1))
else
    pass=$((pass + 1))
fi

# Test 10: -h is alias for --help
output=$("$INSTALLER" -h 2>&1) && rc=0 || rc=$?
if [ "$rc" -ne 0 ]; then
    echo "FAIL: -h should work like --help (exit $rc)" >&2
    fail=$((fail + 1))
else
    pass=$((pass + 1))
fi

echo ""
echo "Results: $pass passed, $fail failed"
[ "$fail" -eq 0 ] || exit 1
echo "installer-help-test: ok"
