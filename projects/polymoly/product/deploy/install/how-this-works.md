---
title: product-deploy-install-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy Install How This Works

## What this folder is

`product/deploy/install/` is the install step in the deploy pipeline.

It owns the project-local Poly binary install story for `poly install` and
`poly self-update`.

## Real commands that reach this folder

- `poly install`
- `poly self-update`

## Direct files in this folder

### `install_project_cli.go`

- `InstallProjectBinary(projectRoot, sourceBinary, version)`
  This validates the target root, copies the current executable into the
  project sidecar, verifies the digest, and writes `poly-install.json`.

- `ReadManifest(projectRoot)`
  This reads the project-local install manifest.

- `LocalBinaryDir(projectRoot)`
- `LocalBinaryPath(projectRoot)`
- `ManifestPath(projectRoot)`

These helpers keep the install layout readable and deterministic.
