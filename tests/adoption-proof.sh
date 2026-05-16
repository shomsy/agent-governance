#!/bin/bash
# tests/adoption-proof.sh — Agent Harness Polyglot Adoption Proof
# Goal 4: Verify architecture neutrality with PHP, Go, and Node samples.

set -e

BASE_DIR="/tmp/harness-adoption-test"
rm -rf "$BASE_DIR"
mkdir -p "$BASE_DIR"

echo "🧪 Starting Polyglot Adoption Proof..."

# 1. PHP Project
echo "🐘 Testing PHP Adoption..."
mkdir -p "$BASE_DIR/php-app"
./install-os.sh "$BASE_DIR/php-app" --language=php --project-type=api-service --platform=claude
sed -i "s/\[declare explicitly\]/INITIAL_BOOTSTRAP/g" "$BASE_DIR/php-app/EVIDENCE/CURRENT.md"
./verify-governance.sh "$BASE_DIR/php-app"
.agents/management/evidence/validation/reconcile-evidence.py "$BASE_DIR/php-app"
echo "✅ PHP Adoption Proven."

# 2. Go Project
echo "🐹 Testing Go Adoption..."
mkdir -p "$BASE_DIR/go-app"
./install-os.sh "$BASE_DIR/go-app" --language=go --project-type=cli --platform=claude
sed -i "s/\[declare explicitly\]/INITIAL_BOOTSTRAP/g" "$BASE_DIR/go-app/EVIDENCE/CURRENT.md"
./verify-governance.sh "$BASE_DIR/go-app"
.agents/management/evidence/validation/reconcile-evidence.py "$BASE_DIR/go-app"
echo "✅ Go Adoption Proven."

# 3. Node/TS Project
echo "🟢 Testing Node/TS Adoption..."
mkdir -p "$BASE_DIR/node-app"
./install-os.sh "$BASE_DIR/node-app" --language=javascript --project-type=web-app --platform=claude
sed -i "s/\[declare explicitly\]/INITIAL_BOOTSTRAP/g" "$BASE_DIR/node-app/EVIDENCE/CURRENT.md"
./verify-governance.sh "$BASE_DIR/node-app"
.agents/management/evidence/validation/reconcile-evidence.py "$BASE_DIR/node-app"
echo "✅ Node/TS Adoption Proven."

echo "🚀 ALL ADOPTIONS PROVEN (PHP, Go, Node). Architecture Neutrality: PASS."
