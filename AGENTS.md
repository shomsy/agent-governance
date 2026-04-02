# AGENTS.md — Agent Harness Repository Contract

Version: 1.11.0
Status: Normative / Local
Scope: `./**`

This repository maintains the reusable shared **Agent Harness** base for other
projects. The canonical reusable contract lives in `.agents/AGENTS.md`.
Deep procedures live in `.agents/governance/**`.

## 0) Order Of Precedence

Agents MUST follow this order in this repository:

1. `AGENTS.md`
2. `.agents/AGENTS.md`
3. `.agents/governance/core/quality/quality-gates.md`
4. `.agents/governance/core/resolution/profile-resolution-algorithm.md`
5. `.agents/governance/profiles/**`
6. `.agents/governance/architecture/**`
7. `.agents/governance/security/**`
8. `.agents/governance/execution/policy/execution-policy.md`
9. `.agents/governance/execution/hooks/hooks-policy.md`
10. `.agents/governance/execution/approvals/approval-policy.md`
11. `.agents/governance/core/flags/feature-flags.md`
12. `.agents/governance/standards/review/how-to-code-review.md`
13. `.agents/governance/standards/review/how-to-strict-review.md`
14. `.agents/governance/standards/coding/how-to-coding-standards.md`
15. `.agents/governance/standards/coding/naming-standard.md`
16. `.agents/governance/standards/documentation/how-to-document-flow.md`
17. `.agents/governance/standards/documentation/how-to-document.md`
18. `.agents/governance/delivery/release/release-and-rollback-policy.md`
19. `.agents/governance/intelligence/memory/memory-lifecycle.md`
20. `.agents/governance/skills/contract/skill-contract.md`
21. `.agents/governance/agents/roles/agent-roles.md`
22. `.agents/governance/delivery/workflows/workflow-pipelines.md`
23. `.agents/governance/intelligence/context/context-management.md`
24. `.agents/governance/intelligence/learning/continuous-learning.md`
25. `.agents/governance/intelligence/learning/instincts-policy.md`
26. `.agents/governance/integrations/platforms/platform-compatibility.md`
27. `.agents/governance/integrations/mcp/mcp-integration-policy.md`
28. `.agents/governance/execution/sandbox/sandbox-boundary-policy.md`
29. `.agents/governance/agents/orchestration/society-of-mind-pattern.md`
30. `.agents/governance/delivery/operations/**`
31. `.agents/skills/**` (Reusable Agent Skills)
32. `README.md`
33. `scaffolds/**`

## 1) Local Rules

1. Keep `.agents/AGENTS.md` generic and reusable across unrelated projects.
2. Do not hardcode product-specific runtime paths, toolchains, or release tools
   into the global contract.
3. If an example is needed, put it in `scaffolds/**` or `README.md`, not in the
   global contract.
4. Keep this repository understandable as a portable OS source:
   - global contract in `.agents/AGENTS.md`
   - local project overrides in `AGENTS.md`
   - specialized rules in `.agents/governance/**`
5. Prefer subtraction over expansion. If a rule can move out of the global and
   still work, move it out.

## 2) Completion Criteria

A change here is complete only when:

1. `.agents/AGENTS.md` remains generic
2. the local repository contract remains short
3. README adoption instructions still match the file layout
4. scaffold files still reflect the documented precedence model

## 3) Offload Output Contract

Final user-facing responses must include one short offload note:

- either a short recommendation, or
- `No offload recommended for this step.`
