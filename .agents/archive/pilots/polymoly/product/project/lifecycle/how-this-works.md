---
title: project-lifecycle-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Project Lifecycle How This Works

## What this folder is

`product/project/lifecycle/` is the pipeline that manages interacting with an existing, running project.

It answers the human question "what is happening with my existing project right now?"

## Pipeline law in this folder

- `product/project/lifecycle/` is the whole existing-project flow.
- `lifecycle_pipeline.go` is the main orchestrator for lifecycle flows.
- `load_existing_project_context.go` ensures the canonical project structures can be loaded.
- File equals one responsibility.
- Function equals one exact action.

The canonical pipeline shape here is:

```text
lifecycle/
  lifecycle_pipeline.go
  load_existing_project_context.go
  access/
  control/
  logs/
```

## The lifecycle flow

The canonical lifecycle flow is:
1. **load** existing project context
2. **resolve** requested lifecycle story
3. **return** access / health / events answer

## Boundary Contracts

This folder has a strict boundary contract:

- **lifecycle MAY**: 
  - load an existing project context
  - resolve access URLs
  - check health/runtime drift
  - read runtime events
- **lifecycle MUST NOT**:
  - create or bootstrap a new project (like `create` does)
  - configure or mutate project intents (like `configure` does)
  - render a generalized system inspect surface or generate global pipelines

## Command to flow mapping

This mapping shows how real CLI commands map to this pipeline:

- `poly open`      -> `RunProjectAccessFlow(...)`
- `poly health`    -> `RunProjectHealthFlow(...)`
- `poly events`    -> `RunProjectEventsFlow(...)`

## Direct files in this folder

### `lifecycle_pipeline.go`

- `RunProjectAccessFlow(...)`
- `RunProjectHealthFlow(...)`
- `RunProjectEventsFlow(...)`

This is the canonical in-code orchestrator. It orchestrates routing the CLI commands to the respective domain.

### `load_existing_project_context.go`

- `LoadExistingProjectContext(...)`

Consolidated helper that loads the existing project context that the pipelines rely on.

## Child folders in this folder

### `access/`

Open [access/how-this-works.md](./access/how-this-works.md).
Owns logic regarding exposing or resolving running project service endpoints and URLs.
Contains:
- `open_project_endpoint.go`
- `resolve_service_endpoints.go`

### `control/`

Open [control/how-this-works.md](./control/how-this-works.md).
Owns the checks for system or runtime deployment health drifts.
Contains:
- `check_project_runtime_health.go`

### `logs/`

Open [logs/how-this-works.md](./logs/how-this-works.md).
Owns exposing the sequence of recorded project-level runtime events.
Contains:
- `read_project_runtime_events.go`

## Dictionary

<a id="dictionary-product"></a>
- `product`: The product surface is the human-facing side of PolyMoly. It groups behavior into stories a user can name.
<a id="dictionary-lifecycle"></a>
- `lifecycle`: Interactive observability elements related to a project that is actively configured and currently capable of running.
