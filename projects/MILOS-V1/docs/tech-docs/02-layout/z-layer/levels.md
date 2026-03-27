# levels.css (Z-Layer)

## 1. Purpose

This file provides a semantic scale for `z-index`. It replaces magic numbers (`z-index: 9999`) with clear, named layers like `l-z-overlay` and `l-z-modal`.

## 2. Architectural Layer

**Layer: LAYOUT**
It manages stacking context depth.

## 3. Core Concept

- **Mechanism:** `z-index` classes.
- **Why Chosen:** `z-index` wars are a common source of bugs. Centralizing them fixes this.

## 4. CSS Fundamentals (MANDATORY)

### z-index

- **Logic:** Must have `position` (handled by `positioning.css`).
- **Scale:**
  - `flat`: 1 (Standard content slightly raised).
  - `raised`: 10 (Card hover, dropdowns).
  - `content`: 50 (Sticky headers).
  - `overlay`: 1000 (Tooltips, popovers).
  - `modal`: 1100 (Dialogs, full-screen takeover).
  - `negative`: -1 (Background decorations).

## 5. CSS Properties Breakdown

- `.l-z-flat`, `.l-z-raised`, etc.

## 6. MILOS Implementation Logic

We use CSS variables for the top layers (`var(--z-popover)`) to allow theming libraries (like a datepicker plugin) to hook into our scale easily.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-imposter` (often uses `l-z-modal`) | `transform` (creates new stacking context) | |
| `l-cover` (backdrop uses `l-z-overlay`) | | |

## 8. Nesting & Collapse Behavior

- **Reflow:** Stacking contexts are created by `position: relative` + `z-index`, or `transform`, `opacity < 1`, `filter`, etc. Beware of nesting! If a parent has `z-index: 10`, a child with `z-index: 1000` is still limited by the parent's `10` relative to siblings of the parent.

## 9. Diagram (MANDATORY)

```text
  User Eye
     |
  [Modal (1100)]
  [Overlay (1000)]
  [Content (50)]
  [Raised (10)]
  [Flat (1)]
  [Document Flow (0)]
  [Negative (-1)]
```

## 10. Valid Example

```html
<div class="l-imposter l-z-modal">
  <dialog>...</dialog>
</div>
```

## 11. Invalid Example

```html
<div style="z-index: 999999">
  <!-- Magic numbers are banned -->
</div>
```

## 12. Boundaries

- **Does NOT** force position (requires `positioning.css` loaded).

## 13. Engine Decision Log

- **Why vars?** Themes.
