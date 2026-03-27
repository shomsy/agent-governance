# JS Timeline

```json
[
  {
    "from": "shadow-css-import",
    "target": "root",
    "lines": [
      "import shadowDomStyleCssText from './shadow-dom-style.css?raw';",
      ""
    ]
  },
  {
    "from": "template-declaration",
    "target": "root",
    "lines": [
      "const myFirstComponentTemplate = document.createElement('template');",
      "@@slot:after-template-declaration@@"
    ]
  },
  {
    "from": "stylesheet-declaration",
    "target": "after-template-declaration",
    "lines": [
      "",
      "const myFirstComponentStyles = new CSSStyleSheet();",
      "@@slot:after-stylesheet-declaration@@"
    ]
  },
  {
    "from": "stylesheet-replace-sync",
    "target": "after-stylesheet-declaration",
    "lines": [
      "",
      "myFirstComponentStyles.replaceSync(shadowDomStyleCssText);",
      "@@slot:after-stylesheet-replace-sync@@"
    ]
  },
  {
    "from": "template-markup-open",
    "target": "after-stylesheet-replace-sync",
    "lines": [
      "",
      "myFirstComponentTemplate.innerHTML = `",
      "  @@slot:template-markup@@",
      "`;",
      "@@slot:after-template-markup@@"
    ]
  },
  {
    "from": "card-markup",
    "target": "template-markup",
    "lines": [
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
    "from": "constructor-adopt-stylesheet",
    "target": "constructor-body",
    "lines": [
      "    shadowRoot.adoptedStyleSheets = [myFirstComponentStyles];"
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
