# space.css

## 1. Purpose

This is the single source of truth for all spacing in the system. It defines a fluid scale (`--space-*`) that scales linearly with the viewport width, and semantic aliases (`--gap-*`) used by layout components.

## 2. Architectural Layer

**Layer: SETTINGS**
It defines the physical dimensions of empty space.

## 3. Core Concept

- **Mechanism:** Fluid CSS Variables using `clamp()`.
- **Why Chosen:** Instead of jumping abruptly at breakpoints, spacing grows smoothly as the screen gets wider. This eliminates "awkward" intermediate states.
- **Alternatives Considered:** Static rem values (rejected for lack of responsiveness) or media-query-based steps (rejected for complexity).

## 4. CSS Fundamentals (MANDATORY)

### Fluid Scaling Formula

- **What it is:** `clamp(MIN, PREFERRED + GROW_RATE, MAX)`.
- **How it works:** `clamp(1rem, 0.85rem + 0.6vw, 1.5rem)` means: start at 1rem (mobile), add 0.6% of viewport width (so it grows), but cap at 1.5rem (desktop).
- **Benefit:** Spacing feels "tight" on mobile and "airy" on extensive desktop displays automatically.

## 5. CSS Properties Breakdown

- `--space-{0..6}`: The primitive geometric scale. Purely mathematical (0, xs, small, medium, large, xl, xxl).
- `--gap-{xs..xl}`: Semantic aliases for gaps between components.
- `--gutter-{x,y}`: Default page gutters (padding).
- `--layout-gap`: The global default gap for stacks and clusters.

## 6. MILOS Implementation Logic

We use a two-step definition:

1. **Primitives:** `--space-3` (the physical value).
2. **Semantics:** `--gap-sm: var(--space-3)` (the layout meaning).
This allows us to change the meaning of "small gap" globally without changing the underlying math.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-stack` (consumes gap) | Hardcoded `px` margin | `font-size` (use type scale instead) |
| `l-cluster` | | |
| `l-grid` | | |
| `l-region` | | |

## 8. Nesting & Collapse Behavior

- **Global:** Variables cascade down.
- **Override:** Can be locally redefined for a specific section (`style="--layout-gap: 0"`).

## 9. Diagram (MANDATORY)

```text
Viewport Width:      320px         1920px
                       │             │
--space-4 (gap-md)     │             │
Value:                 1rem  ----->  1.5rem
                       (Growth Curve)
```

## 10. Valid Example

```css
.my-custom-card {
  padding: var(--gap-md); /* Uses fluid scale */
}
```

## 11. Invalid Example

```css
.my-custom-card {
  padding: 24px; /* Hardcoded magic number */
}
```

## 12. Boundaries

- **Does NOT** define container widths (see `container.css`).
- **Does NOT** define component heights.

## 13. Engine Decision Log

- **Why `clamp()`?** It simplifies the codebase by removing thousands of media query lines for standard spacing adjustments.
- **Why Semantic Aliases?** To support density modes (Compact/Comfortable) by simply re-aliasing `--layout-gap`.
