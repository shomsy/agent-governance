# JS Timeline

```json
[
  {
    "from": "import-template",
    "target": "root",
    "lines": [
      "import { uiUserAvatarTemplate } from './ui-user-avatar.template.js';",
      "@@slot:after-import-template@@"
    ]
  },
  {
    "from": "class-declaration",
    "target": "after-import-template",
    "lines": [
      "class UiUserAvatar extends HTMLElement {",
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
      "  static observedAttributes = ['username', 'role', 'status', 'profile-url'];",
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
      "    this.handleAvatarClick = this.handleAvatarClick.bind(this);"
    ]
  },
  {
    "from": "constructor-state",
    "target": "constructor-body",
    "lines": [
      "    this.usernameElement = null;",
      "    this.roleElement = null;",
      "    this.statusBadgeElement = null;",
      "    this.isClickBound = false;"
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
      "    this.bindEvents();",
      "    @@slot:after-connected-callback-bind@@"
    ]
  },
  {
    "from": "normalize-text-helper",
    "target": "after-connected-callback-bind",
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
    "from": "allowed-statuses-set",
    "target": "after-normalize-text",
    "lines": [
      "const allowedStatuses = new Set(['online', 'idle', 'away', 'offline']);",
      "",
      "@@slot:after-allowed-statuses@@"
    ]
  },
  {
    "from": "normalize-status-helper",
    "target": "after-allowed-statuses",
    "lines": [
      "function normalizeStatusValue(value) {",
      "  const v = String(value ?? '').trim().toLowerCase();",
      "  return allowedStatuses.has(v) ? v : 'offline';",
      "}",
      "",
      "@@slot:after-normalize-status@@"
    ]
  },
  {
    "from": "status-label-map",
    "target": "after-normalize-status",
    "lines": [
      "const statusAriaLabel = {",
      "  online: 'Online',",
      "  idle: 'Idle',",
      "  away: 'Away',",
      "  offline: 'Offline'",
      "};",
      "",
      "@@slot:after-status-label-map@@"
    ]
  },
  {
    "from": "disconnected-callback",
    "target": "class-body",
    "lines": [
      "  disconnectedCallback() {",
      "    this.unbindEvents();",
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
      "      case 'username':",
      "        this.updateUsername();",
      "        break;",
      "      case 'role':",
      "        this.updateRole();",
      "        break;",
      "      case 'status':",
      "        this.updateStatus();",
      "        break;",
      "      default:",
      "        break;",
      "    }"
    ]
  },
  {
    "from": "property-username-getter",
    "target": "class-body",
    "lines": [
      "  get username() {",
      "    return normalizeTextValue(this.getAttribute('username'), 'Team Member');",
      "  }",
      ""
    ]
  },
  {
    "from": "property-username-setter",
    "target": "class-body",
    "lines": [
      "  set username(value) {",
      "    this.setAttribute('username', normalizeTextValue(value, 'Team Member'));",
      "  }",
      ""
    ]
  },
  {
    "from": "property-role-getter",
    "target": "class-body",
    "lines": [
      "  get role() {",
      "    return normalizeTextValue(this.getAttribute('role'), '');",
      "  }",
      ""
    ]
  },
  {
    "from": "property-role-setter",
    "target": "class-body",
    "lines": [
      "  set role(value) {",
      "    this.setAttribute('role', normalizeTextValue(value, ''));",
      "  }",
      ""
    ]
  },
  {
    "from": "property-status-getter",
    "target": "class-body",
    "lines": [
      "  get status() {",
      "    return normalizeStatusValue(this.getAttribute('status'));",
      "  }",
      ""
    ]
  },
  {
    "from": "property-status-setter",
    "target": "class-body",
    "lines": [
      "  set status(value) {",
      "    this.setAttribute('status', normalizeStatusValue(value));",
      "  }",
      ""
    ]
  },
  {
    "from": "property-profile-url-getter",
    "target": "class-body",
    "lines": [
      "  get profileUrl() {",
      "    return this.getAttribute('profile-url') || '';",
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
      "      this.shadowRoot.appendChild(uiUserAvatarTemplate.content.cloneNode(true));",
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
    "from": "cache-dom-username",
    "target": "cache-dom-body",
    "lines": [
      "    if (!this.usernameElement) {",
      "      this.usernameElement = this.shadowRoot.querySelector('.username');",
      "    }",
      ""
    ]
  },
  {
    "from": "cache-dom-role",
    "target": "cache-dom-body",
    "lines": [
      "    if (!this.roleElement) {",
      "      this.roleElement = this.shadowRoot.querySelector('.role');",
      "    }",
      ""
    ]
  },
  {
    "from": "cache-dom-status-badge",
    "target": "cache-dom-body",
    "lines": [
      "    if (!this.statusBadgeElement) {",
      "      this.statusBadgeElement = this.shadowRoot.querySelector('.status-badge');",
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
      "    this.updateUsername();",
      "    this.updateRole();",
      "    this.updateStatus();"
    ]
  },
  {
    "from": "update-username",
    "target": "class-body",
    "lines": [
      "  updateUsername() {",
      "    if (!this.usernameElement) {",
      "      return;",
      "    }",
      "",
      "    this.usernameElement.textContent = this.username;",
      "  }",
      ""
    ]
  },
  {
    "from": "update-role",
    "target": "class-body",
    "lines": [
      "  updateRole() {",
      "    if (!this.roleElement) {",
      "      return;",
      "    }",
      "",
      "    this.roleElement.textContent = this.role;",
      "  }",
      ""
    ]
  },
  {
    "from": "update-status",
    "target": "class-body",
    "lines": [
      "  updateStatus() {",
      "    if (!this.statusBadgeElement) {",
      "      return;",
      "    }",
      "",
      "    const normalizedStatus = this.status;",
      "    this.statusBadgeElement.setAttribute('aria-label', statusAriaLabel[normalizedStatus] || 'Unknown');",
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
    "from": "bind-events-guard",
    "target": "bind-body",
    "lines": [
      "    if (this.isClickBound) {",
      "      return;",
      "    }",
      "",
      "    this.addEventListener('click', this.handleAvatarClick);",
      "    this.setAttribute('tabindex', '0');",
      "    this.setAttribute('role', 'button');",
      "    this.isClickBound = true;"
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
    "from": "unbind-events-guard",
    "target": "unbind-body",
    "lines": [
      "    if (!this.isClickBound) {",
      "      return;",
      "    }",
      "",
      "    this.removeEventListener('click', this.handleAvatarClick);",
      "    this.isClickBound = false;"
    ]
  },
  {
    "from": "handle-avatar-click",
    "target": "class-body",
    "lines": [
      "  handleAvatarClick() {",
      "    @@slot:click-body@@",
      "  }",
      ""
    ]
  },
  {
    "from": "handle-avatar-click-event",
    "target": "click-body",
    "lines": [
      "    this.dispatchEvent(",
      "      new CustomEvent('ui-user-avatar:profile-open', {",
      "        bubbles: true,",
      "        composed: true,",
      "        cancelable: true,",
      "        detail: {",
      "          username: this.username,",
      "          role: this.role,",
      "          status: this.status,",
      "          profileUrl: this.profileUrl,",
      "          source: 'ui-user-avatar'",
      "        }",
      "      })",
      "    );"
    ]
  },
  {
    "from": "define-guard",
    "target": "after-class",
    "lines": [
      "if (!customElements.get('ui-user-avatar')) {",
      "  @@slot:define-body@@",
      "}"
    ]
  },
  {
    "from": "define-element",
    "target": "define-body",
    "lines": [
      "  customElements.define('ui-user-avatar', UiUserAvatar);"
    ]
  }
]
```
