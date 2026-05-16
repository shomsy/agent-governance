---
scope: system/tools/poly/**,.github/workflows/**,Taskfile.yml,system/docs/development/governance/**
contract_ref: v1
status: stable
---

# Shell Debt Reduction Plan

Status: Active / Updated 2026-03-04
Owner lane: CAKI-SURFACE-03

## Baseline

- Canonical operator and verification entrypoints now belong to the Go Poly CLI.
- Repo-owned shell script count for tracked canonical/operator flows is now `0`.
- Python remains explicit only for `doc-engine` and third-party vendored code under `node_modules`.

## Milestones

### M1 (completed lock cycle)

- Freeze one typed control-plane and remove shell from public entrypoints.
- Move governance/reference/profile drift ownership into Go.

### M2 (completed on 2026-03-04)

- Converted the remaining high-frequency verification and ops adapters to Go slices.
- Rewrote the former Python `core/` proof surface and the former `lanes/ai-district` runtime surface into Go-owned modules.
- Removed tracked repo-owned shell scripts from canonical/operator flows.

### M3 (productization cycle)

- Keep Python explicit only for `doc-engine` until its extraction/defer lane closes.
- Keep shell only in third-party image entrypoints or inline upstream commands that are not repo-owned script files.

## Tracking

- Publish quarterly delta in evidence archive.
- If tracked repo-owned shell script count rises above `0`, open a bug lane immediately.
