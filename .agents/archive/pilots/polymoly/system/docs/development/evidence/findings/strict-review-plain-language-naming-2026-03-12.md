---
status: archived
date: 2026-03-12
---

# Strict Review — Plain-Language Naming Convergence

- review date: `2026-03-12`
- review posture: `strict`
- review scope: `plain-language naming pass across CLI routing, profile selection, resolve/config helpers, runtime observation helpers, governance wording, and flow docs`
- reviewer ignored repository self-description as ground truth: `yes`

## Overall Assessment

- quality score: `9.5 / 10.0`
- final decision: `Keep and Improve`
- release judgment: `no open high or critical findings in scope`

This pass removed a second layer of naming friction that remained after the
flow-first rename wave. The main gain is that non-product internals now read
closer to operator intent: `route`, `prepare`, `plan`, `map`, `describe`,
`select`, and `build image` are materially easier to predict than the earlier
`dispatch`, broad `build`, and stray non-canonical `apply` names.

## Findings

No open `critical` findings.

No open `high` findings.

No open `medium` findings.

No open `low` findings.

## Pass-By-Pass Review

### Pass 1: User-Facing And Operator-Facing Language

- Result: `PASS`
- Evidence:
  - CLI routing files now say `route_*_commands.go` instead of `dispatch_*`.
  - gate profile selection now says `select_gate_steps.go` and `RunGateProfile`.

### Pass 2: Internal Action Honesty

- Result: `PASS`
- Evidence:
  - config and observe helpers now say `PrepareInitialIntent`, `PlanIntentChanges`, `MapServiceGraph`, `DescribeRuntimeDelta`, and `CollectRuntimeMetrics`.
  - `Build` now remains only where it is literal enough to survive review, such as `BuildImage`.

### Pass 3: Governance And Docs Truth

- Result: `PASS`
- Evidence:
  - coding standards now explicitly restrict `Build`, `Apply`, and `Run`, and forbid `Dispatch` as a casual default.
  - flow-doc law now forbids prose from excusing implementation-heavy verbs when a plainer action exists.

### Pass 4: Runtime And Validation Safety

- Result: `PASS`
- Evidence:
  - `go test ./...` passed after symbol changes.
  - `poly gate run docs` passed after doc and naming rewrites.

### Pass 5: Backup Review Recoverability

- Result: `PASS`
- Evidence:
  - `poly review pack .` remains the canonical review bundle path.
  - `merge-files.sh .` provides the requested backup review artifact path on the final repo state.

## Keep / Collapse / Delete

- keep:
  - manifest-driven path moves for structural renames
  - operator-readable verbs as the default naming posture
  - canonical product/runtime terms only where they are truly contractual
- collapse:
  - broad `Build*` names that are really planning, reading, selecting, or describing
- delete:
  - casual `dispatch_*` as a default CLI file naming pattern

## First Rewrite Priorities

1. Keep `dispatch` out of new first-party file and function names unless the code is literally a transport-level dispatcher.
2. Allow `build` only for real artifact construction, not for generic planning or description work.
3. Keep `apply` narrow: contractual mutation phases, explicit commit points, or literal external commands.
