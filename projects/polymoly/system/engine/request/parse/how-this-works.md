---
title: system-engine-request-parse-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# System Engine Request Parse How This Works

## What this folder is

`system/engine/request/parse/` does the sharp parsing and validation work inside request intake.

It is where raw user-facing input stops being loose text and becomes a checked request shape.

## Real commands or triggers that reach this folder

- preview, up, and gate flows after CLI routing chooses an engine path

## Exact upstream handoffs

- `system/tools/poly/internal/cli/route_project_commands.go` and `system/tools/poly/internal/runner/run_gate_profile.go` are common callers above engine request intake
- `ReadAndValidateUserRequest(...)` and the request child files take over once a higher story needs a validated engine request

## The simplest story

- a higher product, engine, or tooling story reaches this slice because it needs one reusable step
- this folder does one small machine-facing job, often starting in `read_and_validate_user_request.go`
- the next step gets something concrete back: a helper result, a rendered model, an adapter handoff, or a cleaner request

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. a higher story hands this slice one real machine job"]:::step1 --> B["2. this slice does one concrete machine job, often starting in `read_and_validate_user_request.go`"]:::step2
    B --> C["3. the next caller receives something concrete: checked input, rendered data, or a ready handoff"]:::step3
```

## The first important path

When a real caller reaches this slice for this exact reason:

```text
preview, up, and gate flows after CLI routing chooses an engine path
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant Entry as EngineCaller
    participant Owned as ReadAndValidateUserRequest
    participant Next as NextStep
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `system/engine/request/parse/` through the current story
    Owned->>Owned: Step 2: call `ReadAndValidateUserRequest(...)` to do the main folder-owned work
    Owned->>Next: Step 3: hand the concrete result to the next caller or boundary
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `read_and_validate_user_request.go` through `ReadAndValidateUserRequest(...)`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

### `read_and_validate_user_request.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- its main action is still visible in the code, starting with `ReadAndValidateUserRequest(...)`

When the story opens this file:

- when the `system/engine/request/parse/` story needs this responsibility, it opens `read_and_validate_user_request.go`

What arrives here:

- caller-provided values from the parent flow

What leaves this file:

- the result of `ReadAndValidateUserRequest(...)` for the next caller
- a concrete return value, file write, check result, or summary depending on the path

Why you open it first:

- open this file when the symptom points to `ReadAndValidateUserRequest(...)` doing the wrong thing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as read_and_validate_user_request.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `read_and_validate_user_request.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `read_and_validate_user_request.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `ReadAndValidateUserRequest(...)`
  This is the main action in the file. It does the folder's primary job and returns the next concrete result.
- `detectCapabilityInputKey(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `normalizeCapabilityInput(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `normalizeCapabilityList(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `normalizeCapabilityObject(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `result(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `mapOrDefault(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `canonicalizeDSL(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `toMap(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `stringValue(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `intLikeValue(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- start with `ReadAndValidateUserRequest(...)` in `read_and_validate_user_request.go` when that action looks wrong

## What to remember

- `system/engine/request/parse/` exists so this slice has one obvious home.
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
