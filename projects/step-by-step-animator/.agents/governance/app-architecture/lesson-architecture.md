# Lesson Architecture

This document defines the target lesson-engine architecture and the current lesson/runtime contract for the `step-by-step-animator` repo.

It is written as a production plan, not as a loose idea list.

Target boundaries:

- `product/education/` writes source content
- `system/lesson-engine/` compiles source content into a canonical lesson package
- `system/animator-engine/` replays the compiled package frame by frame
- `product/app/` presents the product shell from the canonical `product/app/index.html` entry

The quality baseline for every implementation decision still comes from `.agents/governance/app-architecture/architecture-standard.md` and `.agents/governance/app-architecture/ARCHITECTURE.md`.

Goal is for the structure to be:

- flow-first (numbers in folders)
- feature-slice (specific lesson)
- file responsibility (clearly delineated roles)
- function precise action
- deterministic compiler output
- runtime animator engine for frame-by-frame playback

## 0. Lesson Engine Product Plan

The lesson system is not a folder of parsers.
It is a content-to-lesson compiler.

The lesson engine must take human-authored source files, validate them, normalize them, project artifact state through steps, and output a stable compiled lesson package that can be replayed by the animator and presented by the app.

### 0.1 Target System Boundaries

- `product/education/` holds authoring source
- `system/lesson-engine/` compiles source into canonical lesson packages
- `system/animator-engine/` plays compiled lesson packages
- `product/app/` renders the product shell and mounts the animator

### 0.2 What the Lesson Engine Is

The lesson engine is:

- discovery
- validation
- parsing
- normalization
- projection
- compilation
- generated documentation

The lesson engine is not:

- app shell
- animator UI
- editor shell
- raw markdown landfill
- a bag of helpers

The engine must stay boring and deterministic.
It should not guess author intent, patch broken content silently, or hide string tricks behind clever code.

### 0.3 Inputs

The engine accepts a small, explicit authoring contract.

`product/education/lessons/<lesson-slug>/source/` is source only.
It does not contain executable lesson glue.
All translation logic lives in `system/lesson-engine/`.

Canonical source files are:

- `lesson.md`
- `theory.md`
- `scenes.md`
- `artifacts/`
- `assets/`

The exact file names are adapter details. The domain model is what matters.

### 0.4 Outputs

The engine must emit three first-class outputs:

1. compiled lesson package
2. generated lesson documentation
3. validation report

Rules:

- the compiled package is the canonical truth for animator
- generated docs are derived, not manually edited
- validation report must clearly state errors, warnings, and readiness

### 0.5 Canonical Lesson Package

The compiled package should contain at least:

- `schemaVersion`
- `meta`
- `teaching`
- `artifacts`
- `statesByStep`

`meta` contains:

- `lessonId`
- `lessonTitle`
- `lessonIntro`
- `status`
- `preview`
- optional tags, difficulty, and estimated minutes

`teaching` contains:

- `steps`
- `goal`
- `homework`
- `references`
- `summary`

`artifacts` contains one entry per lesson artifact:

- `artifactId`
- `kind`
- `language`
- `fileName`
- `sourceFile`
- `editorLabel`
- `runtimeTarget`
- `isPrimary`

`statesByStep` contains the canonical state of each artifact for each step.

### 0.6 Validation Model

Validation must cover:

- identity
- authoring contract
- teaching contract
- artifact contract
- generated output
- readiness

Identity validation checks:

- folder identity matches `lessonId`
- root entry matches folder
- title is present
- status is valid

Authoring validation checks:

- required documents exist
- frontmatter shape is valid
- declared artifact sources exist

Teaching validation checks:

- steps exist
- step order is clear
- `stepId` values are unique
- each step has a title
- markers reference real steps

Artifact validation checks:

- each artifact has a builder or projection path
- each artifact has a stable file identity
- each artifact has a clear language
- no key conflicts exist

Generated output validation checks:

- output is not stale
- output can be regenerated
- output is not hand-edited

Readiness validation checks:

- `active` lessons compile successfully
- `broken` lessons are never treated as healthy

### 0.7 Status Model

Lesson status must at least support:

- `draft`
- `active`
- `broken`
- `deprecated`

Meaning:

- `draft` is still being authored
- `active` is valid and compilable
- `broken` exists but currently fails validation or build
- `deprecated` is historical and should not be the default choice

