# base.css (Box Primitive)

## 1. Purpose

This file defines the most fundamental layout primitive: the Box (`.l-box`). Its sole job is to encapsulate content within a consistent padding, creating "breathing room" and defining a visual boundary (border/background).

## 2. Architectural Layer

**Layer: LAYOUT**
It handles internal spacing and containment.

## 3. Core Concept

- **Mechanism:** Padding and Border containment.
- **Why Chosen:** To centralize the concept of "inset content". Instead of adding `padding: 20px` to random divs, we use `l-box` to ensure all containers share the same system spacing.

## 4. CSS Fundamentals (MANDATORY)

### The `padding` property

- **Behavior:** Pushes content inward from the border.
- **Box Model:** Because we use `box-sizing: border-box`, adding padding does NOT increase the total width of the element if width is set; it squeezes the available content area.

### :where() Pseudo-class

- **Specificity:** Takes the specificity of the most specific argument. `:where(.class)` equals specificity **(0, 0, 0)**.
- **Impact:** This allows any other class (even a single utility class) to override styles defined here without needing `!important`.

## 5. CSS Properties Breakdown

- `--pad`: A locally scoped variable defaulting to `--space-4`. This variable is the "knob" that modifiers turn.
- `padding`: Set to `var(--pad)`.
- `border`: Uses `--border-default` (usually transparent or subtle).
- `display: block`: Ensures the box takes up the full width of its parent (standard block behavior).

## 6. MILOS Implementation Logic

We scope `--pad` locally within the `.l-box` selector. This means nested boxes don't inherit the *value* of padding in a cascading way, but they re-evaluate global tokens.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-stack` (vertical rhythm) | `padding` utility classes (override base) | Inline elements (`span`) |
| `l-cluster` | | |
| `l-card` (extends box) | | |

## 8. Nesting & Collapse Behavior

- **Nesting:** `.l-box > .l-box`. The inner box will have its own padding *plus* the outer box's padding, creating a double-indented look.
- **Collapse:** Padding does not collapse like margins do.

## 9. Diagram (MANDATORY)

```text
  .l-box
  ┌───────────────────────────┐
  │ Padding (var(--pad))      │
  │ ┌───────────────────────┐ │
  │ │ Content               │ │
  │ │                       │ │
  │ └───────────────────────┘ │
  │                           │
  └───────────────────────────┘
```

## 10. Valid Example

```html
<div class="l-box">
  <p>I have standard padding.</p>
</div>
```

## 11. Invalid Example

```html
<span class="l-box">
  <!-- Box forces display: block, breaking inline flow -->
</span>
```

## 12. Boundaries

- **Does NOT** set background color (use utilities or component classes).
- **Does NOT** restrict width (use `l-container`).

## 13. Engine Decision Log

- **Why :where?** To make the layout system "soft". If a developer adds `p-0` (padding: 0 utility), it should win instantly. Standard classes would fight it.
