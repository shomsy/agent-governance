# 02-layout/

## 1. Folder Purpose

This is the core of the Modular Intrinsic Layout Orchestration System (MILOS). It contains the **Layout Primitives**: unstyled, single-purpose components that handle difficult CSS tasks (grid placement, flex wrapping, sidebar allocation, vertical rhythm).

## 2. Layer Definition

**Layer: LAYOUT**
These files define structure only. They have no colors, no shadows, no typography. Just geometry.

## 3. Dependency Direction

- **Imports:** `00-settings` (for tokens).
- **Imported By:** `styles/index.css`.
- **Forbidden:** No cosmetic styles (`background`, `color`). No content-specific styles.

## 4. File Relationships

- `grid/`: 2D distribution system.
- `stack/`: Vertical flow rhythm.
- `cluster/`: Horizontal wrapping distribution.
- `sidebar/`: Asymmetric 2-column layout.
- `switcher/`: Content-driven breakpoint switching.
- `...`: Many other specialized primitives.

## 5. Known Overlaps

- `l-cluster` vs `l-flow`: Both handle inline flow. `cluster` is for distribution (tags), `flow` is for content (prose).

## 6. Architectural Notes

Every primitive follows the **Single Responsibility Principle**.

- `l-stack` handles vertical space.
- `l-grid` handles 2D placement.
- `l-box` handles padding/containers.
They are designed to be composed: `<div class="l-box l-stack">`.
