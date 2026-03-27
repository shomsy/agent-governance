---
scope: product/**,system/**,system/docs/development/**
contract_ref: v2
status: stable
---

# Product Quality Contract

One sentence: This page defines what PolyMoly quality means when the product is presented as enterprise-grade.
One sentence: It matters because market claims are valid only when the runtime, release path, docs, and operator experience all agree.

---

## Market Quality Means

PolyMoly is allowed to claim enterprise-grade product quality only when all are true:

1. There are no open high-risk findings.
2. All required gates are green.
3. Release-path evidence exists for `local -> stage -> prod`.

Source of truth:

- [AGENTS.md](../../../../AGENTS.md)
- [release-and-rollback-policy.md](../governance/release-and-rollback-policy.md)
- [BUGS.md](../../../../BUGS.md)

---

## Quality Gates

The product is not ready for merge or release when any of these fail:

- correctness or trust is unproven
- rollback is unclear
- docs drift from shipped behavior
- release evidence is incomplete
- operator output requires tribal knowledge
- CLI, runtime, and release surfaces disagree

---

## Proof Areas

### 1. Promoted Runtime Boot + Hardening Proof

Goal:

- prove that the promoted production stack builds, starts, serves traffic, and emits inspect evidence from the same run

Required evidence:

- green `promoted-runtime-proof.yml`
- `docker compose ps`, logs, rendered config
- `docker inspect` output for `php`, `node`, `go`, and workers
- gateway smoke through the promoted stack
- image-level SBOM + provenance artifacts

Pass criteria:

- promoted stack boots without shell-only assumptions
- runtime limits are visible in inspect output
- no service runs as root where policy forbids it
- `read_only` and volume policy match overlay expectations
- image evidence is tied to the same build output

Current tracking:

- closed in `system/docs/development/evidence/archives/bug-evidence-archive.md`

### 2. Staging Load Proof

Goal:

- prove that p95/p99 latency and backpressure behavior hold under real k6 load on the staging path

Required evidence:

- green `weekly-resilience-proof.yml` load job
- k6 steady gateway smoke artifact
- summary artifact with latency, error rate, and saturation outcome

Pass criteria:

- p95/p99 stay within declared SLO targets
- no uncontrolled timeout growth
- no queue runaway or retry storm

Current tracking:

- closed in `system/docs/development/evidence/archives/bug-evidence-archive.md`

### 3. Circuit Breaker Runtime Proof

Goal:

- prove that breaker trip, fallback, and recovery behavior work in the real runtime path

Required evidence:

- `poly resilience circuit-breaker-proof` or equivalent staged runtime proof
- one artifact showing trip condition
- one artifact showing recovery condition
- one artifact showing user-visible fallback behavior

Pass criteria:

- breaker trips at the expected threshold
- fallback path is deterministic
- recovery does not flap

Current tracking:

- closed in `system/docs/development/evidence/archives/bug-evidence-archive.md`

### 4. Container Hardening Runtime Proof

Goal:

- prove that the running containers match the hardening contract, not only the source files

Required evidence:

- green `promoted-runtime-proof.yml`
- `docker inspect` proof for `User`
- `docker inspect` proof for `ReadonlyRootfs`
- `docker inspect` proof for `CapDrop`
- `docker inspect` proof for security options

Pass criteria:

- runtime containers match declared hardening settings
- no unexpected writable mounts exist on promoted path

Current tracking:

- closed in `system/docs/development/evidence/archives/bug-evidence-archive.md`

### 5. Backup / Restore Drill Proof

Goal:

- prove that backup data can actually be restored and verified

Required evidence:

- green `backup-restore-serving-proof.yml`
- one successful PostgreSQL restore drill
- one successful MySQL restore drill
- one app-level DB read smoke after restore
- one PITR path confirmation artifact if PITR is part of the promoted data path

Pass criteria:

- restored data is readable
- restored services start cleanly
- verification query matches expected state

Current tracking:

- closed in `system/docs/development/evidence/archives/bug-evidence-archive.md`

### 6. Final Release Evidence Bundle

Goal:

- prove the exact `stage -> prod` release decision with rollback evidence

Required evidence:

- stage proof link
- artifact paths
- release distribution bundle link
- GO / NO-GO statement
- rollback trigger
- rollback command or workflow

Pass criteria:

- release bundle is complete and reviewable by another operator
- rollback path is executable without improvisation
- an independent strict-review report exists when the release is defending a
  `Production Ready` claim or major convergence claim

Required by:

- [release-and-rollback-policy.md](../governance/release-and-rollback-policy.md)
- [how-to-strict-review.md](../governance/how-to-strict-review.md)
- [v3.5-production-ready-review.md](../evidence/findings/v3.5-production-ready-review.md)

---

## Minimum Production Ready Gate Set

This is the minimum set that must be green at the same time for a release decision:

- `./system/tools/poly/bin/poly gate run full`
- `./system/tools/poly/bin/poly gate run docs`
- `./system/tools/poly/bin/poly resilience ha-failure-demo`
- `./system/tools/poly/bin/poly release promoted-runtime-proof`
- `./system/tools/poly/bin/poly release stage-load-smoke`
- `./system/tools/poly/bin/poly resilience circuit-breaker-proof`
- `./system/tools/poly/bin/poly release restore-serving-proof`
- `./system/tools/poly/bin/poly release evidence-index system/gates/artifacts/release-proof`
- `dist/poly/<version>/checksums.txt`
- `system/gates/artifacts/argocd-live/rollback-proof-checks.tsv`

If any one of these is missing, the release stays `NO-GO`.

---

## Decision Rule

PolyMoly can be called `Production Ready` only when:

- the remaining runtime-proof items above are all green,
- the evidence is attached to a release candidate,
- and the rollback path is written down and tested.
- and a current strict-review report exists with no open `high` or `critical`
  findings in the claimed scope.

Current correct label:

- `Production Ready`
