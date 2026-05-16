# MILOS Academy - Frontend Architecture

Version: 1.1.0
Status: Normative / Enforced
Scope: `academy/src/presentation/**`

---

## 1) Purpose

Define presentation architecture for a page-first frontend that evolves into Web Components.
This document governs SSR/UI/browser runtime boundaries in MILOS Academy.

---

## 2) Canonical Presentation Structure

```text
src/presentation/
  ssr/
    register-pages.ts
    render.ts
  ui/
    layouts/
    partials/
    shared/
  apps/
    campus/
      pages/
      assets/
    playground/
      pages/
      assets/
      engine/
    lessons/
      pages/
      assets/
      engine/
      data/
```

---

## 3) Frontend Canonical Flow

Canonical flow:

`ssr render -> app boot (assets) -> app-local engine modules -> optional Custom Elements`

Rules:

- SSR route handlers stay thin and deterministic.
- App boot logic stays inside app asset entry files.
- Runtime helpers stay local to app engine modules.

---

## 4) Web Components Migration Contract

Migration target is controlled, not implicit.

A component is a Web Component candidate only when:

- reused in at least 2 pages/apps,
- behavior contract is stable,
- rendering lifecycle can run independently,
- component can be tested in isolation.

Required implementation contract:

1. File naming: `*.element.ts`
2. Tag naming: `academy-*`
3. Inputs: attributes/properties (explicit mapping)
4. Outputs: `CustomEvent` with stable event names
5. Accessibility: keyboard + ARIA contract defined
6. Style scope: CSS variables + `:host` classes and explicit host states

---

## 5) Forbidden Frontend Patterns

1. Monolithic global scripts with multi-app side effects.
2. Hidden cross-app coupling through direct DOM reach-in.
3. DOM side effects outside owning app boundary.
4. Silent migration to Web Components without explicit iteration scope.

---

## 6) Engine vs App Semantics

- `@milos/layout-os` (`l-*`, `u-*`) remains layout layer.
- App semantics remain academy-owned (`academy-*`, `app-*`, `c-*`, `js-*`).
- Do not create engine DSL primitives in Academy.
- Do not encode business semantics into engine class names.

---

## 7) App Slice Contracts

### 7.1 `ssr/`

- `register-pages.ts` mounts render routes.
- `render.ts` owns rendering wrapper.
- No business logic.

### 7.2 `ui/`

- `layouts/` and `partials/` are shared presentation shell only.
- `shared/js` and `shared/css` are cross-app UI utilities only.

### 7.3 `apps/<app>/`

- `pages/` contains SSR templates.
- `assets/` contains app entry code and styles.
- `engine/` contains app-local runtime utilities.
- `data/` stores presentation data, never domain persistence.

---

## 8) Accessibility and UX Baseline

- Interactive controls must be keyboard reachable.
- Editors and custom controls require valid ARIA labeling.
- User-facing educational text should stay in simple English.

---

## 9) QA Requirements

Before merge:

1. Smoke test SSR routes and render output.
2. Verify each app entry asset resolves.
3. Verify shared navigation/layout behavior across apps.
4. Verify deterministic behavior for lessons/playground runtime.
5. For Web Components changes, verify tag/attribute/event contract and accessibility behavior.

