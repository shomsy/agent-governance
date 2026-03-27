# 02-layout/container/

## 1. Folder Purpose

This directory contains the implementation of the `l-container` primitive, separated into its core centering logic and width override modifiers.

## 2. Layer Definition

**Layer: LAYOUT**
It encapsulates the "page wrapper" concept.

## 3. Dependency Direction

- **Imports:** `00-settings/tokens` (for max-widths/padding).
- **Imported By:** `02-layout/container.css` (aggregator).
- **Forbidden:** No cosmetic styles.

## 4. File Relationships

- `base.css`: Defines `.l-container`.
- `widths.css`: Defines `.l-width--{wide,measure}`.

## 5. Known Overlaps

- `l-box` handles padding but not max-width.
- `l-center` centers elements but usually lacks the "notch-safe" padding logic of `l-container`.

## 6. Architectural Notes

The `l-container` is the only element that should touch the horizontal edges of the viewport directly (via its padding). All other content lives inside it.
