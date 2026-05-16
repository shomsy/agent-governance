---
title: system-engine-resolve-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# System Engine Resolve How This Works

## What this folder is

`system/engine/resolve/` is where the engine matches desired shape to shipped modules, policies, and service graph decisions.

This folder is the “what should we actually use?” step after request intake is finished.

## Real commands or triggers that reach this folder

- engine flows after request intake proves a valid desired shape

## Exact upstream handoffs

- `system/engine/request/` hands validated request state into this folder once intake is complete
- `ResolveRequestedModules(...)` and neighboring resolve files decide which shipped modules and services belong next`

## The simplest story

- a higher product, engine, or tooling story reaches this slice because it needs one reusable step
- this folder does one small machine-facing job, often starting in `resolve_requested_modules.go`
- the next step gets something concrete back: a helper result, a rendered model, an adapter handoff, or a cleaner request

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. a higher story hands this slice one real machine job"]:::step1 --> B["2. this slice does one concrete machine job, often starting in `resolve_requested_modules.go`"]:::step2
    B --> C["3. the next caller receives something concrete: checked input, rendered data, or a ready handoff"]:::step3
```

## The first important path

When a real caller reaches this slice for this exact reason:

```text
engine flows after request intake proves a valid desired shape
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant Entry as EngineCaller
    participant Owned as ResolveRequestedModules
    participant Next as capability/
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `system/engine/resolve/` through the current story
    Owned->>Owned: Step 2: call `ResolveRequestedModules(...)` to do the main folder-owned work
    Owned->>Next: Step 3: hand the result to the next narrower slice
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `resolve_requested_modules.go` through `ResolveRequestedModules(...)`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

### `map_service_graph.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- its main action is still visible in the code, starting with `MapServiceGraph(...)`

When the story opens this file:

- when the `system/engine/resolve/` story needs this responsibility, it opens `map_service_graph.go`

What arrives here:

- caller-provided values from the parent flow

What leaves this file:

- the result of `MapServiceGraph(...)` for the next caller
- a concrete return value, file write, check result, or summary depending on the path

Why you open it first:

- open this file when the symptom points to `MapServiceGraph(...)` doing the wrong thing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as map_service_graph.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `map_service_graph.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `map_service_graph.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `MapServiceGraph(...)`
  This is the main action in the file. It does the folder's primary job and returns the next concrete result.

### `merge_execution_policies.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- its main action is still visible in the code, starting with `EffectiveIntent(...)`

When the story opens this file:

- when the `system/engine/resolve/` story needs this responsibility, it opens `merge_execution_policies.go`

What arrives here:

- caller-provided values from the parent flow

What leaves this file:

- the result of `EffectiveIntent(...)` for the next caller
- a concrete return value, file write, check result, or summary depending on the path

Why you open it first:

- open this file when the symptom points to `EffectiveIntent(...)` doing the wrong thing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as merge_execution_policies.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `merge_execution_policies.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `merge_execution_policies.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `EffectiveIntent(...)`
  This is the main action in the file. It does the folder's primary job and returns the next concrete result.

### `resolve_requested_modules.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- its main action is still visible in the code, starting with `ResolveRequestedModules(...)`

When the story opens this file:

- when the `system/engine/resolve/` story needs this responsibility, it opens `resolve_requested_modules.go`

What arrives here:

- caller-provided values from the parent flow

What leaves this file:

- the result of `ResolveRequestedModules(...)` for the next caller
- a concrete return value, file write, check result, or summary depending on the path

Why you open it first:

- open this file when the symptom points to `ResolveRequestedModules(...)` doing the wrong thing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as resolve_requested_modules.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `resolve_requested_modules.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `resolve_requested_modules.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `ResolveRequestedModules(...)`
  This is the main action in the file. It does the folder's primary job and returns the next concrete result.

## Child folders in this folder

### `capability/`

Open [`capability/how-this-works.md`](./capability/how-this-works.md).

Use it when the story includes:

- engine flows after request intake proves a valid desired shape

## Debug first

- start with `MapServiceGraph(...)` in `map_service_graph.go` when that action looks wrong
- start with `EffectiveIntent(...)` in `merge_execution_policies.go` when that action looks wrong
- start with `ResolveRequestedModules(...)` in `resolve_requested_modules.go` when that action looks wrong

## What to remember

- `system/engine/resolve/` exists so this slice has one obvious home.
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
