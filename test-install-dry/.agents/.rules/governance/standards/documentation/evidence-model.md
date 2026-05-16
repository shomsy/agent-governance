# Enterprise Evidence Model

Version: 3.0.0
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

## Enterprise Evidence Lifecycle

1. **Capture**: Agent completes work and records evidence (validation, test, review) into `.agents/management/evidence/`.
2. **Traceability**: All evidence MUST contain a reference to the triggering task, PR, or decision.
3. **Indexing**: `evidence/truth/` maintains an index of active evidence packs.
4. **Archival**: Evidence older than 30 days or belonging to closed releases is moved to `evidence/archive/`.
5. **Retention Policy**: Raw outputs are kept for 7 days. Release packs and audit packs are kept forever.

## Evidence Packs

- **Release Evidence Packs**: Snapshot of code state, validation, security review, and performance tests at release.
- **Audit Evidence Packs**: Rollup of recursive reviews and security findings for compliance.
- **Rollback Evidence Packs**: Evidence generated when a rollback occurs, detailing the reason and recovery state.

## Anti-Bloat Enforcement

1. **Raw Outputs Forbidden**: Raw logs, stack traces, and verbose outputs are strictly forbidden in `EVIDENCE/`.
2. **Recursive Review Logs Forbidden**: Review findings go to `evidence/reviews/`, never to the human dashboard.
3. **Root Dashboard Size Policy**: No file in `EVIDENCE/` may exceed 150 lines. Overflows must be pushed to machine evidence.
4. **Stale Evidence Detection**: Evidence without an active task or release reference older than 14 days is flagged as stale.
5. **Orphan Evidence Detection**: Machine evidence not referenced by any human summary is orphaned and subject to archival.

## Adoption

Projects that do not need the full evidence model may use a subset.
The minimum viable evidence setup is:

- `EVIDENCE/CURRENT.md`
- `EVIDENCE/CHANGELOG.md`
- `.agents/management/evidence/validation/`
