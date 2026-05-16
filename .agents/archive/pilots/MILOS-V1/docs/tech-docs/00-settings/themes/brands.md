# brands.css

## 1. Purpose

This file establishes the brand-specific DNA of the design system. It overrides global defaults for container widths, padding, and corner radii based on the user's selected brand context.

## 2. Architectural Layer

**Layer: SETTINGS**
It provides the "configuration" values that drive the layout engine.

## 3. Core Concept

- **Mechanism:** CSS Custom Properties (Variables) scoped to attribute selectors on the root element.
- **Why Chosen:** Allows instant, client-side theme switching without reloading CSS or using JavaScript to compute styles.
- **Alternatives Considered:** SCSS variables (rejected because they are static at build time) or separate stylesheets (rejected because they require network requests).

## 4. CSS Fundamentals (MANDATORY)

### :root Pseudo-class

- **What it is:** Selects the highest-level parent in the DOM tree (usually `<html>`).
- **Specificity:** Low `(0, 1, 0)` but higher than `html` tag selector `(0, 0, 1)`.
- **Cascade:** Variables defined here are inherited by every element on the page.

### Attribute Selectors `[data-brand="..."]`

- **What it is:** Selects an element based on the presence and value of an attribute.
- **Specificity:** Adds `(0, 1, 0)` to the selector weight. Combined with `:root`, the total specificity is `(0, 2, 0)`.
- **Behavior:** This allows multiple brands to coexist in the CSS, activated by simply toggling the HTML attribute.

### clamp(min, val, max)

- **What it is:** A mathematical function that clamps a value between an upper and lower bound.
- **How it works:** `clamp(1rem, 2vw, 2rem)` means "Use 2% of viewport width, but never less than 1rem and never more than 2rem."
- **Evaluation:** Computed at layout time, responsive to viewport changes.

## 5. CSS Properties Breakdown

This file strictly defines **Custom Properties** (`--*`). It does not use standard styling properties.

- `--container-max`: Defines the maximum width of the standard layout container.
- `--container-wide`: Defines the maximum width of the "wide" container variant.
- `--container-pad`: Defines the horizontal padding (gutter) of the page container.
- `--radius-md`: Defines the standard border-radius for cards and boxes.
- `--min-card`: Defines the minimum width for a card component before it wraps.

## 6. MILOS Implementation Logic

MILOS uses a "data-attribute driven" theming system. Instead of loading different CSS files for different clients, we load one CSS file containing all brand definitions, and activate them via `data-brand` on the `<html>` tag.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-container` (consumes max/pad) | Hardcoded pixel values | Inline styles overriding vars |
| `l-box` (consumes radius) | | |
| `l-grid` (consumes min-card) | | |

## 8. Nesting & Collapse Behavior

- **Scoping:** Use on `:root` affects the entire page.
- **Nesting:** Theoretically, you could use `data-brand` on a `div` to create a "brand island", but this file targets `:root`, identifying it as a global switch.

## 9. Diagram (MANDATORY)

```text
┌───────────────────────────────┐
│ :root [data-brand="beta"]     │
│  (--radius-md: 0.625rem)      │
│               │               │
│               ▼               │
│      ┌─────────────────┐      │
│      │ .l-box          │      │
│      │ radius: 0.625rem│      │
│      └─────────────────┘      │
└───────────────────────────────┘
```

## 10. Valid Example

```html
<!DOCTYPE html>
<html lang="en" data-brand="acme">
  <head>...</head>
  <body>
    <!-- Entire page uses Acme tokens -->
  </body>
</html>
```

## 11. Invalid Example

```html
<!-- Wrong: data-brand is expected on root, not body, due to :root selector -->
<body data-brand="acme">
  ...
</body>
```

## 12. Boundaries

- **Does NOT** define colors (see `color-scheme.css`).
- **Does NOT** define typography (see `typography.css` if it exists).
- **Does NOT** apply styles directly to elements.

## 13. Engine Decision Log

- **Why Attribute Selectors?** Classes on `<html>` can get messy (`class="no-js home-page dark-mode"`). Data attributes separate concerns: `data-theme`, `data-brand`.
- **Why clamp()?** Fluid typography and spacing is superior to breakpoint-based stepping for basic container padding.
