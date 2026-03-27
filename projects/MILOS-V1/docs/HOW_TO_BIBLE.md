# MILOS: Modular Intrinsic Layout Orchestration System (The Bible) 📖

Version: 2.0.0  
Status: Canonical instructions for building products fast with MILOS.

This is the single companion document for application teams and AI agents.
If this file and implementation differ, fix code or update this file in the same change.

## 1) Mission

Build production UI quickly with:

- Minimal API surface (No choice paralysis)
- Deterministic behavior (Grammar-backed)
- Class-first layout DSL
- Guardrail-backed consistency

Goal is delivery speed without layout entropy.

## 1.1 Beginner Learning Path (Demo-first)

Use demos in this order:

1. `demo/01-school-basics.html`

- Step-by-step intro for entry-level frontend learners.
- Shows one decision at a time: shell, flow, distribution, CQ behavior.

1. `demo/v1-smoke-test.html`

- Real composition patterns (dashboard, editorial, forms, reel).

1. `demo/layout-edge-cases.html`

- Stress harness for overflow/CQ/nested contexts and contract attack cases.

1. `demo/visual-regression.html`

- Stable visual targets used by Playwright snapshots.

Rule:

- Start from school demo.
- Copy one recipe.
- Evolve into smoke-test patterns.
- Validate with edge-cases + visual regression.

## 1.2 Naming Prefix Policy

Use prefixes to keep ownership and intent obvious:

- `l-*`: MILOS layout DSL (framework-owned)
- `u-*`: MILOS utility DSL (framework-owned)
- `c-*`: application component visuals (application-owned)
- `demo-*`: demo/docs helper visuals (example-owned)
- `js-*`: behavior hooks only (no styling contract)

When reading markup:

- `l-*` and `u-*` are framework language.
- `c-*` is product styling on top of the framework.
- `demo-*` is demo-only styling used in examples/harness pages.

## 1.3 File Granularity Policy

MILOS stays scalable by splitting where intent boundaries are real:

- settings/themes: split by concern in `styles/00-settings/` with top-level aggregators
- primitives: one primitive per file in `styles/02-layout/` (internal modules allowed)
- runtime: split by modifier concern in `styles/03-runtime/` with `runtime.css` aggregator
- elements: one geometry intent per file in `styles/04-elements/`
- scenarios: one scenario intent per file in `styles/05-scenarios/`
- utilities: `utilities.css` is aggregator; one utility concern per file in `styles/07-utilities/` (internal modules allowed)
- `tokens.css`, `themes.css`, `runtime.css`, `elements.css`, and `scenarios.css` are aggregators

Do not split into micro-files that represent only tiny variants of the same intent.

## 2) Mental Model

Layout is split into four decision layers:

1. Primitive:

- Choose geometry container (`l-grid`, `l-stack`, `l-rails`, etc.)

1. Structure:

- Choose one structure modifier for `l-grid` (`l-grid--cols-*` or `l-grid--preset`)

1. Item relation:

- Assign spans (`l-span--*`) only as direct children of `l-grid` or `l-rails`

1. Local tuning:

- Apply class modifiers (`l-gap--*`, `l-width--*`, `l-grid--collapse-*`, etc.)

Do not move layout math into inline styles or `data-*`.

### 2.0 Layout Language Spec (Normative)

MILOS is a formal layout language with exactly four categories.
Every core primitive belongs to exactly one category.

Category ontology:

1. Shell layouts:

- solve macro page/app structure and width/frame boundaries.
- question: "Where does this block live in page structure?"

1. Flow layouts:

- solve vertical rhythm and in-flow sequencing.
- question: "How do blocks flow one after another?"

1. Distribution layouts:

- solve sibling space distribution in 1D/2D.
- question: "How is space distributed between peers?"

1. Context layouts:

- solve context-dependent behavior (query boundary, aspect, overlay, viewport-fill).
- question: "How does this block behave relative to context?"

#### 2.0.1 Primitive Classification (Complete, Locked)

| Category     | Primitives                                                                             |
| ------------ | -------------------------------------------------------------------------------------- |
| Shell        | `l-page`, `l-container`, `l-sidebar`, `l-rails`, `l-bleed*`                            |
| Flow         | `l-stack`, `l-flow`, `l-region`                                                        |
| Distribution | `l-grid`, `l-switcher`, `l-cluster`, `l-reel`                                          |
| Context      | `l-cq`, `l-frame`, `l-cover`, `l-imposter`, `l-center`, `l-box`                        |

Language lock rules:

