# .agents

This folder is the reusable agent operating system scaffold.

In the `agent-governance` source repository, every file under `.agents/` must
stay agnostic across unrelated projects. Child repos may copy this folder and
then fill in the project-local placeholders.

## Domains

| Domain | Responsibility | Reusable |
|--------|----------------|----------|
| `governance/` | Architecture rules, execution policy, quality gates, coding/review/documentation standards, release and rollback policy | Yes |
| `language-specific/` | Placeholder for child-repo local stack rules when reusable profiles are not enough | Template only |
| `business-logic/` | Placeholder for child-repo domain meaning and product rules | Template only |
| `management/` | Active planning, defects, decisions, risks, evidence, and test records | Yes |
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

1. `governance/QUALITY.md`
2. `governance/app-architecture/ARCHITECTURE.md`
3. `business-logic/README.md`
4. `management/README.md`
5. `review/REVIEWS.md`
6. `templates/`

## Governance Index

- `governance/QUALITY.md`
- `governance/execution-policy.md`
- `governance/how-to-code-review.md`
- `governance/how-to-coding-standards.md`
- `governance/how-to-document.md`
- `governance/release-and-rollback-policy.md`
- `governance/profiles/README.md`
- `governance/app-architecture/architecture-standard.md`
- `governance/app-architecture/ARCHITECTURE.md`
- `governance/app-architecture/contract-linting.md`
- `governance/app-architecture/execution-profiles.md`
- `governance/app-architecture/migration-governance.md`
- `governance/app-architecture/runtime-hardening.md`

## Rule

- If a rule is not reusable across unrelated repositories, it does not belong in `.agents/`.
- Write outcome first, then technical detail.
- If an item cannot answer the required questions, it is not ready.
