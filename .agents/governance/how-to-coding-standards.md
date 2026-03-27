# How To Coding Standards

Version: 1.1.0
Status: Normative

## Core Rules

- Prefer simple, explicit code over clever code.
- Preserve architecture boundaries unless a tracked migration changes them.
- Keep one responsibility in one place.
- Prefer explicit names over generic buckets.
- Avoid hidden side effects.
- Do not silently change public behavior without updating contracts.
- Add tests or machine checks for changed behavior.
- Do not keep dead compatibility layers without a tracked reason.

## Editing Rules

- Prefer small, reviewable diffs.
- Keep comments short and useful.
- Preserve existing project conventions unless a tracked migration lane says otherwise.
- Avoid creating fallback buckets such as `utils`, `helpers`, `common`, `manager`, or `service`.
- Do not leave placeholder or fake implementation paths behind.
