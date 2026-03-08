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
2. `PARENT-AGENTS.md`
3. `docs/governance/execution-policy.md`
4. `docs/governance/how-to-code-review.md`
5. `docs/governance/how-to-coding-standards.md`
6. `docs/governance/how-to-document.md`
7. `docs/governance/release-and-rollback-policy.md`
8. `README.md`
9. `scaffolds/**`

## 1) Local Rules

1. Keep `PARENT-AGENTS.md` generic and reusable across unrelated projects.
2. Do not hardcode product-specific runtime paths, toolchains, or release tools
   into the parent contract.
3. If an example is needed, put it in `scaffolds/**` or `README.md`, not in the
   parent contract.
4. Keep this repository understandable as a copy source:
   - parent contract in `PARENT-AGENTS.md`
   - local child example in `scaffolds/AGENTS.md`
   - reusable deep rules in `docs/governance/**`
5. Prefer subtraction over expansion. If a rule can move out of the parent and
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
