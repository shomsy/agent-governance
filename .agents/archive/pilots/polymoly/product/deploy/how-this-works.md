---
title: product-deploy-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy How This Works

## What this folder is

`product/deploy/` is the product-facing deploy pipeline for PolyMoly.

This folder is not the answer to `what happens right after git clone polymoly`.
Clone only downloads source code.
This folder starts later, when PolyMoly is already installing, preparing a
release surface, verifying release evidence, or validating a promoted runtime.

## Pipeline law in this folder

- folder says the pipeline step
- file says one responsibility inside that step
- function says one exact action

The canonical pipeline shape here is:

```text
deploy/
  deploy_pipeline.go
  install/
  release/
    prepare/
    verify/
  validate/
    runtime/
```

## Real commands that reach this folder

- `poly install`
- `poly self-update`
- `poly release docker-preflight`
- `poly release promoted-runtime-proof`
- `poly release stage-load-smoke`
- `poly release restore-serving-proof`
- `poly release evidence-index [bundle-root]`
- `poly release dist-channels <version>`

## Direct files in this folder

### `deploy_pipeline.go`

- `RunDeployPipeline(input)`
  This is the canonical in-code orchestration map for the deploy pipeline.
  It runs only the steps the caller asked for, but it preserves the pipeline
  order: install, release prepare, release verify, validate runtime.

## Child folders in this folder

### `install/`

Open [install/how-this-works.md](./install/how-this-works.md).

This step owns project-local install and self-update file writing.

### `release/`

Open [release/how-this-works.md](./release/how-this-works.md).

This step owns release preparation and release verification.

### `validate/`

Open [validate/how-this-works.md](./validate/how-this-works.md).

This step owns post-release validation slices like runtime validation.

## What to remember

- `product/deploy/` is one pipeline slice, not just a loose collection of
  shipping helpers
- the root file is the canonical flow map
- the child folders are the real pipeline steps
- if a path is not a real pipeline step, it should not live directly here
