# span-clamp.css

## 1. Purpose

This is a critical safety file. It prevents "layout breakage" where a developer inadvertently assigns a span (e.g. `span-4`) that is larger than the total number of columns available in the current grid (e.g. `cols-3`).

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It enforces logical constraints.

## 3. Core Concept

- **Mechanism:** Attribute Selector Matching (Grid Context Aware).
- **Why Chosen:** If you define `grid-column: span 4` inside a `grid-template-columns: repeat(3, 1fr)`, CSS Grid will implicitly create a 4th column, ruining the layout symmetry and causing overflow.

## 4. CSS Fundamentals (MANDATORY)

### Context-Aware Selectors

- **Logic:** `.l-grid--cols-3 > .l-span--4` matches an item ONLY if:
  1. It wants to span 4 columns.
  2. Its parent only has 3 columns.
- **Action:** Fallback to `grid-column: 1 / -1`. The item spans the *available* width (3 columns) instead of creating a ghost 4th column.

## 5. CSS Properties Breakdown

- `.l-grid--cols-N > .l-span--M (where M > N)`: Applies the fix.

## 6. MILOS Implementation Logic

This file is generated logic. It covers all combinations of `cols-{2..6}` vs `span-{3..12}`.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Fixed Grids (`cols-N`) | `grid-auto-flow: column` (might behave oddly) | Intrinsic Grids (`auto-fit`) - cannot clamp easily |

## 8. Nesting & Collapse Behavior

- **Context:** Automatic. No user class needed.

## 9. Diagram (MANDATORY)

```text
  Without Span Clamp (Broken)
┌─────────┬─────────┬─────────┐   ┌─────────┐
│ Col 1   │ Col 2   │ Col 3   │   │ Implicit│
├─────────┴─────────┴─────────┼───┘ Col 4 │
│ Span 4 (Overflows)          │           │
└─────────────────────────────┴───────────┘

  With Span Clamp (Fixed)
┌─────────┬─────────┬─────────┐
│ Col 1   │ Col 2   │ Col 3   │
├─────────┴─────────┴─────────┤
│ Span 4 -> Becomes Span Full │
└─────────────────────────────┘
```

## 10. Valid Example

```html
<div class="l-grid l-grid--cols-3">
  <!-- This is safe because of span-clamp.css -->
  <div class="l-span--6">I span full width automatically</div>
</div>
```

## 11. Invalid Example

```css
/* Custom grid definition without safety rules */
.my-grid { grid-template-columns: repeat(3, 1fr); }
.my-span { grid-column: span 4; } /* Will break layout */
```

## 12. Boundaries

- **Does NOT** fix intrinsic grids (where column count is unknown).

## 13. Engine Decision Log

- **Why clamp to full width?** Because if an element is wider than the grid, it most likely intended "maximum width".
