# z-layer.css

## 1. Purpose

This is the main entry point for the Z-Layer layout primitive. It imports the Z-index scale and the positioning fix.

## 2. Architectural Layer

**Layer: LAYOUT**
It bundles the stacking context logic.

## 3. Core Concept

- **Mechanism:** `@import` Aggregation.
- **Why Chosen:** To allow consumers to get the full `l-z-` feature set with a single line.

## 4. CSS Fundamentals (MANDATORY)

### @import

- **Behavior:** Loads styles in order.

## 5. CSS Properties Breakdown

None.

## 6. MILOS Implementation Logic

We bundle `positioning` so you don't have to think about `position: relative` manually. The scale and the mechanism are kept together.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Build Tools | Circular imports | |

## 8. Nesting & Collapse Behavior

- **@layer layout:** All z-layer styles are contained.

## 9. Diagram (MANDATORY)

```text
z-layer.css
├── levels.css      (.l-z-flat)
└── positioning.css (position: relative)
```

## 10. Valid Example

```css
@import url("./02-layout/z-layer.css");
```

## 11. Invalid Example

```css
/* Importing levels without positioning breaks functionality on static elements */
@import url("./02-layout/z-layer/levels.css");
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why split?** Clean separation of scale vs mechanism.
