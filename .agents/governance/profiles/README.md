# Governance Profiles

This folder holds language and framework-specific governance overlays.

Core governance remains in:

- `../QUALITY.md`
- `../execution-policy.md`
- `../how-to-coding-standards.md`
- `../how-to-code-review.md`
- `../how-to-document.md`
- `../release-and-rollback-policy.md`

Profiles add specific constraints and defaults for concrete stacks.

## Structure

- `languages/` for language-level rules
- `frameworks/` for framework/runtime-level rules

## Priority

1. Core governance files
2. Language profile
3. Framework profile
4. Project-local exceptions documented explicitly

If profile guidance conflicts with core safety and quality rules, core rules win.
