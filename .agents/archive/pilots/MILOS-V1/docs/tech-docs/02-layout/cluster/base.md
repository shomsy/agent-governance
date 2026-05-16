# base.css (Cluster Primitive)

## 1. Purpose

This file defines the `l-cluster` primitive, designed for grouping elements horizontally (like buttons, tags, or navigation items) that should naturally wrap to the next line if space runs out.

## 2. Architectural Layer

**Layer: LAYOUT**
It manages horizontal flow and wrapping.

## 3. Core Concept

- **Mechanism:** Flexbox with Wrapping.
- **Why Chosen:** It is the standard way to lay out items of unknown width in a row.
- **Alternatives Considered:** `inline-block` (rejected due to whitespace issues) or `float` (obsolete).

## 4. CSS Fundamentals (MANDATORY)

### display: flex; flex-wrap: wrap

- **Behavior:** Items are placed in a row. If the total width exceeds the container width, items wrap to a new line.
- **Intrinsic Sizing:** Items take only the width they need (unlike Grid columns which stretch to fill tracks by default).
- **Gap:** Space is applied between items *only*, not on the edges.

### min-inline-size: 0 (on children)

- **Problem:** By default, flex items cannot shrink below their minimum content size. Long words or large images can force a flex item to overflow its container.
- **Fix:** Setting `min-width: 0` allows the flex item to shrink correctly if needed (e.g. for text truncation).

## 5. CSS Properties Breakdown

- `--gap`: Defaults to global `--layout-gap`.
- `align-items: center`: Vertically centers items row-by-row. Great for icon + text alignment.
- `gap`: Uses the variable.

## 6. MILOS Implementation Logic

We default to centered vertical alignment because 90% of clusters (button groups, nav bars, tag lists) look broken if items stretch to full height.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-box` | `white-space: nowrap` (prevents wrapping) | |
| `l-stack` | | |
| Inline Elements | | |

## 8. Nesting & Collapse Behavior

- **Wrapping:** If a cluster is inside a flex row that doesn't wrap, it might get squashed.
- **Nesting:** Clusters nest perfectly. A tag list inside a card footer.

## 9. Diagram (MANDATORY)

```text
  .l-cluster
┌───────────────────────────────┐
│ [Item 1]  [Item 2]  [Item 3]  │
│                               │
│ [Item 4]  [Item 5]            │
└───────────────────────────────┘
  (Items wrap naturally)
```

## 10. Valid Example

```html
<ul class="l-cluster">
  <li><a href="#">Home</a></li>
  <li><a href="#">About</a></li>
</ul>
```

## 11. Invalid Example

```html
<div class="l-cluster" style="display: block">
  <!-- Breaking the display type breaks the primitive -->
</div>
```

## 12. Boundaries

- **Does NOT** force items to equal width (use `l-grid`).
- **Does NOT** force items to full width (use `l-stack`).

## 13. Engine Decision Log

- **Why :where?** Low specificity allows utility classes (`align-items-start`) to override the default centering easily.
