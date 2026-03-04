# AGENTS.md — Governance Template

Version: 1.0.0
Status: Normative / Reusable
Scope: `./**`

This file is the short operational contract.
Deep procedures live in `docs/governance/**`.

## 0) Order Of Precedence

Agents MUST follow this order:

1. `AGENTS.md`
2. `docs/governance/execution-policy.md`
3. `docs/governance/how-to-code-review.md`
4. `docs/governance/how-to-coding-standards.md`
5. `docs/governance/how-to-document.md`
6. `docs/governance/release-and-rollback-policy.md`
7. `TODO.md`
8. `BUGS.md`
9. `README.md`
10. `docs/**`

If documents conflict, higher priority wins.
Record unresolved conflict in `TODO.md` or `BUGS.md`.

## 1) Non-Negotiable Rules

1. Execution mode is strict: implement and validate; no stealth redesign.
2. One responsibility, one implementation: duplicate truth is forbidden.
3. Security first: do not weaken runtime or secret handling without explicit approval.
4. Backlog ownership:
   - planned work belongs in `TODO.md`
   - defects, regressions, and risks belong in `BUGS.md`
5. Evidence is mandatory: no evidence means incomplete work.
6. Production docs must use simple English.
7. DoD = implementation + validation + evidence + backlog update.

## 2) Canonical Commands

Each adopting repository MUST define:

- the canonical validation entrypoint
- the canonical release entrypoint
- the canonical local development entrypoint

Those commands must be documented in the adopting repository `README.md`.

## 3) Delivery Flow

1. Classify lane.
2. Map to the correct backlog file.
3. Implement the minimal safe delta.
4. Run required validation.
5. Record evidence.
6. Update backlog state.
7. Commit and publish unless publication is explicitly blocked.

## 4) Git And Publish Contract

- Commit subject format: `<type>: <simple english summary>`
- Allowed types: `chore`, `release`, `hardening`, `feat`, `fix`, `hotfix`
- Prefer small scoped commits.
- Publish only after the change is validated and the backlog is in sync.

## 5) Navigation Map

- Execution policy: `docs/governance/execution-policy.md`
- Code review: `docs/governance/how-to-code-review.md`
- Coding standards: `docs/governance/how-to-coding-standards.md`
- Documentation standard: `docs/governance/how-to-document.md`
- Release and rollback: `docs/governance/release-and-rollback-policy.md`

## 6) Offload Output Contract

Final user-facing responses must include one short offload note:

- either a short recommendation, or
- `No offload recommended for this step.`