Lesson status is separate from validation and build state.

### 0.8 Authoring and Naming Contract

The naming contract stays brutally simple:

- folder says flow
- file says responsibility
- function says exact action

Feature slice root rules:

- a sequential slice should have one root owner file, usually a pipeline
- if the flow is not sequential, use the smallest clear facade, orchestrator, or root function that owns the full slice
- the root file must explain the whole slice without scattering responsibility across many files

Allowed names should read like a small, obvious story.
Avoid generic buckets such as `utils`, `helpers`, `shared`, `common`, `manager`, `service`, and `controller`.

### 0.8a Canonical Tree Rule

The target tree is locked as follows:

- top-level product areas are `product/` and `system/`
- `product/education/lessons/<lesson-slug>/source/` contains only source docs and metadata
- no executable lesson glue lives in `product/education/`
- `system/lesson-engine/` owns discovery, parsing, validation, normalization, projection, compilation, and generated documentation
- `system/lesson-engine/output/` holds the derived lesson documents
- `project-artifact-state` is artifact-first and expands by kind, not by UI language
- `system/animator-engine/` consumes only compiled lesson packages
- `system/foundation/` is the shared primitive layer for frontmatter and markdown
- `lesson.js`, `describe-steps.js`, and per-lesson `build-*` files do not belong in the source-only education tree

Representative tree:

```txt
step-by-step-animator/
  AGENTS.md
  README.md
  product/
    app/
      index.html
      main.js
    education/
      lessons/
        <lesson-slug>/
          source/
            lesson.md
            theory.md
            scenes.md
            artifacts/
            assets/
  system/
    animator-engine/
      choose-lesson/
      play-lesson/
    lesson-engine/
      discover-education-content/
      read-education-entry/
      validate-education-entry/
      parse-education-source/
      normalize-lesson-source/
      project-artifact-state/
      compile-lesson-package/
      documentation/
      register-lesson-packages/
      contracts/
      adapters/
      output/
        lesson-documents/
    foundation/
      frontmatter/
      markdown/
```

This tree is intentionally source-only on the education side and compilation-only in the engine. The compiler owns the translation logic; the animator owns playback only.

### 0.8b Source-Only Education Rule

- product/education holds author intent, not executable build glue
- lesson source is written as scenario and scene content
- source files are allowed to describe the desired code result, the flow, and the teaching story
- source files are not allowed to contain per-lesson compiler implementation
- if a lesson needs a new capability, the capability is added to the engine, not smuggled into education

### 0.8c Foundation Rule

- shared primitives belong in `system/foundation/`
- foundation is allowed for frontmatter and markdown
- foundation must stay small and generic
- foundation must not become a new dumping ground

### 0.8d Artifact-First Projection Rule

- the projection layer is artifact-first
- HTML, CSS, JS, template JS, shadow CSS, PHP, SQL, YAML, and README are all first-class artifact kinds
- the engine must support new artifact kinds without changing the mental model
- the lesson package is compiled by kind, not by front-end-only assumptions

### 0.9 Public API

The lesson engine should expose a small public surface with strong verbs:

- `discoverEducationEntries()`
- `readEducationEntry()`
- `validateEducationEntry()`
- `normalizeEducationEntry()`
- `projectArtifactStateByStep()`
- `compileLessonPackage()`
- `buildLessonDocumentation()`
- `compileAllLessons()`

No generic catch-all helpers should become the public model.

### 0.10 Generated Documentation

Generated documentation is a first-class artifact, not an afterthought.

It should provide:

- aggregated lesson markdown
- theory summary
- step summary
- per-step artifact state
- final state snapshot
- stale output detection and cleanup

Generated docs are read-only outputs.
Manual edits are not part of the contract.

### 0.11 Migration Governance Reference

The completed migration governance record lives in `.agents/governance/app-architecture/migration-governance.md`.
This document keeps the architectural spec and the canonical source contract.

### 0.12 Definition of Done

The refactor is successful when:

- a new lesson can be added without changing engine internals
- the same input always produces the same compiled output
- animator never needs raw source parsing
- generated docs can be recreated at any time
- the same engine can support multiple domains
- names remain simple, predictable, and flow-first
- product/education slices stay source-only and never absorb build glue
- `theory.md` exists wherever the lesson needs explicit narrative content
- `system/foundation/` stays small, shared, and generic
- artifact projection supports HTML, CSS, JS, template JS, shadow CSS, PHP, SQL, YAML, README, and future kinds
- validation catches broken content before playback
- compiled lesson packages become the only truth animator needs

