# AGENTS.md — Local Project Contract

Version: 1.0.0
Status: Normative / Local
Scope: `./**`

This file is the project-specific child contract.
The reusable base contract lives in `PARENT-AGENTS.md`.
Detailed procedures live in `docs/governance/**`.

## 0) Order Of Precedence

Agents MUST follow this order:

1. `AGENTS.md`
2. `PARENT-AGENTS.md`
3. `docs/governance/execution-policy.md`
4. `docs/governance/how-to-code-review.md`
5. `docs/governance/how-to-coding-standards.md`
6. `docs/governance/how-to-document.md`
7. `docs/governance/release-and-rollback-policy.md`
8. `TODO.md`
9. `BUGS.md`
10. `README.md`
11. `docs/**`

## 1) Local Definitions

Replace this section with project-specific truth:

1. canonical validation entrypoint
2. canonical local development entrypoint
3. canonical release or publish entrypoint
4. project-specific architecture boundaries
5. project-specific exceptions or forbidden shortcuts

Keep this file short.
Long procedures belong in governance docs.
Long command chains belong in scripts, task runners, or gates.
