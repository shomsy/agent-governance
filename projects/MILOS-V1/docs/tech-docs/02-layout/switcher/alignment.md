# alignment.css (Switcher Modifiers)

## 1. Purpose

This file provides cross-axis alignment modifiers for the Switcher. By default, items stretch to fill the height, but you can center them vertically.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts cross-axis placement.

## 3. Core Concept

- **Mechanism:** Flex Alignment (`align-items`, `justify-content`).
- **Why Chosen:** Semantic modifiers like `align-center` are clearer.

## 4. CSS Fundamentals (MANDATORY)

### align-items

- **Direction:** Vertical for flex row!

### justify-content

- **Direction:** Horizontal for flex row!

## 5. CSS Properties Breakdown

- `.l-switcher--align-center`: Centers items vertically.
- `.l-switcher--justify-center`: Centers items horizontally.

## 6. MILOS Implementation Logic

We align these modifiers with standard flex terminology.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `.l-switcher` (Required) | | |

## 8. Nesting & Collapse Behavior

- **Context:** Child scope.

## 9. Diagram (MANDATORY)

```text
  .l-switcher--align-center
┌───────────────────────────────┐
│ [ Item 1 ]                    │
│                               │
│ [ Item 2 (Longer) ]           │
└───────────────────────────────┘
```

## 10. Valid Example

```html
<div class="l-switcher l-switcher--align-center">
  <div>Item 1</div>
  <div>Item 2</div>
</div>
```

## 11. Invalid Example

```html
<div class="l-switcher--align-center">
  <!-- Missing base -->
</div>
```

## 12. Boundaries

- **Does NOT** change gap. Use `gap.css` modifiers.

## 13. Engine Decision Log

- **Why minimal set?** Switcher is usually for 50/50 layouts.
