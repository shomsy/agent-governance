---
title: product-deploy-release-prepare-channels-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Deploy Release Prepare Channels How This Works

## What this folder is

This folder owns one narrow release-prepare sub-flow:
generate the distribution-channel files for one already-built PolyMoly
release.

The point of this split is explainability.
The root `release/prepare/` folder keeps the public handoff, while this folder
shows the real sequence in smaller steps.

## Real command that reaches this folder

- `poly release dist-channels <version>`

## The simplest story

```text
GenerateChannels
  -> normalize input
  -> load checksums
  -> build release-binary policy
  -> build output paths
  -> render channel files
  -> write files
```

## Direct files in this folder

### `generate_channels.go`

- `GenerateChannels(input)`
  This is the orchestration step for the whole channel flow.

### `normalize_generate_channels_input.go`

- `NormalizeGenerateChannelsInput(input)`
  This fail-closes external input before the rest of the flow runs.

### `build_release_binaries.go`

- `BuildReleaseBinaries(checksums)`
  This turns the checksum map into the release-binary matrix.

### `validate_required_release_binaries.go`

- `ValidateRequiredReleaseBinaries(binaries)`
  This enforces the required-binary policy.

### `build_channel_paths.go`

- `BuildChannelPaths(root, version)`
  This defines the deterministic output layout.

### `build_channel_files.go`

- `buildChannelFiles(...)`
  This gathers the rendered install script, Homebrew formula, Scoop manifest,
  and channel README before any write happens.

### `write_channel_files.go`

- `WriteChannelFiles(paths, files)`
  This performs the actual file writes through temp-path replacement.

## Child folders in this folder

### `checksums/`

Open [checksums/how-this-works.md](./checksums/how-this-works.md).

This child folder owns checksum loading and strict parsing.

### `homebrew/`

Open [homebrew/how-this-works.md](./homebrew/how-this-works.md).

This child folder owns the Homebrew formula renderer.

### `installscript/`

Open [installscript/how-this-works.md](./installscript/how-this-works.md).

This child folder owns the generated `install.sh`.

### `model/`

Open [model/how-this-works.md](./model/how-this-works.md).

This child folder holds the shared release-channel shapes and binary selectors.

### `readme/`

Open [readme/how-this-works.md](./readme/how-this-works.md).

This child folder owns the generated channel README.

### `scoop/`

Open [scoop/how-this-works.md](./scoop/how-this-works.md).

This child folder owns the Scoop manifest renderer.

## Debug first

- start in `GenerateChannels(...)` when the whole dist-channel flow looks wrong
- then jump to the child folder that owns the failing sub-step

## What to remember

- this folder exists because the channel story became clearer when split by
  flow step
- the folder names now say the sub-flow directly
- the file names now say the exact job directly
- the function names stay explicit so you can follow the story without guessing
