# elements.css

## 1. Purpose

This file corresponds to **Layer 3 (Elements)** of the ITCSS architecture. It is reserved for unclassed HTML elements (e.g. `h1`, `p`, `blockquote`, `table`).

## 2. Architectural Layer

**Layer: ELEMENTS**
It applies base styles to raw DOM nodes.

## 3. Core Concept

- **Mechanism:** Type Selectors.
- **Why Chosen:** To provide sensible defaults for content that comes from a Markdown parser or CMS where classes might be missing.

## 4. CSS Fundamentals (MANDATORY)

### Cascade Order

- **Context:** Element styles override Generic/Reset styles but are overridden by Objects/Components/Utilities.

## 5. CSS Properties Breakdown

- **Current Status:** Intentionally empty in strict mode. We prefer classes (`.l-flow > h1`) or specific typography components over global tag pollution.

## 6. MILOS Implementation Logic

If you need to style all `<a>` tags or `<table>`s globally, this is where it goes. However, beware of specificity creep.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Markdown Content | Component Isolation (if global styles leak) | |

## 8. Nesting & Collapse Behavior

- **Context:** Global.

## 9. Diagram (MANDATORY)

```text
  global scope
  ├── body
  │   ├── h1 (Styled here)
  │   ├── p (Styled here)
```

## 10. Valid Example

```css
/* elements.css */
h1 { font-family: sans-serif; }
```

## 11. Invalid Example

```css
/* Classes belong in components or objects, not elements layer */
.card { ... }
```

## 12. Boundaries

- **Does NOT** use classes.

## 13. Engine Decision Log

- **Why empty?** To enforce "Opt-in" styling via classes for better maintainability.
