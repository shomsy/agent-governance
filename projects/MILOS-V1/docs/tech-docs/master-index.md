# styles/index.css (The Orchestrator)

## 1. Purpose

This is the master entry point of the MILOS CSS engine. It defines the architectural layers using CSS Cascade Layers (`@layer`) and imports all components in the specific order required for a predictable cascade.

## 2. Architectural Layer

### Level: ORCHESTRATOR

- Defines layer precedence.
- Manages global bundle composition.

## 3. Core Concept

- **Mechanism:** `@layer` Statements + `@import`.
- **Why Chosen:** Cascade Layers solve the "specificity war" once and for all. By defining layers at the top of the file, we ensure that a utility class (`07-utilities`) will always override a layout primitive (`02-layout`), even if its selector is less specific.

## 4. CSS Fundamentals (MANDATORY)

### @layer precedence

- **Logic:** The order of the layers in the initial `@layer` statement determines their precedence.
- **MILOS Order:** `settings` < `foundation` < `layout` < `components` < `utilities`.
- **Result:** `utilities` has the highest priority.

### @import with layers

- **Syntax:** `@import url(...) layer(name)`.
- **Benefit:** Assigns imported styles to a specific layer, ensuring they don't leak into the global scope in an uncontrolled manner.

## 5. CSS Properties Breakdown

- **Line 6:** `@layer settings, foundation, layout, components, utilities;`
  - This is the single most important line in the engine. It locks the cascade order.

## 6. MILOS Implementation Logic

The engine is split into 8 logical sections (00 to 07). `index.css` acts as the "Glue" that binds them.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Modern Browsers | Multi-file bundles without Layer support (fallback required) | Legacy IE-era stylesheets |

## 8. Nesting & Collapse Behavior

- **Context:** Global application scale.

## 9. Diagram (MANDATORY)

```text
  index.css (Root)
  ├── 00-settings   (Top of Cascade)
  ├── 01-foundation
  ├── 02-layout
  ├── 03-runtime
  ├── 04-elements
  ├── 05-scenarios
  ├── 06-components (Reserved)
  └── 07-utilities  (Bottom of Cascade / Highest Priority)
```

## 10. Valid Example

```html
<!-- In your HTML -->
<link rel="stylesheet" href="/styles/index.css">
```

## 11. Invalid Example

```css
/* Importing a file outside of index.css can break the defined cascade layers */
@import url("my-bad-style.css"); /* This will be in the unlayered scope, which might override layers unexpectedly */
```

## 12. Boundaries

- **Does NOT** contain any actual CSS rules, only imports and layer definitions.

## 13. Engine Decision Log

- **Why @layer?** Because it allows us to use low specificity classes (`.l-stack`) while still allowing utility overrides (`.u-hide`), avoiding the need for `!important` in most cases.
