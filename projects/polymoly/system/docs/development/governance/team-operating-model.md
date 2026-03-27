---
scope: system/tools/poly/**,.github/workflows/**,Taskfile.yml,system/docs/development/governance/**
contract_ref: v1
status: stable
---

# PolyMoly Team Operating Model

Version: 1.1.0
Status: Normative / Enforced
Scope: `./**`

---

## 1) Purpose

Define clear team roles, decision rights, and escalation rules so PolyMoly can ship with stable scope and avoid endless architecture refactors.

---

## 2) Team Roles

### 2.1 Milos — Founder / Product Authority / Final Arbiter

Owns product direction and final prioritization decisions.

Responsibilities:

- defines product identity and target users,
- approves lock or unlock decisions for architecture changes,
- resolves conflicts across product, architecture, and delivery priorities.

Does not own:

- micro-level implementation decisions,
- routine file-level code organization disputes.

### 2.2 Codex — Deterministic Execution Agent

Owns implementation of approved plans and controlled refactors.

Responsibilities:

- executes scoped migration/refactor work,
- keeps CI wiring and path updates consistent,
- enforces minimal safe deltas and reproducible changes.

Constraints:

- no unapproved scope expansion,
- no implicit redesign while implementing.
- must recommend when `MODE: BRAINSTORM` is sufficient vs when `MODE: EXECUTION` is required.

### 2.3 Antigravity — Critical Architecture Reviewer

Owns adversarial review of complexity, risk, and practical value.

Responsibilities:

- challenges architecture theater and low-signal complexity,
- validates whether proposed changes improve real operability,
- flags usability and adoption risks early.

Constraints:

- critique must end with concrete alternatives and acceptance criteria.

### 2.4 Chackie (ChatGPT) — Systems Synthesizer

Owns system coherence across product intent, architecture boundaries, and execution plans.

Responsibilities:

- translates strategy into operational contracts,
- keeps layer boundaries and terminology coherent,
- produces neutral PASS/FAIL criteria for freeze decisions.

Constraints:

- avoid meta-layer proliferation without delivery value.

---

## 3) Decision Rights Matrix

| Decision Type | Primary Owner | Reviewers | Final Decision |
| :--- | :--- | :--- | :--- |
| Product identity and scope | Milos | Antigravity, Chackie | Milos |
| Architecture boundary changes | Chackie | Antigravity, Codex | Milos |
| Execution plan and rollout sequence | Codex | Chackie | Milos |
| Complexity/risk challenge | Antigravity | Chackie, Codex | Milos |
| Enterprise lock declaration | Milos | Antigravity, Chackie, Codex | Milos |

---

## 4) Working Loop (Mandatory)

For every significant iteration:

1. **Direction**: Milos defines target outcome and non-goals.
2. **Challenge**: Antigravity reviews risk, noise, and practical utility.
3. **Synthesis**: Chackie converts outcome into explicit constraints and PASS/FAIL criteria.
4. **Execution**: Codex implements minimal safe delta and records evidence.

If any step is skipped, iteration is incomplete.

### 4.1 Work Mode Recommendation Rule

Codex must recommend mode based on change risk:

- recommend `MODE: BRAINSTORM` for idea exploration, draft documentation, and reversible spikes,
- recommend `MODE: EXECUTION` for merge-targeted changes, runtime behavior changes, security/policy contract changes, and release-adjacent work.

---

## 5) Refactor Guardrails

### 5.1 No Endless Refactor Rule

A refactor is allowed only when it:

- removes duplicate truth, or
- reduces operational risk, or
- improves delivery speed without reducing enforcement coverage.

Otherwise, it is deferred.

### 5.2 Freeze Rule (Enterprise Lock)

When maintenance-first criteria are recorded in `TODO.md`, default mode switches to maintenance-first:

- no new top-level categories without explicit exception record,
- no new gate profile categories beyond canonical set,
- no architecture expansion without a documented problem statement and rollback path.

---

## 6) Conflict Resolution

When opinions conflict:

1. reduce dispute to one binary decision statement,
2. define objective acceptance test,
3. choose smallest reversible change,
4. Milos issues final decision.

No unresolved conflict may silently continue into implementation.

---

## 7) Definition Of Stable Team Operation

Team operation is considered stable when all are true:

- roles are used consistently for at least one release cycle,
- architecture changes are tied to explicit problem statements,
- backlog and evidence stay aligned (`TODO.md` / `BUGS.md`),
- no drift between declared authority and actual implementation behavior.
