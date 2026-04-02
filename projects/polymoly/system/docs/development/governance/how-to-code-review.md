---
scope: system/tools/poly/**,.github/workflows/**,Taskfile.yml,system/docs/development/governance/**
contract_ref: v1
status: stable
---

Shared baseline: `system/docs/development/governance/shared/agent-harness/how-to-code-review.md`
Upstream source: `system/docs/development/governance/upstream-source.lock.json`
Local role: PolyMoly-specific review depth, lanes, and production-readiness rules

# How To Code Review (PolyMoly)

Version: 1.2.0
Status: Normative / Enforced
Scope: `./**`

This is architecture-first, decision-oriented review.
For independent first-principles challenge review, use
`system/docs/development/governance/how-to-strict-review.md`.

---

## 0) Review Flow Map

```text
[ Scope + Context ]
        |
        v
[ Phase 0: Context Gate ]
        |
        v
[ Phase 1: As-Built Reconstruction ]
        |
        v
[ Phase 2: Stress Test ]
        |
        v
[ Findings: Symptom -> Root Cause -> Impact -> Evidence -> Risk ]
        |
        v
[ Final Decision ]
   | Keep and Improve
   | Redesign
   | Rewrite Candidate
```

Every review must traverse this flow in order.

---

## 1) Review Outcome Contract

Review must end with exactly one:

- Keep and Improve
- Redesign
- Rewrite Candidate

If no decision is possible, review is incomplete.

---

## 2) Phase 0 — Context Gate

Collect before findings:

1. system/layer in scope,
2. runtime context (`local/stage/prod`),
3. in-scope/out-of-scope,
4. compatibility constraints,
5. features/security/performance expectations.

---

## 3) Phase 1 — As-Built Reconstruction

Reconstruct real flow (not intended flow):

`entrypoint -> router -> service -> state mutation -> runtime effect`

Mandatory outputs:

- primary architecture axis,
- responsibility map,
- mutation points,
- failure path map.

---

## 4) Phase 2 — Foundational Stress Test

Check whether architecture scales safely:

1. complexity growth,
2. boundary enforceability,
3. invariant testability,
4. diagnosability of failure.

---

## 5) Lane Checklists

```text
[ runtime-hardening ] [ platform-feature ] [ observability ]
          \\               |               /
           \\              |              /
            +-------- [ release-engineering ] --------+
                             |
                             v
                       [ configurator ]
```

Check all impacted lanes, not only the lane where the change started.

### 5.1 Runtime Hardening

- admin surfaces protected,
- no insecure defaults,
- resource limits enforced,
- container hardening contract intact.

### 5.2 Platform Feature

- deterministic behavior,
- healthy failure paths,
- backward compatibility path,
- rollback path.

### 5.3 Observability

- healthcheck,
- metrics/logs/traces coverage,
- alert/SLO coverage,
- correlation IDs where applicable.

### 5.4 Release Engineering

- promotion contract (`local -> stage -> prod`),
- CI gate integrity,
- artifact integrity,
- rollback workflow completeness.

### 5.5 Configurator

- UI toggle + `.env` generation sync,
- import/export round-trip,
- runtime env mapping correctness,
- no production hardening regression.

---

## 6) Finding Format (Mandatory)

Each finding must include:

- Symptom
- Root Cause
- Impact
- Evidence
- Risk (`low`, `medium`, `high`, `critical`)

---

## 7) Severity Matrix

- `critical`: features/security/data-loss/outage risk -> merge blocked.
- `high`: correctness/regression risk -> merge blocked.
- `medium`: non-blocking, track in `BUGS.md`.
- `low`: improvement/nit.

---

## 8) Deliverables

Review output must include:

1. findings,
2. decision,
3. next steps,
4. backlog mapping.

Tracking rule:

- bugs/risks/regressions -> `BUGS.md`
- feature/expansion follow-ups -> `TODO.md`

---

## 9) Stability Declaration (Optional)

Allowed values:

- Not Stable
- Stable (Pre-Production)
- Production Ready

`Production Ready` requires:

1. no open `high`/`critical` findings,
2. required gates green,
3. release proof artifacts present,
4. full-system review completed for the touched production surfaces.

---

## 10) CI-First Review Cadence

- Prefer CI evidence first.
- Use delta review for scoped changes.
- Use full review for architecture/features/security/release shifts.
- Use strict review for production-ready claims, major convergence claims,
  large restructuring waves, or explicit first-contact challenge requests.

Failed-run triage must include:

1. CI URL,
2. failed job/step,
3. error signature.

## 11) TODO Closure Review Loop

Every TODO item is reviewed in loops, not one pass:

1. run a delta review for the touched files, flows, and gates,
2. fix findings and rerun the relevant tests or gates,
3. repeat until no open `high`/`critical` findings remain for that TODO scope,
4. escalate to full-system review when release, security, architecture,
   governance, cross-lane runtime behavior, or `production ready` claims are
   involved,
5. run a strict review when the change or release needs an independent
   first-principles judgment instead of only AGENTS-converged local review,
6. close the TODO only when acceptance criteria, review pack, evidence, and
   gate results agree,
7. map any remaining `medium`/`low` findings to `BUGS.md` or a new `TODO.md`
   item before closure.
