# self.css

## 1. Purpose

This file provides utilities for individual items to ignore their container's alignment logic and align themselves differently.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts item alignment.

## 3. Core Concept

- **Mechanism:** Self Alignment (`place-self`, `align-self`, `justify-self`).
- **Why Chosen:** A grid might `align-items: stretch` all cards, but one card (e.g. "Add New") needs to be centered.

## 4. CSS Fundamentals (MANDATORY)

### place-self: X Y

- **Logic:** Shorthand for `align-self` (Block Axis) and `justify-self` (Inline Axis).
- **Default:** `auto` (Inherits parent's `align/justify-items`).
- **Options:** `center`, `start`, `end`, `stretch`.

## 5. CSS Properties Breakdown

- `.l-self--center`: Centers the item vertically and horizontally.
- `.l-self--start`: Anchors to top-left (LTR).
- `.l-self--end`: Anchors to bottom-right (LTR).
- `.l-self--stretch`: Forces full stretch.

## 6. MILOS Implementation Logic

We use `place-self` because Grid supports both axes. Flexbox only supports `align-self` (cross-axis), but `place-self` usually maps correctly or is ignored on the main axis.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Grid Items | `display: block` (ignored) | |
| Flex Items (Partial) | `margin: auto` (competes) | |

## 8. Nesting & Collapse Behavior

- **Context:** Item scope.

## 9. Diagram (MANDATORY)

```text
  Grid Container (align-items: stretch)
┌──────────────┬──────────────┐
│ [Card 1]     │ [Card 2]     │
│ (Stretched)  │ (Stretched)  │
├──────────────┼──────────────┤
│              │              │
│ [Card 3]     │    [x]       │
│ (Stretched)  │ (.l-self--center)
└──────────────┴──────────────┘
```

## 10. Valid Example

```html
<div class="l-grid">
  <div class="card">Content</div>
  <div class="l-self--center">
    <button>Add</button>
  </div>
</div>
```

## 11. Invalid Example

```html
<div class="l-self--center">
  <!-- Not inside a container -->
</div>
```

## 12. Boundaries

- **Does NOT** affect content *inside* the item (unless the item itself is also a grid/flex container).

## 13. Engine Decision Log

- **Why shorthand?** Conciseness.
