# imposter.css

## 1. Purpose

This file provides a primitive for positioning elements on top of other content. It handles the classic "absolute centering" problem, making it perfect for modals, tooltips, and floating badges.

## 2. Architectural Layer

**Layer: LAYOUT**
It is an overlay primitive.

## 3. Core Concept

- **Mechanism:** Absolute Positioning + Transform Translation.
- **Why Chosen:** `top: 50%; left: 50%; transform: translate(-50%, -50%)` is the most reliable way to center an element of unknown dimensions relative to its positioned ancestor.

## 4. CSS Fundamentals (MANDATORY)

### Position Context

- **Requirement:** The parent element must have `position: relative` (or fixed/absolute) for the Imposter to position itself relative to that parent. If not, it positions relative to the body (or nearest positioned ancestor).

### Max Size Calculation

- **Logic:** `max-inline-size: calc(100% - margin*2)`.
- **Reason:** Ensuring the modal never touches the edge of the viewport/parent, leaving a safety gap defined by `--imposter-margin`.

## 5. CSS Properties Breakdown

- `.l-imposter`: The element itself.
- `.l-imposter--fixed`: Uses `position: fixed` (relative to viewport).
- `.l-imposter--contain`: Uses flexbox to ensure internal content layout.

## 6. MILOS Implementation Logic

We include `overflow: auto` by default so that if the modal content exceeds the screen height, the user can scroll *inside* the modal, rather than the content being clipped.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-box` (visuals) | `transform` on parent (creates new stacking context) | Static positioning (default) |
| `l-cover` (backdrop) | | |

## 8. Nesting & Collapse Behavior

- **Z-Index:** Usually combined with transparency/shadows (see `elevation.css`).

## 9. Diagram (MANDATORY)

```text
  Parent (position: relative)
┌──────────────────────────────────────┐
│                                      │
│          .l-imposter                 │
│        ┌─────────────┐               │
│        │  Centered   │               │
│        │   Overlay   │               │
│        └─────────────┘               │
│                                      │
└──────────────────────────────────────┘
```

## 10. Valid Example

```html
<div style="position: relative; height: 300px">
  <div class="l-imposter l-box">
    I am dead center.
  </div>
</div>
```

## 11. Invalid Example

```html
<div class="l-imposter">
  <!-- Parent has no position set -->
  <!-- Result: I might center relative to the whole page instead of the div -->
</div>
```

## 12. Boundaries

- **Does NOT** enable the backdrop (dark overlay). That requires a separate element (like `l-cover` or `::backdrop`).

## 13. Engine Decision Log

- **Why translation?** It avoids blurring effects sometimes caused by flexbox centering in older browsers, and allows precise pixel-snapping if needed.
