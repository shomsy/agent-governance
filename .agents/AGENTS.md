# .agents/AGENTS.md — Global Agent Master Contract

Version: 1.8.0
Status: Normative / Universal
Scope: `./**`

This file is the reusable base contract for any repository that adopts the
`.agents` operating system scaffold.

It must stay generic. Product-specific, team-specific, or repository-specific
rules belong in the adopting repo's root `AGENTS.md` or in child-repo
placeholders after installation.

## 0) Order Of Precedence (Universal Model)

In any project using the `.agents` OS, agents MUST follow this order:

1. **`AGENTS.md`** (project-specific local overrides)
2. **`.agents/AGENTS.md`** (this file - global shared rules)
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
17. `.agents/management/TODO.md` | `.agents/management/BUGS.md`
18. `README.md`

## 1) Agent OS Repository Structure

Any project using this OS is divided into specialized domains within the
`.agents/` folder:

| Domain | Responsibility | Reusable |
|:---|:---|:---|
| **`governance/`** | Agnostic quality gates, architecture rules, execution policy, standards, and reusable operations contracts. | **Yes** |
| **`business-logic/`** | Placeholder for child-repo domain behavior and product-specific rules. | Template only |
| **`language-specific/`** | Placeholder for child-repo local stack rules when reusable profiles are insufficient. | Template only |
| **`management/`** | Active planning, task tracking, and delivery evidence. | **Yes** |
| **`templates/`** | Standardized blueprints for reviews, planning, and ADRs. | **Yes** |
| **`review/`** | Canonical review findings and archive. | **Yes** |
| **`glossary/`** | Shared vocabulary, naming dictionaries, and term definitions. | **Yes** |
| **`onboarding/`** | Guided flows for safe project adoption and contributor entry. | **Yes** |

## 2) Non-Negotiable Rules (Shared)

1. **Execution mode is strict by default**: implement and validate; no silent redesign.
2. **One responsibility, one implementation**: duplicate truth is forbidden.
3. **Security first**: do not weaken runtime, dependency, or secret handling.
4. **Backlog ownership**: all tasks belong in `.agents/management/TODO.md` or `.agents/management/BUGS.md` with timestamped status updates.
5. **Evidence is mandatory and timestamped**: no evidence means incomplete work.
6. **DoD = implementation + validation + evidence + backlog update + ceremony.**
7. **What can be automated MUST be automated or gated.**
8. **Production-ready claims require proof**: review, validation, rollback, and operational evidence must agree.

## 3) Common Operating Flow

1. Classify the task lane.
2. Resolve the governance stack and profile pack.
3. Map it to the correct queue.
4. Implement the minimal safe delta.
5. Run validation.
6. Record evidence.
7. Perform the completion ceremony required by the adopting repository.

## 4) Required Project Definitions (Must Be In Root `AGENTS.md`)

Each adopting repository MUST specify:

1. canonical validation entrypoint
2. canonical local development entrypoint
3. canonical release or publish entrypoint
4. project-specific architecture boundaries
5. applied governance stack: languages, frameworks, architecture overlays, and
   required SDLC lanes
