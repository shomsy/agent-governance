# gap.css

## 1. Purpose

This file provides generic gap modifiers that can be applied to any layout primitive that uses the `--gap` variable (`l-stack`, `l-cluster`, `l-flow`, `l-grid`). It decouples spacing size from the layout mechanism.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts the spacing tokens.

## 3. Core Concept

- **Mechanism:** Variable Reassignment (`--gap`).
- **Why Chosen:** A single set of classes `.l-gap--sm`, `.l-gap--lg` works across all primitives, reducing CSS bloat.

## 4. CSS Fundamentals (MANDATORY)

### Variable Reassignment

- **Logic:** The primitive defines `gap: var(--gap)`. This modifier redefines `--gap` locally.
- **Cascade:** The nearest definition wins.

## 5. CSS Properties Breakdown

- `.l-gap--0`: Sets `--gap: 0`.
- `.l-gap--{xs,sm,md,lg,xl}`: Sets `--gap` to corresponding token.

## 6. MILOS Implementation Logic

We use BEM syntax. The modifier doesn't know *what* primitive it's modifying. It just says "Here, the gap is small."

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-stack` (sets row-gap) | Hardcoded `gap: 1rem` | Elements without `--gap` usage |
| `l-cluster` (sets gap) | | |
| `l-grid` (sets grid-gap) | | |
| `l-flow` (sets margin-top) | | |

## 8. Nesting & Collapse Behavior

- **Context:** Local scope.

## 9. Diagram (MANDATORY)

```text
  .l-stack.l-gap--sm
┌──────────────┐    ┌──────────────┐
│  Item        │    │  Item        │
│              │    │              │
│  (Tiny Gap)  │    │  (Huge Gap)  │
│              │    │              │
│  Item        │    │  Item        │
└──────────────┘    └──────────────┘
                    .l-stack.l-gap--xl
```

## 10. Valid Example

```html
<div class="l-stack l-gap--lg">...</div>
<div class="l-cluster l-gap--xs">...</div>
```

## 11. Invalid Example

```html
<div class="l-gap--lg">
  <!-- Does nothing on its own unless child uses var(--gap) -->
</div>
```

## 12. Boundaries

- **Does NOT** set usage (doesn't apply the property `gap`).

## 13. Engine Decision Log

- **Why universal modifier?** Consistency. We don't want `l-stack--gap-sm` and `l-cluster--gap-sm` duplicating code.
