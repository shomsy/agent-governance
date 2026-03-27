# Playback Profiles

This document defines canonical playback operating modes.

## Profiles

### Normal

- default end-user timing
- respects authored durations
- includes standard visual transitions

### Slow

- slower timing for presentation and teaching focus
- preserves flow order and correctness
- must not change canonical state semantics

### Instant

- duration effectively zero
- minimizes or disables visual transitions
- intended for testing, verification, and fast restore

## Rule

Profiles can change timing and presentation behavior.
Profiles must not change lesson meaning or canonical state outcomes.
