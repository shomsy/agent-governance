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
        "from": "shell-summary",
        "line": "/* helper outline removed in final .app-shell summary */"
      }
    ]
  },
  {
    "header": ".sidebar {",
    "showFrom": "sidebar-html",
    "entries": [
      {
        "from": "sidebar-outline",
        "untilBefore": "sidebar-summary",
        "line": "outline: 1px solid #ff4757;"
      },
      {
        "from": "sidebar-width",
        "line": "width: 280px;"
      },
      {
        "from": "sidebar-min-height",
        "line": "min-height: 100vh;"
      },
      {
        "from": "sidebar-border-right",
        "line": "border-right: 1px solid rgba(255,255,255,0.12);"
      },
      {
        "from": "sidebar-background",
        "line": "background: #0b1020;"
      },
      {
        "from": "sidebar-color",
        "line": "color: #edf2ff;"
      },
      {
        "from": "sidebar-display-flex",
        "line": "display: flex;"
      },
      {
        "from": "sidebar-flex-direction",
        "line": "flex-direction: column;"
      },
      {
        "from": "sidebar-summary",
        "line": "/* helper outline removed in final .sidebar summary */"
      }
    ]
  },
  {
    "header": ".sidebar-brand {",
    "showFrom": "brand-html",
    "entries": [
      {
        "from": "brand-outline",
        "untilBefore": "brand-summary",
        "line": "outline: 1px solid #2ed573;"
      },
      {
        "from": "brand-padding",
        "line": "padding: 24px;"
      },
      {
        "from": "brand-margin-bottom",
        "line": "margin-bottom: 28px;"
      },
      {
        "from": "brand-display",
        "line": "display: flex;"
      },
      {
        "from": "brand-align-items",
        "line": "align-items: center;"
      },
      {
        "from": "brand-gap",
        "line": "gap: 14px;"
      },
      {
        "from": "brand-summary",
        "line": "/* helper outline removed in final brand summary */"
      }
    ]
  },
  {
    "header": ".logo {",
    "showFrom": "logo-html",
    "entries": [
      {
        "from": "logo-outline",
        "untilBefore": "brand-summary",
        "line": "outline: 1px dotted #7dd3fc;"
      },
      {
        "from": "logo-width",
        "line": "width: 48px;"
      },
      {
        "from": "logo-height",
        "line": "height: 48px;"
      },
      {
        "from": "logo-display",
        "line": "display: grid;"
      },
      {
        "from": "logo-place-items",
        "line": "place-items: center;"
      },
      {
        "from": "logo-radius",
        "line": "border-radius: 12px;"
      },
      {
        "from": "logo-font-weight",
        "line": "font-weight: 800;"
      },
      {
        "from": "logo-background",
        "line": "background: linear-gradient(135deg, #6d73ff, #8f5cff);"
      },
      {
        "from": "logo-color",
        "line": "color: white;"
      },
      {
        "from": "logo-shadow",
        "line": "box-shadow: 0 12px 24px rgba(109,115,255,0.30);"
      },
      {
        "from": "brand-summary",
        "line": "/* logo helper outline removed in final brand summary */"
      }
    ]
  },
  {
    "header": ".brand-copy {",
    "showFrom": "brand-copy-html",
    "entries": [
      {
        "from": "brand-copy-outline",
        "untilBefore": "brand-summary",
        "line": "outline: 1px dashed #f59e0b;"
      },
      {
        "from": "brand-summary",
        "line": "/* brand-copy helper outline removed in final brand summary */"
      }
    ]
  },
  {
    "header": ".brand-copy strong {",
    "entries": [
      {
        "from": "brand-strong-display",
        "line": "display: block;"
      },
      {
        "from": "brand-strong-font-size",
        "line": "font-size: 16px;"
      }
    ]
  },
  {
    "header": ".brand-copy span {",
    "entries": [
      {
        "from": "brand-span-display",
        "line": "display: block;"
      },
      {
        "from": "brand-span-margin-top",
        "line": "margin-top: 4px;"
      },
      {
        "from": "brand-span-font-size",
        "line": "font-size: 13px;"
      },
      {
        "from": "brand-span-color",
        "line": "color: #9aa6c8;"
      }
    ]
  },
  {
    "header": ".nav-list {",
    "showFrom": "nav-html",
    "entries": [
      {
        "from": "nav-list-outline",
        "untilBefore": "navigation-summary",
        "line": "outline: 1px dashed #38bdf8;"
      },
      {
        "from": "nav-list-padding",
        "untilBefore": "navigation-summary",
        "line": "padding: 10px 8px;"
      },
      {
        "from": "nav-list-display",
        "line": "display: grid;"
      },
      {
        "from": "nav-list-gap",
        "line": "gap: 10px;"
      },
      {
        "from": "navigation-summary",
        "line": "/* nav wrapper helper outline removed in final navigation summary */"
      }
    ]
  },
  {
    "header": ".nav-item {",
    "showFrom": "nav-items-html",
    "entries": [
      {
        "from": "nav-item-outline",
        "untilBefore": "navigation-summary",
        "line": "outline: 1px solid #ffa502;"
      },
      {
        "from": "nav-item-display",
        "line": "display: flex;"
      },
      {
        "from": "nav-item-min-height",
        "line": "min-height: 52px;"
      },
      {
        "from": "nav-item-padding",
        "line": "padding: 12px 16px;"
      },
      {
        "from": "nav-item-align-items",
        "line": "align-items: center;"
      },
      {
        "from": "nav-item-gap",
        "line": "gap: 12px;"
      },
      {
        "from": "nav-item-radius",
        "line": "border-radius: 14px;"
      },
      {
        "from": "nav-item-margin",
        "line": "margin: 0 8px;"
      },
      {
        "from": "nav-item-transition",
        "line": "transition: all 0.4s ease;"
      },
      {
        "from": "navigation-summary",
        "line": "/* nav item helper outline removed in final navigation summary */"
      }
    ]
  },
  {
    "header": ".nav-item .icon {",
    "entries": [
      {
        "from": "nav-icon-outline",
        "untilBefore": "navigation-summary",
        "line": "outline: 1px dotted #7dd3fc;"
      },
      {
        "from": "nav-icon-width",
        "line": "width: 22px;"
      },
      {
        "from": "nav-icon-height",
        "line": "height: 22px;"
      },
      {
        "from": "nav-icon-display",
        "line": "display: grid;"
      },
      {
        "from": "nav-icon-place-items",
        "line": "place-items: center;"
      },
      {
        "from": "navigation-summary",
        "line": "/* nav icon helper outline removed in final navigation summary */"
      }
    ]
  },
  {
    "header": ".nav-item .label {",
    "entries": [
      {
        "from": "nav-label-font-size",
        "line": "font-size: 15px;"
      },
      {
        "from": "nav-label-font-weight",
        "line": "font-weight: 600;"
      }
    ]
  },
  {
    "header": ".nav-item.active {",
    "entries": [
      {
        "from": "nav-item-active-background",
        "line": "background: rgba(109,115,255,0.14);"
      },
      {
        "from": "nav-item-active-color",
        "line": "color: white;"
      }
    ]
  },
  {
    "header": ".nav-item:hover {",
    "entries": [
      {
        "from": "nav-item-hover-background",
        "line": "background: rgba(255,255,255,0.05);"
      }
    ]
  },
  {
    "header": ".sidebar.is-collapsed {",
    "entries": [
      {
        "from": "collapse-width",
        "line": "width: 108px;"
      }
    ]
  },
  {
    "header": [
      ".sidebar.is-collapsed .brand-copy,",
      ".sidebar.is-collapsed .nav-item .label {"
    ],
    "entries": [
      {
        "from": "hide-labels",
        "line": "display: none;"
      }
    ]
  },
  {
    "header": ".sidebar-footer {",
    "showFrom": "footer-html",
    "entries": [
      {
        "from": "footer-outline",
        "untilBefore": "footer-summary",
        "line": "outline: 1px dashed #c084fc;"
      },
      {
        "from": "footer-border",
        "line": "border: 1px solid rgba(255,255,255,0.12);"
      },
      {
        "from": "footer-background",
        "line": "background: rgba(255,255,255,0.05);"
      },
      {
        "from": "footer-padding",
        "line": "padding: 16px;"
      },
      {
        "from": "footer-radius",
        "line": "border-radius: 14px;"
      },
      {
        "from": "footer-margin-top",
        "line": "margin-top: auto;"
      },
      {
        "from": "footer-summary",
        "line": "/* footer helper outline removed in final footer summary */"
      }
    ]
  },
  {
    "header": ".sidebar-footer p {",
    "entries": [
      {
        "from": "footer-text-margin",
        "line": "margin: 6px 0 0;"
      },
      {
        "from": "footer-text-color",
        "line": "color: #9aa6c8;"
      },
      {
        "from": "footer-text-line-height",
        "line": "line-height: 1.5;"
      }
    ]
  },
  {
    "header": "@media (max-width: 980px) {",
    "entries": [
      {
        "from": "responsive-sidebar-min-height",
        "line": ".sidebar {"
      },
      {
        "from": "responsive-sidebar-min-height",
        "line": "  min-height: auto;"
      },
      {
        "from": "responsive-sidebar-min-height",
        "line": "}"
      }
    ]
  }
]
```
