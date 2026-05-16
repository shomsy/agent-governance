---
title: system-tools-poly-internal-product-project-lifecycle-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-14
classification: internal
---

# System Tools Poly Internal Product Project Lifecycle How This Works

## What this folder is

`system/tools/poly/internal/product/project/lifecycle/` is a thin proxy slice
that re-exports the canonical `product/project/lifecycle` package for internal
Poly tooling consumers.

This folder does not own any business logic. Every function forwards directly
into the canonical `product/project/lifecycle` package.

## Why this exists

Architecture convergence rules require that `system/tools/poly/internal/` has
mirrored slices for product packages. This folder satisfies that requirement
while keeping the canonical logic in one place.

## Direct files in this folder

### `lifecycle_forwarder.go`

Proxy file. Re-exports:

- `ProjectDescribe(...)` — forwards to `lifecyclepkg.ProjectDescribe(...)`
- `ProjectEvents(...)` — forwards to `lifecyclepkg.ProjectEvents(...)`
- `ProjectHealth(...)` — forwards to `lifecyclepkg.ProjectHealth(...)`
- `ProjectAccess(...)` — forwards to `lifecyclepkg.ProjectAccess(...)`
- `LoadExistingProjectContext(...)` — forwards to `lifecyclepkg.LoadExistingProjectContext(...)`

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- do not debug here; go straight to `product/project/lifecycle/` for real logic

## What to remember

- this is a proxy, not an owner
- canonical logic lives in `product/project/lifecycle/`
- if you change function signatures in the canonical package, update this proxy
