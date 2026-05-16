# V3 Hardening — Phase 1: Root Contract Alignment

**Date**: 2026-05-16
**Branch**: main
**Commit at start**: 4563b3aab20e00cd5880ec40720c1e820c12b9b9

## Contract File Status

| File | Old claim | New claim | Decision | Risk |
|---|---|---|---|---|
| Root `AGENTS.md` | Version 2.0.0 | Version 3.0.0 | Bumped to 3.0.0, added new V3 governance entries | LOW |
| `PARENT-AGENTS.md` | N/A (never existed) | N/A | Nothing to do | NONE |
| `README.md` | "Evidence Model (V2)", "Management Model (V2)" | Labels removed; profile table updated with overlays | Updated | LOW |
| `.agents/AGENTS.md` | V3.0.0 — canonical shared contract | Unchanged | Already correct | NONE |
| `EVIDENCE/CURRENT.md` | Claims "V2" model, stale | Claims V3, hardening in progress | Updated | LOW |

## Acceptance Criteria

- [x] No root V1/V2 governance contradiction remains
- [x] Adopting project knows where to start (README adoption flow is clear)
- [x] AGENTS bootstrap path is unambiguous (`.agents/AGENTS.md` is canonical)
- [x] `PARENT-AGENTS.md` — never existed, N/A

## Findings
- NONE blocking
