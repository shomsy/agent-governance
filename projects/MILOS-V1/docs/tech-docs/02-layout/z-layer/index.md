# 02-layout/z-layer/

## 1. Folder Purpose

This directory contains the implementation of the `l-z-` system, which manages the stacking order (z-index) of elements.

## 2. Layer Definition

**Layer: LAYOUT**
It defines the depth layout.

## 3. Dependency Direction

- **Imports:** `00-settings/tokens` (for z-modal vars).
- **Imported By:** `02-layout/z-layer.css` (aggregator).
- **Forbidden:** No complex layout (flex/grid). Just positioning.

## 4. File Relationships

- `levels.css`: Defines `.l-z-` scale.
- `positioning.css`: Defines `position: relative` fallback.

## 5. Known Overlaps

- `l-imposter` implicitly sets position and sometimes z-index (modal context).

## 6. Architectural Notes

Use `.l-z-` classes instead of `z-index` in inline styles to prevent "z-index creep".
