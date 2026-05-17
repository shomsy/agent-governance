# Framework Project Type Profile

This profile defines reusable engineering guidance for framework/runtime repositories using Agent Harness.

## Required Detail Rules

Load these profile extensions when `framework` is selected:

- `.agents/.rules/governance/profiles/project-types/framework.d/architecture.md`
- `.agents/.rules/governance/profiles/project-types/framework.d/design-components.md`
- `.agents/.rules/governance/profiles/project-types/framework.d/production-readiness.md`
- `.agents/.rules/governance/profiles/project-types/framework.d/security.md`
- `.agents/.rules/governance/profiles/project-types/framework.d/performance.md`
- `.agents/.rules/governance/profiles/project-types/framework.d/unit-test.md`
- `.agents/.rules/governance/profiles/project-types/framework.d/code-review.md`

## Operating Rule

Framework repositories must keep public surfaces small, runtime internals protected, tests behavior-focused, security loud, performance measurable, and architecture simple outside with enterprise-grade rigor underneath.
