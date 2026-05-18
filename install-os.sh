#!/bin/bash
set -euo pipefail

# Agent Harness OS Hardened Installer (V6.0 Enterprise)
# Idempotent adoption and upgrade engine with transaction safety.
#
# Usage: ./install-os.sh /path/to/project [options...]
# Options:
#   --language=NAME          Select language profile (e.g., php, go, typescript)
#   --framework=NAME         Select framework profile (e.g., laravel, nextjs, react)
#   --repository-profile=NAME Select repository kind (e.g., governance-source)
#   --project-type=NAME      Select project type (e.g., api-service, web-app)
#   --repo-kind=NAME         Same as --repository-profile
#   --project-name=NAME      Set project name for contract generation
#   --platform=NAME          Generate platform adapter (claude, cursor, codex, gemini, all)
#   --dry-run                Simulate changes without writing to disk
#   --validate               Validate existing installation
#   --upgrade                Upgrade baseline rules (.rules) only, keeping local rules intact
#   --adopt                  Adopt existing project without destructive changes, establishing baseline
#   --force                  Force overwrite of conflicting local files with backups (.bak)
#   --migrate                Legacy V1/V2 migration trigger
#   --prune-evidence         Prune stale generated evidence during evidence migration

# =============================================================================
# V6 CONSTANTS
# =============================================================================
VERSION="6.0.0"
INSTALLER_KIND="adoption-upgrade-engine"

# File ownership classification
OWNERSHIP_BASELINE="BASELINE"
OWNERSHIP_LOCAL_CUSTOMIZATION="LOCAL_CUSTOMIZATION"
OWNERSHIP_GENERATED_RUNTIME="GENERATED_RUNTIME"
OWNERSHIP_GENERATED_EPHEMERAL="GENERATED_EPHEMERAL"
OWNERSHIP_GENERATED_CACHE="GENERATED_CACHE"
OWNERSHIP_GENERATED_EVIDENCE="GENERATED_EVIDENCE"

# Runtime exclusion patterns — these are NEVER adopted from source or target
RUNTIME_EXCLUDE_PATTERNS=(
    "__pycache__"
    "*.pyc"
    "*.pyo"
    ".pytest_cache"
    "replay-snapshot*"
    "replay_snapshot*"
    "quarantine"
    "stress-output*"
    "stress_output*"
    "*.tmp"
    "*.tmp.*"
    ".DS_Store"
    "Thumbs.db"
    "*.lock"
    "node_modules"
    "vendor"
)

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
IS_MIGRATION=false
IS_FORCE=false
PRUNE_EVIDENCE=false
PROJECT_NAME=""

# --- Transaction Safety State Variables ---
TX_DIR="/tmp/harness-tx-$$"
INSTALL_SUCCESS=false
TX_CREATED_FILES=()
TX_UPDATED_FILES=()
TX_CREATED_DIRS=()
TX_DELETED_RULES=false

# --- Journal State ---
JOURNAL_DIR=""
JOURNAL_FILE=""
JOURNAL_ENTRIES=()

# --- Counters ---
COUNT_CREATED=0
COUNT_UPDATED=0
COUNT_PRESERVED=0
COUNT_SKIPPED=0
COUNT_CONFLICTS=0
COUNT_EXCLUDED=0
COUNT_MIGRATED=0

LIST_CREATED=()
LIST_UPDATED=()
LIST_PRESERVED=()
LIST_SKIPPED=()
LIST_CONFLICTS=()
LIST_MANUAL=()
LIST_EXCLUDED=()
LIST_MIGRATED=()

# Save original args before any positional manipulation
ALL_ARGS=("$@")

# =============================================================================
# EARLY EXIT DETECTION (--help, --list-*)
# Detect these flags before target directory resolution to avoid
# "Target directory not specified" errors. The actual handlers
# run after helper functions are defined (see after show_list_overlays).
# =============================================================================
EARLY_EXIT=false
for arg in "${ALL_ARGS[@]}"; do
    case "$arg" in
        --help|-h|--list-languages|--list-frameworks|--list-project-types|--list-repo-kinds|--list-overlays)
            EARLY_EXIT=true
            break
            ;;
    esac
done

# Skip target directory resolution for early-exit commands
if [ "$EARLY_EXIT" = false ]; then
# =============================================================================
# TARGET DIRECTORY RESOLUTION
# =============================================================================
if [ -z "$TARGET_DIR" ]; then
    echo "ERROR: Target directory not specified."
    echo "Usage: $0 /path/to/project [options...]"
    exit 1
fi

# Convert TARGET_DIR to normalized absolute path
if [ -d "$TARGET_DIR" ]; then
    TARGET_DIR="$(cd "$TARGET_DIR" && pwd -P)"
else
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$TARGET_DIR"
        TARGET_DIR="$(cd "$TARGET_DIR" && pwd -P)"
    fi
fi

shift
fi # end EARLY_EXIT skip

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================
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

# Normalize a project name to a filesystem-safe slug.
# Converts to lowercase, replaces non-alphanumeric with hyphens, collapses
# consecutive hyphens, strips leading/trailing hyphens.
normalize_slug() {
    local raw="$1"
    local slug
    slug=$(echo "$raw" | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-z0-9]/-/g' -e 's/--*/-/g' -e 's/^-//;s/-$//')
    printf '%s' "$slug"
}

# Auto-detect project name from config files or directory basename.
# Resolution order: --project-name flag → composer.json name → package.json name → directory basename
detect_project_name() {
    # 1. Explicit --project-name flag wins
    if [ -n "$PROJECT_NAME" ]; then
        normalize_slug "$PROJECT_NAME"
        return
    fi

    # 2. Try composer.json
    if [ -f "$TARGET_DIR/composer.json" ]; then
        local name
        name=$(python3 -c "import json,sys; d=json.load(open('$TARGET_DIR/composer.json')); print(d.get('name','').split('/')[-1])" 2>/dev/null || echo "")
        if [ -n "$name" ]; then
            normalize_slug "$name"
            return
        fi
    fi

    # 3. Try package.json
    if [ -f "$TARGET_DIR/package.json" ]; then
        local name
        name=$(python3 -c "import json,sys; d=json.load(open('$TARGET_DIR/package.json')); print(d.get('name','').split('/')[-1])" 2>/dev/null || echo "")
        if [ -n "$name" ]; then
            normalize_slug "$name"
            return
        fi
    fi

    # 4. Fall back to directory basename
    basename "$TARGET_DIR"
}

# Ensure directory exists idempotently. Only records in TX if newly created.
ensure_directory() {
    local dir_path="$1"
    if [ -f "$dir_path" ]; then
        # A regular file exists at this path — cannot create directory
        return 0
    fi
    if [ ! -d "$dir_path" ]; then
        if [ "$DRY_RUN" = false ]; then
            mkdir -p "$dir_path" 2>/dev/null || return 0
            TX_CREATED_DIRS+=("$dir_path")
        fi
        return 0
    fi
    return 0
}

# Compute SHA256 checksum of a file, or empty string if missing.
file_checksum() {
    local f="$1"
    if [ -f "$f" ]; then
        sha256sum "$f" 2>/dev/null | awk '{print $1}' || echo ""
    else
        echo ""
    fi
}

