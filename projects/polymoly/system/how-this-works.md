---
title: system-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# System How This Works

## What this folder is

`system/` is the machine-facing body of PolyMoly.

When the product surface decides what story the user is in, this tree is where the code, shipped assets, checks, and boundaries make that story real.

If `product/` tells you "which story is this?", `system/` tells you "which machine parts now make that story true?"

## Real commands or triggers that reach this folder

- `poly new my-app --framework laravel`
- `poly up`
- `poly gate run docs`
- `poly review pack .`

## Exact upstream handoffs

- `system/tools/poly/cmd/poly/main.go` enters through `system/tools/`
- from there, the story can hop into `engine/`, `shared/`, `runtime/`, `adapters/`, or `gates/`
- the quickest first question is: "am I still routing a command, or am I already reading/writing machine state?"

## The simplest story

- a real command enters `system/` through tooling first
- tooling routes the story into the next machine slice: engine, shared config, runtime assets, adapters, or gates
- by the end, something real has happened: files were written, commands were prepared, checks ran, or proof artifacts appeared

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. a real command enters the machine-facing tree"]:::step1 --> B["2. `system/` points the story at the next real child, often `tools/` first"]:::step2
    B --> C["3. the next caller receives something concrete: checked input, rendered data, or a ready handoff"]:::step3
```

## The first important path

When a real caller reaches this slice for this exact reason:

```bash
poly new my-app --framework laravel
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant Entry as main.go
    participant Owned as tools/
    participant Next as shared/config
    participant Result as CreatedProject

    Entry->>Owned: Step 1: the source-native CLI enters `system/tools/`
    Owned->>Next: Step 2: the create path eventually calls shared config helpers to write project state
    Next-->>Result: Step 3: sidecar files and starter facts become real on disk
    Result-->>Result: Step 4: the user sees project creation output and next steps
```

- **Step 1:** The first machine stop is usually `tools/`, not adapters.
- **Step 2:** From there, the story fans out into narrower machine slices.
- **Step 3:** The exact next child depends on whether the command is routing, deciding, reading config, touching runtime, or proving something.
- **Step 4:** The system story is finished only when something concrete exists: output, state, or evidence.

## Direct files in this folder

This folder has no direct first-party files besides this guide.

## Child folders in this folder

### `adapters/`

Open [`adapters/how-this-works.md`](./adapters/how-this-works.md).

Use it when the story includes:

- engine apply and generate flows when PolyMoly must touch files, Docker, env files, or the browser

### `engine/`

Open [`engine/how-this-works.md`](./engine/how-this-works.md).

Use it when the story includes:

- product and gate flows after CLI routing hands work into the engine

### `gates/`

Open [`gates/how-this-works.md`](./gates/how-this-works.md).

Use it when the story includes:

- `poly gate run docs`
- `poly gate run p0`
- `bash system/gates/run p0`
- `bash system/gates/run nightly`

### `runtime/`

Open [`runtime/how-this-works.md`](./runtime/how-this-works.md).

Use it when the story includes:

- engine resolve, render, runtime start, and gate flows after CLI routing chooses a project story

### `scripts/`

Open [`scripts/how-this-works.md`](./scripts/how-this-works.md).

Use it when the story includes:

- developer, governance, and release shell flows outside the main Go CLI path

### `shared/`

Open [`shared/how-this-works.md`](./shared/how-this-works.md).

Use it when the story includes:

- engine, tools, and adapters call this shared slice instead of copying the same helpers

### `tools/`

Open [`tools/how-this-works.md`](./tools/how-this-works.md).

Use it when the story includes:

- `poly new my-app --framework laravel`
- `poly up`
- `poly gate run docs`
- `poly review pack .`

## Debug first

- open `adapters/how-this-works.md` when the symptom clearly belongs to that child story
- open `engine/how-this-works.md` when the symptom clearly belongs to that child story
- open `gates/how-this-works.md` when the symptom clearly belongs to that child story
- open `runtime/how-this-works.md` when the symptom clearly belongs to that child story
- open `scripts/how-this-works.md` when the symptom clearly belongs to that child story
- open `shared/how-this-works.md` when the symptom clearly belongs to that child story
- open `tools/how-this-works.md` when the symptom clearly belongs to that child story

## What to remember

- `system/` exists so this slice has one obvious home.
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
