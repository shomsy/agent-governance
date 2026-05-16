# MILOS Academy - AGENTS.md

Version: 3.7.0
Status: Normative / Enforced
Scope: `academy/**`

This file is the binding contract for AI/code agents working in MILOS Academy.
MILOS Academy is the product layer. `@milos/layout-os` is the layout engine.

---

## 0) Aggregated Governance Mode (Mandatory)

Agents MUST follow this exact order of precedence:

1. `academy/AGENTS.md`
2. `academy/docs/BACKEND_ARCHITECTURE.md`
3. `academy/docs/FRONTEND_ARCHITECTURE.md`
4. `academy/docs/governance/execution-policy.md`
5. `academy/docs/governance/how-to-code-review.md`
6. `academy/docs/governance/how-to-coding-standards.md`
7. `academy/docs/governance/how-to-document.md`
8. `academy/docs/governance/LEGACY_CANONICAL_BOUNDARY.md`

Lower-priority documents MUST NOT override higher-priority documents.
If documents conflict, higher priority wins and the conflict must be recorded and fixed.

---

## 1) Execution Mode (Strict)

If a refactor/execution contract is active, agents are in EXECUTION MODE.

In execution mode:

- Implement, move, or refactor.
- Do not redesign architecture mid-iteration.
- Do not reopen review decisions without explicit approval.
- Do not perform speculative scope expansion.

If unclear:

- STOP
- RECORD the ambiguity
- ASK for clarification

Silent deviation is forbidden.

---

## 2) Canonical Repository Structure

```text
academy/
  src/
    domain/
      core/
      modules/
      composition/
    presentation/
      ssr/
      ui/
      apps/
    app.ts
    server.ts
  prisma/
  docs/
  scripts/
  AGENTS.md
```

Structure is architectural contract. File moves require reference updates and old location removal.
Dual implementations of the same responsibility are forbidden.

---

## 2.1) Canonical vs Legacy Boundary (Hard Rule)

Canonical source of truth for Academy is:

- `academy/src/**` (runtime source)
- `academy/docs/**` (governance and architecture)

Legacy compatibility namespace:

- `/lab/*` routes and `lab/*` references are legacy aliases only.
- Legacy aliases are redirect compatibility, never a source of truth.
- New implementation work under a legacy path is forbidden.

Migration rule:

1. Document canonical target path first.
2. Keep legacy redirect only while compatibility is required.
3. Remove legacy alias once roadmap marks migration complete.

---

## 3) Domain/Presentation Boundary Contract

- `src/domain/**` owns business logic and persistence orchestration.
- `src/presentation/**` owns SSR, browser runtime, and UI.
- Presentation must not access ORM/storage internals.
- Domain must not import EJS/browser modules.

Cross-module domain imports are allowed only via each feature `public.ts`.

---

## 4) Layout Engine Contract

- `@milos/layout-os` is the layout dependency.
- Engine primitives (`l-*`, `u-*`) are engine-owned.
- Product semantics (`academy-*`, `app-*`, `c-*`, `js-*`) are academy-owned.
- Academy must not define new engine DSL primitives.

---

## 5) Frontend Evolution Contract (Pages -> Web Components)

Frontend evolution is canonical and staged:

- Stage A: SSR pages-first foundation
- Stage B: app runtime modules (`apps/*/assets`, `apps/*/engine`)
- Stage C: extraction to Web Components where reuse contracts are stable
- Stage D: reusable component catalog and governance

Web Components migration must be explicit per iteration; no stealth migration.

---

## 6) Documentation Governance

Architectural decisions must have traceability in governance docs.

Mandatory evidence location:

- `academy/docs/governance/Code-Review-And-ToDo/review.md`

Docs are first-class deliverables, not optional artifacts.

---

## 7) Closure Evidence for Docs Iterations

A documentation-governance iteration is complete only when:

1. All affected documents are updated.
2. Cross-links are valid.
3. Changelog/ToDo status is updated when execution policy requires it.
4. Scope stays docs-only (unless explicitly approved otherwise).

