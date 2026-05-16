---
scope: system/docs/development/governance/shared/agent-harness/**
contract_ref: agent-harness@41fdebe
status: vendored
---

# Release And Rollback Policy

Version: 1.0.0
Status: Normative

## Promotion Path

Use this order unless explicitly overridden:

1. local proof
2. stage proof
3. production release

## GO / NO-GO Contract

GO requires all of the following:

- required validations are green
- release evidence is recorded
- rollback path is defined

Any failed mandatory check is NO-GO.

## Rollback Contract

Every release-impacting change should define:

1. rollback trigger
2. rollback command or workflow
3. expected recovery signal
4. evidence location
