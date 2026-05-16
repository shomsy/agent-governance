---
title: product-examples-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Examples How This Works

## What this folder is

`product/examples/` holds shipped example projects and starter comparisons.

These folders are not the main runtime engine. They are the easiest place to see what a starter looks like before and after a real app grows around it.

## Real commands that reach this folder

- example authors update these folders
- onboarding readers open these folders to compare starter output with a finished app

## Exact CLI front doors

- `system/tools/poly/internal/cli/route_root_commands.go`
- function: `RouteRootCommands(args []string) int`
- this folder is the product-facing map the CLI reaches after root routing chooses a human story

## The simplest story

- you type a real PolyMoly command, or a higher caller reaches this folder for one specific reason
- this folder opens the first direct file or child slice that does the next real job, often `go-service/`
- at the end, the caller has something concrete: a summary, an artifact, a proof, or a next step

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. you type the command, or a parent story hands this folder one honest job"]:::step1 --> B["2. the story opens the first real file or child slice, often `go-service/`"]:::step2
    B --> C["3. by the end, the user or caller gets something concrete back: output, artifact, proof, or next step"]:::step3
```

## The first important path

When you type:

```text
example authors update these folders
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant Entry as RouteRootCommands
    participant Owned as go-service/
    participant Next as NarrowerFlow
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `product/examples/` through the current story
    Owned->>Owned: Step 2: hand the story into `go-service/` because that child slice owns the first concrete step
    Owned->>Next: Step 3: let `go-service/` continue the concrete file and function work
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `go-service/`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

This folder has no direct first-party files besides this guide.

## Child folders in this folder

### `go-service/`

Open [`go-service/how-this-works.md`](./go-service/how-this-works.md).

Use it when the story includes:

- example authors update these folders
- onboarding readers open these folders to compare starter output with a finished app

### `node-nest-service/`

Open [`node-nest-service/how-this-works.md`](./node-nest-service/how-this-works.md).

Use it when the story includes:

- example authors update these folders
- onboarding readers open these folders to compare starter output with a finished app

### `php-laravel-api/`

Open [`php-laravel-api/how-this-works.md`](./php-laravel-api/how-this-works.md).

Use it when the story includes:

- example authors update these folders
- onboarding readers open these folders to compare starter output with a finished app

## Debug first

- open `go-service/how-this-works.md` when the symptom clearly belongs to that child story
- open `node-nest-service/how-this-works.md` when the symptom clearly belongs to that child story
- open `php-laravel-api/how-this-works.md` when the symptom clearly belongs to that child story

## What to remember

- `product/examples/` exists so this slice has one obvious home.
- The fastest map is still the naming law: folder for flow, file for responsibility, function for exact action.
- If the folder overview feels too wide, jump to the child slice that matches the current symptom instead of reading sideways.

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
