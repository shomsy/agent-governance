# 00-settings/tokens/

## 1. Folder Purpose

This directory contains the foundational, atomic design tokens. These are the raw values (px, rem, %, fractions) that the rest of the system consumes. They are grouped by concern: `space` (gaps), `container` (max-widths), `radius` (border-radius), `elevation` (shadows), etc.

## 2. Layer Definition

**Layer: SETTINGS**
These files define the primitive values of the design system.

## 3. Dependency Direction

- **Imports:** None.
- **Imported By:** `00-settings/tokens.css`.
- **Forbidden:** No circular references between token files.

## 4. File Relationships

- `space.css`: Defines the spacing scale (`--gap-*`).
- `container.css`: Defines maximum widths (`--container-*`).
- `radius.css`: Defines corner radii (`--radius-*`).
- `elevation.css`: Defines shadow elevations (`--shadow-*`).
- `safe-area.css`: Defines viewport safe areas (e.g. notch handling).
- `cq.css`: Defines container query breakpoints (`--cq-*`).

## 5. Known Overlaps

None. Each file handles a distinct CSS property domain.

## 6. Architectural Notes

Tokens are immutable constants unless overridden by a theme layer.
