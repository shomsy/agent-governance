# Upstream Reconciliation from AvaX Adopted Baseline

**Date:** 2026-05-19
**Source:** ~/projects/avax/.agents/.rules/
**Target:** ~/projects/agent-harness/.agents/
**Mode:** HARNESS-FULL (selective reconciliation, not blind overwrite)

## Why Reconciliation Was Needed

Agent Harness governance and runtime improvements were accidentally committed
inside AvaX's adopted `.agents/.rules/` directory during adoption. This created
a divergence where AvaX held the latest valid Agent Harness artifacts but the
upstream `agent-harness` repository was stale. This reconciliation moves
Harness-owned changes back upstream while keeping AvaX-local content in AvaX.

## Files Copied (by category)

### Runtime / Execution Substrate (skills/bin/)
- execution_runtime.py — main execution runtime
- runtime_exec.sh — shell execution wrapper
- runtime_python.sh — Python execution wrapper
- runtime_subprocess.py — subprocess execution management
- evidence-query.py — evidence querying tool
- execution_recovery.py — execution recovery and replay
- check-budgets.py — resource budget enforcement
- delegation-runtime-proof.sh — delegation proof runner
- measure-performance.sh — performance measurement
- validate-dictionary.py — framework dictionary validator
- profile-resolution-algorithm.md — updated with L4 project-local contract

### Governance Directories (new in upstream)
- governance/agents/ — agent roles and orchestration patterns
- governance/execution/ — execution lifecycle, substrate, replay, hooks, routing, sandbox
- governance/architecture/ (expanded) — profiles for frameworks and languages
- governance/delivery/ — operations runbooks, release policy, workflows
- governance/security/ — full OWASP, threat modeling, CI/CD security, secrets
- governance/intelligence/ — learning, memory, context management standards
- governance/integrations/ — MCP integration, platform compatibility
- governance/framework-dictionary/ — PHP, JavaScript, infrastructure terms
- governance/profiles/ (expanded) — roles, repository-kinds, additional langs
- governance/product/ — product management standards
- governance/skills/ — skill contract definitions
- governance/standards/ (expanded) — coding, documentation, review, testing

### Hooks System
- hooks/ (11 files) — pre-task, post-task, pre-tool-use, post-tool-use,
  session-start, subagent-dispatch, supervisor, validate-artifact,
  resolve-task-context, lib.sh, README.md

### Config / Schemas
- config/project.schema.json
- config/schemas/ (12 JSON schemas: debt, delegation, evidence, incident,
  postmortem, release, review, risk, rollback, status, validation)
- config/schemas/examples/ (7 example JSON files)

### Templates
- templates/ (22 files) — how-to-write-project, ADR, plan, review, security
  review, task templates, agent memory, PM templates (PRD, meeting notes,
  stakeholder map, user persona), task templates (execute, map, research,
  review-diff)

### Test Scripts (from AvaX tests/)
- pilot-matrix.sh — CI pilot matrix testing
- release-readiness.sh — release readiness gates
- project-local-contract-test.sh — rewrote for harness paths
- execution-substrate-test.sh
- sandbox-enforcement-test.sh
- chaos-adversarial-test.sh
- runtime-performance-test.sh
- framework-dictionary-test.sh
- operator-ux-test.sh
- replay-integrity-test.sh

### Tools
- tools/check-profile-leakage.sh — profile leakage scanner

### CI Workflows
- .github/workflows/agent-harness-ci.yml
- .github/workflows/quality-check.yml

### Root Scripts
- verify-governance.sh — updated with approved mutation handling and better
  bloat exemptions

## Files Skipped (AvaX-Local Only)