- A primitive must not appear in multiple categories.
- New primitives must declare one category in this table in the same change.
- If intent is unclear between categories, update Section 2.3 matrix before API expansion.

### 2.1 Formal Mental Model Map (Locked)

MILOS DSL is formally divided into exactly four categories:

1. Shell layouts:

- primitives: `l-page`, `l-container`, `l-sidebar`, `l-rails`, `l-bleed*`
- purpose: page/application macro structure and shell boundaries.

1. Flow layouts:

- primitives: `l-stack`, `l-flow`, `l-region`
- purpose: vertical rhythm and document flow.

1. Distribution layouts:

- primitives: `l-grid`, `l-switcher`, `l-cluster`, `l-reel`
- purpose: 1D/2D distribution of sibling elements.
- submodes:
  - intrinsic: `l-grid--auto|cards|gallery|balanced`
  - structured: `l-grid--cols-*`

1. Context layouts:

- primitives: `l-cq`, `l-frame`, `l-cover`, `l-imposter`, `l-center`, `l-box`
- purpose: query boundaries, aspect constraints, overlay/imposter logic, and local framing.

Formal lock rules:

- Every layout decision starts with exactly one category.
- Primitive selection happens only inside the chosen category.
- If intent is not covered by a category primitive, redesign composition before adding API.

### 2.2 Canonical Selection Rules

- Use `l-sidebar` for asymmetric shell with side/main intent.
- Use `l-grid--cols-2` for equal two-column distribution.
- Use `l-stack` for block spacing patterns; use `l-flow` for prose/rich-content flow rhythm.
- Use `l-center` to center one block, `l-grid--place-center` to center item cells.
- Use `l-grid--collapse-*` for grid collapse behavior.
- Prefer app-level semantic wrappers (`app-*`) for shell meaning; keep engine classes geometric.

### 2.3 Canonical Choice Matrix (Normative)

If two primitives look similar, this matrix is the binding tie-breaker.
Do not pick by taste. Pick by intent.

| Pair                                   | Use A when                                                                                              | Use B when                                                          | Never use A for                    | Never use B for                              |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- | ---------------------------------- | -------------------------------------------- |
| `l-stack` vs `l-flow`                  | `l-stack`: spacing between generic layout blocks (forms/cards/ui groups)                                | `l-flow`: readable prose/rich-content rhythm                        | article/prose flow                 | generic UI block stacking                    |
| `l-stack` vs `l-region`                | `l-stack`: spacing between direct children in a flow                                                    | `l-region`: section-level vertical breathing room (`padding-block`) | page section outer spacing         | child-to-child rhythm inside content groups  |
| `l-container` vs `l-rails`             | `l-container`: single content column with width constraints and centering                               | `l-rails`: named tracks (`full/wide/content/text`) in one section   | multi-track editorial compositions | simple single-column width limiting          |
| `l-center` vs `l-cluster`              | `l-center`: center one block (or one logical group)                                                     | `l-cluster`: distribute many peer items in a row/wrap               | toolbar/chip/action groups         | one-block centering responsibility           |
| `l-box` vs `l-region`                  | `l-box`: surface wrapper (padding, border/radius, local framing)                                        | `l-region`: outer section rhythm between page blocks                | page-level spacing rhythm          | surface framing/styling responsibility       |
| `l-imposter` vs `l-center`             | `l-imposter`: overlay or detached layer (`absolute/fixed`)                                              | `l-center`: in-flow centering in normal document flow               | regular in-flow centering          | overlays, modals, detached positioned layers |
| `l-sidebar` vs `l-grid--cols-2`        | `l-sidebar`: asymmetric sidebar + main shell intent                                                     | `l-grid--cols-2`: symmetric 2-column distribution                   | symmetric split layouts            | fixed sidebar + main shell layouts           |
| `l-center` vs `l-grid--place-center`   | `l-center`: center one block container                                                                  | `l-grid--place-center`: center all grid items in their cells        | per-cell grid item placement       | single-block centering primitive             |

Escalation rule:

- If a use-case cannot be mapped by this matrix, stop and update this matrix in the same change before adding new API.

## 3) Core API

### 3.1 Primitives

- `l-page`
- `l-container`
- `l-sidebar`
- `l-stack`
- `l-cluster`
- `l-grid`
- `l-switcher`
- `l-center`
- `l-cover`
- `l-reel`
- `l-flow`
- `l-frame`
- `l-imposter`
- `l-rails`
- `l-region`
- `l-box`
- `l-cq`
- `l-bleed`
- `l-bleed-root`
- `l-bleed-safe`