### 0.13 Reading Order

The first part of this document describes the live source-only lesson-engine architecture that the compiler feeds.
The remaining runtime notes are archived reference material from the pre-migration player model.

---

## 1. Live Contract

- `product/education/` is source-only.
- `system/lesson-engine/` owns discovery, validation, parsing, normalization, projection, compilation, and generated documentation.
- `system/animator-engine/` replays compiled lesson packages only.
- `product/app/` mounts the runtime and presents the product shell.
- `system/foundation/` holds shared primitives.
- `system/lesson-engine/output/` holds derived outputs.

## 2. Source Contract

Each lesson slice lives under `product/education/lessons/<lesson-slug>/source/` and contains:

- `lesson.md`
- `theory.md`
- `scenes.md`
- `artifacts/`
- `assets/`

The source contract is authoring-only. No per-lesson build glue belongs in `product/education/`.

## 3. Authoring DSL

- `lesson.md` is the manifest and machine contract for the lesson.
- `theory.md` is the explanation layer and can be optional when explicitly declared.
- `scenes.md` is the strict storyboard DSL.
- `artifacts/` contains the canonical source artifacts for the lesson.
- `assets/` contains reference visuals and other non-executable authoring assets.
- `step` is the pedagogical unit.
- `scene` is the directed frame inside a step.
- the lesson engine validates, normalizes, projects, and compiles this source into a canonical lesson package.
- the animator engine replays only the compiled package.

## 4. Engine Contract

`system/lesson-engine/` is the content-to-lesson compiler.

It owns:

- discovery
- read / validate / parse / normalize
- artifact projection by kind
- lesson package compilation
- documentation generation
- compiled package registration

Artifact projection is artifact-first. Supported kinds include:

- `html`
- `css`
- `js`
- `template-js`
- `shadow-css`
- `php`
- `sql`
- `yaml`
- `readme`
- future kinds through adapters

## 5. Runtime Contract

`system/animator-engine/` consumes only compiled lesson packages.

It does not parse raw lesson source.
It may present docs and playback UI, but it does not own source translation.

## 6. Foundation Contract

`system/foundation/` is allowed for:

- frontmatter
- markdown

Foundation must stay small and generic.

## 7. Governance Rules

- folder says flow
- file says responsibility
- function says exact action
- `theory.md` is real and must not be implied without a file
- source-only education is mandatory
- generated docs are derived, not hand-edited
- validation runs before compilation
- the compiled lesson package is the single truth the animator needs

## 8. Representative Tree

```txt
step-by-step-animator/
  AGENTS.md
  README.md
  product/
    app/
      index.html
      main.js
    education/
      lessons/
        <lesson-slug>/
          source/
            lesson.md
            theory.md
            scenes.md
            artifacts/
            assets/
  system/lesson-engine/
    discover-education-content/
    read-education-entry/
    validate-education-entry/
    parse-education-source/
    normalize-lesson-source/
    project-artifact-state/
    compile-lesson-package/
    documentation/
    register-lesson-packages/
    contracts/
    adapters/
  system/
    animator-engine/
      choose-lesson/
      play-lesson/
    lesson-engine/
      output/
        lesson-documents/
    foundation/
      frontmatter/
      markdown/
```

## 9. Migration Rule

If a feature still needs executable lesson-specific glue, that glue belongs in `system/lesson-engine/` during migration. It does not belong under `product/education/`.

## 10. Archived Runtime Notes

The remaining sections in this file are historical runtime notes from the pre-migration player model. They are retained for reference only and do not define the live source-only contract above.

Must not be source of truth:

- GSAP timeline
- CodeMirror decorations
- DOM preview state
- progress bar
- narrator panel

All of these are output layers.

### 34.2 Scene is Delta, Not Snapshot of World

Each scene describes only what changes relative to previous state.

Scene should not carry:

- complete preview HTML
- complete editor content
- complete set of active classes
- complete state preview component

Scene should carry only:

- code effects
- preview patches
- UI effects
- optional metadata

### 34.3 Replay Must Give Same Result

