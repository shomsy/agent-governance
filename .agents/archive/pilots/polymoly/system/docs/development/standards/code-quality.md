---
scope: product/**,system/**,system/tools/poly/**
contract_ref: code-quality-v1
status: stable
---

# Code Quality Contract

This file defines the stable code-quality bar for PolyMoly.
Detailed implementation procedure lives in
`system/docs/development/governance/how-to-coding-standards.md`.
Flow-documentation procedure lives in
`system/docs/development/governance/how-to-document-flow.md`.

## Core Bar

1. Prefer simple and explicit code over clever compression.
2. Keep one responsibility in one place.
3. Make unsafe behavior obvious and opt-in.
4. Name code by product meaning, not temporary implementation trivia.
5. Make failure paths understandable without tribal knowledge.

## Go And Package Rules

- Package boundaries must follow ownership boundaries.
- Hidden cross-layer law is forbidden.
- Errors must be explicit, actionable, and wrapped with context.
- Helpers must remove repetition, not hide policy.
- Public surfaces must stay small and predictable.

## DSL And Fluent API Rules

- Commands and builders must read like operator intent.
- Chaining is allowed only when each step stays deterministic and readable.
- Default behavior must be safe and unsurprising.
- Human-readable output beats clever internal jargon.
- If a DSL needs a paragraph to explain a basic path, the shape is wrong.

## Enterprise Readability Rule

Another competent engineer should be able to open a file and answer:

1. what this code owns,
2. what it must not do,
3. what happens on failure,
4. where the next layer starts.

If that is not clear, the code is not yet at the required bar.

## Naming And Discoverability Rule

Code must be navigable from names alone before comments are needed.

Rules:

1. folder says the flow, file says the responsibility, function says the exact
   action
2. function names must follow `Action + Object` unless the package name already
   carries the missing object with no ambiguity
3. vague verbs such as `Handle`, `Manage`, `Process`, `Execute`, and
   `Orchestrate` are a smell and require stronger justification than specific
   verbs
4. exported functions and types require doc comments
5. every first-party ownership folder must have `how-this-works.md` that maps
   folder purpose, direct files, and direct flow-entry functions
6. if a new folder or file is hard to place from its name alone, the name is
   wrong or the boundary is wrong

The target is simple:

- a reader should be able to predict what a folder, file, and function do
  before opening the implementation
