# collapse.css

## 1. Purpose

This file handles the responsive behavior of grids using Container Queries. It defines specific points where a multi-column grid should collapse into a single vertical stack.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts layout based on *available space*.

## 3. Core Concept

- **Mechanism:** Container Queries (`@container`).
- **Why Chosen:** A sidebar widget (300px wide) behaves differently than a full-screen layout (1200px wide). Viewport queries fail here.

## 4. CSS Fundamentals (MANDATORY)

### @container layout (max-width: N)

- **Constraint:** Requires the parent (or ancestor) to have `container-type: inline-size` and `container-name: layout`.
- **Action:** Changes `grid-template-columns` to `1fr` (single column) if the condition is met.

### grid-column: 1 / -1

- **Reason:** Ensuring that *any* child (even `span-2`) becomes full width when the grid collapses.

## 5. CSS Properties Breakdown

- `.l-grid--collapse-sm`: Collapses below 40rem (`--cq-narrow`).
- `.l-grid--collapse-md`: Collapses below 60rem (`--cq-medium`).
- `.l-grid--collapse-lg`: Collapses below 72rem (`--cq-wide`).

## 6. MILOS Implementation Logic

We standardized the collapse points to match the token system (`cq.css`). This ensures predictability.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Any `.l-grid` | Missing container context (does nothing) | |

## 8. Nesting & Collapse Behavior

- **Context:** Requires `.l-cq` wrapper or similar context.

## 9. Diagram (MANDATORY)

```text
  Wide Container (> 40rem)
┌─────────────┬──────────────┐
│  Col 1      │  Col 2       │
└─────────────┴──────────────┘

  Narrow Container (< 40rem)
┌────────────────────────────┐
│  Col 1                     │
├────────────────────────────┤
│  Col 2                     │
└────────────────────────────┘
  (Standard Stack)
```

## 10. Valid Example

```html
<div class="l-cq">
  <div class="l-grid l-grid--cols-2 l-grid--collapse-sm">
    <!-- Collapses if .l-cq is < 40rem -->
    <div>A</div>
    <div>B</div>
  </div>
</div>
```

## 11. Invalid Example

```html
<div class="l-grid--collapse-sm">
  <!-- Missing .l-cq context means query never matches -->
</div>
```

## 12. Boundaries

- **Does NOT** use media queries.

## 13. Engine Decision Log

- **Why explicit points?** Intrinsic grids (`auto-fit`) handle themselves. Fixed grids (`cols-3`) need manual intervention to collapse.
