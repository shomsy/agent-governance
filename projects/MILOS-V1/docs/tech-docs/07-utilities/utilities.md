# utilities.css

## 1. Purpose

This is the root `utilities` file. It imports all utility modules. These are high-specificity, single-purpose classes (often with `!important` or specific media queries) that override everything else.

## 2. Architectural Layer

**Layer: UTILITIES (Layer 7)**

- **Specificity:** Highest.
- **Role:** Override.

## 3. Core Concept

- **Mechanism:** `@import`.

## 4. CSS Fundamentals (MANDATORY)

### Cascade Order

- **Context:** Utilities must be loaded LAST to ensure they can override component styles.

## 5. CSS Properties Breakdown

None.

## 6. MILOS Implementation Logic

Currently contains `debug` (visual inspection) and `visibility` (hiding/showing).

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Everything | Inline styles (`style="..."` beats class specificity unless !important is used) | |

## 8. Nesting & Collapse Behavior

- **@layer utilities:** All utility styles are contained.

## 9. Diagram (MANDATORY)

```text
utilities.css
├── visibility.css (.u-hide)
└── debug.css      (.u-debug)
```

## 10. Valid Example

```css
@import url("./07-utilities/utilities.css");
```

## 11. Invalid Example

```css
/* Importing utilities before layout might make overrides fail */
@import url("./07-utilities/utilities.css");
@import url("./02-layout/index.css");
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why utilities layer?** Standard ITCSS practice.
