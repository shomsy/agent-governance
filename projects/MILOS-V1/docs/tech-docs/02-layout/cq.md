# cq.css

## 1. Purpose

This file activates Container Queries on an element. It marks the element as a "queryable context," allowing its children to change their layout based on its width rather than the viewport width.

## 2. Architectural Layer

**Layer: LAYOUT**
It defines context boundaries.

## 3. Core Concept

- **Mechanism:** Container Queries (`@container`).
- **Why Chosen:** Because responsive components (like a card) don't know where they will be placed. They might be in a sidebar (narrow) or main content (wide). Viewport queries fail here.

## 4. CSS Fundamentals (MANDATORY)

### container-type: inline-size

- **Behavior:** The element tracks its own inline (horizontal) size.
- **Children:** Can use `@container (min-width: ...)` to query this size.
- **Layout Impact:** Turning on container queries changes layout containment logic similar to `overflow: hidden` (can clip absolute children if not careful? No, usually fine, but creates a containing block).

### container-name: layout

- **Behavior:** Names the container so nested queries can be specific (`@container layout (min-width: ...)`).
- **Why:** Prevents accidental querying of a distant ancestor if multiple containers are nested.

## 5. CSS Properties Breakdown

- `.l-cq`: Simply applies `container-type` and `container-name`.

## 6. MILOS Implementation Logic

We standardized the name `layout` to avoid confusion. Developers should always query `@container layout (...)` when building components.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-sidebar` (main/aside) | `display: inline` (container needs dimensions) | `l-grid` root (grid tracks handle sizing) |
| `l-card` (as wrapper) | | |

## 8. Nesting & Collapse Behavior

- **Context:** Nearest ancestor with `container-type` wins unless named specifically.

## 9. Diagram (MANDATORY)

```text
  .l-cq (e.g. 300px wide)
┌───────────────────────┐
│ @container (max: 400) │
│ ┌───────────────────┐ │
│ │  Child Layout A   │ │
│ └───────────────────┘ │
└───────────────────────┘

  .l-cq (e.g. 800px wide)
┌─────────────────────────────────────┐
│ @container (min: 400)               │
│ ┌─────────────────────────────────┐ │
│ │  Child Layout B (Expanded)      │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## 10. Valid Example

```html
<div class="l-cq">
  <article class="my-card">
    <!-- Transforms based on .l-cq width -->
  </article>
</div>
```

## 11. Invalid Example

```css
/* Querying viewport inside a component meant for reuse */
@media (min-width: 500px) { ... }
```

## 12. Boundaries

- **Does NOT** contain styles itself.
- **Does NOT** provide the query logic (CSS in component files does that).

## 13. Engine Decision Log

- **Why separate class?** Performance. Browser engines optimize layout calculations if containment is explicit. We don't put it on everything by default.
