---
title: system-runtime-capabilities-identity-contract-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# System Runtime Capabilities Identity Contract How This Works

## What this folder is

`system/runtime/capabilities/identity/contract/` holds the contract files that describe this capability to the rest of the system.

This is the narrow truth surface the engine reads before it decides whether the capability belongs to the current plan.

## Real commands or triggers that reach this folder

- `poly up`
- `poly status`
- `poly gate run p0`
- engine resolve and generate flows after a capability is selected

## Exact upstream handoffs

- `system/engine/resolve/capability/match_capabilities_to_modules.go` and `system/engine/generate/make_final_render_model.go` are the main callers above this shipped capability tree
- once the engine selects a capability or module, this folder provides the config, templates, images, and defaults the render path reads next

## The simplest story

- a higher engine or render flow has already decided this shipped runtime slice matters
- this folder contributes concrete assets or defaults, often starting with `capability.yaml`
- the next render, build, or runtime step reads those shipped files and turns them into concrete output

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. a higher engine or render flow has already decided this shipped runtime slice matters"]:::step1 --> B["2. this folder contributes concrete assets or defaults, often starting with `capability.yaml`"]:::step2
    B --> C["3. the next render, build, or runtime step reads those shipped files and turns them into concrete output"]:::step3
```

## The first important path

When a real caller reaches this slice for this exact reason:

```bash
poly up
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant Entry as ResolveAndRender
    participant Owned as capability.yaml
    participant Next as NextStep
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `system/runtime/capabilities/identity/contract/` through the current story
    Owned->>Owned: Step 2: perform the folder-owned work in `capability.yaml`
    Owned->>Next: Step 3: hand the concrete result to the next caller or boundary
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `capability.yaml`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

### `capability.yaml`

This file ships the `capability.yaml` config, policy, or data asset that the next technical step reads directly.

Why this name is honest:

- the file name already tells you what concrete artifact or config lives here

When the story opens this file:

- when the `system/runtime/capabilities/identity/contract/` story needs this responsibility, it opens `capability.yaml`

What arrives here:

- the next render, runtime, or browser step reads this shipped asset as-is

What leaves this file:

- the shipped `capability.yaml` asset
- a concrete file the next render or runtime step can read directly

Why you open it first:

- open this file when the generated or shipped asset itself looks wrong

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as capability.yaml
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `capability.yaml`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `capability.yaml` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

This file does not expose top-level functions. That is fine. The file itself is the artifact the next step reads.

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- start with `capability.yaml` when the shipped asset or contract itself looks wrong

## What to remember

- `system/runtime/capabilities/identity/contract/` exists so this slice has one obvious home.
- The fastest map is still the naming law: folder for flow, file for responsibility, function for exact action.
- If the visible result is wrong, start with the first direct file that owns the next honest action in the flow.

## Dictionary

<a id="dictionary-capability"></a>
- `capability`: A capability is one shipped building block PolyMoly can add to a project, like app, database, cache, or gateway.
<a id="dictionary-module"></a>
- `module`: A module is one packaged implementation of a capability. It usually carries images, config, templates, and defaults together.
<a id="dictionary-rendered-file"></a>
- `rendered file`: A rendered file is the concrete output the engine writes after it reads templates, config, and selected modules.
<a id="dictionary-runtime"></a>
- `runtime`: Runtime is the live or rendered world these shipped assets eventually shape.
<a id="dictionary-artifact"></a>
- `artifact`: An artifact is a generated or shipped file another step reads later, such as a Dockerfile, config file, or manifest.
