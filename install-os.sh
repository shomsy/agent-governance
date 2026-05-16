#!/bin/bash
set -euo pipefail

# Agent Harness Installer
# Usage: ./install-os.sh /path/to/project [--language=NAME] [--framework=NAME] [--repository-profile=NAME] [--platform=NAME] [--dry-run] [--validate] [--upgrade] [--migrate]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-}"
SELECTED_LANGUAGES=()
SELECTED_FRAMEWORKS=()
SELECTED_REPOSITORY_PROFILES=()
PROJECT_TYPES=()
CODING_PROFILES=()
ARCH_PROFILES=()
PLATFORM_TARGETS=()
PLATFORM_FLAGS_EXPLICITLY_SET=false
GENERATE_ALL_PLATFORM_ADAPTERS=false
DRY_RUN=false
VALIDATE_ONLY=false
IS_UPGRADE=false
IS_MIGRATION=false

if [ -z "$TARGET_DIR" ]; then
    echo "Usage: $0 /path/to/project [options...]"
    exit 1
fi

# Convert TARGET_DIR to absolute path if it exists
if [ -d "$TARGET_DIR" ]; then
    TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
fi

shift

# Helper functions
format_code_list() {
    if [ "$#" -eq 0 ]; then
        printf '[declare explicitly]'
        return
    fi
    local joined=""
    local item
    for item in "$@"; do
        [ -n "$joined" ] && joined+=", "
        joined+="$item"
    done
    printf '%s' "$joined"
}

copy_rules_tree() {
    local target_rules_dir="$1"
    mkdir -p "$target_rules_dir"
    # Avoid recursive copy of .rules or .agents into .rules
    for item in "$SCRIPT_DIR/.agents/"*; do
        [ -e "$item" ] || continue
        base=$(basename "$item")
        if [ "$base" != ".rules" ] && [ "$base" != ".agents" ]; then
            cp -R "$item" "$target_rules_dir/"
        fi
    done
    # Also copy hidden files except .rules
    for item in "$SCRIPT_DIR/.agents/".*; do
        [ -e "$item" ] || continue
        base=$(basename "$item")
        if [ "$base" != ".rules" ] && [ "$base" != ".agents" ] && [ "$base" != "." ] && [ "$base" != ".." ]; then
            cp -R "$item" "$target_rules_dir/"
        fi
    done
}

copy_visible_support_tree() {
    local relative_path="$1"
    local source_path="$SCRIPT_DIR/.agents/$relative_path"
    local target_path="$TARGET_DIR/.agents/$relative_path"
    [ ! -d "$source_path" ] && return
    mkdir -p "$target_path"
    cp -R "$source_path/." "$target_path/"
}

append_unique() {
    local item="$1"
    local existing
    for existing in "${PLATFORM_TARGETS[@]}"; do
        [ "$existing" = "$item" ] && return
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

# --- Phase 1: Argument Parsing ---
for arg in "$@"; do
    case $arg in
        --language=*)
        LANGUAGE_NAME="${arg#*=}"
        if [ -f "$SCRIPT_DIR/.agents/governance/profiles/languages/$LANGUAGE_NAME.md" ]; then
            SELECTED_LANGUAGES+=("$LANGUAGE_NAME")
            CODING_PROFILES+=(".agents/.rules/governance/profiles/languages/$LANGUAGE_NAME.md")
            if [ -f "$SCRIPT_DIR/.agents/governance/architecture/profiles/languages/$LANGUAGE_NAME.md" ]; then
                ARCH_PROFILES+=(".agents/.rules/governance/architecture/profiles/languages/$LANGUAGE_NAME.md")
            fi
        else
            echo "⚠️  Unknown reusable language profile: $LANGUAGE_NAME"
        fi
        ;;
        --framework=*)
        FRAME="${arg#*=}"
        if [ -f "$SCRIPT_DIR/.agents/governance/profiles/frameworks/$FRAME.md" ]; then
            SELECTED_FRAMEWORKS+=("$FRAME")
            CODING_PROFILES+=(".agents/.rules/governance/profiles/frameworks/$FRAME.md")
            if [ -f "$SCRIPT_DIR/.agents/governance/architecture/profiles/frameworks/$FRAME.md" ]; then
                ARCH_PROFILES+=(".agents/.rules/governance/architecture/profiles/frameworks/$FRAME.md")
            fi
        else
            echo "⚠️  Unknown reusable framework profile: $FRAME"
        fi
        ;;
        --repository-profile=*)
        REPOSITORY_PROFILE_NAME="${arg#*=}"
        if [ -f "$SCRIPT_DIR/.agents/governance/profiles/repository-kinds/$REPOSITORY_PROFILE_NAME.md" ]; then
            SELECTED_REPOSITORY_PROFILES+=("$REPOSITORY_PROFILE_NAME")
        else
            echo "⚠️  Unknown reusable repository profile: $REPOSITORY_PROFILE_NAME"
        fi
        ;;
        --project-type=*)
        TYPE="${arg#*=}"
        if [ -f "$SCRIPT_DIR/.agents/governance/profiles/project-types/$TYPE.md" ]; then
            PROJECT_TYPES+=("$TYPE")
            CODING_PROFILES+=(".agents/.rules/governance/profiles/project-types/$TYPE.md")
        else
            echo "⚠️  Unknown reusable project type: $TYPE"
        fi
        ;;
        --repo-kind=*)
        KIND="${arg#*=}"
        if [ -f "$SCRIPT_DIR/.agents/governance/profiles/repository-kinds/$KIND.md" ]; then
            SELECTED_REPOSITORY_PROFILES+=("$KIND")
        else
            echo "⚠️  Unknown reusable repository kind: $KIND"
        fi
        ;;
        --platform=*)
        PLATFORM_FLAGS_EXPLICITLY_SET=true
        PLATFORM_VALUE="${arg#*=}"
        IFS=',' read -ra ADAPTERS <<< "$PLATFORM_VALUE"
        for PLATFORM_ITEM in "${ADAPTERS[@]}"; do
            case $PLATFORM_ITEM in
                claude|cursor|codex|gemini|opencode|cline)
                    append_unique "$PLATFORM_ITEM"
                    ;;
                all)
                    GENERATE_ALL_PLATFORM_ADAPTERS=true
                    ;;
                *)
                    echo "⚠️  Unknown platform adapter: $PLATFORM_ITEM"
                    ;;
            esac
        done
        ;;
        --dry-run)
        DRY_RUN=true
        ;;
        --validate)
        VALIDATE_ONLY=true
        ;;
        --upgrade)
        IS_UPGRADE=true
        ;;
        --migrate)
        IS_MIGRATION=true
        ;;
    esac
