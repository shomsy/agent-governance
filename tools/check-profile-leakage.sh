#!/usr/bin/env bash
# tools/check-profile-leakage.sh — Profile Leakage Scanner (v2)
#
# Scans generated pilot governance files for forbidden leakage terms.
# Designed to run after pilot-matrix.sh to verify cross-contamination.
#
# Usage:
#   bash tools/check-profile-leagage.sh <pilot_dir> <language>
#
# Exit codes:
#   0 = GREEN — no leakage found
#   1 = RED — blocking leakage detected
#   2 = usage error
#
# Severity levels:
#   RED    = wrong language/project instruction (blocking)
#   YELLOW = suspicious leakage (needs review)
#   INFO   = allowed example or detection signal (non-blocking)

set -euo pipefail

# ============================================================
# Configuration
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Forbidden terms for non-AvaX pilots (always wrong)
FORBIDDEN_GENERIC=(
    "how-to-write-avax"
)

# Language-specific forbidden terms (wrong language instruction)
FORBIDDEN_PHP_ONLY=(
    "composer install"
    "composer dump-autoload"
    "composer validate"
    "vendor/bin/phpunit"
    "vendor/bin/phpstan"
    "php tooling/"
    "avax runtime"
    "php avax"
)

# Node.js terms that are WRONG when used as instructions in non-Node projects
# These are checked as RED only when they appear as imperative commands,
# not when they appear as labeled examples or detection signals.
FORBIDDEN_NODEJS_COMMANDS=(
    "npm install "
    "npm test"
    "npm run "
    "npx "
)

# Terms that are acceptable in certain contexts (detection signals, examples)
# These are checked as INFO — they don't fail the scan.
ACCEPTABLE_CONTEXT_TERMS=(
    "package.json"        # Project detection signal in profile-resolution-algorithm.md
    "composer.json"       # Project detection signal in profile-resolution-algorithm.md
    "node_modules"        # Mentioned in .gitignore templates or build docs
)

# Patterns that mark a line as an acceptable example (not a real instruction)
# If a term appears on a line matching these patterns, it's INFO not RED.
EXAMPLE_MARKERS=(
    "# Node.js:"
    "# PHP:"
    "# Python:"
    "# Go:"
    "# JavaScript"
    "# TypeScript"
    "# Ecosystem-specific"
    "example"
    "Example"
    "<package-manager>"
    "<test-runner>"
    "<test-command>"
    "<lint-command>"
    "<dependency>"
    "-> "                 # Detection signal format: "package.json -> nodejs"
    "without "            # Contextual: "package.json without TypeScript"
    "candidate"           # Detection: "runtime candidate"
)

# ============================================================
# Usage
# ============================================================

if [ $# -lt 2 ]; then
    echo "Usage: $0 <pilot_dir> <language>"
    echo ""
    echo "Scans governance files in <pilot_dir> for terms that"
    echo "leak from the wrong language profile or AvaX-specific"
    echo "naming into a non-AvaX pilot."
    echo ""
    echo "Languages: php, nodejs, unknown"
    exit 2
fi

PILOT_DIR="$1"
LANGUAGE="$2"

if [ ! -d "$PILOT_DIR" ]; then
    echo "ERROR: Pilot directory not found: $PILOT_DIR"
    exit 2
fi

# ============================================================
# Helpers
# ============================================================

RED_COUNT=0
YELLOW_COUNT=0
INFO_COUNT=0
REPORT_LINES=()

report_leak() {
    local severity="$1"
    local file="$2"
    local term="$3"
    local reason="$4"

    case "$severity" in
        RED)
            RED_COUNT=$((RED_COUNT + 1))
            ;;
        YELLOW)
            YELLOW_COUNT=$((YELLOW_COUNT + 1))
            ;;
        INFO)
            INFO_COUNT=$((INFO_COUNT + 1))
            return 0  # INFO doesn't count as a leak
            ;;
    esac

    REPORT_LINES+=("${severity}: '${term}' found in ${file} — ${reason}")
}