If same scene is run multiple times from same snapshot or same replay chain, result must be identical.

Rule:

- scene execution must be deterministic
- must not depend on previous animation frame
- must not depend on accidental DOM state outside contract

---

## 35. `scene.ui` Must Have Controlled Vocabulary

`scene.ui` is a useful layer, but is also the easiest path to chaos if it gets too many free 0/1 flags.

So keep it as a limited vocabulary.

Recommended groups:

- `popover`
- `hidden`
- `motion`
- `css`

### 35.1 Recommended Shape

```js
scene.ui = [
  {
    type: "popover",
    target: "code-panel",
    id: "price-period-note",
    title: "Why are we changing both /mo and /yr?",
    text: "Billing state affects both amount and period label."
  },
  {
    type: "hidden",
    selector: ".preview-tip",
    value: false
  },
  {
    type: "motion",
    target: "preview-card",
    enter: "fade-in-up",
    exit: "fade-out",
    duration: 0.35
  },
  {
    type: "css",
    selector: ".lesson-shell",
    name: "--focus-ring-opacity",
    value: "1"
  }
];
```

### 35.2 Rule

`scene.ui` should not become a parallel preview DSL.

Its role is:

- auxiliary teaching UX
- focus
- explanation
- light visual emphasis

Should not take over preview patch responsibilities.

---

## 36. Patch Metadata Hardening

Raw patch shape is not sufficient when engine gets:

- reconnect
- undo
- snapshot restore
- analytics
- debug replay
- future authoring lint

So each patch should support extended metadata layer.

### 36.1 Recommended Metadata Fields

```js
const patch = {
  id: "billing-set-yearly",
  undoId: "billing-set-monthly",
  groupId: "billing-toggle-sequence",
  type: "setProp",
  target: "pricing-card",
  name: "billing",
  value: "yearly",
  debugLabel: "Switch pricing card to yearly billing",
  metadata: {
    reasons: ["User toggled yearly billing switch"],
    tags: ["billing", "preview", "important"]
  }
};
```

### 36.2 Field Meanings

- `id`
  - unique patch identity within scene or lesson
  - useful for logging, testing and tracing

- `undoId`
  - reference to inverse or compatible rollback patch
  - useful for `prev`, reconnect and controlled undo

- `groupId`
  - ties multiple patches into one logical change
  - e.g. price amount + price period + toggle state

- `debugLabel`
  - readable text for devtools, logs and debug panel

- `metadata`
  - carries `reasons` (descriptions why patch happens) and `tags` (for filtering, analytics and linting)

### 36.3 Rule

`undoId` doesn't mean every patch must have hard-coded inverse automatically.

But engine must enable at least one of the following:

- inverse patch model
- snapshot restore model
- combined model

Healthiest approach:

- snapshot as canonical optimization
- inverse patch as fine-grained rewind where useful

---

## 37. `prereq` as Authoring and Runtime Guardrail

For larger lessons and future-linked checks, `step` and optionally `scene` can have `prereq`.

### 37.1 Recommended Shape

```js
const step = {
  id: "billing-toggle",
  title: "Add billing toggle",
  prereq: ["template-created", "shadow-css-ready"],
  scenes: []
};
```

Or more granular at scene level:

```js
const scene = {
  id: "sync-price",
  prereq: ["billing-toggle-wired"],
  code: [],
  preview: [],
  ui: []
};
```

### 37.2 What `prereq` Solves

- authoring validation
- future linked lessons
- conditional playback
- better error reporting
- protection from inconsistent scene reorder

### 37.3 Rule

`prereq` should not become a hidden runtime branch system.

Its primary role is:

- validation
- documenting dependencies
- protection from bad authoring

---

## 38. Enter / Exit Lifecycle for Scene

If engine uses GSAP or similar animation layer, `scene` can also have mild enter/exit contract.

### 38.1 Recommended Shape

```js
const scene = {
  id: "wire-events",
  label: "Bind events",
  duration: 0.4,
  enter: [
    { type: "motion", target: "code-panel", preset: "fade-in" },
    { type: "motion", target: "preview-card", preset: "slide-up" }
  ],
  exit: [
    { type: "motion", target: "callout-panel", preset: "fade-out" }
  ],
  code: [],
  preview: [],
  ui: []
};
```

### 38.2 Rule

`enter` and `exit` must not change canonical lesson state.

