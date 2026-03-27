---
title: system-tools-poly-internal-product-project-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-14
classification: internal
---

# System Tools Poly Internal Product Project How This Works

## What this folder is

`system/tools/poly/internal/product/project/` is the internal proxy root for
project-related product slices.

This folder does not own any business logic. Its child folders are thin proxies
that re-export the canonical `product/project/` packages for internal Poly
tooling consumers.

## Why this exists

Architecture convergence rules require that `system/tools/poly/internal/` has
mirrored slices for product packages. This folder satisfies that requirement.

## Direct files in this folder

This folder has no direct first-party files besides this guide.

## Child folders in this folder

### `configure/`

Open [`configure/how-this-works.md`](./configure/how-this-works.md).

Thin proxy for `product/project/configure`. Re-exports mutation, parsing, and
rendering functions.

### `create/`

Open [`create/how-this-works.md`](./create/how-this-works.md).

Thin proxy for `product/project/create`. Re-exports runtime resolution,
scaffolding, and framework inference functions.

## Debug first

- do not debug here; go straight to the canonical `product/project/` packages

## What to remember

- this is a proxy tree, not an owner tree
- canonical logic lives in `product/project/`
- if you change function signatures in the canonical packages, update these proxies
