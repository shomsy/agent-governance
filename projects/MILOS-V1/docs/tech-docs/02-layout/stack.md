# stack.css

## 1. Purpose

This is the main entry point for the Stack layout primitive. It imports the base flex-column logic and the alignment modifiers.

## 2. Architectural Layer

**Layer: LAYOUT**
It bundles the `l-stack` component.

## 3. Core Concept

- **Mechanism:** `@import` Aggregation.
- **Why Chosen:** To allow consumers to get the full `l-stack` feature set with a single line.

## 4. CSS Fundamentals (MANDATORY)

### @import

- **Behavior:** Loads styles in order.

## 5. CSS Properties Breakdown

None.

## 6. MILOS Implementation Logic

We bundle `alignment` because it's a common need (e.g. centering a stack).

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Build Tools | Circular imports | |

## 8. Nesting & Collapse Behavior

- **@layer layout:** All stack styles are contained.

## 9. Diagram (MANDATORY)

```text
stack.css
├── base.css       (.l-stack)
└── alignment.css  (.l-stack--)
```

## 10. Valid Example

```css
@import url("./02-layout/stack.css");
```

## 11. Invalid Example

```css
/* Importing modifiers without base */
@import url("./02-layout/stack/alignment.css");
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why split?** Modularity.
