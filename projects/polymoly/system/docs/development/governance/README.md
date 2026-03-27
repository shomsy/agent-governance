---
scope: system/docs/development/governance/**
contract_ref: v1
status: stable
---

# Governance Source Map

This directory is split into two layers:

1. local PolyMoly governance contracts
2. vendored shared governance from `shomsy/agent-governance`

PolyMoly does not read the upstream GitHub repository at execution time.
The linkage is explicit, versioned, and local.

## Layout

- `PARENT-AGENTS.md`
  Vendored shared parent contract copied from `agent-governance`.
- `shared/agent-governance/**`
  Vendored snapshot of reusable governance documents.
- top-level files in this directory
  PolyMoly-specific governance overlays, extensions, and local operating rules.
  This includes the independent strict-review contract.

## Precedence Model

PolyMoly uses explicit local override:

1. local `AGENTS.md`
2. vendored `PARENT-AGENTS.md`
3. local governance files in this directory
4. vendored shared docs under `shared/agent-governance/**`
5. backlog, README, and broader `system/docs/**`

That means:

- shared docs define reusable baseline rules
- PolyMoly local docs define product-specific commands, boundaries, and release
  behavior
- conflicts resolve in favor of the local repository contract

## Sync Contract

Source of truth for the vendored layer:

- repo: `https://github.com/shomsy/agent-governance`
- lock file: `system/docs/development/governance/upstream-source.lock.json`
- sync helper: `system/scripts/governance/sync-agent-governance.sh`

Sync is intentional, not automatic:

1. update or clone `agent-governance`
2. run the sync helper
3. review local overrides for drift
4. run docs validation and review pack
5. update evidence before completion

## Managed Upstream Files

- `PARENT-AGENTS.md`
- `shared/agent-governance/execution-policy.md`
- `shared/agent-governance/how-to-code-review.md`
- `shared/agent-governance/how-to-coding-standards.md`
- `shared/agent-governance/how-to-document.md`
- `shared/agent-governance/release-and-rollback-policy.md`

## Local Overlay Highlights

- `how-to-code-review.md`
- `how-to-document-flow.md`
- `how-to-strict-review.md`
- `execution-policy.md`
- `review-template.md`
