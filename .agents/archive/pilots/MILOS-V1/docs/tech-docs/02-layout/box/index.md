# 02-layout/box/

## 1. Folder Purpose

This directory contains the implementation of the `l-box` layout primitive, separated into its base definition and its sizing modifiers.

## 2. Layer Definition

**Layer: LAYOUT**
It encapsulates the "container with padding" concept.

## 3. Dependency Direction

- **Imports:** `00-settings/tokens` (for spacing vars).
- **Imported By:** `02-layout/box.css` (aggregator).
- **Forbidden:** No color or typography styles.

## 4. File Relationships

- `base.css`: Defines `.l-box`.
- `modifiers.css`: Defines `.l-box--{sm,lg,none}`.

## 5. Known Overlaps

- `padding-*` utilities: Can achieve similar results but lack the semantic grouping of "a box".

## 6. Architectural Notes

The `l-box` primitive is designed to be composed with other layout primitives. A common pattern is `<div class="l-box l-stack">`, combining padding with vertical flow.
