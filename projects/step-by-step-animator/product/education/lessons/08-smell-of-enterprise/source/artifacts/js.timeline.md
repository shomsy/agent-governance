# JS Timeline

```json
[
  {
    "from": "import-template",
    "target": "root",
    "lines": [
      "import { uiPricingCardTemplate } from './ui-pricing-card.template.js';",
      "@@slot:after-import-template@@"
    ]
  },
  {
    "from": "normalize-text-helper",
    "target": "after-import-template",
    "lines": [
      "",
      "function normalizeTextValue(value, fallback) {",
      "  return String(value ?? '').trim() || fallback;",
      "}",
      "",
      "@@slot:after-normalize-text@@"
    ]
  },
  {
    "from": "allowed-tiers-set",
    "target": "after-normalize-text",
    "lines": [
      "const allowedTiers = new Set(['starter', 'pro', 'enterprise']);",
      "",
      "@@slot:after-allowed-tiers@@"
    ]
  },
  {
    "from": "normalize-tier-helper",
    "target": "after-allowed-tiers",
    "lines": [
      "function normalizeTierValue(value) {",
      "  const v = String(value ?? '').trim().toLowerCase();",
      "  return allowedTiers.has(v) ? v : 'starter';",
      "}",
      "",
      "@@slot:after-normalize-tier@@"
    ]
  },
  {
    "from": "parse-price-helper",
    "target": "after-normalize-tier",
    "lines": [
      "function parsePriceValue(value) {",
      "  const parsed = parseFloat(value);",
      "  return Number.isFinite(parsed) && parsed >= 0 ? parsed : 0;",
      "}",
      "",
      "@@slot:after-parse-price@@"
    ]
  },
  {
    "from": "format-time-helper",
    "target": "after-parse-price",
    "lines": [
      "function formatTimeRemaining(totalSeconds) {",
      "  const hours = Math.floor(totalSeconds / 3600);",
      "  const minutes = Math.floor((totalSeconds % 3600) / 60);",
      "  const seconds = totalSeconds % 60;",
      "  const pad = (n) => String(n).padStart(2, '0');",
      "  return `${pad(hours)}:${pad(minutes)}:${pad(seconds)}`;",
      "}",
      "",
      "@@slot:after-format-time@@"
    ]
  },
  {
    "from": "tier-display-map",
    "target": "after-format-time",
    "lines": [
      "const tierDisplayName = {",
      "  starter: 'Starter',",
      "  pro: 'Pro',",
      "  enterprise: 'Enterprise'",
      "};",
      "",
      "@@slot:after-tier-display@@"
    ]
  },
  {
    "from": "class-declaration",
    "target": "after-tier-display",
    "lines": [
      "class UiPricingCard extends HTMLElement {",
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
      "  static observedAttributes = [",
      "    'tier',",
      "    'price-monthly',",
      "    'price-yearly',",
      "    'billing',",
      "    'popular', // CSS-only reactive attribute",
      "    'cta-label'",
      "  ];",
      ""
    ]
  },
  {
    "from": "constructor-shadow",
    "target": "class-body",
    "lines": [
      "  constructor() {",
      "    super();",
      "    this.attachShadow({ mode: 'open' });",
      "    @@slot:constructor-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "constructor-bind",
    "target": "constructor-body",
    "lines": [
      "    this.handleCtaClick = this.handleCtaClick.bind(this);",
      "    this.handleToggleClick = this.handleToggleClick.bind(this);"
    ]
  },
  {
    "from": "constructor-state",
    "target": "constructor-body",
    "lines": [
      "    this.tierNameElement = null;",
      "    this.priceAmountElement = null;",
      "    this.pricePeriodElement = null;",
      "    this.ctaElement = null;",
      "    this.toggleSwitchElement = null;",
      "    this.urgencyTextElement = null;",
      "    this.isCtaBound = false;",
      "    this.isToggleBound = false;",
      "    this.urgencyTimerId = null;",
      "    this.urgencyRemaining = 3600;"
    ]
  },
  {
    "from": "connected-callback",
    "target": "class-body",
    "lines": [
      "  connectedCallback() {",
      "    @@slot:connected-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "connected-callback-setup",
    "target": "connected-body",
    "lines": [
      "    this.setupTemplateOnce();"
    ]
  },
  {
    "from": "connected-callback-cache",
    "target": "connected-body",
    "lines": [
      "    this.cacheDom();"
    ]
  },
  {
    "from": "connected-callback-sync",
    "target": "connected-body",
    "lines": [
      "    this.syncFromAttributes();"
    ]
  },
  {
    "from": "connected-callback-bind",
    "target": "connected-body",
    "lines": [
      "    this.bindEvents();"
    ]
  },
  {
    "from": "connected-callback-urgency",
    "target": "connected-body",
    "lines": [
      "    this.startUrgencyTimer();"
    ]
  },
  {
    "from": "disconnected-callback",
    "target": "class-body",
    "lines": [
      "  disconnectedCallback() {",
      "    this.unbindEvents();",
      "    this.stopUrgencyTimer();",
      "  }",
      ""
    ]
  },
  {
    "from": "attribute-changed-callback",
    "target": "class-body",
    "lines": [
      "  attributeChangedCallback(name, oldValue, newValue) {",
      "    @@slot:attribute-changed-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "attribute-changed-guard",
    "target": "attribute-changed-body",
    "lines": [
      "    if (oldValue === newValue || !this.isConnected) {",
      "      return;",
      "    }",
      "",
      "    @@slot:attribute-switch-body@@"
    ]
  },
  {
    "from": "attribute-changed-switch",
    "target": "attribute-switch-body",
    "lines": [
      "    switch (name) {",
      "      case 'tier':",
      "        // visual title + CTA accessibility text both depend on tier",
      "        this.updateTierName();",
      "        this.updateCtaLabel();",
      "        break;",
      "      case 'price-monthly':",
      "      case 'price-yearly':",
      "      case 'billing':",
      "        // price amount, price period, and switch state depend on billing",
      "        this.updatePrice();",
      "        this.updateToggleState();",
      "        break;",
      "      case 'cta-label':",
      "        this.updateCtaLabel();",
      "        break;",
      "      case 'popular':",
      "        // CSS-only reactive attribute, no JS update needed",
      "        break;",
      "      default:",
      "        break;",
      "    }"
    ]
  },
  {
    "from": "property-tier-getter",
    "target": "class-body",
    "lines": [
      "  get tier() {",
      "    return normalizeTierValue(this.getAttribute('tier'));",
      "  }",
      ""
    ]
  },
  {
    "from": "property-tier-setter",
    "target": "class-body",
    "lines": [
      "  set tier(value) {",
      "    this.setAttribute('tier', normalizeTierValue(value));",
      "  }",
      ""
    ]
  },
  {
    "from": "property-price-monthly-getter",
    "target": "class-body",
    "lines": [
      "  get priceMonthly() {",
      "    return parsePriceValue(this.getAttribute('price-monthly'));",
      "  }",
      ""
    ]
  },
  {
    "from": "property-price-yearly-getter",
    "target": "class-body",
    "lines": [
      "  get priceYearly() {",
      "    return parsePriceValue(this.getAttribute('price-yearly'));",
      "  }",
      ""
    ]
  },
  {
    "from": "property-billing-getter",
    "target": "class-body",
    "lines": [
      "  get billing() {",
      "    const v = String(this.getAttribute('billing') ?? '').trim().toLowerCase();",
      "    return v === 'yearly' ? 'yearly' : 'monthly';",
      "  }",
      ""
    ]
  },
  {
    "from": "property-billing-setter",
    "target": "class-body",
    "lines": [
      "  set billing(value) {",
      "    this.setAttribute('billing', value === 'yearly' ? 'yearly' : 'monthly');",
      "  }",
      ""
    ]
  },
  {
    "from": "property-popular-getter",
    "target": "class-body",
    "lines": [
      "  get popular() {",
      "    return this.hasAttribute('popular');",
      "  }",
      ""
    ]
  },
  {
    "from": "property-cta-label-getter",
    "target": "class-body",
    "lines": [
      "  get ctaLabel() {",
      "    return normalizeTextValue(this.getAttribute('cta-label'), 'Get started');",
      "  }",
      "",
      "@@slot:after-property-cta-label@@"
    ]
  },
  {
    "from": "derived_state_getters",
    "target": "after-property-cta-label",
    "lines": [
      "  get isYearlyBilling() {",
      "    return this.billing === 'yearly';",
      "  }",
      "",
      "  get currentPrice() {",
      "    return this.isYearlyBilling ? this.priceYearly : this.priceMonthly;",
      "  }",
      "",
      "  get currentPricePeriodLabel() {",
      "    return this.isYearlyBilling ? '/yr' : '/mo';",
      "  }",
      ""
    ]
  },
  {
    "from": "setup-template-once",
    "target": "class-body",
    "lines": [
      "  setupTemplateOnce() {",
      "    @@slot:setup-template-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "setup-template-once-guard",
    "target": "setup-template-body",
    "lines": [
      "    if (!this.shadowRoot.hasChildNodes()) {",
      "      this.shadowRoot.appendChild(uiPricingCardTemplate.content.cloneNode(true));",
      "    }"
    ]
  },
  {
    "from": "cache-dom",
    "target": "class-body",
    "lines": [
      "  cacheDom() {",
      "    @@slot:cache-dom-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "cache-dom-tier-name",
    "target": "cache-dom-body",
    "lines": [
      "    if (!this.tierNameElement) {",
      "      this.tierNameElement = this.shadowRoot.querySelector('.tier-name');",
      "    }",
      ""
    ]
  },
  {
    "from": "cache-dom-price-amount",
    "target": "cache-dom-body",
    "lines": [
      "    if (!this.priceAmountElement) {",
      "      this.priceAmountElement = this.shadowRoot.querySelector('.price-amount');",
      "    }",
      ""
    ]
  },
  {
    "from": "cache-dom-price-period",
    "target": "cache-dom-body",
    "lines": [
      "    if (!this.pricePeriodElement) {",
      "      this.pricePeriodElement = this.shadowRoot.querySelector('.price-period');",
      "    }",
      ""
    ]
  },
  {
    "from": "cache-dom-cta",
    "target": "cache-dom-body",
    "lines": [
      "    if (!this.ctaElement) {",
      "      this.ctaElement = this.shadowRoot.querySelector('.cta');",
      "    }",
      ""
    ]
  },
  {
    "from": "cache-dom-toggle",
    "target": "cache-dom-body",
    "lines": [
      "    if (!this.toggleSwitchElement) {",
      "      this.toggleSwitchElement = this.shadowRoot.querySelector('.toggle-switch');",
      "    }",
      ""
    ]
  },
  {
    "from": "cache-dom-urgency",
    "target": "cache-dom-body",
    "lines": [
      "    if (!this.urgencyTextElement) {",
      "      this.urgencyTextElement = this.shadowRoot.querySelector('.urgency-text');",
      "    }"
    ]
  },
  {
    "from": "sync-from-attributes",
    "target": "class-body",
    "lines": [
      "  syncFromAttributes() {",
      "    @@slot:sync-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "sync-from-attributes-calls",
    "target": "sync-body",
    "lines": [
      "    this.updateTierName();",
      "    this.updatePrice();",
      "    this.updateToggleState();",
      "    this.updateCtaLabel();"
    ]
  },
  {
    "from": "update-tier-name",
    "target": "class-body",
    "lines": [
      "  updateTierName() {",
      "    if (!this.tierNameElement) {",
      "      return;",
      "    }",
      "",
      "    this.tierNameElement.textContent = tierDisplayName[this.tier] || 'Starter';",
      "  }",
      ""
    ]
  },
  {
    "from": "update-price",
    "target": "class-body",
    "lines": [
      "  updatePrice() {",
      "    if (!this.priceAmountElement || !this.pricePeriodElement) {",
      "      return;",
      "    }",
      "",
      "    this.priceAmountElement.textContent = this.currentPrice;",
      "    this.pricePeriodElement.textContent = this.currentPricePeriodLabel;",
      "  }",
      ""
    ]
  },
  {
    "from": "update-cta-label",
    "target": "class-body",
    "lines": [
      "  updateCtaLabel() {",
      "    if (!this.ctaElement) {",
      "      return;",
      "    }",
      "",
      "    this.ctaElement.textContent = this.ctaLabel;",
      "    this.ctaElement.setAttribute('aria-label', `${this.ctaLabel}: ${tierDisplayName[this.tier] || 'Starter'} plan`);",
      "  }",
      ""
    ]
  },
  {
    "from": "update-toggle-state",
    "target": "class-body",
    "lines": [
      "  updateToggleState() {",
      "    if (!this.toggleSwitchElement) {",
      "      return;",
      "    }",
      "",
      "    const isYearly = this.isYearlyBilling;",
      "    this.toggleSwitchElement.setAttribute('aria-checked', String(isYearly));",
      "    this.toggleSwitchElement.setAttribute('aria-label', isYearly ? 'Switch to monthly billing' : 'Switch to yearly billing');",
      "  }",
      ""
    ]
  },
  {
    "from": "start-urgency-timer",
    "target": "class-body",
    "lines": [
      "  startUrgencyTimer() {",
      "    if (this.urgencyTimerId !== null) {",
      "      return;",
      "    }",
      "",
      "    this.updateUrgencyDisplay();",
      "",
      "    this.urgencyTimerId = setInterval(() => {",
      "      if (this.urgencyRemaining <= 0) {",
      "        this.stopUrgencyTimer();",
      "        return;",
      "      }",
      "",
      "      this.urgencyRemaining -= 1;",
      "      this.updateUrgencyDisplay();",
      "    }, 1000);",
      "  }",
      ""
    ]
  },
  {
    "from": "stop-urgency-timer",
    "target": "class-body",
    "lines": [
      "  stopUrgencyTimer() {",
      "    if (this.urgencyTimerId !== null) {",
      "      clearInterval(this.urgencyTimerId);",
      "      this.urgencyTimerId = null;",
      "    }",
      "  }",
      ""
    ]
  },
  {
    "from": "update-urgency-display",
    "target": "class-body",
    "lines": [
      "  updateUrgencyDisplay() {",
      "    if (!this.urgencyTextElement) {",
      "      return;",
      "    }",
      "",
      "    this.urgencyTextElement.textContent = `Offer ends in ${formatTimeRemaining(this.urgencyRemaining)}`;",
      "  }",
      ""
    ]
  },
  {
    "from": "bind-events",
    "target": "class-body",
    "lines": [
      "  bindEvents() {",
      "    @@slot:bind-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "bind-cta-event",
    "target": "bind-body",
    "lines": [
      "    if (this.ctaElement && !this.isCtaBound) {",
      "      this.ctaElement.addEventListener('click', this.handleCtaClick);",
      "      this.isCtaBound = true;",
      "    }",
      ""
    ]
  },
  {
    "from": "bind-toggle-event",
    "target": "bind-body",
    "lines": [
      "    if (this.toggleSwitchElement && !this.isToggleBound) {",
      "      this.toggleSwitchElement.addEventListener('click', this.handleToggleClick);",
      "      this.isToggleBound = true;",
      "    }"
    ]
  },
  {
    "from": "unbind-events",
    "target": "class-body",
    "lines": [
      "  unbindEvents() {",
      "    @@slot:unbind-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "unbind-cta-event",
    "target": "unbind-body",
    "lines": [
      "    if (this.ctaElement && this.isCtaBound) {",
      "      this.ctaElement.removeEventListener('click', this.handleCtaClick);",
      "      this.isCtaBound = false;",
      "    }",
      ""
    ]
  },
  {
    "from": "unbind-toggle-event",
    "target": "unbind-body",
    "lines": [
      "    if (this.toggleSwitchElement && this.isToggleBound) {",
      "      this.toggleSwitchElement.removeEventListener('click', this.handleToggleClick);",
      "      this.isToggleBound = false;",
      "    }"
    ]
  },
  {
    "from": "handle-cta-click",
    "target": "class-body",
    "lines": [
      "  handleCtaClick() {",
      "    @@slot:cta-click-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "handle-cta-click-event",
    "target": "cta-click-body",
    "lines": [
      "    this.dispatchEvent(",
      "      new CustomEvent('ui-pricing-card:subscribe', {",
      "        bubbles: true,",
      "        composed: true,",
      "        cancelable: true,",
      "        detail: {",
      "          tier: this.tier,",
      "          price: this.currentPrice,",
      "          billing: this.billing,",
      "          ctaLabel: this.ctaLabel,",
      "          source: 'ui-pricing-card'",
      "        }",
      "      })",
      "    );"
    ]
  },
  {
    "from": "handle-toggle-click",
    "target": "class-body",
    "lines": [
      "  handleToggleClick() {",
      "    this.billing = this.billing === 'yearly' ? 'monthly' : 'yearly';",
      "  }",
      ""
    ]
  },
  {
    "from": "define-guard",
    "target": "after-class",
    "lines": [
      "if (!customElements.get('ui-pricing-card')) {",
      "  @@slot:define-body@@",
      "}"
    ]
  },
  {
    "from": "define-element",
    "target": "define-body",
    "lines": [
      "  customElements.define('ui-pricing-card', UiPricingCard);"
    ]
  }
]
```
