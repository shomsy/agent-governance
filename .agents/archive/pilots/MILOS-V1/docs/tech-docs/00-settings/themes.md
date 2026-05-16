# themes.css

## 1. Purpose

This is an aggregator file. It serves as the single entry point for all thematic configuration (colors, density, branding) in the system. It imports the specific brand, color scheme, and density definitions.

## 2. Architectural Layer

**Layer: SETTINGS**
It bundles the "personality" of the interface.

## 3. Core Concept

- **Mechanism:** The `@import` rule.
- **Why Chosen:** To allow modular maintenance of separate concerns (Color vs Spacing vs Brand Identity).

## 4. CSS Fundamentals (MANDATORY)

### @import Order Significance

- **What it is:** The order of `@import` determines the Cascade if specificities are equal.
- **Impact:** Imports later in the file can override variables from imports earlier in the file.
- **Note:** In MILOS, themes are usually orthogonal (density vs color vs brand), but if `brands.css` sets `--gap-sm`, and `density.css` also sets `--gap-sm`, the last one wins.

## 5. CSS Properties Breakdown

None. This file contains only imports.

## 6. MILOS Implementation Logic

We ensure that:

1. **Brand:** Sets fundamental identity (colors, fonts).
2. **Density:** Can override spacing logic.
3. **Color Scheme:** Can override color logic (light/dark).
This order ensures the most specific user preference (dark mode, compact mode) wins over the generic brand default.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Build Tools (bundlers) | Circular imports | Manual `<link>` tags for sub-files |

## 8. Nesting & Collapse Behavior

- **@layer settings:** All imported files are implicitly wrapped.

## 9. Diagram (MANDATORY)

```text
themes.css
├── brands.css       (Identity)
├── density.css      (Metric Override)
└── color-scheme.css (Mode Override)
```

## 10. Valid Example

```css
/* In your main CSS */
@import url("./00-settings/themes.css");
```

## 11. Invalid Example

```css
/* Importing manually risks incoherent state */
@import url("./00-settings/themes/brands.css");
/* Missing density could break layout calculations if brand relies on it */
```

## 12. Boundaries

- **Does NOT** define values itself.
- **Does NOT** contain selectors.

## 13. Engine Decision Log

- **Why explicit imports?** It makes dependencies clear. This file acts as the public API for the "Themes" module.
