# Changelog

Summary of completed changes. Details in machine evidence.

## 2026-05-16
- **V3 11/11 READY**: FULL_GREEN_AGENT_HARNESS_V3_11_PLUS_READY.
- Hardened all 7 JSON schemas with deep fields and validation examples.
- Defined explicit Adoption Model and Rules Engine (`.agents/.rules/`).
- Verified all installer modes (upgrade, migrate, validate, dry-run).
- Neutralized MCP/Integrations (opt-in only, no hardcoded secrets).
- Created architecture overlay profiles (vertical-slice, layered, etc.).
- V3 Evidence Model: human dashboard (`EVIDENCE/`) + machine evidence
  (`.agents/management/evidence/`) separation with schema enforcement.
- V3 Management Model: added `CURRENT.md`, `RISKS.md`, `STATUS.md` to
  `.agents/management/`
- Agent bootstrap contract: `.agents/governance/core/bootstrap/agent-bootstrap.md`
- Recursive governance review contract:
  `.agents/governance/standards/review/recursive-review-contract.md`
- Evidence model governance:
  `.agents/governance/standards/documentation/evidence-model.md`
- Management model governance:
  `.agents/governance/delivery/operations/management-model.md`
- Project-type profiles: `web-app`, `library`, `cli`, `api-service`, `monorepo`, `framework`, `infrastructure`
- Updated installer: V3 version-aware engine with dry-run and validation.
- Updated README: V3 adoption docs and order of precedence.

## 2026-03-27

- Initial agnostic kernel refactoring
- Thinned AGENTS.md and wired required questions

## Machine Evidence

- Raw changelog: [`.agents/management/evidence/CHANGELOG.md`](../.agents/management/evidence/CHANGELOG.md)
