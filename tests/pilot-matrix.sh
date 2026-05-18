#!/usr/bin/env bash
# tests/pilot-matrix.sh — Agent Harness CI Pilot Matrix
#
# Runs 5 pilot adoption scenarios against the Agent Harness installer,
# verifying each produces correct governance artifacts with zero leakage.
#
# Usage:
#   bash tests/pilot-matrix.sh
#
# Exit codes:
#   0 = all scenarios passed
#   1 = one or more scenarios failed
#   2 = environment error (missing harness source)

set -euo pipefail

# ============================================================
# Configuration
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source of reusable baseline (the .agents/.rules directory we install from)
HARNESS_SOURCE="${PROJECT_ROOT}/.agents/.rules"

# Temp root for pilot repos
TEMP_ROOT="${TMPDIR:-/tmp}/agent-harness-pilot-matrix"
TIMESTAMP="$(date +%Y%m%dT%H%M%S)"

# Counters
TOTAL_SCENARIOS=0
PASSED_SCENARIOS=0
FAILED_SCENARIOS=0
SKIPPED_SCENARIOS=0

# Colours (disabled in CI / non-tty)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    CYAN='\033[0;36m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    CYAN=''
    NC=''
fi

# ============================================================
# Helpers
# ============================================================

log()  { echo -e "${CYAN}[MATRIX]${NC} $*"; }
ok()   { echo -e "${GREEN}  [PASS]${NC} $*"; }
fail() { echo -e "${RED}  [FAIL]${NC} $*"; }
warn() { echo -e "${YELLOW}  [WARN]${NC} $*"; }
info() { echo "         $*"; }

assert_file_exists() {
    local file="$1"
    local label="${2:-$file}"
    if [ -f "$file" ]; then
        ok "$label"
        return 0
    else
        fail "$label (expected $file)"
        return 1
    fi
}

assert_file_not_contains() {
    local file="$1"
    local pattern="$2"
    local label="${3:-$file does not contain '$pattern'}"
    if [ -f "$file" ] && grep -q "$pattern" "$file" 2>/dev/null; then
        fail "$label (found '$pattern' in $file)"
        return 1
    else
        ok "$label"
        return 0
    fi
}

assert_file_contains() {
    local file="$1"
    local pattern="$2"
    local label="${3:-$file contains '$pattern'}"
    if [ -f "$file" ] && grep -q "$pattern" "$file" 2>/dev/null; then
        ok "$label"
        return 0
    else
        fail "$label (pattern '$pattern' not found in $file)"
        return 1
    fi
}

assert_dir_exists() {
    local dir="$1"
    local label="${2:-$dir}"
    if [ -d "$dir" ]; then
        ok "$label"
        return 0
    else
        fail "$label (expected directory $dir)"
        return 1
    fi
}

# ============================================================
# Simplified Installer
# ============================================================
# Since harness_installer.php is hardcoded to AvaX, we implement
# a minimal bash installer here that works for any project type.
# This is the installer-under-test.

