# spans.css

## 1. Purpose

This file provides utilities for grid items to span multiple columns, breaking out of the strict grid structure.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts item dimensions.

## 3. Core Concept

- **Mechanism:** Grid Placement (`grid-column`).
- **Why Chosen:** A dashboard usually has "cards" (1col), "wide cards" (2col), and "full width banners" (spanning all).

## 4. CSS Fundamentals (MANDATORY)

### grid-column: span N

- **Behavior:** The item occupies N tracks.
- **Auto-flow:** If N is larger than the remaining tracks in the row, the item grid-auto-flows to the next line.

### grid-column: 1 / -1 (Full Width)

- **Logic:** Starts at line 1 (leftmost) and ends at line -1 (rightmost). This forces the item to span the entire grid regardless of how many columns exist.

## 5. CSS Properties Breakdown

- `.l-span--{1..12}`: Standard spans.
- `.l-span--full`: Full width override.

## 6. MILOS Implementation Logic

We use BEM syntax. The modifier is applied *directly to the child*, not the parent grid.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `.l-grid` (Required) | `grid-auto-flow: dense` (reorders items unpredictably) | Non-grid parents (does nothing) |

## 8. Nesting & Collapse Behavior

- **Context:** Child scope.

## 9. Diagram (MANDATORY)

```text
  .l-grid--cols-3
┌─────────┬─────────┬─────────┐
│ Span 1  │ Span 1  │ Span 1  │
├─────────┴─────────┼─────────┤
│ Span 2            │ Span 1  │
├───────────────────┴─────────┤
│ Span 3 (Full Row)           │
└─────────────────────────────┘
```

## 10. Valid Example

```html
<div class="l-grid l-grid--cols-3">
  <div class="l-span--2">Wide Item</div>
  <div>Normal</div>
</div>
```

## 11. Invalid Example

```html
<div class="l-span--2">
  <!-- Not inside grid -->
</div>
```

## 12. Boundaries

- **Does NOT** span rows (use `grid-row` manually).

## 13. Engine Decision Log

- **Why 1/-1?** Because explicit column counts vary responsive. 1/-1 always works.