# Check if a line is an acceptable example rather than a real instruction
is_acceptable_context() {
    local line="$1"

    for marker in "${EXAMPLE_MARKERS[@]}"; do
        if echo "$line" | grep -qi "$marker" 2>/dev/null; then
            return 0  # acceptable
        fi
    done

    return 1  # not acceptable context
}

# Scan a file for a term, checking context for acceptability
# Checks a window of surrounding lines (not just the matching line) for example markers.
scan_file_contextual() {
    local file="$1"
    local term="$2"
    local severity_red="$3"
    local severity_yellow="$4"
    local context_window=3  # lines before/after to check for markers

    if [ ! -f "$file" ]; then
        return 0
    fi

    # Get line numbers containing the term
    local matching_lines
    matching_lines=$(grep -n "$term" "$file" 2>/dev/null || true)

    if [ -z "$matching_lines" ]; then
        return 0
    fi

    local total_lines
    total_lines=$(wc -l < "$file")

    while IFS= read -r line; do
        local line_num
        line_num=$(echo "$line" | cut -d: -f1)
        local line_content
        line_content=$(echo "$line" | cut -d: -f2-)

        # Check context window: lines before and after the match
        local start=$((line_num - context_window))
        local end=$((line_num + context_window))
        [ "$start" -lt 1 ] && start=1
        [ "$end" -gt "$total_lines" ] && end="$total_lines"

        local context_block
        context_block=$(sed -n "${start},${end}p" "$file")

        if is_acceptable_context "$context_block"; then
            report_leak "INFO" "$file" "$term" "Acceptable context (example/detection signal)"
        else
            report_leak "$severity_red" "$file" "$term" "$severity_yellow"
        fi
    done <<< "$matching_lines"
}

# Simple scan — no context checking
scan_file_simple() {
    local file="$1"
    local term="$2"
    local reason="$3"

    if [ ! -f "$file" ]; then
        return 0
    fi

    if grep -q "$term" "$file" 2>/dev/null; then
        report_leak "RED" "$file" "$term" "$reason"
    fi
}

# ============================================================
# Scanning Logic
# ============================================================

echo "============================================="
echo "PROFILE LEAKAGE SCANNER v2"
echo "============================================="
echo "Pilot:   ${PILOT_DIR}"
echo "Language: ${LANGUAGE}"
echo ""

# Collect governance files to scan
GOV_FILES=()
while IFS= read -r -d '' f; do
    GOV_FILES+=("$f")
done < <(find "$PILOT_DIR" -name "*.md" -path "*/.agents/*" -print0 2>/dev/null || true)

# Also scan root AGENTS.md
if [ -f "$PILOT_DIR/AGENTS.md" ]; then
    GOV_FILES+=("$PILOT_DIR/AGENTS.md")
fi

# Also scan project.json
if [ -f "$PILOT_DIR/.agents/config/project.json" ]; then
    GOV_FILES+=("$PILOT_DIR/.agents/config/project.json")
fi

echo "Files to scan: ${#GOV_FILES[@]}"
echo ""

# --- Check 1: AvaX-specific leakage in non-AvaX pilots ---
echo "--- Check 1: AvaX-specific leakage ---"
for term in "${FORBIDDEN_GENERIC[@]}"; do
    for file in "${GOV_FILES[@]}"; do
        scan_file_simple "$file" "$term" "AvaX-specific reference leaked into non-AvaX pilot"
    done
done

# --- Check 2: Language-specific leakage ---
echo "--- Check 2: Language-specific leakage ---"

if [ "$LANGUAGE" = "nodejs" ] || [ "$LANGUAGE" = "unknown" ]; then
    # PHP terms should NOT appear as instructions in Node.js pilots
    # But they're OK if they're clearly labeled examples
    for term in "${FORBIDDEN_PHP_ONLY[@]}"; do
        for file in "${GOV_FILES[@]}"; do
            scan_file_contextual "$file" "$term" \
                "RED" \
                "PHP-specific term leaked into ${LANGUAGE} pilot"
        done
    done
fi

