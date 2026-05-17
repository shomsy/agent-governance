#!/bin/bash
set -euo pipefail

# Agent Harness OS Hardened Installer (V4.2 Enterprise)
# Usage: ./install-os.sh /path/to/project [options...]
# Options:
#   --language=NAME          Select language profile (e.g., php, go, typescript)
#   --framework=NAME         Select framework profile (e.g., laravel, nextjs, react)
#   --repository-profile=NAME Select repository kind (e.g., governance-source)
#   --project-type=NAME      Select project type (e.g., api-service, web-app)
#   --repo-kind=NAME         Same as --repository-profile
#   --platform=NAME          Generate platform adapter (claude, cursor, codex, gemini, all)
#   --dry-run                Simulate changes without writing to disk
#   --validate               Validate existing installation
#   --upgrade                Upgrade baseline rules (.rules) only, keeping local rules intact
#   --adopt                  Adopt existing project without destructive changes, establishing baseline
#   --force                  Force overwrite of conflicting local files with backups (.bak)

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
IS_ADOPT=false
IS_MIGRATION=false # legacy V1/V2 migration trigger
IS_FORCE=false

# --- Transaction Safety State Variables ---
TX_DIR="/tmp/harness-tx-$$"
INSTALL_SUCCESS=false
TX_CREATED_FILES=()
TX_UPDATED_FILES=()
TX_DELETED_RULES=false

if [ -z "$TARGET_DIR" ]; then
    echo "❌ ERROR: Target directory not specified."
    echo "Usage: $0 /path/to/project [options...]"
    exit 1
fi

# Convert TARGET_DIR to normalized absolute path to avoid symlink/path traversal risk
if [ -d "$TARGET_DIR" ]; then
    TARGET_DIR="$(cd "$TARGET_DIR" && pwd -P)"
else
    # Target directory doesn't exist yet, we will create it if not dry-run
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$TARGET_DIR"
        TARGET_DIR="$(cd "$TARGET_DIR" && pwd -P)"
    fi
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

escape_sed_replacement() {
    printf '%s' "$1" | sed -e 's/[&|]/\\&/g'
}

# --- Transaction Rollback Function ---
rollback_transaction() {
    local exit_code=$?
    # Deactivate the trap to avoid recursion during rollback
    trap - INT TERM EXIT ERR
    
    if [ "$INSTALL_SUCCESS" = "true" ]; then
        # Normal successful completion: clean up transaction folder
        rm -rf "$TX_DIR" 2>/dev/null || true
        exit "$exit_code"
    fi
    
    if [ "$DRY_RUN" = "true" ]; then
        echo "🧪 [DRY RUN] Simulated transaction rolled back safely."
        rm -rf "$TX_DIR" 2>/dev/null || true
        exit "$exit_code"
    fi
    
    echo ""
    echo "🚨 [TRANSACTION] Installation failed or interrupted! Initiating rollback..."
    
    # 1. Restore old rules folder if it was deleted on upgrade
    if [ "$TX_DELETED_RULES" = "true" ] && [ -d "$TX_DIR/old_rules" ]; then
        echo "  [↩️] Restoring baseline rules folder (.agents/.rules)..."
        rm -rf "$TARGET_DIR/.agents/.rules"
        mkdir -p "$TARGET_DIR/.agents"
        cp -rp "$TX_DIR/old_rules" "$TARGET_DIR/.agents/.rules"
    fi

    # 2. Restore updated files from backups
    for rel_path in "${TX_UPDATED_FILES[@]}"; do
        local backup_file="$TX_DIR/backups/$rel_path"
        local target_file="$TARGET_DIR/$rel_path"
        if [ -f "$backup_file" ]; then
            echo "  [↩️] Restoring file: $rel_path"
            mkdir -p "$(dirname "$target_file")"
            cp -pf "$backup_file" "$target_file"
        fi
    done
    
    # 3. Remove newly created files
    for rel_path in "${TX_CREATED_FILES[@]}"; do
        local target_file="$TARGET_DIR/$rel_path"
        if [ -f "$target_file" ]; then
            echo "  [🗑️] Deleting created file: $rel_path"
            rm -f "$target_file"
        fi
    done
    
    # 4. Clean up any empty directories created under TARGET_DIR
    if [ -d "$TARGET_DIR" ]; then
        echo "  [🧹] Cleaning up empty directories..."
        find "$TARGET_DIR" -type d -empty -delete 2>/dev/null || true
    fi
    
    rm -rf "$TX_DIR" 2>/dev/null || true
    echo "❌ [TRANSACTION] Rollback complete. Repository restored to original state."
    exit "$exit_code"
}

