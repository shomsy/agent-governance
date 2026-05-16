# 02-layout/cluster/

## 1. Folder Purpose

This directory contains the implementation of the `l-cluster` primitive, split into its core flex mechanics and its alignment variations.

## 2. Layer Definition

**Layer: LAYOUT**
It defines the horizontal wrapping behavior.

## 3. Dependency Direction

- **Imports:** `00-settings/tokens` (for spacing vars).
- **Imported By:** `02-layout/cluster.css` (aggregator).
- **Forbidden:** No styles for list items or links directly (only container behavior).

## 4. File Relationships

- `base.css`: Defines `.l-cluster` (flex, wrap, gap, center-align).
- `alignment.css`: Defines specific alignment/justify overrides.

## 5. Known Overlaps

- `l-flow` handles inline rhythm but is more for prose; `l-cluster` is for atomic items (buttons, tags).

## 6. Architectural Notes

This is one of the most used primitives in modern UI. It solves the classic "margin-right on every item except the last" problem with `gap`.
