# Project Type Profile: Library

Version: 1.0.0
Status: Normative
Applies when: project `AGENTS.md` declares `library` or inference detects a
reusable package/library structure.

## Scope

This profile applies to projects that publish reusable code consumed by other
projects as a dependency.

## Architecture Expectations

- public API surface is small, stable, and documented
- internal implementation is replaceable without breaking the public contract
- versioning follows semver or equivalent
- no hidden side effects on import or require

## Validation Expectations

- automated test suite covering the public API
- consumer-facing examples or integration tests
- no reliance on global state or environment for core functionality

## Release Expectations

- changelog maintained
- breaking changes documented
- migration guide for major versions
- published artifact matches the tested artifact

## Evidence Expectations

- test coverage reported
- public API stability tracked across versions
