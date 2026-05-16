# How To Document (Node/Express + Frontend + Web Components)

Version: 1.0.0
Status: Normative / Enforced
Scope: `academy/docs/**`

Documentation is a design artifact.
If design cannot be explained without reading source, documentation is incomplete.

---

## 1) Filesystem-First Rule

Start from structure, not assumptions.

Map docs to architecture boundaries:

- backend/domain docs
- frontend/presentation docs
- governance docs
- roadmaps/business docs

If a boundary exists in code, it must exist in docs.

---

## 2) Documentation Layers

Every important document should include two layers:

1. Technical layer (intent, constraints, contracts)
2. Human layer (plain explanation for fast onboarding)

Keep language simple and direct.

---

## 3) Mandatory Sections for Architecture Docs

For backend/frontend architecture docs include:

1. Version / Status / Scope
2. Purpose
3. Canonical flow/axis
4. Boundary rules
5. Hard fail conditions
6. Invariants
7. QA requirements

---

## 4) What to Document by File Type

### 4.1 SSR files (`pages/*.ejs`, `ssr/*.ts`)

- route intent
- rendering responsibilities
- data contract expectations

### 4.2 App entry files (`assets/*.ts`, `assets/*.css`)

- boot responsibilities
- owned runtime surface
- dependencies and side-effect boundaries

### 4.3 Engine utility files (`engine/*.ts`)

- single responsibility
- inputs/outputs
- determinism constraints

### 4.4 Web Components (`*.element.ts`)

- tag name
- attributes/properties
- emitted events
- lifecycle expectations
- accessibility contract
- style scoping strategy

---

## 5) Glossary and Linking

- Keep shared terms in a glossary section or dedicated glossary file.
- First mention of key architecture terms should be linkable.
- Prefer internal links for repository concepts and authoritative external links only when needed.

---

## 6) Change Awareness

When docs are updated:

1. record impacted files,
2. record contract deltas,
3. verify cross-links,
4. update review evidence if governance changed.

---

## 7) Documentation QA Checklist

Before closing docs iteration:

- all scoped docs updated,
- links valid,
- version/status/scope headers present where required,
- no runtime code changes in docs-only iteration,
- review evidence updated in governance folder when required.

---

## 8) Writing Style

- Use short paragraphs.
- Avoid filler language.
- Prefer concrete rules over vague principles.
- Keep examples near rules they explain.
- Explain tradeoffs explicitly.

