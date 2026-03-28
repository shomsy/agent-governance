# Governance Profiles

This folder holds language and framework-specific governance overlays.

Core governance remains in:

- `../quality-gates.md`
- `../profile-resolution-algorithm.md`
- `../execution-policy.md`
- `../how-to-coding-standards.md`
- `../how-to-code-review.md`
- `../how-to-document-flow.md`
- `../how-to-document.md`
- `../release-and-rollback-policy.md`

Profiles add specific constraints and defaults for concrete stacks.
For repo shape and architecture overlays, also see
`../app-architecture/profiles/README.md`.

## Structure

- `languages/` for language-level rules
- `frameworks/` for framework/runtime-level rules

Language profiles should carry syntax, typing, runtime-safety, interop, and
tooling rules for that language.
One project may intentionally combine multiple language profiles, for example
`typescript` + `nodejs` + `css`.

## Priority

1. Core governance files
2. Explicit stack declaration in root `AGENTS.md`
3. Language profile
4. Framework profile
5. Project-local exceptions documented explicitly

If profile guidance conflicts with core safety and quality rules, core rules win.

## Resolution Rule

- the root `AGENTS.md` should declare which profiles are applied
- if the root file is incomplete, resolve profiles through
  `../profile-resolution-algorithm.md`
- do not apply a framework profile unless the repo or root contract gives
  strong evidence that the framework is real
