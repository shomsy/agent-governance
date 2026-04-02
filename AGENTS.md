# AGENTS.md — Agent Harness Repository Contract

Version: 1.13.0
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
9. `.agents/governance/execution/routing/prompt-to-governance-flow.md`
10. `.agents/governance/execution/hooks/hooks-policy.md`
11. `.agents/governance/execution/approvals/approval-policy.md`
12. `.agents/governance/core/flags/feature-flags.md`
13. `.agents/governance/standards/review/how-to-code-review.md`
14. `.agents/governance/standards/review/how-to-strict-review.md`
15. `.agents/governance/standards/coding/how-to-coding-standards.md`
16. `.agents/governance/standards/coding/naming-standard.md`
17. `.agents/governance/standards/documentation/how-to-document-flow.md`
18. `.agents/governance/standards/documentation/how-to-document.md`
19. `.agents/governance/standards/governance/governance-authoring-standard.md`
20. `.agents/governance/standards/governance/governance-evolution-policy.md`
21. `.agents/governance/delivery/release/release-and-rollback-policy.md`
22. `.agents/governance/intelligence/memory/memory-lifecycle.md`
23. `.agents/governance/skills/contract/skill-contract.md`
24. `.agents/governance/agents/roles/agent-roles.md`
25. `.agents/governance/delivery/workflows/workflow-pipelines.md`
26. `.agents/governance/intelligence/context/context-management.md`
27. `.agents/governance/intelligence/learning/continuous-learning.md`
28. `.agents/governance/intelligence/learning/instincts-policy.md`
29. `.agents/governance/integrations/platforms/platform-compatibility.md`
30. `.agents/governance/integrations/mcp/mcp-integration-policy.md`
31. `.agents/governance/execution/sandbox/sandbox-boundary-policy.md`
32. `.agents/governance/agents/orchestration/society-of-mind-pattern.md`
33. `.agents/governance/delivery/operations/**`
34. `.agents/skills/**` (Reusable Agent Skills)
35. `README.md`
36. `scaffolds/**`

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

## 4) Local Applied Governance Stack

This repository should dogfood its own reusable governance where that improves
the Agent Harness as a portable OS source.

- Repository Kind: `governance source`
- Applied Repository Profile:
  `.agents/governance/profiles/repository-kinds/governance-source.md`
- Primary Surfaces: `.agents/**`, `scaffolds/**`, `install-os.sh`,
  `merge-files.sh`, root documentation, and generated adapters
- Structural Change Ceremony: update precedence, indexes, installer/scaffold
  paths, validation commands, and merged snapshot together
