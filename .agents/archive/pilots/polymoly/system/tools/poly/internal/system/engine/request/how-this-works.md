---
title: system-tools-poly-internal-system-engine-request-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# System Tools Poly Internal System Engine Request How This Works

## What this folder is

`system/tools/poly/internal/system/engine/request/` is now a docs-only compatibility checkpoint.

The old local shim file was removed because it was dead code. The real request
entrypoint lives in the canonical engine tree under
`system/engine/request/parse/read_and_validate_user_request.go`.

## Real commands or triggers that used to map here

- `poly ...` commands that eventually need engine request parsing
- gate or review paths that inspect request parsing behavior

## The simplest story

- when you type a real command like `poly status`, the CLI does not enter a
  local request shim in this folder anymore
- it goes straight to the canonical engine request path
- this folder stays only so the documentation map and folder story remain easy
  to follow

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;

    A["1. you type a real `poly ...` command"]:::step1 --> B["2. the CLI routes directly into `system/engine/request/parse/read_and_validate_user_request.go`"]:::step2
    B --> C["3. this folder remains as docs-only map, not as a live shim"]:::step3
```

## The first important path

When you want the real parser story, open this file first:

- `system/engine/request/parse/read_and_validate_user_request.go`

That is where request payload reading, validation, and normalized engine input
actually happen now.

## Direct files in this folder

This folder currently has no live Go source files.

## Debug first

- start with `ReadAndValidateUserRequest(...)` in `system/engine/request/parse/read_and_validate_user_request.go` when request parsing looks wrong

## What to remember

- this folder no longer owns runtime behavior
- the dead shim was removed on purpose
- the real behavior is in the canonical engine request path, not here

## Dictionary

<a id="dictionary-command"></a>
- `command`: A command is the exact CLI sentence that starts the flow.
<a id="dictionary-request"></a>
- `request`: A request is the normalized input object the engine reads before it decides anything.
<a id="dictionary-parser"></a>
- `parser`: A parser is the code that takes raw input and turns it into a safe structured shape.
