# Vanilla Web Components Profile

This profile defines the engineering standard for projects using native Web Components (Vanilla JS) without heavy external frameworks.

## 1. Governance & Scope

- **Native First**: No UI libraries (React, Vue, etc.) or CSS frameworks (Tailwind) are permitted unless explicitly approved.
- **Zero Dependency**: Components should be self-contained and use standard Browser APIs.
- **ES Modules**: Standard ES modules are the only permissible module system.

## 2. Component Organization (Holy Trinity)

Every complex component or feature slice must follow the **State/Render/Actions** (Holy Trinity) separation:

- **`state/`**: The single source of truth. It must not know about the DOM or CSS.
- **`render/`**: Responsible for manual DOM updates based on state changes. It does not contain business logic.
- **`actions/`**: Contains logic that transforms state and manages side effects (API calls, storage).

## 3. Directory Structure

A standard component slice looks like this:
```text
my-component/
  index.js      (Public facade)
  component.js  (Class definition)
  content/      (Internal sub-modules)
  styles/       (CSS modules)
  state/        (State logic)
  render/       (DOM update logic)
  actions/      (Side-effects)
```

## 4. The Facade Rule

The `index.js` (or a file named after the component) is a small public facade. It should only glue the internal parts together and export the class or initialization function. It must not become a large "command center".

## 5. Styling Standards

- Use standard CSS variables for theme and shared tokens.
- Keep styles isolated (Shadow DOM or strict naming).
- No inline styles for layout; use classes and state-driven attributes.
