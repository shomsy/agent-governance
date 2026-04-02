# AGENTS.md — Local Project Contract

Version: 1.8.0
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
3. `.agents/.rules/governance/core/quality/quality-gates.md`
4. `.agents/.rules/governance/core/resolution/profile-resolution-algorithm.md`
5. `.agents/.rules/governance/profiles/**`
6. `.agents/.rules/governance/architecture/**`
7. `.agents/.rules/governance/security/**`
8. `.agents/.rules/governance/execution/policy/execution-policy.md`
9. `.agents/.rules/governance/execution/hooks/hooks-policy.md`
10. `.agents/.rules/governance/execution/approvals/approval-policy.md`
11. `.agents/.rules/governance/core/flags/feature-flags.md`
12. `.agents/.rules/governance/standards/review/how-to-code-review.md`
13. `.agents/.rules/governance/standards/review/how-to-strict-review.md`
14. `.agents/.rules/governance/standards/coding/how-to-coding-standards.md`
15. `.agents/.rules/governance/standards/coding/naming-standard.md`
16. `.agents/.rules/governance/standards/documentation/how-to-document-flow.md`
17. `.agents/.rules/governance/standards/documentation/how-to-document.md`
18. `.agents/.rules/governance/delivery/release/release-and-rollback-policy.md`
19. `.agents/.rules/governance/intelligence/memory/memory-lifecycle.md`
20. `.agents/.rules/governance/skills/contract/skill-contract.md`
21. `.agents/.rules/governance/agents/roles/agent-roles.md`
22. `.agents/.rules/governance/delivery/workflows/workflow-pipelines.md`
23. `.agents/.rules/governance/intelligence/context/context-management.md`
24. `.agents/.rules/governance/intelligence/learning/continuous-learning.md`
25. `.agents/.rules/governance/intelligence/learning/instincts-policy.md`
26. `.agents/.rules/governance/integrations/platforms/platform-compatibility.md`
27. `.agents/.rules/governance/integrations/mcp/mcp-integration-policy.md`
28. `.agents/.rules/governance/execution/sandbox/sandbox-boundary-policy.md`
29. `.agents/.rules/governance/agents/orchestration/society-of-mind-pattern.md`
30. `.agents/.rules/governance/delivery/operations/**`
31. `.agents/skills/**`
32. `.agents/management/ACTIVE.md`
33. `.agents/management/TIMELINE.md`
34. `.agents/management/TODO.md`
35. `.agents/management/BUGS.md`
36. `.agents/review/REVIEWS.md`
37. `README.md`
38. `docs/**`

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
