# PARENT-AGENTS.md — Shared Agent Governance

Version: 1.1.0
Status: Normative / Reusable
Scope: `./**`

This file is the reusable base contract for software projects that want a
consistent agent execution model.

It is intentionally generic. Product names, repository-specific paths, runtime
tools, exact commands, and team lore belong in the adopting repository local
`AGENTS.md`, not here.

## 0) How To Use This File

1. Copy this file into the target repository as `PARENT-AGENTS.md`.
2. Create a local `AGENTS.md` that inherits from it by precedence, not by
   hidden magic.
3. Keep project-specific rules in the local `AGENTS.md`.
4. Keep detailed procedures in `docs/governance/**`.
5. Keep executable truth in scripts, task runners, and automated gates.

## 1) Order Of Precedence

In an adopting repository, agents MUST follow this order:

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

If documents conflict, higher priority wins.
Record unresolved conflict in `TODO.md` or `BUGS.md`.

## 2) Non-Negotiable Rules

1. Execution mode is strict by default: implement and validate; no silent
   redesign.
2. One responsibility, one implementation: duplicate truth is forbidden.
3. Security first: do not weaken runtime, dependency, or secret handling
   without explicit approval.
4. Backlog ownership:
   - planned work belongs in `TODO.md`
   - defects, regressions, and risks belong in `BUGS.md`
5. Evidence is mandatory: no evidence means incomplete work.
6. Production and operator docs must use simple, direct English.
7. DoD = implementation + validation + evidence + backlog update.
8. What can be checked automatically should be enforced by tooling, not only by
   prose.

## 3) Required Local Definitions

Each adopting repository MUST define in its local `AGENTS.md`:

1. canonical validation entrypoint
2. canonical local development entrypoint
3. canonical release or publish entrypoint
4. project-specific architecture boundaries
5. project-specific safety exceptions, if any

These must stay short and stable in the local contract.
Long command details should be moved into scripts, task runners, or gates.

## 4) Delivery Flow

1. Classify the lane.
2. Map the work to the correct backlog file.
3. Implement the minimal safe delta.
4. Run required validation.
5. Record evidence.
6. Update backlog state.
7. Commit and publish unless publication is explicitly blocked.

## 5) Review Contract

Reviews should prioritize:

1. correctness and regressions
2. security and secret handling
3. contract drift
4. missing tests or validation
5. maintainability and clarity

Findings should come first.
If no findings are discovered, say that explicitly and still mention residual
risks or testing gaps.

## 6) Git And Publish Contract

- Commit subject format: `<type>: <simple english summary>`
- Allowed types: `chore`, `release`, `hardening`, `feat`, `fix`, `hotfix`
- Prefer small scoped commits.
- Publish only after validation passes and backlog state is synchronized.

## 7) Navigation Map

- Execution policy: `docs/governance/execution-policy.md`
- Code review: `docs/governance/how-to-code-review.md`
- Coding standards: `docs/governance/how-to-coding-standards.md`
- Documentation standard: `docs/governance/how-to-document.md`
- Release and rollback: `docs/governance/release-and-rollback-policy.md`

## 8) Offload Output Contract

Final user-facing responses must include one short offload note:

- either a short recommendation, or
- `No offload recommended for this step.`
