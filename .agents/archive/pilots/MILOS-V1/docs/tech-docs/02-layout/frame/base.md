# base.css (Frame Primitive)

## 1. Purpose

This file enables aspect-ratio cropping of media content (images, videos, iframes). It ensures that no matter the dimensions of the source file, the rendered element maintains a specific geometric shape (e.g. square, 16:9).

## 2. Architectural Layer

**Layer: LAYOUT**
It enforces geometric relationships between width and height.

## 3. Core Concept

- **Mechanism:** `aspect-ratio` + `object-fit`.
- **Why Chosen:** Replaces the old "padding-bottom hack". It is cleaner, supports content other than background images, and handles responsive wrapping gracefully.

## 4. CSS Fundamentals (MANDATORY)

### aspect-ratio: X / Y

- **Behavior:** The browser calculates the block size (height) based on the inline size (width).
- **Constraint:** If width is 100%, height becomes `width / ratio`.

### object-fit: cover

- **Behavior:** The child content (image/video) scales to fill the container, clipping (cropping) any overflow.
- **Center:** By default, it centers the content (`object-position: center` is usually the default, though not explicitly set here, it's browser standard).

## 5. CSS Properties Breakdown

- `.l-frame`: The container.
  - `--frame`: Default ratio (1/1).
  - `overflow: hidden`: Clips corners and zoomed content.
  - `border-radius`: Uses standard `--radius-md`.
- `> *`: The child.
  - `width/height: 100%`: Fills the frame.
  - `object-fit`: Managed via `--frame-fit`.

## 6. MILOS Implementation Logic

This primitive must be a **wrapper** around the media element (`div > img`), not the media element itself. This allows us to handle rounded corners and overlays robustly.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-grid` (perfect for galleries) | `height: fixed` (fights aspect ratio) | Text content (might overflow if text is long) |
| `l-box` | | |

## 8. Nesting & Collapse Behavior

- **Context:** Works perfectly inside grids.

## 9. Diagram (MANDATORY)

```text
  .l-frame (16 / 9)
┌───────────────────────────────┐
│                               │
│        (Cropped Area)         │
│   [   Image Center Focus  ]   │
│                               │
└───────────────────────────────┘
  (Overflowing parts are hidden)
```

## 10. Valid Example

```html
<figure class="l-frame">
  <img src="portrait.jpg" alt="A person">
</figure>
```

## 11. Invalid Example

```html
<img class="l-frame" src="...">
<!-- The primitive expects to act as a container with a child -->
```

## 12. Boundaries

- **Does NOT** define specific width (takes 100% of parent).

## 13. Engine Decision Log

- **Why wrapper?** Applying `aspect-ratio` directly to `img` works, but applying `overflow: hidden` and `border-radius` to `img` can sometimes be buggy with certain display modes or replaced elements. The wrapper is bulletproof.
