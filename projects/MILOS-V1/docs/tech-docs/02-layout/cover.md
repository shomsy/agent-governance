# cover.css

## 1. Purpose

This file implements the "Cover" pattern. Its goal is to center content vertically within a container that has a minimum height (usually the full viewport height), while optionally allowing a header and footer to stick to the top and bottom.

## 2. Architectural Layer

**Layer: LAYOUT**
It manages vertical distribution and available space.

## 3. Core Concept

- **Mechanism:** Flexbox Auto Margins.
- **Why Chosen:** `margin: auto` on a flex child eats up all available free space. If used vertically, it centers the element perfectly.
- **Alternatives Considered:** `align-items: center` + `justify-content: center` (rejected because if content overflows the viewport, center alignment can clip the top, making it inaccessible).

## 4. CSS Fundamentals (MANDATORY)

### min-block-size: 100%

- **Behavior:** Ensures the container is at least as tall as its parent (or viewport).
- **Flex Direction:** `column`. Allows vertical stacking.

### margin-block: auto (The Magic)

- **Behavior:** On a child element, this splits the available vertical space equally above and below, centering it.
- **Header/Footer:** If you have 3 children (Header, Main, Footer) and put `margin-block: auto` on Main, it pushes Header to top and Footer to bottom.

## 5. CSS Properties Breakdown

- `.l-cover`: The container.
- `.l-cover-content`: The child to be centered.
- `margin-block: 0`: Resets default browser margins on children to prevent miscalculations.

## 6. MILOS Implementation Logic

We use a dedicated class `.l-cover-content` for the centered element rather than assuming the middle child. This is explicit and robust.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-container` (nested inside) | `height: fixed` (if content grows) | Inline elements |
| `l-box` | | |

## 8. Nesting & Collapse Behavior

- **Reflow:** If vertical space is scarce, it behaves like a normal stack.

## 9. Diagram (MANDATORY)

```text
  .l-cover (min-height: 100vh)
┌───────────────────────────────┐
│  [Header] (margin-top: 0)     │
│                               │
│      (margin-block: auto)     │
│  ┌───────────────────────┐    │
│  │ .l-cover-content      │    │
│  │      (Centered)       │    │
│  └───────────────────────┘    │
│      (margin-block: auto)     │
│                               │
│  [Footer] (margin-bottom: 0)  │
└───────────────────────────────┘
```

## 10. Valid Example

```html
<section class="l-cover" style="min-height: 100vh">
  <header>Logo</header>
  <div class="l-cover-content">
    <h1>Hero Title</h1>
  </div>
  <footer>Copyright</footer>
</section>
```

## 11. Invalid Example

```html
<div class="l-cover">
  <!-- Missing .l-cover-content checks means nothing centers automatically -->
</div>
```

## 12. Boundaries

- **Does NOT** force full viewport height by default (uses `100%`). You must set height on parent or style attribute.

## 13. Engine Decision Log

- **Why distinct class?** Targeting `:nth-child(2)` is fragile if a notification banner is injected dynamically.
