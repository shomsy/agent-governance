# 02-layout/region/

## 1. Folder Purpose

This directory contains the implementation of the `l-region` primitive, which manages macro-spacing (the vertical white space separating major blocks of content).

## 2. Layer Definition

**Layer: LAYOUT**
It defines the sectioning structure.

## 3. Dependency Direction

- **Imports:** `00-settings/tokens` (for space tokens).
- **Imported By:** `02-layout/region.css` (aggregator).
- **Forbidden:** No layout styles (grid/flex). Only padding.

## 4. File Relationships

- `base.css`: Defines `.l-region` (padding-block).
- `modifiers.css`: Defines sizes (sm, md, lg).

## 5. Known Overlaps

- `l-cover` provides vertical centering, while `l-region` provides vertical spacing. A `l-cover` might contain a `l-region` but usually they are distinct patterns.

## 6. Architectural Notes

Use `.l-region` on every `section`, `header`, `footer`, or `article` wrapper to ensure the page has breathing room.
