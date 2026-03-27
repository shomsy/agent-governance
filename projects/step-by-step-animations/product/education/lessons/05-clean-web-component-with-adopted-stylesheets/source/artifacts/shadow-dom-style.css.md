# Shadow DOM CSS Rule Blocks

```json
[
  {
    "header": ":host {",
    "entries": [
      {
        "from": "host-font",
        "line": "font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, \"Segoe UI\", sans-serif;"
      },
      {
        "from": "host-color",
        "line": "color: var(--callout-text, #e2e8f0);"
      }
    ]
  },
  {
    "header": ".card {",
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
        "line": "gap: 16px;"
      },
      {
        "from": "card-padding",
        "line": "padding: 24px;"
      },
      {
        "from": "card-radius",
        "line": "border-radius: 28px;"
      },
      {
        "from": "card-border",
        "line": "border: 1px solid var(--callout-border, rgba(148,163,184,0.24));"
      },
      {
        "from": "card-background",
        "line": "background: linear-gradient(180deg, var(--callout-surface, rgba(15,23,42,0.98)), var(--callout-surface-alt, rgba(15,23,42,0.92)));"
      },
      {
        "from": "card-shadow",
        "line": "box-shadow: var(--callout-shadow, 0 26px 60px rgba(15,23,42,0.24));"
      },
      {
        "from": "card-summary",
        "line": "/* helper outline removed in final .card summary */"
      }
    ]
  },
  {
    "header": ".eyebrow {",
    "entries": [
      {
        "from": "eyebrow-outline",
        "untilBefore": "eyebrow-summary",
        "line": "outline: 1px dotted #facc15;"
      },
      {
        "from": "eyebrow-display",
        "line": "display: inline-flex;"
      },
      {
        "from": "eyebrow-align-items",
        "line": "align-items: center;"
      },
      {
        "from": "eyebrow-justify-content",
        "line": "justify-content: center;"
      },
      {
        "from": "eyebrow-width",
        "line": "width: fit-content;"
      },
      {
        "from": "eyebrow-padding",
        "line": "padding: 8px 12px;"
      },
      {
        "from": "eyebrow-radius",
        "line": "border-radius: 999px;"
      },
      {
        "from": "eyebrow-background",
        "line": "background: rgba(56,189,248,0.14);"
      },
      {
        "from": "eyebrow-color",
        "line": "color: var(--callout-accent, #38bdf8);"
      },
      {
        "from": "eyebrow-font-size",
        "line": "font-size: 12px;"
      },
      {
        "from": "eyebrow-font-weight",
        "line": "font-weight: 700;"
      },
      {
        "from": "eyebrow-letter-spacing",
        "line": "letter-spacing: 0.04em;"
      },
      {
        "from": "eyebrow-text-transform",
        "line": "text-transform: uppercase;"
      },
      {
        "from": "eyebrow-summary",
        "line": "/* helper outline removed in final .eyebrow summary */"
      }
    ]
  },
  {
    "header": ".title {",
    "entries": [
      {
        "from": "title-display",
        "line": "display: block;"
      },
      {
        "from": "title-margin",
        "line": "margin: 0;"
      },
      {
        "from": "title-font-size",
        "line": "font-size: clamp(1.75rem, 4vw, 2rem);"
      },
      {
        "from": "title-line-height",
        "line": "line-height: 1.1;"
      },
      {
        "from": "title-font-weight",
        "line": "font-weight: 800;"
      }
    ]
  },
  {
    "header": ".summary {",
    "entries": [
      {
        "from": "summary-margin",
        "line": "margin: 0;"
      },
      {
        "from": "summary-color",
        "line": "color: var(--callout-muted, #cbd5e1);"
      },
      {
        "from": "summary-line-height",
        "line": "line-height: 1.65;"
      }
    ]
  },
  {
    "header": ".cta {",
    "entries": [
      {
        "from": "cta-outline",
        "untilBefore": "cta-summary",
        "line": "outline: 1px dashed #34d399;"
      },
      {
        "from": "cta-justify-self",
        "line": "justify-self: start;"
      },
      {
        "from": "cta-appearance",
        "line": "appearance: none;"
      },
      {
        "from": "cta-padding",
        "line": "padding: 12px 16px;"
      },
      {
        "from": "cta-border",
        "line": "border: 0;"
      },
      {
        "from": "cta-radius",
        "line": "border-radius: 999px;"
      },
      {
        "from": "cta-background",
        "line": "background: linear-gradient(135deg, var(--callout-accent, #38bdf8), var(--callout-accent-strong, #2563eb));"
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
        "line": "box-shadow: 0 14px 30px rgba(37, 99, 235, 0.28);"
      },
      {
        "from": "cta-summary",
        "line": "/* helper outline removed in final .cta summary */"
      }
    ]
  },
  {
    "header": ".cta:hover {",
    "entries": [
      {
        "from": "cta-hover-filter",
        "line": "filter: brightness(1.06);"
      },
      {
        "from": "cta-hover-transform",
        "line": "transform: translateY(-1px);"
      }
    ]
  },
  {
    "header": ".cta:active {",
    "entries": [
      {
        "from": "cta-active-transform",
        "line": "transform: translateY(0);"
      }
    ]
  },
  {
    "header": ".cta:focus-visible {",
    "entries": [
      {
        "from": "cta-focus-outline",
        "line": "outline: 3px solid rgba(56, 189, 248, 0.45);"
      },
      {
        "from": "cta-focus-outline-offset",
        "line": "outline-offset: 3px;"
      }
    ]
  }
]
```