### 3.2 Grid DSL

Structure:

- `l-grid--cols-2`
- `l-grid--cols-3`
- `l-grid--cols-4`
- `l-grid--cols-6`
- `l-grid--cols-12`
- `l-grid--auto`
- `l-grid--cards`
- `l-grid--cards-sm`
- `l-grid--cards-md`
- `l-grid--cards-lg`
- `l-grid--gallery`
- `l-grid--gallery-sm`
- `l-grid--gallery-md`
- `l-grid--gallery-lg`
- `l-grid--balanced`
- `l-grid--feature`
- `l-grid--collapse-sm|md|lg`

Alignment:

- `l-grid--place-center`
- `l-grid--baseline`
- `l-grid--align-start|align-center|align-end|align-stretch`
- `l-grid--justify-start|justify-center|justify-end|justify-stretch`

Item span:

- `l-span--1` ... `l-span--12`
- `l-span--full`

### 3.3 Runtime Modifiers

- `l-gap--0|xs|sm|md|lg|xl`
- `l-width--wide|measure|full`
- `l-height--full`
- `l-region--0|sm|md|lg`
- `l-fill`, `l-shrink`, `l-fit`
- `l-order--first|last`
- `l-self--start|center|end|stretch`
- `l-stack--align-*`, `l-stack--justify-center`
- `l-cluster--align-*`, `l-cluster--justify-*`, `l-cluster--no-wrap`
- `l-switcher--align-center`, `l-switcher--justify-center`, `l-switcher--min-sm|md|lg|xl`
- `l-frame--1-1|4-3|16-9|21-9|cover|contain`
- `l-imposter--fixed|contain`
- `l-box--sm|lg|none`
- `l-z-flat|raised|content|overlay|modal|negative`
- `l-cover-content`
- `l-rail--full|wide|content|text`

### 3.4 Elements and Scenarios

Strict engine mode:

- no elements/scenario classes in framework API
- semantic shortcuts belong to app layer (`app-*`)

### 3.5 Utility DSL

- `u-hide`, `u-show`, `u-debug`
- `u-hide--cq-narrow|medium|wide`
- `u-show--cq-narrow|medium|wide`

## 4) Forbidden Patterns

- Any layout `data-*` API (`data-gap`, `data-cols`, `data-span`, etc.)
- Legacy `u-cols-*`, `u-span-*`
- Inline layout styles:
  - `style="--grid-cols: ..."`
  - `style="--span: ..."`
- Any inline `style` in production markup
- Viewport layout breakpoints (`@media`) in layout system layers

## 5) CQ Policy (Container Query First)

Canonical query boundary:

- wrap responsive regions in `.l-cq`
- `.l-cq` is the named container context (`layout`)

Canonical thresholds:

- `40rem` = narrow
- `60rem` = medium/collapse
- `72rem` = wide

No ad-hoc CQ literals.

## 6) Canonical Recipes

### 6.1 Page Shell

```html
<main class="l-page l-bleed-root">
  <header class="l-container">...</header>
  <section class="l-container">...</section>
  <footer class="l-container">...</footer>
</main>
```

### 6.2 Sidebar App (Recommended)

```html
<section class="app-shell l-sidebar l-gap--md">
  <aside class="app-rail">Filters</aside>
  <main class="app-main">Main content</main>
</section>
```

### 6.3 Cards Grid

```html
<div class="l-grid l-grid--cards l-gap--sm">
  <article>Card A</article>
  <article>Card B</article>
  <article>Card C</article>
</div>
```

### 6.4 Fixed Grid + Span

```html
<div class="l-grid l-grid--cols-4 l-gap--sm">
  <article class="l-span--2">A</article>
  <article class="l-span--1">B</article>
  <article class="l-span--1">C</article>
</div>
```

### 6.4.1 Semantic Structured Grid

```html
<div class="l-grid l-grid--cols-2 l-gap--md">
  <article>A</article>
  <article>B</article>
</div>
```

### 6.5 Sidebar Primitive

```html
<section class="l-sidebar l-gap--md">
  <aside>Rail</aside>
  <main>Main</main>
</section>
```

### 6.6 Editorial Rails

```html
<main class="l-rails">
  <section class="l-rail--content">Content</section>
  <section class="l-rail--wide">Wide</section>
  <section class="l-rail--full">Full</section>
</main>
```

### 6.7 Visibility by Container

