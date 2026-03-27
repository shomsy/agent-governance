---
scope: product/**,system/**,.github/**
contract_ref: v1
status: stable
---

# Root Surface Contract

Status: Normative / Enforced  
Scope: repository root tracked entries

## Purpose

Keep root as architecture landing zone and prevent runtime/config drift at top level.

## Allowed Tracked Root Entries

Files:

- `.dockerignore`
- `.env.example`
- `.gitignore`
- `AGENTS.md`
- `ARCHITECTURE.md`
- `BUGS.md`
- `CONTRIBUTING.md`
- `QUICKSTART.md`
- `README.md`
- `Taskfile.yml`
- `TODO.md`
- `go.mod`
- `go.work`
- `go.work.sum`
- `merge-files.sh`

Directories:

- `.github/`
- `product/`
- `system/`

## Forbidden Root Env Profiles

Tracked root env profiles are forbidden:

- `.env`
- `.env.local`
- `.env.*` (except `.env.example`)

Runtime env profiles live under `system/adapters/env/**` and
`system/runtime/capabilities/environment-law/**`.

## Enforcement

- Gate: `go run ./system/tools/poly/cmd/poly gate check root-surface`
- Artifact: `system/gates/artifacts/architecture-root-surface/`
