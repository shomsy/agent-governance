# Template JS Timeline

```json
[
  {
    "from": "template-html-declaration",
    "target": "root",
    "lines": [
      "export const templateHtml = `",
      "  <article class=\"card\" part=\"card\">",
      "    <div class=\"popular-badge\" part=\"badge\">",
      "      <slot name=\"badge\">Most Popular</slot>",
      "    </div>",
      "",
      "    <h3 class=\"tier-name\" part=\"tier-name\"></h3>",
      "",
      "    <div class=\"price-block\" part=\"price-block\">",
      "      <span class=\"price-currency\">$</span>",
      "      <span class=\"price-amount\"></span>",
      "      <span class=\"price-period\">/mo</span>",
      "    </div>",
      "",
      "    <div class=\"billing-toggle\" part=\"billing-toggle\">",
      "      <span class=\"toggle-label\">Monthly</span>",
      "      <button class=\"toggle-switch\" type=\"button\" role=\"switch\" aria-checked=\"false\">",
      "        <span class=\"toggle-knob\"></span>",
      "      </button>",
      "      <span class=\"toggle-label\">Yearly <span class=\"save-badge\">Save 20%</span></span>",
      "    </div>",
      "",
      "    <div class=\"feature-list\" part=\"feature-list\">",
      "      <slot name=\"features\"></slot>",
      "    </div>",
      "",
      "    <button class=\"cta\" part=\"cta\" type=\"button\"></button>",
      "",
      "    <div class=\"urgency\" part=\"urgency\">",
      "      <span class=\"urgency-icon\">⏰</span>",
      "      <span class=\"urgency-text\"></span>",
      "    </div>",
      "  </article>",
      "`;",
      "",
      "@@slot:after-template-html@@"
    ]
  },
  {
    "from": "template-element-export",
    "target": "after-template-html",
    "lines": [
      "export const uiPricingCardTemplate = document.createElement('template');",
      "uiPricingCardTemplate.innerHTML = `",
      "  <link rel=\"stylesheet\" href=\"./ui-pricing-card.shadow.css\" />",
      "  ${templateHtml}",
      "`;"
    ]
  }
]
```
