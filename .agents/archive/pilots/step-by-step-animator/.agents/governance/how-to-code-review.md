# How To Code Review

This document defines the minimum review quality bar.

## Review Priorities

Review in this order:

1. correctness and regressions
2. security and secret handling
3. architecture boundary violations
4. missing or weak tests
5. maintainability and clarity

## Required Output Shape

Every review should provide:

- findings first, sorted by severity
- exact file references
- clear risk statement for each finding
- explicit "no findings" statement when clean
- residual risks and testing gaps even when clean

## Severity

- `critical`: production breakage, data loss, or security compromise
- `high`: major incorrect behavior or high-probability regression
- `medium`: meaningful defect or reliability risk
- `low`: clarity or maintainability issue with limited immediate risk

## Rules

- do not hide blocking findings behind summary text
- do not approve if critical or high findings are unresolved
- propose smallest safe fix
- keep review language concrete and testable
