# How To Coding Standards

This document defines implementation standards across slices.

## Core Rules

- preserve existing architecture boundaries
- keep diffs small and reviewable
- prefer explicit names over generic buckets
- keep one file, one clear responsibility
- keep one function, one exact action

## Editing Rules

- do not introduce `utils`, `helpers`, `common`, `manager`, or `service` as fallback buckets
- avoid hidden side effects
- isolate side effects at slice edges
- do not silently change public behavior without updating contracts
- update owning docs when architecture or policy changes

## Test Rules

- non-trivial behavior changes require at least one verification path
- bug fixes should add regression-oriented validation where possible
- deterministic flows must stay replayable and reproducible

## Security Rules

- no secrets in committed files
- sanitize or constrain untrusted data before render or execution
- default to least privilege and explicit permissions
