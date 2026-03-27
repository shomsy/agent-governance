# alignment.css (Stack Modifiers)

## 1. Purpose

This file provides cross-axis alignment modifiers for the vertical stack. By default, items stretch to fill the width, but you can change this behavior (e.g. left-aligned list).

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts cross-axis placement.

## 3. Core Concept

- **Mechanism:** Flex Alignment (`align-items`).
- **Why Chosen:** Semantic modifiers like `align-start` are clearer than `class="items-start"`.

## 4. CSS Fundamentals (MANDATORY)

### align-items

- **Direction:** Vertical for flex row, but **Horizontal** for flex column!
- **Default:** `stretch` (makes inputs full width).
- **Options:** `flex-start` (left), `center`, `flex-end` (right), `baseline`.

### justify-content (Main Axis)

- **Direction:** Vertical for stacks.
- **Example:** `center` (vertical centering if container has height).

## 5. CSS Properties Breakdown

- `.l-stack--align-{start,center,end,stretch,baseline}`.
- `.l-stack--justify-center`.

## 6. MILOS Implementation Logic

We align these modifiers with standard flex terminology.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `.l-stack` (Required) | `width: 100%` on child (overrides flex alignment visuals) | |

## 8. Nesting & Collapse Behavior

- **Context:** Child scope.

## 9. Diagram (MANDATORY)

```text
  .l-stack--align-start
┌───────────────────────────────┐
│ [ Item 1 ]                    │
│                               │
│ [ Item 2 (Longer) ]           │
└───────────────────────────────┘

  Standard (Stretch)
┌───────────────────────────────┐
│ [ Item 1 (Stretched)        ] │
│                               │
│ [ Item 2 (Stretched)        ] │
└───────────────────────────────┘
```

## 10. Valid Example

```html
<ul class="l-stack l-stack--align-start">
  <li>Left aligned item</li>
  <li>Another item</li>
</ul>
```

## 11. Invalid Example

```html
<div class="l-stack--align-start">
  <!-- Missing base -->
</div>
```

## 12. Boundaries

- **Does NOT** change gap. Use `gap.css` modifiers.

## 13. Engine Decision Log

- **Why baseline?** Rare, but needed for specific icon + text stacking scenarios.
