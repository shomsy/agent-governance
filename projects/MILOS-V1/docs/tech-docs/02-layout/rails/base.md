# base.css (Rails Primitive)

## 1. Purpose

This file implements a sophisticated "Full Bleed" grid system often called the "CSS Grid Named Lines" technique. It creates a layout where items are centered by default but can "break out" to wider columns without complex negative margins or extra markup.

## 2. Architectural Layer

**Layer: LAYOUT**
It defines a multi-track grid context.

## 3. Core Concept

- **Mechanism:** CSS Grid Named Lines (`[name-start]`).
- **Why Chosen:** It is cleaner than nested containers (`container > wide-wrapper > content`). All items share the same parent grid.

## 4. CSS Fundamentals (MANDATORY)

### Named Grid Lines

- **Logic:** We define start and end lines: `full`, `wide`, `content`.
- **Tracks:**
  1. `full-start` to `wide-start` (gutter).
  2. `wide-start` to `content-start` (margin).
  3. `content-start` to `content-end` (main/center).
  4. `content-end` to `wide-end` (margin).
  5. `wide-end` to `full-end` (gutter).

### Default Placement: `grid-column: content`

- **Behavior:** All direct children are automatically placed in the center `content` column. They behave like normal centered text.

## 5. CSS Properties Breakdown

- `.l-rails`: The container.
- `grid-template-columns`: The complex definition using `minmax` and calculations based on `--container-max` and `--container-wide`.

## 6. MILOS Implementation Logic

This primitive replaces `l-container` for rich long-form content (like blog posts) where you want images to utilize `l-rail--wide` or `l-rail--full`.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-rail--*` modifiers | `l-container` (nested inside) | Use on small components (overkill) |

## 8. Nesting & Collapse Behavior

- **Context:** Operates on direct children only.

## 9. Diagram (MANDATORY)

```text
  .l-rails (100% width)
  [full] [wide] [content] [wide] [full] (Lines)
┌───────┬──────┬─────────┬──────┬───────┐
│       │      │ Default │      │       │
│       │      │ Item    │      │       │
├───────┼──────┼─────────┼──────┼───────┤ (Row 1)
│       │ Wide Item             │       │
├───────┴──────┴─────────┴──────┴───────┤ (Row 2)
│ Full Item (Bleed)                     │
└───────────────────────────────────────┘ (Row 3)
```

## 10. Valid Example

```html
<article class="l-rails">
  <p>I am centered.</p>
  <img class="l-rail--wide" src="wide.jpg">
  <img class="l-rail--full" src="hero.jpg">
</article>
```

## 11. Invalid Example

```html
<div class="l-rails">
  <!-- If children are wrapped in a div, that div is the grid item, not the content inside -->
</div>
```

## 12. Boundaries

- **Does NOT** work inside a constrained parent (needs full width availability to look right).

## 13. Engine Decision Log

- **Why this complexity?** It allows editorial layouts to flow naturally.
