# cq.css

## 1. Purpose

This file centralizes the Container Query breakpoints used throughout the system. It defines standard widths (`--cq-narrow`, `--cq-medium`, `--cq-wide`) at which components should adapt their layout.

## 2. Architectural Layer

**Layer: SETTINGS**
It defines responsive boundaries for component architecture.

## 3. Core Concept

- **Mechanism:** CSS Custom Properties.
- **Why Chosen:** To name the "magic numbers" where layout shifts occur.
- **Alternatives Considered:** Hardcoded pixel values in every container query (rejected for maintenance reasons).

## 4. CSS Fundamentals (MANDATORY)

### Container Queries (`@container`)

- **What it is:** A way to apply styles to an element based on the size of its parent container, rather than the viewport.
- **Current Limitation:** As of 2026, CSS standardization drafts still debate `var()` inside `@container` rules.
- **Usage Strategy:** These variables are primarily used for:
  1. Setting `max-width` constraints on fluid elements.
  2. JavaScript-based `ResizeObserver` logic that needs to match CSS breakpoints.
  3. Pre-processor injection (if using PostCSS).
  4. Documentation reference/standardization for developers writing query rules manually.

## 5. CSS Properties Breakdown

- `--cq-narrow`: Breakpoint for small contexts (e.g. sidebar widgets).
- `--cq-medium`: Breakpoint for tablet-like contexts (e.g. main content area).
- `--cq-wide`: Breakpoint for desktop-like contexts.

## 6. MILOS Implementation Logic

MILOS encourages "intrinsic" design where components adapt fluidly. However, at certain points (`--cq-*`), a component might switch from `stack` layout to `cluster` layout. We standardize these points to avoid "breakpoint soup."

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-grid` (responsive items) | `@media` queries (layout is context-aware, not screen-aware) | |
| `l-stack` / `l-cluster` | | |
| `l-card` | | |

## 8. Nesting & Collapse Behavior

- **Global:** Variables cascade down.
- **Context:** Container queries nest. A component inside a narrow container inside a wide page will see the narrow context.

## 9. Diagram (MANDATORY)

```text
Component Context Width:
0px        40rem       60rem       72rem
│           │           │           │
├── Stack ──┼── Grid 2 ─┼── Grid 3 ─┤
│           │           │           │
(Narrow)    (Medium)    (Wide)
```

## 10. Valid Example

```css
/* Standard usage (conceptually) */
.my-component {
  container-type: inline-size;
}

/* If supported pre-processor or future CSS */
@container (min-width: 40rem) { 
  /* ... */ 
}
```

## 11. Invalid Example

```css
/* Mixing media and container queries */
@media (min-width: 60rem) {
  /* This measures viewport, not component context! */
}
```

## 12. Boundaries

- **Does NOT** enable container queries on elements (requires `container-type`).
- **Does NOT** strictly enforce usage (browser support dependent).

## 13. Engine Decision Log

- **Why these values?** 40rem matches distinct "tablet" width; 60rem matches "desktop" content width; 72rem matches full "container-max".
