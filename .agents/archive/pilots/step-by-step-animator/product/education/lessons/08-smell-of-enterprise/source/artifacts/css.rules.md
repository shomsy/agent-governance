# CSS Rule Blocks

```json
[
  {
    "header": ".app-shell {",
    "showFrom": "empty-shell",
    "entries": [
      {
        "from": "shell-outline",
        "untilBefore": "shell-summary",
        "line": "outline: 1px dashed #94a3b8;"
      },
      {
        "from": "shell-padding",
        "line": "padding: 48px 24px;"
      },
      {
        "from": "shell-display",
        "line": "display: grid;"
      },
      {
        "from": "shell-place-items",
        "line": "place-items: center;"
      },
      {
        "from": "shell-min-height",
        "line": "min-height: 100vh;"
      },
      {
        "from": "shell-background",
        "line": "background: linear-gradient(160deg, #0f172a 0%, #1e293b 50%, #0f172a 100%);"
      },
      {
        "from": "shell-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": "ui-pricing-card {",
    "showFrom": "component-html",
    "entries": [
      {
        "from": "host-outline",
        "untilBefore": "host-summary",
        "line": "outline: 1px solid #f97316;"
      },
      {
        "from": "host-display",
        "line": "display: block;"
      },
      {
        "from": "host-width",
        "line": "width: min(100%, 380px);"
      },
      {
        "from": "host-position",
        "line": "position: relative;"
      },
      {
        "from": "host-surface-token",
        "line": "--pricing-surface: #1e293b;"
      },
      {
        "from": "host-surface-alt-token",
        "line": "--pricing-surface-alt: rgba(15,23,42,0.92);"
      },
      {
        "from": "host-border-token",
        "line": "--pricing-border: rgba(148,163,184,0.18);"
      },
      {
        "from": "host-accent-token",
        "line": "--pricing-accent: #38bdf8;"
      },
      {
        "from": "host-accent-strong-token",
        "line": "--pricing-accent-strong: #2563eb;"
      },
      {
        "from": "host-text-token",
        "line": "--pricing-text: #f1f5f9;"
      },
      {
        "from": "host-muted-token",
        "line": "--pricing-muted: #94a3b8;"
      },
      {
        "from": "host-shadow-token",
        "line": "--pricing-shadow: 0 16px 48px rgba(15,23,42,0.4);"
      },
      {
        "from": "host-popular-glow-token",
        "line": "--pricing-popular-glow: 0 0 0 2px rgba(56,189,248,0.35);"
      },
      {
        "from": "host-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": "ui-pricing-card[tier=\"starter\"] {",
    "showFrom": "tier-starter-accent",
    "entries": [
      {
        "from": "tier-starter-accent",
        "line": "--pricing-accent: #a78bfa;"
      },
      {
        "from": "tier-starter-accent-strong",
        "line": "--pricing-accent-strong: #7c3aed;"
      }
    ]
  },
  {
    "header": "ui-pricing-card[tier=\"pro\"] {",
    "showFrom": "tier-pro-accent",
    "entries": [
      {
        "from": "tier-pro-accent",
        "line": "--pricing-accent: #38bdf8;"
      },
      {
        "from": "tier-pro-accent-strong",
        "line": "--pricing-accent-strong: #2563eb;"
      }
    ]
  },
  {
    "header": "ui-pricing-card[tier=\"enterprise\"] {",
    "showFrom": "tier-enterprise-accent",
    "entries": [
      {
        "from": "tier-enterprise-accent",
        "line": "--pricing-accent: #f59e0b;"
      },
      {
        "from": "tier-enterprise-accent-strong",
        "line": "--pricing-accent-strong: #d97706;"
      }
    ]
  },
  {
    "header": "ui-pricing-card[popular] {",
    "showFrom": "popular-host-shadow",
    "entries": [
      {
        "from": "popular-host-shadow",
        "line": "box-shadow: var(--pricing-popular-glow, 0 0 0 2px rgba(56,189,248,0.35));"
      },
      {
        "from": "popular-host-transform",
        "line": "transform: scale(1.03);"
      },
      {
        "from": "popular-host-z-index",
        "line": "z-index: 1;"
      }
    ]
  }
]
```
