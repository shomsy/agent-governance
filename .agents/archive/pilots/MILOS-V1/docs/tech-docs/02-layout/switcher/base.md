# base.css (Switcher Primitive)

## 1. Purpose

This file implements the "Switcher" pattern. It acts as a "row" of items that automatically "switches" to a vertical stack if the container width is too narrow to fit all items above a certain threshold.

## 2. Architectural Layer

**Layer: LAYOUT**
It is a responsive container primitive.

## 3. Core Concept

- **Mechanism:** `flex-wrap: wrap` + `flex-basis: threshold` + `flex-grow: 1`.
- **Why Chosen:** It is the leanest way to create responsive components (like a 2-column form layout) without media queries or container queries.

## 4. CSS Fundamentals (MANDATORY)

### flex: 1 1 <threshold>

- **Grow (1):** Items expand to fill available space.
- **Shrink (1):** Items can shrink *until* they hit the basis.
- **Basis (Threshold):** The minimum width an item wants to be before it forces a wrap.

### The Wrapping Logic

- If `(item_width * N) + gaps < container_width`: Items sit in a row.
- If `(item_width * N) + gaps > container_width`: Items wrap.
- Because of `flex-grow: 1`, once wrapped, they expand to full width (stacking vertically).

## 5. CSS Properties Breakdown

- `.l-switcher`: The container.
- `--switch-min`: The breakpoint threshold (per item).
- `> *`: The items controlled by the flex logic.

## 6. MILOS Implementation Logic

This is perfect for "sidebar + main" areas where you want them side-by-side on desktop but stacked on mobile, *but based on container space*.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-box` (children) | `width: fixed` (if smaller than threshold) | |

## 8. Nesting & Collapse Behavior

- **Reflow:** Dynamic.

## 9. Diagram (MANDATORY)

```text
  Wide Container
┌───────────────────┬───────────────────┐
│ Item 1            │ Item 2            │
└───────────────────┴───────────────────┘

  Narrow Container (< 2 * threshold)
┌───────────────────────────────────────┐
│ Item 1                                │
├───────────────────────────────────────┤
│ Item 2                                │
└───────────────────────────────────────┘
```

## 10. Valid Example

```html
<div class="l-switcher" style="--switch-min: 20rem">
  <div>Column 1</div>
  <div>Column 2</div>
</div>
```

## 11. Invalid Example

```html
<div class="l-switcher">
  <!-- Missing threshold means it defaults to 0 and never wraps? No, defaults to global var or 0? Check impl. -->
</div>
```

## 12. Boundaries

- **Does NOT** support unequal widths in row mode easily (flex-grow makes them equal if content allows).

## 13. Engine Decision Log

- **Why simple flex?** Browser support is 100%.
