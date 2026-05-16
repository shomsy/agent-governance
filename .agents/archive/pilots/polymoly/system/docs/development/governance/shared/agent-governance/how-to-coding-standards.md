---
scope: system/docs/development/governance/shared/agent-harness/**
contract_ref: agent-harness@41fdebe
status: vendored
---

# How To Coding Standards

Version: 1.0.0
Status: Normative

## Core Rules

- Prefer simple, explicit code over clever code.
- Keep one responsibility in one place.
- Avoid hidden side effects.
- Add tests or machine checks for changed behavior.
- Do not keep dead compatibility layers without a tracked reason.

## Editing Rules

- Prefer small, reviewable diffs.
- Keep comments short and useful.
- Preserve existing project conventions unless a tracked migration lane says otherwise.
- Do not leave placeholder or fake implementation paths behind.
