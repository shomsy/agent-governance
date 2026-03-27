---
title: system-engine-generate-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# System Engine Generate How This Works

## What this folder is

`system/engine/generate/` is where the engine builds the render model and the files later write steps need.

It sits between resolution and file-system or runtime mutation. It turns chosen modules into concrete render-ready output.

## Real commands or triggers that reach this folder

- render flows after module resolution succeeds

## Exact upstream handoffs

- `system/engine/resolve/` hands chosen modules and service graph data into this folder
- `MakeFinalRenderModel(...)` and render-side files take over once the engine is ready to produce concrete output`

## The simplest story

- a higher product, engine, or tooling story reaches this slice because it needs one reusable step
- this folder does one small machine-facing job, often starting in `make_final_render_model.go`
- the next step gets something concrete back: a helper result, a rendered model, an adapter handoff, or a cleaner request

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. a higher story hands this slice one real machine job"]:::step1 --> B["2. this slice does one concrete machine job, often starting in `make_final_render_model.go`"]:::step2
    B --> C["3. the next caller receives something concrete: checked input, rendered data, or a ready handoff"]:::step3
```

## The first important path

When a real caller reaches this slice for this exact reason:

```text
render flows after module resolution succeeds
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant Entry as EngineCaller
    participant Owned as MakeFinalRenderModel
    participant Next as models/
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `system/engine/generate/` through the current story
    Owned->>Owned: Step 2: call `MakeFinalRenderModel(...)` to do the main folder-owned work
    Owned->>Next: Step 3: hand the result to the next narrower slice
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `make_final_render_model.go` through `MakeFinalRenderModel(...)`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

### `make_final_render_model.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- its main action is still visible in the code, starting with `MakeFinalRenderModel(...)`

When the story opens this file:

- when the `system/engine/generate/` story needs this responsibility, it opens `make_final_render_model.go`

What arrives here:

- caller-provided values from the parent flow
- config or model values that need to be normalized, rendered, or checked

What leaves this file:

- the result of `MakeFinalRenderModel(...)` for the next caller
- a concrete return value, file write, check result, or summary depending on the path

Why you open it first:

- open this file when the symptom points to `MakeFinalRenderModel(...)` doing the wrong thing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as make_final_render_model.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `make_final_render_model.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `make_final_render_model.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `MakeFinalRenderModel(...)`
  This is the main action in the file. It does the folder's primary job and returns the next concrete result.
- `CompareModelsForChanges(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `semanticallyEqual(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `normalizeService(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `sortNamed(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `orderedCompatibilityEnv(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `toAny(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `mapsToAny(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `intValue(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `anyToMapSlice(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `toCompatibilityEntries(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.

## Child folders in this folder

### `models/`

Open [`models/how-this-works.md`](./models/how-this-works.md).

Use it when the story includes:

- render flows after module resolution succeeds

### `render/`

Open [`render/how-this-works.md`](./render/how-this-works.md).

Use it when the story includes:

- render flows after module resolution succeeds

## Debug first

- start with `MakeFinalRenderModel(...)` in `make_final_render_model.go` when that action looks wrong

## What to remember

- `system/engine/generate/` exists so this slice has one obvious home.
- The fastest map is still the naming law: folder for flow, file for responsibility, function for exact action.
- If the folder overview feels too wide, jump to the child slice that matches the current symptom instead of reading sideways.

## Dictionary

<a id="dictionary-system"></a>
- `system`: The system is the machine-facing body of PolyMoly. It holds the code, assets, checks, and boundaries that make product stories real.
<a id="dictionary-engine"></a>
- `engine`: The engine is the decision core. It reads intent, matches capabilities, prepares render data, and hands safe work to the next layer.
<a id="dictionary-adapter"></a>
- `adapter`: An adapter is the place where PolyMoly touches the outside world, like files, Docker, environment files, or the browser.
<a id="dictionary-gate"></a>
- `gate`: A gate is a verification run that decides PASS or FAIL before trust increases.
<a id="dictionary-artifact"></a>
- `artifact`: An artifact is a file, bundle, or proof another tool or operator can read later.
<a id="dictionary-runtime"></a>
- `runtime`: Runtime is the live or rendered execution world PolyMoly starts, previews, inspects, or validates.
