# structure.css (Grid Primitive)

## 1. Purpose

This file defines the track logic: how many columns exist, how wide they are, and how they respond to space. It provides both fixed-column grids (12-col) and intrinsic grids (Cards, Gallery).

## 2. Architectural Layer

**Layer: LAYOUT**
It defines the track sizes and distribution.

## 3. Core Concept

- **Mechanism:** Grid Template Columns (Explicit Definition).
- **RAM Pattern:** Repeat, Auto, Minmax.

## 4. CSS Fundamentals (MANDATORY)

### Fixed Tracks: `repeat(N, 1fr)`

- **Logic:** Divides the available space into N equal columns.
- **Example:** `.l-grid--cols-3`.

### Intrinsic Tracks: `repeat(auto-fit, minmax(MIN, 1fr))`

- **Logic:** The browser creates as many columns as will fit into the container, provided each column is at least `MIN` wide.
- **Behavior:**
  - **Wide Screen:** Many columns.
  - **Narrow Screen:** Fewer columns.
  - **Tiny Screen (< MIN):** Items wrap to full width (1 column). No media queries needed!

### Auto-Fit vs Auto-Fill

- **Auto-Fit:** Collapses empty tracks. If items don't fill the row, they stretch to fill width. (Used here for `--cards`).
- **Auto-Fill:** Preserves empty tracks. If items don't fill the row, they stay their size and leave empty space. (Used here for `--balanced`?).

## 5. CSS Properties Breakdown

- `.l-grid--cols-{2,3,4,6,12}`: Standard fixed layouts.
- `.l-grid--auto`: Generic intrinsic grid. Uses `--min-card` token.
- `.l-grid--cards-{sm,md,lg}`: Specific card grids. `--card-min-md` (e.g. 20rem).
- `.l-grid--gallery-{sm,md,lg}`: Tighter gap, smaller minimums.
- `.l-grid--balanced`: Uses `auto-fill` to avoid giant stretched cards if only 2 items exist in a 3-col space? Wait, check file content.

## 6. MILOS Implementation Logic

We provide semantic modifiers (`--cards`, `--gallery`) rather than just utility classes (`min-200`) because "Cards" implies a specific relationship between gap and minimum width.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `.l-grid` (Required) | `grid-template-columns` inline style | Flexbox |
| `.l-span--*` | | |

## 8. Nesting & Collapse Behavior

- **Context:** Grid tracks are established on the container. Nested grids are independent.

## 9. Diagram (MANDATORY)

```text
  .l-grid--cards-md (Container: 60rem)
  (Min Card = 20rem)

  Track 1 (1fr)      Track 2 (1fr)      Track 3 (1fr)
┌─────────────────┬──────────────────┬──────────────────┐
│ [Card 1]        │ [Card 2]         │ [Card 3]         │
└─────────────────┴──────────────────┴──────────────────┘
  (3 items fit)

  .l-grid--cards-md (Container: 30rem)
  (Min Card = 20rem)

  Track 1 (1fr)
┌─────────────────┐
│ [Card 1]        │
├─────────────────┤
│ [Card 2]        │ (Wrap)
├─────────────────┤
│ [Card 3]        │ (Wrap)
└─────────────────┘
  (Only 1 fits)
```

## 10. Valid Example

```html
<div class="l-grid l-grid--cards-md">
  <article>Card 1</article>
  <article>Card 2</article>
  <article>Card 3</article>
</div>
```

## 11. Invalid Example

```html
<div class="l-grid--cards-md">
  <!-- Missing base .l-grid means display: grid is not set! -->
</div>
```

## 12. Boundaries

- **Does NOT** define row heights (usually auto).

## 13. Engine Decision Log

- **Why auto-fit for cards?** Users prefer card lists to look "full". If you have 3 cards on a massive monitor, auto-fill leaves empty space. Auto-fit stretches them.
- **Why min(100%, var(--grid-min))?** Bug fix. If `--grid-min` (e.g. 500px) is wider than the viewport (320px), standard `minmax(500px, 1fr)` causes horizontal scroll. `min(100%, 500px)` means "take 500px, but never more than 100% of viewport", fixing mobile overflow.
