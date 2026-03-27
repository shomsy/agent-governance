# outlines.css

## 1. Purpose

This file paints the red/blue/purple outlines on elements when `.u-debug` is active.

## 2. Architectural Layer

**Layer: UTILITIES**
It is a debug component.

## 3. Core Concept

- **Mechanism:** Attribute Selector + Descendant Combos.
- **Why Chosen:** We use `outline: 1px ... !important` because `border` affects box-sizing and layout. Outline sits on top and doesn't push pixels around.

## 4. CSS Fundamentals (MANDATORY)

### outline

- **Behavior:** Sits outside the element border box but doesn't take up space in layout.

### Specificity Stacking

- **Logic:**
  - Standard items (`*`): Red `1px`.
  - Stacks (`l-stack`): Blue `2px`.
  - Grids (`l-grid`): Green `2px`.
  - Clusters (`l-cluster`): Purple `2px`.
  - **Result:** You can visually parse nested structures.

## 5. CSS Properties Breakdown

- `.u-debug *`: Standard red outline.
- `.u-debug [class*="l-stack"]`: Blue for stacks.

## 6. MILOS Implementation Logic

We use `:where()` extensively to keep specificity low, but then add `!important` because debugging must forcefully override everything.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Any HTML | `outline: none !important` (rare) | Production |

## 8. Nesting & Collapse Behavior

- **Reflow:** None.

## 9. Diagram (MANDATORY)

```text
  .u-debug
┌──────────────────────────────────────┐
│  [Stack (Blue)]                      │
│  ┌────────────────────────────────┐  │
│  │ [Grid (Green)]                 │  │
│  │ ┌──────────────┬─────────────┐ │  │
│  │ │ [Item (Red)] │ [Item (Red)]│ │  │
│  │ └──────────────┴─────────────┘ │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
```

## 10. Valid Example

```html
<main class="u-debug">
  <!-- See the blue and green boxes -->
</main>
```

## 11. Invalid Example

```css
/* Adding borders for debug ruins layout */
* { border: 1px solid red; }
```

## 12. Boundaries

- **Does NOT** inspect padding/margin (use DevTools for that).

## 13. Engine Decision Log

- **Why transparency?** So multiple outlines overlapping don't completely obscure the design.
