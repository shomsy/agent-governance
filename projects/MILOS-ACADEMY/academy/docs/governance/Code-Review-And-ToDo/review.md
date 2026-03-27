# Enterprise-Grade Code Review: MILOS Academy CMS (Standalone v1)

> Legacy note: this document captures historical findings from pre-extraction `lab/*` phase.
> Canonical runtime/source paths are now `academy/src/**` and canonical routes (`/classroom/lesson/*`, `/playground/challenge`).

## Status: Closed

---

## 1. ARCHITECTURE NOTES

### 1.1 Actual Execution Flow (As-Built)

`HTTP GET/POST /api/cms/lessons -> Express Router (api.mjs) -> fs.readFile/writeFile -> lessons.json`

**Explanation:**
This is how the system actually works:
The system currently operates as a thin CRUD wrapper around a flat JSON file. State is created and mutated via direct filesystem writes in the API handlers. Decisions about lesson availability or property updates are handled synchronously after reading the entire data set into memory.

### 1.2 Central Abstraction Identification

- **Primary Axis:** "File-based Persistence" ( फंडामेंटली organized around JSON data manipulation).
- **Secondary Axis:** "Virtual Routing" (Hardcoded map in `server.mjs`).

### 1.3 Central Abstraction Stress Test

- **Classification:** 🚨 Fail
- **Justification:** The primary axis (JSON file) cannot support the mandatory "Multi-tenancy" and "Enterprise Security" requirements defined in `AGENTS.md`. It accumulates responsibility for all content and all access control without structural isolation.

### 1.4 Responsibility and Boundary Mapping

| Component | Orchestrates | Executes | Holds State | Notes |
| --- | --- | --- | --- | --- |
| server.mjs | Middleware/Static | Route Aliasing | No | Mixes static assets and virtual routes |
| api.mjs | Request Parsing | JSON CRUD | No | Direct fs access leaks infra into app layer |
| lessons.json | No | No | Yes | Single source of truth (Global) |
| dashboard.html | UI Layout | AJAX Logic | Client-side only | Contains inline styles/logic |

**Summary:** Responsibility boundaries are **stressed**. The API layer is tightly coupled to the filesystem, and the server mixes product routes with infrastructure setup.

---

## 2. FINDINGS

### Finding 1: Security Baseline Violation (OWASP)

- **Symptom:** Missing Helmet, Rate Limiting, and Input Validation.
- **Root Cause:** Intentional prototype speed.
- **Impact:** Vulnerable to brute-force and malicious payloads.
- **Evidence:** `lab/server.mjs` lines 22-25.
- **Risk Level:** High

### Finding 2: Two Sources of Truth for Routing

- **Symptom:** `CLASSROOM_ROUTES` in `server.mjs` duplicates info from `lessons.json`.
- **Root Cause:** Legacy migration debt.
- **Impact:** Cognitive load; changing a lesson may require editing code and data.
- **Evidence:** `lab/server.mjs` lines 34-49.
- **Risk Level:** Medium

### Finding 3: Missing Multi-tenancy Isolation

- **Symptom:** No `tenant_id` context in any API call.
- **Root Cause:** System designed as single-user local lab.
- **Impact:** Total failure for "Academy-as-a-Service" goal.
- **Evidence:** `lab/app/cms/api.mjs:router.get('/lessons')`.
- **Risk Level:** High (Rewrite Risk for Data Layer)

### Finding 4: Inline Style/Logic Violation

- **Symptom:** Dashboard contains massive `<style>` block and inline `onclick`.
- **Root Cause:** Rapid prototyping.
- **Impact:** Hard violation of `AGENTS.md` Section 8.1.
- **Evidence:** `lab/app/cms/dashboard.html`.
- **Risk Level:** Medium

---

## 3. FINAL DECISION

Select exactly one: **⚠️ Redesign**

### Justification

The system is fundamentally sound in its **Core Intent** (lessons served via Express), but the **Primary Axis (Data Layer)** must be redesigned from a flat JSON file to a relational Postgres model to support mandatory multi-tenancy and enterprise security (Findings 1 & 3). The frontend `dashboard.html` requires a refactor to move logic/styles into feature-sliced modules to comply with `AGENTS.md` (Finding 4).

---

## 4. NEXT STEPS (Action-Oriented)

### 4.1 Constraints

