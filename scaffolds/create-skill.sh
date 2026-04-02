#!/bin/bash
set -euo pipefail

usage() {
    cat <<'EOF'
Usage:
  ./scaffolds/create-skill.sh <skills-dir> <skill-name> <description> [--trust-tier=T0] [--author=NAME] [--tags=a,b] [--version=0.1.0]

Example:
  ./scaffolds/create-skill.sh .agents/skills lint-fixer "Fixes lint errors in JS and TS files" --trust-tier=T1 --tags=lint,javascript
EOF
}

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
    usage
    exit 0
fi

if [ "$#" -lt 3 ]; then
    usage
    exit 1
fi

SKILLS_DIR="$1"
SKILL_NAME="$2"
DESCRIPTION="$3"
shift 3

TRUST_TIER="T0"
AUTHOR=""
TAGS=""
VERSION="0.1.0"

for arg in "$@"; do
    case "$arg" in
        --trust-tier=*)
            TRUST_TIER="${arg#*=}"
            ;;
        --author=*)
            AUTHOR="${arg#*=}"
            ;;
        --tags=*)
            TAGS="${arg#*=}"
            ;;
        --version=*)
            VERSION="${arg#*=}"
            ;;
        *)
            echo "Unknown option: $arg" >&2
            usage
            exit 2
            ;;
    esac
done

if ! printf '%s' "$SKILL_NAME" | grep -Eq '^[a-z0-9][a-z0-9-]*$'; then
    echo "skill-name must be kebab-case ASCII" >&2
    exit 2
fi

case "$TRUST_TIER" in
    T0|T1|T2|T3) ;;
    *)
        echo "trust tier must be one of T0, T1, T2, T3" >&2
        exit 2
        ;;
esac

TARGET_DIR="$SKILLS_DIR/$SKILL_NAME"
if [ -e "$TARGET_DIR" ]; then
    echo "target already exists: $TARGET_DIR" >&2
    exit 2
fi

mkdir -p "$TARGET_DIR/agents" "$TARGET_DIR/scripts" "$TARGET_DIR/tests" "$TARGET_DIR/examples" "$TARGET_DIR/resources"

if [ -n "$TAGS" ]; then
    TAGS_LINE="tags: [$(printf '%s' "$TAGS" | sed 's/,/, /g')]"
else
    TAGS_LINE="tags: []"
fi

if [ -n "$AUTHOR" ]; then
    AUTHOR_LINE="author: $AUTHOR"
else
    AUTHOR_LINE="author: <replace>"
fi

cat > "$TARGET_DIR/SKILL.md" <<EOF
---
name: $SKILL_NAME
description: $DESCRIPTION
trust_tier: $TRUST_TIER
version: $VERSION
$TAGS_LINE
$AUTHOR_LINE
---

## Purpose

- Define when this skill should be used.
- Keep the description optimized for search and intent matching.

## Inputs

- What the user provides
- Required files or paths

## Steps

1. Inspect the relevant context.
2. Apply the smallest correct change.
3. Validate the result.

## Outputs

- Expected artifacts
- Validation signals

## Limits

- State any safety or trust-tier boundaries here.
EOF

cat > "$TARGET_DIR/agents/openai.yaml" <<'EOF'
tools: []

permissions:
  network: false
  file_write: false
  shell_exec: false
EOF

cat > "$TARGET_DIR/scripts/run.sh" <<'EOF'
#!/bin/bash
set -euo pipefail

echo "Implement the runtime helper for this skill."
EOF

cat > "$TARGET_DIR/scripts/validate.sh" <<'EOF'
#!/bin/bash
set -euo pipefail

echo "Implement validation for this skill."
EOF

cat > "$TARGET_DIR/tests/test.sh" <<'EOF'
#!/bin/bash
set -euo pipefail

echo "Add concrete tests for this skill."
EOF

cat > "$TARGET_DIR/examples/example.md" <<'EOF'
# Example Usage

Describe one realistic invocation and the expected output.
EOF

cat > "$TARGET_DIR/resources/template.md" <<'EOF'
# Resource Template

Put reusable helper content for the skill here.
EOF

chmod +x "$TARGET_DIR/scripts/run.sh" "$TARGET_DIR/scripts/validate.sh" "$TARGET_DIR/tests/test.sh"

echo "Created skill scaffold at $TARGET_DIR"
