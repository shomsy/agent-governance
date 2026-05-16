---
title: system-tools-poly-internal-hardeningcheck-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# System Tools Poly Internal Hardeningcheck How This Works

## What this folder is

`system/tools/poly/internal/hardeningcheck/` is one internal Poly tooling slice.

This folder exists so one small tooling responsibility has an obvious home after the CLI or runner hands work into the internal tree.

## Real commands or triggers that reach this folder

- `poly status`
- `poly gate run docs`
- `poly review pack .`

## Exact upstream handoffs

- the CLI, runner, gates, and shipped runtime assets all eventually hand work into this tree
- open the narrower child slice once you know whether the story is product, engine, adapter, shared, runtime, gate, or tooling work

## The simplest story

- a real `poly ...`, gate, or script entry reaches this tooling slice
- this folder owns one concrete tooling step, often starting with `check_advanced_hardening.go`
- the next tool step gets a report, summary, artifact, or exit decision from here

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. a real `poly ...`, gate, or script entry reaches this tooling slice"]:::step1 --> B["2. this folder owns one concrete tooling step, often starting with `check_advanced_hardening.go`"]:::step2
    B --> C["3. the next tool step gets a report, summary, artifact, or exit decision from here"]:::step3
```

## The first important path

When a real caller reaches this slice for this exact reason:

```bash
poly status
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant Entry as Caller
    participant Owned as CheckImageHardening
    participant Next as NextStep
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `system/tools/poly/internal/hardeningcheck/` through the current story
    Owned->>Owned: Step 2: call `CheckImageHardening(...)` to do the main folder-owned work
    Owned->>Next: Step 3: hand the concrete result to the next caller or boundary
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `check_advanced_hardening.go` through `CheckImageHardening(...)`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

### `check_advanced_hardening.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- its main action is still visible in the code, starting with `CheckImageHardening(...)`

When the story opens this file:

- when the `system/tools/poly/internal/hardeningcheck/` story needs this responsibility, it opens `check_advanced_hardening.go`

What arrives here:

- caller-provided values from the parent flow

What leaves this file:

- the result of `CheckImageHardening(...)` for the next caller
- a concrete return value, file write, check result, or summary depending on the path

Why you open it first:

- open this file when the symptom points to `CheckImageHardening(...)` doing the wrong thing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as check_advanced_hardening.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `check_advanced_hardening.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `check_advanced_hardening.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `CheckZeroTrustPosture(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `CheckImageHardening(...)`
  This is the main action in the file. It does the folder's primary job and returns the next concrete result.
- `assertPattern(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.

### `check_core_hardening.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- its main action is still visible in the code, starting with `CheckCoreHardening(...)`

When the story opens this file:

- when the `system/tools/poly/internal/hardeningcheck/` story needs this responsibility, it opens `check_core_hardening.go`

What arrives here:

- caller-provided values from the parent flow

What leaves this file:

- the result of `CheckCoreHardening(...)` for the next caller
- a concrete return value, file write, check result, or summary depending on the path

Why you open it first:

- open this file when the symptom points to `CheckCoreHardening(...)` doing the wrong thing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as check_core_hardening.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `check_core_hardening.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `check_core_hardening.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `CheckCoreHardening(...)`
  This is the main action in the file. It does the folder's primary job and returns the next concrete result.
- `checkNoLatest(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `checkComposeBaseline(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `checkHealthchecks(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `checkUserContract(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `checkDockerSocket(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `extractTopLevelServices(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `checkResourceLimits(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `extractServicesWithDeploy(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `checkSecretHygiene(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `checkVaultTLS(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `checkNetworkIsolation(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `extractServicesWithNetwork(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `checkSecretFiles(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `checkImagePins(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `checkPoolingDockerfiles(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- start with `CheckImageHardening(...)` in `check_advanced_hardening.go` when that action looks wrong
- start with `CheckCoreHardening(...)` in `check_core_hardening.go` when that action looks wrong

## What to remember

- `system/tools/poly/internal/hardeningcheck/` exists so this slice has one obvious home.
- The fastest map is still the naming law: folder for flow, file for responsibility, function for exact action.
- If the visible result is wrong, start with the first direct file that owns the next honest action in the flow.

## Dictionary

<a id="dictionary-command"></a>
- `command`: A command is the exact CLI sentence that starts the flow.
<a id="dictionary-gate"></a>
- `gate`: A gate is one named verification profile or check that decides whether trust can increase.
<a id="dictionary-review-pack"></a>
- `review pack`: A review pack is the merged workspace snapshot PolyMoly writes so a reviewer can inspect one deterministic bundle.
<a id="dictionary-artifact"></a>
- `artifact`: An artifact is a summary, report, bundle, or receipt another tool can read later.
<a id="dictionary-summary"></a>
- `summary`: A summary is the short machine-readable or operator-readable result a tool writes after it finishes.
<a id="dictionary-runtime"></a>
- `runtime`: Runtime here means the source-native CLI or external process world the tool starts or inspects.
