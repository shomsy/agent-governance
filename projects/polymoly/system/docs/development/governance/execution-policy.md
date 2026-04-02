---
scope: system/tools/poly/**,.github/workflows/**,Taskfile.yml,system/docs/development/governance/**
contract_ref: v1
status: stable
---

Shared baseline: `system/docs/development/governance/shared/agent-harness/execution-policy.md`
Upstream source: `system/docs/development/governance/upstream-source.lock.json`
Local role: PolyMoly-specific execution overlay and stricter local contract

# PolyMoly Execution Policy

Version: 1.2.1
Status: Normative / Enforced
Scope: `./**`

---

## 1) Purpose

Define strict transition from review to execution and prevent:

- endless re-analysis,
- scope drift,
- stealth architecture changes,
- undocumented deviations.

---

## 2) Review Closure Rule

A review is closed only when all are true:

1. final decision recorded (`Keep and Improve`, `Redesign`, `Rewrite Candidate`),
2. findings listed,
3. next steps defined,
4. backlog target set (`TODO.md` or `BUGS.md`).

After closure, execution mode is mandatory.

---

## 3) Work Mode Declaration

### 3.1 Execution Mode (`MODE: EXECUTION`, default)

Execution mode means:

- implementation is expected,
- approved direction is fixed,
- scope is enforceable.

Rules:

- each pass must leave runnable/valid state (unless docs-only),
- no silent redesign,
- no unapproved scope expansion.

### 3.2 Brainstorm Mode (`MODE: BRAINSTORM`, explicit opt-in)

Brainstorm mode is a speed path for idea exploration and draft preparation.

Allowed behavior:

- fast docs or code spike edits,
- skip full gate run,
- skip commit/push,
- skip backlog evidence updates in the same pass.

Hard limits:

- no claim of DoD-complete delivery,
- no release/promotion execution,
- no hidden scope migration presented as final.

### 3.3 Promotion Triggers (Must Switch To Execution Mode)

Switch to `MODE: EXECUTION` before completion when any is true:

1. change is intended for merge/release,
2. runtime behavior changes in `core/`, `platform/`, `features/`, or `system/tools/poly/`,
3. security/policy/contract boundaries are modified,
4. irreversible operations are requested.

---

## 4) Iteration Contract (Mandatory)

Each iteration must declare:

1. primary goal,
2. non-goals,
3. constraints,
4. completion criteria,
5. lane (`runtime-hardening`, `platform-feature`, `observability`, `release-engineering`, `configurator`).

---

## 5) Scope Discipline

- New findings may be recorded.
- Unapproved findings must not be implemented in the same pass.
- Scope changes require explicit approval before coding.

### 5.1 Structural Migration Rule

When a repository restructuring wave is active:

- planned moves must be driven by a canonical manifest, not ad-hoc shell moves,
- `poly migrate placement` is the default move planner and apply assistant,
- `poly migrate rewrite` is the default targeted rewrite assistant for path churn,
- broad path rewrites must prefer manifest-driven automation over manual search/replace,
- compatibility shims are allowed only when they are explicit, reviewable, and time-boxed,
- gate failures caused by stale compatibility references must be fixed before the stage can be called complete.

---

## 6) TODO Closure Loop

Every TODO item must carry an explicit closure loop:

1. intake defines acceptance criteria, touched scope, expected gates, and the
   production-claim boundary,
2. implementation delivers the minimal safe delta,
3. AGENTS-driven delta review runs against the touched scope,
4. findings are fixed and the review repeats until no open `high`/`critical`
   findings remain in that TODO scope,
5. a full-system review is mandatory when architecture, security, release,
   governance, cross-lane behavior, or `production ready` surfaces move,
6. the item closes only after gates are green, the review pack exists,
   evidence is recorded, and any residual `medium`/`low` findings are mapped
   forward into `BUGS.md` or a follow-up `TODO.md` item.

## 7) Docs-Only Execution Mode

When iteration is docs-only:

- runtime code changes are forbidden unless explicitly approved,
- docs links/consistency must be validated,
- evidence must be logged.

---

## 8) Evidence Requirements

Every completed iteration in `MODE: EXECUTION` must include:

1. changed file list,
2. executed gates + results,
3. backlog status update,
4. evidence update in `TODO.md` or `BUGS.md` evidence section.

If evidence is missing, iteration is incomplete.

Brainstorm iterations are not canonical completion records.

---

## 9) Enforcement

Violations:

- implementation outside approved scope,
- stealth migration,
- missing system/gates/evidence,
- backlog mismatch (`TODO.md` vs `BUGS.md`),
- closing a TODO before the review loop converges.
- reporting brainstorm output as DoD-complete execution output.

Violation invalidates iteration output.