Their role is:

- transition
- rhythm
- sense of continuity
- micro polish

Player still determines:

- which scene is active
- when scene is done
- what is next scene
- how `prev` and `scrub` work

Animation layer only follows player decision.

---

## 39. Undo Model: Inverse Patch + Snapshot Hybrid

For reliable rewind, don't choose only one approach.

Healthiest model is hybrid:

- snapshot restore for larger jumps
- inverse patch for short local steps

### 39.1 Runtime Inverse Generation

Inverse patch doesn't need to be hardcoded in lesson file. Engine can (and should) generate inverse at moment of applying patch ("runtime pre-state").

- `setProp(new)` → engine remembers `setProp(old)`
- `toggleClass(cls)` → engine remembers `toggleClass(!cls)`

### 39.2 When to Use Snapshot

Use snapshot when:

- transitioning between steps
- having heavier DOM/state changes
- scene has many patches
- wanting stable `scrub`
- wanting fast recovery on reconnect

### 39.3 When to Use Inverse Patch

Use inverse patch when:

- patch has trivial rollback
- change is small and local
- wanting smooth `prev` without full restore
- wanting more precise debug

### 39.4 Recommended Rule

- snapshot at end of each step
- snapshot every 2-4 scenes
- inverse patch generated from runtime state before applying
- replay remains fallback if no snapshot or inverse

---

## 40. Reconnect and Restore Strategy

If preview reconnects, iframe resets, or live preview loses state, engine must know how to return to consistent point.

### 40.1 Reconnect Rule

After reconnect:

1. restore nearest valid snapshot
2. replay scene delta to active scene (deterministic)
3. reapply code effects
4. reapply UI overlays
5. only then continue playback

**Important:** Don't use "shortcut" method of matching old scenes. Always prefer deterministic replay from known snapshot.

### 40.2 What Reconnect Must Not Do

- "guess" state from DOM
- assume last animation
- use GSAP progress as state
- skip preview sync

### 40.3 Why This Matters

Without this rule:

- `prev()` becomes unreliable
- scrub becomes fragile
- autoplay can end in half-state
- debug becomes harder

---

## 41. Scene Execution Must Be Strictly Phased

As engine grows, it's important that scene execution is not one big "runScene" function without discipline.

### 41.1 Recommended Phases

1. resolve scene payload
2. validate prereq and allowed patch types
3. clear previous transient effects
4. restore or prepare baseline state
5. apply code effects
6. apply preview patches
7. apply UI overlays
8. do enter animations
9. sync narration
10. sync progress
11. emit debug and analytics event

### 41.2 Why

This order gives:

- predictability
- fewer race condition situations
- easier debugging
- easier testing by phases

---

## 42. Performance Guardrails

Polish phase is not just UX, but also performance.

### 42.1 What to Control

- number of active CodeMirror decorations
- number of DOM query calls per scene
- number of repaint/reflow points
- size of replay chain without snapshot
- number of simultaneous animations

### 42.2 Recommendations

- snapshot at fixed boundaries
- cache preview target reference where possible
- group patches by target
- don't do full preview reset on every scene
- turn off old UI overlay effects before new ones

### 42.3 Rule

Polish must not introduce "visually beautiful, but runtime expensive" system.

---

## 43. Accessibility Hardening

Frame-by-frame engine must remain accessible.

### 43.1 Required Directions

- keyboard `next/prev`
- focus must not be lost on scene change
- narration panel should be readable by assistive tech
- autoplay must be pausable
- motion heavy scene must have reduced-motion fallback

### 43.2 For `scene.ui`

If using popover/callout:

- must have clear focus model
- must not block basic flow without escape mechanism
- must not visually exist without textual equivalent where important

### 43.3 Rule

Teaching polish must not come at the cost of accessibility.

---

## 44. Observability and Debug Layer

As engine matures, it needs internal debug view.

### 44.1 Lifecycle Hooks

Engine should emit events that external tools can hook into (analytics, debug UI, tests):

- `onSceneEnter(sceneId)`
- `onSceneExit(sceneId)`
- `onPatchApplied(patch)`
- `onSnapshotCreated(id)`
- `onSnapshotRestored(id)`

### 44.2 Useful Debug Outputs

- active `stepId`
- active `sceneId`
- last applied patch IDs
- snapshot key
- replay source
- preview mode
- animation status
- failed prereq log

