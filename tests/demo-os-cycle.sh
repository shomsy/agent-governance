#!/bin/bash
# demo-os-cycle.sh — Agent Harness End-to-End OS Demo
# Goal 6: Clean install -> task -> evidence -> review -> dashboard -> commit.

set -e

DEMO_DIR="/tmp/harness-demo"
rm -rf "$DEMO_DIR"
mkdir -p "$DEMO_DIR"

echo "🏁 Starting End-to-End Agent OS Demo..."

# 1. Clean Repo Install
echo "💿 Stage 1: Installing OS..."
./install-os.sh "$DEMO_DIR" --language=javascript --project-type=api-service --platform=claude >/dev/null

# 2. Run one task (Manual file creation)
echo "📝 Stage 2: Executing Task..."
echo "console.log('Harness Demo');" > "$DEMO_DIR/index.js"

# 3. Write evidence
echo "📊 Stage 3: Recording Evidence..."
mkdir -p "$DEMO_DIR/.agents/management/evidence/phases"
cat > "$DEMO_DIR/.agents/management/evidence/phases/task-complete.json" <<EOF
{
  "phase": "implementation",
  "task": "create-index",
  "status": "DONE",
  "evidence": ["index.js"]
}
EOF

# 4. Run recursive review
echo "🔎 Stage 4: Running Recursive Review..."
cp .agents/management/hooks/recursive-review-engine.sh "$DEMO_DIR/recursive-review.sh"
# Fix the script for the demo dir if needed (not needed, it takes TARGET_DIR)
chmod +x "$DEMO_DIR/recursive-review.sh"
"$DEMO_DIR/recursive-review.sh" "$DEMO_DIR"

# 5. Update dashboard
echo "📊 Stage 5: Updating Human Dashboard..."
sed -i "s/\[declare explicitly\]/V3_DEMO_READY/g" "$DEMO_DIR/EVIDENCE/CURRENT.md"

# 6. Commit
echo "💾 Stage 6: Committing changes..."
cd "$DEMO_DIR"
git init >/dev/null
git add .
git commit -m "feat: complete initial task under harness governance" >/dev/null

echo "🚀 Demo Complete! FULL_CYCLE: PASS."
