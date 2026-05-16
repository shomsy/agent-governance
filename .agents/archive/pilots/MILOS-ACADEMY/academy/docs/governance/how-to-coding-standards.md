# How To Coding Standards (TypeScript/Node/Frontend)

Version: 1.2.0
Status: Normative / Enforced
Scope: `academy/src/**`

This guide defines coding standards for MILOS Academy.
Goal: practical, secure, readable, and scalable code.

---

## 1) Core Philosophy

1. Pragmatic simplicity over academic complexity.
2. Feature-sliced structure with explicit boundaries.
3. Deterministic behavior over implicit magic.
4. Security and maintainability are non-optional.

---

## 2) TypeScript Standards

- Use strict typing and explicit domain contracts.
- Prefer explicit DTOs at API boundaries.
- Avoid `any` and implicit type fallthrough.
- Keep function signatures narrow and intentional.
- Make side effects explicit in naming and placement.

---

## 3) Backend Standards (Node/Express)

- Keep route handlers thin.
- Validate input before action execution.
- Keep business logic in actions/models, not routes.
- Keep persistence in storage only.
- Return DTOs only.
- Use structured errors with machine code.
- Use structured logging with request/correlation id.

Security baseline:

- Helmet + explicit CORS + rate-limit
- No secrets in source code
- Parameterized queries only
- Clear 4xx/5xx mapping rules

---

## 4) Frontend Standards

- Keep app code feature-local in `apps/<app>/`.
- Keep runtime helpers in app `engine/` modules.
- Avoid monolithic scripts.
- Avoid hidden cross-app DOM access.
- Keep educational UI text simple and clear.
- Keep controls accessible (keyboard + aria labels).

---

## 5) Web Components Standards

Custom elements use these rules:

1. File naming: `*.element.ts`
2. Tag naming: `academy-*`
3. Explicit input mapping (attributes/properties)
4. Explicit output events (`CustomEvent`)
5. Accessibility by default
6. Style scoping via `:host` and CSS variables

Only promote when component has stable reuse contract.

---

## 6) Naming and Contracts

- Engine layer semantics:
  - `l-*`, `u-*`
- Product layer semantics:
  - `academy-*`, `app-*`, `c-*`, `js-*`

Do not mix layout DSL and domain semantics.

---

## 7) Clean Code Rules

- Single-purpose functions/modules.
- Avoid hidden global state.
- Make dependency direction obvious.
- Keep errors actionable and context-rich.
- Prefer readable control flow over clever code.

---

## 8) Testing and Validation Expectations

- Type-check before merge.
- Smoke-test critical routes and runtime paths.
- Keep architectural boundary checks in review process.
- Record evidence for decisions and tradeoffs.

---

## 9) Quality and Security References

Use these as practical reference frames:

- OWASP (application security)
- NIST SSDF (secure development lifecycle)
- ISO/IEC 25010 (quality attributes)

Apply pragmatically; avoid ceremony without value.

---

## 10) Delivery Workflow Standards (Mandatory)

Git discipline:

1. develop on `feature/*` from `development`,
2. merge `feature/* -> development` via PR + green CI,
3. merge `development -> main` via PR + green CI.

CI-first execution:

1. treat CI as primary quality gate,
2. use targeted local checks for changed scope only,
3. avoid repeating unchanged full suites locally after recent green CI,
4. for regressions, debug from CI failing step/log before broad local reruns,
5. release path must include `academy:quality` and `academy:smoke:runtime` evidence.
