# Architecture

This document applies the reusable standard from `.agents/governance/app-architecture/architecture-standard.md` to the Step By Step Animator repo.

## Scope and Authority

- `AGENTS.md` governs execution, delivery discipline, and collaboration.
- `.agents/governance/app-architecture/architecture-standard.md` defines the reusable architecture baseline.
- This file binds that baseline to this repo and keeps it concrete.

If a repo-specific exception is needed, it must be documented here and it must not lower the baseline quality bar.

## Migration Posture

This repo follows the live canonical boundaries in the current product/system split.

- `product/`, `system/`, `system/lesson-engine/`, and `system/lesson-engine/output/` are the live boundaries
- the live app surface is rooted at `product/app/index.html`
- new work must stay inside the target boundaries

## Vertical Slice Intent

This repo uses vertical-slice, feature-first architecture.

- the same model applies to animator runtime slices and lesson business slices
- folder names must describe flow or capability
- file names must describe responsibility
- function names must describe exact action
- the reader should be able to predict what a folder, file or function does before opening it
- the business flow should stay readable from the first feature to the last feature without changing the mental model
- technical slices and product slices should both read as vertical slices

## Repo Shape

The live repo is organized into these canonical areas:

- `product/` for the host shell and source-only lesson authoring
- `system/` for compiled lesson playback and shared primitives
- `system/lesson-engine/` for translation, validation, normalization, projection and compilation
- `system/lesson-engine/output/` for derived outputs

Read the tree in this order:

1. Flow
2. Feature slice
3. File responsibility
4. Function action

Representative example:

This block is illustrative, not exhaustive. The live lesson set is registered in `system/lesson-engine/register-lesson-packages/index.js`.

```txt
step-by-step-animator/
  AGENTS.md
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

## Naming Rules

### 1. Folder says flow

Use a folder name that tells what the product is doing.

Good:

```txt
system/animator-engine/
product/education/lessons/<lesson-slug>/source/
system/lesson-engine/register-lesson-packages/
review-progress/
```

Bad:

```txt
src/
modules/
features/
services/
```

### 2. Feature folder says use case

The next folder must tell which concrete product scenario is being handled.

Good:

```txt
play-lesson/
01-build-sidebar/
retry-payment/
```

Bad:

```txt
lesson/
sidebar/
payment/
```

## File Rules

### 3. Root file tells the feature flow

If the feature is sequential, use:

```txt
feature-name.pipeline.js
```

If the feature is a source-only lesson contract, use:

```txt
product/education/lessons/<lesson-slug>/source/lesson.md
```

Markdown lesson documents live under the source contract:

```txt
product/education/lessons/<lesson-slug>/source/lesson.md
product/education/lessons/<lesson-slug>/source/theory.md
product/education/lessons/<lesson-slug>/source/scenes.md
product/education/lessons/<lesson-slug>/source/artifacts/html.timeline.md
product/education/lessons/<lesson-slug>/source/artifacts/css.rules.md
product/education/lessons/<lesson-slug>/source/artifacts/js.timeline.md
product/education/lessons/<lesson-slug>/source/artifacts/template-js.timeline.md
product/education/lessons/<lesson-slug>/source/artifacts/shadow-dom-style.css.md
```

Source-only lesson docs are authored in markdown.
The lesson engine compiles them into the canonical lesson package.

## Root Ownership Rules

Each feature slice must have one root owner that makes the whole slice obvious.

- use `*.pipeline.js` when the flow is sequential
- use `*.facade.js` when the feature needs one stable entry into a larger interior
- use `*.orchestrator.js` when the root coordinates branches, events or multiple subflows
- use a single root function or single root file when that is the clearest composition root
- use a banal main name when that is more readable than a pattern name

If none of the named patterns is the clearest answer, use the smallest construct that can still own the whole feature slice.

The same rule applies to runtime slices under `system/animator-engine/`, source-only lesson slices under `product/education/lessons/`, and compiler slices under `system/lesson-engine/`.

### 4. Every other file owns one clear responsibility

Good:

```txt
lesson.md
scenes.md
compile-lesson-package.js
present-step-finder.js
show-growing-code.js
```

Bad:

```txt
helpers.js
utils.js
shared.js
common.js
manager.js
processor.js
```

### 5. Use numbers only when sequence truly matters

Use `01-...`, `02-...` only when the folder order itself carries product meaning without opening the pipeline.

This repo uses numeric prefixes on ordered lesson flows in `product/education/lessons/` and on the generic lesson journey inside `system/animator-engine/play-lesson/`:

```txt
01-build-sidebar/
02-build-top-navigation/
03-build-custom-element/
04-build-web-component/
05-clean-web-component-with-adopted-stylesheets/
06-modular-web-components/
07-more-separation-of-code/
08-smell-of-enterprise/
```

```txt
01-start-lesson/
02-follow-lesson/
03-watch-code/
04-watch-preview/
05-download-lesson-files/
```

Support flows such as `find-step/`, `save-step/`, and `choose-theme/` stay unnumbered because they are available across the lesson and are not mandatory sequence steps.

### 6. Do not repeat the feature name inside the feature folder

If the folder already says `01-build-sidebar`, do not keep repeating `build-sidebar` in every child file and function.

Good:

```txt
01-build-sidebar/
  lesson.md
  scenes.md
