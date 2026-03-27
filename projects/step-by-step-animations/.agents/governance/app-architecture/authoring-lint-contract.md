# Authoring Lint Contract

This document defines lint guardrails for lesson authoring reliability.

## Required Checks

- patch `type` is valid
- patch `id` is unique in scene scope
- `groupId` does not combine unrelated changes
- `undoId` points to valid inverse strategy or fallback
- `prereq` references known capabilities
- `duration` is numeric and within allowed range
- `scene.ui` uses controlled vocabulary only
- `enter` and `exit` do not mutate canonical state

## Controlled `scene.ui` Vocabulary

Allowed baseline types:

- `popover`
- `hidden`
- `motion`
- `css`

New types require explicit governance update.

## Rule

Lint rules are contract protection, not stylistic decoration.
If lint finds a contract break, content is not release-ready.
