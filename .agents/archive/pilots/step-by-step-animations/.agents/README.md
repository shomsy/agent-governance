# .agents

This folder is the reusable agent operating system for this repository.

It is designed so most of the structure is portable across projects.
Only `business-logic/` is intentionally project-specific and must be rewritten per domain.

## Domains

| Domain | Responsibility | Reusable |
|--------|----------------|----------|
| `governance/` | Architecture rules, execution policy, quality gates, coding/review/documentation standards, release and rollback policy | Yes |
| `business-logic/` | Product/domain meaning, user value model, software behavior meaning | No |
| `management/` | Active planning, defects, decisions, risks, evidence, and test records | Yes |
| `review/` | Review logs and archive | Yes |
| `templates/` | Reusable templates for tasking, planning, review, ADR, and DoD | Yes |
| `glossary/` | Shared vocabulary for terms and naming | Yes |
| `onboarding/` | Bootstrap and contributor operating flow | Yes |

## Required Questions

Every idea, plan, architecture decision, and lesson change must answer:

1. What does the user want to achieve?
2. What should animator software do to make that possible?
3. What should the user see, and does the UX meet the highest standard?
4. What should the user learn visually and step by step?

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
- `governance/app-architecture/architecture-standard.md`
- `governance/app-architecture/ARCHITECTURE.md`

## Legacy Compatibility

Older paths still in repo history remain readable, but the active canonical paths are:

- `review/` (instead of old `code-review/`)
- `management/TODO.md` and `management/BUGS.md` (instead of deep legacy status files)

## Rule

- Write user outcome first, then technical detail.
- Keep UX and step-by-step learning path explicit.
- If an item cannot answer required questions, it is not ready.
