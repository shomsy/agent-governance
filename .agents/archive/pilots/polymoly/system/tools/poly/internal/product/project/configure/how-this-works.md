---
title: system-tools-poly-internal-product-project-configure-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-14 (aligned forwarder with current signature)
classification: internal
---

# System Tools Poly Internal Product Project Configure How This Works

## What this folder is

`system/tools/poly/internal/product/project/configure/` is a thin proxy slice
that re-exports the canonical `product/project/configure` package for internal
Poly tooling consumers.

This folder does not own any business logic. Every function forwards directly
into the canonical `product/project/configure` package.

## Why this exists

Architecture convergence rules require that `system/tools/poly/internal/` has
mirrored slices for product packages. This folder satisfies that requirement
while keeping the canonical logic in one place.

## Direct files in this folder

### `configure_forwarder.go`

Proxy file. Re-exports:

- `MutationOptions` — type alias from `configure.MutationOptions`
- `TemplateResolver` — type alias from `configure.TemplateResolver`
- `PrepareConfigureBaselineIntent(...)` — forwards to `configure.PrepareConfigureBaselineIntent(...)`
- `PreserveExplicitTemplateOverrides(...)` — forwards to `configure.PreserveExplicitTemplateOverrides(...)`
- `ApplyConfigurationMutations(...)` — forwards to `configure.ApplyConfigurationMutations(...)`
- `ParseRequestedSetMutations(...)` — forwards to `configure.ParseRequestedSetMutations(...)`
- `ParseRequestedServiceShorthands(...)` — forwards to `configure.ParseRequestedServiceShorthands(...)`
- `RenderProfileUpgradeSummary(...)` — forwards to `configure.RenderProfileUpgradeSummary(...)`

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- do not debug here; go straight to `product/project/configure/` for real logic

## What to remember

- this is a proxy, not an owner
- canonical logic lives in `product/project/configure/`
- if you change function signatures in the canonical package, update this proxy
