# 07-utilities/visibility/

## 1. Folder Purpose

This directory contains classes for controlling element visibility. It provides a DSL (Domain Specific Language) for responsive hiding and showing.

## 2. Layer Definition

**Layer: UTILITIES**

## 3. Dependency Direction

- **Imported By:** `07-utilities/visibility.css`.

## 4. File Relationships

- `base.css`: Global `u-hide` and `u-show`.
- `cq.css`: Container-Query specific visibility (e.g., `u-hide--cq-narrow`).

## 5. Known Overlaps

- `u-hide` uses `display: none` which removes the element from the layout flow entirely.

## 6. Architectural Notes

MILOS prioritizes Container Query visibility over Media Query visibility to ensure components are truly portable across different layout slots.