```

Bad:

```txt
01-build-sidebar/
  build-sidebar-steps.js
  build-sidebar-view.js
```

## Function Rules

### 7. Function name says the exact action

Good:

```txt
playLesson()
selectLessonFromLocation()
showGrowingCode()
downloadLessonFiles()
```

Bad:

```txt
handle()
run()
process()
manage()
doStuff()
```

### 8. Keep one vocabulary per responsibility kind

Use verbs consistently by responsibility:

- these buckets are the first filter for file and function names
- before you pick the exact verb, classify the work in this order:
  - CRUD: touch one record
  - Query: look at data without changing it
  - Business: do what the business wants
  - System: help the system move, sync, validate or recover
  - State transition: move a thing from one state to another
- `build...` creates derived lesson code for a specific step.
- `show...` writes current lesson content into already-found page parts.
- `present...` owns an interactive user flow such as lesson picker or step finder.
- `create...` initializes progress for a flow.
- `find...` locates a selected lesson or existing page parts.
- `read...` is reserved for persistence reads.
- `write...` is reserved for persistence writes.
- `play...` orchestrates the complete lesson flow.

## Quality Targets

The repo applies the standard's quality goals without exception.

- SOLID, DRY, KISS and YAGNI
- composition over inheritance, Law of Demeter, clean code principles and low-level design clarity
- security by default, OWASP, authentication, authorization, data encryption, vulnerability management and secure APIs
- usability, flexibility, scalability, interoperability and cost efficiency
- cache, rate limiting, checksum, integrity and reproducibility where relevant
- latency vs throughput trade-offs chosen deliberately
- CAP and consistency patterns made explicit when they matter
- long polling vs WebSockets chosen deliberately when transport behavior matters
- observability and operational simplicity

Quality must live inside the slice, but it must not hide the folder/file/function story.

## Functional Programming and Non-OOP Languages

When a language or slice is not OOP-first, low-level design must be expressed as functional design with the same clarity bar.

- use pure functions as the smallest meaningful design unit when possible
- keep inputs explicit and outputs deterministic
- isolate side effects at the edges
- prefer immutable data and data transformation pipelines
- compose behavior through modules, higher-order functions and explicit dependency passing
- if a feature slice is sequential, a pipeline root still owns the flow
- if a feature slice is not sequential, use the smallest root composition unit that makes the whole slice obvious

In non-OOP environments, LLD becomes functional clarity, not a weaker version of architecture.

## Anti-Patterns

Do not introduce these unless there is a very strong reason:

- `utils`
- `helpers`
- `shared`
- `common`
- `base`
- `manager`
- `service`
- `controller`

Avoid tight coupling, premature reuse, over-engineering and insufficient abstraction.

## Standard

Use this sentence as the filter before every new file:

> If the folder does not say the flow, the file does not say the responsibility, or the function does not say the exact action, the name is not good enough.

## Change Policy

- if a change affects repo shape, update this document in the same change
- if a change affects the reusable standard, update `.agents/governance/app-architecture/architecture-standard.md`
- do not invent invisible exceptions
- do not add a folder, file, or abstraction unless it reduces mental noise

## Lesson Authoring

How a lesson becomes animated is documented in [.agents/business-logic/software/lesson-authoring/authoring/LESSON_AUTHORING.md](/home/shomsy/projects/step-by-step-animator/.agents/business-logic/software/lesson-authoring/authoring/LESSON_AUTHORING.md).
