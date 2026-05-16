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
    "from": "topbar-html",
    "target": "app-shell-content",
    "lines": [
      "  <header class=\"topbar\">",
      "    @@slot:topbar-content@@",
      "  </header>"
    ]
  },
  {
    "from": "logo-html",
    "target": "topbar-content",
    "lines": [
      "    <a href=\"#\" class=\"topbar-logo\">LOGOBAKERY</a>"
    ]
  },
  {
    "from": "nav-html",
    "target": "topbar-content",
    "lines": [
      "",
      "    <nav class=\"topbar-links\">",
      "      <a href=\"#\">Services</a>",
      "      <a href=\"#\">Projects</a>",
      "      <a href=\"#\">About</a>",
      "    </nav>"
    ]
  },
  {
    "from": "cta-html",
    "target": "topbar-content",
    "lines": [
      "",
      "    <a href=\"#\" class=\"topbar-cta\">Contact</a>"
    ]
  }
]
```
