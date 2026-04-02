# AGENTS.md — Local Project Contract

Version: 1.7.0
Status: Normative / Local
Scope: `./**`

This file is the project-specific child contract.
The reusable `.agents` project is mounted in `.agents/.rules/`.
The mounted copy is the source of reusable rules for the child repo.
The visible `.agents/` folders are the project workspace skeleton.

## 0) Order Of Precedence

Agents MUST follow this order:

1. `AGENTS.md`
2. `.agents/.rules/AGENTS.md`
3. `.agents/.rules/governance/quality-gates.md`
4. `.agents/.rules/governance/profile-resolution-algorithm.md`
5. `.agents/.rules/governance/profiles/**`
6. `.agents/.rules/governance/app-architecture/**`
7. `.agents/.rules/governance/security/**`
8. `.agents/.rules/governance/execution-policy.md`
9. `.agents/.rules/governance/how-to-code-review.md`
10. `.agents/.rules/governance/how-to-strict-review.md`
11. `.agents/.rules/governance/how-to-coding-standards.md`
12. `.agents/.rules/governance/naming-standard.md`
13. `.agents/.rules/governance/how-to-document-flow.md`
14. `.agents/.rules/governance/how-to-document.md`
15. `.agents/.rules/governance/release-and-rollback-policy.md`
16. `.agents/.rules/governance/operations/**`
17. `.agents/management/ACTIVE.md`
18. `.agents/management/TIMELINE.md`
19. `.agents/management/TODO.md`
20. `.agents/management/BUGS.md`
21. `.agents/review/REVIEWS.md`
22. `README.md`
23. `docs/**`

## 1. Local Definitions

Replace this section with project-specific truth:

1. **Canonical Validation Entrypoint**: (e.g., `npm test`, `./verify.sh`)
2. **Canonical Local Development Entrypoint**: (e.g., `npm run dev`)
3. **Canonical Release or Publish Entrypoint**: (e.g., `./publish.sh`)
4. **Project-Specific Architecture Boundaries**: (e.g., `product/`, `system/`)
5. **Applied Governance Stack**:
   - **Delivery Kind**: `web app` | `API` | `worker` | `CLI` | `library` | [replace]
   - **Languages**: `__AGENTS_LANGUAGES__`
   - **Frameworks Or Runtimes**: `__AGENTS_FRAMEWORKS__`
   - **Applied Coding Profiles**: `__AGENTS_CODING_PROFILES__`
   - **Applied Architecture Profiles**: `__AGENTS_ARCH_PROFILES__`
   - **Security Lanes Required**: `__AGENTS_SECURITY_LANES__`
   - **Operations Lanes Required**: `__AGENTS_OPERATIONS_LANES__`
6. **Project Workspace**:
   - `.agents/business-logic/`
   - `.agents/language-specific/`
   - `.agents/management/`
   - `.agents/hooks/`
   - `.agents/review/`
7. **Project-Specific Exceptions or Forbidden Shortcuts**:

Keep this file short. Long procedures belong in governance docs, and active
queues belong in `.agents/management/**`.

---
*No offload recommended for this step.*
