# bleed.css

## 1. Purpose

This file provides the mechanics for elements to break out of their container and span the full width of the viewport (or parent), typically used for full-width images or colored sections inside a centered layout article.

## 2. Architectural Layer

**Layer: LAYOUT**
It manipulates the element's geometry relative to the document flow.

## 3. Core Concept

- **Mechanism:** The "50% Left, -50vw Margin" Hack (modernized with Logical Properties).
- **Why Chosen:** It allows an element nested deep within a centered container (`max-width: 60rem; margin: auto`) to suddenly span the entire screen width without closing and reopening the container in HTML.
- **Components:**
  - `.l-bleed-root`: The overflow guard.
  - `.l-bleed`: The breakout primitive (full viewport).
  - `.l-bleed-safe`: A constrained variant that handles content padding.

## 4. CSS Fundamentals (MANDATORY)

### The Breakout Formula

1. `inset-inline-start: 50%`: Push the element to the horizontal center of its parent.
2. `margin-inline-start: -50dvi`: Pull the element back by half the viewport width.
3. `inline-size: 100dvi`: Force the width to exactly the viewport width.
Result: The element is centered relative to the viewport, regardless of its parent's width.

### Logical Units (dvi vs vw)

- **vw (Viewport Width):** Includes the scrollbar width in some browsers/OSs, causing horizontal scrolling.
- **dvi (Dynamic Viewport Inline):** The inline size of the viewport. More robust than `vw` for text direction and mobile browser chrome handling.
- **compat:** We use `@supports` to fallback to `vi` for browsers that don't support `dvi`.

## 5. CSS Properties Breakdown

- `.l-bleed-root { overflow-x: clip; }`: Essential on `<body>` (or root wrapper) to prevent horizontal scrollbars if the bleed mechanism slightly miscalculates (e.g. sub-pixel rounding or scrollbar bugs). `clip` is safer than `hidden` for sticky positioning.
- `.l-bleed`: Force full viewport width.
- `.l-bleed-safe`:
  - Uses `min(100%, 100dvi)`: Tries to be full viewport but caps at 100% of parent? (Note: Logic suggests it adapts to container context).
  - Uses `padding-inline`: Adds padding equal to the safe area (notch) or standard page padding, ensuring content *inside* the full-width strip aligns with the main grid.

## 6. MILOS Implementation Logic

We distinguish between "Bleed" (raw, geometric breakout) and "Bleed Safe" (visual breakout, but content stays aligned).

- `l-bleed` is for images/videos (edge-to-edge).
- `l-bleed-safe` is for colored bands containing text (background breaks out, text stays legible).

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-container` | `position: absolute` parent (relativity changes) | Flex/Grid items (alignment might fight positioning) |
| `l-stack` | `overflow: hidden` on immediate parent | |

## 8. Nesting & Collapse Behavior

- **Context:** Requires the parent to be centered in the viewport for perfect alignment. If parent is offset (e.g. in a sidebar grid), the bleed will be offset too! use only in main column.

## 9. Diagram (MANDATORY)

```text
  Viewport (100dvi)
┌──────────────────────────────────────┐
│  l-container (Centered)              │
│  ┌───────────┐                       │
│  │           │                       │
│  │ Normal    │                       │
│  │           │                       │
│◄─┼───────────┼──────────────────────►│
│  │ .l-bleed  │ (Spans full viewport) │
│  │           │                       │
│  └───────────┘                       │
└──────────────────────────────────────┘
   ^ Breakout happens here
```

## 10. Valid Example

```html
<main class="l-container">
  <p>Normal text</p>
  <img class="l-bleed" src="full-width.jpg" alt="">
  <p>Normal text</p>
</main>
```

## 11. Invalid Example

```html
<div class="sidebar">
  <!-- Imbalanced parent geometry -->
  <div class="l-bleed">...</div> 
  <!-- Result: Element bleeds off-screen to the left -->
</div>
```

## 12. Boundaries

- **Does NOT** work inside `transform`ed elements (creates new containing block).
- **Does NOT** imply full height (height is auto).

## 13. Engine Decision Log

- **Why l-bleed-root?** Without it, scrollbars can appear due to `100vw` vs `100%` mismatch on Windows. `overflow-x: clip` suppresses this without killing `position: sticky` (unlike `overflow: hidden`).
