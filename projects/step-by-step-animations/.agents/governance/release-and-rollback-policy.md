# Release And Rollback Policy

This document defines promotion and rollback expectations.

## Promotion Path

1. local verification
2. review and risk check
3. release readiness check
4. promotion
5. post-release validation

## GO / NO-GO Contract

Release is `GO` only when:

- critical and high findings are resolved
- known risks are documented with explicit acceptance
- required verification paths passed
- rollback route is clear and tested at least conceptually

Release is `NO-GO` when any of the above is missing.

## Rollback Contract

- rollback must restore last known healthy behavior
- rollback path must be documented before promotion
- rollback decision and cause must be logged in `management/evidence/CHANGELOG.md`
- post-rollback follow-up must be captured in `management/BUGS.md` or `management/TODO.md`
