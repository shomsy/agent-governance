# Execution Profiles

This document defines canonical operating profiles for systems that vary timing,
verbosity, or non-functional behavior.

## Profiles

### Normal

- default end-user or operator behavior
- standard timing, logging, and recovery posture

### Fast

- reduced waiting where correctness is unaffected
- intended for automation, verification, and restore flows

### Diagnostic

- increased visibility into state transitions and failures
- may reduce performance in exchange for observability

## Rule

Profiles may change timing, logging, or presentation detail.
Profiles must not change canonical outputs, contracts, or safety boundaries.
