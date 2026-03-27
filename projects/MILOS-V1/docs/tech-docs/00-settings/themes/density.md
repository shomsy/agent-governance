# density.css

## 1. Purpose

This file provides density profiles (e.g. `compact`, `comfortable`). It allows the entire interface to "tighten up" or "spread out" without changing the structural CSS, simply by redefining the spacing variables.

## 2. Architectural Layer

**Layer: SETTINGS**
It configures spacing multipliers dynamically.

## 3. Core Concept

- **Mechanism:** Variable Reassignment (Alias Overrides).
- **Why Chosen:** Instead of writing new CSS for "compact mode", we simply alias existing tokens (`--layout-gap`) to smaller values (`--gap-sm`).
- **Alternatives Considered:** Specific utility classes (rejected because it requires modifying HTML across the entire app).

## 4. CSS Fundamentals (MANDATORY)

### Variable Reassignment

- **What it is:** Defining a variable (`--layout-gap`) to point to another variable (`--gap-sm`).
- **Evaluation:** When used, the browser resolves the entire chain (`var(--layout-gap) -> var(--gap-sm) -> 0.5rem`).
- **Cascade:** The new definition applies to all descendants, effectively changing the "meaning" of `--layout-gap` for that subtree.

### :root Attribute Selector `[data-density="..."]`

- **Specificity:** `(0, 2, 0)`.
- **Behavior:** Ensures that density changes are global and consistent.

## 5. CSS Properties Breakdown

This file defines **Semantic Aliases**:

- `--layout-gap`: The default gap used by layout primitives like `l-stack` or `l-cluster`. By changing this, all stacks tighten or loosen.
- `--radius-md`: The standard corner radius. Compact interfaces often prefer sharper corners.
- `--container-pad`: The breathing room at the edge of the page. Compact interfaces use less edge padding.

## 6. MILOS Implementation Logic

We use `data-density="compact"` or `data-density="comfortable"` on the `<html>` element. This is orthogonal to the theme (light/dark) and brand, allowing 3-dimensional customization: `[brand="acme"][theme="dark"][density="compact"]`.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-stack` (via `--gap`) | Hardcoded gaps (e.g. `gap: 1rem`) | |
| `l-cluster` | | |
| `l-box` (via radius) | | |

## 8. Nesting & Collapse Behavior

- **Global:** Applied to root.
- **Local:** Can be applied to a specific component container (`<div data-density="compact">`) to make just a table or sidebar dense while the rest of the page is comfortable.

## 9. Diagram (MANDATORY)

```text
State: [data-density="compact"]

  --layout-gap -----> --gap-sm (0.5rem)
       │
       ▼
  ┌──────────┐
  │  stack   │ gap: 0.5rem
  │          │
  │  stack   │
  └──────────┘

State: [data-density="comfortable"]

  --layout-gap -----> --gap-lg (2rem)
       │
       ▼
  ┌──────────┐
  │  stack   │ gap: 2rem
  │          │
  │          │
  │          │
  │  stack   │
  └──────────┘
```

## 10. Valid Example

```html
<html data-density="compact">
  <!-- All stacks use smaller gaps -->
</html>
```

## 11. Invalid Example

```css
/* Avoid hardcoding values in density file */
:root[data-density="compact"] {
  --layout-gap: 8px; /* Bad: Should reference --gap-sm token */
}
```

## 12. Boundaries

- **Does NOT** define the token values themselves (`--gap-sm` is defined in `tokens/space.css`).
- **Does NOT** change structural behavior (it just changes numbers).

## 13. Engine Decision Log

- **Why Alias Variables?** It keeps the system DRY. If we change `--gap-sm` globally, the compact mode updates automatically.
