# Lesson Authoring

This file is the practical contract for converting content into an animated `Step By Step Animator` lesson.

## 1. Essence

A lesson is not ordinary text and is not a static tutorial.

The lesson must behave like you're watching a programmer over share screen:

- HTML is added element by element
- CSS is added property by property
- when the lesson requires it, executable source is added action by action
- preview shows exactly the same cumulative result that is currently authored
- every change must be visually clear and verbally explainable
- for Web Components lessons, JavaScript must first create the actual rendered DOM, only then CSS should style it
- Web Components lessons are visual-first: early steps should establish the rendered shell and styling before behavior is introduced step by step
- the user goal, the visible UX, and the step-by-step learning path must stay explicit in every lesson decision

## 1.1 Required Questions

Every lesson brief, step sequence, and authoring decision must answer:

1. What does the user want to achieve?
2. What should animator software do to make that possible?
3. What should the user see, and does the UX meet the highest standard?
4. What should the user learn visually and step by step?

If content cannot be broken into such small, readable steps, it is not ready for this type of animation yet.

## 2. Source-Only Lesson Root

Every new lesson goes in its own folder under:

```txt
product/
  education/
    lessons/
      feature-name/
        source/
          lesson.md
          theory.md
          scenes.md
          artifacts/
            html.timeline.md
            css.rules.md
            js.timeline.md
            template-js.timeline.md
            shadow-dom-style.css.md
          assets/
```

Rules:

- `product/education/` is source only
- no per-lesson build glue lives in `product/education/`
- `system/lesson-engine/` owns translation, validation, parsing, normalization, projection, and compilation
- `system/foundation/` owns shared frontmatter and markdown primitives
- `source/` is the only place where the lesson author writes material
- `assets/` stays beside the source and holds reference images or other authoring assets

## 3. File Contracts

### 3.1 `lesson.md`

`lesson.md` is the manifest and metadata source of truth.

It is a markdown file with YAML frontmatter.
The frontmatter is canonical.
The markdown body may be empty or may contain a short human intro, but it is not the machine contract.

Required frontmatter fields:

- `schemaVersion`
- `lessonId`
- `lessonTitle`
- `lessonIntro`
- `status`
- `courseId`
- `order`
- `scenes.file`
- `artifacts`
- `preview.type`
- `preview.title`

Optional frontmatter fields:

- `theory.enabled`
- `theory.file`
- `goal`
- `homework`
- `references`
- `tags`
- `difficulty`
- `estimatedMinutes`

Recommended status values:

- `draft`
- `active`
- `broken`
- `deprecated`

Recommended preview types:

- `dom`
- `terminal`
- `markdown`
- `diagram`
- `none`

Canonical lesson.md example:

```md
---
schemaVersion: 1
lessonId: 01-build-sidebar
lessonTitle: Build Sidebar
lessonIntro: In this lesson we build a sidebar step by step.
status: active
courseId: web-components
order: 1

theory:
  enabled: true
  file: ./theory.md

scenes:
  file: ./scenes.md

artifacts:
  - artifactId: html
    file: ./artifacts/html.timeline.md
    language: html
    kind: timeline
    label: index.html
    isPrimary: true

  - artifactId: css
    file: ./artifacts/css.rules.md
    language: css
    kind: rules
    label: style.css
    isPrimary: false

preview:
  type: dom
  title: Sidebar Preview

goal:
  title: What we are building
  imageSrc: ./assets/goal.png
  imageAlt: Sidebar final preview
  imageCaption: Final sidebar result

homework:
  enabled: true
  title: Homework
  items:
    - Add hover effects to sidebar items
    - Add nested menu items

references:
  - title: MDN HTMLElement
    href: https://developer.mozilla.org/
---
```

Rules:

- `lessonId` must match the lesson folder slug
- each `artifactId` must be unique
- every artifact entry must point to one source file
- `theory.file` is required only when `theory.enabled` is `true`
- `scenes.file` must always exist
- `lesson.md` declares what exists; it does not implement the lesson

### 3.2 `theory.md`

`theory.md` is the explanation layer.

It is plain markdown prose.
It explains the mental model, the why, the business reason, and the conceptual path.
It is not a playback script.
It is not a build instruction file.

Rules:

- `theory.md` may be optional when `lesson.md` says so explicitly
- if present, it should stay readable as ordinary markdown
- headings may be used as anchors for `scenes.md`
- `theory.md` can explain concepts, tradeoffs, and "why this order" reasoning
- `theory.md` must not contain runtime logic or imperative compiler steps

