# 🅂 Signal-Driven Framework: STANKOVICH

This document defines the core architecture and development patterns for the **Minimalist Signal-Driven Web Components Engine**.

## 1. Core Philosophy

* **Signals Only**: Reactivity is explicit and granular. No Virtual DOM, no Proxies, no global diffing.
* **One-Time Mount**: Components are mounted exactly once. Prop/State updates trigger fine-grained effects that manipulate the DOM directly.
* **Total Ownership**: Every side effect is tied to a component's lifecycle. Memory leaks are avoided by design when following ownership rules.

## Source Of Truth

* Canonical implementation lives in `core/*.js`, `index.js`, `index.d.ts`, `tests/*`, and `examples/*`.
* `component-builder.txt` is a generated merge artifact for packaging/review, not an editable source file.

## 2. Reactive Primitives

* **`signal(val)`**: Returns a reactive container. Access via `.value`.
* **`effect(fn)`**: Executes side effects. Automatically tracks signal dependencies.
* **`computed(fn)`**: Returns a derived signal that only updates when its dependencies change.
* **`stop(runner)`**: Permanently deactivates an effect (and also supports computed signals).
* **`stopComputed(sig)`**: Explicitly detaches a computed from dependencies.

## 3. Component Lifecycle & Ownership

### The `BaseComponent` Rules

1. **Mount Isolation**: DOM is rendered into a `#mountPoint` (inside Shadow DOM) with `display: contents`. Styles are isolated from teardowns.
2. **Auto-Tracking**: Any `effect()` created during the `mount` or `setup` phase is automatically registered for cleanup.
3. **Manual Ownership**: Use `this.own(runner)` to register external effects or binders created outside the initial mount.
4. **Automatic Teardown**: `disconnectedCallback` stops all registered effects and clears the mount point.

## 4. Development Patterns (DX)

### Defining a Component

```javascript
Component.define("my-counter")
  .props({ step: { type: "number", default: 1 } })
  .setup(function() {
    const count = signal(0);
    return { count };
  })
  .mount(function(root, ctx) {
    const btn = h("button", { on: { click: () => ctx.count.value += this.step } });
    bindText(btn, ctx.count);
    root.appendChild(btn);
  })
  .register();
```

### Binders

Binders (`bindText`, `bindAttr`, `bindProp`, `bindClass`) return an effect runner. In `mount()`, they are auto-owned. Outside `mount()`, use `this.own()`:

```javascript
this.own(bindText(el, signal));
```

For composable text children, use `text(sig)`:

```javascript
const line = h("p", {}, "Value: ", text(countSig));
```

### Property vs Attribute

* Use `h("input", { value: "..." })` for initial state.
* Use `bindProp(el, "value", signal)` for live reactive state on inputs.

## 5. Context API

* `provide(ctx, valOrSignal)`: Shares state down the tree. Non-signals are automatically wrapped.
* `consume(ctx)`: Returns a **Signal**. Always reactive.

## 6. v2 Plan

* Roadmap and ToDo list for version 2: [ROADMAP_V2.md](./ROADMAP_V2.md)

---
**Version 1.0.0 (STANKOVICH)** - *Pure Performance. Zero Magic.*
