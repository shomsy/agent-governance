#!/usr/bin/env bash
# framework-dictionary-test.sh — Framework Dictionary Integrity Tests
#
# Verifies:
# - Allowed legitimate terms pass
# - Forbidden fake abstractions fail
# - Context-aware evaluation works
# - Dictionary lookup works
# - Malformed dictionary entry fails
#
# Exit codes: 0 = all pass, 1 = failures

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DICT_DIR="$PROJECT_ROOT/.agents/governance/framework-dictionary"
DIAGNOSE="$PROJECT_ROOT/.agents/skills/bin/agent-harness-diagnose.py"
VALIDATE="$PROJECT_ROOT/.agents/skills/bin/validate-dictionary.py"

PASS=0
FAIL=0
TOTAL=0

pass() {
    PASS=$((PASS + 1))
    TOTAL=$((TOTAL + 1))
    echo "  ✅ PASS: $1"
}

fail() {
    FAIL=$((FAIL + 1))
    TOTAL=$((TOTAL + 1))
    echo "  ❌ FAIL: $1"
}

echo "============================================="
echo "FRAMEWORK DICTIONARY TESTS"
echo "============================================="

# Test 1: Dictionary validation passes
echo ""
echo "Test 1: Dictionary validates cleanly"
if python3 "$VALIDATE" "$DICT_DIR" > /dev/null 2>&1; then
    pass "Dictionary validation passes"
else
    fail "Dictionary validation fails"
fi

# Test 2: Index.json has expected term count
echo ""
echo "Test 2: Index has minimum term count"
TERM_COUNT=$(python3 -c "import json; d=json.load(open('$DICT_DIR/index.json')); print(d['total_terms'])")
if [ "$TERM_COUNT" -ge 30 ]; then
    pass "Index has $TERM_COUNT terms (>= 30)"
else
    fail "Index has only $TERM_COUNT terms (< 30)"
fi

# Test 3: All required ecosystems present
echo ""
echo "Test 3: Required ecosystems present"
for eco in php javascript infrastructure; do
    if python3 -c "
import json
d = json.load(open('$DICT_DIR/index.json'))
assert '$eco' in d['ecosystems'], 'Missing $eco'
" 2>/dev/null; then
        pass "Ecosystem '$eco' present"
    else
        fail "Ecosystem '$eco' missing"
    fi
done

# Test 4: Key PHP terms exist
echo ""
echo "Test 4: Key PHP terms exist in dictionary"
for term in ServiceProvider Middleware Controller Migration Repository Event Command Facade Policy; do
    if python3 -c "
import json
d = json.load(open('$DICT_DIR/index.json'))
assert '$term' in d['terms'], 'Missing $term'
" 2>/dev/null; then
        pass "Term '$term' exists"
    else
        fail "Term '$term' missing"
    fi
done

