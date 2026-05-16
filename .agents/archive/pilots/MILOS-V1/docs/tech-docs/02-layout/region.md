# region.css

## 1. Purpose

This is the main entry point for the Region layout primitive. It imports the base padding logic and the size modifiers.

## 2. Architectural Layer

**Layer: LAYOUT**
It bundles the sectioning primitive.

## 3. Core Concept

- **Mechanism:** `@import` Aggregation.
- **Why Chosen:** To allow consumers to get the full `l-region` system with a single line.

## 4. CSS Fundamentals (MANDATORY)

### @import

- **Behavior:** Loads styles in order.

## 5. CSS Properties Breakdown

None.

## 6. MILOS Implementation Logic

We split `base` and `modifiers` because base style is mandatory for structure, while modifiers are optional.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Build Tools | Circular imports | |

## 8. Nesting & Collapse Behavior

- **@layer layout:** All region styles are contained.

## 9. Diagram (MANDATORY)

```text
region.css
├── base.css       (.l-region)
└── modifiers.css  (.l-region--sm)
```

## 10. Valid Example

```css
@import url("./02-layout/region.css");
```

## 11. Invalid Example

```css
/* Importing modifiers without base */
@import url("./02-layout/region/modifiers.css");
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why split?** Clear separation of core purpose vs sizing.
