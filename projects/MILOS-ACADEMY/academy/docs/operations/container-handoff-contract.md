# Academy Container Handoff Contract (External Docker Stack)

Version: 1.0.0  
Status: Normative / Enforced  
Scope: handoff to centralized Docker platform (managed outside this repository)

## 1) Purpose

Define runtime contract required for moving Academy into a central Docker stack without changing application behavior.

## 2) Runtime Contract

Container runtime must execute:

1. `npm ci`
2. `npm run -s prisma:generate`
3. `npm run -s academy:build:runtime`
4. `npm run -s serve`

Health endpoint:

1. `GET /api/health` must return `200`.

## 3) Required Environment Variables

1. `NODE_ENV=production`
2. `PORT`
3. `DATABASE_URL`
4. `APP_SECRET`
5. `CORS_ORIGIN` (explicit allowlist, no wildcard)
6. `TRUST_PROXY`
7. `AUTH_TOKENS`
8. `DEFAULT_TENANT_ID` (for non-production fallback only)

Reference values and descriptions are in root `.env.example`.

## 4) Pre-Handoff Validation

1. `Academy CI` green for release SHA.
2. `academy:db:migrate:deploy` successful in target environment.
3. `academy:db:verify` successful.
4. staging smoke checklist completed.

## 5) Post-Handoff Acceptance

1. No API contract regression against current routes.
2. Tenant/auth policy behavior unchanged.
3. Logs still expose `traceId` and `tenantId` fields.
