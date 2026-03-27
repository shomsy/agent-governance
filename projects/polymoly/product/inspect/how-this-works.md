---
title: product-inspect-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Inspect How This Works

## What this folder is

`product/inspect/` is the product lane for reading, explaining, and previewing system state before the user changes anything.

It answers the human question "what is happening right now?" and guides the user toward a diagnosis or a preview of what's to come.

## Pipeline law in this folder

- `product/inspect/` is the whole inspect flow.
- `inspect_pipeline.go` is the main inspect orchestrator.
- `observe/` is the step that reads live truth.
- `diagnose/` is the step that explains observed truth.
- `preview/` is the step that shows future truth.
- File equals one responsibility inside that step.
- Function equals one exact action.

The canonical pipeline shape here is:

```text
inspect/
  inspect_pipeline.go
  observe/
  diagnose/
  preview/
```

## The inspect flow

The canonical inspect flow is:
1. **observe** live truth
2. **diagnose** observed truth
3. **preview** future truth

Unlike `deploy`, the inspect flow is not strictly linear for every command:
- A `status` command can stop at `observe`.
- A `doctor` command flows `observe -> diagnose`.
- A `preview/diff/impact` command targets `preview`.
- The dashboard remains an `observation-facing` surface.

## Boundary Contracts

Each step has a strict boundary contract defined in its main file to prevent logic from leaking:

- **observe**: `MAY` read project/runtime state, summarize status, list services, collect metrics/activity. `MUST NOT` mutate project state or generate future preview outputs.
- **diagnose**: `MAY` explain what looks wrong, prepare doctor reports, format AI advisories. `MUST NOT` replace observation (live runtime discovery) or preview responsibilities, and `MUST NOT` mutate the system.
- **preview**: `MAY` read pending plan logic, compute impact, render execution preview state and diffs. `MUST NOT` perform live runtime observation or diagnose/mutate system state.

## Command to flow mapping

This mapping shows how real CLI commands map to the inspect pipeline orchestration:

- `poly status`   -> `observe`
- `poly services` -> `observe`
- `poly graph`    -> `observe`
- `poly logs`     -> `observe`
- `poly events`   -> `observe`
- `poly doctor`   -> `observe -> diagnose`
- `poly explain`  -> `observe -> diagnose`
- `poly preview`  -> `observe? -> preview`
- `poly diff`     -> `preview`
- `poly impact`   -> `preview`

## Direct files in this folder

### `inspect_pipeline.go`

- `RunInspectStatusFlow(...)`
- `RunInspectDoctorFlow(...)`
- `RunInspectLogsFlow(...)`
- `RunInspectGraphFlow(...)`
- `RunInspectPreviewFlow(...)`

This is the canonical in-code orchestration map for the inspect pipeline. It routes the CLI commands to the correct step layer without swallowing their business logic.

## Child folders in this folder

### `observe/`

This step owns reading and summarizing the live runtime context.

Key functions:
- `DescribeRuntimeDelta()`
- `CollectRuntimeMetrics()`
- `CollectRuntimeEvents()`
- `DiscoverServices()`

### `diagnose/`

This step owns explaining the observed system truth.

Key functions:
- `PrepareDoctorReport()`
- `GenerateAIAdvisory()`

### `preview/`

This step owns computing and showing future system truth before mutation.

Key functions:
- `LoadPendingPlan()`
- `SummarizeImpact()`
- `Diff()`

## What to remember

- `product/inspect/` exists so this slice has one obvious home.
- The fastest map is still the naming law: folder for flow, file for responsibility, function for exact action.
- The root orchestrator is thin. It routes flows but does not do the reading, explaining, or formatting itself.

## Dictionary

<a id="dictionary-product"></a>
- `product`: The product surface is the human-facing side of PolyMoly. It groups behavior into stories a user can name.
<a id="dictionary-command"></a>
- `command`: A command is the sentence the user types, like `poly install` or `poly status`. It is the thing that wakes the flow up.
<a id="dictionary-lane"></a>
- `lane`: A lane is one named stream of ownership. It tells you which folder should answer the next question.
<a id="dictionary-project"></a>
- `project`: A project is one real app workspace plus the `.polymoly/` sidecar that records what that workspace should become.
<a id="dictionary-runtime"></a>
- `runtime`: Runtime is the live or rendered execution world PolyMoly starts, previews, reads, or validates.
<a id="dictionary-artifact"></a>
- `artifact`: An artifact is a file or bundle another step can read later, like a manifest, proof, package, or summary.
