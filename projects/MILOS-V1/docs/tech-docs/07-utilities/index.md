# 07-utilities/

## 1. Folder Purpose

This directory contains utility-first classes designed for high-priority overrides and debugging. Following ITCSS, these are the most specific rules in the system.

## 2. Layer Definition

**Layer: UTILITIES**
Rules in this layer often use `!important` to ensure they "win" the cascade regardless of component-level styling.

## 3. Dependency Direction

- **Imports:** None.
- **Imported By:** `styles/index.css` (last layer).
- **Forbidden:** No complex layout or theme definitions.

## 4. File Relationships

- `visibility/`: Contextual hiding/showing (CQ and global).
- `debug/`: Visual inspection tools for layout boundaries.

## 5. Known Overlaps

- `u-hide` overrides any `display` property set in `02-layout`.

## 6. Architectural Notes

Utilities should be used sparingly as "escape hatches". If you find yourself using many utilities on one element, consider creating a Scenario or Component.