# Register the transaction safety trap
trap 'rollback_transaction' INT TERM EXIT ERR

# Initialize transaction backups directory
mkdir -p "$TX_DIR/backups"

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
        --repository-profile=*|--repo-kind=*)
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
        --platform=*)
        PLATFORM_FLAGS_EXPLICITLY_SET=true
        PLATFORM_VALUE="${arg#*=}"
        IFS=',' read -ra ADAPTERS <<< "$PLATFORM_VALUE"
        for PLATFORM_ITEM in "${ADAPTERS[@]}"; do
            case $PLATFORM_ITEM in
                claude|cursor|codex|gemini|opencode|cline)
                    exists=false
                    for existing in "${PLATFORM_TARGETS[@]}"; do
                        [ "$existing" = "$PLATFORM_ITEM" ] && exists=true
                    done
                    [ "$exists" = false ] && PLATFORM_TARGETS+=("$PLATFORM_ITEM")
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
        --adopt)
        IS_ADOPT=true
        ;;
        --force)
        IS_FORCE=true
        ;;
        --migrate)
        IS_MIGRATION=true
        ;;
    esac
done

if [ "$IS_UPGRADE" = false ] && [ "$IS_ADOPT" = false ] && [ "$IS_MIGRATION" = false ]; then
    IS_ADOPT=true
fi

# --- Phase 2: Action Branching ---
if [ "$VALIDATE_ONLY" = true ]; then
    echo "🔍 Validating Agent Harness OS Installation at $TARGET_DIR..."
    if [ ! -d "$TARGET_DIR/.agents/.rules" ]; then
        echo "❌ ERROR: OS baseline (.agents/.rules) missing."
        INSTALL_SUCCESS=true # prevent rollback trigger on simple exit
        exit 1
    fi
    echo "✅ OS Validation Passed."
    INSTALL_SUCCESS=true
    exit 0
fi

# --- Detect existing structures ---
HAS_AGENTS=false
HAS_AGENTS_MD=false
HAS_EVIDENCE=false

[ -d "$TARGET_DIR/.agents" ] && HAS_AGENTS=true
[ -f "$TARGET_DIR/AGENTS.md" ] && HAS_AGENTS_MD=true
[ -d "$TARGET_DIR/EVIDENCE" ] && HAS_EVIDENCE=true

echo "🔍 Detecting existing structures at $TARGET_DIR..."
echo "  - Existing .agents folder: $HAS_AGENTS"
echo "  - Existing AGENTS.md contract: $HAS_AGENTS_MD"
echo "  - Existing EVIDENCE folder: $HAS_EVIDENCE"
echo ""

# Report Classification Counters & Lists
COUNT_CREATED=0
COUNT_UPDATED=0
COUNT_PRESERVED=0
COUNT_SKIPPED=0
COUNT_CONFLICTS=0

LIST_CREATED=()
LIST_UPDATED=()
LIST_PRESERVED=()
LIST_SKIPPED=()
LIST_CONFLICTS=()
LIST_MANUAL=()

