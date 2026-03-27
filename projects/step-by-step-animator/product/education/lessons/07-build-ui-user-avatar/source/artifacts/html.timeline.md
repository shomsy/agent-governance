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
    "from": "component-html",
    "target": "app-shell-content",
    "lines": [
      "  <ui-user-avatar",
      "    username=\"Ana Petrović\"",
      "    role=\"Frontend Lead\"",
      "    @@slot:avatar-attributes@@",
      "  >",
      "    @@slot:avatar-slots@@",
      "  </ui-user-avatar>"
    ]
  },
  {
    "from": "status-attribute-html",
    "target": "avatar-attributes",
    "lines": [
      "    status=\"online\""
    ]
  },
  {
    "from": "profile-url-attribute-html",
    "target": "avatar-attributes",
    "lines": [
      "    profile-url=\"/team/ana-petrovic\""
    ]
  },
  {
    "from": "initials-slot-html",
    "target": "avatar-slots",
    "lines": [
      "    <span slot=\"initials\">AP</span>"
    ]
  },
  {
    "from": "tooltip-slot-html",
    "target": "avatar-slots",
    "lines": [
      "    <span slot=\"tooltip\">Ana Petrović · Frontend Lead · Dostupna</span>"
    ]
  }
]
```
