# base.css (Region Primitive)

## 1. Purpose

This file provides consistent vertical padding (whitespace) to group related content into distinct sections. It ensures that meaningful visual breaks exist between major parts of the page.

## 2. Architectural Layer

**Layer: LAYOUT**
It manages vertical rhythm (macro-scale).

## 3. Core Concept

- **Mechanism:** Padding Block.
- **Why Chosen:** `padding` pushes content inward, creating a safe zone where background colors can be applied without text touching the edge. `margin` pushes other elements away but doesn't include the background.

## 4. CSS Fundamentals (MANDATORY)

### padding-block

- **Behavior:** Adds space to the top and bottom (logical property).

## 5. CSS Properties Breakdown

- `.l-region`: The container.
- `--region-space`: Defaults to `--gutter-y` (standard vertical gutter).

## 6. MILOS Implementation Logic

We use a CSS variable `--region-space` so modifiers can tweak it (`--region-space: var(--space-xl)`) and the padding declaration updates automatically.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-container` (nested inside to constrain width) | `l-cover` (if height is strictly 100vh) | Inline elements |
| `l-box` (styles background) | | |

## 8. Nesting & Collapse Behavior

- **Context:** Usually top-level `<section>` or `<footer>`.

## 9. Diagram (MANDATORY)

```text
  .l-region (Background Color)
┌───────────────────────────────┐
│     (Padding Top)             │
│   ┌───────────────────────┐   │
│   │ Content               │   │
│   └───────────────────────┘   │
│     (Padding Bottom)          │
└───────────────────────────────┘
```

## 10. Valid Example

```html
<section class="l-region" style="background: var(--bg-surface-2)">
  <div class="l-container">
    <h2>Features</h2>
  </div>
</section>
```

## 11. Invalid Example

```html
<span class="l-region">
  <!-- Padding block on inline elements doesn't push layout vertically -->
</span>
```

## 12. Boundaries

- **Does NOT** set width (full width by default).

## 13. Engine Decision Log

- **Why padding?** Background color support.
