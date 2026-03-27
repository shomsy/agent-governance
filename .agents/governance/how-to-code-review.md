# How To Code Review

Version: 1.0.0
Status: Normative

## Review Priorities

Review in this order:

1. correctness and regressions
2. security and secret handling
3. contract drift
4. missing tests or validation
5. maintainability and clarity

## Required Output Shape

A review should list:

1. findings first, ordered by severity
2. open questions or assumptions
3. short change summary only after findings

If no findings are discovered, say that explicitly and still mention residual risks or testing gaps.