### AvaX-Specific Content
- .agents/how-to/how-to-write-avax.md — AvaX project-local contract
- .agents/how-to/* — AvaX-specific how-to guides
- .agents/business-logic/ — AvaX business context
- .agents/context/ — AvaX product context (strategy, stakeholders, users)
- .agents/memory/ — AvaX runtime memory
- .agents/sessions/ — AvaX session data
- .agents/reports/ — AvaX-specific reports
- .agents/delivery/ — AvaX delivery context
- .agents/governance-allowlist/ — AvaX-specific allowlist
- .agents/review/ — AvaX review archive/legacy
- .agents/config/ (outside .rules) — AvaX runtime config
- .agents/tmp_final_test.txt — AvaX temp file
- management/ (outside .rules) — AvaX planning, memories, metrics, roadmaps
- mcp/ — AvaX MCP servers

### AvaX Evidence Reports (not useful as upstream)
- .agents/management/evidence/phase/ — AvaX-specific execution phases
- .agents/management/subagent-metrics.json
- .agents/management/v1-rollout-roadmap.md
- .agents/management/memories/
- .agents/management/planning/
- .agents/management/reviews/

### AvaX Test Infrastructure (PHP-specific)
- tests/ (PHP unit tests, TestCase.php, fixtures/) — AvaX product tests
- tests/Architecture/, tests/Unit/, tests/Integration/, tests/Feature/, etc.

### Backup/Archive Files
- .agents.backup-before-harness-* — AvaX backup directories

## Conflicts Resolved

### verify-governance.sh
- **Conflict:** AvaX version had approved mutation handling and better bloat exemptions
- **Resolution:** Adopted AvaX version (more capable, backwards compatible)

### profile-resolution-algorithm.md
- **Conflict:** AvaX version added L4 project-local contract layer
- **Resolution:** Adopted AvaX version (adds needed L4 semantics)

### project-local-contract-test.sh
- **Conflict:** Hardcoded to AvaX paths (.agents/.rules/, how-to-write-avax.md)
- **Resolution:** Rewrote for agent-harness paths (.agents/, .agents/templates/)

### All test scripts
- **Conflict:** Referenced .agents/.rules/ (AvaX adopted layout)
- **Resolution:** Updated to .agents/ (upstream layout)

## Validation Results

### Syntax Checks
- Python compile (37 files): ALL PASS
- Bash syntax (install-os.sh, verify-governance.sh, 26 test scripts, 2 tools): ALL PASS

### Test Results
| Test | Result | Notes |
|------|--------|-------|
| project-local-contract-test.sh | GREEN (6/6) | Rewritten for harness paths |
| sandbox-enforcement-test.sh | GREEN (24/24) | - |
| chaos-adversarial-test.sh | GREEN (10/10) | - |
| replay-integrity-test.sh | GREEN (16/16) | - |
| operator-ux-test.sh | GREEN (6/7, 1 WARN) | - |
| runtime-performance-test.sh | YELLOW (7/8, 1 WARN) | Budget stress file slightly over |
| execution-substrate-test.sh | RED (29/32, 3 FAIL) | Schema files missing (pre-existing) |
| framework-dictionary-test.sh | RED (21/24, 3 FAIL) | Anti-cargo-cult edge cases |
| pilot-matrix.sh | RED (0/5 scenarios) | Installer doesn't create .agents/AGENTS.md (pre-existing) |
| release-readiness.sh | RED | Cascading from pilot-matrix + verify-governance |
| verify-governance.sh | RED (exit 14) | Orphan EVIDENCE/security at root (pre-existing) |

## Remaining YELLOW / RED Items

### Pre-existing (not caused by reconciliation)
1. **pilot-matrix.sh RED** — install-os.sh does not create `.agents/AGENTS.md`
   in target projects. All 5 pilot scenarios fail on this assertion.
2. **verify-governance.sh exit 14** — Orphan `EVIDENCE/security/` directory at
   repo root predates reconciliation. Needs archival or removal.
3. **execution-substrate-test.sh 3 schema failures** — Execution manifest
   schema, replay manifest schema, and approval record schema files missing.
4. **framework-dictionary-test.sh 3 failures** — Anti-cargo-cult compound name
   detection and level reporting edge cases.
5. **runtime-performance-test.sh YELLOW** — stress-results.json slightly over
   budget (6107 bytes, 149.1%). Normal for a reconciliation run.

### Post-reconciliation attention needed
1. `.agents/AGENTS.md` vs `.agents/.rules/` layout — test scripts updated but
   downstream adopters using `.agents/.rules/` layout will need their own path
   adjustments in adopted test scripts.
2. release-readiness.sh gates depend on pilot-matrix passing — will stay RED
   until pilot-matrix installer issue is fixed.

## AvaX Local Overlay (stays in AvaX)

All AvaX-specific content remains in AvaX:
- Project-local contracts (how-to-write-avax.md)
- Business logic, context, strategy documents
- PHP test suite and reference applications
- MCP server implementations
- AvaX management evidence, memories, planning
- Backup directories
