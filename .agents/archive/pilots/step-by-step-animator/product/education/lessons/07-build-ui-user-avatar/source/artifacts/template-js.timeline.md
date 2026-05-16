# Template JS Timeline

```json
[
  {
    "from": "template-html-declaration",
    "target": "root",
    "lines": [
      "export const templateHtml = `",
      "  <div class=\"avatar-container\">",
      "    <div class=\"avatar-image\">",
      "      <slot name=\"initials\"></slot>",
      "    </div>",
      "    <div class=\"status-badge\" role=\"img\" aria-label=\"Status\"></div>",
      "    <div class=\"avatar-info\">",
      "      <span class=\"username\"></span>",
      "      <span class=\"role\"></span>",
      "    </div>",
      "    <div class=\"tooltip\" role=\"tooltip\">",
      "      <slot name=\"tooltip\"></slot>",
      "    </div>",
      "  </div>",
      "`;",
      "",
      "@@slot:after-template-html@@"
    ]
  },
  {
    "from": "template-element-export",
    "target": "after-template-html",
    "lines": [
      "export const uiUserAvatarTemplate = document.createElement('template');",
      "uiUserAvatarTemplate.innerHTML = `",
      "  <link rel=\"stylesheet\" href=\"./ui-user-avatar.shadow.css\" />",
      "  ${templateHtml}",
      "`;"
    ]
  }
]
```
