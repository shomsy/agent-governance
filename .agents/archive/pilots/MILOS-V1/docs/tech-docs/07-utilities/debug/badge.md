# badge.css

## 1. Purpose

This file adds a fixed-position warning badge to the bottom-right corner when debug mode is active.

## 2. Architectural Layer

**Layer: UTILITIES**
It is a debug indicator.

## 3. Core Concept

- **Mechanism:** `position: fixed` pseudo-element (`::after`).
- **Why Chosen:** No extra HTML needed (`<div class="badge">`). It appears automatically.

## 4. CSS Fundamentals (MANDATORY)

### pointer-events: none

- **Behavior:** Ensures the badge doesn't block clicks on content underneath it, even though it's visibly on top.
- **z-index: 9999:** Ensures it floats above modals.

## 5. CSS Properties Breakdown

- `.u-debug::after`: The badge content "LAYOUT DEBUG MODE ACTIVE".

## 6. MILOS Implementation Logic

We use `content: "LAYOUT DEBUG MODE ACTIVE"` directly in CSS.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Any HTML | Bottom-right fixed elements (might overlap visually) | |

## 8. Nesting & Collapse Behavior

- **Reflow:** None (Removed from flow via position: fixed).

## 9. Diagram (MANDATORY)

```text
  Browser Window
┌───────────────────────────────┐
│                               │
│  Content...                   │
│                               │
│                  [BADGE]      │
└───────────────────────────────┘
```

## 10. Valid Example

```html
<body class="u-debug">
  <!-- Badge appears bottom right -->
</body>
```

## 11. Invalid Example

```css
/* Hides badge but keeps outlines? */
.u-debug::after { display: none; }
```

## 12. Boundaries

- **Does NOT** contain interactive logic.

## 13. Engine Decision Log

- **Why fixed?** So you always know why your site has red borders everywhere.
