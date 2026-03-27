# Architecture

Status: Active root contract  
Last updated: 2026-03-07

## Purpose

This file is the current root architecture contract for the active repository.

It exists to make five things explicit:

1. what PolyMoly is as a system,
2. what belongs to the product repository versus a generated user project,
3. where product-facing vocabulary stops and implementation ownership starts,
4. what counts as exact architecture convergence,
5. what must not become a junk drawer while the system grows.

This document is stricter than a brainstorm and lighter than the deeper platform
architecture corpus under `system/docs/development/architecture/`.

## System Model

PolyMoly spans three connected but different systems:

1. the product repository,
2. the generated project,
3. the running environment.

They must stay aligned, but they must never be confused.

### 1) Product Repository

The repository contains the engine, adapters, CLI, deploy assets, proofs, and
documentation used to build and ship PolyMoly itself.

### 2) Generated Project

A generated or managed project is the user-facing working tree that contains
application code plus a PolyMoly sidecar.

### 3) Running Environment

The running environment is the realized topology produced from project intent:
services, containers, networking, endpoints, runtime state, and release
evidence.

## Canonical Flow

```text
User intent
      ↓
Product surface
      ↓
.polymoly configuration
      ↓
Resolver / policy law
      ↓
Runtime topology
      ↓
Running environment
      ↓
Evidence and rollback path
```

Interpretation:

- the user asks for behavior through a product surface,
- the project sidecar stores canonical intent,
- the resolver turns intent into deterministic topology,
- adapters and runtime surfaces realize that topology,
- evidence proves what actually happened.

## Generated Project Contract

The managed project shape remains:

```text
project/
  src/
  .polymoly/
```

- `src/` = application code and framework-owned source.
- `.polymoly/` = infrastructure intent, profile choice, lock state, overrides,
  and local state traces.

The sidecar contract is:

- `.polymoly/config.yaml` is the canonical project intent file,
- `.polymoly/polymoly.lock` pins deterministic identity and version-sensitive
  behavior,
- `.polymoly/overrides/` is the controlled escape hatch for explicit
  customization,
- `.polymoly/state/` is local operational state and must not replace the
  canonical config contract.

## Product Surface And System Surface

PolyMoly should be easy to use without becoming architecturally dishonest.

### Product Surface

This is the vocabulary the user should feel:

- create a project,
- edit setup safely,
- operate lifecycle,
- inspect without mutation,
- prepare, validate, and release.

This is the mental model behind the current `product/` language.

### System Surface

This is the implementation model the repository must enforce:

- engine,
- adapters,
- runtime topology,
- execution and proof lanes,
- governance and evidence.

Rule:

The product surface may simplify the language, but it must not invent a second
resolver, a second state model, or a second source of truth.

## Current Repository Roles

The canonical repository shape is `product/` and `system/`.

- `product/` = user-facing domain: project flows, ecosystem, deploy, inspect,
  examples.
- `system/` = execution domain: engine, adapters, runtime, scripts, shared
  foundations, docs, gates, tools.

The canonical file tree with active release detail is defined in
`system/docs/development/release/current.md`.
This document does not repeat that tree; it defers to it.

## Implementation Binding (Subordinate To Architecture)

The following entries describe current Go implementation mechanics.
They are subordinate to the canonical architecture and must not be read as
defining a second architecture.

- `system/tools/poly/internal/product/**` = Go ownership boundary for extracted
  product behavior.
- `system/tools/poly/internal/system/**` = Go ownership boundary for extracted
  engine and shared-system behavior.
- `system/tools/poly/internal/cli/**` = legacy ingress routers allowed as thin
  delegation layers; must not regain sole ownership of migrated domains.
- `system/engine/request/**`, `system/engine/resolve/**`,
  `system/engine/preview/**`, and `system/engine/apply/**` = direct physical
  engine homes on disk.

These paths exist because Go package layout does not always mirror the product
architecture directly. When they diverge, the architecture (this document and
`release/current.md`) wins.

## Convergence Checkpoint (Evidence, Not Architecture)

The following criteria prove convergence progress.
They do not define architecture; they verify it.

1. tracked-source physical moves proven by
   `system/docs/development/release/current-placement-plan.yaml` are complete,
2. legacy pre-product/system root paths (`core/`, `platform/`, `features/`,
   `deployment/`, `environments/`, `ui/`, `ops-tools/`, `lanes/`) do not
   remain as active on-disk repository structure,
3. legacy ingress files continue to bind into extracted ownership seams instead
   of reintroducing competing truth.

Canonical proof commands:

- `poly gate check root-surface`
- `poly gate check import-boundaries`
- `poly gate run full`

## Boundary Rules

### Engine Boundary

The decision engine lives behind:

- `system/engine/request/**`
- `system/engine/resolve/**`
- `system/engine/preview/**`
- `system/engine/apply/**`
- `system/tools/poly/internal/system/engine/**`

Allowed inside the engine boundary:

- parse,
- validate,
- resolve,
- merge,
- policy evaluate,
- build deterministic models,
- emit structured diagnostics,
- prepare typed preview and apply handoff payloads.

Forbidden inside the engine boundary:

- shell-out,
- network calls,
- file writes,
- Docker/Kubernetes invocation,
- process spawning,
- runtime mutation,
- release publication.

### Policy And Config Boundary

Policy law and configuration truth live behind:

- `system/shared/config/**`
- `system/runtime/capabilities/profile-law/**`
- `system/runtime/capabilities/environment-law/**`

They may define:

