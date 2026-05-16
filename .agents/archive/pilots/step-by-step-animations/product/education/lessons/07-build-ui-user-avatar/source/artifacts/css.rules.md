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
        "line": "padding: 48px 32px;"
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
        "from": "shell-gap",
        "line": "gap: 24px;"
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
    "header": "ui-user-avatar {",
    "showFrom": "component-html",
    "entries": [
      {
        "from": "host-outline",
        "untilBefore": "host-summary",
        "line": "outline: 1px solid #f97316;"
      },
      {
        "from": "host-display",
        "line": "display: inline-block;"
      },
      {
        "from": "host-position",
        "line": "position: relative;"
      },
      {
        "from": "host-cursor",
        "line": "cursor: pointer;"
      },
      {
        "from": "host-surface-token",
        "line": "--avatar-surface: #1e293b;"
      },
      {
        "from": "host-surface-alt-token",
        "line": "--avatar-surface-alt: #0f172a;"
      },
      {
        "from": "host-accent-token",
        "line": "--avatar-accent: #38bdf8;"
      },
      {
        "from": "host-text-token",
        "line": "--avatar-text: #f1f5f9;"
      },
      {
        "from": "host-muted-token",
        "line": "--avatar-muted: #94a3b8;"
      },
      {
        "from": "host-border-token",
        "line": "--avatar-border: rgba(148,163,184,0.2);"
      },
      {
        "from": "host-shadow-token",
        "line": "--avatar-shadow: 0 8px 32px rgba(15,23,42,0.48);"
      },
      {
        "from": "host-status-color-token",
        "line": "--avatar-status-color: #22c55e;"
      },
      {
        "from": "host-summary",
        "line": "/* helper outline removed */"
      }
    ]
  },
  {
    "header": "ui-user-avatar[status=\"online\"] {",
    "showFrom": "variant-online-status-color",
    "entries": [
      {
        "from": "variant-online-status-color",
        "line": "--avatar-status-color: #22c55e;"
      }
    ]
  },
  {
    "header": "ui-user-avatar[status=\"idle\"] {",
    "showFrom": "variant-idle-status-color",
    "entries": [
      {
        "from": "variant-idle-status-color",
        "line": "--avatar-status-color: #facc15;"
      }
    ]
  },
  {
    "header": "ui-user-avatar[status=\"away\"] {",
    "showFrom": "variant-away-status-color",
    "entries": [
      {
        "from": "variant-away-status-color",
        "line": "--avatar-status-color: #fb923c;"
      }
    ]
  },
  {
    "header": "ui-user-avatar[status=\"offline\"] {",
    "showFrom": "variant-offline-status-color",
    "entries": [
      {
        "from": "variant-offline-status-color",
        "line": "--avatar-status-color: #64748b;"
      }
    ]
  }
]
```
