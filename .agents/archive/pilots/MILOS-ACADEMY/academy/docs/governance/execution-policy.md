# ARCHITECTURE EXECUTION POLICY

Version: 1.3.0
Status: Normative / Enforced
Scope: `academy/**`

---

## 1. Purpose

Define mandatory transition from architecture review to execution.
Eliminate ambiguity between review mode and implementation mode.

This policy prevents:

- endless re-analysis,
- scope drift disguised as clarification,
- architecture backtracking during implementation,
- silent design changes without accountability.

---

## 2. Review Closure Rule

A review is closed only when all are true:

- final decision recorded (`Keep and Improve`, `Redesign`, `Rewrite Candidate`),
- findings listed,
- next steps defined,
- system marked viable for evolution.

After closure, review becomes historical context unless explicitly reopened.

---

## 3. Execution Mode Declaration (Critical)

After closure, project enters Execution Mode.

Execution Mode means:

- implementation is expected,
- agreed direction is fixed,
- iteration scope is enforceable.

Rules:

- each pass must leave a compilable/runnable system unless pass is docs-only by contract,
- rollback is not default,
- rollback requires explicit pre-pass agreement.

---

## 4. Docs Execution Mode (Mandatory Addendum)

When iteration goal is governance/documentation:

- only doc-level scope changes are allowed,
- runtime code changes are forbidden unless explicitly approved in scope.

Docs Execution completion requires:

1. impacted docs updated,
2. cross-link integrity verified,
3. evidence logged (decisions and acceptance status),
4. no unintended runtime code deltas.

---

## 5. Iteration Contract (Mandatory)

Each iteration must define:

1. one primary goal (max two if tightly coupled),
2. non-goals,
3. constraints,
4. completion criteria.

Iteration variants for this repository:

- backend-only iteration,
- frontend-only iteration,
- cross-layer iteration,
- docs-only iteration.

Variant must be declared before implementation.

---

## 6. Scope Discipline Rule

During an iteration:

- new findings may be recorded,
- unapproved findings must not be implemented.

Scope changes require explicit approval before coding.

---

## 7. No Stealth Migration Rule

Web Components migration must never be implicit.

Forbidden:

- hidden extraction of page logic into custom elements without scope declaration,
- introducing component contracts without documented migration intent.

Required:

- explicit migration scope in iteration contract,
- declared affected files and acceptance criteria.

---

## 8. Ownership and Authority

- architecture direction is fixed by review + policy,
- implementation details are owned by implementer within approved scope,
- deviations must be proposed explicitly.

Disagreement is allowed; unilateral deviation is not.

---

## 9. Evidence Requirements (Mandatory)

Each completed iteration must include:

1. impacted file list,
2. before/after decision log summary,
3. acceptance checklist status,
4. executed validation commands and outcome.

If evidence is missing, iteration is incomplete.

---

## 10. Applicability

Applies to all architecture reviews, refactors, follow-up implementation requests, and governance updates in MILOS Academy.

---

## 11. Enforcement

Process violations include:

- restarting analysis during execution without approval,
- expanding scope mid-iteration,
- stealth architectural migration,
- proceeding without iteration contract.

Process violations invalidate iteration output.

---

## 12. Final Principle

> Review decides direction.  
> Execution delivers change.  
> Documentation preserves intent.

---

## 13. Branch and Merge Discipline (Mandatory)

Execution must follow branch contract:

1. Base branch for implementation: `development`.
2. Implementation branch naming: `feature/*` (or `hotfix/*` for emergency production fixes).
3. Merge to `main` only through PR from `development` (or approved `hotfix/*` path).
4. Direct push to `main` is forbidden under normal execution flow.

Hotfix exception:

1. `hotfix/*` branches start from `main`,
2. merge to `main` with green CI,
3. mandatory back-merge into `development`.

---

## 14. CI-First Validation Policy (Mandatory)

To control cost/time while preserving release quality:

1. CI is primary source of merge validation.
2. Local runs should be scoped to changed surface area.
3. Re-running full local suites without change in scope is discouraged.
4. Failure triage starts from CI failed job logs and run URL.

Minimum evidence before merge:

1. branch/PR path follows Section 13,
2. required CI workflow(s) are green for the branch tip,
3. production-quality gates are green for release path (`academy:quality`, `academy:smoke:runtime`),
4. failure-to-fix trace is recorded in `review.md` when relevant.
