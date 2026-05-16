---
title: product-inspect-diagnose-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Inspect Diagnose How This Works

## What this folder is

`product/inspect/diagnose/` is where PolyMoly explains what looks wrong and why.

It is the folder you open when a raw status read is not enough and you need a diagnosis story in plain language.

## Real commands that reach this folder

- `poly doctor [--json]`
- `poly review pack .`
- `poly history`

## Exact CLI front doors

- `system/tools/poly/internal/cli/route_root_commands.go`
- function: `RouteRootCommands(args []string) int`
- `poly status` -> `runStatus(...)` in `route_runtime_commands.go`
- `poly doctor` -> `runDoctor(...)` in `route_runtime_commands.go`
- `poly dashboard ...` -> `runDashboard(...)` in `expand_variable_placeholders.go`
- `poly logs` and `poly events` -> `runLogs(...)` and `runProjectEvents(...)` in `route_runtime_commands.go`

## The simplest story

- you type a real PolyMoly command, or a higher caller reaches this folder for one specific reason
- this folder opens the first direct file or child slice that does the next real job, often `ai_advisory.go`
- at the end, the caller has something concrete: a summary, an artifact, a proof, or a next step

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. you type the command, or a parent story hands this folder one honest job"]:::step1 --> B["2. the story opens the first real file or child slice, often `ai_advisory.go`"]:::step2
    B --> C["3. by the end, the user or caller gets something concrete back: output, artifact, proof, or next step"]:::step3
```

## The first important path

When you type:

```bash
poly doctor [--json]
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant Entry as RouteRootCommands
    participant Owned as CheckAgentReview
    participant Next as NextStep
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `product/inspect/diagnose/` through the current story
    Owned->>Owned: Step 2: call `CheckAgentReview(...)` to do the main folder-owned work
    Owned->>Next: Step 3: hand the concrete result to the next caller or boundary
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `ai_advisory.go` through `CheckAgentReview(...)`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

### `ai_advisory.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- its main action is still visible in the code, starting with `CheckAgentReview(...)`

When the story opens this file:

- when the `product/inspect/diagnose/` story needs this responsibility, it opens `ai_advisory.go`

What arrives here:

- caller-provided values from the parent flow

What leaves this file:

- the result of `CheckAgentReview(...)` for the next caller
- a concrete return value, file write, check result, or summary depending on the path

Why you open it first:

- open this file when the symptom points to `CheckAgentReview(...)` doing the wrong thing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as ai_advisory.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `ai_advisory.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `ai_advisory.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `Review(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `Architect(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `LoadPlan(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `Posture(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `Render(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `Marshal(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `CheckAgentReview(...)`
  This is the main action in the file. It does the folder's primary job and returns the next concrete result.

### `doctor_report.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- its main action is still visible in the code, starting with `PrepareDoctorReport(...)`

When the story opens this file:

- when the `product/inspect/diagnose/` story needs this responsibility, it opens `doctor_report.go`

What arrives here:

- caller-provided values from the parent flow

What leaves this file:

- the result of `PrepareDoctorReport(...)` for the next caller
- a concrete return value, file write, check result, or summary depending on the path

Why you open it first:

- open this file when the symptom points to `PrepareDoctorReport(...)` doing the wrong thing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as doctor_report.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `doctor_report.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `doctor_report.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `CheckRequiredToolchain(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `PrepareDoctorReport(...)`
  This is the main action in the file. It does the folder's primary job and returns the next concrete result.
- `WriteReport(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `PrintReport(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `fixSuggestion(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `addGHCRDistributionCheck(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `resolveGHCRToken(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `ghAuthScopes(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `containsScope(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `addToolCheck(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `addNamedToolCheck(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `addCommandProbe(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `addFileCheck(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `addCheck(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `addSidecarChecks(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `lookPathMessage(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `collectEnvFiles(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `collectProfiles(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `sanitizeTSV(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `blankIfEmpty(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `sortedKeys(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.

### `explain_state_logic.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- its main action is still visible in the code, starting with `ExplainPendingPlan(...)`

When the story opens this file:

- when the `product/inspect/diagnose/` story needs this responsibility, it opens `explain_state_logic.go`

What arrives here:

- caller-provided values from the parent flow

What leaves this file:

- the result of `ExplainPendingPlan(...)` for the next caller
- a concrete return value, file write, check result, or summary depending on the path

Why you open it first:

- open this file when the symptom points to `ExplainPendingPlan(...)` doing the wrong thing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as explain_state_logic.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `explain_state_logic.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `explain_state_logic.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `ExplainPendingPlan(...)`
  This is the main action in the file. It does the folder's primary job and returns the next concrete result.

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- start with `CheckAgentReview(...)` in `ai_advisory.go` when that action looks wrong
- start with `PrepareDoctorReport(...)` in `doctor_report.go` when that action looks wrong
- start with `ExplainPendingPlan(...)` in `explain_state_logic.go` when that action looks wrong

## What to remember

- `product/inspect/diagnose/` exists so this slice has one obvious home.
- The fastest map is still the naming law: folder for flow, file for responsibility, function for exact action.
- If the visible result is wrong, start with the first direct file that owns the next honest action in the flow.

## Dictionary

<a id="dictionary-product"></a>
- `product`: The product surface is the human-facing side of PolyMoly. It groups behavior into stories a user can name.
<a id="dictionary-command"></a>
- `command`: A command is the sentence the user types, like `poly install` or `poly status`. It is the thing that wakes the flow up.
<a id="dictionary-lane"></a>
- `lane`: A lane is one named stream of ownership. It tells you which folder should answer the next question.
<a id="dictionary-project"></a>
- `project`: A project is one real app workspace plus the `.polymoly/` sidecar that records what that workspace should become.
<a id="dictionary-intent"></a>
- `intent`: Intent is the desired project shape before the live runtime proves or disproves it.
<a id="dictionary-runtime"></a>
- `runtime`: Runtime is the live or rendered execution world PolyMoly starts, previews, reads, or validates.
<a id="dictionary-artifact"></a>
- `artifact`: An artifact is a file or bundle another step can read later, like a manifest, proof, package, or summary.
