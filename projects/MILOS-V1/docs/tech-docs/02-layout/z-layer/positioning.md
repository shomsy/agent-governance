# positioning.css (Z-Layer)

## 1. Purpose

This file ensures that any element using a `z-index` class *actually works*. Z-index has no effect on static elements.

## 2. Architectural Layer

**Layer: LAYOUT**
It is a safety utility.

## 3. Core Concept

- **Mechanism:** `position: relative`.
- **Why Chosen:** It's the least intrusive way to trigger a stacking context without removing the element from the document flow.

## 4. CSS Fundamentals (MANDATORY)

### Selector Logic: `[class*="l-z-"]`

- **Behavior:** This wildcard selector targets any element with a class containing `l-z-` (e.g. `l-z-content`, `l-z-modal`).
- **Effect:** Applies `position: relative` automatically.

## 5. CSS Properties Breakdown

- `:where([class*="l-z-"])`: Sets position.

## 6. MILOS Implementation Logic

We use this "automated" approach so you don't have to remember to type `position: relative` every time you use a `z-index` utility. It makes the utilities "just work".

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Any `l-z-*` class | `position: absolute/fixed` (overrides relative, which is fine since z-index works on them too) | Static elements |

## 8. Nesting & Collapse Behavior

- **Reflow:** None (relative positioning keeps layout space).

## 9. Diagram (MANDATORY)

```text
  <div class="l-z-content">
     ^ Automatically gets position: relative
  </div>
```

## 10. Valid Example

```html
<header class="l-z-content">
  <!-- My z-index: 50 works immediately -->
</header>
```

## 11. Invalid Example

```css
/* Manual override without understanding why */
.l-z-content { position: static !important; } /* Breaks z-index */
```

## 12. Boundaries

- **Does NOT** override if a more specific position is set (e.g. `position: fixed` or `absolute` from another class).

## 13. Engine Decision Log

- **Why wildcard selector?** To avoid listing every single z-class manually in this file.
