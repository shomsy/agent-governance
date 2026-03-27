# sizing.css

## 1. Purpose

This file provides utilities to control how individual items grow, shrink, or size themselves within a flex or grid context.

## 2. Architectural Layer

**Layer: LAYOUT MODIFIER**
It adjusts box geometry at the item level.

## 3. Core Concept

- **Mechanism:** Flex Properties (`flex-grow`, `flex-shrink`).
- **Why Chosen:** Sometimes one item needs to be greedy (`.l-fill`) while others stay small.

## 4. CSS Fundamentals (MANDATORY)

### flex: 1 1 0% (.l-fill)

- **Grow:** Yes.
- **Shrink:** Yes.
- **Basis:** 0%. (Start from nothing, share available space equally).

### flex: 0 1 auto (.l-shrink)

- **Grow:** No. (Only take what you need).
- **Shrink:** Yes. (Allow squashing if space is tight).
- **Basis:** Auto (Content size).

## 5. CSS Properties Breakdown

- `.l-fill`: Expands to fill available space.
- `.l-shrink`: Fits to content, shrinks if needed.
- `.l-fit`: Shrink-wraps content (`fit-content`).
- `.l-width--full`: `width: 100%` (Force full width).
- `.l-height--full`: `height: 100%`.

## 6. MILOS Implementation Logic

These are critical for "App Layouts" (Sidebar fixed, Main fills rest).

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Flex/Grid Items | `display: block` (flex props ignored) | |

## 8. Nesting & Collapse Behavior

- **Context:** Item scope.

## 9. Diagram (MANDATORY)

```text
  Flex Container
┌───────────────────────────────────────┐
│ [Item 1 (.l-shrink)] [Item 2 (.l-fill)]
│ (Small)              (Takes all remaining space)
└───────────────────────────────────────┘
```

## 10. Valid Example

```html
<div class="l-switcher">
  <div class="l-shrink">Sidebar</div>
  <div class="l-fill">Main Content</div>
</div>
```

## 11. Invalid Example

```html
<div class="l-fill">
  <!-- Not inside a flex container, does nothing -->
</div>
```

## 12. Boundaries

- **Does NOT** set min/max sizes.

## 13. Engine Decision Log

- **Why 0% basis?** To ensure equal distribution if multiple `.l-fill` items exist, regardless of content size.
