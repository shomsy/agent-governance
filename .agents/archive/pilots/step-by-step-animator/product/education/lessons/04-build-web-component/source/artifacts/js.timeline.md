# JS Timeline

```json
[
  {
    "from": "template-declaration",
    "target": "root",
    "lines": [
      "const myFirstComponentTemplate = document.createElement('template');",
      "@@slot:after-template-declaration@@"
    ]
  },
  {
    "from": "template-markup-open",
    "target": "after-template-declaration",
    "lines": [
      "",
      "myFirstComponentTemplate.innerHTML = `",
      "  <style>",
      "    @@slot:template-style-rules@@",
      "  </style>",
      "  @@slot:template-markup@@",
      "`;",
      "@@slot:after-template-markup@@"
    ]
  },
  {
    "from": "host-font",
    "target": "template-style-rules",
    "lines": [
      "    :host {",
      "      font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, \"Segoe UI\", sans-serif;",
      "      @@slot:host-style-body@@",
      "    }"
    ]
  },
  {
    "from": "host-color",
    "target": "host-style-body",
    "lines": [
      "      color: var(--callout-text, #e2e8f0);"
    ]
  },
  {
    "from": "card-outline",
    "target": "template-style-rules",
    "lines": [
      "",
      "    .card {",
      "      outline: 1px dashed #38bdf8;",
      "      @@slot:card-style-body@@",
      "      @@slot:card-summary-comment@@",
      "    }"
    ]
  },
  {
    "from": "card-display",
    "target": "card-style-body",
    "lines": [
      "      display: grid;"
    ]
  },
  {
    "from": "card-gap",
    "target": "card-style-body",
    "lines": [
      "      gap: 16px;"
    ]
  },
  {
    "from": "card-padding",
    "target": "card-style-body",
    "lines": [
      "      padding: 24px;"
    ]
  },
  {
    "from": "card-radius",
    "target": "card-style-body",
    "lines": [
      "      border-radius: 28px;"
    ]
  },
  {
    "from": "card-border",
    "target": "card-style-body",
    "lines": [
      "      border: 1px solid var(--callout-border, rgba(148,163,184,0.24));"
    ]
  },
  {
    "from": "card-background",
    "target": "card-style-body",
    "lines": [
      "      background: linear-gradient(",
      "        180deg,",
      "        var(--callout-surface, rgba(15, 23, 42, 0.98)),",
      "        var(--callout-surface-alt, rgba(15, 23, 42, 0.92))",
      "      );"
    ]
  },
  {
    "from": "card-shadow",
    "target": "card-style-body",
    "lines": [
      "      box-shadow: var(--callout-shadow, 0 26px 60px rgba(15, 23, 42, 0.24));"
    ]
  },
  {
    "from": "card-summary",
    "target": "card-summary-comment",
    "lines": [
      "      /* helper outline removed in final .card summary */"
    ]
  },
  {
    "from": "eyebrow-outline",
    "target": "template-style-rules",
    "lines": [
      "",
      "    .eyebrow {",
      "      outline: 1px dotted #facc15;",
      "      @@slot:eyebrow-style-body@@",
      "      @@slot:eyebrow-summary-comment@@",
      "    }"
    ]
  },
  {
    "from": "eyebrow-display",
    "target": "eyebrow-style-body",
    "lines": [
      "      display: inline-flex;"
    ]
  },
  {
    "from": "eyebrow-align-items",
    "target": "eyebrow-style-body",
    "lines": [
      "      align-items: center;"
    ]
  },
  {
    "from": "eyebrow-justify-content",
    "target": "eyebrow-style-body",
    "lines": [
      "      justify-content: center;"
    ]
  },
  {
    "from": "eyebrow-width",
    "target": "eyebrow-style-body",
    "lines": [
      "      width: fit-content;"
    ]
  },
  {
    "from": "eyebrow-padding",
    "target": "eyebrow-style-body",
    "lines": [
      "      padding: 8px 12px;"
    ]
  },
  {
    "from": "eyebrow-radius",
    "target": "eyebrow-style-body",
    "lines": [
      "      border-radius: 999px;"
    ]
  },
  {
    "from": "eyebrow-background",
    "target": "eyebrow-style-body",
    "lines": [
      "      background: rgba(56,189,248,0.14);"
    ]
  },
  {
    "from": "eyebrow-color",
    "target": "eyebrow-style-body",
    "lines": [
      "      color: var(--callout-accent, #38bdf8);"
    ]
  },
  {
    "from": "eyebrow-font-size",
    "target": "eyebrow-style-body",
    "lines": [
      "      font-size: 12px;"
    ]
  },
  {
    "from": "eyebrow-font-weight",
    "target": "eyebrow-style-body",
    "lines": [
      "      font-weight: 700;"
    ]
  },
  {
    "from": "eyebrow-letter-spacing",
    "target": "eyebrow-style-body",
    "lines": [
      "      letter-spacing: 0.04em;"
    ]
  },
  {
    "from": "eyebrow-text-transform",
    "target": "eyebrow-style-body",
    "lines": [
      "      text-transform: uppercase;"
    ]
  },
  {
    "from": "eyebrow-summary",
    "target": "eyebrow-summary-comment",
    "lines": [
      "      /* helper outline removed in final .eyebrow summary */"
    ]
  },
  {
    "from": "title-display",
    "target": "template-style-rules",
    "lines": [
      "",
      "    .title {",
      "      display: block;",
      "      @@slot:title-style-body@@",
      "    }"
    ]
  },
  {
    "from": "title-margin",
    "target": "title-style-body",
    "lines": [
      "      margin: 0;"
    ]
  },
  {
    "from": "title-font-size",
    "target": "title-style-body",
    "lines": [
      "      font-size: clamp(1.75rem, 4vw, 2rem);"
    ]
  },
  {
    "from": "title-line-height",
    "target": "title-style-body",
    "lines": [
      "      line-height: 1.1;"
    ]
  },
  {
    "from": "title-font-weight",
    "target": "title-style-body",
    "lines": [
      "      font-weight: 800;"
    ]
  },
  {
    "from": "summary-margin",
    "target": "template-style-rules",
    "lines": [
      "",
      "    .summary {",
      "      margin: 0;",
      "      @@slot:summary-style-body@@",
      "    }"
    ]
  },
  {
    "from": "summary-color",
    "target": "summary-style-body",
    "lines": [
      "      color: var(--callout-muted, #cbd5e1);"
    ]
  },
  {
    "from": "summary-line-height",
    "target": "summary-style-body",
    "lines": [
      "      line-height: 1.65;"
    ]
  },
  {
    "from": "cta-outline",
    "target": "template-style-rules",
    "lines": [
      "",
      "    .cta {",
      "      outline: 1px dashed #34d399;",
      "      @@slot:cta-style-body@@",
      "      @@slot:cta-summary-comment@@",
      "    }"
    ]
  },
  {
    "from": "cta-justify-self",
    "target": "cta-style-body",
    "lines": [
      "      justify-self: start;"
    ]
  },
  {
    "from": "cta-appearance",
    "target": "cta-style-body",
    "lines": [
      "      appearance: none;"
    ]
  },
  {
    "from": "cta-padding",
    "target": "cta-style-body",
    "lines": [
      "      padding: 12px 16px;"
    ]
  },
  {
    "from": "cta-border",
    "target": "cta-style-body",
    "lines": [
      "      border: 0;"
    ]
  },
  {
    "from": "cta-radius",
    "target": "cta-style-body",
    "lines": [
      "      border-radius: 999px;"
    ]
  },
  {
    "from": "cta-background",
    "target": "cta-style-body",
    "lines": [
      "      background: linear-gradient(",
      "        135deg,",
      "        var(--callout-accent, #38bdf8),",
      "        var(--callout-accent-strong, #2563eb)",
      "      );"
    ]
  },
  {
    "from": "cta-color",
    "target": "cta-style-body",
    "lines": [
      "      color: #ffffff;"
    ]
  },
  {
    "from": "cta-font",
    "target": "cta-style-body",
    "lines": [
      "      font: inherit;"
    ]
  },
  {
    "from": "cta-font-weight",
    "target": "cta-style-body",
    "lines": [
      "      font-weight: 700;"
    ]
  },
  {
    "from": "cta-cursor",
    "target": "cta-style-body",
    "lines": [
      "      cursor: pointer;"
    ]
  },
  {
    "from": "cta-transition",
    "target": "cta-style-body",
    "lines": [
      "      transition: transform 160ms ease, filter 160ms ease, box-shadow 160ms ease;"
    ]
  },
  {
    "from": "cta-box-shadow",
    "target": "cta-style-body",
    "lines": [
      "      box-shadow: 0 14px 30px rgba(37, 99, 235, 0.28);"
    ]
  },
  {
    "from": "cta-summary",
    "target": "cta-summary-comment",
    "lines": [
      "      /* helper outline removed in final .cta summary */"
    ]
  },
  {
    "from": "cta-hover-filter",
    "target": "template-style-rules",
    "lines": [
      "",
      "    .cta:hover {",
      "      filter: brightness(1.06);",
      "      @@slot:cta-hover-body@@",
      "    }"
    ]
  },
  {
    "from": "cta-hover-transform",
    "target": "cta-hover-body",
    "lines": [
      "      transform: translateY(-1px);"
    ]
  },
  {
    "from": "cta-active-transform",
    "target": "template-style-rules",
    "lines": [
      "",
      "    .cta:active {",
      "      transform: translateY(0);",
      "    }"
    ]
  },
  {
    "from": "cta-focus-outline",
    "target": "template-style-rules",
    "lines": [
      "",
      "    .cta:focus-visible {",
      "      outline: 3px solid rgba(56, 189, 248, 0.45);",
      "      @@slot:cta-focus-body@@",
      "    }"
    ]
  },
  {
    "from": "cta-focus-outline-offset",
    "target": "cta-focus-body",
    "lines": [
      "      outline-offset: 3px;"
    ]
  },
  {
    "from": "card-markup",
    "target": "template-markup",
    "lines": [
      "",
      "  <article class=\"card\" part=\"card\">",
      "    <span class=\"eyebrow\" part=\"eyebrow\">",
      "      <slot name=\"eyebrow\">Vanilla JS</slot>",
      "    </span>",
      "",
      "    <h2 class=\"title\" part=\"title\"></h2>",
      "",
      "    <p class=\"summary\" part=\"summary\">",
      "      <slot>Dodaj opis komponente kroz default slot.</slot>",
      "    </p>",
      "",
      "    <button class=\"cta\" part=\"cta\" type=\"button\"></button>",
      "  </article>"
    ]
  },
  {
    "from": "class-declaration",
    "target": "after-template-markup",
    "lines": [
      "",
      "class MyFirstComponent extends HTMLElement {",
      "  @@slot:class-head@@",
      "  @@slot:class-body@@",
      "}",
      "",
      "@@slot:after-class@@"
    ]
  },
  {
    "from": "observed-attributes",
    "target": "class-head",
    "lines": [
      "  static observedAttributes = ['title', 'cta-label'];",
      ""
    ]
  },
  {
    "from": "constructor-shadow",
    "target": "class-body",
    "lines": [
      "  constructor() {",
      "    super();",
      "    const shadowRoot = this.attachShadow({ mode: 'open' });",
      "    @@slot:constructor-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "constructor-clone",
    "target": "constructor-body",
    "lines": [
      "    shadowRoot.appendChild(myFirstComponentTemplate.content.cloneNode(true));"
    ]
  },
  {
    "from": "constructor-cache-title",
    "target": "constructor-body",
    "lines": [
      "    this.titleElement = shadowRoot.querySelector('.title');"
    ]
  },
  {
    "from": "constructor-cache-cta",
    "target": "constructor-body",
    "lines": [
      "    this.ctaElement = shadowRoot.querySelector('.cta');"
    ]
  },
  {
    "from": "constructor-bind-click",
    "target": "constructor-body",
    "lines": [
      "    this.handleClick = this.handleClick.bind(this);"
    ]
  },
  {
    "from": "render-declaration",
    "target": "class-body",
    "lines": [
      "  render() {",
      "    @@slot:render-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "render-title",
    "target": "render-body",
    "lines": [
      "    this.titleElement.textContent = this.getAttribute('title') || 'Naslov komponente';"
    ]
  },
  {
    "from": "render-cta",
    "target": "render-body",
    "lines": [
      "    this.ctaElement.textContent = this.getAttribute('cta-label') || 'Saznaj više';"
    ]
  },
  {
    "from": "connected-callback",
    "target": "class-body",
    "lines": [
      "  connectedCallback() {",
      "    @@slot:connected-callback-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "connected-callback-render",
    "target": "connected-callback-body",
    "lines": [
      "    this.render();"
    ]
  },
  {
    "from": "connected-callback-listener",
    "target": "connected-callback-body",
    "lines": [
      "    this.ctaElement.addEventListener('click', this.handleClick);"
    ]
  },
  {
    "from": "disconnected-callback",
    "target": "class-body",
    "lines": [
      "  disconnectedCallback() {",
      "    this.ctaElement.removeEventListener('click', this.handleClick);",
      "  }",
      ""
    ]
  },
  {
    "from": "attribute-changed-callback",
    "target": "class-body",
    "lines": [
      "  attributeChangedCallback() {",
      "    if (this.isConnected) {",
      "      this.render();",
      "    }",
      "  }",
      ""
    ]
  },
  {
    "from": "handle-click-dispatch-event",
    "target": "class-body",
    "lines": [
      "  handleClick() {",
      "    this.dispatchEvent(",
      "      new CustomEvent('component-action', {",
      "        bubbles: true,",
      "        composed: true,",
      "        detail: {",
      "          title: this.getAttribute('title') || 'Naslov komponente',",
      "          ctaLabel: this.getAttribute('cta-label') || 'Saznaj više'",
      "        }",
      "      })",
      "    );",
      "  }"
    ]
  },
  {
    "from": "define-guard",
    "target": "after-class",
    "lines": [
      "if (!customElements.get('my-first-component')) {",
      "  @@slot:define-body@@",
      "}"
    ]
  },
  {
    "from": "define-element",
    "target": "define-body",
    "lines": [
      "  customElements.define('my-first-component', MyFirstComponent);"
    ]
  }
]
```
