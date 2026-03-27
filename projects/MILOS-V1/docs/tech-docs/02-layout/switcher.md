# switcher.css

## 1. Purpose

This is the main entry point for the Switcher layout primitive. It imports the base flex-wrap logic, alignment modifiers, and threshold presets.

## 2. Architectural Layer

**Layer: LAYOUT**
It bundles the `l-switcher` component.

## 3. Core Concept

- **Mechanism:** `@import` Aggregation.
- **Why Chosen:** To allow consumers to get the full `l-switcher` feature set with a single line.

## 4. CSS Fundamentals (MANDATORY)

### @import

- **Behavior:** Loads styles in order.

## 5. CSS Properties Breakdown

None.

## 6. MILOS Implementation Logic

We split `min-presets` effectively to isolate configuration.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Build Tools | Circular imports | |

## 8. Nesting & Collapse Behavior

- **@layer layout:** All switcher styles are contained.

## 9. Diagram (MANDATORY)

```text
switcher.css
├── base.css         (.l-switcher)
├── alignment.css    (.l-switcher--)
└── min-presets.css  (.l-switcher--min-)
```

## 10. Valid Example

```css
@import url("./02-layout/switcher.css");
```

## 11. Invalid Example

```css
/* Importing modifiers without base */
@import url("./02-layout/switcher/alignment.css");
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why split?** Modularity.
