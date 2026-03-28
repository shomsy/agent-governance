# Profile Resolution Algorithm

Version: 1.0.0
Status: Normative

## Purpose

Given only the local root `AGENTS.md`, the copied `.agents/` folder, the actual
repository tree, and the current user task, the agent must be able to resolve:

- the active SDLC lane
- the applicable language profiles
- the applicable framework or runtime profiles
- the applicable architecture overlays
- the required security and operations rules
- the completion ceremony and evidence set

This file defines that deterministic resolution order.

## Core Rule

The agent must not improvise stack law from vibes.
It must resolve the rule pack in a predictable order.

The target is:

`task lane -> stack -> architecture -> coding rules -> security -> release or evidence`

## Required Child-Repo Declaration

Every adopting repository should declare this explicitly in its root
`AGENTS.md` under a short section such as `Applied Governance Stack`:

- delivery kind or system kind
- languages
- frameworks or runtimes
- applied coding profiles
- applied architecture profiles
- whether `security/**` is mandatory
- whether `operations/**` is mandatory
- canonical validation, development, and release entrypoints

Explicit declaration is preferred over inference.
Inference exists only as a safe fallback.

## Resolution Order

Resolve rules in this order:

1. root `AGENTS.md`
2. `.agents/AGENTS.md`
3. `.agents/governance/quality-gates.md`
4. this file
5. `.agents/governance/profiles/**`
6. `.agents/governance/app-architecture/**`
7. `.agents/governance/security/**`
8. `.agents/governance/execution-policy.md`
9. lane-specific governance such as review, documentation, release, or ops
10. `.agents/business-logic/**`
11. `.agents/language-specific/**`
12. `README.md` and other local supporting docs

If two rules conflict:

- local root `AGENTS.md` wins over reusable defaults
- quality, safety, and security floors cannot be weakened silently
- framework rules may narrow language rules
- architecture profiles shape structure; coding profiles shape behavior
- local `language-specific/**` may narrow a reusable profile, not contradict a
  safety floor

## Step 1: Classify The Task Lane

Before reading stack details, classify the task into one primary lane:

- `brainstorm`: exploring options, tradeoffs, or architecture directions
- `planning`: turning scope into execution steps and owned backlog
- `coding`: changing implementation
- `review`: evaluating existing changes or claimed readiness
- `documentation`: writing or updating docs as the primary deliverable
- `security`: threat modeling, security hardening, vulnerability response, or
  policy review
- `release`: packaging, rollout, rollback, smoke, handoff, or production claim
- `operations`: runtime diagnosis, restore, recovery, observability, or support

If a task spans multiple lanes, choose the primary lane first and then add the
secondary lanes explicitly.
Example: a release hotfix is `coding + security + release + operations`.

## Step 2: Resolve Explicit Stack Declarations

Read the local root `AGENTS.md` and extract:

- declared languages
- declared frameworks or runtimes
- declared architecture profiles
- declared system kind such as `web app`, `API`, `worker`, `CLI`, `library`,
  `design system`, or `monolith`
- declared required security and operations lanes

If the root file declares a profile, that declaration is authoritative unless it
is obviously stale relative to the repo tree.
Stale declarations must be called out as governance drift.

## Step 3: Infer Missing Stack Facts From Repository Signals

If the root declaration is incomplete, infer only what is strongly supported by
the repository.

Use signals like these:

- `composer.json` -> `php`
- `composer.json` with `laravel/framework`, `artisan`, or standard Laravel
  folders -> `laravel`
- `package.json` -> `nodejs` runtime candidate
- `tsconfig.json` or `*.ts` / `*.tsx` source -> `typescript`
- `package.json` without TypeScript signals -> `javascript`
- `next.config.*` or `next` dependency -> `nextjs`
- `react` dependency or `tsx` UI slices -> `react`
- `express` dependency or explicit Express server entrypoints -> `express`
- `.css` files, token layers, or component styling boundaries -> `css`

Inference rules:

- only infer profiles that actually exist under reusable `.agents` governance
- do not invent framework-specific rules that do not exist
- if evidence is weak, stay at the broader language or architecture baseline
- if the repo is polyglot, compose all clearly-owned profiles instead of
  pretending there is only one

## Step 4: Resolve Architecture Overlays

Architecture resolution order is:

1. `.agents/governance/app-architecture/architecture-standard.md`
2. relevant app-architecture language profiles
3. relevant app-architecture framework profiles
4. child-repo `.agents/governance/app-architecture/ARCHITECTURE.md`
5. repo-local exceptions in root `AGENTS.md`

