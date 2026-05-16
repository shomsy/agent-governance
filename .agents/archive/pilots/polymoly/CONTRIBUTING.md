# Contributing

## Prerequisites

- Go toolchain (for local builds/tests).
- Docker (runtime and many checks).
- Task (`task`) command available.

## Build CLI

```bash
task poly:build
```

## Run Common Verification

```bash
./system/tools/poly/bin/poly gate run p0
./system/tools/poly/bin/poly gate run --changed
```

## Documentation Checks

```bash
./system/tools/poly/bin/poly gate run docs
```

## Backlog Rules

- Feature/platform work goes to `TODO.md`.
- Bug/risk/regression work goes to `BUGS.md`.

## Pull Request Expectations

1. Keep changes scoped and coherent.
2. Keep contracts and docs consistent with code changes.
3. Run required gates for touched surfaces.
4. Keep evidence and backlog state aligned.

## Governance

Before contributing, read:

- [`AGENTS.md`](./AGENTS.md)
- [`system/docs/development/governance/execution-policy.md`](./system/docs/development/governance/execution-policy.md)
