---
title: product-deploy-prepare-channels-installscript-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy Prepare Channels Installscript How This Works

## What this folder is

This folder owns one generated artifact in the channel flow:
the production-facing `install.sh` script.

## Direct files in this folder

### `render_install_script.go`

- `RenderInstallScript(version, baseURL, binaries)`
  This renders the shell installer with platform detection, checksum
  verification, and writable-install-dir fallback behavior.
