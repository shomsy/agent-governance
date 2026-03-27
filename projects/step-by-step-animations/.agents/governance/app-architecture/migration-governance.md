# Migration Governance Record

Status: completed.

This document records the completed migration from the legacy `lessons/` + `animator/` shape to the source-only `product/education/` + `system/lesson-engine/` + `system/animator-engine/` + `product/app/` + `system/foundation/` + `system/lesson-engine/output/` shape.

It is not an active plan.
It is a historical governance record and a reference for the rules that remain in force after the migration.

## Completed Checkpoints

### Freeze The Contracts

- locked `lesson.md`, `theory.md`, `scenes.md`, and `artifacts/` as the source-only authoring contract
- kept legacy `lessons/` and `animator/` readable, but stopped extending them
- aligned the owning documents that define architecture, authoring, and work discipline

### Pilot One Lesson

- created the source-only pilot lesson layout under `product/education/lessons/<lesson-slug>/source/`
- authored lesson metadata, theory, scenes, and artifacts in the new contract
- made the lesson engine compile the pilot into a canonical lesson package

### Separate Compiler From Runtime

- moved translation logic into `system/lesson-engine/`
- kept runtime playback in `system/animator-engine/`
- removed raw lesson-source parsing from runtime entry points
- introduced `system/foundation/` for frontmatter and markdown primitives where they are actually shared

### Migrate The Remaining Lesson Slices

- moved each lesson slice using the same source-only contract
- kept lesson authoring deterministic and boring
- avoided a second authoring style during migration
- kept the same step and scene semantics across lessons

### Retire Legacy Glue

- retired per-lesson build files from the source-only lesson tree
- retired old document-generation paths that duplicated the compiler
- removed migration-only adapters once they were no longer needed

## Governance That Remains In Force

- lessons are authored source-only
- the compiler owns translation
- the runtime consumes only compiled lesson packages
- the app shell stays separate from lesson logic
- names must stay simple, predictable, and flow-first
- the evidence ledger in `.agents/management/evidence/CHANGELOG.md` is the active running log for follow-up state
