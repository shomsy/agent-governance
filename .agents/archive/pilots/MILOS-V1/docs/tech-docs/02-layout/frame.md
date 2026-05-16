# frame.css

## 1. Purpose

This is the main entry point for the Frame layout primitive. It imports the core aspect-ratio mechanics and the optional fit/ratio modifiers.

## 2. Architectural Layer

**Layer: LAYOUT**
It bundles the aspect-ratio primitive.

## 3. Core Concept

- **Mechanism:** `@import` Aggregation.
- **Why Chosen:** To allow consumers to get the full `l-frame` system with a single line.

## 4. CSS Fundamentals (MANDATORY)

### @import

- **Behavior:** Loads styles in order.

## 5. CSS Properties Breakdown

None.

## 6. MILOS Implementation Logic

We split `ratios` and `fit` because they are separate concerns. One is about container shape, the other about content scaling.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Build Tools | Circular imports | |

## 8. Nesting & Collapse Behavior

- **@layer layout:** All frame styles are contained.

## 9. Diagram (MANDATORY)

```text
frame.css
├── base.css    (.l-frame)
├── ratios.css  (.l-frame--16-9)
└── fit.css     (.l-frame--contain)
```

## 10. Valid Example

```css
@import url("./02-layout/frame.css");
```

## 11. Invalid Example

```css
/* Partial imports */
@import url("./02-layout/frame/fit.css");
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why split?** Modularity.
