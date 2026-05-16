# fit.css

## 1. Purpose

This file provides modifiers to change how content fits inside the frame (crop vs letterbox).

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts content rendering.

## 3. Core Concept

- **Mechanism:** Variable Reassignment (`--frame-fit`).
- **Why Chosen:** A single semantic class `.l-frame--contain` is clearer than `object-fit: contain`.

## 4. CSS Fundamentals (MANDATORY)

### object-fit: contain

- **Behavior:** The content scales to fit entirely within the box, maintaining its aspect ratio. Empty space is filled with background color (letterboxing).

### object-fit: cover

- **Behavior:** The content scales to fill the entire box, potentially cropping off edges.

## 5. CSS Properties Breakdown

- `.l-frame--contain`: Sets `--frame-fit: contain`.
- `.l-frame--cover`: Sets `--frame-fit: cover` (default).

## 6. MILOS Implementation Logic

We default to `cover` because it is the most common use case (hero images, avatars). `contain` is for logos or product shots where cropping is unacceptable.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `.l-frame` | | Text (usually ignores object-fit unless it's a replaced element) |

## 8. Nesting & Collapse Behavior

- **Context:** Local scope.

## 9. Diagram (MANDATORY)

```text
  .l-frame--contain
┌───────────────────────────────┐
│     (Empty Space)             │
│   ┌───────────────────────┐   │
│   │ [Full Image Visible]  │   │
│   └───────────────────────┘   │
│     (Empty Space)             │
└───────────────────────────────┘

  .l-frame--cover
┌───────────────────────────────┐
│  [Cropped Top]                │
│                               │
│  [Visible Center]             │
│                               │
│  [Cropped Bottom]             │
└───────────────────────────────┘
```

## 10. Valid Example

```html
<figure class="l-frame l-frame--contain">
  <img src="logo.png" alt="Brand">
</figure>
```

## 11. Invalid Example

```html
<div class="l-frame--contain">...</div>
```

## 12. Boundaries

- **Does NOT** change aspect ratio.

## 13. Engine Decision Log

- **Why vars?** Clean separation.
