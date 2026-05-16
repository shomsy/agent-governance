# 00-settings/

## 1. Folder Purpose

This directory contains the global configuration variables (Design Tokens) for the MILOS system. It defines the "DNA" of the visual language: spacing, colors, typography, break-points, and z-indices. It contains NO CSS selectors or styles, only `--variable: value` definitions.

## 2. Layer Definition

**Layer: SETTINGS**
This is the foundational layer. It must be loaded before any other CSS.

## 3. Dependency Direction

- **Imports:** None (or strictly other settings).
- **Imported By:** Everything (Foundation, Layout, Components).
- **Forbidden:** Must NOT import anything from Layout or Components.

## 4. File Relationships

- `themes.css`: Aggregates brand, mode (light/dark), and density tokens.
- `tokens.css`: Aggregates structural tokens (spacing, radius, containers).
- `themes/`: Contains specific theme definitions.
- `tokens/`: Contains specific token category definitions.

## 5. Known Overlaps

None. This is the single source of truth for design values.

## 6. Architectural Notes

MILOS uses strictly defined CSS Custom Properties. We do not use SCSS variables or pre-processors for tokens. This allows for runtime-changeable themes (e.g. dark mode toggles) without recompiling CSS.
