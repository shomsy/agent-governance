# spans.css

## 1. Purpose

This file provides utilities for grid placement within the `l-rails` system.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts grid child placement.

## 3. Core Concept

- **Mechanism:** Grid Placement (`grid-column: [name]`).
- **Why Chosen:** Semantic class names (`.l-rail--wide`) map directly to the conceptual "wide" track, abstracting the complex line numbers (`2 / -2` etc).

## 4. CSS Fundamentals (MANDATORY)

### grid-column: name

- **Logic:** Places the item into the area defined by grid lines named `name`.

## 5. CSS Properties Breakdown

- `.l-rail--content`: The default (explicitly set if needed).
- `.l-rail--wide`: Spans the `wide` track (wider than content, narrower than full).
- `.l-rail--full`: Spans the `full` track (edge-to-edge).
- `.l-rail--text`: Constrains text to `--measure` (reading width) inside the content column.

## 6. MILOS Implementation Logic

We include `.l-rail--text` because `--container-max` (content column) might be too wide for comfortable reading (72ch+). This centers text even further.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `.l-rails` (Required) | `grid-column: span *` (different grid system) | |

## 8. Nesting & Collapse Behavior

- **Context:** Child scope.

## 9. Diagram (MANDATORY)

```text
  .l-rails
┌───────────────────────────────┐
│ [Full Bleed Image]            │
│  (.l-rail--full)              │
│                               │
├───────┬───────────────┬───────┤
│       │ [Wide Quote]  │       │
│       │ (.l-rail--wide)       │
│       └───────────────┘       │
├───────┬───────────────┬───────┤
│       │ [Text Block]  │       │
│       │ (.l-rail--text)       │
└───────┴───────────────┴───────┘
  (Note: Gaps visually represented)
```

## 10. Valid Example

```html
<blockquote class="l-rail--wide">
  "This quote breaks out of the column."
</blockquote>
```

## 11. Invalid Example

```html
<div class="l-rail--wide">
  <!-- Missing .l-rails parent means grid-column style is ignored or invalid -->
</div>
```

## 12. Boundaries

- **Does NOT** define alignment (use `justify-self` if needed).

## 13. Engine Decision Log

- **Why named areas?** Future-proof. We can redefine track sizes without updating markup classes.
