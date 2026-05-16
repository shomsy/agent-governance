# sidebar.css

## 1. Purpose

This file implements the "Classic Sidebar" pattern. It creates a layout with two columns: a fixed-width sidebar and a fluid main content area. Crucially, it handles responsiveness **without media queries**: if there isn't enough room for both side-by-side, the sidebar wraps on top (or content wraps below, depending on exact mechanics, though usually this pattern wraps into a vertical stack).

## 2. Architectural Layer

**Layer: LAYOUT**
It is a macro-layout primitive.

## 3. Core Concept

- **Mechanism:** "The Fab Four" Equation (Flexbox Wrapping Trick).
- **Why Chosen:** It provides a robust responsive behavior based on *available container width*, not viewport width.

## 4. CSS Fundamentals (MANDATORY)

### The "Fab Four" Logic

1. **Container:** `flex-wrap: wrap`.
2. **Sidebar (First Child):** `flex-basis: <width>; flex-grow: 1`.
3. **Content (Last Child):**
    - `flex-basis: 0`: Starts at 0 size.
    - `flex-grow: 999`: Grows at a massive rate compared to separation.
    - `min-inline-size: 50%`: The breakpoint trigger.

**How it works:**
- **Roomy:** If the container is wider than `sidebar-width + 50%`, both fit. The sidebar takes its basis, the content takes the rest (because `999` >>> `1`).
- **Cramped:** If the container is narrower, the content (needing at least 50%) forces a wrap. Once wrapped, `flex-grow: 1` on the sidebar makes it expand to full width (stacking).

## 5. CSS Properties Breakdown

- `.l-sidebar`: The container.
- `--sidebar-size`: Width of the fixed column (defaults to 18rem).
- `> :first-child`: The Sidebar.
- `> :last-child`: The Main Content.

## 6. MILOS Implementation Logic

We use `:first-child` and `:last-child` structural pseudo-classes. This implies the `l-sidebar` container should have exactly two direct children.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-container` (parent) | More than 2 children (breakdown of logic) | |
| `l-box` (children) | | |

## 8. Nesting & Collapse Behavior

- **Reflow:** Wraps into a vertical stack automatically.
- **Gap:** Spacing is maintained in both horizontal and vertical modes.

## 9. Diagram (MANDATORY)

```text
  Wide Space
┌────────────┬──────────────────────────────────┐
│ Sidebar    │ Main Content (grows)             │
│ (18rem)    │                                  │
└────────────┴──────────────────────────────────┘

  Narrow Space (Wrapped)
┌───────────────────────────────────────────────┐
│ Sidebar (grows to 100%)                       │
├───────────────────────────────────────────────┤
│ Main Content (grows to 100%)                  │
└───────────────────────────────────────────────┘
```

## 10. Valid Example

```html
<div class="l-sidebar">
  <aside> I am the sidebar </aside>
  <main> I am the content </main>
</div>
```

## 11. Invalid Example

```html
<div class="l-sidebar">
  <div>Side</div>
  <div>Content</div>
  <div>Third Wheel?</div> <!-- Logic breaks here -->
</div>
```

## 12. Boundaries

- **Does NOT** strictly enforce the Sidebar is on the left. DOM order dictates it. Use `flex-direction: row-reverse` if you want a right sidebar but keeping DOM order.

## 13. Engine Decision Log

- **Why logic based?** It solves the "Container Query" problem for sidebars without needing recent browser tech (works everywhere flexbox works).
