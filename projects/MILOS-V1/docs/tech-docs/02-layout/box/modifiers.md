# modifiers.css (Box)

## 1. Purpose

This file provides variations for the `.l-box` layout based on size. It allows the standard padding to be tightened or expanded without custom CSS.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts the behavior of the `l-box` primitive.

## 3. Core Concept

- **Mechanism:** Variable Reassignment (`--pad`).
- **Why Chosen:** To allow a box to change size without redeclaring `padding` or `border`. It just turns the local variable "knob".

## 4. CSS Fundamentals (MANDATORY)

### Variable Scope & Cascade

- **Local Scope:** `.l-box--sm` redefines `--pad` *only within* elements matching this selector.
- **Precedence:** Standard class specificity (`0, 1, 0`) beats the `:where` specificity of the base file (`0, 0, 0`), ensuring modifiers always win.

## 5. CSS Properties Breakdown

- `--pad`: The target variable.
- `.l-box--sm`: Sets `--pad` to `var(--space-2)`.
- `.l-box--lg`: Sets `--pad` to `var(--space-6)`.
- `.l-box--none`: Sets `--pad` to `0`.

## 6. MILOS Implementation Logic

We use BEM syntax (`--sm`, `--lg`) but implement them by altering a custom property rather than overwriting styles. This is cleaner and respects the "single token source" principle.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `.l-box` (Required) | Manual padding override (`style="padding: 10px"`) | Non-layout elements |

## 8. Nesting & Collapse Behavior

- **Override:** A modifier applied to a nested box changes that box's padding, independent of the parent.
- **Example:** A `.l-box--lg` (parent) containing a `.l-box--sm` (child) works perfectly.

## 9. Diagram (MANDATORY)

```text
  .l-box--sm            .l-box--lg
  ┌────────┐            ┌──────────────┐
  │  Sm    │            │              │
  │        │            │   Lg         │
  └────────┘            │              │
                        └──────────────┘
```

## 10. Valid Example

```html
<div class="l-box l-box--sm">
  <p>Tight padding.</p>
</div>
```

## 11. Invalid Example

```html
<div class="l-box--sm">
  <!-- Missing base .l-box class means padding property is never set -->
  <!-- Result: No padding at all (unless inherited or set elsewhere) -->
</div>
```

## 12. Boundaries

- **Does NOT** change font-size.
- **Does NOT** change border thickness.

## 13. Engine Decision Log

- **Why explicitly set padding to 0 in --none?** To remove padding completely for scenarios like full-bleed images inside a card.