No evidence means incomplete execution.

---

## 8) QA Gate

Before merge:

1. Validate impacted docs and links.
2. Ensure no runtime code changes when scope is docs-only.
3. Run optional sanity type-check when requested:
   - `npm run academy:typecheck`

If checks fail, work is not done.

---

## 9) Change Protocol

Every change report must include:

1. Contract impact summary
2. QA status (commands + result)
3. Version impact:
   - patch = internal fix
   - minor = additive non-breaking governance
   - major = breaking contract behavior

---

## 10) Git Workflow Discipline (Mandatory)

Branch policy for this repository is enforceable contract:

1. `main` is release/stable branch only.
2. `development` is integration branch for approved work.
3. Feature work MUST start from `development` using `feature/*` branches.
4. Merge path MUST be:
   - `feature/* -> development` (via PR + green CI),
   - `development -> main` (via PR + green CI).
5. Direct push to `main` is forbidden except approved `hotfix/*` protocol.

Hotfix protocol:

1. branch from `main` as `hotfix/*`,
2. merge to `main` after CI green,
3. back-merge same hotfix into `development`.

Any deviation must be explicitly approved and documented in review evidence.

---

## 11) CI-First + Codex Resource Discipline (Mandatory)

To reduce analysis/token overhead without reducing quality:

1. Prefer CI-first verification over repeated full local runs.
2. For failing changes, provide CI run URL + failed job log first; avoid broad re-analysis.
3. Use delta review for narrow diffs; use full review only for major architectural shifts.
4. Avoid repeated unchanged command suites when a recent green CI run already covers the same scope.
5. Keep governance evidence concise and append-only in `review.md`.

Default local validation profile:

- docs-only change: docs/link checks only,
- scoped code change: targeted local command(s) + CI run,
- release merge: full CI gate evidence required.

---

## 12) ChatGPT Companion Offload Discipline (Mandatory)

To reduce Codex usage while preserving delivery speed, agents MUST route non-implementation tasks to ChatGPT when practical.

Offload targets (recommended):

1. Drafting/rewriting PR descriptions, release notes, runbook prose.
2. Summarizing CI logs and producing issue triage text.
3. Preparing checklists, acceptance criteria, and stakeholder updates.
4. Brainstorming alternatives before code changes are requested.

Model routing contract:

1. `instant`:
   - tiny formatting/rewrite tasks,
   - very short summaries,
   - low-risk text polish.
2. `auto`:
   - default choice for routine docs/triage/supporting text.
3. `thinking`:
   - architecture tradeoff analysis,
   - medium-complex planning, prioritization, sequencing.
4. `extended thinking`:
   - high-stakes design decisions,
   - security/compliance reasoning,
   - migration strategy with irreversible impacts.

### 12.1 Mandatory User Reminder

In every final user-facing response, agent MUST include a short `ChatGPT Offload Note` with:

1. one concrete task user can do in ChatGPT to save Codex resources,
2. recommended model (`instant`, `auto`, `thinking`, or `extended thinking`),
3. short why/risk note.

If no offload is useful, agent must explicitly state:
`ChatGPT Offload Note: No offload recommended for this step.`

---

## 13) Production Quality Hardening Gate (Mandatory)

For release-path validation (`feature/* -> development -> main`), the following extra quality evidence is mandatory:

1. Security dependency audit passes:
   - `npm run -s academy:quality`
2. Runtime HTTP smoke passes against built runtime:
   - `npm run -s academy:smoke:runtime`
3. Smoke evidence must include all:
   - `/api/health` returns 200,
   - `/api/ready` returns 200,
   - unauthenticated protected API returns 401,
   - authenticated tenant-scoped protected API returns 2xx.
4. If `AUTH_MODE=jwt|hybrid`, evidence must include JWT expiry/revocation behavior (reject expired/revoked tokens).
5. CI workflow for release tip must contain and pass quality + runtime smoke steps.
