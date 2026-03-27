# AGENTS.md — PolyMoly Local Contract

Version: 6.2.1
Status: Normative / Local
Scope: `./**`

This file is the local child contract for PolyMoly.
The reusable base rules live in `PARENT-AGENTS.md`, vendored from
`shomsy/agent-governance`.
The shared governance snapshot for this repository lives under
`system/docs/development/governance/shared/agent-governance/**`.

Do not treat the upstream GitHub repository as a live runtime dependency.
PolyMoly uses explicit vendor-copy sync with a locked source commit.

---

## 0) Order Of Precedence (Mandatory)

Agents MUST follow this order:

1. `AGENTS.md`
2. `PARENT-AGENTS.md`
3. `system/docs/development/governance/execution-policy.md`
4. `system/docs/development/governance/how-to-code-review.md`
5. `system/docs/development/governance/how-to-document-flow.md`
6. `system/docs/development/governance/how-to-coding-standards.md`
7. `system/docs/development/governance/how-to-document.md`
8. `system/docs/development/governance/chatgpt-offload-policy.md`
9. `system/docs/development/governance/release-and-rollback-policy.md`
10. `system/docs/development/governance/ci-profile-contract.md`
11. `system/docs/development/governance/review-template.md`
12. `system/docs/development/governance/team-operating-model.md`
13. `system/docs/development/governance/shell-debt-reduction-plan.md`
14. `system/docs/development/governance/shared/agent-governance/**`
15. `TODO.md`
16. `BUGS.md`
17. `README.md`
18. `system/docs/**`
19. `system/runtime/capabilities/security/policies/**`

If documents conflict, higher priority wins.
Conflict must be recorded in `TODO.md` or `BUGS.md`.

---

## 1) Local Product Contract

PolyMoly is not only code. It is a product surface, an operator surface, and a
release system. All three MUST stay aligned.

Priority order:

1. correctness and trust,
2. safety and recoverability,
3. clarity and operability,
4. deterministic automation,
5. speed,
6. feature breadth.

Local north-star rules:

1. Product surface and production surface are one system: install, help,
   runtime, release, rollback, and docs must describe the same behavior.
2. Runtime evidence can correct docs and backlog truth, but unexplained runtime
   drift must be recorded as a defect or explicit follow-up, not normalized by
   prose alone.
3. `production ready` is a proof label, not a tone label.
4. Prefer the most understandable design that preserves rollback,
   diagnosability, and operator trust.
5. Naming is part of operability: folder says the flow, file says the
   responsibility, function says the exact action.

---

## 2) Required Local Definitions

### Canonical validation entrypoint

Use `poly gate run <profile>`.

Canonical source-native form:

- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run p0`
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run full`
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run nightly`
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run docs`
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run --changed` (local optimization only)

### Canonical local development entrypoint

Use the source-native CLI entrypoint:

- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly`

Optional local build:

- `task poly:build`
- generated local binary: `./system/tools/poly/bin/poly`

### Canonical release or publish entrypoint

CI profile entrypoints:

- PR gates: `bash system/gates/run p0`
- nightly gates: `bash system/gates/run nightly`

Review-pack entrypoint before final done report:

- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly review pack <target-dir>`
- use `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly review pack .` when governance, evidence, or multiple lanes are touched

### Project-specific architecture boundaries

- `product/` owns user-facing vocabulary.
- `system/engine/request/`, `system/engine/resolve/`,
  `system/engine/preview/`, and `system/engine/apply/` own engine law.
- `system/adapters/` owns execution boundaries.
- lower layers must not redefine upper-layer law.
- do not reintroduce a second physical `system/engine/core/` tier unless
  architecture docs, placement proof, and convergence gates are reopened
  together.
- UI emits intent; UI must not become a second resolver.

### Project-specific safety exceptions

- `poly gate run docs` and CI profile execution use the pinned external
  `doc-engine` module runtime as the canonical path.
- a local `doc-engine` binary is allowed only as an explicit opt-in
  convenience for `poly docs ...`, and must be marked as non-canonical in
  output.

---

## 3) Local Non-Negotiable Rules

1. Backlog ownership:
   - feature and platform work in `TODO.md`
   - bug, risk, and regression findings in `BUGS.md`
2. Gate profile freeze: only `p0`, `full`, `nightly`, and `docs` are
   canonical profiles.
3. Diff-aware runs are local optimization only, not merge law.
4. Evidence write lock:
   - release and ArgoCD proof commands must hard-fail when mandatory evidence
     artifacts cannot be written
   - unsafe bypass is allowed only through explicit `--no-evidence` plus
     `POLY_ALLOW_NO_EVIDENCE=1`, with a visible `UNSAFE MODE` banner
5. Timeout policy:
   - external command execution defaults to `5m`
   - lane, step, and explicit command overrides are allowed
   - the effective timeout must be visible in run summary artifacts
6. Interaction modes:
   - `MODE: BRAINSTORM` = non-canonical draft path
   - `MODE: EXECUTION` = canonical delivery path
   - when no mode token is present, execution behavior is the default
7. Promotion rule: any change intended for merge or release must finish in
   `MODE: EXECUTION`.
8. Missing trust input, policy input, evidence artifact, or mandatory contract
   data must fail closed.
9. Unsafe behavior must require explicit opt-in and visibly unsafe output.
10. Success output must not be emitted when the required runtime action, proof,
    or artifact is absent.
11. Docs drift is a real bug.
12. Observability is part of the feature for runtime and release-impacting
    flows.
13. Every mutation needs a safety shape: preview, diff, confirmation, rollback,
    or explicit audit evidence.
14. Compatibility changes require migration or rollback language.
15. Machine-readable surfaces are first-class outputs.
16. Performance claims require measurement artifacts or gates.
17. Product claims must map to a real shipped command path.
18. Production docs must use simple English.
19. Every TODO closes through a review loop until no open `high` or `critical`
    findings remain in scope and the touched system slice is defensibly
    production ready.

---

## 4) Local Delivery Flow

Required iteration declaration:

1. primary goal
2. non-goals
3. constraints
4. completion criteria
5. lane (`runtime-hardening`, `platform-feature`, `observability`,
   `release-engineering`, `configurator`, `governance`, or clearly equivalent)

Required execution flow:

1. classify the lane
2. map to `TODO.md` or `BUGS.md`
3. implement the minimal safe delta
4. run the required validation
5. record evidence
6. update backlog truth
7. commit and push unless the user explicitly blocks publish

Required execution behavior:

1. leave the repo in a runnable or valid state after each pass unless the work
   is docs-only
2. review until risk converges instead of stopping at the first obvious fix
3. do not silently widen the iteration scope
4. do not claim `production ready` unless the formal proof conditions are met

### Docs-Only Execution

When iteration scope is docs-only:

1. runtime code changes are forbidden unless explicitly approved
2. docs links and contract wording must be validated
3. evidence must still be recorded
4. backlog state must still be synchronized

---

## 5) Enterprise-Grade Delivery Filters

Before marking work complete, agents MUST be able to defend these questions:

1. Trust: does the change fail closed when required trust or evidence is
   missing?
2. Operator clarity: can another operator understand failure, recovery, and
   artifact paths without tribal knowledge?
3. Rollback: is there an explicit rollback or containment path for
   release-impacting behavior?
4. Compatibility: does the change preserve existing contracts or clearly
   document migration impact?
5. Automation: can CI, scripts, or other tools consume the result
   deterministically?
6. Observability: do logs, checks, summaries, and exit codes make behavior
   diagnosable?
7. Performance posture: are new latency, scale, or offline claims measured or
   intentionally left unclaimed?
8. Security posture: does the change preserve least privilege, secret hygiene,
   and policy boundaries?
9. Docs truth: do help text, README, governance docs, and product docs still
   describe the shipped system accurately?
10. Production-ready truth: if the label is claimed, are no open
    `high` or `critical` findings present, are required gates green, and are
    release proof artifacts present?

If any answer is `no`, the work is not finished.
