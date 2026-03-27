# grid.css

## 1. Purpose

This is the main entry point for the Grid layout primitive. It imports the entire Grid System: base activation, track structure logic, alignment modifiers, span utilities, safety clamps, and responsive collapse logic.

## 2. Architectural Layer

**Layer: LAYOUT**
It bundles the complex 2D layout engine.

## 3. Core Concept

- **Mechanism:** `@import` Aggregation.
- **Why Chosen:** Grid logic is split across 6 files to keep each concern (Spanning vs Tracking vs Collapsing) isolated and testable.

## 4. CSS Fundamentals (MANDATORY)

### @import Order

- **Logic:**
  1. `base.css`: Activates grid.
  2. `alignment.css`: Adds default alignments.
  3. `structure.css`: Creates tracks (`cols-3`).
  4. `spans.css`: Allows items to break structure (`span-2`).
  5. `span-clamp.css`: Fixes broken spans if structure is too small.
  6. `collapse.css`: Overrides everything if container is tiny (forces stack).

## 5. CSS Properties Breakdown

None.

## 6. MILOS Implementation Logic

This modular approach allows advanced users to import only parts (e.g. `base` + `structure`) if they don't need the span helper classes, though `grid.css` is the recommended default.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Build Tools | Circular imports | |

## 8. Nesting & Collapse Behavior

- **@layer layout:** All grid styles are contained.

## 9. Diagram (MANDATORY)

```text
grid.css
├── base.css        (Activation)
├── alignment.css   (Placement)
├── structure.css   (Tracks)
├── spans.css       (Items)
├── span-clamp.css  (Safety)
└── collapse.css    (Responsive)
```

## 10. Valid Example

```css
@import url("./02-layout/grid.css");
```

## 11. Invalid Example

```css
/* Importing structure before base might fail in some preprocessors? */
/* CSS import order matters for cascade! Collapse MUST come last to override structure. */
@import url("./02-layout/grid/collapse.css");
@import url("./02-layout/grid/structure.css");
/* Result: Structure overrides collapse! Mobile layout breaks. */
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why so complex?** Grid is powerful but fragile. Splitting safety logic (`span-clamp`) from core logic (`structure`) makes the system robust.
