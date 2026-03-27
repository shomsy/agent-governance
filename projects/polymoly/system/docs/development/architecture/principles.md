---
scope: product/**,system/**
contract_ref: v2
status: stable
---

# Architecture Principles

One sentence: This page locks the non-negotiable architecture rules for PolyMoly.
One sentence: It matters because product clarity and runtime trust collapse fast when ownership lines blur.

---

## Constitutional Rule

PolyMoly is built through one strict split:

```text
product = what the user asks for
system  = how the request is executed
```

Everything else follows from that boundary.

## Ownership Model

- `product/` owns user-facing vocabulary and flows.
- `system/engine/` owns deterministic decision law.
- `system/adapters/` owns host and runtime side effects.
- `system/runtime/` owns live environment truth.
- `system/shared/` owns reusable foundations.
- `system/gates/` verifies the whole system.
- `system/tools/poly/` is the CLI source and internal composition seam.

Authority is one-way:

```text
product -> system/engine -> system/adapters -> system/runtime
```

Lower layers must not redefine guarantees from upper layers.

## Engine Law

The engine is the pure decision span:

```text
request -> resolve -> preview -> apply
```

Inside `system/engine/**`, allowed behavior is:

- parsing and validation
- deterministic rule evaluation
- planning and diff generation
- policy enforcement
- structured diagnostics

Inside `system/engine/**`, forbidden behavior is:

- shell execution
- network calls
- filesystem mutation
- process spawning
- runtime orchestration
- environment-specific side effects

If the work needs one of those forbidden actions, it belongs outside the engine.

## Product Surface Rule

`product/` may expose help, doctor, lifecycle, access, observe, and deploy
surfaces, but it must not become a second resolver or a host-execution backdoor.

Required behavior:

- product code keeps user vocabulary and operator flow
- host actions delegate to adapters
- operator output uses the same canonical runtime names as `system/**`

## Repository Truth

The exact current repository shape and release-bound structural expectations are
defined in [`release/current.md`](../release/current.md).

The root landing-zone contract is defined in
[`root-surface-contract.md`](./root-surface-contract.md).

`platform` contains declarative inputs consumed by `core`.

Allowed inside `platform`:

- module metadata,
- profile defaults,
- environment rules,
- template inputs,
- policy declarations.

Forbidden inside `platform`:

- execution orchestration,
- Docker or Kubernetes command calls,
- mutable runtime state,
- UI logic,
- web transport logic.

`platform` is vocabulary and policy, not execution code.

---

## Adapter Pattern

PolyMoly uses adapters around a stable engine.

Recommended mental model:

```text
                CLI
                 |
UI / API ->   core   <- CI / tests
                 |
               ops
                 |
         Docker / K8s / files
```

This means:

- multiple surfaces may call the same engine,
- engine behavior must stay identical regardless of caller,
- adapters are replaceable as long as they respect the same contract.

The engine is the stable center.
Everything else is an edge adapter.

---

## Non-Negotiable Constraints

- No shell-out from `core`.
- No Docker or Kubernetes knowledge inside `core`.
- No CLI flags altering `core` semantics.
- No filesystem coupling inside `core`.
- No runtime execution inside `core`.
- No execution logic inside `platform`.
- No UI or web assumptions inside `core`.
- No policy bypass path that skips `core` resolution.

These are red-line rules.

### Executable Boundary Guard

`core` import boundaries are enforced by:

- `go run ./system/tools/poly/cmd/poly gate check import-boundaries`

The gate fails if any file under `core/**` imports forbidden top-level layers (`features`, `lanes`, `ops`, `configurator`, `gates`, `docs`, `k8s`, `helm`, `platform`, or `tools`).

---

## Determinism Rule

The same canonical DSL input, platform bundle, and engine version must produce the same resolved result.

That means `core` logic must not depend on:

- current machine hostname,
- current shell state,
- current working directory semantics,
- ambient Docker daemon behavior,
- random runtime side effects.

Determinism is required for review, CI, rollback, and trust.

---

## Side-Effect Rule

`core` may describe action, but it may not perform action.

Examples:

- `core` may describe the render result for Compose.
- `core` may describe validation failures for a profile.
- `core` may describe a promotion plan.

But:

- `core` may not write the generated Compose file,
- `core` may not call `docker compose up`,
- `core` may not call `kubectl apply`,
- `core` may not push artifacts,
- `core` may not mutate the filesystem directly.

Those are adapter responsibilities.

---

## Filesystem Rule

`core` must not be coupled to one repository layout.

It may consume already-loaded content or explicit structured inputs from adapters.
It must not assume:

- a root directory shape,
- a `.polymoly/` path,
- a `vendor/` path,
- a local checkout state.

This keeps the engine portable across CLI, UI service, tests, and future packaging modes.

---

## Why This Matters

If these boundaries are ignored, PolyMoly will degrade in predictable ways:

1. `core` starts calling Docker directly.
2. resolver logic starts depending on file paths.
3. CLI flags start changing engine meaning.
4. UI needs special-case behavior inside `core`.
5. testing becomes brittle and slow.

That path creates a tool that is hard to reuse, hard to trust, and hard to keep stable.

The locked model prevents that drift early.

---

## Anti-Patterns We Reject

### CLI-Driven Engine

If `core` behavior changes because one CLI flag is present, the adapter now controls the engine.
That is forbidden.

### Runtime-Coupled Resolver

If dependency resolution needs Docker state or filesystem discovery to understand intent, `core` is no longer pure.
That is forbidden.

### Platform With Execution Logic

If modules or profiles start carrying imperative runtime actions, `platform` stops being declarative.
That is forbidden.

### UI-Coupled Core

If browser or HTTP assumptions shape core semantics, engine reuse breaks.
That is forbidden.

---

## Final Layer Contract

PolyMoly is structured around responsibility boundaries:

- `core` composes,
- `platform` defines,
- `cli` translates for humans,
- `ui/api` translates for interactive clients,
- `ops` executes and distributes.

That is the architecture we are locking before DSL and API work continue.

---

## Final Decision

Core composes infrastructure intent into resolved infrastructure models.
It must remain pure, deterministic, side-effect free, and independent from transport layers, user interfaces, runtime tooling, and execution environments.

This is the constitutional boundary for the PolyMoly engine.
