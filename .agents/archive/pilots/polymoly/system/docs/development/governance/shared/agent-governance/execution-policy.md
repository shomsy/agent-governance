---
scope: system/docs/development/governance/shared/agent-harness/**
contract_ref: agent-harness@41fdebe
status: vendored
---

# Execution Policy

Version: 1.0.0
Status: Normative

## Purpose

Define the transition from analysis to execution and prevent endless re-analysis, scope drift, and undocumented deviations.

## Execution Mode

Execution mode means implementation is expected and the approved direction is fixed.

Rules:

- each pass must leave the repository in a valid state unless the lane is explicitly docs-only
- no silent redesign
- no unapproved scope expansion

## Iteration Contract

Each iteration should declare:

1. primary goal
2. non-goals
3. constraints
4. completion criteria
5. lane

## Evidence Requirements

A completed iteration must include:

- changed file list
- validation commands and results
- backlog status update
- recorded evidence in `TODO.md` or `BUGS.md`
