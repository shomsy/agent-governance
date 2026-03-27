# PolyMoly V2 Audit Findings

Status: Active findings register  
Owner lane: `platform-feature`  
Last update: 2026-03-06

## Purpose

Capture concrete V2 findings discovered during brainstorming and review.
This file contains structural gaps and quality risks, not feature wishlists.

## Scope

- Product and architecture gaps that need hardening before broad expansion.
- Mapping from findings to active execution items in `TODO.md` or `BUGS.md`.

## Findings

## FINDING-001 — Replace Contract Not Fully Hardened

Status: Resolved  
Priority: P1  
Backlog mapping: `TODO-CLI-REPLACE-HARDENING-44`

Resolution:
- `poly replace` now supports deterministic runtime inference from framework hints, prints the full destructive preview before apply, creates backup artifacts under `.polymoly/backups/`, and preserves sidecar identity across supported scaffold replacements.

Verification:
- direct CLI regression covers framework-inferred replace plus backup/sidecar preservation in `system/tools/poly/internal/cli/product_test.go`.

## FINDING-002 — Canonical State File Decision Is Ratified

Status: Resolved  
Priority: P0  
Backlog mapping: decision log `DEC-2026-03-06-05`

Resolution:
- canonical intent source for v2 is `.polymoly/config.yaml`,
- root `polymoly.yaml` references are treated as legacy/migration-only language.

Follow-up:
- keep docs synchronized with decision log and sidecar contract.

## FINDING-003 — CLI Output Contract Is Not Yet Normative

Status: Resolved  
Priority: P2  
Backlog mapping: `TODO-CLI-OUTPUT-CONTRACT-45`

Resolution:
- core CLI surfaces now share explicit success/warn/fix/next-step framing,
- hints are suppressible through `--quiet` or `POLY_NO_HINTS=1`,
- unknown command, help, onboarding, doctor, runtime, and plan flows all expose the same discoverability contract,
- debug mode is explicit through `poly --debug ...`.

Verification:
- CLI regression covers help surface, completion/tutorial output, advanced wizard flows, plan JSON export, and new runtime coaching paths in `system/tools/poly/internal/cli/*.go` tests.

## FINDING-004 — Framework Scaffolding Scope Is Still Partial

Status: Resolved  
Priority: P2  
Backlog mapping: `TODO-SCAFFOLD-FRAMEWORK-MATRIX-46`

Resolution:
- framework hints are now locked to one documented runtime matrix,
- starter contract provenance is explicit in CLI output and product docs,
- fallback behavior is deterministic: unknown hints fail closed, explicit `--lang` wins, templates remain authoritative unless `--lang` is explicit.

Verification:
- direct tests cover framework inference, explicit override behavior, replace inference, and starter contract output in `system/tools/poly/internal/cli/product_test.go`.

## FINDING-005 — Brainstorm Material Needed Structural Split

Status: Resolved  
Priority: P2  
Backlog mapping: `TODO-BRAINSTORM-DOC-SPLIT-01`

Problem:
- brainstorming, findings, and execution items were mixed in one narrative-heavy stream.

Resolution:
- split completed into:
  - `system/docs/development/findings/v2-audit-findings.md`
  - `system/docs/development/product/v2-execution-backlog.md`
  - `system/docs/development/product/v3-idea-pool.md`

## FINDING-006 — Extensibility Strategy Was Unstructured

Status: Deferred to V3  
Priority: P2  
Backlog mapping: Track L (`TODO-V3-*`)

Problem:
- plugin/extensibility model was identified as strategic but not captured in a structured product roadmap.

Resolution path:
- captured in V3 planning documents for staged promotion.

## Notes

- Findings in this file are implementation-relevant.
- Visionary or speculative ideas must live in `system/docs/development/product/v3-idea-pool.md`.
- Verified mutation-safety bug closure evidence is archived in `system/docs/development/bug-evidence-archive.md`.

Offload note: No offload recommended for this step.
