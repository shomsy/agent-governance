# page.css

## 1. Purpose

This file establishes the "root structure" of the page. It uses the "Holy Grail" grid layout pattern to ensure:

1. The layout fills the full vertical height of the viewport.
2. The footer always stays at the bottom, even if content is short.

## 2. Architectural Layer

**Layer: LAYOUT**
It is the top-level layout controller.

## 3. Core Concept

- **Mechanism:** Grid Layout (`grid-template-rows: auto 1fr auto`).
- **Why Chosen:** It solves the "Sticky Footer" problem without `position: absolute` hacks or minimum viewport heights on `body`.

## 4. CSS Fundamentals (MANDATORY)

### min-block-size: 100dvh

- **Logic:** Makes the page container at least as tall as the Dynamic Viewport Height (adapting to mobile browser chrome expanding/contracting).
- **Rows:** `auto` (Header size based on content), `1fr` (Main area takes ALL remaining space), `auto` (Footer size based on content).

### min-inline-size: 0

- **Safety:** Applied to direct children to prevent grid blowouts (horizontal scroll) if a child becomes too wide.

## 5. CSS Properties Breakdown

- `.l-page`: The main wrapper. Usually applied to `<body>` or a top-level `div`.

## 6. MILOS Implementation Logic

This primitive assumes a standard Header-Main-Footer structure. If you need a sidebar layout, that usually happens *inside* the Main area (or uses `l-sidebar`).

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-container` (nested) | `height: fixed` | Horizontal layouts (this is vertical) |
| `l-sidebar` | | |

## 8. Nesting & Collapse Behavior

- **Reflow:** The main content area expands to fill the screen on large monitors.
- **Scroll:** If content exceeds viewport height, the page scrolls naturally.

## 9. Diagram (MANDATORY)

```text
  .l-page (100dvh)
┌───────────────────────────────┐
│ Header (auto)                 │
├───────────────────────────────┤ (row 1)
│                               │
│ Main Content (1fr)            │
│ (Expands to fill space)       │
│                               │
├───────────────────────────────┤ (row 2)
│ Footer (auto)                 │
└───────────────────────────────┘ (row 3)
```

## 10. Valid Example

```html
<body class="l-page">
  <header>...</header>
  <main>...</main>
  <footer>...</footer>
</body>
```

## 11. Invalid Example

```html
<div class="l-page">
  <!-- Missing middle child? Layout still works but might not push footer down correctly unless empty div exists -->
</div>
```

## 12. Boundaries

- **Does NOT** define width (use `l-container` inside children).

## 13. Engine Decision Log

- **Why Grid instead of Flex?** Flex column can achieve this too, but Grid syntax (`auto 1fr auto`) is more explicit about the intent.