done

# --- Phase 2: Action Branching ---

if [ "$VALIDATE_ONLY" = true ]; then
    echo "🔍 Validating V3 OS Installation at $TARGET_DIR..."
    if [ ! -d "$TARGET_DIR/.agents/.rules" ]; then
        echo "❌ OS not installed."
        exit 1
    fi
    echo "✅ OS Validation Passed."
    exit 0
fi

if [ "$DRY_RUN" = true ]; then
    echo "🧪 DRY RUN MODE: No files will be modified."
    exit 0
fi

echo "🚀 Installing Agent Harness into $TARGET_DIR..."

# --- Phase 3: Execution ---

# 1. Archive legacy if migration
if [ "$IS_MIGRATION" = true ]; then
    echo "🔄 MIGRATION MODE: Archiving legacy structures..."
    mkdir -p "$TARGET_DIR/.agents/archive/legacy"
    for f in BUGS.md TODO.md; do
        [ -f "$TARGET_DIR/.agents/management/$f" ] && mv "$TARGET_DIR/.agents/management/$f" "$TARGET_DIR/.agents/archive/legacy/"
    done
    echo "✅ Legacy structures archived."
fi

# 2. Upgrade if requested
if [ "$IS_UPGRADE" = true ]; then
    echo "🔼 UPGRADE MODE: Updating .rules engine only."
    rm -rf "$TARGET_DIR/.agents/.rules"
fi

# 3. Create structure
mkdir -p "$TARGET_DIR/.agents/.rules"
copy_rules_tree "$TARGET_DIR/.agents/.rules"

if [ -d "$SCRIPT_DIR/scaffolds/agents-skeleton" ]; then
    cp -r "$SCRIPT_DIR/scaffolds/agents-skeleton/." "$TARGET_DIR/.agents/"
fi

copy_visible_support_tree "hooks"
copy_visible_support_tree "management/learning"
copy_visible_support_tree "management/memories"

for d in memory sessions context/product context/users context/strategy context/stakeholders skills; do
    mkdir -p "$TARGET_DIR/.agents/$d"
    touch "$TARGET_DIR/.agents/$d/.gitkeep"
done

if [ -d "$SCRIPT_DIR/scaffolds/evidence-dashboard" ]; then
    mkdir -p "$TARGET_DIR/EVIDENCE"
    cp -r "$SCRIPT_DIR/scaffolds/evidence-dashboard/." "$TARGET_DIR/EVIDENCE/"
    echo "📊 Created EVIDENCE/ human dashboard"
fi

for evidence_subdir in phases reviews raw validation security performance releases truth; do
    mkdir -p "$TARGET_DIR/.agents/management/evidence/$evidence_subdir"
    touch "$TARGET_DIR/.agents/management/evidence/$evidence_subdir/.gitkeep"
done

mkdir -p "$TARGET_DIR/.agents/config"
[ ! -f "$TARGET_DIR/.agents/config/project.json" ] && cp "$SCRIPT_DIR/scaffolds/agents-skeleton/.agents/config/project.json" "$TARGET_DIR/.agents/config/project.json" 2>/dev/null || true

# 4. Root contracts
if [ -f "$TARGET_DIR/AGENTS.md" ]; then
    cp "$TARGET_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md.bak"
