# 00-settings/themes/

## 1. Folder Purpose

This directory manages visual system variants. It defines the brand identity (primary/secondary colors, typography), color schemes (light/dark mode triggers), and density tokens (compact vs comfortable spacing).

## 2. Layer Definition

**Layer: SETTINGS**
These files define the thematic overrides and core brand values.

## 3. Dependency Direction

- **Imports:** None.
- **Imported By:** `00-settings/themes.css`.
- **Relationship:** These files work together to form a complete theme context.

## 4. File Relationships

- `brands.css`: Defines the brand identity (colors, fonts).
- `density.css`: Defines spacing density multipliers.
- `color-scheme.css`: Defines the light/dark mode root switching mechanism.

## 5. Known Overlaps

Color values might overlap if defined in both brand and utilities, but here they are defined as semantic tokens (e.g. `--color-primary`).

## 6. Architectural Notes

Themes are additive. You can swap density or color-scheme independently of the brand definition.
