---
title: product-deploy-release-prepare-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy Release Prepare How This Works

## What this folder is

`product/deploy/release/prepare/` is the release-prepare step in the deploy
pipeline.

It gets already-built release inputs and prepares release-facing outputs.

## Real command that reaches this folder

- `poly release dist-channels <version>`

## Direct files in this folder

### `generate_channels.go`

- `GenerateChannels(input)`
  This is the thin public handoff into the deeper `channels/` slice.

### `channel_models.go`

This file keeps the public release-prepare channel types readable from the
outside.

## Child folders in this folder

### `channels/`

Open [channels/how-this-works.md](./channels/how-this-works.md).

This is the real file-generation sub-flow for release channels.
