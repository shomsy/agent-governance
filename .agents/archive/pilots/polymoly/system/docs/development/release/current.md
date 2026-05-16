---
scope: product/**,system/**,system/docs/development/**
contract_ref: current-release
status: active
---

# Current Release Contract

This is the only active release-planning file in the repository.

Closed versioned roadmap stacks do not stay in the active tree.
When a release train ends, replace this file with the next one instead of
keeping old versioned plan stacks alive.

## Current State

- target version: `3.8`
- status: `active`
- primary goal: `converge PolyMoly on flow-first naming so folder says the flow, file says the responsibility, and function says the exact action across product, system, tooling, and docs`
- non-goals:
  - `do not change the user-facing command vocabulary unless naming drift blocks operator clarity`
  - `do not reopen engine placement or product/runtime ownership law`
  - `do not hide compatibility shims or forwarding wrappers as permanent architecture`
  - `do not widen the wave into unrelated feature work`
- release risks:
  - `broad path churn can leave imports, docs, tests, and architecture checks pointing at stale names`
  - `partial renames can increase confusion if wrapper files stay generic while canonical files move`
  - `large compatibility layers can keep the repository technically green while naming truth remains misleading`
  - `flow-book and governance drift can invalidate operator trust even if Go compilation still passes`
- exit criteria:
  - `active naming hotspots move to canonical flow-first folder and file paths through the placement manifest`
  - `touched exported functions use exact action verbs instead of generic orchestration verbs`
  - `CLI call sites, architecture checks, flow books, and governance docs all point at the same canonical names`
  - `required gates, review-pack evidence, and a current strict-review report are green for the claimed convergence slice`
- required gates:
  - `poly gate run p0`
  - `poly gate run docs`
  - `poly review pack .`
  - `targeted go test runs for every touched package slice`
- rollback and evidence boundary:
  - `rollback is the revert of the manifest-driven rename wave plus its paired rewrite pass`
  - `every structural rename wave must record evidence in TODO.md and keep placement/rewrite artifacts reviewable`
- strict-review boundary:
  - `required before closing this release because repo-wide naming convergence is a major architectural claim`
- active TODO items: see [`TODO.md`](../../../../TODO.md)
- active bug items: see [`BUGS.md`](../../../../BUGS.md)

## Release Intake Contract

Every active release must explicitly carry these fields:

- target version: `fill before implementation starts`
- primary goal: `fill before implementation starts`
- non-goals: `fill before implementation starts`
- release risks: `fill before implementation starts`
- exit criteria: `fill before implementation starts`
- required gates: `fill before implementation starts`
- rollback and evidence boundary: `fill before implementation starts`
- strict-review boundary: `fill when the release targets production-ready or major convergence claims`

If any field is missing, the release is not properly opened.

## Canonical Repository Shape

PolyMoly repository source stays split into:

```text
polymoly/
├─ product/
└─ system/
```

Generated managed projects stay separate:

```text
<app>/
├─ src/
└─ .polymoly/
   ├─ config.yaml
   ├─ overrides/
   ├─ state/
   └─ polymoly.lock
```

Never mix repository source tree with generated managed project tree.

## Architectural Truth

The active architecture is enforced through:

- [`ARCHITECTURE.md`](../../../../ARCHITECTURE.md)
- [`../architecture/principles.md`](../architecture/principles.md)
- [`../architecture/root-surface-contract.md`](../architecture/root-surface-contract.md)

The engine law remains:

```text
request -> resolve -> preview -> apply
```

`system/engine/**` is not allowed to perform:

- shell execution
- network calls
- filesystem mutation
- process spawning
- runtime orchestration

Legacy ingress must not:

- regain product ownership
- regain engine ownership
- create a second state model
- create a second resolver

## Release Proof Boundary

Every active release must stay tied to:

- [`../standards/product-quality.md`](../standards/product-quality.md)
- [`../standards/release-proof-plan.md`](../standards/release-proof-plan.md)
- [`../governance/how-to-strict-review.md`](../governance/how-to-strict-review.md) for production-ready or major convergence claims
- [`current-placement-plan.yaml`](./current-placement-plan.yaml) when structural moves are in scope
- `TODO.md`
- `BUGS.md`

## Closure Rule

The release is closable only when all are true:

1. no open `high` or `critical` findings remain in scope
2. required gates are green
3. rollback path is explicit
4. release evidence exists
5. docs match shipped behavior
6. if the release claims production ready or major convergence, a current
   strict-review report exists and has no open `high` or `critical` findings

If any of those are false, the release remains open.
