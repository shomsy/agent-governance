# alignment.css (Cluster Modifiers)

## 1. Purpose

This file provides alignment and distribution modifiers for horizontal clusters. It allows you to transform a tightly packed row into a spread-out toolbar or align items differently on the cross-axis (top/bottom).

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It tweaks the flexbox alignment props.

## 3. Core Concept

- **Mechanism:** Flex Alignment (`justify-content`, `align-items`).
- **Why Chosen:** To support common patterns like "Split Headers" (Left logo, Right nav) or "Top-aligned cards".

## 4. CSS Fundamentals (MANDATORY)

### justify-content: space-between

- **Behavior:** Pushes the first item to the start and the last item to the end, distributing remaining space evenly between items.
- **Wrap Behavior:** If items wrap, the last row might look sparse (one item left, one right).

### align-items: baseline

- **Behavior:** Aligns items so their text baselines match, regardless of font size or padding. Crucial for form labels + inputs.

## 5. CSS Properties Breakdown

- `.l-cluster--align-{start,center,end,stretch,baseline}`: Controls vertical alignment.
- `.l-cluster--justify-center`: Centers items horizontally.
- `.l-cluster--split`: Sets `justify-content: space-between`.
- `.l-cluster--no-wrap`: Forces items onto a single line (scrolling or shrinking).

## 6. MILOS Implementation Logic

We simplify "justify-content: space-between" to just `split`. Why? Because "split" describes the intent perfectly: split the content to the edges.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `.l-cluster` (Required) | `flex-wrap: nowrap` (if content overflows) | |

## 8. Nesting & Collapse Behavior

- **Context:** Alignment applies to direct children only.

## 9. Diagram (MANDATORY)

```text
  .l-cluster--split
┌───────────────────────────────┐
│ [Logo]                 [Menu] │
└───────────────────────────────┘

  .l-cluster--justify-center
┌───────────────────────────────┐
│      [Icon] [Icon] [Icon]     │
└───────────────────────────────┘
```

## 10. Valid Example

```html
<nav class="l-cluster l-cluster--split">
  <h1>Brand</h1>
  <ul>Link 1 Link 2</ul>
</nav>
```

## 11. Invalid Example

```html
<div class="l-cluster--split">
  <!-- Missing base class means display: flex never triggers -->
</div>
```

## 12. Boundaries

- **Does NOT** define column widths (use Grid).

## 13. Engine Decision Log

- **Why not utility classes?** `flex-justify-between` is generic. `.l-cluster--split` is semantic to the cluster primitive.
