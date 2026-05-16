# 02-layout/stack/

## 1. Folder Purpose

This directory contains the implementation of the `l-stack` primitive, which manages vertical flow (spacing and alignment).

## 2. Layer Definition

**Layer: LAYOUT**
It defines the vertical stacking structure.

## 3. Dependency Direction

- **Imports:** `00-settings/tokens` (for layout-gap).
- **Imported By:** `02-layout/stack.css` (aggregator).
- **Forbidden:** No horizontal flow logic.

## 4. File Relationships

- `base.css`: Defines `.l-stack` (flex-col, gap).
- `alignment.css`: Defines `.l-stack--align-*`.

## 5. Known Overlaps

- `l-grid` is multi-dimensional. `l-stack` is 1D vertical. Use stack for components, grid for pages.
- `l-flow` is for *content* (margins). `l-stack` is for *layout* (flex gap).

## 6. Architectural Notes

The stack is the "vertical rhythm" workhorse of the component library. Every card, form, or dialog is built on a stack.
