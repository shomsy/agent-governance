---
title: system-engine-resolve-capability-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# System Engine Resolve Capability How This Works

## What this folder is

`system/engine/resolve/capability/` is where capability matching becomes a concrete module decision.

It answers small but important questions like which shipped capability or module belongs to this request.

## Real commands or triggers that reach this folder

- engine flows after request intake proves a valid desired shape

## Exact upstream handoffs

- `system/engine/request/` hands validated request state into this folder once intake is complete
- `ResolveRequestedModules(...)` and neighboring resolve files decide which shipped modules and services belong next`

## The simplest story

- a higher product, engine, or tooling story reaches this slice because it needs one reusable step
- this folder does one small machine-facing job, often starting in `match_capabilities_to_modules.go`
- the next step gets something concrete back: a helper result, a rendered model, an adapter handoff, or a cleaner request

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. a higher story hands this slice one real machine job"]:::step1 --> B["2. this slice does one concrete machine job, often starting in `match_capabilities_to_modules.go`"]:::step2
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
    participant Owned as MatchCapabilitiesToModules
    participant Next as NextStep
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `system/engine/resolve/capability/` through the current story
    Owned->>Owned: Step 2: call `MatchCapabilitiesToModules(...)` to do the main folder-owned work
    Owned->>Next: Step 3: hand the concrete result to the next caller or boundary
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `match_capabilities_to_modules.go` through `MatchCapabilitiesToModules(...)`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

### `match_capabilities_to_modules.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- its main action is still visible in the code, starting with `MatchCapabilitiesToModules(...)`

When the story opens this file:

- when the `system/engine/resolve/capability/` story needs this responsibility, it opens `match_capabilities_to_modules.go`

What arrives here:

- caller-provided values from the parent flow

What leaves this file:

- the result of `MatchCapabilitiesToModules(...)` for the next caller
- a concrete return value, file write, check result, or summary depending on the path

Why you open it first:

- open this file when the symptom points to `MatchCapabilitiesToModules(...)` doing the wrong thing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as match_capabilities_to_modules.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `match_capabilities_to_modules.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `match_capabilities_to_modules.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `MatchCapabilitiesToModules(...)`
  This is the main action in the file. It does the folder's primary job and returns the next concrete result.
- `selectProviders(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `buildCapabilitySettings(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `capabilityKnobValueIsValid(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `allowedEnumValues(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `enforceCapabilityConstraints(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `providerSupportsCapabilitySettings(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `buildGraph(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `applyProfileDefaults(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `applyModuleDefaultsAndAssets(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `applyEnvironmentRules(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `applyUserOverrides(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `applyPolicyEnforcement(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `checkLockMatch(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `emitUnusedCapabilityWarning(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `mergeNamedItems(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `listToEnvMap(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `lockModules(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `failResult(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `containsString(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `toAnySlice(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- start with `MatchCapabilitiesToModules(...)` in `match_capabilities_to_modules.go` when that action looks wrong

## What to remember

- `system/engine/resolve/capability/` exists so this slice has one obvious home.
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
