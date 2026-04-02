#!/bin/bash
set -euo pipefail

# Agent Harness Installer
# Usage: ./install-os.sh /path/to/project [--language=NAME] [--framework=NAME] [--repository-profile=NAME] [--platform=NAME]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-}"
SELECTED_LANGUAGES=()
SELECTED_FRAMEWORKS=()
SELECTED_REPOSITORY_PROFILES=()
CODING_PROFILES=()
ARCH_PROFILES=()
PLATFORM_TARGETS=()
PLATFORM_FLAGS_EXPLICITLY_SET=false
GENERATE_ALL_PLATFORM_ADAPTERS=false

if [ -z "$TARGET_DIR" ]; then
    echo "Usage: $0 /path/to/project [--language=NAME] [--framework=NAME] [--repository-profile=NAME] [--platform=NAME]"
    exit 1
fi

shift

echo "🚀 Installing Agent Harness into $TARGET_DIR..."

format_code_list() {
    if [ "$#" -eq 0 ]; then
        printf '[declare explicitly]'
        return
    fi

    local joined=""
    local item
    for item in "$@"; do
        if [ -n "$joined" ]; then
            joined+=", "
        fi
        joined+="$item"
    done

    printf '%s' "$joined"
}

copy_rules_tree() {
    local target_rules_dir="$1"

    cp -R "$SCRIPT_DIR/.agents/." "$target_rules_dir/"
}

copy_visible_support_tree() {
    local relative_path="$1"
    local source_path="$SCRIPT_DIR/.agents/$relative_path"
    local target_path="$TARGET_DIR/.agents/$relative_path"

    if [ ! -d "$source_path" ]; then
        return
    fi

    mkdir -p "$target_path"
    cp -R "$source_path/." "$target_path/"
}

append_unique() {
    local item="$1"
    local existing

    for existing in "${PLATFORM_TARGETS[@]}"; do
        if [ "$existing" = "$item" ]; then
            return
        fi
    done

    PLATFORM_TARGETS+=("$item")
}

write_file() {
    local relative_path="$1"
    local target_file="$TARGET_DIR/$relative_path"

    mkdir -p "$(dirname "$target_file")"
    cat > "$target_file"
}

escape_sed_replacement() {
    printf '%s' "$1" | sed -e 's/[&|]/\\&/g'
}

# 1. Create target and .agents
mkdir -p "$TARGET_DIR/.agents"

# 2. Copy the full reusable `.agents` project into hidden `.rules`
mkdir -p "$TARGET_DIR/.agents/.rules"
copy_rules_tree "$TARGET_DIR/.agents/.rules"

# 3. Copy the visible project skeleton into `.agents`
if [ -d "$SCRIPT_DIR/scaffolds/agents-skeleton" ]; then
    cp -r "$SCRIPT_DIR/scaffolds/agents-skeleton/." "$TARGET_DIR/.agents/"
fi

# 3b. Copy reusable runtime support into the visible `.agents` workspace
copy_visible_support_tree "hooks"
copy_visible_support_tree "management/learning"
copy_visible_support_tree "management/memories"

# 4. Initialize the runtime .agent directory for memory, sessions, and strategic context
mkdir -p "$TARGET_DIR/.agent/memory"
mkdir -p "$TARGET_DIR/.agent/sessions"
mkdir -p "$TARGET_DIR/.agent/context/product"
mkdir -p "$TARGET_DIR/.agent/context/users"
mkdir -p "$TARGET_DIR/.agent/context/strategy"
mkdir -p "$TARGET_DIR/.agent/context/stakeholders"
touch "$TARGET_DIR/.agent/memory/.gitkeep"
touch "$TARGET_DIR/.agent/sessions/.gitkeep"
touch "$TARGET_DIR/.agent/context/product/.gitkeep"
touch "$TARGET_DIR/.agent/context/users/.gitkeep"
touch "$TARGET_DIR/.agent/context/strategy/.gitkeep"
touch "$TARGET_DIR/.agent/context/stakeholders/.gitkeep"

# 5. Initialize the local .agents/skills directory
mkdir -p "$TARGET_DIR/.agents/skills"
touch "$TARGET_DIR/.agents/skills/.gitkeep"

