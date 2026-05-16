# EVIDENCE — Human Dashboard

This folder is the human-readable project evidence dashboard.

It summarizes and links to detailed machine evidence stored in
`.agents/management/evidence/`.

## Rules

- This dashboard is for humans. Keep it small and scannable.
- Raw outputs, recursive reviews, and validation logs do not go here.
- Every file in this folder must link to its machine evidence source.
- Evidence duplication between this dashboard and machine evidence is forbidden.
- If a dashboard file grows beyond a single screen, move detail to machine
  evidence and link.

## Files

| File | Purpose |
|:---|:---|
| `CURRENT.md` | Current operational state snapshot |
| `ACTIVE_PLAN.md` | Current phase and active execution plan |
| `FLOW.md` | High-level execution flow and phase transitions |
| `CHANGELOG.md` | Summary of completed changes |
| `DONE.md` | Archive of completed work items |
| `LINKS.md` | Quick reference links to machine evidence |

## Machine Evidence Location

Detailed machine evidence lives in `.agents/management/evidence/`:

- `phases/` — per-phase evidence bundles
- `reviews/` — recursive governance review findings
- `validation/` — validation command outputs and gate results
- `security/` — security audit evidence
- `performance/` — performance measurement evidence
- `releases/` — release evidence bundles
- `truth/` — truth reconciliation records
- `raw/` — raw machine outputs and logs
