---
title: product-examples-node-nest-service-starter-src-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Product Examples Node Nest Service Starter Src How This Works

## What this folder is

`product/examples/node-nest-service/starter/src/` holds the built-out source version of this example.

Open it when you want to compare the starter skeleton with a more realistic app tree.

## Real commands that reach this folder

- example authors update these folders
- onboarding readers open these folders to compare starter output with a finished app

## Exact CLI front doors

- `system/tools/poly/internal/cli/route_root_commands.go`
- function: `RouteRootCommands(args []string) int`
- this folder is the product-facing map the CLI reaches after root routing chooses a human story

## The simplest story

- you type a real PolyMoly command, or a higher caller reaches this folder for one specific reason
- this folder opens the first direct file or child slice that does the next real job, often `index.js`
- at the end, the caller has something concrete: a summary, an artifact, a proof, or a next step

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. you type the command, or a parent story hands this folder one honest job"]:::step1 --> B["2. the story opens the first real file or child slice, often `index.js`"]:::step2
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
    participant Owned as index.js
    participant Next as NextStep
    participant Result as VisibleResult

    Entry->>Owned: Step 1: reach `product/examples/node-nest-service/starter/src/` through the current story
    Owned->>Owned: Step 2: perform the folder-owned work in `index.js`
    Owned->>Next: Step 3: hand the concrete result to the next caller or boundary
    Next-->>Result: Step 4: make the next visible summary, artifact, or state available
```

- **Step 1:** This is the moment the story actually enters this folder instead of staying in a higher router or parent helper.
- **Step 2:** The first real work starts in `index.js`.
- **Step 3:** From here, the story moves to one smaller file, child slice, or boundary that can do the next concrete job.
- **Step 4:** At the end, the caller has something concrete to carry forward: a file on disk, a rendered asset, a proof artifact, or a clear next state.

## Direct files in this folder

### `index.js`

This file ships the `index.js` web or script asset that a later runtime or UI step reads directly.

Why this name is honest:

- the file name already tells you what concrete artifact or config lives here

When the story opens this file:

- when the `product/examples/node-nest-service/starter/src/` story needs this responsibility, it opens `index.js`

What arrives here:

- the next render, runtime, or browser step reads this shipped asset as-is

What leaves this file:

- the shipped `index.js` asset
- a concrete file the next render or runtime step can read directly

Why you open it first:

- open this file when the generated or shipped asset itself looks wrong

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as index.js
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `index.js`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `index.js` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

This file does not expose top-level functions. That is fine. The file itself is the artifact the next step reads.

### `worker.js`

This file ships the `worker.js` web or script asset that a later runtime or UI step reads directly.

Why this name is honest:

- the file name already tells you what concrete artifact or config lives here

When the story opens this file:

- when the `product/examples/node-nest-service/starter/src/` story needs this responsibility, it opens `worker.js`

What arrives here:

- the next render, runtime, or browser step reads this shipped asset as-is

What leaves this file:

- the shipped `worker.js` asset
- a concrete file the next render or runtime step can read directly

Why you open it first:

- open this file when the generated or shipped asset itself looks wrong

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as worker.js
    participant Next as NextStep

    Note over Caller,File: Input: parent flow values, repo state, or shipped asset context
    Caller->>File: Step 1: enter `worker.js`
    File->>File: Step 2: do the file-owned work
    File->>Next: Step 3: hand the concrete result forward
```

- **Step 1:** The story reaches `worker.js` because this file owns the next small responsibility.
- **Step 2:** The file does its own narrow action instead of mixing it into a bigger caller.
- **Step 3:** The next caller gets a concrete result, not another vague promise.

Important functions:

This file does not expose top-level functions. That is fine. The file itself is the artifact the next step reads.

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- start with `index.js` when the shipped asset or contract itself looks wrong
- start with `worker.js` when the shipped asset or contract itself looks wrong

## What to remember

- `product/examples/node-nest-service/starter/src/` exists so this slice has one obvious home.
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
