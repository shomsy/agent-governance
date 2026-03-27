---
title: product-deploy-prepare-channels-scoop-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy Prepare Channels Scoop How This Works

## What this folder is

This folder owns one generated artifact in the channel flow:
the Scoop manifest for the Windows release surface.

## Direct files in this folder

### `render_scoop_manifest.go`

- `RenderScoopManifest(version, baseURL, binaries)`
  This renders the Scoop manifest from the published Windows binary.
