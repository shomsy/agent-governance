---
title: product-deploy-prepare-channels-model-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy Prepare Channels Model How This Works

## What this folder is

This folder holds the shared shapes and selectors for the release-channel
feature.

## Direct files in this folder

### `channel_models.go`

This file defines the typed shapes for:

- `GenerateChannelsInput`
- `ChannelResult`
- `ReleaseBinary`
- `ChannelPaths`
- `ChannelFiles`

### `select_release_binaries.go`

- `FilterReleaseBinariesByChannel(binaries, channel)`
- `FindReleaseBinary(binaries, name)`

These helpers keep the binary-selection rules close to the shared model.