fi
cp "$SCRIPT_DIR/scaffolds/AGENTS.md" "$TARGET_DIR/AGENTS.md"

if [ ! -f "$TARGET_DIR/merge-files.sh" ] || ! cmp -s "$SCRIPT_DIR/merge-files.sh" "$TARGET_DIR/merge-files.sh"; then
    cp "$SCRIPT_DIR/merge-files.sh" "$TARGET_DIR/merge-files.sh"
    chmod +x "$TARGET_DIR/merge-files.sh"
    echo "🧩 Synced merge-files.sh"
else
    chmod +x "$TARGET_DIR/merge-files.sh"
    echo "🧩 merge-files.sh already up to date"
fi

chmod +x "$TARGET_DIR/.agents/hooks/"* 2>/dev/null || true
[ -f "$TARGET_DIR/.agents/management/learning/analyze-instincts.py" ] && chmod +x "$TARGET_DIR/.agents/management/learning/analyze-instincts.py"

# 5. Profile replacement
LANGUAGE_VALUE="$(format_code_list "${SELECTED_LANGUAGES[@]}")"
FRAMEWORK_VALUE="$(format_code_list "${SELECTED_FRAMEWORKS[@]}")"
REPOSITORY_PROFILE_VALUE="$(format_code_list "${SELECTED_REPOSITORY_PROFILES[@]}")"
CODING_PROFILE_VALUE="$(format_code_list "${CODING_PROFILES[@]}")"
ARCH_PROFILE_VALUE="$(format_code_list "${ARCH_PROFILES[@]}")"
PROJECT_TYPE_VALUE="$(format_code_list "${PROJECT_TYPES[@]}")"

target_agents_tmp="$TARGET_DIR/AGENTS.md.tmp.$$"
sed \
    -e "s|__AGENTS_REPOSITORY_PROFILES__|$(escape_sed_replacement "$REPOSITORY_PROFILE_VALUE")|" \
    -e "s|__AGENTS_LANGUAGES__|$(escape_sed_replacement "$LANGUAGE_VALUE")|" \
    -e "s|__AGENTS_FRAMEWORKS__|$(escape_sed_replacement "$FRAMEWORK_VALUE")|" \
    -e "s|__AGENTS_CODING_PROFILES__|$(escape_sed_replacement "$CODING_PROFILE_VALUE")|" \
    -e "s|__AGENTS_PROJECT_TYPES__|$(escape_sed_replacement "$PROJECT_TYPE_VALUE")|" \
    -e "s|__AGENTS_ARCH_PROFILES__|$(escape_sed_replacement "$ARCH_PROFILE_VALUE")|" \
    -e "s|__AGENTS_SECURITY_LANES__|security/**|" \
    -e "s|__AGENTS_OPERATIONS_LANES__|delivery/operations/**|" \
    "$TARGET_DIR/AGENTS.md" > "$target_agents_tmp"
mv "$target_agents_tmp" "$TARGET_DIR/AGENTS.md"

# 6. Platform Adapters
if [ "$PLATFORM_FLAGS_EXPLICITLY_SET" = false ] || [ "$GENERATE_ALL_PLATFORM_ADAPTERS" = true ]; then
    PLATFORM_TARGETS=(claude cursor codex gemini)
fi

for PLATFORM_ITEM in "${PLATFORM_TARGETS[@]}"; do
    case $PLATFORM_ITEM in
        claude)
            write_file "CLAUDE.md" <<'ADAPTER'
# Agent Harness — Claude Desktop Profile

## Operational Truth
- Use `AGENTS.md` as primary context.
- Use `EVIDENCE/` for human dashboards.
- Use `.agents/management/evidence/` for machine-verifiable proof.

## Tooling
- Verify: `./verify-governance.sh`
- Merge: `./merge-files.sh . --pieces=4`
ADAPTER
            echo "🧩 Wrote CLAUDE.md"
            ;;
        cursor)
            write_file ".cursorrules" <<'ADAPTER'
# Cursor Rules — Agent Harness Profile
- Read AGENTS.md on every session start.
- Follow .agents/governance/ standards strictly.
- Evidence all changes in .agents/management/evidence/.
ADAPTER
            echo "🧩 Wrote .cursorrules"
            ;;
        codex)
            mkdir -p "$TARGET_DIR/.codex"
            write_file ".codex/INSTALL.md" <<'ADAPTER'
# Codex Installation
Harness V3 active. Follow .agents/ governance.
ADAPTER
            echo "🧩 Wrote .codex/INSTALL.md"
            ;;
        gemini)
            write_file "GEMINI.md" <<'ADAPTER'
# Gemini Profile
Harness V3 active. Follow .agents/ governance.
ADAPTER
            echo "🧩 Wrote GEMINI.md"
            ;;
    esac
done

echo "✅ Agent Harness installed successfully!"
echo "Next steps: cd $TARGET_DIR and finalize the Applied Governance Stack in AGENTS.md"
