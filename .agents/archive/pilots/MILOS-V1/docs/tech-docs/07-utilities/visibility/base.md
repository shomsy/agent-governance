# base.css (Visibility)

## 1. Purpose

This file provides the basic `u-hide` and `u-show` utilities.

## 2. Architectural Layer

**Layer: UTILITIES**
It manages visibility.

## 3. Core Concept

- **Mechanism:** `display: none` / `revert`.
- **Why Chosen:** Simple, effective removal of elements from the document flow.

## 4. CSS Fundamentals (MANDATORY)

### display: none

- **Behavior:** The element is completely removed from layout calculations and accessibility tree.

### display: revert

- **Behavior:** Restores the element to its browser-default or user-agent style sheet value (e.g. `block` for `div`, `inline` for `span`). This overrides `display: none`.

## 5. CSS Properties Breakdown

- `.u-hide`: Hides everything.
- `.u-show`: Shows everything (reverts).

## 6. MILOS Implementation Logic

We use `.u-show` specifically to override `.u-hide` in responsive scenarios (e.g. Hide on mobile, Show on desktop).

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Any HTML | `display: flex !important` (inline styles) | A11y (visually hidden but readable text - use .sr-only for that) |

## 8. Nesting & Collapse Behavior

- **Reflow:** Toggling causes reflow.

## 9. Diagram (MANDATORY)

```text
  .u-hide (display: none)
  [ Nothing ]
```

## 10. Valid Example

```html
<div class="u-hide">I am gone</div>
```

## 11. Invalid Example

```css
/* Using specific display type limits utility */
.u-show { display: block; } /* Fails on spans */
```

## 12. Boundaries

- **Does NOT** handle opacity (use animation classes).

## 13. Engine Decision Log

- **Why revert?** It respects semantic HTML.
