---
title: system-shared-config-platform-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# System Shared Config Platform How This Works

## What this folder is

`system/shared/config/platform/` is one focused slice of PolyMoly.

This folder exists so one flow or one responsibility has an obvious home instead of being mixed into a wider bucket.

## Real commands or triggers that reach this folder

- engine, tools, and adapters call this shared slice instead of copying the same helpers

## Exact upstream handoffs

- engine, tooling, and adapters call this shared tree instead of re-implementing the same helpers
- once you know the helper family, jump into the narrower child slice for config, CLI, logging, errors, or utilities

## The simplest story

- a higher product, engine, or tooling story reaches this slice because it needs one reusable step
- this folder does one small machine-facing job, often starting in `global-policies/`
- the next step gets something concrete back: a helper result, a rendered model, an adapter handoff, or a cleaner request

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. a higher story hands this slice one real machine job"]:::step1 --> B["2. this slice does one concrete machine job, often starting in `global-policies/`"]:::step2
    B --> C["3. the next caller receives something concrete: checked input, rendered data, or a ready handoff"]:::step3
```

## The first important path

When a real caller reaches this slice for this exact reason:

```text
engine, tools, and adapters call this shared slice instead of copying the same helpers
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant Entry as Caller
    participant Owned as global-policies/
    participant Next as NarrowerFlow
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `system/shared/config/platform/` through the current story
    Owned->>Owned: Step 2: hand the story into `global-policies/` because that child slice owns the first concrete step
    Owned->>Next: Step 3: let `global-policies/` continue the concrete file and function work
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `global-policies/`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

This folder has no direct first-party files besides this guide.

## Child folders in this folder

### `global-policies/`

Open [`global-policies/how-this-works.md`](./global-policies/how-this-works.md).

Use it when the story includes:

- engine, tools, and adapters call this shared slice instead of copying the same helpers

### `posture-matrix/`

Open [`posture-matrix/how-this-works.md`](./posture-matrix/how-this-works.md).

Use it when the story includes:

- engine, tools, and adapters call this shared slice instead of copying the same helpers

### `registry/`

Open [`registry/how-this-works.md`](./registry/how-this-works.md).

Use it when the story includes:

- engine, tools, and adapters call this shared slice instead of copying the same helpers

## Debug first

- open `global-policies/how-this-works.md` when the symptom clearly belongs to that child story
- open `posture-matrix/how-this-works.md` when the symptom clearly belongs to that child story
- open `registry/how-this-works.md` when the symptom clearly belongs to that child story

## What to remember

- `system/shared/config/platform/` exists so this slice has one obvious home.
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