# 4. Copy the project-local AGENTS scaffold to root
cp "$SCRIPT_DIR/scaffolds/AGENTS.md" "$TARGET_DIR/AGENTS.md"

# 5. Keep merge-files.sh in sync with the latest OS version
if [ ! -f "$TARGET_DIR/merge-files.sh" ] || ! cmp -s "$SCRIPT_DIR/merge-files.sh" "$TARGET_DIR/merge-files.sh"; then
    cp "$SCRIPT_DIR/merge-files.sh" "$TARGET_DIR/merge-files.sh"
    chmod +x "$TARGET_DIR/merge-files.sh"
    echo "🧩 Synced merge-files.sh"
else
    chmod +x "$TARGET_DIR/merge-files.sh"
    echo "🧩 merge-files.sh already up to date"
fi

if [ -d "$TARGET_DIR/.agents/hooks" ]; then
    chmod +x "$TARGET_DIR/.agents/hooks/"*.sh 2>/dev/null || true
    chmod +x "$TARGET_DIR/.agents/hooks/"*.py 2>/dev/null || true
fi

if [ -f "$TARGET_DIR/.agents/management/learning/analyze-instincts.py" ]; then
    chmod +x "$TARGET_DIR/.agents/management/learning/analyze-instincts.py"
fi

# 6. Resolve selected reusable profiles for the local AGENTS scaffold
for arg in "$@"; do
    case $arg in
        --language=*)
        LANGUAGE_NAME="${arg#*=}"
        if [ -f "$SCRIPT_DIR/.agents/governance/profiles/languages/$LANGUAGE_NAME.md" ]; then
            echo "📦 Selecting language profile: $LANGUAGE_NAME"
            SELECTED_LANGUAGES+=("$LANGUAGE_NAME")
            CODING_PROFILES+=(".agents/.rules/governance/profiles/languages/$LANGUAGE_NAME.md")
        else
            echo "⚠️  Unknown reusable language profile: $LANGUAGE_NAME"
        fi

        if [ -f "$SCRIPT_DIR/.agents/governance/architecture/profiles/languages/$LANGUAGE_NAME.md" ]; then
            ARCH_PROFILES+=(".agents/.rules/governance/architecture/profiles/languages/$LANGUAGE_NAME.md")
        fi
        ;;
        --framework=*)
        FRAME="${arg#*=}"
        if [ -f "$SCRIPT_DIR/.agents/governance/profiles/frameworks/$FRAME.md" ]; then
            echo "📦 Selecting framework profile: $FRAME"
            SELECTED_FRAMEWORKS+=("$FRAME")
            CODING_PROFILES+=(".agents/.rules/governance/profiles/frameworks/$FRAME.md")
        else
            echo "⚠️  Unknown reusable framework profile: $FRAME"
        fi

        if [ -f "$SCRIPT_DIR/.agents/governance/architecture/profiles/frameworks/$FRAME.md" ]; then
            ARCH_PROFILES+=(".agents/.rules/governance/architecture/profiles/frameworks/$FRAME.md")
        fi
        ;;
        --repository-profile=*)
        REPOSITORY_PROFILE_NAME="${arg#*=}"
        if [ -f "$SCRIPT_DIR/.agents/governance/profiles/repository-kinds/$REPOSITORY_PROFILE_NAME.md" ]; then
            echo "📦 Selecting repository profile: $REPOSITORY_PROFILE_NAME"
            SELECTED_REPOSITORY_PROFILES+=(".agents/.rules/governance/profiles/repository-kinds/$REPOSITORY_PROFILE_NAME.md")
        else
            echo "⚠️  Unknown reusable repository profile: $REPOSITORY_PROFILE_NAME"
        fi
        ;;
        --platform=*)
        PLATFORM_FLAGS_EXPLICITLY_SET=true
        PLATFORM_VALUE="${arg#*=}"
        IFS=',' read -r -a PLATFORM_ITEMS <<< "$PLATFORM_VALUE"

        for PLATFORM_ITEM in "${PLATFORM_ITEMS[@]}"; do
            case "$PLATFORM_ITEM" in
                all)
                    GENERATE_ALL_PLATFORM_ADAPTERS=true
                    ;;
                claude|cursor|codex|gemini)
                    append_unique "$PLATFORM_ITEM"
                    ;;
                antigravity|native)
                    echo "ℹ️  Native AGENTS.md already covers the Antigravity-style entry point."
                    ;;
                "")
                    ;;
                *)
                    echo "⚠️  Unknown platform adapter: $PLATFORM_ITEM"
                    ;;
            esac
        done
        ;;
    esac
