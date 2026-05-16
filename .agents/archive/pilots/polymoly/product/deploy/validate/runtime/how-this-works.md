---
title: product-deploy-validate-runtime-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy Validate Runtime How This Works

## What this folder is

`product/deploy/validate/runtime/` is the runtime-validation sub-step in the
deploy pipeline.

It keeps the product-facing runtime validation commands small and explicit,
then hands the heavy proof work into `release/verify/`.

## Real commands that reach this folder

- `poly release promoted-runtime-proof`
- `poly release stage-load-smoke`
- `poly release restore-serving-proof`

## Direct files in this folder

### `check_promoted_runtime_state.go`

- `CheckPromotedRuntimeState(root)`
  This forwards the promoted-runtime validation story into
  `release/verify.CheckPromotedRuntimeProof(...)`.

### `check_stage_smoke.go`

- `CheckStageSmoke(root)`
  This forwards the stage-smoke validation story into
  `release/verify.CheckStageLoadSmoke(...)`.

### `restore_serving.go`

- `RestoreServing(root)`
  This forwards the restore-serving validation story into
  `release/verify.CheckRestoreServingProof(...)`.
