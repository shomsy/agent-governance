# color-scheme.css

## 1. Purpose

This file explicitly informs the browser (User Agent) which color scheme the page is using (light or dark). This is critical for native UI elements like scrollbars, form inputs, and system default colors.

## 2. Architectural Layer

**Layer: SETTINGS**
It configures the browser's rendering context before any layout or painting occurs.

## 3. Core Concept

- **Mechanism:** The standard CSS `color-scheme` property.
- **Why Chosen:** It ensures native OS integration (e.g. dark scrollbars on Windows/Mac) without hacking custom scrollbar styles.
- **Alternatives Considered:** Relying purely on CSS variables for colors (rejected because form inputs and scrollbars would remain white in dark mode).

## 4. CSS Fundamentals (MANDATORY)

### color-scheme Property

- **What it is:** A property that indicates which operating system color scheme an element is comfortable being rendered with.
- **Values:** `light`, `dark`, `light dark`, `normal`.
- **Impact:**
  - Changes the default `canvas` background color (white vs black).
  - Changes the default text color (black vs white).
  - Changes form controls (checkboxes, radios, selects) to match the theme.
  - Changes the scrollbar track and thumb color.
- **Cascade:** Inherited. Setting it on `:root` applies it to the entire document.

### :root Attribute Selector `[data-theme="..."]`

- **Specificity:** `(0, 2, 0)` (Class + Attribute on Root).
- **Behavior:** Explicitly sets the scheme based on the attribute, overriding the user's OS preference if they select a manual toggle.

## 5. CSS Properties Breakdown

- `color-scheme`: Direct instruction to the browser engine about the desired rendering mode for system UI.

## 6. MILOS Implementation Logic

We use `data-theme="dark"` or `data-theme="light"` on the `<html>` element. This decouples the theme from the OS preference (media query `prefers-color-scheme`), allowing users to toggle themes manually regardless of their system settings.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| System UI (Scrollbars) | Force-colored inputs | `prefers-color-scheme` (if not synchronized via JS) |
| Form Inputs | | |
| `base.css` (defaults) | | |

## 8. Nesting & Collapse Behavior

- **Root Level:** Applied to `<html>` affects window chrome (scrollbars).
- **Nested Level:** Can be applied to specific containers (`<div style="color-scheme: dark">`) to create "dark mode islands" within a light page.

## 9. Diagram (MANDATORY)

```text
                  Browser Window
┌─────────────────────────────────────────┐
│  Start | Settings | X   [ Dark Scroll ] │
├─────────────────────────────────────────┤
│ :root [data-theme="dark"]               │
│                                         │
│   color-scheme: dark;                   │
│      ⬇                                 │
│   (Browser UI flips)                    │
│   - Scrollbars: Dark                    │
│   - Inputs: Dark                        │
│   - Default BG: Black                   │
└─────────────────────────────────────────┘
```

## 10. Valid Example

```html
<html data-theme="dark">
  <!-- Scrollbars are now dark -->
  <body>...</body>
</html>
```

## 11. Invalid Example

```css
/* Avoid using only classes without color-scheme property */
.dark-theme {
  background: black; 
  color: white;
  /* Missing color-scheme: dark means scrollbars stay white! */
}
```

## 12. Boundaries

- **Does NOT** define the actual color palette (hex codes).
- **Does NOT** define CSS variables for text or background (that is handled in `themes/` or `base/`).

## 13. Engine Decision Log

- **Why not just media queries?** Media queries (`@media (prefers-color-scheme: dark)`) are read-only. We cannot force them via a toggle button. Attributes allow JS state to control the CSS engine.