- API MUST maintain compatibility with current lesson JSON structure during transition.
- Database MUST use the schema defined in `schema.sql`.
- CSRF and Rate Limiting MUST be present before the next major release.

### 4.2 First 3 Concrete Actions

1. **Security Hardening**: Move `server.mjs` to include Helmet, Rate Limiter, and extract `api.mjs` validation into Zod schemas.
2. **Postgres Integration**: Swap `fs` operations in `api.mjs` for a Postgres service layer (Multi-tenant ready).
3. **Dashboard Decoupling**: Extract CSS to `cms-dashboard.css` and JS to `cms-dashboard.js` (following feature-sliced module rules).

---

## 5. DECISIONS LOG

### Decision: Redesign Data Layer to Postgres

- **Date:** 2026-02-22
- **Context:** Transitioning from individual Lab to Corporate LMS.
- **Decision:** Stop using `lessons.json` for persistence; implement Postgres with `tenant_id` filters.
- **Alternatives:** Keeping JSON and adding folders per tenant (Rejected: doesn't scale for enterprise).
- **Consequences:** Higher infrastructure requirement but enables true "LMS as a Service".

---

## 6. FOLLOW-UP REMEDIATION (2026-02-24)

Implemented hardening and governance cleanup based on AGENTS-aligned review findings:

1. **Canonical vs Legacy boundary locked**
- `academy/src/**` is canonical source.
- `lab/*` is now explicitly legacy redirect namespace.
- Added governance document: `academy/docs/governance/LEGACY_CANONICAL_BOUNDARY.md`.

2. **Production static surface tightened**
- Removed public serving of `/academy` and `/node_modules`.
- Added explicit asset routes under `/assets/**` and vendor route `/vendor/monaco`.

3. **Production security profile hardened**
- Added production env guardrails (no wildcard CORS, required DB URL, required APP_SECRET, trust proxy guard).
- CSP and security headers now environment-aware and stricter in production.

4. **Type-safety and runtime integrity**
- Expanded TypeScript scope to `src/**/*.ts`.
- Removed duplicate `*.js` source files where `*.ts` exists (TS is source of truth).
- Added runtime build pipeline (`academy:build:runtime`) and asset copy scripts.

5. **Backend correctness fixes**
- Added optimistic concurrency protection for CMS updates (update conflict detection).
- Removed `any` usage from domain database/storage layers.
- Tightened regression script route checks to expected statuses (no false pass on 404).

---

## 7. P0 Hardening Pass (2026-02-25)

Implemented from architecture review priorities:

1. **Tenant isolation contract (transport -> action -> storage)**
- Added tenant request context middleware:
  - `academy/src/domain/core/middleware/tenant-context.ts`
  - strict header contract in production (`x-tenant-id` required)
  - dev fallback via `DEFAULT_TENANT_ID`
- Propagated `tenantId` through all users/cms action signatures and route calls.
- Enforced tenant filters in repositories (`find*`, `create`, `update` paths).
- Updated Prisma schema with `tenant_id` columns and tenant-scoped unique/index constraints.

2. **Policy engine MVP (deterministic, tenant-aware)**
- Added new domain module:
  - `academy/src/domain/modules/policy/**`
- Exposed API endpoint:
  - `POST /api/policy/evaluate`
- Added deterministic rule evaluation baseline:
  - `no-important`
  - `blocked-property`
  - optional `no-id-selector`

3. **Mechanical architecture enforcement (CI gate)**
- Added script:
  - `academy/scripts/check-architecture-contracts.mjs`
- Enforces:
  - API/actions boundary rules
  - presentation/storage isolation
  - cross-module import via `public.ts`
  - tenant forwarding presence in routes/repositories
- Added npm scripts:
  - `academy:check:contracts`
  - `academy:ci`

4. **Focused validation tests**
- Added tests:
  - `academy/tests/tenant-context.test.ts`
  - `academy/tests/tenant-scope.test.ts`
  - `academy/tests/policy-actions.test.ts`
- Commands executed:
  - `npm run -s academy:check:contracts` ✅
  - `npm run -s academy:test` ✅

---

## 8. Frontend Typecheck Unblock (2026-02-25)

Goal for this pass was strictly to unblock runtime/build pipeline while broader frontend strict-typing refactor is in progress.

Implemented:
- Added temporary `@ts-nocheck` guard on legacy-heavy frontend runtime modules:
  - lessons engine runtime files
  - playground runtime files
- Added execution roadmap document:
  - `academy/docs/governance/Code-Review-And-ToDo/ENTERPRISE_COMPLETION_PLAN.md`

Validation evidence:
- `npm run -s academy:typecheck` ✅
- `npm run -s academy:check:contracts` ✅
- `npm run -s academy:test` ✅

Note:
- This is an unblock step, not the final strict-typing target.
- `ENTERPRISE_COMPLETION_PLAN.md` defines phased removal of temporary type suppression.

---

## 9. Enterprise Code Review + Bugfix Pass (2026-02-25)

### 9.1 PHASE 0 — Context Gate

- System Type: Node/Express + Prisma + SSR frontend (single deployable runtime).
- Primary Consumers: Browser clients (Campus/Classroom/Playground) + internal API clients.
- Runtime Context: `academy/src/**` canonical runtime, Postgres persistence, tenant-scoped APIs.
- Lifecycle: Execution Mode hardening pass (`academy/AGENTS.md` contract).
- In Scope: backend/domain correctness, tenant isolation, API determinism, operational readiness.
- Out of Scope: UX redesign, feature expansion, Web Components migration.
- Compatibility Constraints: keep existing API routes stable; preserve `/api/health`; keep legacy route redirects.

### 9.2 PHASE 1 — As-Built Reconstruction

- Primary axis: `api -> actions -> models -> storage`.
- Mutation points:
  - users/cms `create` in storage repositories
  - cms `update` with optimistic concurrency guard
  - tenant context assignment in middleware pipeline
- Failure paths:
  - validation/domain errors -> `AppError` mapped 4xx
  - unhandled infra errors -> `500 INTERNAL_SERVER_ERROR`

### 9.3 Findings (Pre-Fix)

### Finding: Tenant Isolation Incomplete at DB Constraint Level

- **Symptom:** Tenant data model allowed globally unique lesson id semantics and progress relations without composite tenant-bound FK constraints.
- **Root Cause:** `Lesson` had single-column PK on `id`; `LessonProgress` referenced `User.id` and `Lesson.id` without tenant-coupled foreign keys.
- **Impact:** Cross-tenant integrity could be violated at DB level; one tenant could block lesson IDs for others; isolation relied too heavily on app-level filtering.
- **Evidence:** `academy/prisma/schema.prisma` (pre-fix `Lesson.id @id`, and `LessonProgress` relations by single-column refs).
- **Risk:** High.

### Finding: Non-Deterministic Conflict Mapping on Concurrent Create

- **Symptom:** Concurrent duplicate creates could return `500` instead of deterministic `409 CONFLICT`.
- **Root Cause:** Actions performed pre-checks, but repository create paths did not map Prisma unique violations (`P2002`) to domain `ConflictError`.
- **Impact:** Client retry/error handling contract breaks under concurrency; violates deterministic 4xx/5xx mapping requirement.
- **Evidence:** `academy/src/domain/modules/users/actions/user.actions.ts`, `academy/src/domain/modules/cms/actions/cms.actions.ts`, `academy/src/domain/core/middleware/error-handler.ts`.
- **Risk:** High.

### Finding: Tenant Header Enforcement Applied Too Broadly in Request Pipeline

- **Symptom:** Production tenant enforcement was positioned globally, affecting non-API/static/SSR requests and health probing assumptions.
- **Root Cause:** `tenantContextMiddleware` executed at app-wide level before route segmentation.
- **Impact:** Operational fragility for assets/pages/probes when upstream header injection is absent or partial.
- **Evidence:** `academy/src/app.ts` (middleware order) and `academy/src/domain/core/middleware/tenant-context.ts`.
- **Risk:** Medium.

### Finding: Migration Discipline Gap

- **Symptom:** Prisma schema existed without versioned migration artifacts.
- **Root Cause:** Runtime schema evolved faster than migration bookkeeping.
- **Impact:** Non-reproducible environment setup and elevated deploy drift risk.
- **Evidence:** `academy/prisma/` pre-fix had only `schema.prisma`.
- **Risk:** Medium.

### 9.4 Immediate Remediation Implemented (This Pass)

1. Tenant isolation hardening in Prisma schema:
   - `Lesson` switched to composite primary key `@@id([tenantId, id])`.
   - `User` now exposes `@@unique([tenantId, id])` for tenant-coupled FK references.
   - `LessonProgress` relations now reference `[tenantId, userId] -> User[tenantId, id]` and `[tenantId, lessonId] -> Lesson[tenantId, id]`.
2. Deterministic unique-conflict mapping:
   - Added `P2002` mapping to `ConflictError` in:
     - `academy/src/domain/modules/users/storage/user.repository.ts`
     - `academy/src/domain/modules/cms/storage/cms.repository.ts`
3. Middleware/routing stabilization:
   - Moved tenant middleware to `/api` chain.
   - Added explicit `/api/health` route before tenant enforcement.
   - Removed `/api/health` from module composition router.
4. Migration evidence added:
   - `academy/prisma/migrations/20260225133000_baseline/migration.sql`
   - `academy/prisma/migrations/migration_lock.toml`

### 9.5 Final Decision

Selected outcome: **Keep and Improve**

Justification:
- Core architecture axis remains valid and enforceable.
- Detected defects were critical but localized and fixable without system redesign.
- Post-fix, contracts are materially stronger (tenant isolation + deterministic error mapping + migration baseline).

### 9.6 QA Evidence

- `npm run -s prisma:generate` ✅
- `npm run -s academy:check:contracts` ✅
- `npm run -s academy:typecheck` ✅
- `npm run -s academy:test` ✅

### 9.7 Decision Log Entry

- **Date:** 2026-02-25
- **Context:** AGENTS-aligned enterprise review with mandatory bugfix follow-through.
- **Decision:** Keep and Improve; execute immediate hardening fixes in the same iteration.
- **Alternatives Rejected:** Full redesign/rewrite (rejected because axis and boundaries are already serviceable).
- **Consequences/Risks:** Requires DB migration rollout coordination for environments with existing data.
- **Evidence:** Updated schema, repositories, middleware order, migration artifacts, and passing QA commands.

---

## 10. Phase Execution Update (2026-02-25)

Executed in user-requested sequence:

1. **Phase 1 (DB + integration proof)**
- Added migration/deploy scripts and DB integrity verifier:
  - `academy:db:migrate:deploy`
  - `academy:db:verify`
- Added integration tests (tenant isolation + concurrent create conflict mapping):
  - `academy/tests/tenant-isolation.integration.test.ts`
- Integration tests are env-aware:
  - run when `DATABASE_URL` exists,
  - skipped otherwise with explicit message.

2. **Phase 2 (AuthN/AuthZ + frontend integration)**
- Added backend auth middleware + role enforcement:
  - `academy/src/domain/core/middleware/auth-context.ts`
  - `cms` routes protected with role checks (`INSTRUCTOR|ADMIN` read, `ADMIN` write)
  - `policy` evaluate route protected (`INSTRUCTOR|ADMIN`)
- Added auth config contract:
  - `AUTH_TOKENS` parsing in `core/config`
  - production guardrails for token quality and ADMIN presence
- Added frontend auth + backend integration UI:
  - shared auth client: `academy/src/presentation/ui/shared/js/auth-client.ts`
  - Campus API console for credential capture and protected API calls:
    - `GET /api/cms/lessons`
    - `POST /api/policy/evaluate`
  - files:
    - `academy/src/presentation/apps/campus/pages/index.ejs`
    - `academy/src/presentation/apps/campus/assets/campus.ts`
    - `academy/src/presentation/apps/campus/assets/campus.css`
- Removed `@ts-nocheck` from selected frontend runtime files:
  - `lessons/assets/classroom.ts`
  - `playground/engine/simulator-adapter.ts`
  - `playground/engine/variables.ts`
  - `playground/engine/responsive.ts`
  - `playground/engine/positioning.ts`

3. **Final Phase (CI)**
- Added GitHub Actions workflow with Postgres service:
  - `.github/workflows/academy-ci.yml`
- CI gates include:
  - prisma generate
  - migrate deploy
  - db integrity verify
  - architecture contracts
  - full typecheck
  - tests (unit + integration)
  - runtime build + doctor

### QA Evidence (Local)

- `npm run -s academy:check:contracts` ✅
- `npm run -s academy:typecheck` ✅
- `npm run -s academy:test` ✅ (integration skipped locally because `DATABASE_URL` is not set)
- `npm run -s academy:build:runtime` ✅

---

## 11. Complete Code Review Pass (2026-02-25)

### 11.1 Context Gate

- System Type: multi-tenant Node/Express + Prisma backend with SSR + app-runtime frontend.
- Runtime Context: production target with token-based API auth baseline.
- Scope: `academy/src/**`, `academy/prisma/**`, CI/governance artifacts impacted in phased delivery.
- Out of Scope: visual redesign and large frontend runtime rewrite.

### 11.2 Findings

### Finding: `/api/users` remains unauthenticated

- **Symptom:** Users routes allow create/list/get without auth middleware.
- **Root Cause:** AuthN/AuthZ middleware was applied to CMS and Policy modules only; Users module was not included.
- **Impact:** User data plane can be accessed or mutated by unauthenticated callers that can provide tenant context (or default tenant in non-production).
- **Evidence:** `academy/src/domain/modules/users/api/users.routes.ts` (no `authContextMiddleware` / role guard on route declarations).
- **Risk:** High.

### Finding: Stored-XSS vector in Campus API console rendering

- **Symptom:** Lesson fields from API response are injected with `innerHTML`.
- **Root Cause:** Render helper builds markup string directly from `lesson.navLabel`, `lesson.title`, and `lesson.goal` without escaping.
- **Impact:** If CMS content is poisoned, browser execution can occur in Campus console context.
- **Evidence:** `academy/src/presentation/apps/campus/assets/campus.ts` lines building `li.innerHTML`.
- **Risk:** High.

### Finding: Tenant typing contract is stronger than runtime guarantee

- **Symptom:** `req.tenantId` is typed as always present, while middleware populates it only on `/api` path.
- **Root Cause:** `Express.Request` declaration in tenant middleware marks `tenantId` required globally.
- **Impact:** Non-API requests can carry `undefined` tenant in logs/error paths; future logic may incorrectly assume non-null tenant.
- **Evidence:** `academy/src/domain/core/middleware/tenant-context.ts` (`tenantId: string`) vs `academy/src/app.ts` (`tenantContextMiddleware` mounted only under `/api`).
- **Risk:** Medium.

### Finding: Remaining frontend runtime is still largely `@ts-nocheck`

- **Symptom:** Critical runtime files still bypass TypeScript checks.
- **Root Cause:** Prior unblock strategy deferred strict typing for largest modules.
- **Impact:** Regression detection remains limited in lesson/playground runtime hot paths.
- **Evidence:** `academy/src/presentation/apps/playground/assets/playground.ts` and multiple `academy/src/presentation/apps/lessons/engine/*.ts` files with `// @ts-nocheck`.
- **Risk:** Medium.

### 11.3 Decision

Selected outcome: **Keep and Improve**

Justification:
- Architectural axis remains valid, but security and type-contract gaps still require follow-up hardening.
- No finding currently justifies redesign/rewrite; issues are fixable with bounded iterations.

### 11.4 Next Steps

1. Apply auth middleware + role contract to Users module (or explicitly document why public).
2. Replace `innerHTML` lesson rendering with safe DOM text node construction.
3. Align tenant typing contract with middleware scope (`tenantId?: string` + API guard normalization).
4. Continue phased removal of `@ts-nocheck` in `playground/assets` and `lessons/engine`.

---

## 12. Remediation Closure + Stability Declaration (2026-02-25)

### 12.1 Closed Findings from Section 11

### Finding Closure: `/api/users` unauthenticated surface

- **Symptom (closed):** Users routes were open without auth.
- **Root Cause (closed):** Missing auth middleware in Users API module.
- **Impact (resolved):** Users data plane now requires valid token + role checks.
- **Evidence:** `academy/src/domain/modules/users/api/users.routes.ts` now uses `authContextMiddleware` and role guards (`INSTRUCTOR|ADMIN` read, `ADMIN` write).
- **Risk:** Closed.

### Finding Closure: Stored-XSS vector in Campus API console

- **Symptom (closed):** API fields were injected via `innerHTML`.
- **Root Cause (closed):** String-based markup rendering with unescaped data.
- **Impact (resolved):** Lesson fields are now rendered via `textContent` and node append flow.
- **Evidence:** `academy/src/presentation/apps/campus/assets/campus.ts` `renderLessons()` now builds DOM nodes directly.
- **Risk:** Closed.

### Finding Closure: Tenant typing/runtime contract mismatch

- **Symptom (closed):** Global `req.tenantId: string` conflicted with middleware scope.
- **Root Cause (closed):** Tenant typing was mandatory while middleware ran only on `/api`.
- **Impact (resolved):** Contract now explicit (`tenantId?: string`) plus route-level normalization (`requireTenantId`).
- **Evidence:** `academy/src/domain/core/middleware/tenant-context.ts`, `academy/src/domain/modules/*/api/*.routes.ts`.
- **Risk:** Closed.

### Finding Closure: Remaining frontend `@ts-nocheck`

- **Symptom (closed):** Legacy runtime modules bypassed TS checks via `@ts-nocheck`.
- **Root Cause (closed):** Temporary unblock strategy.
- **Impact (resolved):** `@ts-nocheck` usage removed from frontend source.
- **Evidence:** no occurrences in `academy/src/**` (`rg -n "@ts-nocheck" academy/src` => none).
- **Risk:** Closed.

### 12.2 Additional Runtime Integrity Fix

- Unified presentation runtime path to `academy/dist/presentation/**`:
  - `academy/src/app.ts` now resolves presentation root at `dist/presentation`.
  - `academy/src/presentation/ssr/register-pages.ts` now consumes presentation root directly.
  - `academy/scripts/copy-presentation-assets.mjs` copies static assets (including `.js`) into `dist/presentation`.

### 12.3 Stability Status

- **Status:** `Stable (Pre-Production)`
- **Reason:** All previously open High findings from section 11 are closed and local QA gates pass.
- **Production Ready Gate Remaining:** first CI run with Postgres-backed integration execution evidence.

### 12.4 QA Evidence (Closure Pass)

- `npm run -s academy:check:contracts` ✅
- `npm run -s academy:typecheck` ✅
- `npm run -s academy:test` ✅ (unit/in-process integration; DB-backed integration tests are env-gated)
- `npm run -s academy:build:runtime` ✅
- `npm run -s doctor:runtime` ✅

---

## 13. Production Readiness Delta Review (2026-02-25)

### 13.1 Findings (Pre-Fix)

### Finding: CI blocked at dependency installation

- **Symptom:** GitHub Actions `academy-ci` failed in `npm ci` before any runtime checks.
- **Root Cause:** `@milos/layout-os` was locked to `git+ssh://git@github.com/...` in `package-lock.json`.
- **Impact:** CI gates were non-executable; release confidence and Production Ready promotion were blocked.
- **Evidence:** `.github/workflows/academy-ci.yml` run `22397110459` failed at `Install Dependencies` with SSH permission error.
- **Risk:** High.

### Finding: Destructive integration tests had no explicit reset guard

- **Symptom:** Integration tests perform full-table deletes when `DATABASE_URL` is present.
- **Root Cause:** `tenant-isolation.integration.test.ts` relied only on presence of `DATABASE_URL` and had no explicit destructive-run flag.
- **Impact:** Accidental execution against non-test database could delete runtime data.
- **Evidence:** `academy/tests/tenant-isolation.integration.test.ts` (`resetDatabaseState()` calls `deleteMany()` on all core tables).
- **Risk:** Medium.

### Finding: Local `academy:ci` command drifted from required governance gates

- **Symptom:** Local CI script used domain-only typecheck and skipped runtime build gate.
- **Root Cause:** Script lagged behind workflow hardening changes.
- **Impact:** Local “green CI” could diverge from workflow outcome.
- **Evidence:** `package.json` pre-fix `academy:ci` script.
- **Risk:** Medium.

### 13.2 Remediation Implemented

1. Dependency reliability fix:
- Vendored `@milos/layout-os` into `academy/vendor/layout-os`.
- Switched dependency to local file source: `file:academy/vendor/layout-os`.
- Regenerated `package-lock.json` to remove SSH-based git resolution.

2. Integration test safety gate:
- Added explicit `ACADEMY_INTEGRATION_DB_RESET=true` requirement before destructive reset in integration tests.
- Added the same env flag in `.github/workflows/academy-ci.yml`.

3. CI command parity:
- Updated `package.json` `academy:ci` script to run:
  - `prisma:generate`
  - `academy:check:contracts`
  - full `academy:typecheck`
  - `academy:test`
  - `academy:build:runtime`
  - `doctor:runtime`
- Replaced shell-dependent test globbing with deterministic test file discovery:
  - `academy/scripts/run-tests.mjs`
  - `academy:test` and `academy:test:integration` now use this runner.

### 13.3 QA Evidence (Delta Pass)

- `npm ci` ✅
- `npm run -s academy:ci` ✅
- `gh run view 22397110459 --log-failed` confirms root-cause prior to fix (dependency SSH fetch failure).
- `gh run view 22397655266 --log-failed` confirms secondary root-cause prior to fix (Linux shell glob expansion in test script).
- `Academy CI` run `22397741221` ✅:
  - https://github.com/shomsy/MILOS-ACADEMY/actions/runs/22397741221
  - includes Postgres-backed migration, DB integrity verification, contracts, full typecheck, unit+integration tests, runtime build, and runtime doctor.

### 13.4 Updated Stability Status

- **Status:** `Production Ready`
- **Reason:** all stability declaration conditions are now satisfied:
  1. no open High/Rewrite findings,
  2. contracts/typecheck/test/build/doctor gates pass,
  3. migration discipline evidence exists,
  4. protected API auth baseline enforced,
  5. CI gate executes and is green on `main` with DB-backed integration coverage.

### 13.5 Post-Production ToDo (Non-Blocking)

1. Add deployment runbook (`deploy`, rollback, secret rotation) under governance docs.
2. Add backup/restore drill evidence for Postgres.
3. Add staging smoke test checklist (auth + tenant + CMS + policy happy-path verification).

---

## 14. Governance Update: Git Discipline + CI-First Mode (2026-02-25)

### 14.1 Decision

Adopted mandatory branch discipline and CI-first validation as repository contract.

### 14.2 Contract Changes

1. `academy/AGENTS.md`
- Added mandatory `main/development/feature/*/hotfix/*` flow.
- Added CI-first and Codex-resource discipline rules.

2. `academy/docs/governance/execution-policy.md`
- Added enforceable branch/merge protocol.
- Added CI-first validation policy and minimum merge evidence.

3. `academy/docs/governance/how-to-code-review.md`
- Added CI-first review cadence and triage input requirements.

4. `academy/docs/governance/how-to-coding-standards.md`
- Added mandatory delivery workflow standards (branch + CI-first).

5. `academy/docs/governance/Code-Review-And-ToDo/review-template.md`
- Added branch-policy and CI-run-URL evidence checks.

### 14.3 Rationale

- Reduces endless local full-suite reruns.
- Preserves release quality with mandatory PR + CI gates.
- Lowers Codex token usage by shifting validation to deterministic CI evidence and delta review.

---

## 15. Post-Production Completion Pass (2026-02-25)

### 15.1 Scope

Complete remaining plan items except Docker implementation (handled in external central stack).

### 15.2 Implemented in this pass

1. Policy persistence completed:
- Added DB-backed policy packs with versioning and tenant active mapping.
- Added API surface for list/upsert/activate policy packs.
- Added integration test for tenant policy persistence behavior.

2. Operations docs completed:
- deploy + rollback runbook,
- Postgres backup/restore runbook,
- staging smoke checklist,
- observability + machine-readable error envelope contract,
- security checklist with explicit CSRF strategy.

3. Environment contract completed:
- Added root `.env.example` with required runtime variables and test safety flag.

4. Container handoff preparation completed:
- Added container runtime handoff contract (without Dockerfile in this repository).

### 15.3 Deferred by explicit owner decision

1. Dockerfile/build profile in this repository.
2. Local Docker orchestration in this repository.

Reason:
- Docker lifecycle is managed in external centralized stack and will be integrated there.

### 15.4 QA Evidence (Completion Pass)

- `npm run -s prisma:generate` ✅
- `npm run -s academy:check:contracts` ✅
- `npm run -s academy:typecheck` ✅
- `npm run -s academy:test` ✅ (DB integration tests remain env-gated without local `DATABASE_URL`)
- `npm run -s academy:build:runtime` ✅
- `npm run -s doctor:runtime` ✅

---

## 16. Governance Update: ChatGPT Offload + Model Routing (2026-02-25)

### 16.1 Decision

Added mandatory companion offload discipline to reduce Codex resource usage for non-implementation tasks.

### 16.2 Contract Change

Updated `academy/AGENTS.md`:

1. Added section `12) ChatGPT Companion Offload Discipline (Mandatory)`.
2. Added explicit model routing by task class:
- `instant`
- `auto`
- `thinking`
- `extended thinking`
3. Added mandatory `ChatGPT Offload Note` in every final response.

### 16.3 Expected Outcome

1. Less Codex usage on drafting/summarization tasks.
2. Faster cycle time for CI triage and communication artifacts.
3. Better model-task fit for decision depth and risk level.

---

## 17. Production Quality Hardening Pass (2026-02-25)

### 17.1 Findings (Pre-Fix)

### Finding: Auth profile lacked token-expiry/revocation path

- **Symptom:** Only static env tokens were accepted; no native expiry or token-id revocation checks.
- **Root Cause:** Auth middleware used token lookup only (`AUTH_TOKENS`) without JWT claims verification.
- **Impact:** Lower resilience for long-lived credential leakage and limited operational revocation controls.
- **Evidence:** `academy/src/domain/core/middleware/auth-context.ts` (pre-fix static token lookup only).
- **Risk:** High.

### Finding: Health probing lacked readiness signal

- **Symptom:** `/api/health` existed but no DB-backed readiness endpoint.
- **Root Cause:** Liveness endpoint was implemented without dependency readiness contract.
- **Impact:** Deploy orchestrators could not distinguish "process up" from "service ready".
- **Evidence:** `academy/src/app.ts` (pre-fix only `/api/health`).
- **Risk:** Medium.

### Finding: Release quality gates missed dependency audit + runtime HTTP smoke

- **Symptom:** CI validated contracts/typecheck/tests/build but did not execute production dependency audit and post-build API smoke against running runtime.
- **Root Cause:** Missing scripts/workflow steps for those gates.
- **Impact:** Increased chance of shipping dependency risk or runtime wiring regressions.
- **Evidence:** `.github/workflows/academy-ci.yml` (pre-fix), `package.json` pre-fix scripts.
- **Risk:** Medium.

### 17.2 Remediation Implemented

1. Auth hardening with JWT support:
- Added `AUTH_MODE=static|jwt|hybrid`.
- Added JWT verification (HS256) with required `exp`, optional `nbf`/`iat`, issuer/audience enforcement, role extraction, and `jti` revocation list support.
- Added config contract:
  - `AUTH_JWT_SECRET`
  - `AUTH_JWT_ISSUER`
  - `AUTH_JWT_AUDIENCE`
  - `AUTH_JWT_CLOCK_SKEW_SECONDS`
  - `AUTH_REVOKED_JTIS`
- Added JWT-focused middleware tests for valid/expired/revoked tokens.

2. Readiness contract:
- Added `verifyDatabaseConnection()` in core database module.
- Added `GET /api/ready` endpoint with deterministic `503 SERVICE_UNAVAILABLE` mapping when DB check fails.

3. Production-quality CI gates:
- Added script: `academy:quality` (`npm audit --omit=dev`).
- Added script: `academy:smoke:runtime` (starts built runtime and validates `/api/health`, `/api/ready`, auth failure path, and protected tenant-scoped API success path).
- Updated CI workflow to run both gates.

4. Governance contract updates:
- Updated `academy/AGENTS.md` with mandatory production quality hardening gate.
- Updated code-review and execution-policy contracts to require quality + runtime smoke evidence for release path.
- Updated PR/review templates and operations docs to include readiness/auth-mode quality signals.

### 17.3 Stability Status Update

- **Status:** `Production Ready` (Hardened)
- **Reason:** Previous open operational gaps are now covered by executable runtime and quality gates plus explicit governance contracts.

### 17.4 QA Evidence

- `npm run -s academy:check:contracts` ✅
- `npm run -s academy:typecheck` ✅
- `npm run -s academy:test` ✅
- `npm run -s academy:build:runtime` ✅
- `npm run -s academy:quality` ✅
- `npm run -s academy:smoke:runtime` ✅ in CI profile (`DATABASE_URL` required)
- `npm run -s doctor:runtime` ✅

---

## 18. Executive Communication Artifact (2026-02-25)

### 18.1 Scope

Docs-only communication artifact for leadership/stakeholder distribution.

### 18.2 Implemented

1. Added bilingual executive release summary:
- `academy/docs/operations/CEO_ONE_PAGER.md`
2. Updated operations docs index:
- `academy/docs/operations/README.md`

### 18.3 Traceability Evidence

One-pager includes:

1. release status (`GO - Production Ready`),
2. merge commit references (`d376585`, `c34b3e4`),
3. CI run URLs on feature/development/main,
4. explicit remediation note for initial failed CI run (`22401477985` -> fixed by `b0ae78b`).

### 18.4 QA Evidence

1. Docs-only iteration: no runtime code changes in this pass.
2. Cross-link/index updated in operations docs catalog.
