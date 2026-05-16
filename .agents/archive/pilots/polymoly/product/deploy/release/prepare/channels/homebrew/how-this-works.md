---
title: product-deploy-prepare-channels-homebrew-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy Prepare Channels Homebrew How This Works

## What this folder is

This folder owns one generated artifact in the channel flow:
the Homebrew formula for one release.

## Direct files in this folder

### `render_homebrew_formula.go`

- `RenderHomebrewFormula(version, baseURL, binaries)`
  This renders the Homebrew formula from the published macOS binaries.

### `render_homebrew_formula_test.go`

This test file proves the formula uses explicit binary names instead of a loose
wildcard install.
