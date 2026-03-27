#!/bin/bash

# Agent OS Installer
# Usage: ./install-os.sh /path/to/project [--language=NAME] [--framework=NAME]

TARGET_DIR=$1
shift

if [ -z "$TARGET_DIR" ]; then
    echo "Usage: $0 /path/to/project [--language=NAME] [--framework=NAME]"
    exit 1
fi

echo "🚀 Installing Agent OS into $TARGET_DIR..."

# 1. Create target and .agents
mkdir -p "$TARGET_DIR/.agents"

# 2. Copy the Universal OS Core
cp -r .agents/* "$TARGET_DIR/.agents/"

# 3. Copy Local Blueprints from scaffolds/ to Root
# This is the primary use for the scaffolds folder.
cp scaffolds/AGENTS.md "$TARGET_DIR/AGENTS.md"
cp scaffolds/TODO.md "$TARGET_DIR/TODO.md"
cp scaffolds/BUGS.md "$TARGET_DIR/BUGS.md"

# 4. Handle Language Specifics (Profiles)
for arg in "$@"; do
    case $arg in
        --language=*)
        LANG="${arg#*=}"
        if [ -f ".agents/governance/profiles/languages/$LANG.md" ]; then
            echo "📦 Adding language profile: $LANG"
            cp ".agents/governance/profiles/languages/$LANG.md" "$TARGET_DIR/.agents/language-specific/$LANG.md"
        fi
        ;;
        --framework=*)
        FRAME="${arg#*=}"
        if [ -f ".agents/governance/profiles/frameworks/$FRAME.md" ]; then
            echo "📦 Adding framework profile: $FRAME"
            cp ".agents/governance/profiles/frameworks/$FRAME.md" "$TARGET_DIR/.agents/language-specific/$FRAME.md"
        fi
        ;;
    esac
done

echo "✅ Agent OS installed successfully!"
echo "Next steps: cd $TARGET_DIR and customize your AGENTS.md"