# Classify a file path by ownership kind.
classify_file() {
    local rel_path="$1"
    local is_from_baseline="$2"  # "true" if source is baseline skeleton

    # Runtime/generated patterns
    case "$rel_path" in
        *__pycache__*|*.pyc|*.pyo|.pytest_cache/*)
            echo "$OWNERSHIP_GENERATED_EPHEMERAL"
            return
            ;;
        *replay-snapshot*|*replay_snapshot*|*stress-output*|*stress_output*)
            echo "$OWNERSHIP_GENERATED_EPHEMERAL"
            return
            ;;
        *quarantine/*|*.tmp|*.tmp.*|.DS_Store|Thumbs.db)
            echo "$OWNERSHIP_GENERATED_EPHEMERAL"
            return
            ;;
        .agents/management/evidence/generated/*|.agents/management/evidence/replay/*|.agents/management/evidence/traces/*)
            echo "$OWNERSHIP_GENERATED_RUNTIME"
            return
            ;;
        .agents/management/evidence/cache/*)
            echo "$OWNERSHIP_GENERATED_CACHE"
            return
            ;;
        EVIDENCE/recovery-generated/*|EVIDENCE/recovery-staging/*)
            echo "$OWNERSHIP_GENERATED_RUNTIME"
            return
            ;;
        .agents/config/project.json|AGENTS.md|.agents/management/ACTIVE.md)
            if [ "$is_from_baseline" = "true" ]; then
                echo "$OWNERSHIP_BASELINE"
            else
                echo "$OWNERSHIP_LOCAL_CUSTOMIZATION"
            fi
            return
            ;;
        EVIDENCE/*)
            echo "$OWNERSHIP_GENERATED_EVIDENCE"
            return
            ;;
        .agents/.rules/*)
            echo "$OWNERSHIP_BASELINE"
            return
            ;;
        .agents/skills/*|*.agent/*|.agent/*)
            echo "$OWNERSHIP_BASELINE"
            return
            ;;
        .agents/how-to/*|.agents/governance-allowlist/*)
            echo "$OWNERSHIP_BASELINE"
            return
            ;;
    esac

    # Default: skeleton-sourced = baseline, otherwise local customization
    if [ "$is_from_baseline" = "true" ]; then
        echo "$OWNERSHIP_BASELINE"
    else
        echo "$OWNERSHIP_LOCAL_CUSTOMIZATION"
    fi
}

# Check if a path matches a runtime exclusion pattern.
is_runtime_excluded() {
    local rel_path="$1"
    local basename
    basename="$(basename "$rel_path")"

    for pattern in "${RUNTIME_EXCLUDE_PATTERNS[@]}"; do
        case "$pattern" in
            \**)
                # Glob pattern — match against basename
                # shellcheck disable=SC2254
                case "$basename" in
                    $pattern) echo "true"; return ;;
                esac
                # Also match against full relative path
                # shellcheck disable=SC2254
                case "$rel_path" in
                    $pattern) echo "true"; return ;;
                esac
                ;;
            *\**)
                # Glob pattern
                # shellcheck disable=SC2254
                case "$rel_path" in
                    $pattern) echo "true"; return ;;
                esac
                ;;
            *)
                # Literal substring match
                if [[ "$rel_path" == *"$pattern"* ]] || [[ "$basename" == *"$pattern"* ]]; then
                    echo "true"
                    return
                fi
                ;;
        esac
    done
    echo "false"
}

# =============================================================================
# PROFILE DISCOVERY & ERROR UX HELPERS
# =============================================================================

# List profile names from a profile directory. Strips .md extension, excludes
# .d subdirectories, sorts alphabetically. Returns empty gracefully.
list_profiles() {
    local profile_dir="$1"
    if [ ! -d "$profile_dir" ]; then
        return 0
    fi
    local f
    for f in "$profile_dir"/*.md; do
        [ -f "$f" ] || continue
        local name
        name=$(basename "$f" .md)
        # Skip README.md — documentation, not a profile
        [ "$name" = "README" ] && continue
        echo "$name"
    done | sort
}

# Format a newline-separated list into a compact comma-separated string.
format_profile_list() {
    local items="$1"
    if [ -z "$items" ]; then
        printf '(none)'
        return
    fi
    echo "$items" | tr '\n' ',' | sed 's/,$//' | sed 's/,/, /g'
}

# Compute Levenshtein distance between two strings. Used for typo suggestions.
# Capped at max_distance to avoid expensive computation on large strings.
levenshtein_distance() {
    local s1="$1" s2="$2" max_dist="${3:-3}"
    local len1=${#s1} len2=${#s2}

    # Quick reject: if lengths differ by more than max_dist, skip
    local diff=$((len1 - len2))
    [ "$diff" -lt 0 ] && diff=$((-diff))
    [ "$diff" -gt "$max_dist" ] && echo "999" && return

    # For short strings (profile names), use full DP
    if [ "$len1" -gt 20 ] || [ "$len2" -gt 20 ]; then
        echo "999"; return
    fi

    # Use a simple 1D DP array
    local -a dp
    local i j
    for ((i = 0; i <= len2; i++)); do dp[$i]=$i; done

    for ((i = 1; i <= len1; i++)); do
        local prev=${dp[0]}
        dp[0]=$i
        for ((j = 1; j <= len2; j++)); do
            local temp=${dp[$j]}
            local cost=0
            [ "${s1:$((i-1)):1}" != "${s2:$((j-1)):1}" ] && cost=1
            local v=$((dp[$j] + 1))
            [ $((dp[$j-1] + 1)) -lt "$v" ] && v=$((dp[$j-1] + 1))
            [ $((prev + cost)) -lt "$v" ] && v=$((prev + cost))
            dp[$j]=$v
            prev=$temp
        done
    done
    echo "${dp[$len2]}"
}

# Given an invalid profile name and a sorted newline list of valid names,
# return up to 3 closest suggestions by Levenshtein distance.
suggest_profiles() {
    local invalid="$1"
    local valid_list="$2"
    local max_suggestions="${3:-3}"
    local max_dist="${4:-3}"

    local -a candidates=()
    local -a distances=()
    local name dist

    while IFS= read -r name; do
        [ -z "$name" ] && continue
        dist=$(levenshtein_distance "$invalid" "$name" "$max_dist")
        if [ "$dist" -le "$max_dist" ]; then
            candidates+=("$name")
            distances+=("$dist")
        fi
    done <<< "$valid_list"

    # Bubble-sort by distance (small n, trivial)
    local n=${#candidates[@]}
    local i j
    for ((i = 0; i < n - 1; i++)); do
        for ((j = 0; j < n - i - 1; j++)); do
            if [ "${distances[$j]}" -gt "${distances[$((j+1))]}" ]; then
                local tmp="${candidates[$j]}"
                candidates[$j]="${candidates[$((j+1))]}"
                candidates[$((j+1))]="$tmp"
                tmp="${distances[$j]}"
                distances[$j]="${distances[$((j+1))]}"
                distances[$((j+1))]="$tmp"
            fi
        done
    done

    local count=0
    for ((i = 0; i < n && count < max_suggestions; i++)); do
        echo "${candidates[$i]}"
        count=$((count + 1))
    done
}

# Exit with a structured error for an invalid profile value.
# Args: profile_kind invalid_value profile_dir
die_invalid_profile() {
    local kind="$1" invalid="$2" profile_dir="$3"

    echo "ERROR: Unknown $kind: '$invalid'" >&2

    local valid_list
    valid_list=$(list_profiles "$profile_dir")

    if [ -n "$valid_list" ]; then
        echo "  Valid $kind values: $(format_profile_list "$valid_list")" >&2

        local suggestions
        suggestions=$(suggest_profiles "$invalid" "$valid_list")
        if [ -n "$suggestions" ]; then
            echo "  Did you mean: $(echo "$suggestions" | tr '\n' ',' | sed 's/,$//' | sed 's/,/, /g')?" >&2
        fi
    else
        echo "  No $kind profiles found at: $profile_dir" >&2
    fi

    echo "  Fix: specify a valid --${kind// /-}=NAME from the list above." >&2
    exit 1
}

# Display help text. Generated from real profile data where possible.
show_help() {
    local languages frameworks project_types repo_kinds overlays
    languages=$(list_profiles "$SCRIPT_DIR/.agents/.rules/governance/profiles/languages")
    frameworks=$(list_profiles "$SCRIPT_DIR/.agents/.rules/governance/profiles/frameworks")
    project_types=$(list_profiles "$SCRIPT_DIR/.agents/.rules/governance/profiles/project-types")
    repo_kinds=$(list_profiles "$SCRIPT_DIR/.agents/.rules/governance/profiles/repository-kinds")
    overlays=$(list_profiles "$SCRIPT_DIR/.agents/.rules/governance/profiles/overlays")

    cat <<HELPEOF
Agent Harness OS Installer V$VERSION
====================================
Idempotent adoption and upgrade engine with transaction safety.

USAGE:
  $0 /path/to/project [options...]

INSTALL MODES (mutually exclusive; default: --adopt):
  --adopt          Adopt existing project, establish baseline (default)
  --upgrade        Upgrade baseline rules (.rules) only, keep local rules intact
  --migrate        Legacy V1/V2 migration, archive old structures
  --validate       Validate existing installation without changes
  --force          Force overwrite of conflicting local files with .bak backups

PROFILE SELECTION:
  --language=NAME          Language profile (e.g., php, typescript, go)
  --framework=NAME         Framework profile (e.g., laravel, nextjs, react)
  --project-type=NAME      Project type (e.g., api-service, web-app, cli)
  --project-name=NAME      Project name for local contract (e.g., avax, my-app)
  --repo-kind=NAME         Repository kind (e.g., governance-source)
  --repository-profile=    Alias for --repo-kind

  Available languages:     $(format_profile_list "$languages")
  Available frameworks:    $(format_profile_list "$frameworks")
  Available project types: $(format_profile_list "$project_types")
  Available repo kinds:    $(format_profile_list "$repo_kinds")
  Available overlays:      $(format_profile_list "$overlays")

PLATFORM ADAPTERS:
  --platform=NAME          Generate platform adapter: claude, cursor, codex, gemini, opencode, cline
  --platform=all           Generate all platform adapters

DISCOVERY:
  --list-languages         List available language profiles
  --list-frameworks        List available framework profiles
  --list-project-types     List available project type profiles
  --list-repo-kinds        List available repository kind profiles
  --list-overlays          List available overlay profiles

UTILITY:
  --dry-run                Simulate changes without writing to disk
  --prune-evidence         Prune stale generated evidence during migration

EXAMPLES:
  $0 /path/to/project --language=typescript --project-type=api-service
  $0 /path/to/project --framework=laravel --project-type=web-app --dry-run
  $0 /path/to/project --upgrade --language=go
  $0 /path/to/project --migrate --prune-evidence
  $0 /path/to/project --adopt --platform=claude,cursor
HELPEOF
}

# Each --list-* handler: prints profile names one per line, exits 0.
show_list_languages() {
    list_profiles "$SCRIPT_DIR/.agents/.rules/governance/profiles/languages"
    exit 0
}

show_list_frameworks() {
    list_profiles "$SCRIPT_DIR/.agents/.rules/governance/profiles/frameworks"
    exit 0
}

show_list_project_types() {
    list_profiles "$SCRIPT_DIR/.agents/.rules/governance/profiles/project-types"
    exit 0
}

show_list_repo_kinds() {
    list_profiles "$SCRIPT_DIR/.agents/.rules/governance/profiles/repository-kinds"
    exit 0
}

show_list_overlays() {
    list_profiles "$SCRIPT_DIR/.agents/.rules/governance/profiles/overlays"
    exit 0
}

# =============================================================================
# EARLY EXIT HANDLERS (--help, --list-*)
# Processed after helper functions are defined. Uses ALL_ARGS saved at startup.
# =============================================================================
for arg in "${ALL_ARGS[@]}"; do
    case "$arg" in
        --help|-h)
            show_help
            exit 0
            ;;
        --list-languages)
            show_list_languages
            ;;
        --list-frameworks)
            show_list_frameworks
            ;;
        --list-project-types)
            show_list_project_types
            ;;
        --list-repo-kinds)
            show_list_repo_kinds
            ;;
        --list-overlays)
            show_list_overlays
            ;;
    esac
done

# =============================================================================
# JOURNAL FUNCTIONS
# =============================================================================
init_journal() {
    JOURNAL_DIR="$TARGET_DIR/.agents/management/evidence/install-journal"
    JOURNAL_FILE="$JOURNAL_DIR/journal-$(date -u +%Y%m%d-%H%M%S)-$$.jsonl"
    ensure_directory "$JOURNAL_DIR"
    if [ "$DRY_RUN" = false ]; then
        echo '{"event":"install_start","version":"'"$VERSION"'","timestamp":"'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'","target":"'"$TARGET_DIR"'","mode":"'"$(install_mode_label)"'"}' > "$JOURNAL_FILE"
    fi
}

journal_entry() {
    local event_type="$1"
    local details="$2"
    JOURNAL_ENTRIES+=("$event_type: $details")
    if [ "$DRY_RUN" = false ] && [ -n "$JOURNAL_FILE" ]; then
        local ts
        ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
        echo '{"event":"'"$event_type"'","details":"'"$details"'","timestamp":"'"$ts"'"}' >> "$JOURNAL_FILE"
    fi
}

# Save interrupted-install recovery marker.
save_recovery_marker() {
    if [ "$DRY_RUN" = false ] && [ -n "$JOURNAL_FILE" ]; then
        local recovery_file="$JOURNAL_DIR/interrupted-$(date -u +%Y%m%d-%H%M%S)-$$.json"
        cat > "$recovery_file" <<REOF
{
    "recovery": true,
    "install_version": "$VERSION",
    "target": "$TARGET_DIR",
    "mode": "$(install_mode_label)",
    "journal": "$JOURNAL_FILE",
    "created_files": $(printf '%s\n' "${TX_CREATED_FILES[@]}" 2>/dev/null | python3 -c "import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))" 2>/dev/null || echo "[]"),
    "updated_files": $(printf '%s\n' "${TX_UPDATED_FILES[@]}" 2>/dev/null | python3 -c "import sys,json; print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))" 2>/dev/null || echo "[]"),
    "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
REOF
        echo "  [RECOVERY] Recovery marker saved: $recovery_file"
    fi
}

install_mode_label() {
    if [ "$IS_UPGRADE" = true ]; then echo "UPGRADE"
    elif [ "$IS_MIGRATION" = true ]; then echo "MIGRATION"
    elif [ "$IS_ADOPT" = true ]; then echo "ADOPT"
    else echo "UNKNOWN"
    fi
}

# =============================================================================
# TRANSACTION ROLLBACK
# =============================================================================
rollback_transaction() {
    local exit_code=$?
    trap - INT TERM EXIT ERR

    if [ "$INSTALL_SUCCESS" = "true" ]; then
        rm -rf "$TX_DIR" 2>/dev/null || true
        exit "$exit_code"
    fi

    if [ "$DRY_RUN" = "true" ]; then
        echo "[DRY RUN] Simulated transaction rolled back safely."
        rm -rf "$TX_DIR" 2>/dev/null || true
        exit "$exit_code"
    fi

    echo ""
    echo "[TRANSACTION] Installation failed or interrupted! Initiating rollback..."

    # Save recovery marker before rollback
    save_recovery_marker

    # 1. Restore removed baseline files from transaction backups
    if [ -d "$TX_DIR/backups/removed" ]; then
        while IFS= read -r backup_file; do
            local rel="${backup_file#$TX_DIR/backups/removed/}"
            echo "  [RESTORE] Restoring removed baseline: $rel"
            ensure_directory "$(dirname "$TARGET_DIR/$rel")"
            cp -pf "$backup_file" "$TARGET_DIR/$rel"
        done < <(find "$TX_DIR/backups/removed" -type f 2>/dev/null)
    fi

    # 2. Restore updated files from transaction backups
    for rel_path in "${TX_UPDATED_FILES[@]}"; do
        local backup_file="$TX_DIR/backups/$rel_path"
        local target_file="$TARGET_DIR/$rel_path"
        if [ -f "$backup_file" ]; then
            echo "  [RESTORE] Restoring file: $rel_path"
            ensure_directory "$(dirname "$target_file")"
            cp -pf "$backup_file" "$target_file"
        fi
    done

    # 3. Remove newly created files
    for rel_path in "${TX_CREATED_FILES[@]}"; do
        local target_file="$TARGET_DIR/$rel_path"
        if [ -f "$target_file" ]; then
            echo "  [DELETE] Removing created file: $rel_path"
            rm -f "$target_file"
        fi
    done

    # 4. Clean up empty directories created during this install
    if [ -d "$TARGET_DIR" ]; then
        echo "  [CLEANUP] Removing empty directories created during install..."
        for d in "${TX_CREATED_DIRS[@]}"; do
            if [ -d "$d" ]; then
                find "$d" -type d -empty -delete 2>/dev/null || true
                # Remove the directory itself if now empty
                rmdir "$d" 2>/dev/null || true
            fi
        done
    fi

    rm -rf "$TX_DIR" 2>/dev/null || true
    echo "[TRANSACTION] Rollback complete. Repository restored to original state."
    exit "$exit_code"
}

trap 'rollback_transaction' INT TERM EXIT ERR

# Initialize transaction backups
ensure_directory "$TX_DIR/backups"

# =============================================================================
# PHASE 1: ARGUMENT PARSING
# =============================================================================
for arg in "$@"; do
    case $arg in
        --language=*)
        LANGUAGE_NAME="${arg#*=}"
        if [ -f "$SCRIPT_DIR/.agents/.rules/governance/profiles/languages/$LANGUAGE_NAME.md" ]; then
            SELECTED_LANGUAGES+=("$LANGUAGE_NAME")
            CODING_PROFILES+=(".agents/.rules/governance/profiles/languages/$LANGUAGE_NAME.md")
            if [ -f "$SCRIPT_DIR/.agents/.rules/governance/architecture/profiles/languages/$LANGUAGE_NAME.md" ]; then
                ARCH_PROFILES+=(".agents/.rules/governance/architecture/profiles/languages/$LANGUAGE_NAME.md")
            fi
        else
            die_invalid_profile "language" "$LANGUAGE_NAME" \
                "$SCRIPT_DIR/.agents/.rules/governance/profiles/languages"
        fi
        ;;
        --framework=*)
        FRAME="${arg#*=}"
        if [ -f "$SCRIPT_DIR/.agents/.rules/governance/profiles/frameworks/$FRAME.md" ]; then
            SELECTED_FRAMEWORKS+=("$FRAME")
            CODING_PROFILES+=(".agents/.rules/governance/profiles/frameworks/$FRAME.md")
            if [ -f "$SCRIPT_DIR/.agents/.rules/governance/architecture/profiles/frameworks/$FRAME.md" ]; then
                ARCH_PROFILES+=(".agents/.rules/governance/architecture/profiles/frameworks/$FRAME.md")
            fi
        else
            die_invalid_profile "framework" "$FRAME" \
                "$SCRIPT_DIR/.agents/.rules/governance/profiles/frameworks"
        fi
        ;;
        --repository-profile=*|--repo-kind=*)
        REPOSITORY_PROFILE_NAME="${arg#*=}"
        if [ -f "$SCRIPT_DIR/.agents/.rules/governance/profiles/repository-kinds/$REPOSITORY_PROFILE_NAME.md" ]; then
            SELECTED_REPOSITORY_PROFILES+=("$REPOSITORY_PROFILE_NAME")
        else
            die_invalid_profile "repository kind" "$REPOSITORY_PROFILE_NAME" \
                "$SCRIPT_DIR/.agents/.rules/governance/profiles/repository-kinds"
        fi
        ;;
        --project-type=*)
        TYPE="${arg#*=}"
        if [ -f "$SCRIPT_DIR/.agents/.rules/governance/profiles/project-types/$TYPE.md" ]; then
            PROJECT_TYPES+=("$TYPE")
            CODING_PROFILES+=(".agents/.rules/governance/profiles/project-types/$TYPE.md")
        else
            die_invalid_profile "project type" "$TYPE" \
                "$SCRIPT_DIR/.agents/.rules/governance/profiles/project-types"
        fi
        ;;
        --project-name=*)
        PROJECT_NAME="${arg#*=}"
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
                    echo "ERROR: Unknown platform adapter: '$PLATFORM_ITEM'" >&2
                    echo "  Valid platform adapters: claude, cursor, codex, gemini, opencode, cline, all" >&2
                    echo "  Fix: specify a valid --platform=NAME (comma-separated for multiple)." >&2
                    exit 1
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
        --prune-evidence)
        PRUNE_EVIDENCE=true
        ;;
    esac
done

# =============================================================================
# ARGUMENT CONFLICT VALIDATION
# =============================================================================

# Detect mutually exclusive modes
if [ "$IS_UPGRADE" = true ] && [ "$IS_MIGRATION" = true ]; then
    echo "ERROR: Conflicting install modes: --upgrade and --migrate cannot be used together." >&2
    echo "  Why: These modes have incompatible file handling strategies." >&2
    echo "  Fix: Choose either --upgrade (baseline-only) or --migrate (legacy migration)." >&2
    exit 1
fi

# Warn on migration mode without profile guidance
if [ "$IS_MIGRATION" = true ] && [ ${#SELECTED_LANGUAGES[@]} -eq 0 ] && [ ${#PROJECT_TYPES[@]} -eq 0 ]; then
    echo "WARNING: Migration mode without --language or --project-type specified." >&2
    echo "  Consider specifying profiles for targeted migration." >&2
fi

# Default mode: adopt if no explicit mode specified
if [ "$IS_UPGRADE" = false ] && [ "$IS_ADOPT" = false ] && [ "$IS_MIGRATION" = false ]; then
    IS_ADOPT=true
fi

# =============================================================================
# PHASE 2: VALIDATE-ONLY MODE
# =============================================================================
if [ "$VALIDATE_ONLY" = true ]; then
    echo "Validating Agent Harness OS Installation at $TARGET_DIR..."
    local_status="GREEN"

    if [ ! -d "$TARGET_DIR/.agents/.rules" ]; then
        echo "ERROR: OS baseline (.agents/.rules) missing."
        local_status="RED"
    fi

    if [ ! -f "$TARGET_DIR/AGENTS.md" ]; then
        echo "ERROR: Root AGENTS.md contract missing."
        local_status="RED"
    fi

    if [ ! -d "$TARGET_DIR/.agents/management" ]; then
        echo "ERROR: Management workspace missing."
        local_status="YELLOW"
    fi

    # Check for journal evidence of prior install
    if [ -d "$TARGET_DIR/.agents/management/evidence/install-journal" ]; then
        journal_count=$(find "$TARGET_DIR/.agents/management/evidence/install-journal" -name "journal-*.jsonl" 2>/dev/null | wc -l)
        echo "Install journal: $journal_count entries found"
    fi

    # Check for interrupted recovery markers
    if [ -d "$TARGET_DIR/.agents/management/evidence/install-journal" ]; then
        recovery_count=$(find "$TARGET_DIR/.agents/management/evidence/install-journal" -name "interrupted-*.json" 2>/dev/null | wc -l)
        if [ "$recovery_count" -gt 0 ]; then
            echo "WARNING: $recovery_count interrupted install recovery markers found"
            if [ "$local_status" = "GREEN" ]; then
                local_status="YELLOW"
            fi
        fi
    fi

    echo "Validation status: $local_status"
    if [ "$local_status" != "GREEN" ]; then
        INSTALL_SUCCESS=true
        exit 1
    fi
    echo "OS Validation Passed."
    INSTALL_SUCCESS=true
    exit 0
fi

# =============================================================================
# PHASE 3: DETECT EXISTING STRUCTURES
# =============================================================================
HAS_AGENTS=false
HAS_AGENTS_MD=false
HAS_EVIDENCE=false
HAS_BASELINE_RULES=false
HAS_MANAGEMENT=false
HAS_JOURNAL=false
HAS_INTERRUPTED=false

[ -d "$TARGET_DIR/.agents" ] && HAS_AGENTS=true
[ -f "$TARGET_DIR/AGENTS.md" ] && HAS_AGENTS_MD=true
[ -d "$TARGET_DIR/EVIDENCE" ] && HAS_EVIDENCE=true
[ -d "$TARGET_DIR/.agents/.rules" ] && HAS_BASELINE_RULES=true
[ -d "$TARGET_DIR/.agents/management" ] && HAS_MANAGEMENT=true
[ -d "$TARGET_DIR/.agents/management/evidence/install-journal" ] && HAS_JOURNAL=true

# Check for interrupted install recovery markers
if [ "$HAS_JOURNAL" = true ]; then
    interrupted_count=$(find "$TARGET_DIR/.agents/management/evidence/install-journal" -name "interrupted-*.json" 2>/dev/null | wc -l)
    [ "${interrupted_count:-0}" -gt 0 ] && HAS_INTERRUPTED=true
fi

echo "Detecting existing structures at $TARGET_DIR..."
echo "  Existing .agents folder: $HAS_AGENTS"
echo "  Existing AGENTS.md contract: $HAS_AGENTS_MD"
echo "  Existing EVIDENCE folder: $HAS_EVIDENCE"
echo "  Existing baseline rules (.agents/.rules): $HAS_BASELINE_RULES"
echo "  Existing management workspace: $HAS_MANAGEMENT"
echo "  Existing install journal: $HAS_JOURNAL"
echo "  Interrupted install markers: ${HAS_INTERRUPTED:-false}"
echo "  Installer version: $VERSION"
echo ""

# Initialize journal
init_journal

# =============================================================================
# PHASE 4: FILE OWNERSHIP & MERGE ENGINE (sync_file V6)
# =============================================================================

# Sync individual file with full V6 ownership classification, checksum-aware
# merge, baseline drift detection, and transaction safety.
sync_file() {
    local src_file="$1"
    local rel_path="$2"
    local is_baseline_src="$3"  # "true" if source is from baseline
    local dest_file="$TARGET_DIR/$rel_path"

    # --- Runtime exclusion check ---
    local excluded
    excluded="$(is_runtime_excluded "$rel_path")"
    if [ "$excluded" = "true" ]; then
        LIST_EXCLUDED+=("Excluded (runtime artifact): $rel_path")
        COUNT_EXCLUDED=$((COUNT_EXCLUDED + 1))
        journal_entry "excluded" "$rel_path"
        return 0
    fi

    # --- Classify the file ---
    local ownership
    ownership="$(classify_file "$rel_path" "$is_baseline_src")"

    # --- Ensure parent directory idempotently ---
    local parent_dir
    parent_dir="$(dirname "$dest_file")"
    ensure_directory "$parent_dir"

    # Verify the parent is actually a directory (not a file at some path component)
    if [ ! -d "$parent_dir" ]; then
        LIST_EXCLUDED+=("Skipped (parent is not a directory): $rel_path")
        COUNT_EXCLUDED=$((COUNT_EXCLUDED + 1))
        return 0
    fi

    # --- Case 1: Target file does not exist ---
    if [ ! -f "$dest_file" ]; then
        # Never adopt generated runtime/ephemeral files from source
        if [ "$ownership" = "$OWNERSHIP_GENERATED_EPHEMERAL" ]; then
            LIST_EXCLUDED+=("Skipped ephemeral (not creating): $rel_path")
            COUNT_EXCLUDED=$((COUNT_EXCLUDED + 1))
            journal_entry "skipped_ephemeral" "$rel_path"
            return 0
        fi

        LIST_CREATED+=("Created ($ownership): $rel_path")
        COUNT_CREATED=$((COUNT_CREATED + 1))
        journal_entry "created" "$rel_path"

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

    # --- Case 2: Target file exists ---
    local src_checksum dest_checksum
    src_checksum="$(file_checksum "$src_file")"
    dest_checksum="$(file_checksum "$dest_file")"

    # Identical files — skip
    if [ "$src_checksum" = "$dest_checksum" ] && [ -n "$src_checksum" ]; then
        LIST_SKIPPED+=("Skipped (identical): $rel_path")
        COUNT_SKIPPED=$((COUNT_SKIPPED + 1))
        return 0
    fi

    # --- Drift classification ---
    local src_template_checksum=""

    # Resolve the canonical template for this file. Try multiple sources:
    # 1. For .agents/.rules/* files → source baseline .agents/
    # 2. For .agents/* files → skeleton .agents/
    # 3. For root files → scaffold root
    local template_path=""
    case "$rel_path" in
        .agents/.rules/*)
            template_path="$SCRIPT_DIR/.agents/${rel_path#.agents/.rules/}"
            ;;
        .agents/*)
            # Try skeleton first, then rules
            template_path="$SCRIPT_DIR/scaffolds/agents-skeleton/.agents/${rel_path#.agents/}"
            if [ ! -f "$template_path" ]; then
                template_path="$SCRIPT_DIR/.agents/${rel_path#.agents/}"
            fi
            ;;
        AGENTS.md)
            template_path="$SCRIPT_DIR/scaffolds/AGENTS.md"
            ;;
        *.sh|*.md)
            template_path="$SCRIPT_DIR/scaffolds/agents-skeleton/$rel_path"
            ;;
    esac

    if [ -n "$template_path" ] && [ -f "$template_path" ]; then
        src_template_checksum="$(file_checksum "$template_path")"
    fi

    local drift_status="unknown"
    if [ "$src_template_checksum" = "$dest_checksum" ] && [ -n "$src_template_checksum" ]; then
        drift_status="local_untouched"
    elif [ "$src_checksum" = "$src_template_checksum" ] && [ -n "$src_checksum" ] && [ -n "$src_template_checksum" ]; then
        drift_status="baseline_untouched"
    elif [ "$src_checksum" != "$dest_checksum" ] && [ "$src_template_checksum" != "$dest_checksum" ] && [ "$src_checksum" != "$src_template_checksum" ]; then
        drift_status="both_diverged"
    elif [ "$src_checksum" != "$dest_checksum" ]; then
        drift_status="baseline_changed"
    fi

    # --- Apply ownership policy ---
    case "$ownership" in
        "$OWNERSHIP_BASELINE")
            if [ "$IS_UPGRADE" = true ] || [ "$IS_FORCE" = true ]; then
                # Upgrade mode: update baseline files with drift info
                LIST_UPDATED+=("Updated Baseline ($drift_status): $rel_path")
                COUNT_UPDATED=$((COUNT_UPDATED + 1))
                journal_entry "updated_baseline" "$rel_path (drift: $drift_status)"

                if [ "$DRY_RUN" = false ]; then
                    ensure_directory "$(dirname "$TX_DIR/backups/$rel_path")"
                    cp -pf "$dest_file" "$TX_DIR/backups/$rel_path"
                    TX_UPDATED_FILES+=("$rel_path")
                    cp "$src_file" "$dest_file"
                fi
            elif [ "$IS_ADOPT" = true ]; then
                # Adopt mode: update baseline files from canonical source.
                # Preserve only when destination has genuinely diverged from
                # the canonical source (both src and dest changed independently).
                if [ "$drift_status" = "both_diverged" ]; then
                    LIST_PRESERVED+=("Preserved Baseline (locally modified): $rel_path")
                    COUNT_PRESERVED=$((COUNT_PRESERVED + 1))
                    LIST_CONFLICTS+=("Conflict: $rel_path (locally modified baseline, drift: $drift_status)")
                    COUNT_CONFLICTS=$((COUNT_CONFLICTS + 1))
                    LIST_MANUAL+=("Review baseline drift in $rel_path (drift: $drift_status)")
                    journal_entry "conflict_baseline" "$rel_path (drift: $drift_status)"
                else
                    # baseline_changed, local_untouched, baseline_untouched, or unknown:
                    # update from canonical source
                    LIST_UPDATED+=("Updated Baseline ($drift_status): $rel_path")
                    COUNT_UPDATED=$((COUNT_UPDATED + 1))
                    journal_entry "updated_baseline_adopt" "$rel_path (drift: $drift_status)"

                    if [ "$DRY_RUN" = false ]; then
                        ensure_directory "$(dirname "$TX_DIR/backups/$rel_path")"
                        cp -pf "$dest_file" "$TX_DIR/backups/$rel_path"
                        TX_UPDATED_FILES+=("$rel_path")
                        cp "$src_file" "$dest_file"
                    fi
                fi
            else
                LIST_PRESERVED+=("Preserved Baseline (no upgrade trigger): $rel_path")
                COUNT_PRESERVED=$((COUNT_PRESERVED + 1))
            fi
            ;;

        "$OWNERSHIP_LOCAL_CUSTOMIZATION")
            if [ "$IS_FORCE" = true ]; then
                LIST_UPDATED+=("Forced Overwrite: $rel_path")
                COUNT_UPDATED=$((COUNT_UPDATED + 1))
                journal_entry "forced_overwrite" "$rel_path"

                if [ "$DRY_RUN" = false ]; then
                    cp -pf "$dest_file" "${dest_file}.bak"
                    ensure_directory "$(dirname "$TX_DIR/backups/$rel_path")"
                    cp -pf "$dest_file" "$TX_DIR/backups/$rel_path"
                    TX_UPDATED_FILES+=("$rel_path")
                    cp "$src_file" "$dest_file"
                fi
            else
                LIST_PRESERVED+=("Preserved Local Customization: $rel_path")
                COUNT_PRESERVED=$((COUNT_PRESERVED + 1))
                journal_entry "preserved_local" "$rel_path"

                # Flag conflicts for critical governance files
                case "$rel_path" in
                    AGENTS.md|.agents/config/project.json)
                        LIST_CONFLICTS+=("Conflict: $rel_path (local customization differs from template)")
                        COUNT_CONFLICTS=$((COUNT_CONFLICTS + 1))
                        LIST_MANUAL+=("Merge local customizations in $rel_path with source template")

                        # Generate 3-way merge diff for AGENTS.md
                        if [ "$rel_path" = "AGENTS.md" ] && [ "$DRY_RUN" = false ] && [ -f "$src_file" ]; then
                            local merge_diff_dir="$TX_DIR/merge-suggestions"
                            ensure_directory "$merge_diff_dir"
                            local diff_file="$merge_diff_dir/AGENTS.md-3way-diff.txt"
                            cp -pf "$dest_file" "$merge_diff_dir/local.$rel_path"
                            cp -pf "$src_file" "$merge_diff_dir/upstream.$rel_path"
                            {
                                echo "# 3-Way Merge Analysis for $rel_path"
                                echo "# Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
                                echo "# "
                                echo "# LOCAL (current in project) vs UPSTREAM (new template):"
                                echo ""
                                diff -u "$dest_file" "$src_file" 2>/dev/null || true
                                echo ""
                                echo "# To merge manually:"
                                echo "#   1. Review the diff above"
                                echo "#   2. Copy local version: cp $dest_file ${dest_file}.local-backup"
                                echo "#   3. Apply upstream changes: cp $src_file $dest_file"
                                echo "#   4. Re-apply your local customizations from the backup"
                            } > "$diff_file" 2>/dev/null || true
                            LIST_MANUAL+=("3-way diff generated: $diff_file")
                        fi
                        ;;
                esac
            fi
            ;;

        "$OWNERSHIP_GENERATED_RUNTIME")
            # Never overwrite runtime-generated files from skeleton
            LIST_PRESERVED+=("Preserved Runtime Artifact: $rel_path")
            COUNT_PRESERVED=$((COUNT_PRESERVED + 1))
            journal_entry "preserved_runtime" "$rel_path"
            ;;

        "$OWNERSHIP_GENERATED_EPHEMERAL")
            LIST_EXCLUDED+=("Excluded ephemeral: $rel_path")
            COUNT_EXCLUDED=$((COUNT_EXCLUDED + 1))
            journal_entry "excluded_ephemeral" "$rel_path"
            ;;

        "$OWNERSHIP_GENERATED_CACHE")
            # Regenerate cache files from source
            LIST_UPDATED+=("Regenerated Cache: $rel_path")
            COUNT_UPDATED=$((COUNT_UPDATED + 1))
            journal_entry "regenerated_cache" "$rel_path"

            if [ "$DRY_RUN" = false ]; then
                ensure_directory "$(dirname "$TX_DIR/backups/$rel_path")"
                cp -pf "$dest_file" "$TX_DIR/backups/$rel_path" 2>/dev/null || true
                TX_UPDATED_FILES+=("$rel_path")
                cp "$src_file" "$dest_file"
            fi
            ;;

        "$OWNERSHIP_GENERATED_EVIDENCE")
            # Evidence migration logic
            if [ "$PRUNE_EVIDENCE" = true ]; then
                LIST_UPDATED+=("Pruned & Replaced Evidence: $rel_path")
                COUNT_UPDATED=$((COUNT_UPDATED + 1))
                journal_entry "pruned_evidence" "$rel_path"

                if [ "$DRY_RUN" = false ]; then
                    ensure_directory "$(dirname "$TX_DIR/backups/$rel_path")"
                    cp -pf "$dest_file" "$TX_DIR/backups/$rel_path"
                    TX_UPDATED_FILES+=("$rel_path")
                    cp "$src_file" "$dest_file"
                fi
            else
                LIST_PRESERVED+=("Preserved Evidence (use --prune-evidence to replace): $rel_path")
                COUNT_PRESERVED=$((COUNT_PRESERVED + 1))
                journal_entry "preserved_evidence" "$rel_path"
            fi
            ;;
    esac
}

# =============================================================================
# PHASE 5: EVIDENCE MIGRATION
# =============================================================================
migrate_evidence() {
    echo "Processing evidence migration..."

    local evidence_src="$SCRIPT_DIR/scaffolds/evidence-dashboard"
    if [ ! -d "$evidence_src" ]; then
        echo "  No evidence dashboard scaffold found, skipping."
        return 0
    fi

    # If target has existing EVIDENCE, archive it first
    if [ "$HAS_EVIDENCE" = true ] && [ "$DRY_RUN" = false ]; then
        local archive_dir="$TARGET_DIR/EVIDENCE/.install-archive/$(date -u +%Y%m%d-%H%M%S)"
        ensure_directory "$archive_dir"

        # Archive existing evidence files (not the dashboard canonical files)
        while IFS= read -r existing_file; do
            local rel="${existing_file#$TARGET_DIR/EVIDENCE/}"
            # Skip canonical dashboard files and our own archive
            case "$rel" in
                .install-archive/*|ACTIVE_PLAN.md|CURRENT.md|FLOW.md|LINKS.md|README.md) continue ;;
            esac

            # Archive historical evidence, not runtime noise
            local excluded
            excluded="$(is_runtime_excluded "$rel")"
            if [ "$excluded" = "true" ]; then
                LIST_EXCLUDED+=("Excluded from evidence migration: EVIDENCE/$rel")
                COUNT_EXCLUDED=$((COUNT_EXCLUDED + 1))
                continue
            fi

            ensure_directory "$(dirname "$archive_dir/$rel")"
            cp -pf "$existing_file" "$archive_dir/$rel"
            LIST_MIGRATED+=("Archived evidence: EVIDENCE/$rel")
            COUNT_MIGRATED=$((COUNT_MIGRATED + 1))
            journal_entry "evidence_archived" "EVIDENCE/$rel -> $archive_dir/$rel"
        done < <(find "$TARGET_DIR/EVIDENCE" -type f 2>/dev/null)
    fi

    # Sync canonical dashboard files
    while IFS= read -r src_file; do
        local rel_path="${src_file#$evidence_src/}"
        sync_file "$src_file" "EVIDENCE/$rel_path" "false"
    done < <(find "$evidence_src" -type f)
}

# =============================================================================
# PHASE 6: MIGRATION MODE (Legacy V1/V2)
# =============================================================================
apply_migration() {
    if [ "$IS_MIGRATION" = false ]; then
        return 0
    fi

    echo "MIGRATION MODE: Archiving legacy structures..."

    if [ "$DRY_RUN" = false ]; then
        ensure_directory "$TARGET_DIR/.agents/archive/legacy"

        for f in BUGS.md TODO.md; do
            if [ -f "$TARGET_DIR/.agents/management/$f" ]; then
                ensure_directory "$(dirname "$TX_DIR/backups/.agents/management/$f")"
                cp -pf "$TARGET_DIR/.agents/management/$f" "$TX_DIR/backups/.agents/management/$f"
                TX_UPDATED_FILES+=(".agents/management/$f")
                mv "$TARGET_DIR/.agents/management/$f" "$TARGET_DIR/.agents/archive/legacy/"
                LIST_MIGRATED+=("Migrated legacy: .agents/management/$f")
                COUNT_MIGRATED=$((COUNT_MIGRATED + 1))
                journal_entry "migrated_legacy" ".agents/management/$f"
            fi
        done

        if [ -d "$TARGET_DIR/docs/governance" ]; then
            ensure_directory "$TX_DIR/backups/docs"
            cp -rp "$TARGET_DIR/docs/governance" "$TX_DIR/backups/docs/"
            TX_DELETED_RULES=true
            ensure_directory "$TARGET_DIR/.agents/archive/legacy_docs"
            mv "$TARGET_DIR/docs/governance" "$TARGET_DIR/.agents/archive/legacy_docs/" || true
            LIST_MIGRATED+=("Migrated legacy docs: docs/governance")
            COUNT_MIGRATED=$((COUNT_MIGRATED + 1))
            journal_entry "migrated_legacy_docs" "docs/governance"
        fi
    else
        echo "  [DRY RUN] Would archive legacy structures."
    fi
}

# =============================================================================
# PHASE 7: BASELINE RULES INSTALLATION
# =============================================================================
install_baseline_rules() {
    # Granular upgrade: sync each baseline file individually instead of
    # nuking the entire .rules tree. This preserves locally modified files
    # and only replaces files where the upstream source has actually changed.
    if [ "$IS_UPGRADE" = true ] && [ "$DRY_RUN" = false ]; then
        echo "Upgrading baseline rules (.agents/.rules) — granular mode..."
        journal_entry "upgrade_mode" "granular per-file baseline sync"
    fi

    # Granular copy of rules tree
    local src_base="$SCRIPT_DIR/.agents/.rules"
    local dest_base=".agents/.rules"

    if [ ! -d "$src_base" ]; then
        echo "WARNING: Source baseline .rules not found at $src_base"
        return 0
    fi

    echo "Installing baseline rules..."
    while IFS= read -r src_file; do
        local rel_path="${src_file#$src_base/}"
        # Skip self-referential and git artifacts
        case "$rel_path" in
            .agents/*|.git/*|archive/pilots/*) continue ;;
        esac
        sync_file "$src_file" "$dest_base/$rel_path" "true"
    done < <(find "$src_base" -type f)

    # Detect removed baseline files (exist in target but not in source).
    # Only applies in upgrade mode — in adopt mode, target-only files are
    # local additions that must be preserved.
    if [ "$IS_UPGRADE" = true ] && [ -d "$TARGET_DIR/$dest_base" ]; then
        while IFS= read -r dest_file; do
            local rel_path="${dest_file#$TARGET_DIR/$dest_base/}"
            if [ ! -f "$src_base/$rel_path" ]; then
                # File was removed from upstream baseline
                local excluded
                excluded="$(is_runtime_excluded "$rel_path")"
                if [ "$excluded" = "false" ]; then
                    LIST_UPDATED+=("Removed from upstream baseline: $dest_base/$rel_path")
                    COUNT_UPDATED=$((COUNT_UPDATED + 1))
                    journal_entry "baseline_removed" "$dest_base/$rel_path"
                    if [ "$DRY_RUN" = false ]; then
                        ensure_directory "$(dirname "$TX_DIR/backups/removed/$dest_base/$rel_path")"
                        cp -pf "$dest_file" "$TX_DIR/backups/removed/$dest_base/$rel_path"
                        rm -f "$dest_file"
                    fi
                fi
            fi
        done < <(find "$TARGET_DIR/$dest_base" -type f 2>/dev/null)
    fi
}

# =============================================================================
# PHASE 8: SKELETON WORKSPACE INSTALLATION
# =============================================================================
install_skeleton() {
    local skeleton_base="$SCRIPT_DIR/scaffolds/agents-skeleton/.agents"

    if [ ! -d "$skeleton_base" ]; then
        echo "WARNING: Skeleton .agents not found at $skeleton_base"
        return 0
    fi

    echo "Installing skeleton workspace..."
    while IFS= read -r src_file; do
        local rel_path="${src_file#$skeleton_base/}"
        case "$rel_path" in
            .rules/*) continue ;;
        esac
        sync_file "$src_file" ".agents/$rel_path" "false"
    done < <(find "$skeleton_base" -type f)

    # Support files from skeleton root
    local skeleton_root="$SCRIPT_DIR/scaffolds/agents-skeleton"
    if [ -d "$skeleton_root" ]; then
        sync_file "$skeleton_root/business-logic/README.md" ".agents/business-logic/README.md" "false"
        sync_file "$skeleton_root/language-specific/README.md" ".agents/language-specific/README.md" "false"
        sync_file "$skeleton_root/review/REVIEWS.md" ".agents/review/REVIEWS.md" "false"
        if [ -f "$skeleton_root/review/archive/README.md" ]; then
            sync_file "$skeleton_root/review/archive/README.md" ".agents/review/archive/README.md" "false"
        fi
    fi
}

# =============================================================================
# PHASE 9: WORKSPACE DIRECTORIES (Idempotent)
# =============================================================================
ensure_workspace_directories() {
    local dirs=(
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
        ".agents/management/evidence/install-journal"
        ".agents/management/evidence/cache"
        ".agents/config"
    )

    for d in "${dirs[@]}"; do
        ensure_directory "$TARGET_DIR/$d"
        # Only create .gitkeep if directory is newly created and empty
        if [ "$DRY_RUN" = false ] && [ -d "$TARGET_DIR/$d" ]; then
            if [ -z "$(ls -A "$TARGET_DIR/$d" 2>/dev/null)" ]; then
                if [ ! -f "$TARGET_DIR/$d/.gitkeep" ]; then
                    touch "$TARGET_DIR/$d/.gitkeep"
                    TX_CREATED_FILES+=("$d/.gitkeep")
                fi
            fi
        fi
    done
}

# =============================================================================
# PHASE 10: AGENTS.MD CONTRACT
# =============================================================================
install_agents_contract() {
    if [ ! -f "$SCRIPT_DIR/scaffolds/AGENTS.md" ]; then
        echo "WARNING: Scaffold AGENTS.md not found"
        return 0
    fi

    local tmp_agents="/tmp/AGENTS.md.tmp.$$"
    cp "$SCRIPT_DIR/scaffolds/AGENTS.md" "$tmp_agents"

    local LANGUAGE_VALUE FRAMEWORK_VALUE REPOSITORY_PROFILE_VALUE CODING_PROFILE_VALUE ARCH_PROFILE_VALUE PROJECT_TYPE_VALUE
    LANGUAGE_VALUE="$(format_code_list "${SELECTED_LANGUAGES[@]}")"
    FRAMEWORK_VALUE="$(format_code_list "${SELECTED_FRAMEWORKS[@]}")"
    REPOSITORY_PROFILE_VALUE="$(format_code_list "${SELECTED_REPOSITORY_PROFILES[@]}")"
    CODING_PROFILE_VALUE="$(format_code_list "${CODING_PROFILES[@]}")"
    ARCH_PROFILE_VALUE="$(format_code_list "${ARCH_PROFILES[@]}")"
    PROJECT_TYPE_VALUE="$(format_code_list "${PROJECT_TYPES[@]}")"

    # Resolve project contract reference
    local project_slug
    project_slug="$(detect_project_name)"
    local project_contract_ref=".agents/how-to/how-to-write-${project_slug}.md"

    local target_agents_tmp="/tmp/AGENTS.md.tmp.sed.$$"
    sed \
        -e "s|__AGENTS_PROJECT_CONTRACT__|$project_contract_ref|" \
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
}

# =============================================================================
# PHASE 11: CORE UTILITIES
# =============================================================================
install_core_utilities() {
    if [ -f "$SCRIPT_DIR/merge-files.sh" ]; then
        sync_file "$SCRIPT_DIR/merge-files.sh" "merge-files.sh" "false"
    fi
    if [ -f "$SCRIPT_DIR/verify-governance.sh" ]; then
        sync_file "$SCRIPT_DIR/verify-governance.sh" "verify-governance.sh" "false"
    fi

    if [ "$DRY_RUN" = false ]; then
        [ -f "$TARGET_DIR/merge-files.sh" ] && chmod +x "$TARGET_DIR/merge-files.sh" 2>/dev/null || true
        [ -f "$TARGET_DIR/verify-governance.sh" ] && chmod +x "$TARGET_DIR/verify-governance.sh" 2>/dev/null || true
    fi
}

# =============================================================================
# PHASE 12B: PROJECT-LOCAL CONTRACT GENERATION
# =============================================================================
install_project_contract() {
    # Detect project name if not already resolved
    local project_slug
    project_slug="$(detect_project_name)"

    local contract_file=".agents/how-to/how-to-write-${project_slug}.md"

    # Skip if project contract already exists
    if [ -f "$TARGET_DIR/$contract_file" ]; then
        echo "  Project contract already exists: $contract_file (skipping generation)"
        return 0
    fi

    # Check template exists
    local template_src="$SCRIPT_DIR/scaffolds/templates/how-to-write-project.md"
    if [ ! -f "$template_src" ]; then
        echo "  WARNING: Project contract template not found at $template_src"
        echo "  Skipping project-local contract generation."
        return 0
    fi

    echo "Generating project-local contract: $contract_file"

    # Determine language and project type for template substitution
    local primary_language="php"
    local project_type="framework"
    if [ ${#SELECTED_LANGUAGES[@]} -gt 0 ]; then
        primary_language="${SELECTED_LANGUAGES[0]}"
    fi
    if [ ${#PROJECT_TYPES[@]} -gt 0 ]; then
        project_type="${PROJECT_TYPES[0]}"
    fi

    local project_display
    project_display="$(echo "$project_slug" | sed -e 's/-/ /g' -e 's/\b\(.\)/\u\1/g')"

    if [ "$DRY_RUN" = false ]; then
        ensure_directory "$TARGET_DIR/.agents/how-to"

        local generated_file="$TARGET_DIR/$contract_file"
        sed \
            -e "s/__PROJECT_NAME__/${project_display}/g" \
            -e "s/__PRIMARY_LANGUAGE__/${primary_language}/g" \
            -e "s/__PROJECT_TYPE__/${project_type}/g" \
            "$template_src" > "$generated_file"

        TX_CREATED_FILES+=("$contract_file")
        LIST_CREATED+=("Created (project contract): $contract_file")
        COUNT_CREATED=$((COUNT_CREATED + 1))
        journal_entry "created_project_contract" "$contract_file"

        echo "  Generated: $contract_file"
    else
        echo "  [DRY RUN] Would create: $contract_file"
        LIST_CREATED+=("Would create (project contract): $contract_file")
        COUNT_CREATED=$((COUNT_CREATED + 1))
    fi
}

# =============================================================================
# PHASE 12C: GOVERNANCE INDEX
# =============================================================================
install_governance_index() {
    local scaffold_src="$SCRIPT_DIR/scaffolds/agents-skeleton/GOVERNANCE_INDEX.md"
    if [ ! -f "$scaffold_src" ]; then
        echo "  WARNING: GOVERNANCE_INDEX scaffold not found"
        return 0
    fi

    echo "Installing GOVERNANCE_INDEX.md..."

    local tmp_gi="/tmp/GOVERNANCE_INDEX.md.tmp.$$"
    local project_slug
    project_slug="$(detect_project_name)"
    local project_contract_ref=".agents/how-to/how-to-write-${project_slug}.md"

    local LANGUAGE_VALUE FRAMEWORK_VALUE REPOSITORY_PROFILE_VALUE PROJECT_TYPE_VALUE
    LANGUAGE_VALUE="$(format_code_list "${SELECTED_LANGUAGES[@]}")"
    FRAMEWORK_VALUE="$(format_code_list "${SELECTED_FRAMEWORKS[@]}")"
    REPOSITORY_PROFILE_VALUE="$(format_code_list "${SELECTED_REPOSITORY_PROFILES[@]}")"
    PROJECT_TYPE_VALUE="$(format_code_list "${PROJECT_TYPES[@]}")"

    sed \
        -e "s|__AGENTS_PROJECT_CONTRACT__|\`$project_contract_ref\`|" \
        -e "s|__AGENTS_LANGUAGES__|$(escape_sed_replacement "$LANGUAGE_VALUE")|" \
        -e "s|__AGENTS_FRAMEWORKS__|$(escape_sed_replacement "$FRAMEWORK_VALUE")|" \
        -e "s|__AGENTS_PROJECT_TYPES__|$(escape_sed_replacement "$PROJECT_TYPE_VALUE")|" \
        -e "s|__AGENTS_REPOSITORY_PROFILES__|$(escape_sed_replacement "$REPOSITORY_PROFILE_VALUE")|" \
        "$scaffold_src" > "$tmp_gi"

    sync_file "$tmp_gi" ".agents/GOVERNANCE_INDEX.md" "false"
    rm -f "$tmp_gi"
}

# =============================================================================
# PHASE 12D: PERSIST PROJECT NAME TO CONFIG
# =============================================================================
persist_project_config() {
    local config_file="$TARGET_DIR/.agents/config/project.json"
    if [ ! -f "$config_file" ]; then
        return 0
    fi

    local project_slug
    project_slug="$(detect_project_name)"
    local project_display
    project_display="$(echo "$project_slug" | sed -e 's/-/ /g' -e 's/\b\(.\)/\u\1/g')"

    if [ "$DRY_RUN" = false ]; then
        # Inject "name" field into project.json if not already present
        if ! python3 -c "import json; d=json.load(open('$config_file')); assert 'name' in d" 2>/dev/null; then
            python3 -c "
import json
with open('$config_file', 'r') as f:
    data = json.load(f)
data['name'] = '$project_slug'
data['displayName'] = '$project_display'
with open('$config_file', 'w') as f:
    json.dump(data, f, indent=2)
" 2>/dev/null
            echo "  Persisted project name to .agents/config/project.json: $project_slug"
        fi
    fi
}

# =============================================================================
# PHASE 12: PLATFORM ADAPTERS
# =============================================================================
install_platform_adapters() {
    if [ "$PLATFORM_FLAGS_EXPLICITLY_SET" = false ] || [ "$GENERATE_ALL_PLATFORM_ADAPTERS" = true ]; then
        PLATFORM_TARGETS=(claude cursor codex gemini)
    fi

    for PLATFORM_ITEM in "${PLATFORM_TARGETS[@]}"; do
        _generate_platform_adapter "$PLATFORM_ITEM"
    done
}

_generate_platform_adapter() {
    local item="$1"
    local tmp_plat="/tmp/plat.$item.$$"

    case $item in
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
            printf '%s\n' \
                "# Cursor Rules — Agent Harness Profile" \
                "- Read AGENTS.md on every session start." \
                "- Follow .agents/governance/ standards strictly." \
                "- Evidence all changes in .agents/management/evidence/." \
                > "$tmp_plat"
            sync_file "$tmp_plat" ".cursorrules" "false"
            ;;
        codex)
            printf '%s\n' "# Codex Installation" "Harness V6 active. Follow .agents/ governance." > "$tmp_plat"
            sync_file "$tmp_plat" ".codex/INSTALL.md" "false"
            ;;
        gemini)
            printf '%s\n' "# Gemini Profile" "Harness V6 active. Follow .agents/ governance." > "$tmp_plat"
            sync_file "$tmp_plat" "GEMINI.md" "false"
            ;;
        opencode)
            printf '%s\n' "# OpenCode Profile" "Harness V6 active. Follow .agents/ governance." > "$tmp_plat"
            sync_file "$tmp_plat" ".opencode/INSTALL.md" "false"
            ;;
        cline)
            printf '%s\n' "# Cline Profile" "Harness V6 active. Follow .agents/ governance." > "$tmp_plat"
            sync_file "$tmp_plat" ".cline/INSTALL.md" "false"
            ;;
    esac
    rm -f "$tmp_plat"
}

# =============================================================================
# PHASE 13: INSTALL REPORT
# =============================================================================
_print_list_section() {
    local label="$1" count="$2" marker="$3"
    shift 3
    local items=("$@")
    local limit=30
    echo "$label ($count):"
    if [ "$count" -eq 0 ]; then echo "  (none)"; return; fi
    local i=0
    for f in "${items[@]}"; do
        if [ "$i" -lt "$limit" ]; then
            echo "  $marker $f"
        else
            echo "  ... and $((count - limit)) more"
            break
        fi
        i=$((i + 1))
    done
}

generate_report() {
    echo "==========================================================="
    echo "AGENT HARNESS OS ADOPTION REPORT (V$VERSION)"
    echo "Target Directory: $TARGET_DIR"
    echo "Mode:             $(install_mode_label)"
    echo "Dry Run:          $DRY_RUN"
    echo "==========================================================="
    [ "$DRY_RUN" = true ] && echo "SIMULATED FILE OPERATIONS:" || echo "REALIZED FILE OPERATIONS:"

    echo ""
    _print_list_section "Created" "$COUNT_CREATED" "[+]" "${LIST_CREATED[@]}"
    echo ""
    _print_list_section "Updated" "$COUNT_UPDATED" "[*]" "${LIST_UPDATED[@]}"
    echo ""
    _print_list_section "Preserved" "$COUNT_PRESERVED" "[=]" "${LIST_PRESERVED[@]}"
    echo ""
    _print_list_section "Excluded Runtime" "$COUNT_EXCLUDED" "[x]" "${LIST_EXCLUDED[@]}"
    echo ""
    _print_list_section "Migrated Evidence" "$COUNT_MIGRATED" "[>]" "${LIST_MIGRATED[@]}"
    echo ""
    _print_list_section "Conflicts" "$COUNT_CONFLICTS" "[!]" "${LIST_CONFLICTS[@]}"

    if [ ${#LIST_MANUAL[@]} -ne 0 ]; then
        echo ""
        echo "MANUAL ACTIONS REQUIRED:"
        for act in "${LIST_MANUAL[@]}"; do echo "  - $act"; done
    fi

    echo ""
    echo "==========================================================="
    echo "INSTALL SUMMARY"
    echo "  Created:     $COUNT_CREATED"
    echo "  Updated:     $COUNT_UPDATED"
    echo "  Preserved:   $COUNT_PRESERVED"
    echo "  Skipped:     $COUNT_SKIPPED"
    echo "  Excluded:    $COUNT_EXCLUDED"
    echo "  Migrated:    $COUNT_MIGRATED"
    echo "  Conflicts:   $COUNT_CONFLICTS"
    echo "==========================================================="

    journal_entry "install_complete" "created=$COUNT_CREATED updated=$COUNT_UPDATED preserved=$COUNT_PRESERVED skipped=$COUNT_SKIPPED excluded=$COUNT_EXCLUDED conflicts=$COUNT_CONFLICTS"
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================
echo "Agent Harness OS Installer V$VERSION"
echo "====================================="

# Step 1: Migration (legacy V1/V2)
apply_migration

# Step 2: Baseline rules
install_baseline_rules

# Step 3: Skeleton workspace
install_skeleton

# Step 4: Workspace directories (idempotent)
ensure_workspace_directories

# Step 5: Evidence migration
migrate_evidence

# Step 6: Root AGENTS.md contract
install_agents_contract

# Step 6b: Project-local contract (Layer 4)
install_project_contract

# Step 6c: Governance index
install_governance_index

# Step 6d: Persist project name to config
persist_project_config

# Step 7: Core utilities
install_core_utilities

# Step 8: Platform adapters
install_platform_adapters

# Step 9: Report
generate_report

# Mark success — prevents rollback trigger
INSTALL_SUCCESS=true

if [ "$DRY_RUN" = true ]; then
    echo "DRY RUN MODE COMPLETE: No changes were written to disk."
else
    echo "Agent Harness OS V$VERSION installed successfully!"
    if [ "$COUNT_CONFLICTS" -gt 0 ]; then
        echo "NOTE: $COUNT_CONFLICTS conflict(s) detected. Review manual actions above."
    fi
fi
