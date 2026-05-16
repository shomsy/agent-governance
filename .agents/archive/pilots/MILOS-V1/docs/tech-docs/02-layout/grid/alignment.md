# alignment.css (Grid Modifiers)

## 1. Purpose

This file provides alignment and distribution modifiers for grid items inside their tracks. It mirrors the `cluster/alignment` logic but uses grid-specific properties.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts item placement.

## 3. Core Concept

- **Mechanism:** Grid Alignment (`place-items`, `align-items`, `justify-items`).
- **Why Chosen:** Grid cells often act as "micro-containers". Centering content inside a full-height grid cell is a common requirement.

## 4. CSS Fundamentals (MANDATORY)

### place-items: X Y

- **Logic:** Shorthand for `align-items` (vertical/block) and `justify-items` (horizontal/inline).
- **Example:** `place-items: center` centers items both ways.

### align-items vs justify-items

- **align-items:** Vertical alignment (Start = Top, End = Bottom).
- **justify-items:** Horizontal alignment (Start = Left, End = Right).

### Stretch (Default)

- **Behavior:** `align-items: stretch` makes items fill the entire height of the row. This is why grid cards often look uniform.

## 5. CSS Properties Breakdown

- `.l-grid--place-center`: Centers everything.
- `.l-grid--align-{start,center,end,stretch,baseline}`: Vertical control.
- `.l-grid--justify-{start,center,end,stretch}`: Horizontal control.

## 6. MILOS Implementation Logic

We default to standard grid behavior (stretch). These modifiers are opt-in.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `.l-grid` (Required) | `height: auto` on items (might look weird if not stretched) | |

## 8. Nesting & Collapse Behavior

- **Context:** Alignment applies to direct children.

## 9. Diagram (MANDATORY)

```text
  .l-grid--place-center
┌───────────────────────────────┐
│       (Grid Cell)             │
│                               │
│       [  Item  ]              │ (Centered)
│                               │
└───────────────────────────────┘

  Standard Grid (Stretch)
┌───────────────────────────────┐
│ [ Item fills entire cell ]    │
│ [ height...              ]    │
└───────────────────────────────┘
```

## 10. Valid Example

```html
<div class="l-grid l-grid--cols-3 l-grid--align-start">
  <div>Small</div>
  <div>Tall (Defines row height)</div>
  <div>Small (Top aligned)</div>
</div>
```

## 11. Invalid Example

```html
<div class="l-grid--align-center">
  <!-- Missing base -->
</div>
```

## 12. Boundaries

- **Does NOT** change track sizes (use structure modifiers).

## 13. Engine Decision Log

- **Why place-center?** Common for "empty state" messages inside a grid area.
