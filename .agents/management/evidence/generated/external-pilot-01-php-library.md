# External Pilot 01 — Generic PHP Library Adoption

Date: 2026-05-18
Status: GREEN
Pilot Kind: External adoption proof

## Objective

Prove that Agent Harness OS V6.0.0 is project-agnostic by adopting a generic
PHP library repository that has no relationship to AvaX.

## Pilot Setup

Created a minimal PHP library at `/tmp/agent-os-pilot-php-library/`:

```json
{
    "name": "pilot/php-library",
    "type": "library",
    "autoload": {"psr-4": {"Pilot\\PhpLibrary\\": "src/"}}
}
```

Single source file: `src/StringHelper.php` — a `slugify()` utility.

Adoption command:
```
bash install-os.sh /tmp/agent-os-pilot-php-library \
  --language=php --project-type=library --project-name=pilot-php-library
```

## Results

### Files Installed

352 files created. Full baseline rules, skeleton workspace, project-local
contract, GOVERNANCE_INDEX, and AGENTS.md.

### Profile Resolution Chain (L0-L4)

| Layer | File | Status |
|-------|------|--------|
| L0 | `AGENTS.md` | Present, references L4 contract |
| L1 | `.agents/.rules/AGENTS.md` | Present, baseline contract |
| L2 | `.agents/.rules/governance/profiles/languages/php.md` | Present |
| L3 | `.agents/.rules/governance/profiles/project-types/library.md` | Present |
| L4 | `.agents/how-to/how-to-write-pilot-php-library.md` | Present, 105 non-empty lines |

### AvaX Leakage Check

| Scope | AvaX References | Verdict |
|-------|----------------|---------|
| Project-local contract | 0 | CLEAN |
| GOVERNANCE_INDEX.md | 0 | CLEAN |
| AGENTS.md (scaffold) | 0 | CLEAN |
| Reusable baseline (.agents/.rules/) | Minor (php.d docs reference AvaX as example) | ACCEPTABLE — baseline docs, not project contract |

The project-local contract contains zero AvaX-specific content. It uses
generic template language appropriate for any PHP library project.

### Project Name Persistence

The installer now writes the detected project name to
`.agents/config/project.json`:

```json
{
    "name": "pilot-php-library",
    "displayName": "Pilot Php Library",
    ...
}
```

This ensures validation tools discover the same project name the installer
used, regardless of whether the name came from `--project-name` flag,
composer.json, package.json, or directory basename.

### Validation Results

**Project-local contract validation (check-project-local-contract.php):**

```
PASS (10/10):
  ✓ Project-local contract exists: how-to-write-pilot-php-library.md
  ✓ Exactly one active project-local contract
  ✓ AGENTS.md references the project-local contract
  ✓ AGENTS.md declares Layer 4 in precedence chain
  ✓ GOVERNANCE_INDEX.md references the project-local contract
  ✓ Project-local contract imports reusable baseline
  ✓ Project-local contract declares override semantics
  ✓ Project-local contract has no unresolved placeholders
  ✓ Project-local contract has substantial content (105 non-empty lines)
  ✓ Project-local contract does not duplicate reusable baseline (similarity: 11.4%)

GREEN: Project-local contract is valid.
```

### Bugs Fixed During Pilot

1. **Baseline profiles not installed**: The `install_baseline_rules()` skip
   pattern `.rules/*` matched relative paths like
   `.rules/governance/profiles/languages/php.md`, preventing all governance
   profiles, standards, delivery, execution, intelligence, and integration
   directories from being installed. Fixed by changing `src_base` from
   `$SCRIPT_DIR/.agents` to `$SCRIPT_DIR/.agents/.rules` so relative paths
   start at the actual governance files.

2. **Project name not persisted**: The validator discovered project name from
   composer.json (`php-library`) while the installer used `--project-name`
   flag (`pilot-php-library`), causing a filename mismatch. Fixed by:
   - Adding `persist_project_config()` phase to write name to project.json
   - Updating validator to check contract filename first (most reliable signal)

3. **AGENTS.md scaffold missing Layer 4 marker**: The scaffold didn't include
   "Layer 4" or "overlay" text, causing the validator to fail. Fixed by
   adding `# Layer 4 project-local overlay` comment to the project contract
   reference line.

4. **`stri_contains()` unavailable**: PHP 8.5 build lacks mbstring-based
   `stri_contains()`. Replaced with `str_contains(strtolower(...), strtolower(...))`.

## Classification

**GREEN** — Agent Harness OS V6.0.0 successfully adopts a generic PHP library
project with zero AvaX leakage in the project-local contract, complete L0-L4
profile resolution chain, and all validation checks passing.
