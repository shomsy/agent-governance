---
title: product-deploy-prepare-channels-readme-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy Prepare Channels Readme How This Works

## What this folder is

This folder owns one generated artifact in the channel flow:
the small README that explains what was generated for one release.

## Direct files in this folder

### `render_channel_readme.go`

- `RenderChannelReadme(version, paths, binaries)`
  This renders the human-readable summary of generated channel files and
  published release assets.
