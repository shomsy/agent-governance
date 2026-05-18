# Recursive Review Contract

Version: 1.0.0
Status: Normative

## Purpose

Define the recursive pre-commit governance review contract that every agent
must traverse before proposing a merge. This contract ensures that no change
commits with unresolved tool-detected findings.

## Finding Closure Contract

Every tool-detected finding MUST transition through the full lifecycle:

```
detected -> classified -> decided -> closed
```

**No Markdown-Only Closure.**

A finding is NOT closed until:
1. The detecting tool reports it fixed (exit code 0 for that finding), OR
2. A machine-verifiable decision exists in `.agents/management/evidence/indexes/finding-decisions.json`

Markdown evidence alone (e.g., a review finding summary in a `.md` file) is
NOT sufficient to close a RED, HIGH, or MEDIUM finding.

## Decision Registry

Every finding must have an entry in the Finding Decision Registry with a valid
decision type:

- `FIXED` — Root cause resolved, tool validates clean
- `ACCEPTED_EXCEPTION` — Intentionally waived with owner, reason, mitigation, expiry
- `DEFERRED` — Tracked in backlog with expiry and promotion condition
- `FALSE_POSITIVE` — Tool error, requires evidence
- `COMPOSITION_ROOT_ALLOWED` — Acceptable at composition root boundary
- `SCAFFOLD_DEFERRED` — Scaffold/template intentionally incomplete
- `TOOLING_BUG` — Detecting tool has a known bug

### Required Fields for Non-FIXED Decisions

| Decision | Requires |
|---|---|
| ACCEPTED_EXCEPTION | owner, reason, mitigation, expiry, evidenceRefs |
| DEFERRED | expiry, promotion condition, backlog link |
| FALSE_POSITIVE | evidence showing tool error |
| COMPOSITION_ROOT_ALLOWED | justification of boundary |
| SCAFFOLD_DEFERRED | adoption condition |
| TOOLING_BUG | bug reference |

## Expiry Policy

Decisions with an `expiry` date MUST be re-evaluated before that date.
Expired decisions revert the finding to ACTIVE (RED) status.

- BLOCKER/HIGH decisions MAY NOT be deferred indefinitely
- ACCEPTED_EXCEPTION decisions MUST have a time-bound expiry
- Expired decisions are detected by `finding_decisions.py expire-check`

## Review Verification

Before approving a merge, the reviewer (human or agent) MUST verify:

1. All detecting tools report GREEN for the touched scope, OR
2. Every remaining finding has an active decision in the registry, AND
3. `finding_decisions.py validate --dir <project>` exits 0, AND
4. `finding_decisions.py expire-check --dir <project>` shows no expired blocking decisions

## Recursive Scope

The review traverses outward from the change:
1. Directly changed files
2. Files imported or called by changed code
3. Governance files that reference changed behavior
4. Evidence files that must reflect the new state

Each level checks for findings. Each finding follows the closure contract.
