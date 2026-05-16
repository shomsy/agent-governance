# modifiers.css (Region)

## 1. Purpose

This file provides variants for the section padding depth. It allows you to create "tight" sections (like a footer pre-bar) or "airy" sections (like a hero).

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts padding.

## 3. Core Concept

- **Mechanism:** Variable Reassignment (`--region-space`).
- **Why Chosen:** Reusing the base logic while just changing the value creates a cleaner cascade.

## 4. CSS Fundamentals (MANDATORY)

### Variable Override

- **Logic:** The modifiers update `--region-space` which is consumed by `.l-region` as `padding-block`.

## 5. CSS Properties Breakdown

- `.l-region--0`: No padding.
- `.l-region--sm`: Small padding (`--space-2`).
- `.l-region--md`: Medium (`--space-4`).
- `.l-region--lg`: Large (`--space-6`).

## 6. MILOS Implementation Logic

We align these modifiers with standard spacing tokens (`sm`, `md`, `lg`) for predictability.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `.l-region` | Manually set padding-block (overrides var) | |

## 8. Nesting & Collapse Behavior

- **Context:** Local scope.

## 9. Diagram (MANDATORY)

```text
  .l-region--sm     .l-region--lg
┌───────────────┐ ┌───────────────┐
│ (Small Pad)   │ │ (Large Pad)   │
│ Content       │ │ Content       │
│ (Small Pad)   │ │ (Large Pad)   │
└───────────────┘ └───────────────┘
```

## 10. Valid Example

```html
<footer class="l-region l-region--sm">
  <small>Copyright</small>
</footer>
```

## 11. Invalid Example

```html
<div class="l-region--lg">
  <!-- Missing base -->
</div>
```

## 12. Boundaries

- **Does NOT** affect horizontal padding.

## 13. Engine Decision Log

- **Why 0 padding?** Sometimes needed for full-bleed images inside a grid.
