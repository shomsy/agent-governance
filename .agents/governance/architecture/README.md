# Architecture Governance

This folder holds reusable architecture contracts for repository shape, feature
ownership, runtime boundaries, and migration-safe structure decisions.

## Core Law

- vertical slice architecture is the default
- feature-first is the default orientation
- folder says flow or capability
- file says responsibility
- function says exact action
- the same law applies to business slices and technical slices
- the target is absurd simplicity with enterprise-grade quality underneath

## What Lives Here

- `architecture-standard.md`: the universal screaming feature-first baseline
- `how-to-architecture.md`: general architecture guidance guide
- `how-to-architecture-extension.md`: public API boundary extension rules
- `runtime-kernel.md`: runtime ownership, recovery, safety, and five-plane architecture
- `runtime-hardening.md`: runtime behavior hardening — determinism, state ownership, async, lifecycle, isolation, recovery
- `survivability-analysis.md`: framework portability and migration analysis
- `contract-linting.md`: machine-verifiable contract law
- `execution-profiles.md`: execution mode overlays when one architecture must
  support more than one runtime posture
- `profiles/**`: language and framework architecture overlays
- `migration-governance.md`: migration posture and convergence discipline

## How To Use

Apply architecture rules in this order:

1. `../core/resolution/profile-resolution-algorithm.md`
2. `architecture-standard.md`
3. relevant `profiles/languages/**`
4. relevant `profiles/frameworks/**`
5. `runtime-kernel.md` for runtime posture
6. repo-local exceptions in root `AGENTS.md`

## Rule

- this folder governs repo shape, slice boundaries, ingress ownership, and
  internal architecture honesty
- `../profiles/**` governs language/runtime/framework coding behavior beyond
  architecture shape
- if a language or framework needs architectural narrowing, prefer a profile
  here instead of bloating the universal standard
- the child repo `ARCHITECTURE.md` should agree with the applied governance
  stack declared in root `AGENTS.md`
- if a name is not intuitive and predictable, the architecture is not finished
