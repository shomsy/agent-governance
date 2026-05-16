---
scope: system/tools/poly/**,.github/workflows/**,Taskfile.yml,system/docs/development/governance/**
contract_ref: v1
status: stable
---

# CI Profile Contract

Version: 1.0.0  
Status: Normative / Enforced  
Scope: `.github/workflows/**`, `system/tools/poly/cmd/poly`, `system/tools/poly/internal/runner`

---

## 1) Purpose

Keep CI deterministic and decoupled from internal gate script paths.

Hard rule:

- CI workflows call only `bash system/gates/run <profile>`.
- CI must not hardcode internal `check-*` / `scan-*` script lists as merge law.
- Workflows pulling external module images from GHCR must declare `permissions: packages: read`.

---

## 2) Canonical Gate Profiles

The only canonical profiles are:

- `p0`
- `full`
- `nightly`
- `docs`

`--changed` is local-only optimization and must never be merge law.

---

## 3) Workflow Mapping (Frozen v1)

- `.github/workflows/pr-gates.yml` -> `bash system/gates/run p0`
- `.github/workflows/nightly-suite.yml` -> `bash system/gates/run nightly`
- `.github/workflows/security-suite.yml` -> `bash system/gates/run nightly`
- `.github/workflows/release-proof.yml` -> `bash system/gates/run full`

Any new workflow must keep this contract and justify why an existing profile cannot be reused.

---

## 4) Change Policy

A profile/workflow mapping change requires:

1. Risk statement (what breaks if we do nothing),
2. Owner lane in `TODO.md`,
3. Rollback note (how to restore previous mapping),
4. Evidence command output in `system/docs/development/evidence/archives/evidence-archive.md`.

---

## 5) Docs Runtime Mode Lock (CI)

For merge-law CI jobs:

- docs validation must use the pinned external `doc-engine` module runtime.
- if GHCR denies the pinned module image pull but the module lock pins source
  repository + revision, the canonical Docker path may bootstrap that same
  module image from the pinned source revision.
- fallback output must say which canonical Docker mode ran.
- workflows must not opt into local-binary preference for docs validation.
- CI output must keep canonical/non-canonical mode visibility when fallback paths are used.

---

## 6) Timeout and Evidence Policy (CI)

- default runner timeout for external commands is `5m`; workflows may override only when lane requirements justify it.
- workflows that execute release/Argo proof flows must keep evidence writes fail-closed by default.
- unsafe evidence bypass is forbidden in merge-law CI jobs.

---

## 7) Verification

Use:

- `bash system/gates/run p0`
- `bash system/gates/run docs`
- `./system/tools/poly/bin/poly gate check ci-profile-contract`
- `./system/tools/poly/bin/poly gate check ci-runner-entrypoint`
- `./system/tools/poly/bin/poly gate check root-surface`

CI can add deeper profiles, but merge law remains profile-driven through the Poly CLI runner.
