# scenarios.css

## 1. Purpose

This file corresponds to **Layer 4 (Scenarios)**. It is often called "Make Ups" or "Themes" in other systems. It defines specific compositions of primitives for specific *business scenarios*.

## 2. Architectural Layer

**Layer: SCENARIOS (or OBJECTS)**
It applies layout combinations to patterns.

## 3. Core Concept

- **Mechanism:** Composition classes.
- **Why Chosen:** A "Blog Header" is always a `l-cover`, `l-stack`, `l-center`. We can create a `.s-blog-header` that applies these properties compositionally.

## 4. CSS Fundamentals (MANDATORY)

### Composition vs Inheritance

- **Context:** Rather than `@extend`, we prefer explicit classes in HTML. But if a pattern repeats 100 times (like a product card structure), a Scenario class can bundle it.

## 5. CSS Properties Breakdown

- **Current Status:** Intentionally empty. We prefer explicit primitive composition in HTML (`<div class="l-cover l-stack">`) for clarity.

## 6. MILOS Implementation Logic

Use this layer only if the HTML becomes too verbose with primitive classes. It acts as a "shortcut" layer.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Any Primitives | Over-abstraction | |

## 8. Nesting & Collapse Behavior

- **Context:** Component scope.

## 9. Diagram (MANDATORY)

```text
  .s-product-card
    (imports styles of l-stack + l-box + theme)
```

## 10. Valid Example

```css
/* scenarios.css */
.s-hero {
  /* Bundles multiple layers */
  min-height: 80vh; /* cover */
  display: flex;    /* center */
}
```

## 11. Invalid Example

```css
/* Styling a specific button is a Component, not a Scenario */
.btn-primary { ... }
```

## 12. Boundaries

- **Does NOT** contain highly specific UI logic (that's Components).

## 13. Engine Decision Log

- **Why empty?** YAGNI (You Ain't Gonna Need It). Primitives are usually enough.
