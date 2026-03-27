---
title: system-tools-poly-internal-product-project-create-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-14
classification: internal
---

# System Tools Poly Internal Product Project Create How This Works

## What this folder is

`system/tools/poly/internal/product/project/create/` is a thin proxy slice
that re-exports the canonical `product/project/create` package for internal
Poly tooling consumers.

This folder does not own any business logic. Every function forwards directly
into the canonical `product/project/create` package.

## Why this exists

Architecture convergence rules require that `system/tools/poly/internal/` has
mirrored slices for product packages. This folder satisfies that requirement
while keeping the canonical logic in one place.

## Direct files in this folder

### `create_forwarder.go`

Proxy file. Re-exports:

- `RuntimeResolution` — type alias from `create.RuntimeResolution`
- `FrameworkMatrixEntry` — type alias from `create.FrameworkMatrixEntry`
- `ResolveScaffoldRuntime(...)` — forwards to `create.ResolveScaffoldRuntime(...)`
- `InferRuntimeFromFramework(...)` — forwards to `create.InferRuntimeFromFramework(...)`
- `FrameworkMatrix()` — forwards to `create.FrameworkMatrix()`
- `ScaffoldNextSteps(...)` — forwards to `create.ScaffoldNextSteps(...)`
- `ExpectedStarterFiles(...)` — forwards to `create.ExpectedStarterFiles(...)`
- `WriteStarter(...)` — forwards to `create.WriteStarter(...)`
- `EnsureEmptyOrReplace(...)` — forwards to `create.EnsureEmptyOrReplace(...)`
- `CopyTree(...)` — forwards to `create.CopyTree(...)`

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- do not debug here; go straight to `product/project/create/` for real logic

## What to remember

- this is a proxy, not an owner
- canonical logic lives in `product/project/create/`
- if you change function signatures in the canonical package, update this proxy
