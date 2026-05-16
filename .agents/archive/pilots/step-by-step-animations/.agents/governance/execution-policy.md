# Execution Policy

This document defines how work is executed from intake to completion.

## Purpose

- keep delivery deterministic
- keep evidence visible
- prevent "done by feeling"

## Execution Mode

- work in small vertical slices
- keep one clear expected outcome per slice
- prefer smallest change that can prove value
- avoid broad parallel edits without a clear integration point

## Iteration Contract

For every non-trivial item:

1. define user outcome
2. define system behavior
3. define visible UX result
4. define learning outcome (if lesson-facing)
5. execute
6. verify
7. record evidence

## Evidence Requirements

Before an item can be considered done:

- acceptance criteria are met
- test strategy is referenced or updated
- risk impact is checked
- result is recorded in `management/evidence/CHANGELOG.md`

## Completion Criteria

Work is complete only when:

- requested behavior exists and is verified
- no known high-severity regressions are introduced
- governance and architecture docs are updated when boundaries changed
- follow-up work is captured in `management/TODO.md` or `management/BUGS.md`
