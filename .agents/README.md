# .agents

This folder is the reusable agent operating system project.

In the `agent-governance` source repository, every file under `.agents/` must
stay agnostic across unrelated projects. Child repos copy this entire tree into
`.agents/.rules/`, then fill the visible `.agents/` scaffold with project-local
workspace files.

## Domains

| Domain | Responsibility | Reusable |
|--------|----------------|----------|
| `governance/` | Architecture rules, execution policy, quality gates, security policy, coding/review/documentation standards, release and rollback policy, and reusable operations contracts | Yes |
| `language-specific/` | Placeholder for child-repo local stack rules when reusable profiles are not enough | Template only |
| `business-logic/` | Placeholder for child-repo domain meaning and product rules | Template only |
| `management/` | Active planning, defects, decisions, timeline policy, risks, evidence, and test records | Yes |
| `review/` | Review logs and archive | Yes |
| `templates/` | Reusable templates for tasking, planning, review, ADR, and DoD | Yes |
| `glossary/` | Shared vocabulary for terms and naming | Yes |
| `onboarding/` | Bootstrap and contributor operating flow | Yes |

## Required Questions

Every idea, plan, architecture decision, and release-impacting change must answer:

1. What outcome should the user or operator achieve?
2. What should the system do to make that outcome reliable?
3. What should be visible at the interface, API, or artifact boundary?
4. How will correctness, risk, and recovery be verified?

## Reading Order

1. `../AGENTS.md`
2. `governance/quality-gates.md`
3. `governance/profile-resolution-algorithm.md`
4. `governance/app-architecture/README.md`
5. `governance/security/README.md`
6. `governance/app-architecture/ARCHITECTURE.md`
7. `business-logic/README.md`
8. `management/README.md`
9. `management/TIMELINE.md`
10. `review/REVIEWS.md`
11. `templates/`

## Governance Index

- `governance/quality-gates.md`
- `governance/profile-resolution-algorithm.md`
- `governance/execution-policy.md`
- `governance/how-to-code-review.md`
- `governance/how-to-strict-review.md`
- `governance/how-to-coding-standards.md`
- `governance/how-to-document-flow.md`
- `governance/how-to-document.md`
- `governance/release-and-rollback-policy.md`
- `governance/security/README.md`
- `governance/security/secure-development-lifecycle.md`
- `governance/security/owasp-web-and-api-baseline.md`
- `governance/security/authentication-and-session-security.md`
- `governance/security/secrets-and-key-management.md`
- `governance/security/ci-cd-and-supply-chain-security.md`
- `governance/security/threat-modeling-and-abuse-case-policy.md`
- `governance/security/vulnerability-and-incident-response.md`
- `governance/operations/README.md`
- `governance/operations/observability-and-error-envelope.md`
- `governance/operations/staging-smoke-checklist.md`
- `governance/operations/security-launch-checklist.md`
- `governance/operations/backup-and-restore-runbook.md`
- `governance/operations/runtime-handoff-contract.md`
- `governance/profiles/README.md`
- `governance/app-architecture/README.md`
- `governance/app-architecture/architecture-standard.md`
- `governance/app-architecture/ARCHITECTURE.md`
- `governance/app-architecture/profiles/README.md`
- `governance/app-architecture/contract-linting.md`
- `governance/app-architecture/execution-profiles.md`
- `governance/app-architecture/migration-governance.md`
- `governance/app-architecture/runtime-hardening.md`

## Rule

- If a rule is not reusable across unrelated repositories, it does not belong in `.agents/`.
- Write outcome first, then technical detail.
- If an item cannot answer the required questions, it is not ready.
- Prefer enforceable contracts and templates over long prose without gates.
- Child repos should declare their applied governance stack in root `AGENTS.md`
  so agents can resolve the correct SDLC lane and profile pack deterministically.
