# reel.css

## 1. Purpose

This file implements the "Reel" pattern (horizontal scrolling list). It is ideal for browsing categories (e.g. Netflix rows) or image galleries on mobile devices without hiding content behind a "Show More" button.

## 2. Architectural Layer

**Layer: LAYOUT**
It manages horizontal overflow.

## 3. Core Concept

- **Mechanism:** Flexbox + Overflow Auto.
- **Why Chosen:** Native scrolling is performant and touch-friendly. JavaScript carousels are often heavy and janky.

## 4. CSS Fundamentals (MANDATORY)

### overflow: auto hidden

- **X-Axis (Horizontal):** `auto` (Shows scrollbar if needed).
- **Y-Axis (Vertical):** `hidden` (Prevents vertical expansion).

### flex: 0 0 auto (on children)

- **Logic:** Prevents flex items from shrinking (squashing) or growing (stretching). They maintain their intrinsic width.

### scrollbar-width: none

- **Behavior:** Hides the ugly native scrollbar on Firefox/Chrome (when supported) for a cleaner "app-like" feel, but keeps the functionality.

## 5. CSS Properties Breakdown

- `.l-reel`: Container.
- `> *`: Items.
- `> img`: Special handling for direct image children (height 100%, width auto).

## 6. MILOS Implementation Logic

We intentionally hide scrollbars because on mobile they are rarely needed (touch is intuitive), and on desktop they clutter the UI. (Note: Ensure horizontal scrollability is discoverable via cut-off content).

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-stack` (parent) | `flex-wrap: wrap` (negates reel) | Complex interactive elements inside (might trap scroll) |
| `l-card` (child) | | |

## 8. Nesting & Collapse Behavior

- **Height:** The reel height is determined by the tallest item (flex default).

## 9. Diagram (MANDATORY)

```text
  .l-reel (Overflow Hidden Y)
┌───────────────────────────────────────┐
│ [Item 1] [Item 2] [Item 3] [Item...]  │ -> Scroll
└───────────────────────────────────────┘
```

## 10. Valid Example

```html
<div class="l-reel">
  <img src="1.jpg">
  <img src="2.jpg">
  <img src="3.jpg">
</div>
```

## 11. Invalid Example

```html
<div class="l-reel" style="flex-wrap: wrap">
  <!-- Breaking the overflow logic -->
</div>
```

## 12. Boundaries

- **Does NOT** include snap points by default (can be added via utility `scroll-snap-type: x mandatory`).

## 13. Engine Decision Log

- **Why hide scrollbar?** Aesthetic choice heavily requested by designers.
