# How To Code Review (Node/Express + Frontend + Web Components)

Version: 1.2.0
Status: Normative / Enforced
Scope: `academy/src/**`

This guide defines enterprise-grade system review for MILOS Academy.
It is architecture-first and decision-oriented.

---

## 1) Review Outcome Contract

Review must end with exactly one:

- Keep and Improve
- Redesign
- Rewrite Candidate

If no decision is possible, review is incomplete.

---

## 2) Phase 0 — Context Gate

Collect before findings:

1. System type and lifecycle stage
2. Consumers and runtime context
3. In scope and out of scope
4. Compatibility constraints
5. Security/performance expectations

No context gate means invalid review.

---

## 3) Phase 1 — As-Built Reconstruction

Reconstruct real flow (not intended flow):

`Public API -> domain flow -> runtime effect`

Mandatory outputs:

- primary architecture axis statement
- responsibility map
- mutation points
- failure path map

---

## 4) Phase 2 — Foundational Stress Test

Test whether architecture scales safely.

Questions:

1. Does complexity compound with each feature?
2. Are boundaries enforceable by structure?
3. Are invariants explicit and testable?
4. Are failure modes diagnosable?

---

## 5) Backend Review Checklist (Node/Express)

Mandatory checks:

- `api -> actions -> models -> storage` boundary integrity
- no API-side ORM calls
- no action-side Express/Prisma leakage
- DTO-only external outputs
- deterministic error mapping
- security middleware baseline
- migration discipline in Prisma

---

## 6) Frontend Review Checklist

Mandatory checks:

- canonical flow: SSR -> app boot -> app engine
- no hidden cross-app coupling
- deterministic runtime behavior for lessons/playground
- accessibility baseline (keyboard + aria)
- naming boundary integrity:
  - engine classes: `l-*`, `u-*`
  - app semantics: `academy-*`, `app-*`, `c-*`, `js-*`

---

## 7) Web Components Readiness Checklist

Evaluate candidate promotion to Custom Element only if:

- reused in >=2 pages/apps
- stable interface
- independent lifecycle
- testable in isolation

Required contract checks:

- tag naming (`academy-*`)
- attributes/properties mapping
- `CustomEvent` outputs
- ARIA/keyboard contract
- style scoping (`:host`, CSS vars)

---

## 8) Finding Format (Mandatory)

Each finding must include:

- Symptom
- Root Cause
- Impact
- Evidence
- Risk (Low/Medium/High/Rewrite Risk)

---

## 9) Deliverables

Review output file:

- `academy/docs/governance/Code-Review-And-ToDo/review.md`

Must include:

1. Architecture notes
2. Findings
3. Decision
4. Decision log
5. Next steps

---

## 10) Stability Declaration Contract

To prevent endless review loops, review output MAY include explicit stability state:

- `Not Stable`
- `Stable (Pre-Production)`
- `Production Ready`

`Production Ready` is valid only when ALL are true:

1. No open High / Rewrite Risk findings.
2. Architecture boundary checks pass (`academy:check:contracts`).
3. Full typecheck passes (`academy:typecheck`).
4. Test suite passes (including integration tests when DB-backed paths exist).
5. Migration discipline evidence exists (`prisma/migrations/**` + deploy command).
6. AuthN/AuthZ baseline is enforced on protected API surfaces.
7. CI pipeline executes required gates on pull requests.
8. Production-quality gates pass:
   - `academy:quality` (prod dependency audit),
   - `academy:smoke:runtime` (`/api/health`, `/api/ready`, protected-route auth/tenant checks).

If any condition is missing, stability status MUST NOT be `Production Ready`.

---

## 11) CI-First Review Cadence (Mandatory)

To reduce tool/token cost while keeping rigor:

1. Prefer PR/CI evidence as first review signal.
2. For small scoped changes, run delta review against changed files + CI output.
3. Trigger full-system review only when one of these is true:
   - architecture axis changed,
   - cross-module boundary changed,
   - security model changed,
   - release readiness audit is requested.

Required triage input for failed runs:

1. CI run URL,
2. failed job/step name,
3. failing log excerpt or error signature.

Without this triage input, review turnaround is considered incomplete.
