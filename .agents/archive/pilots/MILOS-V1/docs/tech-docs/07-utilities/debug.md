# debug.css

## 1. Purpose

This file provides a visual debugging mode for inspecting the layout. By adding the single class `.u-debug` to a container (or `<body>`), you can see the boundaries of all layout primitives and a "DEBUG ACTIVE" badge.

## 2. Architectural Layer

**Layer: UTILITIES**
It is a DX (Developer Experience) tool.

## 3. Core Concept

- **Mechanism:** Outline Highlighting.
- **Why Chosen:** Outlines do not affect layout geometry (unlike borders which add width), making them safe to toggle without causing reflows.

## 4. CSS Fundamentals (MANDATORY)

### outline: !important

- **Behavior:** Ensures the outline is visible regardless of other styles.
- **Color Coding:** Different primitives get different colors (Grid=Green, Flex=Blue, Cluster=Purple).

## 5. CSS Properties Breakdown

- `.u-debug` (Trigger class).
- Imports `outlines.css` (The colors).
- Imports `badge.css` (The warning label).

## 6. MILOS Implementation Logic

Inspired by "Pesticide" and similar browser extensions, but baked into the CSS engine itself.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Any HTML | High specificity conflicts | Production builds (strip this out!) |

## 8. Nesting & Collapse Behavior

- **Reflow:** None.

## 9. Diagram (MANDATORY)

```text
  .u-debug
┌─────────────────────────────────┐
│ [Stack: Blue Outline]           │
│ ┌─────────────────────────────┐ │
│ │ [Grid: Green Outline]       │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
  [BADGE: DEBUG MODE]
```

## 10. Valid Example

```html
<body class="u-debug">
  <!-- Everything is now outlined -->
</body>
```

## 11. Invalid Example

```css
/* Custom badge override */
.u-debug::after { display: none; }
```

## 12. Boundaries

- **Does NOT** affect production (should be tree-shaken, but isn't automatically).

## 13. Engine Decision Log

- **Why built-in?** Saves installing extensions.
