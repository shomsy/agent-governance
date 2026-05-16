# MILOS Academy - Backend Architecture

Version: 2.1.0
Status: Normative / Enforced
Scope: `academy/src/domain/**`

---

## 1) Purpose

Define strict backend architecture for Node.js/Express + Postgres (TypeScript) in MILOS Academy.
This document governs only the Domain Layer and its API boundary.

---

## 2) Canonical Backend Axis

Canonical execution axis:

`api -> actions -> models -> storage`

Platform layer:

- `core/config`
- `core/database`
- `core/logger`
- `core/errors`
- `core/middleware`
- `core/security`

Rule: every backend feature must remain legible on this axis.

---

## 3) Canonical Domain Structure

```text
src/domain/
  core/
    config/
    database/
    errors/
    logger/
    middleware/
    security/
  modules/
    <feature>/
      api/
      actions/
      models/
      storage/
      validation/
      dto/
      <feature>.module.ts
      public.ts
  composition/
    register-modules.ts
    di.ts
```

---

## 4) Layer Contracts

### 4.1 `api/`

- Owns transport only (Express req/res).
- Validates input before action call.
- Calls actions only.
- Returns DTO output only.
- Must not include business logic.
- Must not call Prisma/storage directly.

### 4.2 `actions/`

- Owns use-case orchestration.
- Calls models and storage contracts.
- Maps outputs to DTOs.
- Must not import Express.
- Must not import Prisma.

### 4.3 `models/`

- Owns domain invariants and behavior.
- Must keep entities valid after create/update flows.
- Must not import Express or Prisma.

### 4.4 `storage/`

- Owns persistence implementation.
- Prisma access allowed only here and `core/database`.
- Maps DB rows <-> domain model.
- Must not contain orchestration or transport logic.

### 4.5 `validation/`

- Owns typed input schemas.
- Must execute before actions.

### 4.6 `dto/`

- Owns explicit input/output contracts.
- API responses must expose DTO shapes only.

---

## 5) Hard Stop Conditions (Review Gates)

Any of these is an immediate fail:

1. API directly accessing Prisma/storage.
2. Business logic inside `api/`.
3. Storage performing orchestration/use-case branching.
4. ORM entity leakage to external response contract.
5. Cross-feature deep import bypassing `public.ts`.

---

## 6) Operational Invariants (Mandatory)

Minimum invariants that must hold:

1. Route behavior is deterministic for same input.
2. Typed validation executes before actions.
3. DTO-only external outputs.
4. No ORM leakage outside storage/database.
5. Errors are structured and machine-classified.
6. Correlation/request id propagates through request pipeline.
7. No secrets hardcoded in source.
8. Migration discipline: schema changes are versioned in `prisma/migrations`.

---

## 7) Security Baseline

- Helmet enabled with explicit config.
- CORS policy must be explicit (no unrestricted wildcard in production profile).
- Rate limiting active for API routes.
- Parameterized queries only; no SQL concatenation.
- Tenant isolation (`tenant_id`) is mandatory when multi-tenancy is enabled.

---

## 8) Failure-Mode Contract

- Error classes must include stable machine `code`.
- Error mapping must be deterministic:
  - validation/domain issues -> 4xx
  - unhandled/server issues -> 5xx
- Response bodies must expose safe error detail only.
- Logs must keep diagnostic context (request id, route, code path).

---

## 9) Composition Root Contract

- `composition/register-modules.ts` mounts module routes and nothing else.
- `composition/di.ts` owns construction/wiring only.
- No business branching in composition files.

---

## 10) Cross-Module Rules

- Cross-feature access allowed only via `public.ts`.
- No deep imports into another module internals.
- Module internals remain replaceable without cross-module edits.

---

## 11) QA Requirements

Before merge:

1. Type-check domain modules.
2. Verify boundaries (`api -> actions -> models -> storage`).
3. Smoke test core API routes and error paths.
4. Verify no ORM leaks outside storage/database.

