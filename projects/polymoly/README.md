# PolyMoly

Developer-first infrastructure runtime that turns application intent into runnable environments.

Run production-grade infrastructure without becoming a DevOps expert.

Current status:

- release-quality evidence is closed for the shipped baseline.
- architecture convergence is enforced through placement, root-surface,
  import-boundary, and end-to-end gate proof.
- Thin-core CLI, runtime GA, install/update paths, release channels, template catalog, dashboard, enterprise advisory, and supply-chain proof surfaces are available.

## 10-Second Demo

```bash
poly new billing --framework laravel
cd billing
poly cache warm
poly up --fast-start
```

Example output:

```text
Application ready

HTTP: http://localhost:8080
DB: localhost:3306
Redis: localhost:6379
```

## Install Paths

Project-local install:

```bash
poly install
./.polymoly/bin/poly help
```

Release channel generation:

```bash
poly release dist-channels <version>
```

Canonical host-family paths:

- macOS: Homebrew formula
- Windows: Scoop manifest
- Linux: `install.sh`

These are the distribution channels for one PolyMoly release:

- Homebrew -> macOS users
- Scoop -> Windows users
- `install.sh` -> Linux users and shell-first environments

Visual map:

```text
            PolyMoly release
                   |
     +-------------+-------------+
     |             |             |
  Homebrew       Scoop       Install script
     |             |             |
  macOS users   Windows users   Linux users
```

## First 60 Seconds With PolyMoly

```bash
poly new billing --framework laravel
cd billing
poly cache warm
poly up --fast-start
poly status
poly explain redis
```

Generated shape:

```text
billing/
 ├─ src/
 └─ .polymoly/
     ├─ config.yaml
     └─ polymoly.lock
```

Mental model:

```text
src/        -> application code
.polymoly/  -> infrastructure intent
```

## What PolyMoly Is Not

PolyMoly is not:

- a Kubernetes replacement
- a Terraform replacement
- a CI/CD system
- a PaaS hosting platform

PolyMoly is:

- a developer-first infrastructure runtime
- safe defaults + progressive depth
- deterministic, explainable environment orchestration

## PolyMoly Mental Model

```text
Application intent
      ↓
.polymoly configuration
      ↓
Resolver
      ↓
Runtime topology
      ↓
Running environment
```

## Why Developers Use PolyMoly

- Run infrastructure in minutes.
- Safe defaults without DevOps expertise.
- Same commands from local to production profiles.
- Clear system introspection (`poly describe`).
- Deterministic lock-driven environments.

## Public CLI Surface (v2 Thin-Core)

```bash
poly new <name> [usage] [runtime]
poly init [runtime] [usage]
poly wizard [--mode quickstart|guided|advanced]
poly edit [--mode guided|advanced]
poly configure [--answers file]
poly plan [--json]
poly diff
poly apply
poly cache warm
poly up
poly down
poly status
poly logs
poly events
poly metrics
poly doctor
poly describe
poly tutorial
poly completion <bash|zsh|fish>
poly list
poly gate run p0
poly verify   # compatibility alias for `poly gate run`
```

Optional and advanced surfaces:

```bash
poly install [--project dir]
poly self-update [--project dir]
poly template search [term]
poly template show <template>
poly template install <template> [name]
poly dashboard [--open]
poly enterprise <summary|clusters|audit-log>
poly ai <review|architect|load-plan|posture>
poly chaos [sim]
poly ghost
```

Config mutation flow:

```bash
poly plan --profile production --recipe hardened
poly diff
poly apply
```

## Profiles

- `localhost`: fastest local development.
- `production`: reproducible production baseline.
- `enterprise`: production plus advanced security/governance overlays.

Profiles are additive (`localhost -> production -> enterprise`).

## Example Projects

- `poly new billing --usage api --lang php`
- `poly new gateway --usage service --lang go`
- `poly new dashboard --usage web --lang node`
- `poly tutorial --name billing --lang php`

Ready-to-run examples are available under [`product/examples/`](./product/examples/).

## Example Topology

```text
User
  ↓
Gateway
  ↓
Application
  ↓
Database
```

## More Documentation

- Quickstart: [`QUICKSTART.md`](./QUICKSTART.md)
- Why PolyMoly: [`system/docs/guides/why-polymoly.md`](./system/docs/guides/why-polymoly.md)
- Architecture: [`ARCHITECTURE.md`](./ARCHITECTURE.md)
- Development source map: [`system/docs/development/README.md`](./system/docs/development/README.md)
- Governance source map: [`system/docs/development/governance/README.md`](./system/docs/development/governance/README.md)
- Current release: [`system/docs/development/release/current.md`](./system/docs/development/release/current.md)
- Product quality: [`system/docs/development/standards/product-quality.md`](./system/docs/development/standards/product-quality.md)
- Release proof plan: [`system/docs/development/standards/release-proof-plan.md`](./system/docs/development/standards/release-proof-plan.md)
- Contributing: [`CONTRIBUTING.md`](./CONTRIBUTING.md)
- Governance contract: [`AGENTS.md`](./AGENTS.md)
