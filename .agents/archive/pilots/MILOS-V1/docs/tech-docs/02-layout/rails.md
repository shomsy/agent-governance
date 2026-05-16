# rails.css

## 1. Purpose

This is the main entry point for the Rails layout primitive. It imports the complex grid setup and the specific placement modifiers.

## 2. Architectural Layer

**Layer: LAYOUT**
It bundles the full-bleed grid system.

## 3. Core Concept

- **Mechanism:** `@import` Aggregation.
- **Why Chosen:** To allow consumers to get the full logic with one line.

## 4. CSS Fundamentals (MANDATORY)

### @import

- **Behavior:** Ensures tracks are defined before use.

## 5. CSS Properties Breakdown

None.

## 6. MILOS Implementation Logic

We split `base` (tracks) and `spans` (usage) because while `base` is structural, `spans` are utility classes used directly in HTML.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Build Tools | Circular imports | |

## 8. Nesting & Collapse Behavior

- **@layer layout:** All styles contained.

## 9. Diagram (MANDATORY)

```text
rails.css
├── base.css    (.l-rails)
└── spans.css   (.l-rail--wide)
```

## 10. Valid Example

```css
@import url("./02-layout/rails.css");
```

## 11. Invalid Example

```css
/* Importing spans without context breaks everything that relies on named grid lines */
@import url("./02-layout/rails/spans.css");
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why named lines?** Named areas are more semantic than `grid-column: 1 / -1`.
