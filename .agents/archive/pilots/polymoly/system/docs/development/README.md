---
scope: system/docs/development/**
contract_ref: v2
status: stable
---

# Development Source Map

This directory keeps only the active development contract for PolyMoly.

The rule is simple:

- stable law lives here
- one current release file lives here
- evidence lives here
- closed versioned planning waves do not stay in the active tree

## Layout

- `governance/`
  Execution, review, strict-review, release, documentation, and operating rules.
- `architecture/`
  Frozen architecture principles and repository boundary contracts.
- `standards/`
  Product-quality, code-quality, and release-proof quality bars.
- `release/current.md`
  The only active release-planning file.
- `release/current-placement-plan.yaml`
  The active placement or restructuring manifest when a move wave is open.
- `evidence/`
  Findings and archive evidence that preserve execution history.

## Working Model

When a new release starts:

1. update `release/current.md`
2. update `TODO.md` and `BUGS.md`
3. update `release/current-placement-plan.yaml` only if a structural move is required

When a release closes:

1. keep the evidence
2. replace `release/current.md` with the next active release contract
3. do not resurrect versioned roadmap stacks inside the active tree

## Repository Navigation Contract

First-party ownership folders in `product/` and `system/` should carry
`how-this-works.md` files.
Those files are the local human-readable flow map for folder purpose, direct
files, and direct flow-entry functions.
