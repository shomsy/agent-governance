# MILOS: Modular Intrinsic Layout Orchestration System (2026 Agent Contract)

Version: 3.1.0 (Enterprise Engine + Standalone LMS Architecture - MAXIMAL ENFORCEMENT)
Status: Normative / Enforced

This file is the binding contract for AI and code agents in this repository.
It defines the **Execution Mode** and **Structural Integrity** rules.

---

## 1) Execution Mode (STRICT)

If a refactor or execution contract exists, you are in **EXECUTION MODE**.

In EXECUTION MODE:

- You implement, move, or refactor code.
- You do NOT redesign architecture.
- You do NOT re-open review decisions.
- You do NOT perform speculative analysis.

If something feels “wrong” or unclear:

- **STOP**
- **RECORD it**
- **ASK for clarification**

Silent deviation is forbidden.

---

## 2) Structural Refactor Rule (CRITICAL)

During structural refactors:

- Moving files or namespaces REQUIRES:
  - removing the old location immediately.
  - updating all references.
- **Two implementations of the same responsibility MUST NEVER coexist.**
- Duplication is a **hard architectural violation.**

If a class is moved:

- the old file MUST be deleted.
- aliases or transitional duplicates are NOT allowed.

---

## 3) Changelog Governance (MANDATORY)

### 3.1 CHANGELOGS Folder

- A folder named **`CHANGELOGS`** MUST exist at the **root of the subsystem**.
- Folder name MUST be **uppercase**: `CHANGELOGS`.
- If it does not exist, you MUST create it before proceeding.

### 3.2 Goal-Oriented Changelog Rule

- Changelogs are **goal-based**, NOT cycle-based.
- **ONE changelog file per GOAL** (not one per commit).
- File Naming: lowercase, e.g., `refactor-router-v3.md`, `bootstrap-isolation.md`.

### 3.3 Mandatory Changelog Content

Each changelog file MUST contain:

- Goal name
- Status (In Progress | Completed | Partially Completed)
- Start date (date + time)
- Intent (why this goal exists)
- Scope (included / excluded)
- Execution summary
- Architectural decisions
- Risks & trade-offs
- Validation steps
- Outcome
- Next goals (if any)

### 3.4 Update Rules

- Created when a new goal starts.
- Updated when status changes.
- MUST reference involved cycles and major decisions.
- MUST NOT duplicate `ToDo.md` or contain speculative plans.

---

## 4) Snapshot & Traceability Rule

Changelogs, `ToDo.md`, and snapshots serve **different purposes**:

- **`ToDo.md`** → execution state (tasks).
- **`CHANGELOGS/*`** → intent and outcome (history).
- **`[Subsystem].Cycle-<N>.txt`** → exact code snapshot.

You MUST NOT merge or conflate these roles.

---

## 5) File Creation & Update Discipline

You MUST:

- Create missing governance folders/files when required.
- Respect naming, casing, and placement rules.
- Treat governance artifacts as **first-class deliverables**.

Failure to create or update required governance files is considered **incomplete execution**.

---

## 6) Final Execution Principle

> Architecture defines **where** code lives.
> Execution policy defines **when** work happens.
> Review defines **why** decisions exist.
> Changelogs preserve **intent and truth over time**.

If any of these are skipped, the work is **not enterprise-grade**.

---

## 7) Non-Negotiable Closure Rule

You MUST NOT:

- Silently proceed to the next goal.
- Start documentation without approval.
- Assume completion without explicit confirmation.

Completion is proven by:

- Updated `ToDo.md`
- Updated goal changelog
- Generated snapshots
- Passing tests

**Silence is NOT compliance.**

---

## 8) Architecture Execution Policy (Summary)

Detailed policy is in `lab/docs/governance/execution-policy.md`.

- **Review Closure**: Review phase ends when decisions are recorded. It becomes historical context.
- **Post-Review Transition**: Every completed Architecture Review MUST result in an updated **`ToDo.md`**.
- **Iteration Contract**: One primary goal, explicit non-goals, and completion criteria.
- **Scope Discipline**: Note new issues, but do NOT implement them mid-iteration.
- **Final Principle**: Review decides direction. Execution delivers change. The two must never be mixed.

---

## 9) Enterprise Node.js / Express / Postgres Rules

Standards for secure, scalable API services:

- **OWASP Compliance**: Helmet, CORS restrictiveness, Rate limiting.
- **Security**: No secrets in code. Use env vars. Parameterized SQL queries only (no concatenation).
- **AuthN/AuthZ**: Access control per resource. Password storage via Argon2/BCrypt.
- **Database**: Connection pooling required. Versioned migrations.
- **Multi-tenancy**: Mandatory `tenant_id` isolation in all queries.
- **Observability**: Structured JSON logging, correlation IDs, `liveness`/`readiness` checks.

---

## 10) Layer Order & Namespace Rules (MILOS Core)

- **Layers**: `@layer settings, foundation, layout, components, utilities;`
- **Namespaces**:
  - `l-`: Layout primitives
  - `u-`: Utilities
  - `c-` / `app-`: Application visuals
  - `js-`: Behavior hooks

---

## 11) Lesson & UX Contract (`lab/*`)

- Classroom pages MUST have IDs: `#taskList`, `#progress`, `#cssEditor`, `#manual-styles`, `#submitBtn`, `#resetBtn`, `#nextBtn`.
- No inline styles or inline logic in classroom pages.
- Lessons must be data-driven via `lessons.json`.

---

## 12) Enforcement

Any process violation (analysis during execution, expanding scope, missing changelogs) **invalidates the iteration output**.
Completion is strictly proven by governance compliance.
