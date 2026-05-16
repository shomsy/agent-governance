# safe-area.css

## 1. Purpose

This file ensures content is not obscured by hardware features like camera notches, rounded display corners, or home indicator bars on mobile devices. It defines safe area insets standardizing the "breathing room" required by the device.

## 2. Architectural Layer

**Layer: SETTINGS**
It captures environmental constraints from the user agent.

## 3. Core Concept

- **Mechanism:** CSS Environment Variables (`env()`).
- **Why Chosen:** It is the standard way browsers communicate "unsafe" areas of the viewport (like the notch on an iPhone).
- **Alternatives Considered:** `constant()` (deprecated iOS 11 syntax).

## 4. CSS Fundamentals (MANDATORY)

### env(variable, fallback)

- **What it is:** Accesses User Agent defined environment variables.
- **Behavior:** If the variable exists (e.g. on an iPhone X), it returns the pixel value of the inset. If not (e.g. desktop), it returns the fallback (`0px`).
- **Difference from var():** `env()` values come from the browser/OS, not CSS.

## 5. CSS Properties Breakdown

- `--safe-left`: The left inset (landscape mode notch).
- `--safe-right`: The right inset.
- Note: Top/Bottom insets are handled via specific padding on `l-page` but primarily `l-bleed-safe` uses left/right.

## 6. MILOS Implementation Logic

We wrap the raw `env()` call in a standard CSS variable (`--safe-left`). This allows us to inspect, mock, or override the value easily during development without needing a physical device.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| `l-bleed-safe` (primary consumer) | `position: fixed; left: 0` (might be under notch) | |
| `l-page` | | |
| Mobile Layouts | | |

## 8. Nesting & Collapse Behavior

- **Global:** Variables cascade.

## 9. Diagram (MANDATORY)

```text
  iPhone Landscape
  ┌───────┐───────────────────────────┐
  │ Notch │  Header Content           │
  │       │                           │
  └───────┘───────────────────────────┘
   <----->
   --safe-left
```

## 10. Valid Example

```css
.my-header {
  padding-left: var(--safe-left);
  padding-right: var(--safe-right);
}
```

## 11. Invalid Example

```css
.my-header {
  padding-left: 20px; /* Might be covered by notch (44px+) */
}
```

## 12. Boundaries

- **Does NOT** force the browser to respect safe areas (requires `viewport-fit=cover` meta tag).

## 13. Engine Decision Log

- **Why Wrap?** `var(--safe-left)` is shorter to type and easier to override in dev-tools than `env(safe-area-inset-left)`.
