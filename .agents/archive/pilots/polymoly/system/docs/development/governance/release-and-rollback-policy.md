---
scope: system/tools/poly/**,.github/workflows/**,Taskfile.yml,system/docs/development/governance/**
contract_ref: v1
status: stable
---

Shared baseline: `system/docs/development/governance/shared/agent-harness/release-and-rollback-policy.md`
Upstream source: `system/docs/development/governance/upstream-source.lock.json`
Local role: PolyMoly-specific release, rollback, and evidence policy

# Release and Rollback Policy (PolyMoly)

Version: 1.0.0
Status: Normative / Enforced
Scope: release-impacting changes

---

## 1) Promotion Path

Mandatory path:

1. local proof,
2. stage proof,
3. prod release.

No direct prod jump without explicit approval.

---

## 2) GO / NO-GO Release Gate

GO requires all:

1. required lane gates green,
2. hardening gate green,
3. release evidence logged,
4. rollback path defined.

Any failed mandatory gate = NO-GO.

Stage and resilience release lanes must bootstrap runtime TLS certificates before compose startup.
This keeps SNI/TLS behavior deterministic for `stage-load-smoke` and `circuit-breaker-proof`.

---

## 3) Rollback Contract

Every release-impacting change must define:

1. rollback trigger,
2. rollback command/workflow,
3. expected recovery signal,
4. evidence artifact path.

---

## 4) Evidence Requirements

For release candidate:

- command/gate list + results,
- artifact references,
- binary distribution bundle (`dist/poly/<version>/*`),
- checksums file (`dist/poly/<version>/checksums.txt`),
- final GO/NO-GO statement,
- backlog status sync.

---

## 5) Versioning Discipline (SemVer)

- Release tags follow `vMAJOR.MINOR.PATCH`.
- `MAJOR`: breaking contract change.
- `MINOR`: backward-compatible feature.
- `PATCH`: bugfix/hardening without contract break.

Rollback note is mandatory for every `MINOR` and `MAJOR` release candidate.
