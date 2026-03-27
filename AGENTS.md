# AGENTS.md — agent-governance Repository Contract

Version: 1.1.0
Status: Normative / Local
Scope: `./**`

This repository maintains the reusable shared governance base for other
projects. The canonical reusable contract lives in `PARENT-AGENTS.md`.
Deep procedures live in `docs/governance/**`.

## 0) Order Of Precedence

Agents MUST follow this order in this repository:

1. `AGENTS.md`
2. `.agents/AGENTS.md`
3. `.agents/governance/quality-gates.md`
4. `.agents/governance/execution-policy.md`
5. `.agents/governance/how-to-code-review.md`
6. `.agents/governance/how-to-coding-standards.md`
7. `.agents/governance/naming-standard.md`
8. `.agents/governance/how-to-document.md`
9. `.agents/governance/release-and-rollback-policy.md`
10. `README.md`
11. `scaffolds/**`

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

1. the parent contract remains generic
2. the local repository contract remains short
3. README adoption instructions still match the file layout
4. scaffold files still reflect the documented precedence model

## 3) Offload Output Contract

Final user-facing responses must include one short offload note:

- either a short recommendation, or
- `No offload recommended for this step.`
