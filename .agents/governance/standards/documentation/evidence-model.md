# Evidence Model

Version: 2.0.0
Status: Normative

## Purpose

Define how evidence is structured, stored, and surfaced in any repository
using the Agent Harness operating system.

## Two-Layer Model

### Human Dashboard: `EVIDENCE/`

The root `EVIDENCE/` folder is the human-readable project dashboard.
It contains only summaries that link to machine evidence.

Required files:

| File | Purpose |
|:---|:---|
| `README.md` | Dashboard guide and machine evidence locations |
| `CURRENT.md` | Current operational state snapshot |
| `ACTIVE_PLAN.md` | Current phase and execution plan summary |
| `FLOW.md` | High-level phase transitions |
| `CHANGELOG.md` | Summary of completed changes |
| `DONE.md` | Archive of completed work |
| `LINKS.md` | Quick reference links to machine evidence |

### Machine Evidence: `.agents/management/evidence/`

Machine evidence is the detailed, verbose, agent-generated evidence.

Required subdirectories:

| Directory | Contents |
|:---|:---|
| `phases/` | Per-phase evidence bundles |
| `reviews/` | Recursive governance review findings |
| `raw/` | Raw machine outputs and logs |
| `validation/` | Validation command outputs and gate results |
| `security/` | Security audit evidence |
| `performance/` | Performance measurement evidence |
| `releases/` | Release evidence bundles |
| `truth/` | Truth reconciliation records |

## Rules

1. Root `EVIDENCE/` summarizes and links — it does not contain raw data.
2. Raw outputs never go into root `EVIDENCE/`.
3. Recursive review findings never go into root `EVIDENCE/`.
4. Validation logs never go into root `EVIDENCE/`.
5. Root `EVIDENCE/` must remain readable by a human in under 60 seconds.
6. Machine evidence may be deep and verbose.
7. Every human dashboard file must link to its machine evidence source.
8. Evidence duplication between dashboard and machine evidence is forbidden.
9. Evidence is timestamped. Undated evidence is incomplete.
10. Evidence without a link to the change it proves is incomplete.

## Lifecycle

1. Agent completes work
2. Agent writes machine evidence to `.agents/management/evidence/`
3. Agent updates human dashboard files in `EVIDENCE/` if the change is
   significant
4. Human dashboard stays small — detail lives in machine evidence

## Adoption

Projects that do not need the full evidence model may use a subset.
The minimum viable evidence setup is:

- `EVIDENCE/CURRENT.md`
- `EVIDENCE/CHANGELOG.md`
- `.agents/management/evidence/validation/`
