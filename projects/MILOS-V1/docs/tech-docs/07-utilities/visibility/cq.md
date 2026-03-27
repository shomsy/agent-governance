# cq.css (Visibility)

## 1. Purpose

This file provides responsive visibility utilities based on Container Queries (CQ). It allows showing/hiding elements depending on the width of their *container*, not the viewport.

## 2. Architectural Layer

**Layer: UTILITIES**
It manages contextual visibility.

## 3. Core Concept

- **Mechanism:** `@container` Queries.
- **Why Chosen:** MILOS is a component-first system. A card shouldn't care about the browser width; it should care about the slot it lives in.

## 4. CSS Fundamentals (MANDATORY)

### @container (max-width: N)

- **Logic:** Hides or Shows elements when the container is *smaller* than N.
- **Thresholds:** Matches `tokens/cq.css` (`narrow: 40rem`, `medium: 60rem`, `wide: 72rem`).

### @container (min-width: N)

- **Logic:** Hides or Shows elements when the container is *larger* than N.

## 5. CSS Properties Breakdown

- `.u-hide--cq-narrow`: Hides if container <= 40rem.
- `.u-show--cq-narrow`: Shows if container <= 40rem.
- `.u-hide--cq-wide`: Hides if container >= 72rem.
- `.u-show--cq-wide`: Shows if container >= 72rem.

## 6. MILOS Implementation Logic

We provide both hide/show variants to support "Mobile First" (default visible, hide on narrow) and "Desktop First" (default hidden, show on wide) logic within containers.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-box`, `l-card` (Direct children of containers) | Missing `container-type` on parent (query fails, never triggers) | |

## 8. Nesting & Collapse Behavior

- **Context:** Requires `container-type: inline-size` on an ancestor.

## 9. Diagram (MANDATORY)

```text
  Container (Width: 30rem) -> "Narrow"
┌───────────────────────────────┐
│ [ .u-hide--cq-narrow ]        │ -> Hidden
│ [ .u-show--cq-narrow ]        │ -> Visible
└───────────────────────────────┘

  Container (Width: 50rem) -> "Medium"
┌──────────────────────────────────────────┐
│ [ .u-hide--cq-narrow ]                   │ -> Visible
│ [ .u-show--cq-narrow ]                   │ -> Hidden
└──────────────────────────────────────────┘
```

## 10. Valid Example

```html
<div class="l-card" style="container-type: inline-size">
  <img class="u-hide--cq-narrow" src="big-hero.jpg">
  <img class="u-show--cq-narrow" src="small-thumb.jpg">
</div>
```

## 11. Invalid Example

```html
<div class="u-hide--cq-narrow">
  <!-- Parent has no container-type defined -->
</div>
```

## 12. Boundaries

- **Does NOT** respond to viewport width directly (indirectly yes, if container is full width).

## 13. Engine Decision Log

- **Why CQ?** It's the future of modular design.
