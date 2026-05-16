# box.css

## 1. Purpose

This is the main entry point for the Box layout primitive. It imports both the core structure and the modifier variations in the correct dependency order.

## 2. Architectural Layer

**Layer: LAYOUT**
It bundles the `l-box` component.

## 3. Core Concept

- **Mechanism:** `@import` Aggregation.
- **Why Chosen:** To allow consumers to get the full `l-box` feature set with a single line.

## 4. CSS Fundamentals (MANDATORY)

### @import Order

- **Importance:** Base styles must be defined *before* modifiers so that if specificity is equal (it isn't here, but usually), the modifiers win by source order.
- **Cascade:** Later rules override earlier ones.

## 5. CSS Properties Breakdown

None.

## 6. MILOS Implementation Logic

We split `base` and `modifiers` to keep files small and focused. `base.css` handles structure; `modifiers.css` handles variations.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Build Tools | Circular imports | |

## 8. Nesting & Collapse Behavior

- **@layer layout:** All box styles are contained within the `layout` cascade layer.

## 9. Diagram (MANDATORY)

```text
box.css
├── base.css       (.l-box)
└── modifiers.css  (.l-box--*)
```

## 10. Valid Example

```css
@import url("./02-layout/box.css");
```

## 11. Invalid Example

```css
/* Importing modifiers before base is risky */
@import url("./02-layout/box/modifiers.css");
@import url("./02-layout/box/base.css");
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why split?** To separate "must have" (padding) from "nice to have" (sizes) cleanly.
