# ratios.css

## 1. Purpose

This file provides presets for common geometric aspect ratios. It saves you from calculating the math for 16:9 (1.7777) etc.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts the geometry.

## 3. Core Concept

- **Mechanism:** Variable Reassignment (`--frame`).
- **Why Chosen:** Standardization. Designers speak in these ratios.

## 4. CSS Fundamentals (MANDATORY)

### aspect-ratio: calc(X / Y)

- **Support:** Modern browsers support division like `calc(16 / 9)`. No need for precalced decimals.

## 5. CSS Properties Breakdown

- `.l-frame--16-9`: Standard widescreen.
- `.l-frame--4-3`: Classic TV / iPad.
- `.l-frame--1-1`: Square (default).
- `.l-frame--21-9`: Ultrawide / Cinema.

## 6. MILOS Implementation Logic

We scope these as modifiers. You can compose them with fit modifiers.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `.l-frame` | `height: fixed` (if set, aspect ratio is ignored) | |

## 8. Nesting & Collapse Behavior

- **Context:** Local scope.

## 9. Diagram (MANDATORY)

```text
  1:1                 16:9
┌─────┐             ┌────────────┐
│Sq.  │             │Widescreen  │
└─────┘             └────────────┘
```

## 10. Valid Example

```html
<div class="l-frame l-frame--16-9">
  <iframe src="..."></iframe>
</div>
```

## 11. Invalid Example

```html
<div class="l-frame--16-9">
  <!-- Missing base -->
</div>
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why separate file?** Keeps `base.css` tiny. Ratio presets are optional sugar.