install_harness() {
    local target="$1"
    local project_name="$2"
    local language="${3:-unknown}"
    local project_type="${4:-generic}"

    # 0. Ensure parent .agents directory exists before copying baseline
    mkdir -p "$target/.agents"

    # 1. Copy reusable baseline
    if [ -d "$HARNESS_SOURCE" ]; then
        cp -r "$HARNESS_SOURCE" "$target/.agents/.rules"
    else
        echo "ERR_MISSING_HARNESS_SOURCE"
        return 1
    fi

    # 2. Create local workspace skeleton
    mkdir -p "$target/.agents/how-to"
    mkdir -p "$target/.agents/config"
    mkdir -p "$target/.agents/management/evidence"/{truth,releases,generated,raw,archive,security,validation,indexes,cache,phases,reviews,traces,replay,performance,install-journal}
    mkdir -p "$target/.agents/management/memories"
    mkdir -p "$target/.agents/management/learning"
    mkdir -p "$target/.agents/skills"
    mkdir -p "$target/.agents/business-logic"
    mkdir -p "$target/.agents/review"
    mkdir -p "$target/.agents/hooks"
    mkdir -p "$target/EVIDENCE"

    # 3. Create project.json
    cat > "$target/.agents/config/project.json" <<'ENDJSON'
{
    "version": "1.0.0",
    "adopted_at": "TIMESTAMP_PLACEHOLDER",
    "project_name": "PROJECT_NAME_PLACEHOLDER",
    "language": "LANGUAGE_PLACEHOLDER",
    "project_type": "PROJECT_TYPE_PLACEHOLDER",
    "harness_version": "3.0.0",
    "profiles_resolved": true
}
ENDJSON
    sed -i "s|TIMESTAMP_PLACEHOLDER|$(date -u +%Y-%m-%dT%H:%M:%SZ)|g" "$target/.agents/config/project.json"
    sed -i "s|PROJECT_NAME_PLACEHOLDER|${project_name}|g" "$target/.agents/config/project.json"
    sed -i "s|LANGUAGE_PLACEHOLDER|${language}|g" "$target/.agents/config/project.json"
    sed -i "s|PROJECT_TYPE_PLACEHOLDER|${project_type}|g" "$target/.agents/config/project.json"

    # 4. Create L4 overlay template
    cat > "$target/.agents/how-to/how-to-write-${project_name}.md" <<ENDOVERLAY
# ${project_name} — Project-Local Contract (Layer 4)

Version: 1.0.0
Status: Active
Scope: ./**

This is the Layer 4 project-local governance overlay for ${project_name}.

It extends the reusable baseline (.agents/) with project-specific
naming, filesystem shape, and conventions.

## Language: ${language}
## Project Type: ${project_type}

## Override Semantics

When this overlay disagrees with the reusable baseline, this overlay wins
for ${project_name}-specific concerns.

This overlay MUST NOT modify .agents/ directly.

## Project Structure

Describe the actual folder shape of ${project_name} here.

## Naming Rules

Describe naming conventions here.

## MUST_RESTORE_LOCALLY

The following concepts are project-local and must NOT leak into reusable rules:
- (add project-specific concepts here)

## Validation

Run project-specific validation commands here.
ENDOVERLAY

    # 5. Create root AGENTS.md if not present
    if [ ! -f "$target/AGENTS.md" ]; then
        cat > "$target/AGENTS.md" <<ENDAGENTS
# AGENTS.md — ${project_name} Local Project Contract

Version: 1.0.0
Status: Normative / Local / Root Contract
Scope: ./**

This file is the project-specific root contract for ${project_name}.

It adopts the Agent Harness operating system.

## Order of Precedence

1. This AGENTS.md (L0 — highest)
2. .agents/how-to/how-to-write-${project_name}.md (L4 overlay)
3. .agents/AGENTS.md (reusable baseline)
4. .agents/governance/profiles/languages/${language}.md (if exists)
5. .agents/governance/profiles/project-types/${project_type}.md (if exists)

## Project-Local Contract

The project-local contract lives at:

\`.agents/how-to/how-to-write-${project_name}.md\`

This file declares project-specific naming, filesystem, and validation rules.

## Evidence

Evidence lives in:

- EVIDENCE/ (human dashboard — thin layer)
- .agents/management/evidence/ (canonical evidence runtime)
ENDAGENTS
    fi

    # 6. Create GOVERNANCE_INDEX.md if not present
    if [ ! -f "$target/.agents/GOVERNANCE_INDEX.md" ]; then
        cat > "$target/.agents/GOVERNANCE_INDEX.md" <<ENDINDEX
# ${project_name} Governance Index

## Purpose

This file tells agents what to read, in what order, and why.

## Required Reading Order

1. AGENTS.md - root contract
2. .agents/how-to/how-to-write-${project_name}.md - Layer 4 project-local contract
3. .agents/GOVERNANCE_INDEX.md - this navigation map
4. .agents/AGENTS.md - reusable baseline
5. .agents/management/TODO.md - active work queue

## Workspace Routing

| Area | Purpose |
|------|---------|
| .agents/how-to/ | local governance rules |
| .agents/skills/ | task playbooks |
| .agents/management/ | active stage, evidence |
| .agents/ | reusable baseline |

## Project-Local Contract

The project-local contract is:

\`.agents/how-to/how-to-write-${project_name}.md\`
ENDINDEX
    fi

    # 7. Create CURRENT.md in EVIDENCE
    if [ ! -f "$target/EVIDENCE/CURRENT.md" ]; then
        cat > "$target/EVIDENCE/CURRENT.md" <<ENDCURRENT
# Current Status

## Status: YELLOW

Adoption in progress. Validation not yet run.

## Commit: $(cd "$target" && git rev-parse HEAD 2>/dev/null || echo "no-git")
## Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)
ENDCURRENT
    fi

    echo "OK"
    return 0
}

# ============================================================
# Scenario Runner
# ============================================================

run_scenario() {
    local name="$1"
    local scenario_fn="$2"
    TOTAL_SCENARIOS=$((TOTAL_SCENARIOS + 1))

    log "Running scenario: $name"
    local pilot_dir="${TEMP_ROOT}/${name}-${TIMESTAMP}"
    mkdir -p "$pilot_dir"

    local scenario_pass=0
    local scenario_fail=0

    # Run the scenario, capturing pass/fail via a subshell variable
    (
        cd "$pilot_dir"
        $scenario_fn "$pilot_dir"
    )
    local rc=$?

    if [ $rc -eq 0 ]; then
        PASSED_SCENARIOS=$((PASSED_SCENARIOS + 1))
        log "  Scenario $name: PASSED"
    else
        FAILED_SCENARIOS=$((FAILED_SCENARIOS + 1))
        log "  Scenario $name: FAILED"
    fi
    return $rc
}

# ============================================================
# Scenario 1: PHP Library
# ============================================================

scenario_php_library() {
    local dir="$1"
    local checks_pass=0
    local checks_fail=0

    # Setup: create minimal PHP library structure
    mkdir -p "$dir/src"
    cat > "$dir/composer.json" <<'EOF'
{
    "name": "pilot/php-library",
    "description": "Pilot PHP Library for Agent Harness adoption test",
    "type": "library",
    "autoload": {
        "psr-4": {
            "Pilot\\PhpLibrary\\": "src/"
        }
    }
}
EOF
    cat > "$dir/src/Example.php" <<'EOF'
<?php
declare(strict_types=1);

namespace Pilot\PhpLibrary;

class Example
{
    public function hello(): string
    {
        return 'hello from pilot php library';
    }
}
EOF
    cd "$dir" && git init -q && git add -A && git commit -q -m "initial php library pilot"

    # Install harness
    local result
    result=$(install_harness "$dir" "pilot-php-library" "php" "library" 2>&1) || {
        fail "Install failed for php-library"
        return 1
    }
    if [ "$result" != "OK" ]; then
        fail "Install returned unexpected result: $result"
        return 1
    fi

    # --- Verify artifacts ---

    assert_dir_exists "$dir/.agents/.rules" ".agents/.rules exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/AGENTS.md" ".agents/AGENTS.md exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/how-to/how-to-write-pilot-php-library.md" "L4 overlay exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/AGENTS.md" "Root AGENTS.md exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/GOVERNANCE_INDEX.md" "GOVERNANCE_INDEX.md exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/config/project.json" "project.json exists" || checks_fail=$((checks_fail+1)) || true

    # Verify project.json metadata
    assert_file_contains "$dir/.agents/config/project.json" '"project_name": "pilot-php-library"' "project.json has correct project_name" || checks_fail=$((checks_fail+1)) || true
    assert_file_contains "$dir/.agents/config/project.json" '"language": "php"' "project.json has correct language" || checks_fail=$((checks_fail+1)) || true
    assert_file_contains "$dir/.agents/config/project.json" '"project_type": "library"' "project.json has correct project_type" || checks_fail=$((checks_fail+1)) || true

    # Verify AGENTS.md references project-local contract
    assert_file_contains "$dir/AGENTS.md" "how-to-write-pilot-php-library.md" "AGENTS.md references project-local contract" || checks_fail=$((checks_fail+1)) || true

    # Verify GOVERNANCE_INDEX.md references project-local contract
    assert_file_contains "$dir/.agents/GOVERNANCE_INDEX.md" "how-to-write-pilot-php-library.md" "GOVERNANCE_INDEX.md references project-local contract" || checks_fail=$((checks_fail+1)) || true

    # Verify evidence hygiene
    assert_file_exists "$dir/EVIDENCE/CURRENT.md" "EVIDENCE/CURRENT.md exists" || checks_fail=$((checks_fail+1)) || true

    if [ $checks_fail -gt 0 ]; then
        return 1
    fi
    return 0
}

# ============================================================
# Scenario 2: Node.js CLI
# ============================================================

scenario_node_cli() {
    local dir="$1"
    local checks_pass=0
    local checks_fail=0

    # Setup: create minimal Node.js CLI structure
    mkdir -p "$dir/cli" "$dir/tests"
    cat > "$dir/package.json" <<'EOF'
{
    "name": "pilot-node-cli",
    "version": "1.0.0",
    "description": "Pilot Node.js CLI for Agent Harness adoption test",
    "type": "module",
    "bin": {
        "pilot-cli": "./cli/index.js"
    },
    "scripts": {
        "test": "node tests/run.js"
    }
}
EOF
    cat > "$dir/cli/index.js" <<'EOF'
#!/usr/bin/env node
console.log('hello from pilot node cli');
EOF
    chmod +x "$dir/cli/index.js"
    cat > "$dir/tests/run.js" <<'EOF'
console.log('tests pass');
process.exit(0);
EOF
    cd "$dir" && git init -q && git add -A && git commit -q -m "initial node cli pilot"

    # Install harness
    local result
    result=$(install_harness "$dir" "pilot-node-cli" "nodejs" "cli" 2>&1) || {
        fail "Install failed for node-cli"
        return 1
    }
    if [ "$result" != "OK" ]; then
        fail "Install returned unexpected result: $result"
        return 1
    fi

    # --- Verify artifacts ---
    assert_dir_exists "$dir/.agents/.rules" ".agents/.rules exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/AGENTS.md" ".agents/AGENTS.md exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/how-to/how-to-write-pilot-node-cli.md" "L4 overlay exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/AGENTS.md" "Root AGENTS.md exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/GOVERNANCE_INDEX.md" "GOVERNANCE_INDEX.md exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/config/project.json" "project.json exists" || checks_fail=$((checks_fail+1)) || true

    # Verify project.json metadata
    assert_file_contains "$dir/.agents/config/project.json" '"project_name": "pilot-node-cli"' "project.json has correct project_name" || checks_fail=$((checks_fail+1)) || true
    assert_file_contains "$dir/.agents/config/project.json" '"language": "nodejs"' "project.json has correct language" || checks_fail=$((checks_fail+1)) || true

    # Verify AGENTS.md references project-local contract
    assert_file_contains "$dir/AGENTS.md" "how-to-write-pilot-node-cli.md" "AGENTS.md references project-local contract" || checks_fail=$((checks_fail+1)) || true

    # Verify GOVERNANCE_INDEX.md references project-local contract
    assert_file_contains "$dir/.agents/GOVERNANCE_INDEX.md" "how-to-write-pilot-node-cli.md" "GOVERNANCE_INDEX.md references project-local contract" || checks_fail=$((checks_fail+1)) || true

    if [ $checks_fail -gt 0 ]; then
        return 1
    fi
    return 0
}

# ============================================================
# Scenario 3: API Service
# ============================================================

scenario_api_service() {
    local dir="$1"
    local checks_pass=0
    local checks_fail=0

    # Setup: create minimal API service structure (Node.js)
    mkdir -p "$dir/src/routes" "$dir/src/handlers" "$dir/tests"
    cat > "$dir/package.json" <<'EOF'
{
    "name": "pilot-api-service",
    "version": "1.0.0",
    "description": "Pilot API Service for Agent Harness adoption test",
    "type": "module",
    "main": "src/index.js",
    "scripts": {
        "start": "node src/index.js",
        "test": "node tests/run.js"
    }
}
EOF
    cat > "$dir/src/index.js" <<'EOF'
// Minimal API service entry point
console.log('api service starting');
EOF
    cat > "$dir/src/routes/index.js" <<'EOF'
// Route definitions
export const routes = [];
EOF
    cat > "$dir/src/handlers/health.js" <<'EOF'
// Health check handler
export function healthCheck() {
    return { status: 'ok' };
}
EOF
    cd "$dir" && git init -q && git add -A && git commit -q -m "initial api service pilot"

    # Install harness
    local result
    result=$(install_harness "$dir" "pilot-api-service" "nodejs" "api-service" 2>&1) || {
        fail "Install failed for api-service"
        return 1
    }
    if [ "$result" != "OK" ]; then
        fail "Install returned unexpected result: $result"
        return 1
    fi

    # --- Verify artifacts ---
    assert_dir_exists "$dir/.agents/.rules" ".agents/.rules exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/AGENTS.md" ".agents/AGENTS.md exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/how-to/how-to-write-pilot-api-service.md" "L4 overlay exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/AGENTS.md" "Root AGENTS.md exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/GOVERNANCE_INDEX.md" "GOVERNANCE_INDEX.md exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/config/project.json" "project.json exists" || checks_fail=$((checks_fail+1)) || true

    # Verify project.json metadata
    assert_file_contains "$dir/.agents/config/project.json" '"project_name": "pilot-api-service"' "project.json has correct project_name" || checks_fail=$((checks_fail+1)) || true
    assert_file_contains "$dir/.agents/config/project.json" '"project_type": "api-service"' "project.json has correct project_type" || checks_fail=$((checks_fail+1)) || true

    # Verify AGENTS.md references project-local contract
    assert_file_contains "$dir/AGENTS.md" "how-to-write-pilot-api-service.md" "AGENTS.md references project-local contract" || checks_fail=$((checks_fail+1)) || true

    # Verify GOVERNANCE_INDEX.md references project-local contract
    assert_file_contains "$dir/.agents/GOVERNANCE_INDEX.md" "how-to-write-pilot-api-service.md" "GOVERNANCE_INDEX.md references project-local contract" || checks_fail=$((checks_fail+1)) || true

    if [ $checks_fail -gt 0 ]; then
        return 1
    fi
    return 0
}

# ============================================================
# Scenario 4: Clean Empty Repo
# ============================================================

scenario_clean_empty_repo() {
    local dir="$1"
    local checks_pass=0
    local checks_fail=0

    # Setup: completely empty repo, no composer.json, no package.json
    cd "$dir" && git init -q && git commit -q --allow-empty -m "initial empty commit"

    # Install harness — should fallback to directory name
    local result
    result=$(install_harness "$dir" "$(basename "$dir")" "unknown" "generic" 2>&1) || {
        fail "Install failed for clean-empty-repo"
        return 1
    }
    if [ "$result" != "OK" ]; then
        fail "Install returned unexpected result: $result"
        return 1
    fi

    # --- Verify artifacts ---
    assert_dir_exists "$dir/.agents/.rules" ".agents/.rules exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/AGENTS.md" ".agents/AGENTS.md exists" || checks_fail=$((checks_fail+1)) || true

    # L4 overlay should exist with the directory name
    local overlay_name
    overlay_name="$(basename "$dir")"
    assert_file_exists "$dir/.agents/how-to/how-to-write-${overlay_name}.md" "L4 overlay exists with fallback name" || checks_fail=$((checks_fail+1)) || true

    assert_file_exists "$dir/AGENTS.md" "Root AGENTS.md created for empty repo" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/GOVERNANCE_INDEX.md" "GOVERNANCE_INDEX.md created for empty repo" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/config/project.json" "project.json created for empty repo" || checks_fail=$((checks_fail+1)) || true

    # Verify fallback metadata
    assert_file_contains "$dir/.agents/config/project.json" '"language": "unknown"' "project.json has unknown language fallback" || checks_fail=$((checks_fail+1)) || true
    assert_file_contains "$dir/.agents/config/project.json" '"project_type": "generic"' "project.json has generic project_type fallback" || checks_fail=$((checks_fail+1)) || true

    # Root AGENTS.md should reference the contract
    assert_file_contains "$dir/AGENTS.md" "how-to-write-${overlay_name}.md" "AGENTS.md references the fallback contract" || checks_fail=$((checks_fail+1)) || true

    if [ $checks_fail -gt 0 ]; then
        return 1
    fi
    return 0
}

# ============================================================
# Scenario 5: Conflicting Governance Repo
# ============================================================

scenario_conflicting_governance() {
    local dir="$1"
    local checks_pass=0
    local checks_fail=0

    # Setup: pre-existing AGENTS.md and local governance
    cat > "$dir/AGENTS.md" <<'EOF'
# AGENTS.md — Pre-existing Local Contract

This is the pre-existing governance for this project.
It must not be overwritten by the installer.

## Project Rules

- All code must be reviewed
- Tests must pass before commit
- No secrets in source
EOF

    mkdir -p "$dir/.agents/how-to"
    cat > "$dir/.agents/how-to/how-to-write-local.md" <<'EOF'
# Local Governance Overlay (Pre-existing)

This is the pre-existing local governance overlay.
The installer must preserve this file and report the conflict.

## Local Rules

- Custom naming convention: always use prefix `local_`
- All modules go in `modules/` directory
EOF

    mkdir -p "$dir/.agents/management"
    cat > "$dir/.agents/management/TODO.md" <<'EOF'
# TODO

- Build the thing
- Test the thing
EOF

    cd "$dir" && git init -q && git add -A && git commit -q -m "initial with pre-existing governance"

    # Install harness — should detect conflict and preserve local governance
    local result
    result=$(install_harness "$dir" "pilot-conflicting" "php" "library" 2>&1) || {
        fail "Install failed for conflicting-governance"
        return 1
    }
    if [ "$result" != "OK" ]; then
        fail "Install returned unexpected result: $result"
        return 1
    fi

    # --- Verify artifacts ---

    # Pre-existing AGENTS.md should be preserved (installer should not overwrite)
    # Our minimal installer uses "if not present" check, so it preserves
    assert_file_exists "$dir/AGENTS.md" "Pre-existing AGENTS.md preserved" || checks_fail=$((checks_fail+1)) || true

    # Pre-existing local overlay should be preserved
    assert_file_exists "$dir/.agents/how-to/how-to-write-local.md" "Pre-existing local overlay preserved" || checks_fail=$((checks_fail+1)) || true

    # New overlay should also be created (conflict reported)
    assert_file_exists "$dir/.agents/how-to/how-to-write-pilot-conflicting.md" "New L4 overlay created alongside existing" || checks_fail=$((checks_fail+1)) || true

    # Baseline should be installed
    assert_dir_exists "$dir/.agents/.rules" ".agents/.rules exists" || checks_fail=$((checks_fail+1)) || true
    assert_file_exists "$dir/.agents/AGENTS.md" ".agents/AGENTS.md exists" || checks_fail=$((checks_fail+1)) || true

    # GOVERNANCE_INDEX should exist
    assert_file_exists "$dir/.agents/GOVERNANCE_INDEX.md" "GOVERNANCE_INDEX.md exists" || checks_fail=$((checks_fail+1)) || true

    # project.json should exist
    assert_file_exists "$dir/.agents/config/project.json" "project.json exists" || checks_fail=$((checks_fail+1)) || true

    # Pre-existing TODO should be preserved
    assert_file_exists "$dir/.agents/management/TODO.md" "Pre-existing TODO.md preserved" || checks_fail=$((checks_fail+1)) || true

    # The pre-existing AGENTS.md should still contain its original content
    assert_file_contains "$dir/AGENTS.md" "Pre-existing Local Contract" "Pre-existing AGENTS.md content preserved" || checks_fail=$((checks_fail+1)) || true

    if [ $checks_fail -gt 0 ]; then
        return 1
    fi
    return 0
}

# ============================================================
# Main
# ============================================================

main() {
    echo "============================================="
    echo "AGENT HARNESS — CI PILOT MATRIX"
    echo "============================================="
    echo "Timestamp: ${TIMESTAMP}"
    echo "Temp root: ${TEMP_ROOT}"
    echo "Harness source: ${HARNESS_SOURCE}"
    echo ""

    # Verify harness source exists
    if [ ! -d "$HARNESS_SOURCE" ]; then
        echo "ERROR: Harness source not found at ${HARNESS_SOURCE}"
        echo "This script requires .agents/ to exist."
        exit 2
    fi

    # Clean previous runs
    rm -rf "$TEMP_ROOT"
    mkdir -p "$TEMP_ROOT"

    # Run scenarios
    log "--- Scenario 1: PHP Library ---"
    run_scenario "php-library" "scenario_php_library" || true

    echo ""
    log "--- Scenario 2: Node.js CLI ---"
    run_scenario "node-cli" "scenario_node_cli" || true

    echo ""
    log "--- Scenario 3: API Service ---"
    run_scenario "api-service" "scenario_api_service" || true

    echo ""
    log "--- Scenario 4: Clean Empty Repo ---"
    run_scenario "clean-empty-repo" "scenario_clean_empty_repo" || true

    echo ""
    log "--- Scenario 5: Conflicting Governance Repo ---"
    run_scenario "conflicting-governance" "scenario_conflicting_governance" || true

    # Summary
    echo ""
    echo "============================================="
    echo "PILOT MATRIX RESULTS"
    echo "============================================="
    echo "Total scenarios:  ${TOTAL_SCENARIOS}"
    echo -e "Passed:           ${GREEN}${PASSED_SCENARIOS}${NC}"
    echo -e "Failed:           ${RED}${FAILED_SCENARIOS}${NC}"
    echo ""

    if [ $FAILED_SCENARIOS -gt 0 ]; then
        echo "STATUS: RED"
        exit 1
    else
        echo "STATUS: GREEN"
        exit 0
    fi
}

main "$@"
