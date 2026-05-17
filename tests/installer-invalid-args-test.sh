#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER="$ROOT/install-os.sh"
TMPDIR_TARGET=$(mktemp -d)

cleanup() { rm -rf "$TMPDIR_TARGET"; }
trap cleanup EXIT

pass=0
fail=0

assert_fails_with() {
    local label="$1" expected_fragment="$2"
    shift 2
    local output
    output=$("$INSTALLER" "$TMPDIR_TARGET" "$@" 2>&1) && rc=0 || rc=$?

    if [ "$rc" -eq 0 ]; then
        echo "FAIL: $label — expected non-zero exit, got 0" >&2
        fail=$((fail + 1))
        return
    fi

    if echo "$output" | grep -qF -- "$expected_fragment"; then
        pass=$((pass + 1))
    else
        echo "FAIL: $label — expected '$expected_fragment' in output" >&2
        echo "  Got: $(echo "$output" | head -5)" >&2
        fail=$((fail + 1))
    fi
}

assert_error_contains() {
    local label="$1" expected_fragment="$2"
    shift 2
    local output
    output=$("$INSTALLER" "$TMPDIR_TARGET" "$@" 2>&1) && rc=0 || rc=$?

    if [ "$rc" -eq 0 ]; then
        echo "FAIL: $label — expected non-zero exit, got 0" >&2
        fail=$((fail + 1))
        return
    fi

    if echo "$output" | grep -qi -- "$expected_fragment"; then
        pass=$((pass + 1))
    else
        echo "FAIL: $label — expected pattern '$expected_fragment' in error output" >&2
        echo "  Got: $(echo "$output" | head -5)" >&2
        fail=$((fail + 1))
    fi
}

echo "=== Installer Invalid Arguments Tests ==="

# Test 1: Unknown language fails
assert_fails_with "Unknown language fails" \
    "Unknown language: 'typo-lang'" \
    --language=typo-lang --dry-run

# Test 2: Unknown language suggests closest match
assert_error_contains "Unknown language suggests php" \
    "Did you mean" \
    --language=phpp --dry-run

# Test 3: Unknown project type fails
assert_fails_with "Unknown project type fails" \
    "Unknown project type: 'typo-type'" \
    --project-type=typo-type --dry-run

# Test 4: Unknown project type suggests closest match
assert_error_contains "Unknown project type suggests" \
    "Did you mean" \
    --project-type=we-app --dry-run

# Test 5: Unknown framework fails
assert_fails_with "Unknown framework fails" \
    "Unknown framework: 'django'" \
    --framework=django --dry-run

# Test 6: Unknown repo kind fails
assert_fails_with "Unknown repo kind fails" \
    "Unknown repository kind: 'random-kind'" \
    --repo-kind=random-kind --dry-run

# Test 7: Unknown platform adapter fails
assert_fails_with "Unknown platform adapter fails" \
    "Unknown platform adapter: 'vim'" \
    --platform=vim --dry-run

# Test 8: Error message includes valid values
output=$("$INSTALLER" "$TMPDIR_TARGET" --language=typo-lang --dry-run 2>&1) && rc=0 || rc=$?
if [ "$rc" -eq 0 ]; then
    echo "FAIL: Unknown language should fail" >&2
    fail=$((fail + 1))
elif echo "$output" | grep -qF -- "Valid language values:"; then
    pass=$((pass + 1))
else
    echo "FAIL: Error should include valid values" >&2
    fail=$((fail + 1))
fi

# Test 9: Error message includes fix hint
output=$("$INSTALLER" "$TMPDIR_TARGET" --language=typo-lang --dry-run 2>&1) && rc=0 || rc=$?
if [ "$rc" -eq 0 ]; then
    echo "FAIL: Unknown language should fail" >&2
    fail=$((fail + 1))
elif echo "$output" | grep -qi -- "Fix:"; then
    pass=$((pass + 1))
else
    echo "FAIL: Error should include fix hint" >&2
    fail=$((fail + 1))
fi

# Test 10: Conflicting modes fail
assert_fails_with "Conflicting --upgrade --migrate" \
    "Conflicting install modes" \
    --upgrade --migrate

# Test 11: Typo close enough triggers suggestion
output=$("$INSTALLER" "$TMPDIR_TARGET" --language=typescrip --dry-run 2>&1) && rc=0 || rc=$?
if [ "$rc" -eq 0 ]; then
    echo "FAIL: Near-miss language should fail" >&2
    fail=$((fail + 1))
elif echo "$output" | grep -qF -- "typescript"; then
    pass=$((pass + 1))
else
    echo "FAIL: Near-miss 'typescrip' should suggest 'typescript'" >&2
    echo "  Got: $(echo "$output" | head -5)" >&2
    fail=$((fail + 1))
fi

# Test 12: Valid profiles still work
"$INSTALLER" "$TMPDIR_TARGET" --language=php --project-type=api-service --dry-run >/dev/null 2>&1
pass=$((pass + 1))

echo ""
echo "Results: $pass passed, $fail failed"
[ "$fail" -eq 0 ] || exit 1
echo "installer-invalid-args-test: ok"
