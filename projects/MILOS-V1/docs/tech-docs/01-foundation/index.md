# 01-foundation/

## 1. Folder Purpose

This directory contains the foundational styles that normalize browser behavior. It provides the "standard canvas" upon which the layout system is built.

## 2. Layer Definition

**Layer: FOUNDATION**
These styles must load immediately after Settings to ensure consistent rendering across all browsers.

## 3. Dependency Direction

- **Imports:** None.
- **Imported By:** `styles/index.css`.
- **Forbidden:** No selectors with high specificity (use element tags only).

## 4. File Relationships

- `reset.css`: The minimal box-model and media reset.

## 5. Known Overlaps

None.

## 6. Architectural Notes

MILOS uses a "surgical" reset, not a "normalize.css" or "reboot.css" sledgehammer. We only fix what structurally breaks layout (box-sizing, overflowing images).
