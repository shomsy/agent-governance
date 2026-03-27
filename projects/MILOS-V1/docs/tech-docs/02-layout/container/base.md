# base.css (Container Primitive)

## 1. Purpose

This file is the bedrock of the page structure. It defines the `.l-container`, which constrains content width, centers it horizontally, and enforces consistent horizontal padding (gutters) so text never touches the screen edge.

## 2. Architectural Layer

**Layer: LAYOUT**
It is the primary shell primitive.

## 3. Core Concept

- **Mechanism:** Calculated Width + Safe Area Padding.
- **Why Chosen:** To ensure that content respects both the maximum design width (`--container-max`) AND the device constraints (safe areas/notches) simultaneously.

## 4. CSS Fundamentals (MANDATORY)

### box-sizing: content-box (Override)

- **Behavior:** `width` refers to the content area *only*. Padding is added on top.
- **Why:** We want the *content* to be exactly `--container-max` wide on large screens, or the viewport minus padding on small screens.

### Calculated Width: `min(100% - (pad * 2), max)`

- **Logic:**
  1. Take the full parent width (`100%`).
  2. Subtract the required gutter space on both sides (`pad * 2`).
  3. Compare this result with the maximum allowed width (`--container-max`).
  4. Use whichever is smaller.
- **Result:** on mobile, width is "screen - padding". On desktop, width is "max width".

### Safe Area Padding: `max(pad, env(safe))`

- **Logic:** The padding is either the standard design token (`--container-pad`) OR the device notch size (`env(safe-area-inset-left)`), whichever is larger.
- **Benefit:** Ensures content is never hidden behind a notch, but doesn't add double padding if the notch is small.

## 5. CSS Properties Breakdown

- `--container-inline-pad`: Local alias for the padding token.
- `margin-inline: auto`: Centers the container in the viewport.
- `inline-size`: The main width constraint logic.

## 6. MILOS Implementation Logic

We effectively remove the padding from the width calculation, then add it back as real padding. This seemingly complex dance ensures that `l-bleed` (which uses `-50vw`) has a consistent center point to calculate from.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-bleed` (relies on this centering) | `width: 100%` overrides | Nested inside another container (padding doubles) |
| `l-grid` | | |
| `l-stack` | | |

## 8. Nesting & Collapse Behavior

- **Nesting:** `.l-container` is typically a direct child of `body` or a full-width section. Nesting it is possible but usually redundant.

## 9. Diagram (MANDATORY)

```text
  Viewport (Desktop)
┌─────────────────────────────────┐
│     Margin Auto (Flexible)      │
│   ┌─────────────────────────┐   │
│   │ Padding                 │   │
│   │ ┌─────────────────────┐ │   │
│   │ │ Content (Max Width) │ │   │
│   │ └─────────────────────┘ │   │
│   │ Padding                 │   │
│   └─────────────────────────┘   │
│     Margin Auto (Flexible)      │
└─────────────────────────────────┘
```

## 10. Valid Example

```html
<body>
  <main class="l-container">
    <h1>Page Title</h1>
  </main>
</body>
```

## 11. Invalid Example

```html
<div class="l-sidebar">
  <!-- Sidebar is narrow, container padding might be too much here -->
  <div class="l-container">...</div>
</div>
```

## 12. Boundaries

- **Does NOT** define background colors.

## 13. Engine Decision Log

- **Why not `max-width: var(--container-max)`?** Standard `max-width` with `border-box` includes padding. If `--container-max` is 72rem (content width), we'd have to manually add padding to it (`calc(72rem + 2 * pad)`) to get the box width. The `content-box` approach makes the math explicit and variable-independent.