done

if [ "$GENERATE_ALL_PLATFORM_ADAPTERS" = true ] || [ "$PLATFORM_FLAGS_EXPLICITLY_SET" = false ]; then
    PLATFORM_TARGETS=(claude cursor codex gemini)
fi

LANGUAGE_VALUE="$(format_code_list "${SELECTED_LANGUAGES[@]}")"
FRAMEWORK_VALUE="$(format_code_list "${SELECTED_FRAMEWORKS[@]}")"
REPOSITORY_PROFILE_VALUE="$(format_code_list "${SELECTED_REPOSITORY_PROFILES[@]}")"
CODING_PROFILE_VALUE="$(format_code_list "${CODING_PROFILES[@]}")"
ARCH_PROFILE_VALUE="$(format_code_list "${ARCH_PROFILES[@]}")"

target_agents_tmp="$TARGET_DIR/AGENTS.md.tmp.$$"
if sed \
    -e "s|__AGENTS_REPOSITORY_PROFILES__|$(escape_sed_replacement "$REPOSITORY_PROFILE_VALUE")|" \
    -e "s|__AGENTS_LANGUAGES__|$(escape_sed_replacement "$LANGUAGE_VALUE")|" \
    -e "s|__AGENTS_FRAMEWORKS__|$(escape_sed_replacement "$FRAMEWORK_VALUE")|" \
    -e "s|__AGENTS_CODING_PROFILES__|$(escape_sed_replacement "$CODING_PROFILE_VALUE")|" \
    -e "s|__AGENTS_ARCH_PROFILES__|$(escape_sed_replacement "$ARCH_PROFILE_VALUE")|" \
    -e "s|__AGENTS_SECURITY_LANES__|security/**|" \
    -e "s|__AGENTS_OPERATIONS_LANES__|delivery/operations/**|" \
    "$TARGET_DIR/AGENTS.md" > "$target_agents_tmp"; then
    mv "$target_agents_tmp" "$TARGET_DIR/AGENTS.md"
else
    rm -f "$target_agents_tmp"
    exit 1
fi

generate_platform_adapters() {
    local platform

    for platform in "${PLATFORM_TARGETS[@]}"; do
        case "$platform" in
            claude)
                write_file "CLAUDE.md" <<'EOF'
# Claude Code Setup

Read and follow all rules in `.agents/AGENTS.md`.
EOF
                echo "🧩 Wrote CLAUDE.md"
                ;;
            cursor)
                write_file ".cursorrules" <<'EOF'
Read and follow all rules in `.agents/AGENTS.md`.
EOF
                echo "🧩 Wrote .cursorrules"
                ;;
            codex)
                write_file ".codex/INSTALL.md" <<'EOF'
# Codex Project Setup

Read and follow all rules in `.agents/AGENTS.md`.

Keep the Codex approval mode aligned with the harness trust tier and the
current task lane.
EOF
                echo "🧩 Wrote .codex/INSTALL.md"
                ;;
            gemini)
                write_file "GEMINI.md" <<'EOF'
Read and follow all rules in `.agents/AGENTS.md`.
EOF
                echo "🧩 Wrote GEMINI.md"
                ;;
        esac
    done
}

if [ "${#PLATFORM_TARGETS[@]}" -gt 0 ]; then
    echo "📦 Generating platform adapters: $(format_code_list "${PLATFORM_TARGETS[@]}")"
    generate_platform_adapters
fi

echo "✅ Agent Harness installed successfully!"
echo "Next steps: cd $TARGET_DIR and finalize the Applied Governance Stack in AGENTS.md"
