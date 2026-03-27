# container.css

## 1. Purpose

This file defines the structural constraints of the layout. It sets the maximum width of the main content area, the minimum widths for responsive cards (for intrinsic grids), and standard sidebar dimensions.

## 2. Architectural Layer

**Layer: SETTINGS**
It defines the horizontal boundaries of the design.

## 3. Core Concept

- **Mechanism:** CSS Variables (rem, ch).
- **Why Chosen:** Centralizes all "magic numbers" related to layout widths.
- **Alternatives Considered:** Hardcoding widths in layout files (rejected because it makes global width adjustments impossible).

## 4. CSS Fundamentals (MANDATORY)

### The `ch` unit

- **What it is:** The width of the "0" (zero) character in the current font.
- **Usage:** `--measure: 65ch` defines the optimal line length for readability (approx 65 characters per line).
- **Benefit:** Scales perfectly with font size. If user increases text size, the container expands to maintain readability.

### Intrinsic Sizing Thresholds

- **What it is:** Variables like `--card-min-md` define the "ideal minimum width" of a component.
- **Usage:** Used in `minmax(var(--card-min-md), 1fr)` grid definitions.
- **Benefit:** Allows components to determine their own layout based on available space, not viewport width.

## 5. CSS Properties Breakdown

- `--container-max`: The maximum width of the standard page container (e.g. 72rem).
- `--container-wide`: A wider alternative (e.g. 90rem) for dashboards or data tables.
- `--container-pad`: The horizontal padding (gutter) inside the container.
- `--sidebar-width`: Standard sidebar width.
- `--measure`: Optimal reading width (60-70ch).
- `--switcher-min-*`: Breakpoints for the `l-switcher` component.
- `--card-min-*`, `--gallery-min-*`: Thresholds for intrinsic grid columns.

## 6. MILOS Implementation Logic

MILOS relies heavily on "RAM" (Repeat, Auto, Minmax) techniques. These variables feed the `min` part of that logic. By tweaking `--card-min-md`, you globally adjust when grid cards wrap across the entire application.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-container` | `width: 100vw` (causes scrollbar) | Height-based layouts |
| `l-sidebar` | | |
| `l-grid` (feature/auto) | | |
| `l-switcher` | | |
| `l-width--measure` | | |

## 8. Nesting & Collapse Behavior

- **Global:** Variables cascade down.
- **Context:** Can be redefined inside a specific component to change its wrapping behavior.

## 9. Diagram (MANDATORY)

```text
Screen Width
◄──────────────────────────────►

   ┌───────────────────────┐
   │ --container-max (72rem)│
   │                       │
   │  [Content]            │
   │                       │
   └───────────────────────┘
   ◄--pad--►       ◄--pad--►
```

## 10. Valid Example

```css
.my-grid {
  grid-template-columns: repeat(auto-fit, minmax(var(--card-min-md), 1fr));
}
```

## 11. Invalid Example

```css
.my-grid {
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); /* Hardcoded magic number */
}
```

## 12. Boundaries

- **Does NOT** define the grid system itself (number of columns).
- **Does NOT** handle vertical rhythm (see usually `space.css`).

## 13. Engine Decision Log

- **Why 72rem?** Fits standard 12-column grid comfortably on 13-inch laptops while leaving margins.
- **Why `ch` for measure?** Typography research dictates 45-75 characters per line for optimal reading speed.
