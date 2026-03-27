# tokens.css

## 1. Purpose

This is an aggregator file. It serves as the single entry point for all design tokens (variables) in the system. It imports all specific token categories (`space`, `radius`, `elevation`, etc.) in the correct dependency order.

## 2. Architectural Layer

**Layer: SETTINGS**
It bundles the primitive configuration.

## 3. Core Concept

- **Mechanism:** The `@import` rule.
- **Why Chosen:** To keep the folder structure modular (one file per concern) while allowing consumers to import a single file (`tokens.css`) to get everything.
- **Alternatives Considered:** A single giant `tokens.css` file (rejected for readability).

## 4. CSS Fundamentals (MANDATORY)

### @import

- **What it is:** A CSS at-rule used to import style rules from other style sheets.
- **Constraint:** Must precede all other types of rules (except `@charset` and `@layer`).
- **Performance:** In standard HTTP/1, `@import` caused waterfalls. In HTTP/2+, parallel downloads mitigate this. In modern build tools (Vite/PostCSS), these are often inlined at build time.

## 5. CSS Properties Breakdown

None. This file contains only imports.

## 6. MILOS Implementation Logic

We enforce a strict separation of concerns. `space.css` handles gaps. `radius.css` handles corners. This file ensures they are all present.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Build Tools (bundlers) | Circular imports | Manual `<link>` tags for sub-files |

## 8. Nesting & Collapse Behavior

- **@layer settings:** All imported files are implicitly wrapped in the `settings` layer if the consumer imports this file into a layer.

## 9. Diagram (MANDATORY)

```text
tokens.css
├── space.css
├── radius.css
├── elevation.css
├── cq.css
├── safe-area.css
└── container.css
```

## 10. Valid Example

```css
/* In your main CSS */
@import url("./00-settings/tokens.css");
```

## 11. Invalid Example

```css
/* Importing sub-files manually risks missing dependencies or updates */
@import url("./00-settings/tokens/space.css"); 
@import url("./00-settings/tokens/radius.css");
```

## 12. Boundaries

- **Does NOT** define values itself.
- **Does NOT** contain selectors.

## 13. Engine Decision Log

- **Why granular files?** Moving from "one big file" to "many small files" makes Git diffs cleaner and mental overhead lower.
