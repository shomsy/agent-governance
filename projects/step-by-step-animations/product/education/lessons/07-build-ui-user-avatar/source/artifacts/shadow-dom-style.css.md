# Shadow CSS Rule Blocks

```json
[
  {
    "header": ":host {",
    "showFrom": "shadow-host-display",
    "entries": [
      {
        "from": "shadow-host-display",
        "line": "display: inline-block;"
      },
      {
        "from": "shadow-host-font-family",
        "line": "font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, \"Segoe UI\", sans-serif;"
      },
      {
        "from": "shadow-host-color",
        "line": "color: var(--avatar-text, #f1f5f9);"
      }
    ]
  },
  {
    "header": ".avatar-container {",
    "showFrom": "container-outline",
    "entries": [
      {
        "from": "container-outline",
        "untilBefore": "container-summary",
        "line": "outline: 1px dashed #38bdf8;"
      },
      {
        "from": "container-position",
        "line": "position: relative;"
      },
      {
        "from": "container-display",
        "line": "display: inline-flex;"
      },
      {
        "from": "container-direction",
        "line": "flex-direction: column;"
      },
      {
        "from": "container-align",
        "line": "align-items: center;"
      },
      {
        "from": "container-gap",
        "line": "gap: 8px;"
      },
      {
        "from": "container-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": ".avatar-image {",
    "showFrom": "image-outline",
    "entries": [
      {
        "from": "image-outline",
        "untilBefore": "image-summary",
        "line": "outline: 1px dashed #a78bfa;"
      },
      {
        "from": "image-position",
        "line": "position: relative;"
      },
      {
        "from": "image-width",
        "line": "width: 72px;"
      },
      {
        "from": "image-height",
        "line": "height: 72px;"
      },
      {
        "from": "image-radius",
        "line": "border-radius: 50%;"
      },
      {
        "from": "image-background",
        "line": "background: linear-gradient(135deg, var(--avatar-accent, #38bdf8), #6366f1);"
      },
      {
        "from": "image-border",
        "line": "border: 2px solid var(--avatar-border, rgba(148,163,184,0.2));"
      },
      {
        "from": "image-shadow",
        "line": "box-shadow: var(--avatar-shadow, 0 8px 32px rgba(15,23,42,0.48));"
      },
      {
        "from": "image-display",
        "line": "display: flex;"
      },
      {
        "from": "image-align",
        "line": "align-items: center;"
      },
      {
        "from": "image-justify",
        "line": "justify-content: center;"
      },
      {
        "from": "image-overflow",
        "line": "overflow: hidden;"
      },
      {
        "from": "image-transition",
        "line": "transition: transform 180ms ease, box-shadow 180ms ease;"
      },
      {
        "from": "image-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": ".avatar-image:hover {",
    "showFrom": "image-hover-transform",
    "entries": [
      {
        "from": "image-hover-transform",
        "line": "transform: scale(1.05);"
      },
      {
        "from": "image-hover-shadow",
        "line": "box-shadow: 0 12px 40px rgba(56,189,248,0.28);"
      }
    ]
  },
  {
    "header": "::slotted([slot=\"initials\"]) {",
    "showFrom": "initials-font-size",
    "entries": [
      {
        "from": "initials-font-size",
        "line": "font-size: 24px;"
      },
      {
        "from": "initials-font-weight",
        "line": "font-weight: 800;"
      },
      {
        "from": "initials-color",
        "line": "color: #ffffff;"
      },
      {
        "from": "initials-letter-spacing",
        "line": "letter-spacing: 0.04em;"
      },
      {
        "from": "initials-select",
        "line": "user-select: none;"
      }
    ]
  },
  {
    "header": ".status-badge {",
    "showFrom": "status-outline",
    "entries": [
      {
        "from": "status-outline",
        "untilBefore": "status-summary",
        "line": "outline: 1px dotted #facc15;"
      },
      {
        "from": "status-position",
        "line": "position: absolute;"
      },
      {
        "from": "status-bottom",
        "line": "bottom: 2px;"
      },
      {
        "from": "status-right",
        "line": "right: 2px;"
      },
      {
        "from": "status-width",
        "line": "width: 16px;"
      },
      {
        "from": "status-height",
        "line": "height: 16px;"
      },
      {
        "from": "status-radius",
        "line": "border-radius: 50%;"
      },
      {
        "from": "status-background",
        "line": "background: var(--avatar-status-color, #22c55e);"
      },
      {
        "from": "status-border",
        "line": "border: 2px solid var(--avatar-surface, #1e293b);"
      },
      {
        "from": "status-transition",
        "line": "transition: background 240ms ease;"
      },
      {
        "from": "status-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": ".avatar-info {",
    "showFrom": "info-outline",
    "entries": [
      {
        "from": "info-outline",
        "untilBefore": "info-summary",
        "line": "outline: 1px dashed #34d399;"
      },
      {
        "from": "info-display",
        "line": "display: flex;"
      },
      {
        "from": "info-direction",
        "line": "flex-direction: column;"
      },
      {
        "from": "info-align",
        "line": "align-items: center;"
      },
      {
        "from": "info-gap",
        "line": "gap: 2px;"
      },
      {
        "from": "info-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": ".username {",
    "showFrom": "username-font-size",
    "entries": [
      {
        "from": "username-font-size",
        "line": "font-size: 14px;"
      },
      {
        "from": "username-font-weight",
        "line": "font-weight: 700;"
      },
      {
        "from": "username-color",
        "line": "color: var(--avatar-text, #f1f5f9);"
      },
      {
        "from": "username-white-space",
        "line": "white-space: nowrap;"
      }
    ]
  },
  {
    "header": ".role {",
    "showFrom": "role-font-size",
    "entries": [
      {
        "from": "role-font-size",
        "line": "font-size: 11px;"
      },
      {
        "from": "role-font-weight",
        "line": "font-weight: 500;"
      },
      {
        "from": "role-color",
        "line": "color: var(--avatar-muted, #94a3b8);"
      },
      {
        "from": "role-text-transform",
        "line": "text-transform: uppercase;"
      },
      {
        "from": "role-letter-spacing",
        "line": "letter-spacing: 0.06em;"
      },
      {
        "from": "role-white-space",
        "line": "white-space: nowrap;"
      }
    ]
  },
  {
    "header": ".tooltip {",
    "showFrom": "tooltip-outline",
    "entries": [
      {
        "from": "tooltip-outline",
        "untilBefore": "tooltip-summary",
        "line": "outline: 1px dotted #f472b6;"
      },
      {
        "from": "tooltip-position",
        "line": "position: absolute;"
      },
      {
        "from": "tooltip-bottom",
        "line": "bottom: calc(100% + 10px);"
      },
      {
        "from": "tooltip-left",
        "line": "left: 50%;"
      },
      {
        "from": "tooltip-transform",
        "line": "transform: translateX(-50%);"
      },
      {
        "from": "tooltip-background",
        "line": "background: #0f172a;"
      },
      {
        "from": "tooltip-border",
        "line": "border: 1px solid var(--avatar-border, rgba(148,163,184,0.2));"
      },
      {
        "from": "tooltip-color",
        "line": "color: var(--avatar-text, #f1f5f9);"
      },
      {
        "from": "tooltip-padding",
        "line": "padding: 8px 12px;"
      },
      {
        "from": "tooltip-radius",
        "line": "border-radius: 8px;"
      },
      {
        "from": "tooltip-font-size",
        "line": "font-size: 12px;"
      },
      {
        "from": "tooltip-white-space",
        "line": "white-space: nowrap;"
      },
      {
        "from": "tooltip-pointer-events",
        "line": "pointer-events: none;"
      },
      {
        "from": "tooltip-opacity-start",
        "line": "opacity: 0;"
      },
      {
        "from": "tooltip-transition",
        "line": "transition: opacity 180ms ease, transform 180ms ease;"
      },
      {
        "from": "tooltip-z-index",
        "line": "z-index: 10;"
      },
      {
        "from": "tooltip-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": ":host(:hover) .tooltip, :host(:focus-within) .tooltip {",
    "showFrom": "tooltip-hover-opacity",
    "entries": [
      {
        "from": "tooltip-hover-opacity",
        "line": "opacity: 1;"
      },
      {
        "from": "tooltip-hover-transform",
        "line": "transform: translateX(-50%) translateY(-4px);"
      }
    ]
  },
  {
    "header": ":host(:focus-visible) {",
    "showFrom": "host-focus-outline",
    "entries": [
      {
        "from": "host-focus-outline",
        "line": "outline: 3px solid rgba(56,189,248,0.55);"
      },
      {
        "from": "host-focus-outline-offset",
        "line": "outline-offset: 4px;"
      },
      {
        "from": "host-focus-radius",
        "line": "border-radius: 50%;"
      }
    ]
  }
]
```
