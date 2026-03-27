# min-presets.css (Switcher)

## 1. Purpose

This file provides preset breakdown thresholds for the Switcher. It saves you from declaring custom variables.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts the threshold.

## 3. Core Concept

- **Mechanism:** Variable Reassignment (`--switch-min`).
- **Why Chosen:** Standardization. Designers speak in these thresholds.

## 4. CSS Fundamentals (MANDATORY)

### Variable Override

- **Logic:** The modifiers update `--switch-min` which is consumed by `.l-switcher` as `flex-basis`.

## 5. CSS Properties Breakdown

- `.l-switcher--min-sm`: Small threshold (`--switcher-min-sm`).
- `.l-switcher--min-md`: Medium (`--switcher-min-md`).
- `.l-switcher--min-lg`: Large (`--switcher-min-lg`).
- `.l-switcher--min-xl`: Extra Large (`--switcher-min-xl`).

## 6. MILOS Implementation Logic

We align these modifiers with standard spacing tokens (`sm`, `md`, `lg`) for predictability.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `.l-switcher` | Manually set --switch-min (overrides var) | |

## 8. Nesting & Collapse Behavior

- **Context:** Local scope.

## 9. Diagram (MANDATORY)

```text
  .l-switcher--min-sm
┌───────────────────────────────┐
│ (Threshold: 10rem)            │
│ Item 1 | Item 2 | Item 3      │
└───────────────────────────────┘
```

## 10. Valid Example

```html
<div class="l-switcher l-switcher--min-md">
  <div>Col 1</div>
  <div>Col 2</div>
</div>
```

## 11. Invalid Example

```html
<div class="l-switcher--min-md">
  <!-- Missing base -->
</div>
```

## 12. Boundaries

- **Does NOT** affect gap.

## 13. Engine Decision Log

- **Why presets?** Consistency. We don't want `style="--switch-min: 343px"`.
