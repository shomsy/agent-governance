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
        echo "FAIL: $label — expected '$expected' not found" >&2
        fail=$((fail + 1))
    fi
}

assert_not_contains() {
    local output="$1" unexpected="$2" label="$3"
    if echo "$output" | grep -qF -- "$unexpected"; then
        echo "FAIL: $label — should NOT contain '$unexpected'" >&2
        fail=$((fail + 1))
    else
        pass=$((pass + 1))
    fi
}

assert_sorted() {
    local output="$1" label="$2"
    local sorted
    sorted=$(echo "$output" | sort)
    if [ "$output" = "$sorted" ]; then
        pass=$((pass + 1))
    else
        echo "FAIL: $label — output is not sorted" >&2
        fail=$((fail + 1))
    fi
}

assert_line_count() {
    local output="$1" expected="$2" label="$3"
    local count
    count=$(echo "$output" | grep -c . || true)
    if [ "$count" -eq "$expected" ]; then
        pass=$((pass + 1))
    else
        echo "FAIL: $label — expected $expected lines, got $count" >&2
        fail=$((fail + 1))
    fi
}

echo "=== Installer Profile Discovery Tests ==="

# Test 1: Languages are from real files, not hardcoded
langs=$("$INSTALLER" --list-languages 2>&1)
assert_contains "$langs" "php" "Languages has php"
assert_contains "$langs" "go" "Languages has go"
assert_contains "$langs" "javascript" "Languages has javascript"
assert_contains "$langs" "css" "Languages has css"
assert_contains "$langs" "nodejs" "Languages has nodejs"
assert_contains "$langs" "typescript" "Languages has typescript"
assert_line_count "$langs" 6 "Languages has exactly 6 entries"

# Test 2: Languages are sorted
assert_sorted "$langs" "Languages are sorted"

# Test 3: No .d subdirectories leaked
assert_not_contains "$langs" "php.d" "Languages excludes .d dirs"

# Test 4: Frameworks
frameworks=$("$INSTALLER" --list-frameworks 2>&1)
assert_contains "$frameworks" "laravel" "Frameworks has laravel"
assert_contains "$frameworks" "express" "Frameworks has express"
assert_contains "$frameworks" "react" "Frameworks has react"
assert_contains "$frameworks" "nextjs" "Frameworks has nextjs"
assert_contains "$frameworks" "v-web-components" "Frameworks has v-web-components"
assert_line_count "$frameworks" 5 "Frameworks has exactly 5 entries"

# Test 5: Project types
ptypes=$("$INSTALLER" --list-project-types 2>&1)
assert_contains "$ptypes" "api-service" "Project-types has api-service"
assert_contains "$ptypes" "web-app" "Project-types has web-app"
assert_contains "$ptypes" "cli" "Project-types has cli"
assert_contains "$ptypes" "library" "Project-types has library"
assert_contains "$ptypes" "framework" "Project-types has framework"
assert_contains "$ptypes" "monorepo" "Project-types has monorepo"
assert_contains "$ptypes" "infrastructure" "Project-types has infrastructure"
assert_line_count "$ptypes" 7 "Project-types has exactly 7 entries"

# Test 6: Repo kinds
repo_kinds=$("$INSTALLER" --list-repo-kinds 2>&1)
assert_contains "$repo_kinds" "governance-source" "Repo-kinds has governance-source"
assert_line_count "$repo_kinds" 1 "Repo-kinds has exactly 1 entry"

# Test 7: Overlays
overlays=$("$INSTALLER" --list-overlays 2>&1)
assert_contains "$overlays" "strict-security" "Overlays has strict-security"
assert_contains "$overlays" "high-performance" "Overlays has high-performance"
assert_contains "$overlays" "experimental" "Overlays has experimental"
assert_contains "$overlays" "enterprise-regulated" "Overlays has enterprise-regulated"
assert_line_count "$overlays" 4 "Overlays has exactly 4 entries"

# Test 8: --help includes real values from --list-*
help=$("$INSTALLER" --help 2>&1)
assert_contains "$help" "php" "Help references php"
assert_contains "$help" "laravel" "Help references laravel"
assert_contains "$help" "api-service" "Help references api-service"

echo ""
echo "Results: $pass passed, $fail failed"
[ "$fail" -eq 0 ] || exit 1
echo "installer-profile-discovery-test: ok"
