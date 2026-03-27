# base.css (Grid Primitive)

## 1. Purpose

This file provides the foundation for the 2D layout engine. It activates the grid context and sets safe defaults for children.

## 2. Architectural Layer

**Layer: LAYOUT**
It manages the grid formatting context.

## 3. Core Concept

- **Mechanism:** CSS Grid Layout (`display: grid`).
- **Why Chosen:** It is the only CSS mechanism that can handle 2-dimensional layout (rows and columns) simultaneously.

## 4. CSS Fundamentals (MANDATORY)

### display: grid

- **Behavior:** Transforms the element into a Grid Container.
- **Children:** Direct children become Grid Items.

### min-inline-size: 0 (on children)

- **Problem:** By default, grid items cannot shrink below their minimum content size (e.g. a wide image or a long word). This causes the grid track itself to blow out and overflow the screen.
- **Fix:** `min-width: 0` allows the item to shrink, enabling text truncation or responsive image scaling to work inside grid cells.

## 5. CSS Properties Breakdown

- `.l-grid`: The container.
- `--gap`: Defaults to `--layout-gap`.
- `gap`: Uses the variable.

## 6. MILOS Implementation Logic

We separate the *activation* (`display: grid`) from the *structure* (`grid-template-columns`). `.l-grid` alone creates a single-column stack (implicit rows) unless structure modifiers are added.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-box` | `display: flex` (overrides grid) | Inline elements (become blockified) |
| `l-strut`? | | |

## 8. Nesting & Collapse Behavior

- **Subgrid:** CSS Subgrid is not yet used here to maximize compatibility, but nested grids work standardly.

## 9. Diagram (MANDATORY)

```text
  .l-grid
┌──────────────┐
│ [ Item 1 ]   │
│              │
│ (gap)        │
│              │
│ [ Item 2 ]   │
└──────────────┘
(Default: 1 col)
```

## 10. Valid Example

```html
<div class="l-grid">
  <div>Item</div>
  <div>Item</div>
</div>
```

## 11. Invalid Example

```html
<span class="l-grid">
  <!-- Valid HTML5, but semantic confusion -->
</span>
```

## 12. Boundaries

- **Does NOT** define columns (use structure modifiers).

## 13. Engine Decision Log

- **Why min-inline-size: 0?** This "CSS Grid blowout" bug is the #1 issue developers face. We fix it globally.