```html
<div class="l-cq">
  <aside class="u-hide--cq-narrow u-show--cq-wide">Secondary</aside>
  <section>Primary</section>
</div>
```

### 6.8 Bleed-safe Section

```html
<main class="l-page l-bleed-root">
  <section class="l-container">Normal</section>
  <section class="l-bleed-safe">Full width safe</section>
</main>
```

### 6.9 Switcher with Min Preset

```html
<div class="l-switcher l-switcher--min-lg l-gap--md">
  <article>Tile A</article>
  <article>Tile B</article>
  <article>Tile C</article>
</div>
```

## 7) AI-First Build Protocol

When prompting an AI agent for UI work, use this template:

1. Intent:

- "Build [screen type] with Layout System 2026 classes only."

1. Constraints:

- "No inline style."
- "No data attributes for layout."
- "Use only public DSL from HOW TO Bible."
- "CQ-first, no viewport breakpoints in layout layer."

1. Output contract:

- return changed files
- return QA result from `npm run ci`
- call out any API contract impact

### 7.1 Intention-First Build Mode (Required for Apps)

MILOS is the layout operating system. Your application naming is a separate layer.

Three-layer authoring model:

1. Infrastructure (MILOS):

- use `l-*` / `u-*` only for geometry/runtime behavior.

1. Application intent:

- use `app-*` names to express domain meaning (for example `app-shell`, `app-main`, `app-rail`).
- define these in app codebase, not in MILOS framework layer.

1. Components/visuals:

- use `c-*` classes for visual/component styling.
- components consume layout; they do not redefine layout algorithms.

Extraction triggers (when to introduce `app-*`):

- the same MILOS composition appears more than once
- one element carries one primitive plus many modifiers (hard to scan)
- the pattern clearly represents a domain structure

Example progression:

```html
<!-- Infrastructure-first prototype -->
<section class="l-sidebar l-gap--md">
  <aside>...</aside>
  <main>...</main>
</section>

<!-- Intention-first production markup -->
<section class="app-shell l-sidebar l-gap--md">
  <aside class="app-rail">...</aside>
  <main class="app-main">...</main>
</section>
```

Hard boundary:

- Do not move MILOS geometry into `app-*` custom algorithms.
- `app-*` should label intent and orchestrate reuse, while MILOS remains the engine.
- Controlled escape is token-only: app-level tuning vars like `--switch-min` and `--grid-min` must reference tokens (`var(--...)`), never raw `px/rem`.

### 7.2 AI Prompt Add-on (Intention-first)

Add this block to UI prompts:

- "Use MILOS as infrastructure (`l-*`, `u-*`)."
- "Extract repeated/domain layout into `app-*` composition names."
- "Do not implement new layout algorithms in app/component CSS."
- "Keep framework contract and HOW TO Bible rules."

## 8) Composition Rules

- Every `.l-grid` must declare exactly one structure modifier.
- Nested `.l-grid` must declare its own structure.
- `.l-span--*` must be direct child of parent grid/rails context.
- Preset + structure conflicts are invalid unless explicitly defined.
- `span > cols` is invalid and must fail guards (except explicit debug marker).

## 9) Do/Do-Not

Do:

- compose primitives first
- use scenario classes only for semantic naming
- keep component visuals in `.c-*`
- keep utility usage minimal and explicit

Do not:

- use fixed 12-col grid for card/list layouts where intrinsic presets solve it
- use span modifiers when intrinsic presets already produce correct rhythm
- encode layout in component visuals
- redefine layout engine variables in utilities
- add bespoke grid classes outside canonical DSL
- add new API surface casually

## 10) One Page Cheatsheet

10 classes to remember:

- `l-page`
- `l-container`
- `l-sidebar`
- `l-grid`
- `l-grid--cards`
- `l-grid--cols-2`
- `l-grid--collapse-md`
- `l-span--6`
- `l-stack`
- `l-flow`

3 rules:

- every `l-grid` gets exactly one structure modifier
- spans are direct child relation, never ancestor relation
- use `.l-cq` for container-driven responsiveness

2 anti-patterns:

- `l-grid--cols-12` for simple card lists
- bespoke utility/layout classes outside the whitelist

## 11) QA Gate (Mandatory)

Run before merge:

```bash
npm run ci
```

Must pass:

- build bundle
- stylelint
- layout guards
- guard unit tests
- visual regression tests

## 12) Change Governance

For any new primitive/modifier:

- update `AGENTS.md`
- update this file
- run full CI
- treat API growth as versioned change

If contract and code conflict, contract wins until updated in same PR.
