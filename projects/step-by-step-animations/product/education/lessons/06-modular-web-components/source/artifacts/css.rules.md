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
        "line": "padding: 40px;"
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
        "line": "background: linear-gradient(180deg, #e2e8f0, #cbd5e1);"
      },
      {
        "from": "shell-summary",
        "line": "/* helper outline removed in final .app-shell summary */"
      }
    ]
  },
  {
    "header": "my-first-component {",
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
        "line": "width: min(100%, 420px);"
      },
      {
        "from": "host-surface-token",
        "line": "--callout-surface: #0f172a;"
      },
      {
        "from": "host-surface-alt-token",
        "line": "--callout-surface-alt: rgba(15, 23, 42, 0.92);"
      },
      {
        "from": "host-border-token",
        "line": "--callout-border: rgba(148,163,184,0.24);"
      },
      {
        "from": "host-accent-token",
        "line": "--callout-accent: #38bdf8;"
      },
      {
        "from": "host-accent-strong-token",
        "line": "--callout-accent-strong: #2563eb;"
      },
      {
        "from": "host-text-token",
        "line": "--callout-text: #e2e8f0;"
      },
      {
        "from": "host-muted-token",
        "line": "--callout-muted: #cbd5e1;"
      },
      {
        "from": "host-shadow-token",
        "line": "--callout-shadow: 0 26px 60px rgba(15, 23, 42, 0.24);"
      },
      {
        "from": "host-summary",
        "line": "/* helper outline removed in final my-first-component host summary */"
      }
    ]
  }
]
```