# Test 5: Each term has required sections
echo ""
echo "Test 5: Terms have required sections"
REQUIRED_SECTIONS=("Term" "Classification" "Purpose" "Why Allowed" "Allowed Contexts" "Forbidden Misuse" "Ecosystem References" "Allowed Patterns" "Forbidden Patterns")
MISSING_SECTIONS=0
for md_file in "$DICT_DIR"/php/*.md "$DICT_DIR"/javascript/*.md "$DICT_DIR"/infrastructure/*.md; do
    [ -f "$md_file" ] || continue
    basename_file=$(basename "$md_file")
    for section in "${REQUIRED_SECTIONS[@]}"; do
        if ! grep -q "^# ${section}$" "$md_file"; then
            fail "$basename_file missing section: $section"
            MISSING_SECTIONS=$((MISSING_SECTIONS + 1))
        fi
    done
done
if [ "$MISSING_SECTIONS" -eq 0 ]; then
    pass "All terms have all required sections"
fi

# Test 6: Allowed legitimate terms in components/ are recognized
echo ""
echo "Test 6: Legitimate component directory names recognized"
# Create a temp project with known-good structure
TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR/.agents/governance/framework-dictionary"
cp "$DICT_DIR/index.json" "$TMPDIR/.agents/governance/framework-dictionary/"
mkdir -p "$TMPDIR/components/API/Contracts"
mkdir -p "$TMPDIR/components/DeveloperTools/Diagnostics"
mkdir -p "$TMPDIR/components/Operations/Events"
touch "$TMPDIR/AGENTS.md"
mkdir -p "$TMPDIR/.agents/management/evidence/generated"

# Run diagnose and check Contracts/Diagnostics/Events are allowed
RESULT=$(python3 "$DIAGNOSE" "$TMPDIR" --json 2>/dev/null || true)
ALLOWED=$(echo "$RESULT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    naming = d.get('checks', {}).get('naming_compliance', {})
    violations = naming.get('violations', [])
    suspicious = naming.get('metrics', {}).get('suspicious_contexts', 0)
    violation_paths = [v.get('path', '') for v in violations]
    has_contracts = any('Contracts' in p for p in violation_paths)
    has_diagnostics = any('Diagnostics' in p for p in violation_paths)
    has_events = any('Events' in p for p in violation_paths)
    if has_contracts or has_diagnostics or has_events or suspicious > 0:
        print('FAIL')
    else:
        print('PASS')
except:
    print('ERROR')
" 2>/dev/null || echo "ERROR")

if [ "$ALLOWED" = "PASS" ]; then
    pass "Legitimate component dirs (Contracts, Diagnostics, Events) recognized"
else
    fail "Legitimate component dirs not properly recognized (got: $ALLOWED)"
fi
rm -rf "$TMPDIR"

# Test 7: Forbidden fake abstractions are rejected
echo ""
echo "Test 7: Forbidden fake abstractions are rejected"
TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR/.agents/governance/framework-dictionary"
cp "$DICT_DIR/index.json" "$TMPDIR/.agents/governance/framework-dictionary/"
mkdir -p "$TMPDIR/src/Helpers"
mkdir -p "$TMPDIR/src/Utils"
touch "$TMPDIR/AGENTS.md"
mkdir -p "$TMPDIR/.agents/management/evidence/generated"

RESULT=$(python3 "$DIAGNOSE" "$TMPDIR" --json 2>/dev/null || true)
REJECTED=$(echo "$RESULT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    naming = d.get('checks', {}).get('naming_compliance', {})
    violations = naming.get('violations', [])
    violation_paths = [v.get('path', '') for v in violations]
    has_helpers = any('Helpers' in p for p in violation_paths)
    has_utils = any('Utils' in p for p in violation_paths)
    if has_helpers and has_utils:
        print('PASS')
    else:
        print('FAIL')
except:
    print('ERROR')
" 2>/dev/null || echo "ERROR")

if [ "$REJECTED" = "PASS" ]; then
    pass "Forbidden dirs (Helpers, Utils) properly rejected"
else
    fail "Forbidden dirs not properly rejected"
fi
rm -rf "$TMPDIR"

# Test 8: Context-aware evaluation — Support in tests/ is allowed
echo ""
echo "Test 8: Context-aware evaluation (Support in tests/)"
TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR/.agents/governance/framework-dictionary"
cp "$DICT_DIR/index.json" "$TMPDIR/.agents/governance/framework-dictionary/"
mkdir -p "$TMPDIR/tests/Support"
touch "$TMPDIR/AGENTS.md"
mkdir -p "$TMPDIR/.agents/management/evidence/generated"

RESULT=$(python3 "$DIAGNOSE" "$TMPDIR" --json 2>/dev/null || true)
CONTEXT_OK=$(echo "$RESULT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    naming = d.get('checks', {}).get('naming_compliance', {})
    violations = naming.get('violations', [])
    violation_paths = [v.get('path', '') for v in violations]
    has_support = any('Support' in p for p in violation_paths)
    if has_support:
        print('FAIL')
    else:
        print('PASS')
except:
    print('ERROR')
" 2>/dev/null || echo "ERROR")

if [ "$CONTEXT_OK" = "PASS" ]; then
    pass "Support in tests/ correctly allowed via context"
else
    fail "Support in tests/ incorrectly flagged"
fi
rm -rf "$TMPDIR"

# Test 9: Context-aware evaluation — Support in production code is flagged
echo ""
echo "Test 9: Context-aware evaluation (Support in src/ should be flagged)"
TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR/.agents/governance/framework-dictionary"
cp "$DICT_DIR/index.json" "$TMPDIR/.agents/governance/framework-dictionary/"
mkdir -p "$TMPDIR/src/Support"
touch "$TMPDIR/AGENTS.md"
mkdir -p "$TMPDIR/.agents/management/evidence/generated"

RESULT=$(python3 "$DIAGNOSE" "$TMPDIR" --json 2>/dev/null || true)
CONTEXT_FLAG=$(echo "$RESULT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    naming = d.get('checks', {}).get('naming_compliance', {})
    violations = naming.get('violations', [])
    suspicious = naming.get('metrics', {}).get('suspicious_contexts', 0)
    violation_paths = [v.get('path', '') for v in violations]
    has_support = any('Support' in p for p in violation_paths)
    if has_support or suspicious > 0:
        print('PASS')
    else:
        print('FAIL')
except:
    print('ERROR')
" 2>/dev/null || echo "ERROR")

if [ "$CONTEXT_FLAG" = "PASS" ]; then
    pass "Support in src/ correctly flagged as forbidden"
else
    fail "Support in src/ should be flagged but was not"
fi
rm -rf "$TMPDIR"

# Test 10: Malformed dictionary entry detection
echo ""
echo "Test 10: Malformed dictionary entry detection"
TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR/php"
cat > "$TMPDIR/index.json" << 'EOF'
{"version":"1.0.0","terms":{"BadTerm":{"classification":"test"}},"total_terms":1,"ecosystems":["php"]}
EOF
cat > "$TMPDIR/php/bad-term.md" << 'EOF'
# Term
BadTerm
# Classification
test
EOF

if python3 "$VALIDATE" "$TMPDIR" > /dev/null 2>&1; then
    fail "Malformed entry was not detected"
else
    pass "Malformed entry correctly detected"
fi
rm -rf "$TMPDIR"

# Test 11: V2 schema requires 'level' field on each term
echo ""
echo "Test 11: V2 schema requires 'level' field on each term"
TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR/php"
cat > "$TMPDIR/index.json" << 'EOF'
{
  "version": "2.0.0",
  "levels": {
    "FOUNDATIONAL": "Universal concept",
    "FRAMEWORK_STANDARD": "Framework term",
    "CONTEXTUAL": "Narrow context only",
    "LEGACY_ALLOWED": "Historical",
    "DISCOURAGED": "Avoid"
  },
  "terms": {
    "NoLevelTerm": {
      "classification": "test",
      "ecosystem": ["php"],
      "allowed_contexts": ["test"],
      "forbidden_misuse": ["bad"],
      "references": ["https://example.com"]
    }
  },
  "total_terms": 1,
  "ecosystems": ["php"]
}
EOF
cat > "$TMPDIR/php/no-level-term.md" << 'EOF'
# Term
NoLevelTerm
# Classification
test
# Purpose
test
# Why Allowed
test
# Allowed Contexts
- test
# Forbidden Misuse
- bad
# Ecosystem References
- https://example.com
# Allowed Patterns
- NoLevelTerm
# Forbidden Patterns
- NoLevelTermUtil
EOF

if python3 "$VALIDATE" "$TMPDIR" > /dev/null 2>&1; then
    fail "Missing 'level' field was not detected"
else
    pass "Missing 'level' field correctly detected"
fi
rm -rf "$TMPDIR"

# Test 12: Anti-cargo-cult detection — compound fake names are rejected
echo ""
echo "Test 12: Anti-cargo-cult detection (compound fake names)"
TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR/.agents/governance/framework-dictionary"
cp "$DICT_DIR/index.json" "$TMPDIR/.agents/governance/framework-dictionary/"
mkdir -p "$TMPDIR/src/ServiceProviderManager"
mkdir -p "$TMPDIR/src/RepositoryServiceFactory"
touch "$TMPDIR/AGENTS.md"
mkdir -p "$TMPDIR/.agents/management/evidence/generated"

RESULT=$(python3 "$DIAGNOSE" "$TMPDIR" --json 2>/dev/null || true)
CARGO=$(echo "$RESULT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    naming = d.get('checks', {}).get('naming_compliance', {})
    violations = naming.get('violations', [])
    anti_cargo = naming.get('anti_cargo_cult', [])
    violation_paths = [v.get('path', '') for v in violations]
    cargo_paths = [c.get('path', '') for c in anti_cargo]
    has_sp_manager = any('ServiceProviderManager' in p for p in violation_paths + cargo_paths)
    has_repo_factory = any('RepositoryServiceFactory' in p for p in violation_paths + cargo_paths)
    if has_sp_manager and has_repo_factory:
        print('PASS')
    else:
        print('FAIL')
except:
    print('ERROR')
" 2>/dev/null || echo "ERROR")

if [ "$CARGO" = "PASS" ]; then
    pass "Cargo-cult compound names (ServiceProviderManager, RepositoryServiceFactory) detected"
else
    fail "Cargo-cult compound names not detected"
fi
rm -rf "$TMPDIR"

# Test 13: V2 levels are reported in output
echo ""
echo "Test 13: V2 levels reported in diagnostic output"
TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR/.agents/governance/framework-dictionary"
cp "$DICT_DIR/index.json" "$TMPDIR/.agents/governance/framework-dictionary/"
mkdir -p "$TMPDIR/components/Test/Daemon"
touch "$TMPDIR/AGENTS.md"
mkdir -p "$TMPDIR/.agents/management/evidence/generated"

RESULT=$(python3 "$DIAGNOSE" "$TMPDIR" --json 2>/dev/null || true)
LEVELS=$(echo "$RESULT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    naming = d.get('checks', {}).get('naming_compliance', {})
    allowed = naming.get('dictionary_exceptions', [])
    levels_found = set()
    for a in allowed:
        if 'Daemon' in a.get('name', ''):
            levels_found.add(a.get('level', ''))
    if 'FOUNDATIONAL' in levels_found:
        print('PASS')
    else:
        print('FAIL')
except:
    print('ERROR')
" 2>/dev/null || echo "ERROR")

if [ "$LEVELS" = "PASS" ]; then
    pass "Dictionary term includes level (FOUNDATIONAL) in output"
else
    fail "Level not properly reported in output"
fi
rm -rf "$TMPDIR"

# Test 14: Path constraints — allowed_paths match
echo ""
echo "Test 14: Path constraints (allowed_paths match)"
TMPDIR=$(mktemp -d)
mkdir -p "$TMPDIR/.agents/governance/framework-dictionary"
cp "$DICT_DIR/index.json" "$TMPDIR/.agents/governance/framework-dictionary/"
# Daemon in a path that matches **/Daemon/** pattern
mkdir -p "$TMPDIR/framework/System/Capabilities/Daemon"
touch "$TMPDIR/AGENTS.md"
mkdir -p "$TMPDIR/.agents/management/evidence/generated"

RESULT=$(python3 "$DIAGNOSE" "$TMPDIR" --json 2>/dev/null || true)
PATH_MATCH=$(echo "$RESULT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    naming = d.get('checks', {}).get('naming_compliance', {})
    violations = naming.get('violations', [])
    allowed = naming.get('dictionary_exceptions', [])
    violation_paths = [v.get('path', '') for v in violations]
    has_daemon_violation = any('Daemon' in p for p in violation_paths)
    has_daemon_allowed = any('Daemon' in a.get('name', '') for a in allowed)
    if has_daemon_allowed and not has_daemon_violation:
        print('PASS')
    else:
        print('FAIL')
except:
    print('ERROR')
" 2>/dev/null || echo "ERROR")

if [ "$PATH_MATCH" = "PASS" ]; then
    pass "Daemon in allowed path correctly allowed via path constraints"
else
    fail "Daemon in allowed path incorrectly flagged"
fi
rm -rf "$TMPDIR"

# Summary
echo ""
echo "============================================="
echo "RESULTS: $PASS passed, $FAIL failed, $TOTAL total"
echo "============================================="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
