# Recursive Governance Review Contract

Version: 1.0.0
Status: Normative

## Purpose

Define the mandatory review loop that must complete before any commit.
Passing tests alone is not commit permission. Passing static analysis alone is
not commit permission. Passing gates alone is not commit permission.

## Required Loop

```
implement/fix → validate → run gates → recursive governance review →
fix BLOCKER/HIGH/MEDIUM → rerun validation → rerun review → commit
```

### Step 1: Implement or Fix

Make the code or governance change.

### Step 2: Validate

Run the project's canonical validation entrypoint.
Record results in `.agents/management/evidence/validation/`.

### Step 3: Run Gates

Verify quality gates from `quality-gates.md` are satisfied for the touched
scope.

### Step 4: Recursive Governance Review

Review the change against the applicable governance stack:

1. Does the change obey the applicable profiles?
2. Does the change maintain the architecture standard?
3. Does the change preserve security posture?
4. Is the evidence recorded?
5. Is the management state updated?
6. Are docs still accurate?

Record review findings in `.agents/management/evidence/reviews/`.

### Step 5: Fix Findings

Fix all BLOCKER, HIGH, and MEDIUM findings.
Fixing a finding invalidates the previous validation — you must revalidate.

### Step 6: Rerun Validation

After fixes, rerun validation. Record new results.

### Step 7: Rerun Review

After fixes and revalidation, rerun the governance review.
Only a clean review (no BLOCKER/HIGH/MEDIUM) allows proceeding to commit.

### Step 8: Commit

Only after the loop is clean:

- validation passes
- gates pass
- review shows no BLOCKER/HIGH/MEDIUM
- evidence is recorded
- management state is updated

## FULL_GREEN Definition

FULL_GREEN requires:

- zero unresolved findings at any severity above LOW
- all validation passing
- all gates satisfied
- evidence recorded
- human dashboard updated (if significant)

## Accepted YELLOW Debt

YELLOW debt (accepted MEDIUM findings that are deferred) requires ALL of:

- `owner`: who owns the resolution
- `target`: what the resolution looks like
- `risk`: what happens if not resolved
- `expiry`: when it must be resolved by
- `evidence`: link to the finding
- `blocking_decision`: explicit decision to accept, recorded in DECISIONS.md

YELLOW debt without all six fields is not accepted — it is unresolved.

## Finding Severity

- `BLOCKER`: must fix before commit
- `HIGH`: must fix before commit
- `MEDIUM`: must fix or explicitly accept as YELLOW debt before commit
- `LOW`: may be deferred to backlog without ceremony

## Rule

Fixing validation invalidates previous review. The loop must restart from
Step 2 after any fix. This prevents "reviewed once, fixed silently, committed
without re-review."
