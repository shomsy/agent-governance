---
title: project-configure-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Project Configure How This Works

## What this folder is

`product/project/configure/` is the pipeline that manages safe mutations to the current project's configuration state (the intent).

It answers the human question "how do I change what this project is supposed to be?"

## Pipeline law in this folder

- `product/project/configure/` is the whole mutation pipeline.
- `configure_pipeline.go` is the main orchestrator for configure flows.
- File equals one responsibility.
- Function equals one exact action.

The canonical pipeline shape here is:

```text
configure/
  configure_pipeline.go
  configure_pipeline_test.go
  configure_request_contract.go
  how-this-works.md
  baseline/
    prepare_configure_baseline_intent.go
  parse/
    parse_requested_set_mutations.go
    parse_requested_service_shorthands.go
  mutate/
    apply_configuration_mutations.go
    mutation_options.go
    preserve_explicit_template_overrides.go
  render/
    render_profile_upgrade_summary.go
  cache/
  database/
  profile/
  replace/
    replace_pipeline.go
    perform_scaffold_replace.go
    prepare_replace_preview.go
    replace_scaffold.go
```

## The configure flow

The canonical configure flow is:
1. **load** existing project intent
2. **prepare** baseline intent
3. **parse** requested mutations (set, add, replace)
4. **apply** mutations
5. **preserve** explicit overrides
6. **emit** normalized next intent

## Boundary Contracts

This folder has a strict boundary contract:

- **configure MAY**: 
  - load current project intent
  - prepare the next intent
  - parse mutation inputs
  - apply configuration changes safely
- **configure MUST NOT**:
  - bootstrap completely new projects (like `create`)
  - read or interpret live running system state (like `lifecycle` or `inspect`)
  - bypass explicit template override rules
  - perform hidden side effects on disk beyond saving the updated intent.

## Command to flow mapping

This mapping shows how real CLI commands map to this pipeline:

- `poly configure` -> `RunProjectConfigureFlow(...)`
- `poly set`       -> `RunProjectSetFlow(...)`
- `poly add`       -> `RunProjectAddFlow(...)`
- `poly replace`   -> `RunProjectReplaceFlow(...)`
- `poly apply`     -> `RunProjectApplyFlow(...)`

## Direct files in this folder

### `configure_pipeline.go`

- `RunProjectConfigureFlow(...)`
- `RunProjectSetFlow(...)`
- `RunProjectAddFlow(...)`
- `RunProjectReplaceFlow(...)`
- `RunProjectApplyFlow(...)`

This is the canonical in-code orchestrator. It orchestrates the configuration steps.

### `configure_request_contract.go`

Re-exports the canonical types used across this pipeline as package-level aliases:

- `MutationOptions` — alias for `mutate.MutationOptions`
- `TemplateResolver` — alias for `mutate.TemplateResolver`

This keeps the canonical type definition in `mutate/mutation_options.go` (where the struct fields live) while allowing callers to import `configure.MutationOptions` without reaching into the internal `mutate` package.

## Child folders in this folder

### `baseline/`

Owns baseline intent preparation.

Contains:

- `prepare_configure_baseline_intent.go` -> `PrepareConfigureBaselineIntent(...)`

### `parse/`

Owns mutation input parsing.

Contains:

- `parse_requested_set_mutations.go` -> `ParseRequestedSetMutations(...)`
- `parse_requested_service_shorthands.go` -> `ParseRequestedServiceShorthands(...)`

### `mutate/`

Owns mutation application, template override rules, and the canonical `MutationOptions` type.

Contains:

- `mutation_options.go` -> `MutationOptions`, `TemplateResolver` (canonical type definitions)
- `apply_configuration_mutations.go` -> `ApplyConfigurationMutations(...)`
- `preserve_explicit_template_overrides.go` -> `PreserveExplicitTemplateOverrides(...)`

### `render/`

Owns profile upgrade messaging.

Contains:

- `render_profile_upgrade_summary.go` -> `RenderProfileUpgradeSummary(...)`

### `cache/`

Handles the isolated cache specific mutation sub-pipeline logic.

### `database/`

Handles the isolated database specific mutation sub-pipeline logic.

### `profile/`

Handles the isolated profile specific mutation sub-pipeline logic.

### `replace/`

Open [replace/how-this-works.md](./replace/how-this-works.md).

The replace mini-pipeline. Owns the three-step scaffold replacement flow:

1. **resolve** target runtime via create law (`perform_scaffold_replace.go`)
2. **preview** the scaffold swap with backup (`prepare_replace_preview.go`)
3. **apply** the scaffold swap (`replace_scaffold.go`)

`replace_pipeline.go` is the thin orchestrator that wires these three steps together.
`configure_pipeline.go` calls `RunReplaceScaffoldFlow(...)` — it does not orchestrate replace steps directly.

Contains:

- `replace_pipeline.go` -> `RunReplaceScaffoldFlow(...)` (orchestrator)
- `perform_scaffold_replace.go` -> `ResolveRuntime(...)` (runtime bridge to create law)
- `prepare_replace_preview.go` -> `PrepareReplacePreview(...)` (backup + file diff)
- `replace_scaffold.go` -> `ReplaceScaffold(...)` (actual scaffold swap)

## Debug first

- start in `ParseRequestedSetMutations(...)` when raw `poly set` input is parsed wrong
- start in `ParseRequestedServiceShorthands(...)` when `poly add ...` behaves wrong
- start in `PrepareConfigureBaselineIntent(...)` when template-backed setup starts from the wrong base
- start in `PreserveExplicitTemplateOverrides(...)` when templates are being overridden too aggressively
- start in `ApplyConfigurationMutations(...)` when the resulting intent is wrong
- start in `RenderProfileUpgradeSummary(...)` when the user-facing upgrade note is wrong

## Dictionary

<a id="dictionary-configure"></a>
- `configure`: The act of mutating the intent structure prior to execution.
<a id="dictionary-intent"></a>
- `intent`: The project plan that capture the full configuration structure for the environment.
<a id="dictionary-override"></a>
- `override`: An explicit decision by the user to forcefully replace a structured configuration component (such as overriding a template value).
