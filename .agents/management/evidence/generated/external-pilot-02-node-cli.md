# External Pilot 02 — Generic Node.js CLI Adoption

Date: 2026-05-18
Status: GREEN
Pilot Kind: External adoption proof — first non-PHP portability

## Objective

Prove that Agent Harness OS V6.0.0 works outside PHP and outside AvaX by
adopting a generic Node.js CLI repository.

## Pilot Setup

Created a minimal Node.js CLI at `/tmp/agent-os-pilot-node-cli/`:

```json
{
  "name": "pilot/node-cli",
  "version": "1.0.0",
  "type": "module",
  "bin": { "pilot-cli": "./cli/index.js" }
}
```

Source structure:
- `cli/index.js` — CLI entrypoint
- `cli/greet.js` — core logic
- `tests/greet.test.js` — node:test-based tests

Adoption command:
```
bash install-os.sh /tmp/agent-os-pilot-node-cli \
  --language=nodejs --project-type=cli --project-name=pilot-node-cli
```

## Results

### Files Installed

352 files created. Full baseline rules, skeleton workspace, project-local
contract, GOVERNANCE_INDEX, and AGENTS.md.

### Profile Resolution Chain (L0-L4)

| Layer | File | Status |
|-------|------|--------|
| L0 | `AGENTS.md` | Present, references L4 contract, declares `nodejs` + `cli` |
| L1 | `.agents/.rules/AGENTS.md` | Present, baseline contract |
| L2 | `.agents/.rules/governance/profiles/languages/nodejs.md` | Present, 7426 bytes, genuine Node.js profile |
| L3 | `.agents/.rules/governance/profiles/project-types/cli.md` | Present, 1543 bytes, genuine CLI profile |
| L4 | `.agents/how-to/how-to-write-pilot-node-cli.md` | Present, 105 non-empty lines |

### AvaX/PHP Leakage Check

| Scope | AvaX References | PHP References | Verdict |
|-------|----------------|----------------|---------|
| Project-local contract | 0 | 0 (only template placeholder examples) | CLEAN |
| GOVERNANCE_INDEX.md | 0 | 0 | CLEAN |
| AGENTS.md (scaffold) | 0 | 0 | CLEAN |
| project.json | 0 | 0 | CLEAN |
| nodejs.md profile | 0 | 0 | CLEAN |
| cli.md profile | 0 | 0 | CLEAN |

The project-local contract references `nodejs.md` and `cli.md` — no PHP
or AvaX-specific rules are forced.

### Template Placeholder Note

The template `how-to-write-project.md` had PHP examples in placeholder text
(e.g., "PHP 8.5", "php-fpm"). Fixed to use language-neutral examples
(TypeScript, Python, Go, node, deno, bun). This was a minor cosmetic issue,
not a functional leak — the placeholders are instructional, not prescriptive.

### Validation Results

**Project-local contract validation (check-project-local-contract.php):**

```
PASS (10/10):
  ✓ Project-local contract exists: how-to-write-pilot-node-cli.md
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

**Agent Harness Diagnostics:**

```
Overall Status: GREEN
[GREEN] adoption_readiness
[GREEN] upgrade_readiness
[GREEN] migration_readiness
[GREEN] install_health
[GREEN] orphan_artifacts
[GREEN] baseline_integrity
[GREEN] naming_compliance
```

**Root Evidence Hygiene:**

```
Result: PASS
Root EVIDENCE/ is clean.
```

### Bugs Fixed During Pilot

1. **Template had PHP-biased examples**: The `how-to-write-project.md`
   template used PHP-specific examples in placeholders ("PHP 8.5",
   "php-fpm, frankenphp, roadrunner"). Updated to language-neutral
   examples ("TypeScript, Python, Go" and "node, deno, bun").

## Classification

**GREEN** — Agent Harness OS V6.0.0 successfully adopts a generic Node.js CLI
project with zero AvaX/PHP leakage in project-local governance files, complete
L0-L4 profile resolution chain with genuine Node.js and CLI profiles, and all
validation checks passing.

This is the first non-PHP portability proof.
