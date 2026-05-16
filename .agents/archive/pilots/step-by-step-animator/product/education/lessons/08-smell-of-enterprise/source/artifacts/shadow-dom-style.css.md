# Shadow CSS Rule Blocks

```json
[
  {
    "header": ":host {",
    "showFrom": "shadow-host-display",
    "entries": [
      {
        "from": "shadow-host-display",
        "line": "display: block;"
      },
      {
        "from": "shadow-host-font-family",
        "line": "font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, \"Segoe UI\", sans-serif;"
      },
      {
        "from": "shadow-host-color",
        "line": "color: var(--pricing-text, #f1f5f9);"
      }
    ]
  },
  {
    "header": ".card {",
    "showFrom": "card-outline",
    "entries": [
      {
        "from": "card-outline",
        "untilBefore": "card-summary",
        "line": "outline: 1px dashed #38bdf8;"
      },
      {
        "from": "card-display",
        "line": "display: grid;"
      },
      {
        "from": "card-gap",
        "line": "gap: 20px;"
      },
      {
        "from": "card-padding",
        "line": "padding: 32px 28px;"
      },
      {
        "from": "card-radius",
        "line": "border-radius: 24px;"
      },
      {
        "from": "card-border",
        "line": "border: 1px solid var(--pricing-border, rgba(148,163,184,0.18));"
      },
      {
        "from": "card-background",
        "line": "background: linear-gradient(180deg, var(--pricing-surface, #1e293b), var(--pricing-surface-alt, rgba(15,23,42,0.92)));"
      },
      {
        "from": "card-shadow",
        "line": "box-shadow: var(--pricing-shadow, 0 16px 48px rgba(15,23,42,0.4));"
      },
      {
        "from": "card-text-align",
        "line": "text-align: center;"
      },
      {
        "from": "card-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": ".popular-badge {",
    "showFrom": "badge-outline",
    "entries": [
      {
        "from": "badge-outline",
        "untilBefore": "badge-summary",
        "line": "outline: 1px dotted #facc15;"
      },
      {
        "from": "badge-display",
        "line": "display: none;"
      },
      {
        "from": "badge-padding",
        "line": "padding: 6px 14px;"
      },
      {
        "from": "badge-radius",
        "line": "border-radius: 999px;"
      },
      {
        "from": "badge-background",
        "line": "background: linear-gradient(135deg, var(--pricing-accent, #38bdf8), var(--pricing-accent-strong, #2563eb));"
      },
      {
        "from": "badge-color",
        "line": "color: #ffffff;"
      },
      {
        "from": "badge-font-size",
        "line": "font-size: 12px;"
      },
      {
        "from": "badge-font-weight",
        "line": "font-weight: 700;"
      },
      {
        "from": "badge-letter-spacing",
        "line": "letter-spacing: 0.04em;"
      },
      {
        "from": "badge-text-transform",
        "line": "text-transform: uppercase;"
      },
      {
        "from": "badge-width",
        "line": "width: fit-content;"
      },
      {
        "from": "badge-justify-self",
        "line": "justify-self: center;"
      },
      {
        "from": "badge-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": ":host([popular]) .popular-badge {",
    "showFrom": "badge-popular-display",
    "entries": [
      {
        "from": "badge-popular-display",
        "line": "display: inline-flex;"
      }
    ]
  },
  {
    "header": "::slotted([slot=\"badge\"]) {",
    "showFrom": "badge-slotted-font",
    "entries": [
      {
        "from": "badge-slotted-font",
        "line": "font: inherit;"
      }
    ]
  },
  {
    "header": ".tier-name {",
    "showFrom": "tier-name-margin",
    "entries": [
      {
        "from": "tier-name-margin",
        "line": "margin: 0;"
      },
      {
        "from": "tier-name-font-size",
        "line": "font-size: 18px;"
      },
      {
        "from": "tier-name-font-weight",
        "line": "font-weight: 700;"
      },
      {
        "from": "tier-name-text-transform",
        "line": "text-transform: uppercase;"
      },
      {
        "from": "tier-name-letter-spacing",
        "line": "letter-spacing: 0.08em;"
      },
      {
        "from": "tier-name-color",
        "line": "color: var(--pricing-accent, #38bdf8);"
      }
    ]
  },
  {
    "header": ".price-block {",
    "showFrom": "price-outline",
    "entries": [
      {
        "from": "price-outline",
        "untilBefore": "price-summary",
        "line": "outline: 1px dashed #a78bfa;"
      },
      {
        "from": "price-display",
        "line": "display: flex;"
      },
      {
        "from": "price-align",
        "line": "align-items: baseline;"
      },
      {
        "from": "price-justify",
        "line": "justify-content: center;"
      },
      {
        "from": "price-gap",
        "line": "gap: 4px;"
      },
      {
        "from": "price-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": ".price-currency {",
    "showFrom": "price-currency-font-size",
    "entries": [
      {
        "from": "price-currency-font-size",
        "line": "font-size: 24px;"
      },
      {
        "from": "price-currency-font-weight",
        "line": "font-weight: 700;"
      },
      {
        "from": "price-currency-color",
        "line": "color: var(--pricing-muted, #94a3b8);"
      }
    ]
  },
  {
    "header": ".price-amount {",
    "showFrom": "price-amount-font-size",
    "entries": [
      {
        "from": "price-amount-font-size",
        "line": "font-size: 56px;"
      },
      {
        "from": "price-amount-font-weight",
        "line": "font-weight: 800;"
      },
      {
        "from": "price-amount-line-height",
        "line": "line-height: 1;"
      },
      {
        "from": "price-amount-transition",
        "line": "transition: transform 200ms ease;"
      }
    ]
  },
  {
    "header": ".price-period {",
    "showFrom": "price-period-font-size",
    "entries": [
      {
        "from": "price-period-font-size",
        "line": "font-size: 16px;"
      },
      {
        "from": "price-period-color",
        "line": "color: var(--pricing-muted, #94a3b8);"
      },
      {
        "from": "price-period-font-weight",
        "line": "font-weight: 500;"
      }
    ]
  },
  {
    "header": ".billing-toggle {",
    "showFrom": "toggle-outline",
    "entries": [
      {
        "from": "toggle-outline",
        "untilBefore": "toggle-summary",
        "line": "outline: 1px dotted #f472b6;"
      },
      {
        "from": "toggle-display",
        "line": "display: flex;"
      },
      {
        "from": "toggle-align",
        "line": "align-items: center;"
      },
      {
        "from": "toggle-justify",
        "line": "justify-content: center;"
      },
      {
        "from": "toggle-gap",
        "line": "gap: 10px;"
      },
      {
        "from": "toggle-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": ".toggle-label {",
    "showFrom": "toggle-label-font-size",
    "entries": [
      {
        "from": "toggle-label-font-size",
        "line": "font-size: 13px;"
      },
      {
        "from": "toggle-label-color",
        "line": "color: var(--pricing-muted, #94a3b8);"
      },
      {
        "from": "toggle-label-font-weight",
        "line": "font-weight: 500;"
      },
      {
        "from": "toggle-label-transition",
        "line": "transition: color 180ms ease;"
      }
    ]
  },
  {
    "header": ".toggle-switch {",
    "showFrom": "toggle-switch-appearance",
    "entries": [
      {
        "from": "toggle-switch-appearance",
        "line": "appearance: none;"
      },
      {
        "from": "toggle-switch-width",
        "line": "width: 44px;"
      },
      {
        "from": "toggle-switch-height",
        "line": "height: 24px;"
      },
      {
        "from": "toggle-switch-radius",
        "line": "border-radius: 12px;"
      },
      {
        "from": "toggle-switch-border",
        "line": "border: 0;"
      },
      {
        "from": "toggle-switch-background",
        "line": "background: rgba(148,163,184,0.2);"
      },
      {
        "from": "toggle-switch-cursor",
        "line": "cursor: pointer;"
      },
      {
        "from": "toggle-switch-position",
        "line": "position: relative;"
      },
      {
        "from": "toggle-switch-padding",
        "line": "padding: 2px;"
      },
      {
        "from": "toggle-switch-transition",
        "line": "transition: background 180ms ease;"
      }
    ]
  },
  {
    "header": ".toggle-knob {",
    "showFrom": "toggle-knob-display",
    "entries": [
      {
        "from": "toggle-knob-display",
        "line": "display: block;"
      },
      {
        "from": "toggle-knob-width",
        "line": "width: 20px;"
      },
      {
        "from": "toggle-knob-height",
        "line": "height: 20px;"
      },
      {
        "from": "toggle-knob-radius",
        "line": "border-radius: 50%;"
      },
      {
        "from": "toggle-knob-background",
        "line": "background: #ffffff;"
      },
      {
        "from": "toggle-knob-transition",
        "line": "transition: transform 180ms ease;"
      }
    ]
  },
  {
    "header": ":host([billing=\"yearly\"]) .toggle-switch {",
    "showFrom": "toggle-yearly-bg",
    "entries": [
      {
        "from": "toggle-yearly-bg",
        "line": "background: var(--pricing-accent, #38bdf8);"
      }
    ]
  },
  {
    "header": ":host([billing=\"yearly\"]) .toggle-knob {",
    "showFrom": "toggle-yearly-knob",
    "entries": [
      {
        "from": "toggle-yearly-knob",
        "line": "transform: translateX(20px);"
      }
    ]
  },
  {
    "header": ".save-badge {",
    "showFrom": "save-badge-font-size",
    "entries": [
      {
        "from": "save-badge-font-size",
        "line": "font-size: 10px;"
      },
      {
        "from": "save-badge-background",
        "line": "background: rgba(34,197,94,0.2);"
      },
      {
        "from": "save-badge-color",
        "line": "color: #22c55e;"
      },
      {
        "from": "save-badge-padding",
        "line": "padding: 2px 6px;"
      },
      {
        "from": "save-badge-radius",
        "line": "border-radius: 4px;"
      },
      {
        "from": "save-badge-font-weight",
        "line": "font-weight: 700;"
      }
    ]
  },
  {
    "header": ".feature-list {",
    "showFrom": "features-outline",
    "entries": [
      {
        "from": "features-outline",
        "untilBefore": "features-summary",
        "line": "outline: 1px dashed #34d399;"
      },
      {
        "from": "features-padding",
        "line": "padding: 8px 0;"
      },
      {
        "from": "features-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": "::slotted(ul) {",
    "showFrom": "features-slotted-list-style",
    "entries": [
      {
        "from": "features-slotted-list-style",
        "line": "list-style: none;"
      },
      {
        "from": "features-slotted-margin",
        "line": "margin: 0;"
      },
      {
        "from": "features-slotted-padding",
        "line": "padding: 0;"
      },
      {
        "from": "features-slotted-display",
        "line": "display: grid;"
      },
      {
        "from": "features-slotted-gap",
        "line": "gap: 12px;"
      },
      {
        "from": "features-slotted-text-align",
        "line": "text-align: left;"
      },
      {
        "from": "features-slotted-font-size",
        "line": "font-size: 14px;"
      },
      {
        "from": "features-slotted-color",
        "line": "color: var(--pricing-muted, #94a3b8);"
      }
    ]
  },
  {
    "header": ".cta {",
    "showFrom": "cta-outline",
    "entries": [
      {
        "from": "cta-outline",
        "untilBefore": "cta-summary",
        "line": "outline: 1px dashed #f97316;"
      },
      {
        "from": "cta-appearance",
        "line": "appearance: none;"
      },
      {
        "from": "cta-width",
        "line": "width: 100%;"
      },
      {
        "from": "cta-padding",
        "line": "padding: 14px 20px;"
      },
      {
        "from": "cta-border",
        "line": "border: 0;"
      },
      {
        "from": "cta-radius",
        "line": "border-radius: 14px;"
      },
      {
        "from": "cta-background",
        "line": "background: linear-gradient(135deg, var(--pricing-accent, #38bdf8), var(--pricing-accent-strong, #2563eb));"
      },
      {
        "from": "cta-color",
        "line": "color: #ffffff;"
      },
      {
        "from": "cta-font",
        "line": "font: inherit;"
      },
      {
        "from": "cta-font-size",
        "line": "font-size: 15px;"
      },
      {
        "from": "cta-font-weight",
        "line": "font-weight: 700;"
      },
      {
        "from": "cta-cursor",
        "line": "cursor: pointer;"
      },
      {
        "from": "cta-transition",
        "line": "transition: transform 160ms ease, filter 160ms ease, box-shadow 160ms ease;"
      },
      {
        "from": "cta-box-shadow",
        "line": "box-shadow: 0 12px 28px rgba(37,99,235,0.28);"
      },
      {
        "from": "cta-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": ".cta:hover {",
    "showFrom": "cta-hover-filter",
    "entries": [
      {
        "from": "cta-hover-filter",
        "line": "filter: brightness(1.08);"
      },
      {
        "from": "cta-hover-transform",
        "line": "transform: translateY(-1px);"
      }
    ]
  },
  {
    "header": ".cta:active {",
    "showFrom": "cta-active-transform",
    "entries": [
      {
        "from": "cta-active-transform",
        "line": "transform: translateY(0);"
      }
    ]
  },
  {
    "header": ".cta:focus-visible {",
    "showFrom": "cta-focus-outline",
    "entries": [
      {
        "from": "cta-focus-outline",
        "line": "outline: 3px solid rgba(56,189,248,0.45);"
      },
      {
        "from": "cta-focus-outline-offset",
        "line": "outline-offset: 3px;"
      }
    ]
  },
  {
    "header": ".urgency {",
    "showFrom": "urgency-outline",
    "entries": [
      {
        "from": "urgency-outline",
        "untilBefore": "urgency-summary",
        "line": "outline: 1px dotted #fb923c;"
      },
      {
        "from": "urgency-display",
        "line": "display: flex;"
      },
      {
        "from": "urgency-align",
        "line": "align-items: center;"
      },
      {
        "from": "urgency-justify",
        "line": "justify-content: center;"
      },
      {
        "from": "urgency-gap",
        "line": "gap: 6px;"
      },
      {
        "from": "urgency-font-size",
        "line": "font-size: 12px;"
      },
      {
        "from": "urgency-color",
        "line": "color: #fb923c;"
      },
      {
        "from": "urgency-font-weight",
        "line": "font-weight: 600;"
      },
      {
        "from": "urgency-summary",
        "line": "/* helper outline removed */"
      }
    ]
  }
]
```