### 3.3 `scenes.md`

`scenes.md` is the canonical storyboard DSL for lesson playback.

It is strict, declarative, and machine-readable.
It describes teaching moments, not runtime code.

Core model:

- `step` is the primary pedagogical unit
- `scene` is the directed frame inside a step

File shape:

- frontmatter declares ordered steps
- the body contains step sections and scene sections

Frontmatter contract:

- `schemaVersion` is required
- `lessonId` is required
- `steps` is required and ordered
- every step must declare `stepId`, `title`, `summary`, and `intent`
- `stepId` must be unique and use `kebab-case`
- frontmatter order is execution order

Body contract:

- each step must appear exactly once as `# Step: <stepId>`
- each scene must appear inside a declared step as `## Scene: <sceneId>`
- every scene must declare `sceneId` and `narration`
- every scene must include at least one of `focus`, `code`, `preview`, or `theory`
- narration-only scenes are allowed only when the validator explicitly permits them

Field contract:

- `focus.artifactId` must exist in `lesson.md`
- `code.activeArtifactId` must exist in `lesson.md`
- `theory.anchor` must exist in `theory.md`
- `preview.action` must be one of `apply-state` or `none`
- `preview.target` must match the lesson preview capability

Scene discipline:

- one clear change or one clear explanation per scene
- deterministic order
- no hidden sorting
- no empty scenes
- keep it readable out loud in one breath

Canonical scene shape:

```md
---
schemaVersion: 1
lessonId: 01-build-sidebar
steps:
  - stepId: add-sidebar-shell
    title: Add sidebar shell
    summary: Introduce the base sidebar container.
    intent: Establish the minimum HTML structure before styling.

  - stepId: add-sidebar-navigation
    title: Add sidebar navigation
    summary: Add a navigation block inside the sidebar.
    intent: Introduce semantic navigation before visual refinement.
---

# Step: add-sidebar-shell

## Scene: intro-shell

narration:
First, we introduce the simplest possible sidebar shell.

focus:
  artifactId: html
  reveal:
    from: 1
    to: 3

code:
  activeArtifactId: html
  highlightLines:
    - from: 1
      to: 3

preview:
  action: apply-state
  target: dom

theory:
  anchor: why-shell-first

## Scene: explain-empty-css

narration:
CSS stays empty for now because structure comes before visual identity.

focus:
  artifactId: css
  reveal:
    from: 1
    to: 1

code:
  activeArtifactId: css

preview:
  action: none

theory:
  anchor: structure-before-style

# Step: add-sidebar-navigation

## Scene: add-nav-block

narration:
Now we add a navigation block inside the sidebar.

focus:
  artifactId: html
  reveal:
    from: 1
    to: 6

code:
  activeArtifactId: html
  highlightLines:
    - from: 2
      to: 5

preview:
  action: apply-state
  target: dom

theory:
  anchor: sidebar-as-navigation
```

Validation rules:

- steps must be declared in frontmatter and appear exactly once in the body
- scenes must belong to declared steps
- scene ids must be unique inside each step
- cross-references must resolve
- unknown preview actions, artifact ids, or theory anchors are validation errors

Authoring rules:

- write steps as pedagogy
- write scenes as direction
- keep narration human
- use theory links when they add conceptual value
- do not use scenes to hide missing step design
- do not use steps as vague topic buckets
- every scene must justify its existence

Final rule:

A good `scenes.md` file should let a human review the lesson flow without opening engine code, and let the lesson engine compile the lesson without guessing author intent.

### 3.4 `artifacts/`

`artifacts/` contains the canonical source artifacts for the lesson.

The source artifact is the real desired content.
It is not generated output.
It is not a build artifact.

Recommended naming pattern:

- `html.source.html`
- `css.source.css`
- `js.source.js`
- `template-js.source.js`
- `shadow-css.source.css`
- `php.source.php`
- `sql.source.sql`
- `yaml.source.yaml`
- `readme.source.md`

Rules:

- each artifact entry in `lesson.md` must map to exactly one file in `artifacts/`
- file extension must match the declared language
- artifact names should be banal and predictable
- new artifact kinds belong in the engine contract, not in per-lesson glue

### 3.5 `assets/`

`assets/` contains reference visuals and any other non-executable authoring asset.

Rules:

- goal images belong here
- extra practice variants belong here
- assets are optional, but when they exist they must be referenced from `lesson.md`

## 4. Rules for Animated Lesson Flow

### 4.1 Beginning

