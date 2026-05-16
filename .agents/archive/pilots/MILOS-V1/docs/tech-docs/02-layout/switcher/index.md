# 02-layout/switcher/

## 1. Folder Purpose

This directory contains the implementation of the `l-switcher` flexible layout.

## 2. Layer Definition

**Layer: LAYOUT**
It defines the responsive wrapping logic.

## 3. Dependency Direction

- **Imports:** `00-settings/tokens` (for min sizes).
- **Imported By:** `02-layout/switcher.css` (aggregator).
- **Forbidden:** No complex grid logic.

## 4. File Relationships

- `base.css`: Defines `.l-switcher`.
- `alignment.css`: Defines alignment modifiers.
- `min-presets.css`: Defines threshold presets.

## 5. Known Overlaps

- `l-grid` does layouts. `l-switcher` does "dumb" wrapping without grid alignment.
- `l-cluster` does wrapping for small items. `l-switcher` is for entire columns.

## 6. Architectural Notes

Use `.l-switcher` for sidebar/main layouts, form fields, and card grids when you don't need strict row alignment.
