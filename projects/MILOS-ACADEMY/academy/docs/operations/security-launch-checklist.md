# Academy Security Launch Checklist + CSRF Strategy

Version: 1.0.0  
Status: Normative / Enforced  
Scope: API launch and production readiness

## 1) CSRF Strategy

Current API auth profile is token-header based (`Authorization` / `x-api-token`) and does not rely on browser cookies.

Therefore:

1. Primary CSRF risk is reduced because credentials are not automatically attached by browser cookie policy.
2. CORS allowlist remains mandatory and must not be wildcard in production.

If/when session cookies are introduced in future:

1. enable CSRF token middleware,
2. enforce `SameSite=Lax|Strict` and `HttpOnly` cookies,
3. add origin/referer validation on state-changing routes.

## 2) Launch Checklist

1. Production env guards pass (`DATABASE_URL`, `APP_SECRET`, strict CORS, `TRUST_PROXY`, ADMIN token).
2. Helmet/CORS/rate-limit middleware active.
3. Protected routes enforce AuthN/AuthZ (`users`, `cms`, `policy`).
4. Auth mode contract validated (`AUTH_MODE=static|jwt|hybrid`), and if `jwt|hybrid` then JWT secret/issuer/audience/revocation policy are configured.
5. Tenant isolation contract enforced (`x-tenant-id` in production).
6. Prisma migrations up to date and deployed.
7. CI gate green for release SHA.
8. API smoke checklist completed on staging.

## 3) Secrets Checklist

1. No secrets in source control.
2. Runtime secrets injected via environment.
3. Token rotation process documented and testable.
4. Emergency token revocation path defined.
