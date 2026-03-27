# base.css (Stack Primitive)

## 1. Purpose

This file implements the `l-stack` primitive, which is the default vertical layout mechanism for groups of components (buttons, cards, inputs). It is essentially a Flex Column with consistent spacing.

## 2. Architectural Layer

**Layer: LAYOUT**
It manages vertical flow.

## 3. Core Concept

- **Mechanism:** Flexbox Column (`display: flex; flex-direction: column`).
- **Why Chosen:** It provides gap control (`gap`) and alignment control (`align-items`) in a way that margins (`l-flow`) cannot.

## 4. CSS Fundamentals (MANDATORY)

### display: flex; flex-direction: column

- **Behavior:** Items stack vertically.
- **Intrinsic Sizing:** Items stretch to full width by default (`align-items: stretch`).

### min-inline-size: 0 (on children)

- **Problem:** Flex items sometimes refuse to shrink below their content size, causing horizontal overflow.
- **Fix:** `min-width: 0` allows text truncation and responsive images to work correctly inside a stack.

## 5. CSS Properties Breakdown

- `.l-stack`: The container.
- `--gap`: Defaults to `--layout-gap`.
- `gap`: Uses the variable.

## 6. MILOS Implementation Logic

We use `l-stack` for *structural* vertical stacking (Card Header + Body + Footer), whereas `l-flow` is for *content* vertical flow (Heading + Paragraphs). The difference is subtle but important: `l-stack` implies a rigid relationship.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-box` (styles background) | `display: grid` (override) | Inline text (behaves like block) |
| `l-cluster` (child) | | |

## 8. Nesting & Collapse Behavior

- **Reflow:** Stacks adapt to height changes naturally.

## 9. Diagram (MANDATORY)

```text
  .l-stack
┌──────────────┐
│ [ Item 1 ]   │
│              │
│ (gap)        │
│              │
│ [ Item 2 ]   │
└──────────────┘
```

## 10. Valid Example

```html
<form class="l-stack">
  <label>Email</label>
  <input type="email">
  <button>Submit</button>
</form>
```

## 11. Invalid Example

```html
<span class="l-stack">
  <!-- Valid HTML5, but semantic confusion -->
</span>
```

## 12. Boundaries

- **Does NOT** collapse margins (flex gap is separate).

## 13. Engine Decision Log

- **Why flex?** Gap support is universal now.
