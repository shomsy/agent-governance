---
scope: system/tools/poly/**,.github/workflows/**,Taskfile.yml,system/docs/development/governance/**
contract_ref: v1
status: stable
---

Shared baseline: `system/docs/development/governance/shared/agent-harness/how-to-coding-standards.md`
Upstream source: `system/docs/development/governance/upstream-source.lock.json`
Local role: PolyMoly-specific coding standards and code-level delivery rules

# How To Coding Standards (PolyMoly)

Version: 1.3.0
Status: Normative / Enforced
Scope: `./**`

---

## 0) Coding Boundary Map

```text
                      [ PolyMoly Repository ]
                               |
        +----------------------+----------------------+
        |                                             |
        v                                             v
[ Runtime Surfaces ]                           [ Governance Surfaces ]
 product, system/engine, system/adapters,      system/docs/development/governance,
 system/runtime, system/gates                  TODO.md, BUGS.md, AGENTS.md
        |                                             |
        +----------------------+----------------------+
                               |
                               v
                       [ CI + Gate Scripts ]
```

Rule: every change must preserve both runtime integrity and governance traceability.

---

## 1) Core Philosophy

1. Pragmatic simplicity over clever complexity.
2. Deterministic behavior over hidden magic.
3. Security and operability are non-optional.
4. Make failure paths explicit and actionable.

---

## 2) Infrastructure/Compose Standards

```text
[ compose spec ] -> [ security defaults ] -> [ resource limits ] -> [ healthchecks ]
```

- No `latest` tags.
- Required env vars for sensitive values.
- Healthcheck required for runtime-critical services.
- Resource/security baseline required (`mem_limit`, `cpus`, `security_opt`, etc.).
- No duplicate canonical service definitions.

---

## 3) Service Standards

- Small, readable functions/modules.
- No silent error swallowing.
- Structured logs with correlation IDs where applicable.
- Explicit timeout/retry/backpressure behavior.

### 3.1 Folder And File Naming Contract

PolyMoly naming must be navigable at first glance:

- folder says the flow
- file says the responsibility
- function says the exact action

Rules:

1. folder names must identify the shipped flow, ownership slice, or operator
   boundary they own
2. file names must state the single responsibility owned by that file, not a
   vague bucket around several concerns
3. if a file owns multiple distinct responsibilities, split it or rename it to
   the narrowest honest boundary
4. a reader should be able to predict the upstream trigger and downstream
   handoff of a file from its name plus package context before opening the
   implementation
5. compatibility or forwarding wrappers must say so literally in the file
   name, for example `*_compat.go`, `*_bridge.go`, or `*_legacy_adapter.go`
6. canonical platform entrypoints may keep conventional names such as
   `main.go`, `doc.go`, `README.md`, `how-this-works.md`, and `*_test.go`

Avoid placeholder buckets when a sharper name exists:

- `helpers`
- `misc`
- `common`
- `manager`
- `logic`
- `service`

The point is not longer names for their own sake.
The point is predictable ownership and absurdly simple navigation.

### 3.2 Function Naming Contract

Function names must read like an explicit operation, not a vague placeholder.

Preferred pattern:

- `Action + Object`
- `Action + Object + Boundary/Outcome` when needed for clarity

Examples:

- `ParseAndValidateUserRequest`
- `PrepareInitialIntent`
- `PlanIntentChanges`
- `ResolveRequestedModules`
- `MapServiceGraph`
- `BuildImage`
- `WriteEvidenceIndex`

Preferred verbs:

- `Parse`
- `Validate`
- `Normalize`
- `Resolve`
- `Prepare`
- `Plan`
- `Read`
- `Describe`
- `Select`
- `Route`
- `Map`
- `Render`
- `Write`
- `Load`
- `Check`
- `Record`
- `Publish`
- `Restore`
- `Collect`

Limited-use verbs:

- `Build` only when the function literally creates an artifact, image, report,
  spec, or other constructed output from inputs
- `Apply` only when the function truly commits a prepared change or mirrors a
  canonical shipped command or runtime contract such as `poly apply`, the
  engine `apply` slice, or `kubectl apply`
- `Run` only when the shipped CLI command itself is literally `run` and a
  plainer verb would be less honest

Avoid generic or implementation-heavy verbs unless the package boundary makes
the action fully obvious:

- `Handle`
- `Manage`
- `Process`
- `Execute`
- `Do`
- `Orchestrate`
- `Dispatch`

Rules:

1. the function name must say what it acts on
2. package name and function name must read cleanly together at the call site
3. package context is helpful, but it is not a license to hide the object
   behind a generic verb
4. exported functions require Go doc comments
5. unexported flow-entry or non-obvious functions should also carry short doc
   comments when the behavior is not obvious from the name alone

Examples of clearer call-site intent:

- prefer `ResolveTemplateIntent` over `Resolve` when package context alone is
  still ambiguous
- prefer `BuildWatchSnapshot` over `Snapshot` when the noun is too broad
- prefer `CheckRequiredToolchain` over `Run` when the function is a concrete
  preflight check

### 3.3 Programming Docs Boundary

Flow-documentation rules no longer live in this file.

Use:

- `system/docs/development/governance/how-to-document-flow.md` for
  folder/file/function walkthrough rules
- `system/docs/development/governance/how-to-document.md` for shared writing law

This file stays focused on code standards, naming, configuration standards, and
delivery-safe coding practice.

---

## 4) YAML Naming Standards

For configuration and declarative states, apply strict naming boundaries:

### Docker Compose
Canonical base and environment overlays only:
- `compose.yaml` (canonical base)
- `compose.dev.yaml`
- `compose.stage.yaml`
- `compose.prod.yaml`
- `compose.local.yaml`

Do not use custom naming like `dockerCompose.yaml` or `MyConfig.yaml`.

### Kubernetes manifests
Use `lowercase + kebab-case`.
Name must include `domain`, `purpose`, and `kind`:
- `<domain>-<purpose>-<kind>.yaml` or `<purpose>-<kind>.yaml`
- Examples: `api-deployment.yaml`, `api-service.yaml`, `api-ingress.yaml`, `worker-configmap.yaml`

### Helm templates
Use canonical base names inside the chart `templates/` structure:
- `deployment.yaml`
- `service.yaml`
- `ingress.yaml`
- `configmap.yaml`
- (or prefix with the component if necessary: `api-deployment.yaml`)

Use canonical `Chart.yaml` and `values.yaml` for Helm rules.

---

## 5) Script Standards (`system/gates/**` + `ops-tools/**`)

- Shell scripts use `set -euo pipefail`.
- Gate scripts produce deterministic pass/fail output.
- Gate artifacts written under `system/gates/artifacts/**`.
- Error messages must explain next action.

---

## 6) Configurator Standards

Any env/switch change must be synchronized across:

1. UI controls,
2. `app.js` generation/import logic,
3. runtime compose/script consumers.

No sync = change incomplete.

---

## 7) Compatibility Standards

For API/env/schema/behavior changes:

1. provide migration/compat path,
2. record breaking impact,
3. define rollback route.

---

## 8) Delivery Standards

```text
[ implement ] -> [ run gates ] -> [ collect evidence ] -> [ update backlog ] -> [ close ]
```

Before close:

1. required gates green,
2. evidence logged,
3. backlog updated (`TODO.md` or `BUGS.md`).

Docs lane minimum:

- run `task docs:governance` during development phase,
- use `task docs:governance:strict` when intentionally enforcing strict governance closure.
