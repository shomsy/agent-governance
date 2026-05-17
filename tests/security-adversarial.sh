#!/usr/bin/env bash
# tests/security-adversarial.sh — Shell wrapper for adversarial security tests
#
# Runs all attack simulations against the execution substrate security controls.
# Exit 0 if all pass, exit 1 if any fail.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ADVERSARY_SCRIPT="$PROJECT_ROOT/.agents/skills/bin/security-adversary.py"

if [ ! -f "$ADVERSARY_SCRIPT" ]; then
    echo "ERROR: Adversarial test runner not found at $ADVERSARY_SCRIPT"
    exit 1
fi

echo "========================================"
echo "  Security Adversarial Test Suite"
echo "========================================"
echo ""

# Run all attacks via the Python test runner
python3 "$ADVERSARY_SCRIPT" --all --dir "$PROJECT_ROOT"
exit_code=$?

echo ""

if [ $exit_code -eq 0 ]; then
    echo "All adversarial tests passed."
else
    echo "Some adversarial tests failed — review security controls."
fi

exit $exit_code