If the lesson builds a component, start from the smallest neutral beginning.

For layout or component work that is most often:

```html
<div class="app-shell">
```

Do not insert early filler content that the lesson does not explain.

### 4.2 Step and Scene Rules

Write the lesson as a sequence of steps, and each step as a sequence of scenes.

Good:

1. define the step
2. open the first scene
3. reveal one source artifact change
4. narrate why it matters
5. show the preview change
6. move to the next scene

Bad:

- collapse everything into one giant step
- mix multiple pedagogical moves into one scene without a reason
- let a scene become a hidden mini-lesson

### 4.3 Source Growth Rules

Source grows in the smallest explainable increments.

Good:

1. add root wrapper
2. add main semantic element
3. add child zone
4. add child element
5. add label or copy

Bad:

- paste the finished source file all at once
- skip intermediate states that the preview should teach

### 4.4 Presentation Rules

When some unit is still under construction, helper lines are mandatory if they help orientation.

Rules:

- helper outline or border is introduced early
- `.app-shell` must also get its thin helper outline and keep it through the entire lesson, until the final shell summary
- each sub-element of the same unit should have its own thin helper outline
- each sub-element of the same unit may have its own helper color
- helper styles stay active until the final summary step for that element or unit
- final summary step only then removes helper styles

Step narration must say this:

- when introducing helper style: `We're adding a temporary helper border for easier orientation, we'll remove it later.`
- when removing it: `We're removing the temporary helper border, we don't need it anymore.`

### 4.5 Focus Rules During Styling

While styling some element, the corresponding HTML target in the editor panel must be clearly highlighted in yellow.

This means:

- the current scene should show exactly which source area is being worked on
- the highlight must be prominent enough to understand instantly
- the same scene should not spread focus across too many unrelated elements

### 4.6 Preview Integrity

Preview must be the actual result of the same source shown in the authoring contract.

This means:

- no special fake preview DOM
- no manually directed scene
- no source file that did not come from the lesson contract
- no preview state that the canonical lesson package cannot reproduce

### 4.7 Web Components Lesson Phases

Web Components lessons are written in two pedagogical phases: visual composition first, then behavior and API.

Rules:

- the visual phase may use the minimum JavaScript needed to make the component actually render, but the teaching goal is still to make the component visibly real and styled before behavior grows
- the logic phase is where attributes, `observedAttributes`, properties, events, lifecycle, methods, state, and cleanup are introduced
- do not split the lesson by file type alone; split it by the learner's mental model: first I can see the component, then I can understand how it behaves
- when a step could belong to either phase, prefer the step that shows the final UI sooner without hiding the behavior contract

## 5. How to Break Content Into Steps and Scenes

Before writing files, break content in this order:

1. What is the final result?
2. What are the main pedagogical steps?
3. In what order should the learner see them to understand the building?
4. What are the scenes inside each step?
5. What is the smallest source increment that still makes sense?
6. What is the smallest visible or logical change that preview should show?

Most common good order is:

1. root shell
2. main semantic wrapper
3. first large unit
4. child elements of that unit
5. helper styles for orientation
6. layout properties
7. spacing
8. colors and typography
9. interaction states
10. responsive rules
11. final summary

## 6. What To Tell AI

If you want AI to convert content into a lesson, give it the UI goal and strict source rules.

Use this template:

```txt
Convert this into a Step By Step Animator lesson.

Lesson goal:
- Make [component or layout name]
- Final result should look like [short description]

Repo contract:
- root split is `product/` and `system/`
- add new lesson under `product/education/lessons/[feature-name]/source/`
- make:
  - `lesson.md`
  - `theory.md` when the lesson needs it
  - `scenes.md`
  - `artifacts/[artifactId].source.[ext]`
  - `assets/[feature-name]-goal.svg` when reference image exists
- do not create per-lesson build files
- do not create runtime parser code in the lesson folder
- keep authoring source-only

Authoring rules:
- step is the pedagogical unit
- scene is the frame inside the step
- step and scene must be easy to explain out loud
- source artifacts are canonical desired content
- preview must be derived from the same source contract
- every scene must make one clear change or one clear explanation
- use simple, predictable names

Deliver output ready for this repo.
```

## 7. Quick Filter Before Every New Scene

Before keeping a scene, check:

- Does this scene make one clear change?
- Can preview clearly show that change?
- Could I explain this scene by voice without jumping around?
- Is this a natural next scene for a learning human?
- Does the scene belong to the right step?

If the answer is not `yes`, the scene should be broken or moved.
