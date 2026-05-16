# widths.css

## 1. Purpose

This file provides width modifiers that can override the standard container size or apply specific reading constraints to any block element.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts the geometry of containers or blocks.

## 3. Core Concept

- **Mechanism:** Inline Size Override.
- **Why Chosen:** A blog post might need a standard width, but a data table inside the same layout system needs a "wide" width.

## 4. CSS Fundamentals (MANDATORY)

### min(100% - pads, value)

- **Safety:** Just like the base container, these modifiers use `min()` to ensure that even "wide" elements don't overflow the viewport on mobile devices.

## 5. CSS Properties Breakdown

- `.l-width--wide`: Expands to `--container-wide` (e.g. 90rem).
- `.l-width--measure`: Constrains to `--measure` (e.g. 65ch), the optimal line length for readability.

## 6. MILOS Implementation Logic

These classes are designed to be composed with `.l-container` or `.l-box`, or used standalone on `p` tags.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-container` (Replace default width) | `l-grid` items (grid controls width) | Inline elements |
| `l-center` (Replace default max) | | |

## 8. Nesting & Collapse Behavior

- **Context:** Works on any block-level element.

## 9. Diagram (MANDATORY)

```text
  .l-width--measure  (65ch ~ 600px)
  ┌──────────────┐
  │ Text         │
  └──────────────┘

  .l-width--wide     (90rem ~ 1440px)
  ┌───────────────────────────┐
  │ Table Data                │
  └───────────────────────────┘
```

## 10. Valid Example

```html
<p class="l-width--measure">
  This paragraph will never get too wide to read comfortably.
</p>
```

## 11. Invalid Example

```html
<span class="l-width--wide">...</span>
```

## 12. Boundaries

- **Does NOT** set margins (margin: auto). It only sets width.

## 13. Engine Decision Log

- **Why separate file?** To allow these utilities to be used outside the container primitive context if needed.
