# radius.css

## 1. Purpose

This file defines the curvature of UI elements. It establishes a consistent "softness" across the interface, ensuring that buttons, cards, and inputs share the same geometric personality.

## 2. Architectural Layer

**Layer: SETTINGS**
It defines the aesthetic geometry.

## 3. Core Concept

- **Mechanism:** CSS Custom Properties (rem).
- **Why Chosen:** To allow global adjustment of "corner sharpness". A single change can transform the app from friendly (rounded) to severe (sharp).
- **Alternatives Considered:** Pixel values (rejected because they look different on high-DPI screens or when zoomed).

## 4. CSS Fundamentals (MANDATORY)

### border-radius

- **What it is:** Defines the radius of the circle used to round the corner of an element's border box.
- **Impact:** Affects the border, background, and `overflow: hidden` clipping mask.
- **Note:** If `border-radius` exceeds 50% of the element's size, it becomes circular/pill-shaped.

## 5. CSS Properties Breakdown

- `--radius-sm`: For small elements (tags, badges, tiny buttons).
- `--radius-md`: For standard elements (buttons, inputs).
- `--radius-lg`: For large containers (cards, modals).

## 6. MILOS Implementation Logic

We enforce just 3 sizes to prevent "radius soup" where every element looks slightly different. Consistency in curvature is key to professional polish.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-box` | Mixing `px` and `rem` radii | Circular avatars (`50%` is separate) |
| Inputs / Buttons | | |
| Cards | | |

## 8. Nesting & Collapse Behavior

- **Global:** Variables cascade.
- **Composition:** Nested elements often need *less* radius than their container to look geometrically correct (nested radius = outer radius - padding). MILOS generally ignores this math for simplicity, sticking to the standard scale.

## 9. Diagram (MANDATORY)

```text
  radius-sm      radius-md      radius-lg
  ┌──┐           ╭──╮           ╭───╮
  │  │           │  │           │   │
  └──┘           ╰──╯           ╰───╯
  (Soft)         (Round)        (Bubble)
```

## 10. Valid Example

```css
.card {
  border-radius: var(--radius-lg);
}
```

## 11. Invalid Example

```css
.card {
  border-radius: 12px; /* Hardcoded magic number */
}
```

## 12. Boundaries

- **Does NOT** handle specialized shapes (clip-path).
- **Does NOT** define circle shapes (use `border-radius: 50%`).

## 13. Engine Decision Log

- **Why rem?** So corners scale up when the user increases the base font size for accessibility.
