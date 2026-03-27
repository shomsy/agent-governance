# container.css

## 1. Purpose

This is the main entry point for the Container layout primitive. It imports both the core `.l-container` and its width modifiers (`.l-width--*`).

## 2. Architectural Layer

**Layer: LAYOUT**
It bundles the content constraint logic.

## 3. Core Concept

- **Mechanism:** `@import` Aggregation.
- **Why Chosen:** To allow consumers to get the full `l-container` system with a single line.

## 4. CSS Fundamentals (MANDATORY)

### @import

- **Behavior:** Ensures base styles are loaded before modifiers.

## 5. CSS Properties Breakdown

None.

## 6. MILOS Implementation Logic

We bundle `widths.css` here because `l-width--wide` is semantically tied to the container system, even though it can be used on other elements.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Build Tools | Circular imports | |

## 8. Nesting & Collapse Behavior

- **@layer layout:** All styles contained in `layout` layer.

## 9. Diagram (MANDATORY)

```text
container.css
├── base.css    (.l-container)
└── widths.css  (.l-width--*)
```

## 10. Valid Example

```css
@import url("./02-layout/container.css");
```

## 11. Invalid Example

```css
@import url("./02-layout/container/widths.css");
/* Missing base styles might leave --container-pad undefined if base sets defaults? */
/* Actually base sets padding vars locally on l-container, so purely using widths on a div might work, but conceptual dependency is broken. */
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why split?** `base` is mandatory for 99% of pages. `widths` are optional utilities.
