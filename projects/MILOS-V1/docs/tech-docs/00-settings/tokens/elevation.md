# elevation.css

## 1. Purpose

This file manages the "Z-axis" of the design system. It defines depth (shadows), definition (borders), layering (z-index), and temporal scale (transition duration).

## 2. Architectural Layer

**Layer: SETTINGS**
It defines the physics of depth and motion.

## 3. Core Concept

- **Mechanism:** Optical depth simulation (shadows) and stacking context control (z-index).
- **Why Chosen:** To create a standard language for "which element is on top" and "how far away it is".
- **Alternatives Considered:** Flat design (no shadows, just borders) - rejected because shadows provide critical affordance in complex apps.

## 4. CSS Fundamentals (MANDATORY)

### box-shadow

- **What it is:** Simulates a light source casting a shadow behind an element.
- **Layers:** `box-shadow` supports multiple comma-separated values for complex effects (ambient + direct light).
- **Performance:** Animating `box-shadow` is expensive (causes repaints).

### z-index & Stacking Contexts

- **What it is:** Determines the vertical stacking order of elements that overlap.
- **Gotcha:** `z-index` **only works** on positioned elements (`relative`, `absolute`, `fixed`, `sticky`) or flex/grid children. It fails silently on `static` elements.
- **Stacking Context:** A new context resets the scale. `z-index: 9999` inside a context with `z-index: 1` will still be below a sibling context with `z-index: 2`.

## 5. CSS Properties Breakdown

- `--shadow-{sm,md,lg}`: Depth elevations.
- `--border-default`: A standard, subtle border color (usually semi-transparent black for mode agnosticism).
- `--duration-{fast,slow}`: Standard timings for UI transitions.
- `--z-popover`: (1000) For dropdowns, tooltips.
- `--z-modal`: (1100) For dialogs covering everything else.

## 6. MILOS Implementation Logic

We reserve `z-index` 0-999 for application usage. The framework claims 1000+ for overlays to ensure they always float above content.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-box` (shadows) | `overflow: hidden` (clips shadows) | Continuous animation (perf cost) |
| `l-imposter` (z-index) | `z-index: 9999` (global pollution) | |
| Transitions | | |

## 8. Nesting & Collapse Behavior

- **Shadows:** Do not collapse; they stack visually.
- **Z-Index:** Relative to the nearest stacking context ancestor.

## 9. Diagram (MANDATORY)

```text
Layer                  Z-Index    Shadow
─────────────────────────────────────────────
[ Modal ]              1100       --shadow-lg (Deep)
   │
[ Popover ]            1000       --shadow-md (Medium)
   │
[ Navbar ]             Sticky     --shadow-sm (Shallow)
   │
[ Content ]            Auto       None
```

## 10. Valid Example

```css
.my-modal {
  z-index: var(--z-modal);
  box-shadow: var(--shadow-lg);
}
```

## 11. Invalid Example

```css
.my-modal {
  z-index: 999999; /* Avoid z-index arms race */
}
```

## 12. Boundaries

- **Does NOT** define specific colors for shadows (uses rgba black usually).
- **Does NOT** define specific easing curves (use `ease-out` generally).

## 13. Engine Decision Log

- **Why semi-transparent borders?** `rgb(17 17 17 / 16%)` works on both light and slightly off-white backgrounds without needing a specific theme variable.
