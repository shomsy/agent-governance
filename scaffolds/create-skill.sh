#!/bin/bash
set -euo pipefail

# create-skill.sh
# Generates the directory layout and compliant YAML frontmatter for a new Agent Skill.

SKILL_NAME="${1:-}"

if [ -z "$SKILL_NAME" ]; then
    echo "Usage: ./create-skill.sh <skill-name-lowercase>"
    echo "Example: ./create-skill.sh create-ui-component"
    exit 1
fi

SKILL_DIR=".agents/skills/$SKILL_NAME"

echo "Scaffolding new skill: $SKILL_NAME..."

mkdir -p "$SKILL_DIR/scripts"
mkdir -p "$SKILL_DIR/examples"

cat > "$SKILL_DIR/SKILL.md" <<EOF
---
name: $SKILL_NAME
description: "ENTER_DESCRIPTION_HERE (Optimize this field for Cognitive Search Optimization so the agent knows when to invoke it)"
version: 1.0.0
author: "Agent OS"
capabilities:
  - Add relevant system capabilities
---

# $SKILL_NAME

## 1) Purpose
Explain what this skill provides to the orchestration layer.

## 2) Execution Trigger
When should the Agent choose to invoke this skill instead of standard logic?

## 3) Steps
1. First step
2. Second step

## 4) Success Criteria
Strict validation rules before the skill exits.
EOF

echo "✅ Skill '$SKILL_NAME' successfully scaffolded at: $SKILL_DIR"
echo "Next step: Open $SKILL_DIR/SKILL.md and fill in the CSO description."