# Sync individual file safely with Transaction Backups
sync_file() {
    local src_file="$1"
    local rel_path="$2"
    local is_baseline="$3" # "true" or "false"
    local dest_file="$TARGET_DIR/$rel_path"

    local parent_dir="$(dirname "$dest_file")"
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$parent_dir"
    fi

    # Case 1: Target file does not exist
    if [ ! -f "$dest_file" ]; then
        LIST_CREATED+=("Created: $rel_path")
        COUNT_CREATED=$((COUNT_CREATED + 1))
        if [ "$DRY_RUN" = false ]; then
            TX_CREATED_FILES+=("$rel_path")
            if [ -f "$src_file" ]; then
                cp "$src_file" "$dest_file"
            else
                touch "$dest_file"
            fi
        fi
        return 0
    fi

    # Case 2: Target file exists
    if [ "$is_baseline" = "true" ]; then
        if cmp -s "$src_file" "$dest_file"; then
            LIST_SKIPPED+=("Skipped (identical baseline): $rel_path")
            COUNT_SKIPPED=$((COUNT_SKIPPED + 1))
        else
            if [ "$IS_UPGRADE" = true ] || [ "$IS_FORCE" = true ] || [ "$IS_ADOPT" = true ]; then
                LIST_UPDATED+=("Updated Baseline: $rel_path")
                COUNT_UPDATED=$((COUNT_UPDATED + 1))
                if [ "$DRY_RUN" = false ]; then
                    # Backup to transaction workspace before updating
                    mkdir -p "$(dirname "$TX_DIR/backups/$rel_path")"
                    cp -pf "$dest_file" "$TX_DIR/backups/$rel_path"
                    TX_UPDATED_FILES+=("$rel_path")
                    cp "$src_file" "$dest_file"
                fi
            else
                LIST_PRESERVED+=("Preserved Baseline (no upgrade trigger): $rel_path")
                COUNT_PRESERVED=$((COUNT_PRESERVED + 1))
            fi
        fi
    else
        if cmp -s "$src_file" "$dest_file"; then
            LIST_SKIPPED+=("Skipped (identical local): $rel_path")
            COUNT_SKIPPED=$((COUNT_SKIPPED + 1))
        else
            if [ "$IS_FORCE" = true ]; then
                LIST_UPDATED+=("Forced Overwrite: $rel_path")
                COUNT_UPDATED=$((COUNT_UPDATED + 1))
                if [ "$DRY_RUN" = false ]; then
                    # Standard developer backup file (.bak)
                    cp -pf "$dest_file" "${dest_file}.bak"
                    # Transaction rollback backup
                    mkdir -p "$(dirname "$TX_DIR/backups/$rel_path")"
                    cp -pf "$dest_file" "$TX_DIR/backups/$rel_path"
                    TX_UPDATED_FILES+=("$rel_path")
                    cp "$src_file" "$dest_file"
                fi
            else
                LIST_PRESERVED+=("Preserved Local Customization: $rel_path")
                COUNT_PRESERVED=$((COUNT_PRESERVED + 1))
                if [ "$rel_path" = "AGENTS.md" ] || [ "$rel_path" = ".agents/config/project.json" ] || [[ "$rel_path" == EVIDENCE/* ]]; then
                    LIST_CONFLICTS+=("Conflict: $rel_path (differing from baseline template)")
                    COUNT_CONFLICTS=$((COUNT_CONFLICTS + 1))
                    LIST_MANUAL+=("Merge local customizations in $rel_path with $src_file")
                fi
            fi
        fi
    fi
}

# 1. Migrate legacy structures if in migration mode
if [ "$IS_MIGRATION" = true ]; then
    echo "🔄 MIGRATION MODE: Archiving legacy structures..."
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$TARGET_DIR/.agents/archive/legacy"
        for f in BUGS.md TODO.md; do
            if [ -f "$TARGET_DIR/.agents/management/$f" ]; then
                # Move under transaction backup so we can restore if aborted
                mkdir -p "$(dirname "$TX_DIR/backups/.agents/management/$f")"
                cp -pf "$TARGET_DIR/.agents/management/$f" "$TX_DIR/backups/.agents/management/$f"
                TX_UPDATED_FILES+=(".agents/management/$f")
                mv "$TARGET_DIR/.agents/management/$f" "$TARGET_DIR/.agents/archive/legacy/"
            fi
        done
        if [ -d "$TARGET_DIR/docs/governance" ]; then
            # Backup directory structure
            mkdir -p "$TX_DIR/backups/docs"
            cp -rp "$TARGET_DIR/docs/governance" "$TX_DIR/backups/docs/"
            TX_DELETED_RULES=true # reuse trigger for directory rollbacks
            mkdir -p "$TARGET_DIR/.agents/archive/legacy_docs"
            mv "$TARGET_DIR/docs/governance" "$TARGET_DIR/.agents/archive/legacy_docs/" || true
        fi
    else
        echo "🧪 [DRY RUN] Would archive legacy structures."
    fi
fi

# 2. Recreate/Update baseline .rules directory granularly
if [ "$IS_UPGRADE" = true ] && [ "$DRY_RUN" = false ]; then
    echo "🔼 Cleaning existing baseline rules (.agents/.rules)..."
    if [ -d "$TARGET_DIR/.agents/.rules" ]; then
        # Backup the old rules directory to transaction workspace
        mkdir -p "$TX_DIR/old_rules"
        cp -rp "$TARGET_DIR/.agents/.rules" "$TX_DIR/old_rules/.rules"
        TX_DELETED_RULES=true
    fi
    rm -rf "$TARGET_DIR/.agents/.rules"
fi

# Granular copying of rules tree (Baseline files)
src_base="$SCRIPT_DIR/.agents"
dest_base=".agents/.rules"
if [ -d "$src_base" ]; then
    # Standard baseline copy - pipe through subshell safely
    while read -r src_file; do
        rel_path="${src_file#$src_base/}"
        case "$rel_path" in
            .rules/*|.agents/*|.git/*|archive/pilots/*) continue ;;
        esac
        sync_file "$src_file" "$dest_base/$rel_path" "true"
    done < <(find "$src_base" -type f)
fi

# 3. Process the agents-skeleton workspace (Local customizable files)
skeleton_base="$SCRIPT_DIR/scaffolds/agents-skeleton/.agents"
if [ -d "$skeleton_base" ]; then
    while read -r src_file; do
        rel_path="${src_file#$skeleton_base/}"
        case "$rel_path" in
            .rules/*) continue ;;
        esac
        sync_file "$src_file" ".agents/$rel_path" "false"
    done < <(find "$skeleton_base" -type f)
fi

# Add local customizable support files
skeleton_root="$SCRIPT_DIR/scaffolds/agents-skeleton"
if [ -d "$skeleton_root" ]; then
    sync_file "$skeleton_root/business-logic/README.md" ".agents/business-logic/README.md" "false"
    sync_file "$skeleton_root/language-specific/README.md" ".agents/language-specific/README.md" "false"
    sync_file "$skeleton_root/review/REVIEWS.md" ".agents/review/REVIEWS.md" "false"
    sync_file "$skeleton_root/review/archive/README.md" ".agents/review/archive/README.md" "false"
fi

# Create skeleton workspace directories and .gitkeep
dirs=(
    ".agents/memory"
    ".agents/sessions"
    ".agents/context/product"
    ".agents/context/users"
    ".agents/context/strategy"
    ".agents/context/stakeholders"
    ".agents/skills"
    ".agents/management/evidence/raw"
    ".agents/management/evidence/validation"
    ".agents/management/evidence/traces"
    ".agents/management/evidence/generated"
    ".agents/management/evidence/replay"
    ".agents/management/evidence/archive"
    ".agents/management/evidence/security"
    ".agents/management/evidence/performance"
    ".agents/management/evidence/releases"
    ".agents/management/evidence/phases"
    ".agents/management/evidence/reviews"
    ".agents/management/evidence/truth"
)
for d in "${dirs[@]}"; do
    if [ "$DRY_RUN" = false ]; then
        if [ ! -d "$TARGET_DIR/$d" ]; then
            mkdir -p "$TARGET_DIR/$d"
            TX_CREATED_FILES+=("$d/.gitkeep")
            touch "$TARGET_DIR/$d/.gitkeep"
        fi
    fi
done

# 4. Sync EVIDENCE/ dashboard (Clean V4 layout containing 5 canonical files)
evidence_src="$SCRIPT_DIR/scaffolds/evidence-dashboard"
if [ -d "$evidence_src" ]; then
    while read -r src_file; do
        rel_path="${src_file#$evidence_src/}"
        sync_file "$src_file" "EVIDENCE/$rel_path" "false"
    done < <(find "$evidence_src" -type f)
fi

# 5. Root AGENTS.md contract with placeholder replacements
tmp_agents="/tmp/AGENTS.md.tmp.$$"
cp "$SCRIPT_DIR/scaffolds/AGENTS.md" "$tmp_agents"

LANGUAGE_VALUE="$(format_code_list "${SELECTED_LANGUAGES[@]}")"
FRAMEWORK_VALUE="$(format_code_list "${SELECTED_FRAMEWORKS[@]}")"
REPOSITORY_PROFILE_VALUE="$(format_code_list "${SELECTED_REPOSITORY_PROFILES[@]}")"
CODING_PROFILE_VALUE="$(format_code_list "${CODING_PROFILES[@]}")"
ARCH_PROFILE_VALUE="$(format_code_list "${ARCH_PROFILES[@]}")"
PROJECT_TYPE_VALUE="$(format_code_list "${PROJECT_TYPES[@]}")"

target_agents_tmp="/tmp/AGENTS.md.tmp.sed.$$"
sed \
    -e "s|__AGENTS_REPOSITORY_PROFILES__|$(escape_sed_replacement "$REPOSITORY_PROFILE_VALUE")|" \
    -e "s|__AGENTS_LANGUAGES__|$(escape_sed_replacement "$LANGUAGE_VALUE")|" \
    -e "s|__AGENTS_FRAMEWORKS__|$(escape_sed_replacement "$FRAMEWORK_VALUE")|" \
    -e "s|__AGENTS_CODING_PROFILES__|$(escape_sed_replacement "$CODING_PROFILE_VALUE")|" \
    -e "s|__AGENTS_PROJECT_TYPES__|$(escape_sed_replacement "$PROJECT_TYPE_VALUE")|" \
    -e "s|__AGENTS_ARCH_PROFILES__|$(escape_sed_replacement "$ARCH_PROFILE_VALUE")|" \
    -e "s|__AGENTS_SECURITY_LANES__|security/**|" \
    -e "s|__AGENTS_OPERATIONS_LANES__|delivery/operations/**|" \
    "$tmp_agents" > "$target_agents_tmp"

sync_file "$target_agents_tmp" "AGENTS.md" "false"
rm -f "$tmp_agents" "$target_agents_tmp"

# 6. Core utilities: merge-files.sh & verify-governance.sh
sync_file "$SCRIPT_DIR/merge-files.sh" "merge-files.sh" "false"
sync_file "$SCRIPT_DIR/verify-governance.sh" "verify-governance.sh" "false"

if [ "$DRY_RUN" = false ]; then
    chmod +x "$TARGET_DIR/merge-files.sh" 2>/dev/null || true
    chmod +x "$TARGET_DIR/verify-governance.sh" 2>/dev/null || true
fi

# 7. Platform Adapters
if [ "$PLATFORM_FLAGS_EXPLICITLY_SET" = false ] || [ "$GENERATE_ALL_PLATFORM_ADAPTERS" = true ]; then
    PLATFORM_TARGETS=(claude cursor codex gemini)
fi

for PLATFORM_ITEM in "${PLATFORM_TARGETS[@]}"; do
    tmp_plat="/tmp/plat.$PLATFORM_ITEM.$$"
    case $PLATFORM_ITEM in
        claude)
            cat > "$tmp_plat" <<'ADAPTER'
# Agent Harness — Claude Desktop Profile

## Operational Truth
- Use `AGENTS.md` as primary context.
- Use `EVIDENCE/` for human dashboards.
- Use `.agents/management/evidence/` for machine-verifiable proof.

## Tooling
- Verify: `./verify-governance.sh`
- Merge: `./merge-files.sh . --pieces=4`
ADAPTER
            sync_file "$tmp_plat" "CLAUDE.md" "false"
            ;;
        cursor)
            cat > "$tmp_plat" <<'ADAPTER'
# Cursor Rules — Agent Harness Profile
- Read AGENTS.md on every session start.
- Follow .agents/governance/ standards strictly.
- Evidence all changes in .agents/management/evidence/.
ADAPTER
            sync_file "$tmp_plat" ".cursorrules" "false"
            ;;
        codex)
            cat > "$tmp_plat" <<'ADAPTER'
# Codex Installation
Harness V3 active. Follow .agents/ governance.
ADAPTER
            sync_file "$tmp_plat" ".codex/INSTALL.md" "false"
            ;;
        gemini)
            cat > "$tmp_plat" <<'ADAPTER'
# Gemini Profile
Harness V3 active. Follow .agents/ governance.
ADAPTER
            sync_file "$tmp_plat" "GEMINI.md" "false"
            ;;
    esac
    rm -f "$tmp_plat"
done

# --- Phase 4: Generate Report ---
echo "==========================================================="
echo "📋 AGENT HARNESS OS ADOPTION REPORT"
echo "Target Directory: $TARGET_DIR"
echo "Mode:             $( [ "$IS_UPGRADE" = true ] && echo "UPGRADE" || echo "ADOPT" )"
echo "Dry Run:          $DRY_RUN"
echo "==========================================================="

if [ "$DRY_RUN" = true ]; then
    echo "🧪 SIMULATED FILE OPERATIONS:"
else
    echo "✍️  REALIZED FILE OPERATIONS:"
fi

echo "📂 Created Files ($COUNT_CREATED):"
count=0
for f in "${LIST_CREATED[@]}"; do
    if [ "$count" -lt 30 ]; then
        echo "  [+] $f"
    else
        echo "  ... and $((COUNT_CREATED - 30)) more"
        break
    fi
    count=$((count + 1))
done

echo ""
echo "📂 Updated Files ($COUNT_UPDATED):"
for f in "${LIST_UPDATED[@]}"; do echo "  [*] $f"; done

echo ""
echo "📂 Preserved Local Files ($COUNT_PRESERVED):"
count=0
for f in "${LIST_PRESERVED[@]}"; do
    if [ "$count" -lt 30 ]; then
        echo "  [=] $f"
    else
        echo "  ... and $((COUNT_PRESERVED - 30)) more"
        break
    fi
    count=$((count + 1))
done

echo ""
echo "📂 Conflicts Detected ($COUNT_CONFLICTS):"
for f in "${LIST_CONFLICTS[@]}"; do echo "  [!] $f"; done

if [ ${#LIST_MANUAL[@]} -ne 0 ]; then
    echo ""
    echo "⚠️  MANUAL ACTIONS REQUIRED:"
    for act in "${LIST_MANUAL[@]}"; do echo "  - $act"; done
fi

echo "==========================================================="
echo "📊 INSTALL SUMMARY"
echo "  Created:   $COUNT_CREATED"
echo "  Updated:   $COUNT_UPDATED"
echo "  Preserved: $COUNT_PRESERVED"
echo "  Skipped:   $COUNT_SKIPPED"
echo "  Conflicts: $COUNT_CONFLICTS"
echo "==========================================================="

# Set transactional success to true to prevent rollback trigger
INSTALL_SUCCESS=true

if [ "$DRY_RUN" = true ]; then
    echo "🧪 DRY RUN MODE COMPLETE: No changes were written to disk."
else
    echo "✅ Agent Harness OS installed successfully!"
fi
