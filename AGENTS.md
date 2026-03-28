# AGENTS.md — agent-governance Repository Contract

Version: 1.6.0
Status: Normative / Local
Scope: `./**`

This repository maintains the reusable shared governance base for other
projects. The canonical reusable contract lives in `.agents/AGENTS.md`.
Deep procedures live in `.agents/governance/**`.

## 0) Order Of Precedence

Agents MUST follow this order in this repository:

1. `AGENTS.md`
2. `.agents/AGENTS.md`
3. `.agents/governance/quality-gates.md`
4. `.agents/governance/profile-resolution-algorithm.md`
5. `.agents/governance/profiles/**`
6. `.agents/governance/app-architecture/**`
7. `.agents/governance/security/**`
8. `.agents/governance/execution-policy.md`
9. `.agents/governance/how-to-code-review.md`
10. `.agents/governance/how-to-strict-review.md`
11. `.agents/governance/how-to-coding-standards.md`
12. `.agents/governance/naming-standard.md`
13. `.agents/governance/how-to-document-flow.md`
14. `.agents/governance/how-to-document.md`
15. `.agents/governance/release-and-rollback-policy.md`
16. `.agents/governance/operations/**`
17. `README.md`
18. `scaffolds/**`

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
