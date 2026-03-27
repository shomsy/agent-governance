# center.css

## 1. Purpose

This file provides the canonical way to horizontally center a block-level element within its parent. It is the workhorse for main content columns, cards, and modal dialogs.

## 2. Architectural Layer

**Layer: LAYOUT**
It manages horizontal distribution and constraints.

## 3. Core Concept

- **Mechanism:** Automatic Margins (`margin: auto`).
- **Why Chosen:** It is the robust, standard CSS way to center block elements without needing flex/grid on the parent container.

## 4. CSS Fundamentals (MANDATORY)

### margin-inline: auto

- **What it is:** Instructs the browser to take all available horizontal space in the containing block and distribute it equally to the left and right margins.
- **Requirement:** The element must have a defined width (or `max-width`) smaller than its parent to show the effect.
- **Direction:** Adapts to reading direction (LTR/RTL) automatically because it uses logical property `inline`.

### box-sizing: content-box (Wait, why?)

- **Override:** The global reset sets `border-box`. This primitive reverts to `content-box`.
- **Reason:** Ensuring that if you add `padding` to a centered element with a max-width, the content area remains consistent (padding extends outwards). This behavior is debatable but chosen here for specific intrinsic sizing reasons.

## 5. CSS Properties Breakdown

- `--center-max`: Defaults to `--container-max`. Controls the maximum width.
- `max-inline-size`: Constraints the width. If content is smaller, it shrinks (intrinsic). If larger, it caps.
- `box-sizing`: Explicitly `content-box`.

## 6. MILOS Implementation Logic

We scope `--center-max` locally so you can override it per instance (`style="--center-max: 60ch"`). This makes `l-center` extremely flexible for tailored readable columns.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-stack` (vertical) | `float` (margins fail) | Inline elements (`span`) |
| `l-box` (padding) | `position: absolute` (without left/right set) | |

## 8. Nesting & Collapse Behavior

- **Nesting:** Centered elements can be nested. A narrow column inside a wide column.
- **Margins:** Adjoining vertical margins will collapse standardly.

## 9. Diagram (MANDATORY)

```text
  Parent Container
┌───────────────────────────────┐
│       (margin: auto)          │
│      ┌───────────────┐        │
│      │   .l-center   │        │
│      │               │        │
│      └───────────────┘        │
│       (margin: auto)          │
└───────────────────────────────┘
```

## 10. Valid Example

```html
<article class="l-center" style="--center-max: 65ch">
  <p>Readable text column centered on the page.</p>
</article>
```

## 11. Invalid Example

```html
<span class="l-center">
  <!-- Spans are inline; width/margin properties apply differently or not at all -->
</span>
```

## 12. Boundaries

- **Does NOT** center content *vertically* (use `l-cover` or grid for that).
- **Does NOT** center text *inside* the block (use `text-align: center`).

## 13. Engine Decision Log

- **Why variable for max-width?** To allow rapid prototyping of measure (line length) without writing new CSS classes.
