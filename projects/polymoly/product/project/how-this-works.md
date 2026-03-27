---
title: product-project-how-this-works
owner: platform@polymoly
last_reviewed: 2026-03-14
classification: internal
---

# Product Project How This Works

## What this folder is

`product/project/` is the **story-family root** for all user-facing project lifecycle operations.

### ⚠️ This folder is NOT a single pipeline
It does not define one sequential pipeline of execution. Instead, it serves as a human-readable map and routing hub for three distinct sub-pipelines. If you are looking for execution logic, you must look into the specific story folders.

Additionally, this root provides a **fluent entrypoint** that offers a highly predictive, readable interface for programmatic callers while keeping the sub-pipelines as the execution owners.

## Story Map

- **`create/`** → **Bootstrap Pipeline**: Brings a project into existence from nothing or adopts a raw directory.
- **`configure/`** → **Mutation Pipeline**: Safely changes project intent (the `polymoly.yaml`) and preserves explicit overrides.
- **`lifecycle/`** → **Usage Pipeline**: Interacts with, accesses, and reads the status of an already-existing project.

## Command To Story Mapping

Every project-related command maps to exactly one story folder:

| Command | Story Folder | Responsibility |
| :--- | :--- | :--- |
| `poly new` | `create/` | New project scaffold |
| `poly init` | `create/` | Existing dir adoption |
| `poly wizard` | `create/` | Interactive selection |
| `poly template` | `create/` | Template lookup/use |
| `poly set` | `configure/` | Direct mutation |
| `poly add` | `configure/` | Service addition |
| `poly configure` | `configure/` | Full reconfiguration |
| `poly replace` | `configure/` | Framework/Runtime swap |
| `poly apply` | `configure/` | Pending plan execution |
| `poly open` | `lifecycle/` | Browser access |
| `poly status` | `lifecycle/` | Health check |
| `poly events` | `lifecycle/` | Runtime event stream |
| `poly health` | `lifecycle/` | Deep integrity check |

## Boundary Contracts

**MAY**
- Group all project-facing stories under one human-readable surface.
- Route the reader and technical caller to the correct story folder.
- Define story ownership and command ownership.

**MUST NOT**
- Pretend all child stories are one sequential pipeline.
- Become a second project orchestrator (logic stays in sub-pipelines).
- Hide story-specific behavior in root-level files.
- Introduce "junk drawer" files (e.g., `helpers.go`).

## Entrypoint

The `project.go` file provides the canonical, human-readable fluent entrypoint for the root project package.
Programmatic callers can start an operation directly from package-level functions.

### Architecture Rule
1. **Types are contexts, methods are actions**: `Create`, `Configure`, `Lifecycle` are entry contexts. `Into()`, `FromTemplate()`, `Apply()` are action methods.
2. **Terminal methods delegate execution**: Verbs like `Apply()`, `Health()`, and `Events()` trigger the real execution.
3. **Child pipelines remain the owners**: `project.go` is a thin entrypoint. No business logic moves from `create/`, `configure/`, or `lifecycle/` into the root.
4. **Contract Isolation**: The root defines its own intent types and maps them to child lane contracts via adapters, preventing child lane internal changes from breaking the public API.

### Usage Pattern

```go
import "github.com/shomsy/polymoly/product/project"

// Create a new project
project.Create().
    Into("/tmp/my-app").
    FromTemplate("go-service").
    ConfigureServices().
        Database("postgres").
        Cache("redis").
    Apply(ctx)

// Configure an existing project
project.Configure("/workspace/my-app").
    WithProfile("production").
    ConfigureServices().
        Cache("redis").
    Apply(ctx)

// Replace a scaffold
project.Configure("/workspace/my-app").
    Replace().
        FromTemplate("php-laravel-api").
        WithBackup(true).
    Apply(ctx)

// Check project health
project.Lifecycle("/workspace/my-app").Health(ctx)
```
