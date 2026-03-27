# Test Strategy

Defines verification layers for this repository.

## Layers

- unit tests for pure logic and contracts
- integration tests for flow behavior and boundaries
- regression tests for previously fixed defects
- manual UX verification for lesson playback quality where automation is not yet available

## Rules

- bug fixes should include a regression verification path
- deterministic systems require deterministic tests
- test coverage should follow risk, not vanity metrics

## Current Notes

Baseline strategy established. Per-release runs belong in `TEST_REPORTS.md`.
