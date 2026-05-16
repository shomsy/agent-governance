# visibility.css

## 1. Purpose

This file provides utilities for hiding or showing elements based on certain conditions (usually breakpoints or Container Queries).

## 2. Architectural Layer

**Layer: UTILITIES**
It manages responsive visibility.

## 3. Core Concept

- **Mechanism:** `display: none`.
- **Why Chosen:** The standard way to remove an element from the layout and accessibility tree.

## 4. CSS Fundamentals (MANDATORY)

### display: revert

- **Behavior:** The `.u-show` utility uses `display: revert` instead of `display: block`. This restores the element's natural display type (e.g. `table`, `flex`, `inline`) rather than forcing everything to `block`.

## 5. CSS Properties Breakdown

- `.u-hide`: Hides element.
- `.u-show`: Shows element (reverts display property).
- Imports `cq.css` (Container Query variants).

## 6. MILOS Implementation Logic

We bundle `base.css` (global hide/show) and `cq.css` (responsive hide/show) into one import.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-stack`, `l-grid` | `display: flex !important` (inline styles might win) | A11y (removed from screen readers too) |
| `visibility: hidden` (this keeps layout space, display:none removes it) | | |

## 8. Nesting & Collapse Behavior

- **Reflow:** Toggling causes reflow.

## 9. Diagram (MANDATORY)

```text
  .u-hide (display: none)
  [ Nothing rendered here ]

  .u-show (display: revert)
  [ Element visible ]
```

## 10. Valid Example

```html
<div class="u-hide u-show--cq-wide">
  <!-- Hidden by default, shown only on wide containers -->
</div>
```

## 11. Invalid Example

```css
/* Using explicit block instead of revert limits utility */
.u-show { display: block !important; }
```

## 12. Boundaries

- **Does NOT** use `visibility: hidden` (use custom utility if you need to reserve space).

## 13. Engine Decision Log

- **Why CQ visibility?** Media Queries are banned in MILOS layout logic, so visibility must also be container-aware.