### 44.3 Useful Events

- `scene:enter`
- `scene:exit`
- `scene:replay`
- `snapshot:create`
- `snapshot:restore`
- `patch:apply`
- `patch:undo`
- `prereq:fail`

### 44.4 Why

This dramatically eases:

- testing
- bug reproduction
- authoring mistakes
- perf investigations

---

## 45. Playback Profiles

Engine should support different operating modes depending on context (development, demo, test).

### 45.1 Profiles

1. **Normal**
   - Standard user timing.
   - Respects `duration` and animations.
   - Used for end users.

2. **Slow**
   - Slowed timing (e.g. 0.5x or fixed delay).
   - Emphasizes transitions.
   - Used for presentations or debugging fast changes.

3. **Instant (Headless)**
   - `duration: 0` for all transitions.
   - Skips visual effects (fade, slide).
   - Used for automated testing, fast-forward, or initial load states.

---

## 46. Lint Rules for Authoring Hardening

As lesson data grows, you must early prevent authoring drift.

### 46.1 Proposed Rules

- each patch must have valid `type`
- each `id` must be unique at least within scene
- `undoId` must point to existing inverse or allowed fallback strategy
- `groupId` must not mix unrelated changes
- `prereq` must point to defined capability or milestone values
- `scene.ui` type must be from allowed vocabulary
- `duration` must be numeric and in allowed range
- `enter` and `exit` must not contain state mutation patch types

### 46.2 Benefits

- less implicit behavior
- less manual assumptions
- more readable lesson files
- safer refactor

---

## 47. Test Strategy for Hardening Phase

Polish layer must be covered by tests, not just manual clicking.

### 47.1 Unit Tests

Cover:

- patch normalization
- prereq validation
- snapshot create/restore
- inverse patch mapping
- scene resolve order
- replay determinism

### 47.2 Integration Tests

Cover:

- `next` through entire step
- `prev` over snapshot boundary
- `scrubTo(scene)` from multiple positions
- reconnect + restore
- DOM mode and state mode with same lesson payload

### 47.3 Regression Tests

For each serious bug create:

- minimal lesson fixture
- expected scene sequence
- expected preview outcome
- expected debug log

---

## 48. Definition of Done for Hardening Phase

Polish and hardening phase is done only when the following holds:

- `next`, `prev`, `goTo`, `scrub` are deterministic
- reconnect returns consistent state
- snapshot restore is reliable
- inverse patch doesn't introduce state drift
- `scene.ui` doesn't grow uncontrollably
- `prereq` catches authoring mistakes early
- GSAP is exclusively visual layer
- debug panel clearly shows scene execution
- reduced-motion and keyboard flow work
- same lesson payload can work in DOM and state preview mode

---

## 49. Recommended Introduction Order for Hardening Details

Don't introduce these all at once.

### Phase A — Metadata and Guardrails

- add `id`
- add `groupId`
- add `debugLabel`
- add limited `scene.ui` vocabulary

### Phase B — Rollback Stability

- add `undoId`
- introduce inverse patch map where it makes sense
- lock snapshot boundary rules

### Phase C — Authoring Reliability

- add `prereq`
- add lint for `scene.ui`
- add lint for `enter/exit`

### Phase D — Playback Polish

- add `duration`
- add `enter`
- add `exit`
- add reduced-motion fallback

### Phase E — Observability

- debug event log
- scene execution inspector
- snapshot inspector
- patch trace panel

---

## 50. Final Hardening Goal

Animator engine shouldn't just "work".

It should be:

- replayable
- rewindable
- authorable
- testable
- debuggable
- performant
- accessible

Ideal final model looks like this:

- `player state` decides what is active
- `scene delta` describes what changes
- `code effects` and `preview patches` execute the change
- `scene.ui` assists learning without taking over state responsibility
- `GSAP` only visually follows transition
- `snapshot` and `inverse patch` provide stable rewind and restore
- `prereq` and lint rules protect authoring layer
- debug layer enables every scene to be explainable and verifiable

---

## 51. Appendix: Existing Lesson Architecture

For current lesson architecture details, see:
- `.agents/governance/app-architecture/ARCHITECTURE.md`
- `.agents/business-logic/software/lesson-authoring/authoring/LESSON_AUTHORING.md`
