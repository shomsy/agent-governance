---
title: system-tools-poly-internal-runner-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# System Tools Poly Internal Runner How This Works

## What this folder is

`system/tools/poly/internal/runner/` runs named gate profiles and other step-by-step internal command batches.

When PolyMoly needs to execute a sequence of checks or commands with a summary and exit decision, this folder usually owns that handoff.

## Real commands or triggers that reach this folder

- `poly gate run docs`
- `poly gate run p0`
- `poly review pack .`

## Exact upstream handoffs

- `system/tools/poly/internal/cli/route_root_commands.go` and gate entrypoints reach this folder when a named profile must run as ordered steps
- `RunGateProfile(...)` is the first file-function pair to inspect when gate profile execution looks wrong`

## The simplest story

- a real `poly ...`, gate, or script entry reaches this tooling slice
- this folder owns one concrete tooling step, often starting with `run_gate_profile.go`
- the next tool step gets a report, summary, artifact, or exit decision from here

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. a real `poly ...`, gate, or script entry reaches this tooling slice"]:::step1 --> B["2. this folder owns one concrete tooling step, often starting with `run_gate_profile.go`"]:::step2
    B --> C["3. the next tool step gets a report, summary, artifact, or exit decision from here"]:::step3
```

## The first important path

When a real caller reaches this slice for this exact reason:

```bash
poly gate run docs
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant Entry as Caller
    participant Owned as RunGateProfile
    participant Next as NextStep
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `system/tools/poly/internal/runner/` through the current story
    Owned->>Owned: Step 2: call `RunGateProfile(...)` to do the main folder-owned work
    Owned->>Next: Step 3: hand the concrete result to the next caller or boundary
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `run_gate_profile.go` through `RunGateProfile(...)`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

### `execute_task_runner_test.go`

This test file locks one real behavior in this folder and fails loudly when that behavior drifts.

Why this name is honest:

- its main action is still visible in the code, starting with `TestRunStepsFailsWhenSummaryWriteFails(...)`

When the story opens this file:

- when the `system/tools/poly/internal/runner/` story needs this responsibility, it opens `execute_task_runner_test.go`

What arrives here:

- caller-provided values from the parent flow

What leaves this file:

- test proof for one regression shape
- clear failure when the behavior drifts

Why you open it first:

- a test case in this file is the fastest proof of the contract that drifted

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as execute_task_runner_test.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `execute_task_runner_test.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `execute_task_runner_test.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `TestRunStepsFailsWhenSummaryWriteFails(...)`
  One proof case in this file. It locks one expected behavior so a regression fails loudly.

### `run_gate_profile.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- its main action is still visible in the code, starting with `RunGateProfile(...)`

When the story opens this file:

- when the `system/tools/poly/internal/runner/` story needs this responsibility, it opens `run_gate_profile.go`

What arrives here:

- caller-provided values from the parent flow

What leaves this file:

- the result of `RunGateProfile(...)` for the next caller
- a concrete return value, file write, check result, or summary depending on the path

Why you open it first:

- open this file when the symptom points to `RunGateProfile(...)` doing the wrong thing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as run_gate_profile.go
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `run_gate_profile.go`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `run_gate_profile.go` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

- `String(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `Set(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `RunGateProfile(...)`
  This is the main action in the file. It does the folder's primary job and returns the next concrete result.
- `runSteps(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `normalizeArgs(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.
- `printProfiles(...)`
  Small helper for one narrow sub-step. It exists so the main path stays readable.

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- start with `TestRunStepsFailsWhenSummaryWriteFails(...)` in `execute_task_runner_test.go` when that action looks wrong
- start with `RunGateProfile(...)` in `run_gate_profile.go` when that action looks wrong

## What to remember

- `system/tools/poly/internal/runner/` exists so this slice has one obvious home.
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
