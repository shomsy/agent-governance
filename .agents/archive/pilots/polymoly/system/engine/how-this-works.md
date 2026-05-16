---
title: system-engine-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-14
classification: internal
---

# System Engine How This Works

## What this folder is

`system/engine/` is the decision core of PolyMoly.

It is the place where the machine stops talking about vague user stories and starts turning [intent](#dictionary-intent) into validated, renderable, and runnable steps.

## Canonical entrypoint

`engine.go` is the single root entrypoint for the engine.

It exposes exactly two public functions:

```go
engine.PreviewRequestedChange(ctx, input) → (PreviewResult, error)
engine.ApplyRequestedChange(ctx, input)   → (ApplyResult, error)
```

Both orchestrate the same canonical sequence up to the branch point:

### Preview path

```text
request → resolve → generate → preview
```

### Apply path

```text
request → resolve → generate → apply
```

`engine.go` only sequences steps. It does not own child logic.

## Step ownership

| Step | Owner | Responsibility |
| :--- | :--- | :--- |
| **request** | `request/` | Read and validate user input, discover platform capabilities |
| **resolve** | `resolve/` | Compute effective intent, map service graph, resolve modules |
| **generate** | `generate/` | Produce the final render model from the resolved model |
| **preview** | `preview/` | Prepare a preview result from the render model |
| **apply** | `apply/` | Hand the render model to adapters for execution |

## Boundary between generate and preview

- `generate/` produces the **final render model** — this is the structured data
- `preview/` takes that render model and produces the **preview output** — diffs, summaries, visuals

The render model is the contract between generate and preview/apply. The engine makes this explicit by calling them as separate steps.

## Real commands or triggers that reach this folder

- `poly gate run docs` after the runner has already prepared command specs
- Higher product or tooling integrations after they have already reduced user intent into engine-shaped input

## Exact upstream handoffs

- `system/tools/poly/internal/runner/run_gate_profile.go` commonly reaches engine apply through `contracts.ApplyCommandSpec(...)`
- Product-facing integrations reach `request/`, `resolve/`, `generate/`, `preview/`, or `apply/` depending on how far the story has already been reduced

## Direct files in this folder

| File | Responsibility |
| :--- | :--- |
| `engine.go` | Canonical root entrypoint, sequences request → resolve → generate → preview/apply |
| `engine_test.go` | Proves ordering and branch behavior |
| `how-this-works.md` | This guide |

## Child folders in this folder

### `request/`

Open [`request/how-this-works.md`](./request/how-this-works.md).

Use it when the story includes:

- reading and validating user input
- discovering platform capabilities and rules

### `resolve/`

Open [`resolve/how-this-works.md`](./resolve/how-this-works.md).

Use it when the story includes:

- computing effective intent
- mapping the service graph
- resolving requested modules

### `generate/`

Open [`generate/how-this-works.md`](./generate/how-this-works.md).

Use it when the story includes:

- producing the final render model from a resolved model

### `preview/`

Open [`preview/how-this-works.md`](./preview/how-this-works.md).

Use it when the story includes:

- preparing diffs, summaries, and visual outputs from a render model

### `apply/`

Open [`apply/how-this-works.md`](./apply/how-this-works.md).

Use it when the story includes:

- handing resolved decisions to adapters for execution

## Debug first

- If the symptom is about input validation: start in `request/`
- If the symptom is about capability matching or module resolution: start in `resolve/`
- If the symptom is about the rendered output shape: start in `generate/`
- If the symptom is about preview content: start in `preview/`
- If the symptom is about execution or adapter handoff: start in `apply/`

## What to remember

- `engine.go` is the canonical root. Callers should use `PreviewRequestedChange` or `ApplyRequestedChange`.
- The sequence is always: request → resolve → generate → (preview | apply).
- If a step fails, the chain stops. No later step is called.
- The engine does not own child logic. It only sequences.

## Dictionary

<a id="dictionary-system"></a>
- `system`: The system is the machine-facing body of PolyMoly. It holds the code, assets, checks, and boundaries that make product stories real.
<a id="dictionary-engine"></a>
- `engine`: The engine is the decision core. It reads intent, matches capabilities, prepares render data, and hands safe work to the next layer.
<a id="dictionary-intent"></a>
- `intent`: Intent is the validated, normalized description of what the user wants the engine to produce.
<a id="dictionary-adapter"></a>
- `adapter`: An adapter is the place where PolyMoly touches the outside world, like files, Docker, environment files, or the browser.
<a id="dictionary-gate"></a>
- `gate`: A gate is a verification run that decides PASS or FAIL before trust increases.
<a id="dictionary-artifact"></a>
- `artifact`: An artifact is a file, bundle, or proof another tool or operator can read later.
<a id="dictionary-runtime"></a>
- `runtime`: Runtime is the live or rendered execution world PolyMoly starts, previews, inspects, or validates.
