# Academy Staging Smoke Checklist

Version: 1.0.0  
Status: Normative / Enforced  
Scope: `academy/**`

Run after each deployment candidate to staging.

## 1) Platform Health

1. `/api/health` returns `200` and `status: "ok"`.
2. `/api/ready` returns `200` and `status: "ready"`.
3. Logs contain `traceId` on each request line.
4. No startup exception in logs.

## 2) Auth + Tenant Contract

1. Request without auth token returns `401`.
2. Request with invalid role returns `403`.
3. JWT token with expired `exp` claim returns `401` (when `AUTH_MODE=jwt|hybrid`).
4. Request without tenant header in production profile returns `400`.
5. Request with valid tenant + token returns `2xx` on allowed route.

## 3) CMS Flow

1. `GET /api/cms/lessons` with instructor/admin token returns `200`.
2. `POST /api/cms/lessons` with admin token returns `201`.
3. concurrent update/create conflict maps to deterministic `409` behavior.

## 4) Policy Flow

1. `POST /api/policy/packs` (admin) persists pack version.
2. `POST /api/policy/activate` (admin) sets tenant active policy.
3. `POST /api/policy/evaluate` uses active tenant policy version.

## 5) Frontend Runtime

1. Campus page loads and can call protected APIs with token + tenant headers.
2. Classroom route loads expected lesson.
3. Playground challenge route loads without runtime errors.

## 6) Exit Criteria

1. No High-severity functional failure.
2. No auth/tenant contract regression.
3. CI run for release SHA is green.