- profiles,
- environments,
- templates,
- module metadata,
- registry pins,
- policy declarations.

They must not become:

- an execution layer,
- a UI layer,
- a mutable runtime state store.

### Product Ownership Boundary

Product behavior belongs behind:

- `system/tools/poly/internal/product/**`

It may:

- express user-facing use cases,
- translate CLI/UI intent into typed requests,
- render previews, explanations, and summaries,
- stay opinionated about user experience.

It must not:

- bypass the canonical config contract,
- redefine engine law,
- import legacy CLI routers as a source of truth.

### Adapter Boundary

CLI, docs, automation, and web surfaces are adapters around the same system.

They may:

- collect user intent,
- call the same resolver path,
- present previews, diagnostics, and evidence,
- invoke runtime actions through typed contracts.

They must not:

- redefine policy,
- bypass the canonical sidecar contract,
- present behavior the runtime cannot prove.

### Legacy Ingress Boundary (Implementation Detail)

Legacy ingress files under `system/tools/poly/internal/cli/**`,
`system/tools/poly/internal/releaseops/**`, and `system/tools/poly/internal/resilienceops/**`
are implementation mechanics, not architectural layers.

Allowed:

- flag parsing,
- command dispatch,
- thin output shaping,
- calls into extracted product/system ownership seams.

Forbidden:

- new policy truth,
- new engine truth,
- new domain ownership that bypasses extracted packages,
- silent second implementations of already-extracted behavior.

### Runtime And Proof Boundary

Runtime and release claims are real only when they are backed by:

- generated topology,
- successful execution,
- verifiable artifacts,
- explicit rollback or containment guidance.

## Mutation And Inspection Laws

All state-changing flows must follow this shape:

```text
request
  -> resolve
  -> preview
  -> apply handoff
  -> adapter execution
  -> evidence
```

Meaning:

- mutations require preview or diff before apply,
- apply remains distinct from planning,
- adapter execution performs the real side effects,
- evidence records the outcome,
- rollback or containment must be explicit for release-impacting work.

Inspection flows are different:

```text
request
  -> read config/runtime/evidence
  -> explain state
  -> suggest fix
```

Inspection must stay read-only unless the command is explicitly a repair flow.

## Profile Layering

Profiles remain additive and do not fork into separate systems.

- `localhost` = local development baseline,
- `production` = reproducible production baseline,
- `enterprise` = advanced hardening and governance overlays.

Rules:

- stronger profiles may add guarantees but must not weaken lower-layer law,
- profile changes must explain capability delta and safety delta,
- runtime proofs must reflect the same posture the architecture claims.

## Release And Evidence Model

PolyMoly is not only a generator. It is also a release system.

Release truth requires the full path:

```text
local
  -> stage
  -> production
  -> evidence bundle
  -> rollback path
```

Architecture is not allowed to claim:

- production readiness without evidence,
- enterprise posture without fail-closed behavior,
- stable distribution without install/update proof,
- runtime safety without observability and rollback language.

## Anti-Junk-Drawer Rules

Growth is allowed. Unowned piles are not.

### `shared/`

`shared/` is allowed only for narrow cross-cutting primitives such as:

- small config helpers,
- output formatting helpers,
- logging contracts,
- typed error helpers.

Anything with domain language, policy, runtime meaning, or product semantics
must move into a named slice with explicit ownership.

### `utils/`

`utils/` is not a parking lot.

Allowed:

- tiny stateless helpers with no domain vocabulary,
- helpers whose responsibility is obvious and does not expand over time.

Forbidden:

- business logic,
- policy decisions,
- runtime orchestration,
- schema knowledge,
- second resolver behavior,
- mixed helpers that serve unrelated domains.

If a helper starts attracting domain terms or multiple reasons to change, it
must be promoted into a named slice.

### `scripts/`

`scripts/` must not become a shadow control plane.

Allowed:

- thin convenience wrappers,
- local development helpers,
- packaging helpers that wrap canonical commands.

Forbidden:

- the only implementation of a canonical product behavior,
- hidden policy logic,
- a second release flow separate from the typed CLI and workflows.

## Migration Law For Future Waves

Future architecture waves may expand vocabulary and simplify the user-facing
story, but they must follow these rules:

1. behavior first, naming second, file moves last,
2. no big-bang rewrite of repository topology,
3. do not change behavior, directory layout, and release process in one pass,
4. preserve the public entrypoints: `poly`, `.polymoly/`, profiles, gates, and
   evidence paths,
5. keep old and new names bridged until docs, tests, and gates all agree,
6. any root-level layout change must satisfy the root surface contract and
   update architecture docs in the same iteration.

## Stability Model

The stable promises remain:

- CLI surface is intentionally stable,
- project intent lives in `.polymoly/`,
- schema and lock versions are explicit,
- runtime dependencies are pinned,
- environment outputs are deterministic by contract,
- architecture claims must match runtime proofs,
- product simplification must not weaken trust, evidence, or rollback posture.

## Practical Reading Order

Read this file first when deciding:

- whether a refactor is conceptual or physical,
- whether a behavior belongs to the engine or an adapter,
- whether a new helper is a real slice or junk-drawer drift,
- whether a future migration claim is still truthful.

Then use:

- `system/docs/development/release/current.md` for the active release and
  placement contract,
- `system/docs/development/architecture/principles.md` for the strict engine
  and boundary doctrine,
- `system/docs/development/architecture/root-surface-contract.md` for root
  layout law,
- `AGENTS.md` for delivery, review, and evidence rules.
