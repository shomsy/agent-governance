# JS Timeline

```json
[
  {
    "from": "class-declaration",
    "target": "root",
    "lines": [
      "class MyFirstComponent extends HTMLElement {",
      "  @@slot:class-body@@",
      "}",
      "",
      "@@slot:after-class@@"
    ]
  },
  {
    "from": "connected-callback",
    "target": "class-body",
    "lines": [
      "  connectedCallback() {",
      "    @@slot:connected-body@@",
      "  }"
    ]
  },
  {
    "from": "read-title-attribute",
    "target": "connected-body",
    "lines": [
      "    const title = this.getAttribute('title') || 'Naslov komponente';"
    ]
  },
  {
    "from": "read-cta-attribute",
    "target": "connected-body",
    "lines": [
      "    const ctaLabel = this.getAttribute('cta-label') || 'Saznaj više';"
    ]
  },
  {
    "from": "render-inner-html",
    "target": "connected-body",
    "lines": [
      "    this.innerHTML = `",
      "      <article class=\"card\">",
      "        <span class=\"eyebrow\">Custom element</span>",
      "        <strong class=\"title\">${title}</strong>",
      "        <p class=\"summary\">Light DOM verzija nam prvo objašnjava registraciju, atribut API i render bez shadow DOM sloja.</p>",
      "        <button class=\"cta\" type=\"button\">${ctaLabel}</button>",
      "      </article>",
      "    `;"
    ]
  },
  {
    "from": "define-element",
    "target": "after-class",
    "lines": [
      "if (!customElements.get('my-first-component')) {",
      "  customElements.define('my-first-component', MyFirstComponent);",
      "}"
    ]
  }
]
```