Architecture overlays answer:

- how the repo is shaped
- where vertical slices begin
- what the root of each slice owns
- what the ingress, facade, pipeline, orchestration, or adapter boundaries are
- what naming law the folders, files, and functions must obey

## Step 5: Resolve Coding Profiles

Coding resolution order is:

1. `.agents/governance/how-to-coding-standards.md`
2. `.agents/governance/naming-standard.md`
3. relevant language profiles from `.agents/governance/profiles/languages/**`
4. relevant framework profiles from `.agents/governance/profiles/frameworks/**`
5. repo-local `.agents/language-specific/**` only when reusable profiles are not
   enough

Use coding profiles for:

- syntax and typing law
- runtime behavior and failure handling
- module or package discipline
- interop rules
- performance, cache, and resource posture
- stack-specific security behavior

## Step 6: Add Security And Operations Layers

Security is not optional when the system handles users, secrets, external
input, state mutation, deployable infrastructure, or public interfaces.

Always add `.agents/governance/security/**` when the task touches:

- auth, session, identity, or permissions
- APIs, forms, uploads, or external input
- secrets, keys, tokens, or environment variables
- CI/CD, release automation, artifact publication, or dependencies
- vulnerability handling, threat modeling, or incident response

Add `.agents/governance/operations/**` when the task touches:

- deployment, smoke, rollback, restore, backup, or recovery
- runtime observability and operator evidence
- handoff contracts between application and infrastructure

## Step 7: Build The Lane-Specific Rule Pack

After the stack is known, build the lane pack.

### Brainstorm

Use:

- `quality-gates.md`
- this file
- app architecture baseline and relevant overlays
- security baseline when the idea touches trust boundaries
- local business and glossary docs

Goal:

- produce defendable options without pretending implementation already exists

### Planning

Use:

- `quality-gates.md`
- this file
- relevant architecture and profile overlays
- `execution-policy.md`
- local management queues and plan templates

Goal:

- convert scope into owned, validated, and queue-backed execution

### Coding

Use:

- `quality-gates.md`
- this file
- app-architecture overlays
- coding profiles
- `execution-policy.md`
- `security/**` when relevant
- local business logic and root `AGENTS.md`

Goal:

- produce the minimal safe delta that obeys the stack law and repo shape

### Review

Use:

- `quality-gates.md`
- this file
- `how-to-code-review.md`
- `how-to-strict-review.md` when production readiness or major claims are in
  scope
- relevant stack profiles
- `security/**` for trust-boundary changes

Goal:

- judge the real behavior and evidence, not only code style

### Documentation

Use:

- `how-to-document-flow.md`
- `how-to-document.md`
- `naming-standard.md`
- relevant stack and architecture overlays when docs describe implementation

Goal:

- make the real flow, ownership, and operator contract obvious

### Security

Use:

- `security/README.md`
- all relevant security sub-docs
- relevant stack profiles
- `quality-gates.md`
- release and operations rules if the work changes deployment posture

Goal:

- preserve secure SDLC posture instead of bolting on late fixes

### Release

Use:

- `release-and-rollback-policy.md`
- `operations/**`
- `security/**`
- `quality-gates.md`
- local evidence records and release entrypoint definitions

Goal:

- prove the shipped artifact, rollback path, and runtime evidence agree

### Operations

Use:

- `operations/**`
- `security/vulnerability-and-incident-response.md` when trust or compromise is
  involved
- `release-and-rollback-policy.md`
- relevant stack profiles where runtime behavior matters

Goal:

- recover or diagnose the system without guesswork

## Step 8: Completion Contract By Lane

The lane determines what done means:

- `brainstorm`: options, risks, and recommendation are explicit
- `planning`: task breakdown, ownership, and queue placement are explicit
- `coding`: implementation, validation, evidence, and backlog update exist
- `review`: findings or explicit no-findings judgment are recorded
- `documentation`: canonical docs match the real system
- `security`: threat, mitigation, validation, and residual risk are explicit
- `release`: rollout, smoke, rollback, and evidence bundle are explicit
- `operations`: diagnosis, containment, recovery, and follow-up tasks are
  explicit

## Fallback Rule

If the repo does not declare a stack cleanly and inference is weak:

- fall back to universal quality, security, execution, and architecture law
- apply only the profiles with strong evidence
- record the missing declaration as governance debt

The agent must prefer safe under-application over confident hallucination.
