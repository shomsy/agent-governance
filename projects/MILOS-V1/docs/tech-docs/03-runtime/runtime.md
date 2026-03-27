# runtime.css

## 1. Purpose

This is the main entry point for the Runtime utilities. It aggregates all layout override modifiers into a single import.

## 2. Architectural Layer

**Layer: LAYOUT**
It bundles the atomic modifiers.

## 3. Core Concept

- **Mechanism:** `@import` Aggregation.

## 4. CSS Fundamentals (MANDATORY)

### @import

- **Behavior:** Loads styles in order.

## 5. CSS Properties Breakdown

None.

## 6. MILOS Implementation Logic

These utilities are grouped because they all solve the "exception to the rule" problem (I'm a flex item but I want to be 100% width).

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Any Layout Primitive | `display: inline` (flex props ignored) | |

## 8. Nesting & Collapse Behavior

- **@layer layout:** All styles contained.

## 9. Diagram (MANDATORY)

```text
runtime.css
├── sizing.css    (.l-fill)
├── ordering.css  (.l-order--first)
└── self.css      (.l-self--center)
```

## 10. Valid Example

```css
@import url("./03-runtime/runtime.css");
```

## 11. Invalid Example

```css
/* Using utilities without understanding context */
.l-fill { display: block; } /* .l-fill assumes flex context */
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why Runtime?** Because they change runtime behavior of static layout definitions.
