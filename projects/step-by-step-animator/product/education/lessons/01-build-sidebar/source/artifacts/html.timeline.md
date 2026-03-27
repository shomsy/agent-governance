# HTML Timeline

```json
[
  {
    "from": "empty-shell",
    "target": "root",
    "lines": [
      "<div class=\"app-shell\">",
      "  @@slot:app-shell-content@@",
      "</div>"
    ]
  },
  {
    "from": "sidebar-html",
    "target": "app-shell-content",
    "lines": [
      "  <aside class=\"sidebar\">",
      "    @@slot:sidebar-content@@",
      "  </aside>"
    ]
  },
  {
    "from": "brand-html",
    "target": "sidebar-content",
    "lines": [
      "    <div class=\"sidebar-brand\">",
      "      @@slot:brand-content@@",
      "    </div>"
    ]
  },
  {
    "from": "logo-html",
    "target": "brand-content",
    "lines": [
      "      <div class=\"logo\">A</div>"
    ]
  },
  {
    "from": "brand-copy-html",
    "target": "brand-content",
    "lines": [
      "      <div class=\"brand-copy\">",
      "        <strong>AdminPro</strong>",
      "        <span>Dashboard</span>",
      "      </div>"
    ]
  },
  {
    "from": "nav-html",
    "target": "sidebar-content",
    "lines": [
      "",
      "    <nav class=\"nav-list\">",
      "      @@slot:nav-content@@",
      "    </nav>"
    ]
  },
  {
    "from": "nav-items-html",
    "target": "nav-content",
    "lines": [
      "      <a href=\"#\" class=\"nav-item active\"><span class=\"icon\">⌂</span><span class=\"label\">Overview</span></a>",
      "      <a href=\"#\" class=\"nav-item\"><span class=\"icon\">◫</span><span class=\"label\">Analytics</span></a>",
      "      <a href=\"#\" class=\"nav-item\"><span class=\"icon\">◧</span><span class=\"label\">Orders</span></a>",
      "      <a href=\"#\" class=\"nav-item\"><span class=\"icon\">◎</span><span class=\"label\">Customers</span></a>",
      "      <a href=\"#\" class=\"nav-item\"><span class=\"icon\">▣</span><span class=\"label\">Products</span></a>",
      "      <a href=\"#\" class=\"nav-item\"><span class=\"icon\">⚙</span><span class=\"label\">Settings</span></a>"
    ]
  },
  {
    "from": "footer-html",
    "target": "sidebar-content",
    "lines": [
      "",
      "    <div class=\"sidebar-footer\">",
      "      <strong>Pro Tip</strong>",
      "      <p>Sidebar nije samo lista linkova. On je layout zona sa ritmom, hijerarhijom i stanjima.</p>",
      "    </div>"
    ]
  }
]
```
