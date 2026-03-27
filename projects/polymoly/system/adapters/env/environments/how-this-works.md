---
title: system-adapters-env-environments-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# System Adapters Env Environments How This Works

## What this folder is

`system/adapters/env/environments/` is one focused slice of PolyMoly.

This folder exists so one flow or one responsibility has an obvious home instead of being mixed into a wider bucket.

## Real commands or triggers that reach this folder

- engine apply and generate flows when PolyMoly must touch files, Docker, env files, or the browser

## Exact upstream handoffs

- `system/engine/apply/` and `system/engine/generate/render/` are the main upstream callers above this tree
- this folder becomes active when the engine is ready to touch Docker, files, env assets, or the browser for real

## The simplest story

- a higher product, engine, or tooling story reaches this slice because it needs one reusable step
- this folder does one small machine-facing job, often starting in `local.yaml`
- the next step gets something concrete back: a helper result, a rendered model, an adapter handoff, or a cleaner request

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. a higher story hands this slice one real machine job"]:::step1 --> B["2. this slice does one concrete machine job, often starting in `local.yaml`"]:::step2
    B --> C["3. the next caller receives something concrete: checked input, rendered data, or a ready handoff"]:::step3
```

## The first important path

When a real caller reaches this slice for this exact reason:

```text
engine apply and generate flows when PolyMoly must touch files, Docker, env files, or the browser
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant Entry as Caller
    participant Owned as local.yaml
    participant Next as NextStep
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `system/adapters/env/environments/` through the current story
    Owned->>Owned: Step 2: perform the folder-owned work in `local.yaml`
    Owned->>Next: Step 3: hand the concrete result to the next caller or boundary
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `local.yaml`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

### `local.yaml`

This file ships the `local.yaml` config, policy, or data asset that the next technical step reads directly.

Why this name is honest:

- the file name already tells you what concrete artifact or config lives here

When the story opens this file:

- when the `system/adapters/env/environments/` story needs this responsibility, it opens `local.yaml`

What arrives here:

- the next render, runtime, or browser step reads this shipped asset as-is

What leaves this file:

- the shipped `local.yaml` asset
- a concrete file the next render or runtime step can read directly

Why you open it first:

- open this file when the generated or shipped asset itself looks wrong

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as local.yaml
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `local.yaml`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `local.yaml` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

This file does not expose top-level functions. That is fine. The file itself is the artifact the next step reads.

### `managed.yaml`

This file ships the `managed.yaml` config, policy, or data asset that the next technical step reads directly.

Why this name is honest:

- the file name already tells you what concrete artifact or config lives here

When the story opens this file:

- when the `system/adapters/env/environments/` story needs this responsibility, it opens `managed.yaml`

What arrives here:

- the next render, runtime, or browser step reads this shipped asset as-is

What leaves this file:

- the shipped `managed.yaml` asset
- a concrete file the next render or runtime step can read directly

Why you open it first:

- open this file when the generated or shipped asset itself looks wrong

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as managed.yaml
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `managed.yaml`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `managed.yaml` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

This file does not expose top-level functions. That is fine. The file itself is the artifact the next step reads.

### `production.yaml`

This file ships the `production.yaml` config, policy, or data asset that the next technical step reads directly.

Why this name is honest:

- the file name already tells you what concrete artifact or config lives here

When the story opens this file:

- when the `system/adapters/env/environments/` story needs this responsibility, it opens `production.yaml`

What arrives here:

- the next render, runtime, or browser step reads this shipped asset as-is

What leaves this file:

- the shipped `production.yaml` asset
- a concrete file the next render or runtime step can read directly

Why you open it first:

- open this file when the generated or shipped asset itself looks wrong

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as production.yaml
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `production.yaml`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `production.yaml` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

This file does not expose top-level functions. That is fine. The file itself is the artifact the next step reads.

### `stage.yaml`

This file ships the `stage.yaml` config, policy, or data asset that the next technical step reads directly.

Why this name is honest:

- the file name already tells you what concrete artifact or config lives here

When the story opens this file:

- when the `system/adapters/env/environments/` story needs this responsibility, it opens `stage.yaml`

What arrives here:

- the next render, runtime, or browser step reads this shipped asset as-is

What leaves this file:

- the shipped `stage.yaml` asset
- a concrete file the next render or runtime step can read directly

Why you open it first:

- open this file when the generated or shipped asset itself looks wrong

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as stage.yaml
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `stage.yaml`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `stage.yaml` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

This file does not expose top-level functions. That is fine. The file itself is the artifact the next step reads.

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- start with `local.yaml` when the shipped asset or contract itself looks wrong
- start with `managed.yaml` when the shipped asset or contract itself looks wrong
- start with `production.yaml` when the shipped asset or contract itself looks wrong
- start with `stage.yaml` when the shipped asset or contract itself looks wrong

## What to remember

- `system/adapters/env/environments/` exists so this slice has one obvious home.
- The fastest map is still the naming law: folder for flow, file for responsibility, function for exact action.
- If the visible result is wrong, start with the first direct file that owns the next honest action in the flow.

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