if [ "$LANGUAGE" = "php" ] || [ "$LANGUAGE" = "unknown" ]; then
    # Node.js command terms should NOT appear as instructions in PHP pilots
    # But they're OK if they're clearly labeled examples
    for term in "${FORBIDDEN_NODEJS_COMMANDS[@]}"; do
        for file in "${GOV_FILES[@]}"; do
            scan_file_contextual "$file" "$term" \
                "RED" \
                "Node.js command leaked into ${LANGUAGE} pilot"
        done
    done

    # Acceptable context terms (INFO only)
    for term in "${ACCEPTABLE_CONTEXT_TERMS[@]}"; do
        for file in "${GOV_FILES[@]}"; do
            scan_file_contextual "$file" "$term" \
                "RED" \
                "Node.js reference leaked into ${LANGUAGE} pilot"
        done
    done
fi

# --- Check 3: Stage name leakage from AvaX ---
echo "--- Check 3: Stage name leakage ---"
AVAX_STAGE_NAMES=(
    "V4-01"
    "V4-02"
    "V4-03"
    "V4-17"
    "V5.9"
    "V5.8"
    "V5.7"
    "V4-16"
    "V4-15"
)

for term in "${AVAX_STAGE_NAMES[@]}"; do
    for file in "${GOV_FILES[@]}"; do
        scan_file_simple "$file" "$term" "AvaX stage name leaked into non-AvaX pilot"
    done
done

# --- Check 4: Validate that project.json language matches ---
echo "--- Check 4: Project.json consistency ---"
PROJECT_JSON="$PILOT_DIR/.agents/config/project.json"
if [ -f "$PROJECT_JSON" ]; then
    ACTUAL_LANG=$(grep '"language"' "$PROJECT_JSON" | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "")
    if [ "$ACTUAL_LANG" != "$LANGUAGE" ]; then
        report_leak "RED" "$PROJECT_JSON" "language=${ACTUAL_LANG}" "Expected language=${LANGUAGE}, got ${ACTUAL_LANG}"
    fi
fi

# --- Check 5: Command cross-contamination ---
echo "--- Check 5: Command cross-contamination ---"
if [ "$LANGUAGE" = "nodejs" ]; then
    for file in "${GOV_FILES[@]}"; do
        if [ -f "$file" ]; then
            # composer in Node.js pilot is wrong
            if grep -q "composer " "$file" 2>/dev/null; then
                report_leak "RED" "$file" "composer" "composer command in Node.js pilot governance"
            fi
        fi
    done
fi

if [ "$LANGUAGE" = "php" ]; then
    for file in "${GOV_FILES[@]}"; do
        if [ -f "$file" ]; then
            # npm install as a direct command (not in example context) is wrong
            if echo "$file" | grep -q "\.md$"; then
                scan_file_contextual "$file" "npm install" \
                    "RED" \
                    "npm command in PHP pilot governance markdown"
            fi
        fi
    done
fi

# ============================================================
# Report
# ============================================================

echo ""
echo "============================================="
echo "LEAKAGE REPORT"
echo "============================================="
echo "RED:    ${RED_COUNT}"
echo "YELLOW: ${YELLOW_COUNT}"
echo "INFO:   ${INFO_COUNT}"
echo ""

if [ $RED_COUNT -gt 0 ]; then
    echo "STATUS: RED — ${RED_COUNT} blocking leakage(s) detected"
    echo ""
    for line in "${REPORT_LINES[@]}"; do
        if [[ "$line" == RED:* ]]; then
            echo "  $line"
        fi
    done
    exit 1
elif [ $YELLOW_COUNT -gt 0 ]; then
    echo "STATUS: YELLOW — ${YELLOW_COUNT} warning(s)"
    echo ""
    for line in "${REPORT_LINES[@]}"; do
        echo "  $line"
    done
    exit 0
else
    echo "STATUS: GREEN — No blocking leakage detected"
    if [ $INFO_COUNT -gt 0 ]; then
        echo "INFO: ${INFO_COUNT} acceptable context term(s) found (examples/detection signals)"
    fi
    exit 0
fi
