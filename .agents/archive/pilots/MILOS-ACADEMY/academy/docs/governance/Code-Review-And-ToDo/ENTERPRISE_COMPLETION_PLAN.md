# MILOS Academy Enterprise Completion Plan

Version: 1.2.0  
Status: Completed (Docker Handoff Deferred Externally)  
Scope: `academy/**`

## Goal
Finish MILOS Academy as a production-ready Node/Express + Postgres application with stable frontend runtime, strict governance, and operational readiness.

## Current Step (Completed in this iteration)
- Policy pack persistence moved to Postgres with tenant-active mapping.
- Operational docs delivered (deploy/rollback, backup/restore, smoke, observability, security, container handoff contract).
- `.env.example` delivered for runtime/env contract portability.

## Execution Phases

### Phase P0 (Critical - Production blockers)
1. Frontend TypeScript stabilization
   - Remove emergency `@ts-nocheck` gradually and restore strict typing module-by-module.
   - Prioritize `lessons/engine` and `playground/assets`.
2. Database migration discipline
   - Add Prisma migrations folder and baseline migration.
   - Add repeatable local bootstrap sequence (`migrate deploy` + seed strategy if needed).
3. AuthN/AuthZ baseline
   - Introduce auth module skeleton (`auth/api|actions|models|storage`).
   - Add role/permission checks for CMS and policy endpoints.
4. Tenant isolation proof
   - Add integration tests for cross-tenant read/write isolation in users/cms flows.

### Phase P1 (Enterprise readiness)
1. CI pipeline
   - Add GitHub Actions workflow:
     - architecture contracts check
     - domain typecheck
     - tests
     - runtime doctor
2. Observability contract
   - Add machine-readable error envelope documentation.
   - Add requestId + tenantId tracing in operational docs.
3. Policy pack persistence
   - Move policy storage from in-memory to database.
   - Version policy packs and map active policy per tenant.

### Phase P2 (Operational hardening)
1. Deployment profile
   - Add Dockerfile and production start profile. (Deferred: maintained in external central docker stack)
   - Add `.env.example` with secure defaults and required variables.
2. Security operations
   - Document CSRF strategy (cookie/session mode vs token mode).
   - Add security checklist for production launch.
3. Disaster recovery basics
   - Backup/restore runbook for Postgres.
   - Recovery verification checklist.

## Acceptance Criteria
1. `academy:check:contracts` passes.
2. `academy:typecheck` passes without global suppression strategy.
3. `academy:test` passes with tenant integration coverage.
4. Prisma migrations are versioned and reproducible.
5. CI workflow executes required gates on pull requests.
6. Auth/RBAC and policy persistence are documented and implemented.
7. Runbooks exist for deploy and DB recovery.

## Out of Scope (for this plan document)
- Redesign of lesson UX flows.
- Visual redesign/theme overhaul.
- Major rewrite of simulator behavior.

## Tracking
- Primary evidence log: `academy/docs/governance/Code-Review-And-ToDo/review.md`
- This plan file is the execution roadmap source for upcoming iterations.

---

## Execution Update (2026-02-25)

Completed in phased execution:

1. **Phase 1**
- Migration discipline implemented (baseline migration + deploy command).
- Integration tenant isolation tests added.

2. **Phase 2**
- AuthN/AuthZ baseline implemented for CMS and Policy APIs.
- Frontend auth + protected API console added in Campus app.
- `@ts-nocheck` removed from first targeted frontend runtime subset.

3. **Final CI Phase**
- Added GitHub Actions workflow with Postgres-backed validation gates.

---

## Stability Gate Note (2026-02-25)

Current declared product state:

- Production Ready

Promotion to `Production Ready` follows the governance contract in:

- `academy/docs/governance/how-to-code-review.md` (Stability Declaration Contract)

Promotion evidence captured:

1. No open High/Rewrite findings.
2. CI workflow green on PR/main with Postgres-backed gate execution:
   - https://github.com/shomsy/MILOS-ACADEMY/actions/runs/22397741221
3. Integration DB checks executed in CI context.

---

## Delta Update (2026-02-25, Production Gate)

Closed in this pass:

1. CI dependency supply-chain blocker
- Root cause: lockfile resolved `@milos/layout-os` via SSH (`git@github.com`) and failed on GitHub runner.
- Fix: vendored `@milos/layout-os` to `academy/vendor/layout-os` and switched dependency to `file:academy/vendor/layout-os`.

2. Integration test destructive reset safety
- Added explicit env guard: `ACADEMY_INTEGRATION_DB_RESET=true` required before table reset in integration tests.
- CI workflow now sets this flag for controlled reset in dedicated CI Postgres service.

3. Local CI parity
- `academy:ci` now mirrors required gate sequence (`prisma:generate`, contracts, full typecheck, tests, build runtime, doctor).
- Test execution is now shell-agnostic via `academy/scripts/run-tests.mjs` (avoids Linux glob expansion drift).

4. Production quality hardening gates
- Added auth hardening path with `AUTH_MODE=static|jwt|hybrid` and JWT expiry/revocation support.
- Added DB-backed readiness endpoint `/api/ready`.
- Added mandatory quality/runtime scripts:
  - `academy:quality`
  - `academy:smoke:runtime`
- CI now executes quality audit and runtime HTTP smoke on release path.

Post-production improvement queue (non-blocking):

1. Execute first real backup/restore drill and attach evidence run.
2. Keep security checklist and smoke checklist attached to every release PR.
3. Complete Docker handoff in central stack and re-validate this runtime contract there.

---

## Operating Model (Mandatory, 2026-02-25)

1. Work branches: `feature/*` from `development`.
2. Integration path: `feature/* -> development` only via PR + green `Academy CI`.
3. Release path: `development -> main` only via PR + green `Academy CI`.
4. Triage mode: CI log/link first, local deep reruns only when CI signal is insufficient.

## Deferred Scope (Owner-Approved)

1. Dockerfile/container build profile in this repository.
2. Local Docker orchestration for this repository.

These are intentionally deferred because container lifecycle is being centralized in external Docker stack.
