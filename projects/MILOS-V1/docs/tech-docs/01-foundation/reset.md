# reset.css

## 1. Purpose

This is the "anti-break" file. It ensures that 1) layout math is intuitive (`border-box`) and 2) images never overflow their containers (`max-width: 100%`). Without this file, the entire layout system would fail catastrophically in various scenarios.

## 2. Architectural Layer

**Layer: FOUNDATION**
It normalizes the DOM rendering context.

## 3. Core Concept

- **Mechanism:** Box Sizing and Intrinsic Ratios.
- **Why Chosen:** The standard CSS `content-box` model makes fluid layouts nearly impossible because padding adds to width. `border-box` includes padding/border in the width calculation.

## 4. CSS Fundamentals (MANDATORY)

### box-sizing: border-box

- **What it is:** Changes how width and height are calculated.
- **Content-Box (Default):** `width: 100px` + `padding: 10px` = **120px** total width.
- **Border-Box (Reset):** `width: 100px` + `padding: 10px` = **100px** total width (content shrinks to 80px).
- **Inheritance:** `*` selector applies it universally.

### max-width: 100% (Images/Video)

- **What it is:** Constraints media to fit their parent.
- **Behavior:** If an image is 2000px wide but its container is 500px, the image shrinks to 500px.
- **height: auto:** Ensures aspect ratio is preserved (image doesn't squish).

## 5. CSS Properties Breakdown

- `box-sizing`: The fundamental math fix.
- `margin: 0` (on body): Removes the annoying 8px default browser margin.
- `max-width: 100%`: Prevents layout blowouts from large media.

## 6. MILOS Implementation Logic

We intentionally exclude resets for lists (`ul`, `ol`), buttons, and headings from this file. Those belong in `04-elements`. This file only handles **geometry-breaking** defaults.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| **All Layouts** (Required) | Legacy libraries relying on content-box | |
| Responsive Design | Fixed-width media players (if iframe) | |

## 8. Nesting & Collapse Behavior

- **Global:** Applied to `*` (Universal Selector). Affects everything including Shadow DOM if stylesheets are injected.

## 9. Diagram (MANDATORY)

```text
  Border-Box Model (Our Standard)
  ┌───────────────────────────┐
  │ width: 100px              │
  │ ┌───────────────────────┐ │
  │ │ Content (80px)        │ │
  │ │                       │ │
  │ └───────────────────────┘ │
  │ padding: 10px             │
  └───────────────────────────┘
  Total rendered width: 100px
```

## 10. Valid Example

```css
/* Width is predictable */
.card {
  width: 50%;
  padding: 1rem;
  /* Result: Exactly 50% wide */
}
```

## 11. Invalid Example

```css
/* Without reset, this calculation fails */
.card {
  width: 50%;
  padding: 1rem;
  /* Result: 50% + 2rem (overflows container!) */
}
```

## 12. Boundaries

- **Does NOT** remove list styling (`list-style`).
- **Does NOT** normalize form elements (`input`, `button`).

## 13. Engine Decision Log

- **Why `height: auto` on images?** Prevents aspect ratio distortion when width is constrained.
- **Why universal selector `*`?** Performance impact is negligible in modern engines, and inheritance-based resets (`html { box-sizing... } *, *::before... { box-sizing: inherit }`) are unnecessary complexity for this project.
