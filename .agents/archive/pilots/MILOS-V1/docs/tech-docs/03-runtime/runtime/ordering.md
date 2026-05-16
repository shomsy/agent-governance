# ordering.css

## 1. Purpose

This file provides utilities to reorder items visually within a flex or grid layout, without changing the source order in the HTML.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts visual order.

## 3. Core Concept

- **Mechanism:** Flex/Grid Order Property (`order`).
- **Why Chosen:** Useful for responsive designs where a footer might become a header on mobile, or vice versa (though rare).

## 4. CSS Fundamentals (MANDATORY)

### order: X

- **Logic:** Default is 0. Lower numbers appear first, higher numbers appear last.
- **Negative:** `order: -1` guarantees it appears before default items.
- **Positive:** `order: 999` guarantees it appears after default items.

### ⚠️ Accessibility Warning

- **Screen Readers:** Read content in DOM order (source order), NOT visual order.
- **Tab Order:** Follows DOM order.
- **Conclusion:** Changing visual order can create a disconnect for keyboard/screen reader users. Use sparingly!

## 5. CSS Properties Breakdown

- `.l-order--first`: `order: -1`.
- `.l-order--last`: `order: 999`.

## 6. MILOS Implementation Logic

We provide only extreme values (first/last) because granular ordering (1, 2, 3) is too fragile and hard to maintain in CSS classes.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Flex/Grid Items | `display: block` (order ignored) | Accessible interactive flows (forms) |

## 8. Nesting & Collapse Behavior

- **Context:** Item scope.

## 9. Diagram (MANDATORY)

```text
  DOM: [A] [B] [C]
  CSS: [C (.l-order--first)] [A] [B]
  
  Visual: C A B
  Reader: A B C (Confusing!)
```

## 10. Valid Example

```html
<div class="l-cluster">
  <button>Cancel</button>
  <button class="l-order--first">Primary Action</button>
  <!-- Visually Primary is left, but focus lands on Cancel first? Be careful. -->
</div>
```

## 11. Invalid Example

```html
<div class="l-order--first">
  <!-- Not a flex item -->
</div>
```

## 12. Boundaries

- **Does NOT** change focus order.

## 13. Engine Decision Log

- **Why include despite a11y risks?** Sometimes purely decorative reordering (e.g. image vs text in a card) is valid.
