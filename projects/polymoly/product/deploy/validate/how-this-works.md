---
title: product-deploy-validate-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy Validate How This Works

## What this folder is

`product/deploy/validate/` is the validation step in the deploy pipeline.

It holds validation slices that confirm whether a later deploy claim still
matches reality.

## Child folders in this folder

### `runtime/`

Open [runtime/how-this-works.md](./runtime/how-this-works.md).

Use it for runtime-facing validation commands like promoted proof, stage smoke,
and restore-to-serving checks.
