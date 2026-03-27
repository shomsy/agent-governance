# 07-utilities/debug/

## 1. Folder Purpose

This directory contains the layout debugging system. It is designed to be activated temporarily during development to visualize how different primitives interact.

## 2. Layer Definition

**Layer: UTILITIES**
Specifically for DX (Developer Experience).

## 3. Dependency Direction

- **Imported By:** `07-utilities/debug.css`.

## 4. File Relationships

- `outlines.css`: High-specific outlines for different primitives.
- `badge.css`: A status indicator that confirms debug mode is active.

## 5. Known Overlaps

- The outlines may overlap with component borders. They use `outline` instead of `border` to avoid geometry shifts.

## 6. Architectural Notes

Debug mode is non-interactive. It is strictly for observing the "invisible" grid and flex boxes that drive the MILOS engine.
