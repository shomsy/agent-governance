---
scope: system/tools/poly/**,.github/workflows/**,system/docs/development/**
contract_ref: v2
status: stable
---

# Release Proof Plan

One sentence: This page maps the production-readiness proof surface to the exact CI workflow or runtime proof that closed it.
One sentence: It matters because a release decision must come from reproducible evidence, not memory or manual interpretation.

---

## Objective

Record the canonical CI and local-equivalent proof paths that close the product-quality gap.

This document does not redefine architecture.
It defines the proof lanes that make a release decision reviewable.

---

## Gap To Workflow Map

| Gap | Proof type | Existing path | Required artifact |
| --- | --- | --- | --- |
| Promoted runtime boot + hardening proof | Docker-backed runtime proof | `promoted-runtime-proof.yml` | inspect + smoke + image evidence |
| Staging load proof | k6 runtime proof | `weekly-resilience-proof.yml` | latency and error summary |
| Circuit breaker proof | controlled failure proof | `release-proof.yml` lane `circuit-breaker-proof` | trip + recovery summary |
| Container hardening runtime proof | inspect proof | `promoted-runtime-proof.yml` | inspect snapshots |
| Backup / restore drill proof | restore proof | `backup-restore-serving-proof.yml` | restore verification summary |
| Release distribution bundle | multi-platform binary proof | `release-distribution.yml` | `dist/poly/<version>/*` + `checksums.txt` + channel metadata |
| Final release bundle | aggregate release evidence | `release-proof.yml` | one reviewable bundle |

---

## Recommended Workflow Shape

### 1. `promoted-runtime-proof.yml`

Purpose:

- build the promoted production overlay
- bring up the promoted stack in a Docker-enabled runner
- capture real runtime inspect evidence and per-image release artifacts

Suggested steps:

1. prepare Docker secret files for the promoted stack
2. `docker compose --project-directory . -f system/adapters/docker/compose.yaml -f system/adapters/docker/compose.prod.yaml build`
3. `docker compose --project-directory . -f system/adapters/docker/compose.yaml -f system/adapters/docker/compose.prod.yaml up -d`
4. `docker inspect` selected services
5. run gateway smoke from an external probe container
6. generate per-image SBOM + provenance artifacts
7. capture:
   - `User`
   - `ReadonlyRootfs`
   - `CapDrop`
   - mounts
   - network attachments
8. store artifacts under `system/gates/artifacts/promoted-runtime-proof/`

Pass criteria:

- all promoted services match hardening contract
- no unexpected bind mounts remain

### 2. `weekly-resilience-proof.yml`

Purpose:

- run the declared k6 scenarios on the staging path

Suggested steps:

1. bring up staged target stack
2. run the weekly HA drill
3. run the weekly k6 gateway smoke
4. collect:
   - latency summary
   - error rate summary
   - saturation signals
   - pass/fail decision file

Artifact path:

- `system/gates/artifacts/weekly-resilience-proof/`

Pass criteria:

- p95/p99 within target
- error rate within target
- no uncontrolled queue or retry growth

### 3. `release-proof.yml` lane `circuit-breaker-proof`

Purpose:

- prove trip and recovery on the real runtime path

Suggested steps:

1. bring up staged target stack
2. run failure injection through `poly resilience circuit-breaker-proof`
3. capture:
   - breaker open event
   - fallback response proof
   - recovery proof

Artifact path:

- `system/gates/artifacts/circuit-breaker-proof/`

Pass criteria:

- breaker trips when expected
- fallback is visible
- breaker closes cleanly after recovery

### 4. `backup-restore-serving-proof.yml`

Purpose:

- prove restore, not just backup creation

Suggested steps:

1. bring up the promoted data + app path
2. generate a fresh backup artifact
3. restore PostgreSQL into a clean target
4. restore MySQL into a clean target
5. run verification queries
6. run an app-level DB read smoke after restore
7. optionally run PITR verification if the promoted path requires it

Artifact path:

- `system/gates/artifacts/restore-serving-proof/`

Pass criteria:

- restored services start
- verification query succeeds
- restore summary says `PASS`

### 5. `release-proof.yml`

Purpose:

- aggregate all release evidence into one canonical bundle

Suggested steps:

1. collect artifacts from:
   - `promoted-runtime-proof`
   - `ha-failure-demo`
   - `stage-load-smoke`
   - `circuit-breaker-proof`
   - `restore-serving-proof`
   - `dist/poly/<version>/*`
2. generate:
   - release summary
   - GO / NO-GO statement
   - rollback trigger note
   - rollback command/workflow note
3. upload one bundle

Artifact path:

- `system/gates/artifacts/release-proof/`

Pass criteria:

- all required upstream proofs exist
- final verdict is explicit
- rollback path is included

---

## Execution Order

Run these in this order:

1. `release-distribution.yml`
2. `promoted-runtime-proof.yml`
3. `weekly-resilience-proof.yml`
4. `release-proof.yml` lane `circuit-breaker-proof`
5. `backup-restore-serving-proof.yml`
6. `release-proof.yml`

Reason:

- the release bundle should only aggregate already-proven runtime evidence

---

## Artifact Contract

Every workflow above should produce at minimum:

- `summary.txt`
- `checks.tsv`
- `decision.txt` if the workflow makes a GO / NO-GO claim
- raw supporting logs or JSON outputs when relevant

Naming rule:

- keep artifact directories under `system/gates/artifacts/<workflow-purpose>/`

---

## Final State

When all release lanes and the distribution bundle are green, the remaining proof gap is closed.

At that point:

- `BUGS.md` can move from proof-pending statuses to fully proven statuses
- the release can be reviewed as `Production Ready`
- the decision is backed by CI evidence, not local memory

Observed closure:

- local artifact-equivalent execution was completed on `2026-03-06`
- the same artifact contract remains the CI source of truth for independent witness runs
