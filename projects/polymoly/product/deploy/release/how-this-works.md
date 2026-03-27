---
title: product-deploy-release-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy Release How This Works

## What this folder is

`product/deploy/release/` is the release step inside the deploy pipeline.

It is intentionally split into two sub-steps:

- `prepare/` prepares release-facing distribution surfaces
- `verify/` verifies and writes release-facing proof artifacts

## Child folders in this folder

### `prepare/`

Open [prepare/how-this-works.md](./prepare/how-this-works.md).

Use it for:

- `poly release dist-channels <version>`

### `verify/`

Open [verify/how-this-works.md](./verify/how-this-works.md).

Use it for:

- `poly release docker-preflight`
- `poly release evidence-index [bundle-root]`
- proof artifact writing after runtime validation wrappers hand work forward
