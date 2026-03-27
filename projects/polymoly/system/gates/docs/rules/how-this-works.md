---
title: system-gates-docs-rules-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# System Gates Docs Rules How This Works

## What this folder is

`system/gates/docs/rules/` is one gate-specific slice.

This folder exists so one check family or gate fixture has a stable home that the runner and CI can point at.

## Real commands that reach this folder

- `poly gate run docs`
- `poly docs ...`

## Exact CLI front doors

- `system/tools/poly/cmd/poly/main.go`
- function: `main()`
- `poly gate run ...` -> `RunGateProfile(...)` in `system/tools/poly/internal/runner/run_gate_profile.go`
- `bash system/gates/run ...` wraps the same canonical gate profiles from shell entrypoints

## The simplest story

- a real `poly ...`, gate, or script entry reaches this tooling slice
- this folder owns one concrete tooling step, often starting with `polymoly.rules.json`
- the next tool step gets a report, summary, artifact, or exit decision from here

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. a real `poly ...`, gate, or script entry reaches this tooling slice"]:::step1 --> B["2. this folder owns one concrete tooling step, often starting with `polymoly.rules.json`"]:::step2
    B --> C["3. the next tool step gets a report, summary, artifact, or exit decision from here"]:::step3
```

## The first important path

When you type:

```bash
poly gate run docs
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant Entry as RunGateProfile
    participant Owned as polymoly.rules.json
    participant Next as NextStep
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `system/gates/docs/rules/` through the current story
    Owned->>Owned: Step 2: perform the folder-owned work in `polymoly.rules.json`
    Owned->>Next: Step 3: hand the concrete result to the next caller or boundary
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `polymoly.rules.json`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

### `polymoly.rules.json`

This file ships the `polymoly.rules.json` config, policy, or data asset that the next technical step reads directly.

Why this name is honest:

- the file name already tells you what concrete artifact or config lives here

When the story opens this file:

- when the `system/gates/docs/rules/` story needs this responsibility, it opens `polymoly.rules.json`

What arrives here:

- the next render, runtime, or browser step reads this shipped asset as-is

What leaves this file:

- the shipped `polymoly.rules.json` asset
- a concrete file the next render or runtime step can read directly

Why you open it first:

- open this file when the generated or shipped asset itself looks wrong

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as polymoly.rules.json
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `polymoly.rules.json`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `polymoly.rules.json` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

This file does not expose top-level functions. That is fine. The file itself is the artifact the next step reads.

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- start with `polymoly.rules.json` when the shipped asset or contract itself looks wrong

## What to remember

- `system/gates/docs/rules/` exists so this slice has one obvious home.
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
