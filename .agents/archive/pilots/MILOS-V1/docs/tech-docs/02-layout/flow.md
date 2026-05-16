# flow.css

## 1. Purpose

This file implements the "Flow" primitive (also known as the "Stack" or "Lobotomized Owl" pattern). Its job is to add vertical spacing between flow content (paragraphs, headings, lists) without adding unwanted margins to the first or last elements.

## 2. Architectural Layer

**Layer: LAYOUT**
It manages vertical rhythm (typography).

## 3. Core Concept

- **Mechanism:** Adjacent Sibling Selector (`* + *`).
- **Why Chosen:** `margin-top` on every element except the first one is the most robust way to space content, especially when empty elements might be present (though `:empty` selector helps, sibling selector is cleaner).
- **Alternatives Considered:** `gap` (Flexbox/Grid). Rejected for *text flow* because `display: flex` changes block formatting context (margins don't collapse naturally inside flex). We want standard block behavior for articles.

## 4. CSS Fundamentals (MANDATORY)

### The `* + *` Selector

- **Logic:** Selects any element that immediately follows another element.
- **Result:** The **first child** is never selected (it has no predecessor).
- **Loop:** `h1 + p`, `p + p`, `p + ul`. All get margin-top.

### margin-block-start

- **Behavior:** Logical property for `margin-top`. Adapts to writing mode.

## 5. CSS Properties Breakdown

- `.l-flow`: The container.
- `--gap`: Defaults to `--layout-gap` (or `--flow-space` if provided).
- `margin-block-start: var(--gap)`: Applied to siblings.

## 6. MILOS Implementation Logic

This is the default wrapper for any rich text content (cms-body, article-body). It ensures consistent spacing regardless of what HTML tags the editor throws in.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-container` | `display: flex` (margins behave differently) | Grid layouts (use gap) |
| Typographic Elements | | |

## 8. Nesting & Collapse Behavior

- **Reflow:** Margins collapse between nested flows if not cleared.
- **Override:** Specific elements can set `margin-top: 0` via utility classes if needed, but `.l-flow` resets general rhythm.

## 9. Diagram (MANDATORY)

```text
  .l-flow
┌───────────────────────────────┐
│  <h1>Title</h1>               │
│                               │
│  (margin-top: --gap)          │
│  <p>Paragraph 1...</p>        │
│                               │
│  (margin-top: --gap)          │
│  <p>Paragraph 2...</p>        │
└───────────────────────────────┘
```

## 10. Valid Example

```html
<article class="l-flow">
  <p>One</p>
  <p>Two</p>
</article>
```

## 11. Invalid Example

```html
<div class="l-flow" style="display: flex">
  <!-- Flex ignores margin collapsing rules sometimes, gap is preferred -->
</div>
```

## 12. Boundaries

- **Does NOT** assume content is text. Can be images, divs.
- **Does NOT** set font styles.

## 13. Engine Decision Log

- **Why margin instead of gap?** To allow margin collapsing between paragraphs and headings if customized. And to avoid `display: flex` side effects on text wrapping/floats.
