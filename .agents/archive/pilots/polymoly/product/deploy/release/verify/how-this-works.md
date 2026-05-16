---
title: product-deploy-release-verify-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy Release Verify How This Works

## What this folder is

`product/deploy/release/verify/` is the release-verification step in the deploy
pipeline.

This is where release claims become proof artifacts, evidence indexes, and
machine-readable verdict files.

## Real commands that reach this folder

- `poly release docker-preflight`
- `poly release evidence-index [bundle-root]`
- indirect proof calls forwarded from `validate/runtime/`

## Direct files in this folder

### `check_release_proofs.go`

- `EnsureDockerRuntime(...)`
- `CheckPromotedRuntimeProof(...)`
- `CheckStageLoadSmoke(...)`
- `CheckRestoreServingProof(...)`
- `GenerateEvidenceIndex(...)`

This is the main proof engine file in the folder.

### `check_rollback_safety.go`

This file defines the rollback reference artifacts and commands used by the
release evidence path.

### `write_release_evidence_index.go`

- `WriteEvidenceIndex(...)`

This is the compatibility wrapper around `GenerateEvidenceIndex(...)`.

## Child folders in this folder

### `gitops/`

Open [gitops/how-this-works.md](./gitops/how-this-works.md).

This child folder owns the GitOps manifests that sit next to release
verification work.
