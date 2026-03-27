---
scope: system/tools/poly/** + system/docs/development/product/v3*
status: archived
date: 2026-03-06
review_mode: execution
---

# V3 Overall Code Review

Resolution note:
- All findings in this review were closed on 2026-03-06.
- Closure evidence is recorded in `system/docs/development/bug-evidence-archive.md`.

Reviewed scope:
- commit `d9b3d92` ("feat: complete v3 platform and contract closure")
- V3 CLI surfaces (`plugin`, `demo`, `health`, `blueprint`, `diff --runtime`, command discoverability)
- plugin trust and lock behavior

Method:
- static code inspection
- command behavior tracing
- cross-check against AGENTS.md hard contract

## Stage 1 — AGENTS.md Contract Review

Findings are ordered by severity.

### 1) HIGH — Plugin trust policy can be bypassed for PATH-based executables

Contract impact:
- AGENTS rule 3 (Security first)
- AGENTS rule 1 (strict execution behavior) because trust checks appear enforced but can be skipped in common paths.

What happens:
- `ValidateTrust` returns success when descriptor has digest but executable file is not found locally.
- for PATH-based executables (for example `poly-topology`), `os.Stat("poly-topology")` fails in project root, so digest verification is skipped.
- runtime bridge then executes the command from PATH anyway.

Code references:
- `system/tools/poly/internal/pluginops/pluginops.go:350`
- `system/tools/poly/internal/pluginops/pluginops.go:363`
- `system/tools/poly/internal/cli/v3.go:159`
- `system/tools/poly/internal/cli/v3.go:171`

Risk:
- managed plugins with pinned digest can run unverified binaries from PATH.
- weakens auditability and trust policy guarantees.

Recommendation:
- for PATH-style executables, resolve absolute path via `exec.LookPath` during trust verification and verify digest against that binary.
- fail closed when digest is set but binary cannot be resolved.

### 2) HIGH — `poly demo` runs repository runtime, not generated demo project runtime

Contract impact:
- AGENTS rule 1 (strict execution mode / no misleading behavior)
- product contract drift: command advertises first-success demo for created project, but runtime action targets monorepo deployment stack.

What happens:
- `runDemo` creates project directory and `chdir`s into it,
- but `runRuntimeCommand` is called with `root` (repo root),
- compose contract uses repo deployment files (`deployment/compose/...`) from that root.

Code references:
- `system/tools/poly/internal/cli/v3.go:577`
- `system/tools/poly/internal/contracts/compose.go:51`
- `system/tools/poly/internal/contracts/compose.go:68`

Risk:
- `poly demo` mutates/starts monorepo infra instead of demo project infra.
- confusing and potentially destructive for operators expecting isolated demo behavior.

Recommendation:
- either:
  - make `poly demo` explicitly shell into demo project context and use project-local runtime contract, or
  - clearly label command as monorepo showcase and do not create project scaffolds in the same flow.

### 3) MEDIUM — Plugin bridge is fail-open on lock/read errors

Contract impact:
- AGENTS rule 1 and rule 10 (strictness + evidence-quality behavior).

What happens:
- `runPluginBridge` ignores lock loading errors (`if err == nil && found { ... }`),
- on lock parse/read failure it falls through to unmanaged PATH fallback.

Code references:
- `system/tools/poly/internal/cli/v3.go:158`
- `system/tools/poly/internal/cli/v3.go:176`

Risk:
- corrupted/invalid managed plugin state can silently downgrade into unmanaged execution path.
- difficult to audit and debug.

Recommendation:
- fail closed when managed lock read/parsing fails.
- print explicit remediation (`poly plugin list` / lock repair).

## Stage 2 — Independent Engineering Review (Beyond AGENTS)

### 4) MEDIUM — `plugin install` fallback UX for unknown registry plugin is ambiguous

What happens:
- unknown plugin in registry falls back to synthetic local descriptor (`0.0.0-local`) and later fails validation if flags are incomplete.

Code references:
- `system/tools/poly/internal/cli/v3.go:273`
- `system/tools/poly/internal/cli/v3.go:280`

Risk:
- user sees low-signal failure (`executable/source required`) instead of clear `plugin not found`.

Recommendation:
- split explicit modes:
  - registry install (default, fail if not found),
  - local descriptor install (`--local` or `--exec` required).

### 5) MEDIUM — `plugin update` does not preserve local override fields except command

What happens:
- update path copies only command from currently installed descriptor;
- executable/source/digest/signature_mode may be replaced by registry entry unexpectedly.

Code reference:
- `system/tools/poly/internal/cli/v3.go:407`

Risk:
- previously trusted local pin can be silently changed by update.

Recommendation:
- document and enforce merge strategy:
  - either registry is authoritative (explicit warning),
  - or preserve local overrides unless `--reset-overrides` is passed.

### 6) LOW — `poly diff --runtime` is informational-only with zero exit code even on drift

What happens:
- runtime diff prints missing/unhealthy services but always exits `0`.

Code references:
- `system/tools/poly/internal/cli/product.go:470`
- `system/tools/poly/internal/cli/product.go:484`

Risk:
- less useful in automation/CI where non-zero on drift is often required.

Recommendation:
- add optional strict mode (`--strict`) returning non-zero on missing/unhealthy drift.

## Positive Notes

- V3 command surface is coherent and significantly improved for discoverability.
- plugin contract/trust docs are strong and traceable.
- tests for new V3 slices exist and compile coverage is reasonable for first cut.

## Suggested Next Fix Order

1. Fix digest/path trust verification (HIGH).
2. Correct `poly demo` runtime targeting (HIGH).
3. Make plugin bridge fail closed on lock errors (MEDIUM).
4. Clarify local vs registry install/update semantics (MEDIUM).
5. Add strict runtime diff mode (LOW).

Offload note: No offload recommended for this step.
