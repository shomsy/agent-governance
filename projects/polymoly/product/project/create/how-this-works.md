---
title: project-create-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Project Create How This Works

## What this folder is

`product/project/create/` is the pipeline that turns "I want a project" into a real directory, starter skeleton, and initial sidecar intent.

It answers the human question "how do I bring a new project into existence?" and forms the canonical bootstrap flow.

## Pipeline law in this folder

- `product/project/create/` is the whole create pipeline.
- `create_pipeline.go` is the main orchestrator for create flows.
- File equals one responsibility.
- Function equals one exact action.

The canonical pipeline shape here is:

```text
create/
  create_pipeline.go
  create_pipeline_test.go
  create_request_contract.go
  how-this-works.md
  runtime/
    resolve_scaffold_runtime.go
  scaffold/
    ensure_target_directory_is_safe.go
    write_project_starter.go
  template/
  wizard/
  testdata/
```

## The create flow

The canonical structural create flow is:
1. **accept** create request
2. **resolve** scaffold runtime and starter choice
3. **validate** target directory
4. **write** starter skeleton files
5. **return** managed project outcome

## Boundary Contracts

This folder has a strict boundary contract:

- **create MUST**: 
  - receive create requests (new, init)
  - resolve templates, prompts, and runtimes
  - validate target directory safety
  - write the initial scaffold and project structure
- **create MUST NOT**:
  - mutate existing explicit project configuration like `configure` does
  - read or interpret live running system state like `lifecycle` does
  - hide side effects outside of the `.polymoly/` sidecar and the explicit `src/` directory.

## Command to flow mapping

This mapping shows how real CLI commands map to this pipeline:

- `poly new`      -> `RunProjectNewFlow(...)`
- `poly init`     -> `RunProjectInitFlow(...)`
- `poly wizard`   -> `RunProjectWizardFlow(...)`
- `poly template` -> `template.RunProjectTemplateFlow(...)`

## Direct files in this folder

### `create_pipeline.go`

- `RunProjectNewFlow(...)`
- `RunProjectInitFlow(...)`
- `RunProjectWizardFlow(...)`

This is the canonical in-code orchestrator. It manages the steps but delegates the actual logic (resolving, writing) to the specialized files.

### `create_request_contract.go`

Holds the data structures that shape the incoming CLI boundaries:

- `NewRequest` — parameters for `poly new`
- `InitRequest` — parameters for `poly init`
- `WizardAnswers` — the answer set from the wizard flow
- `WizardPreview`, `WizardRequest`, `WizardResult` — wizard flow contracts

## Child folders in this folder

### `testdata/`

Contains example starter trees (`examples/go-service/`, `examples/php-laravel-api/`) used by `create_pipeline_test.go` and `template/template_pipeline_test.go`.


### `scaffold/`

Owns reusable starter-copy logic shared by create flows and replace bridges.

Contains:

- `ensure_target_directory_is_safe.go` -> `EnsureEmptyOrReplace(...)`
- `write_project_starter.go` -> `WriteStarter(...)`

### `runtime/`

Owns runtime inference logic reused by create and replace flows.

Contains:

- `resolve_scaffold_runtime.go` -> `ResolveScaffoldRuntime(...)`

### `template/`

Open [template/how-this-works.md](./template/how-this-works.md).
Owns template catalog, resolution, and install pipeline entrypoints.

### `wizard/`

Open [wizard/how-this-works.md](./wizard/how-this-works.md).
Owns interactive guided prompt workflows.

## Debug first

- start with `ResolveScaffoldRuntime(...)` when the language or framework is inferred incorrectly
- start with `EnsureEmptyOrReplace(...)` if creation prevents writing to the disk unnecessarily
- start with `WriteStarter(...)` if the initial app code is placed incorrectly

## Dictionary

<a id="dictionary-product"></a>
- `product`: The product surface is the human-facing side of PolyMoly. It groups behavior into stories a user can name.
<a id="dictionary-create"></a>
- `create`: Create means "make the first usable version of the project."
<a id="dictionary-scaffold"></a>
- `scaffold`: A scaffold is the starter code PolyMoly writes into `src/`.
<a id="dictionary-runtime"></a>
- `runtime`: The main app technology PolyMoly will scaffold for, such as `php`, `node`, `go`, or `fullstack`.
