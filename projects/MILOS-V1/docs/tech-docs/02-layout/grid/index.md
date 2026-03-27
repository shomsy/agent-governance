# 02-layout/grid/

## 1. Folder Purpose

This directory contains the entire Grid System implementation. It defines how content is placed in 2D space, including track definitions (`cols-3`), item sizing (`span-2`), and responsive behavior (`collapse-sm`).

## 2. Layer Definition

**Layer: LAYOUT**
It encapsulates the CSS Grid specification.

## 3. Dependency Direction

- **Imports:** `00-settings/tokens` (for grid-min, card-min).
- **Imported By:** `02-layout/grid.css` (aggregator).
- **Forbidden:** No flex logic (use `l-stack` or `l-cluster`).

## 4. File Relationships

- `base.css`: Activates `display: grid`.
- `structure.css`: Defines `grid-template-columns`.
- `alignment.css`: Defines item placement.
- `spans.css`: Defines item sizing.
- `span-clamp.css`: Layout safety.
- `collapse.css`: Responsive behavior.

## 5. Known Overlaps

- `l-stack` is essentially a 1-column grid but simpler. Use `stack` for vertical lists, `grid` for layouts.

## 6. Architectural Notes

The grid system uses the "RAM" pattern (Repeat, Auto, Minmax) extensively to create intrinsic layouts that adapt without media queries.
