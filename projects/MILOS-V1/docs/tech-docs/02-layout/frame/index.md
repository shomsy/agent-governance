# 02-layout/frame/

## 1. Folder Purpose

This directory contains the implementation of the `l-frame` primitive, split into aspect ratio core, fit modifiers (contain/cover), and ratio presets (16:9, etc.).

## 2. Layer Definition

**Layer: LAYOUT**
It encapsulates the "cropped media box" concept.

## 3. Dependency Direction

- **Imports:** `00-settings/tokens` (for border radius).
- **Imported By:** `02-layout/frame.css` (aggregator).
- **Forbidden:** No media-specific hacks (like assuming video controls height).

## 4. File Relationships

- `base.css`: Defines `.l-frame`.
- `fit.css`: Defines object-fit modifiers.
- `ratios.css`: Defines aspect-ratio modifiers.

## 5. Known Overlaps

- Standard `img` styles (max-width: 100%) handle intrinsic ratios but not cropping or rigorous aspect ratio enforcement.

## 6. Architectural Notes

The `l-frame` is essential for Component-Driven Design where a card image must always be 16:9 regardless of the uploaded asset size.
