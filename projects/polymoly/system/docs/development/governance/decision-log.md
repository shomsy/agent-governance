---
scope: system/docs/development/governance/**
contract_ref: v1
status: stable
---

# Decision Log — PolyMoly

Status: Living document  
Scope: product and architecture decisions that resolve contradictions and lock behavior.

---

## DEC-2026-03-05-01

Date: 2026-03-05  
Topic: Sidecar intent location  
Decision: Sidecar-first intent (Model A). `.polymoly/` is the committed source of truth except local-only folders (`state/`, `cache/`, optional `bin/`).  
Alternatives considered:
- Model B: root intent only (rejected due to weaker separation and repository pollution).  
Rationale: reduces root-folder pollution and enables dependency-style behavior.  
Impact:
- docs and code must converge on a single model,
- generated output stays separated and treated as artifact.  
Status: ACCEPTED

---

## DEC-2026-03-05-02

Date: 2026-03-05  
Topic: Execution sequencing for v2 productization  
Decision: Sequential triage. Trust-core and correctness hardening first, differentiators later as opt-in.  
Alternatives considered:
- ship many 12/10 features immediately (rejected).  
Rationale: Ghost/Chaos features should not advance on top of inconsistent mutation safety.  
Impact:
- Stage 1 correctness findings are merge-blocking for product trust,
- differentiators remain experimental until core invariants are covered by tests.  
Status: ACCEPTED

---

## DEC-2026-03-05-03

Date: 2026-03-05  
Topic: CLI distribution and version drift  
Decision: Local per-project binary reliance is mandatory as a supported path.  
Alternatives considered:
- global-only install (rejected due to version drift across machines).  
Rationale: essential for sail-grade UX and for removing CLI version drift across machines.  
Impact:
- `poly install` and `.polymoly/bin/poly` path becomes part of adoption strategy,
- lock must carry checksum and version constraints.  
Status: ACCEPTED

---

## DEC-2026-03-05-04

Date: 2026-03-05  
Topic: CLI surface baseline for developer onboarding  
Decision: Adopt a clean surface with grouped command intents:
- create: `poly new`,
- runtime: `poly up/down/status/logs`,
- config: `poly set`, `poly set profile=<profile_name>`,
- tools: `poly doctor/configure/wizard/open`.  
Alternatives considered:
- broad mixed command surface without explicit grouping (rejected).  
Rationale: improves memorability and first-run discoverability.  
Impact:
- help/docs must mirror grouped surface,
- command contracts should remain stable through v2 productization.  
Status: ACCEPTED

---

## DEC-2026-03-05-05

Date: 2026-03-05  
Topic: Golden path onboarding sequence  
Decision: First-run golden path includes `poly up` and `poly open` after project creation.  
Alternatives considered:
- stop onboarding at project creation only (rejected).  
Rationale: users trust the tool when they see the app running quickly.  
Impact:
- onboarding docs and examples must include runtime bring-up and open step,
- runtime summary output becomes part of product experience.  
Status: ACCEPTED

---

## DEC-2026-03-05-06

Date: 2026-03-05  
Topic: Configuration mutation UX (`poly set`)  
Decision: `poly set` must show change preview before apply and require confirmation by default.  
Alternatives considered:
- silent set mutation (rejected).  
Rationale: explicit preview prevents accidental drift and increases operator trust.  
Impact:
- mutation flow needs diff rendering and confirmation gate,
- non-interactive path must be explicit for automation use cases.  
Status: ACCEPTED

---

## DEC-2026-03-05-07

Date: 2026-03-05  
Topic: `wizard` and `configure` command boundary  
Decision:
- `poly wizard` is onboarding-guided setup,
- `poly configure` is infrastructure configuration for an existing project.  
Alternatives considered:
- one merged command for both onboarding and reconfiguration (rejected).  
Rationale: reduces cognitive load and preserves clear command intent.  
Impact:
- system/docs/help must clearly separate onboarding vs configuration behavior,
- command tests should enforce boundary semantics.  
Status: ACCEPTED

---

## DEC-2026-03-05-08

Date: 2026-03-05  
Topic: Smart framework inference  
Decision: framework hints may infer runtime (`Laravel -> PHP`, `Nest -> Node`), while explicit runtime always wins.  
Alternatives considered:
- strict explicit runtime only (rejected for beginner UX).  
Rationale: smart inference reduces friction while preserving deterministic overrides.  
Impact:
- parser/CLI inference table must be versioned and test-covered,
- CLI output should disclose inferred runtime decision.  
Status: ACCEPTED

---

## DEC-2026-03-06-01

Date: 2026-03-06  
Topic: `poly replace` safety model  
Decision: scaffold replacement must use guarded destructive flow with preview and confirmation; `.polymoly` must never be deleted by replace operations.  
Alternatives considered:
- direct overwrite without preview (rejected).  
Rationale: safe replacement ergonomics requires explicit deletion awareness and identity preservation.  
Impact:
- replace flow must print removal list and language/framework transition,
- backup path support should be available under `.polymoly/backups/<timestamp>`.  
Status: ACCEPTED

---

## DEC-2026-03-06-02

Date: 2026-03-06  
Topic: Replace command context resolution  
Decision: `poly replace` defaults to current project context (`cd <project> && poly replace --lang ...`), while explicit app name remains optional.  
Alternatives considered:
- always require project name argument (rejected for everyday DX friction).  
Rationale: current-directory context is consistent with established CLI ergonomics in developer tooling.  
Impact:
- context detection rules must be deterministic,
- safety checks must prevent accidental cross-project replacement.  
Status: ACCEPTED

---

## DEC-2026-03-06-03

Date: 2026-03-06  
Topic: Config mutation UX surface (`set` vs `add`)  
Decision: keep `poly set` as canonical mutation surface; evaluate `poly add` as user-facing shorthand mapped to canonical set semantics.  
Alternatives considered:
- only `poly set`,
- only `poly add`.  
Rationale: developers often think in service additions, but canonical mutation law should stay singular.  
Impact:
- if `poly add` is implemented, parity and traceability with `poly set` are required,
- system/docs/help must explain relation clearly.  
Status: ACCEPTED

---

## DEC-2026-03-06-04

Date: 2026-03-06  
Topic: Canonical language flag for project creation  
Decision: prefer `--lang` for UX-facing project creation examples; keep explicit compatibility policy for `--runtime` naming.  
Alternatives considered:
- keep only `--runtime`,
- keep both as equal permanent aliases.  
Rationale: language-focused wording is clearer for scaffold creation use cases.  
Impact:
- help and examples should prioritize `--lang`,
- compatibility behavior must be tested and documented.  
Status: ACCEPTED

---

## DEC-2026-03-06-06

Date: 2026-03-06  
Topic: Mutation safety execution model (`intent -> plan -> apply`)  
Decision: For everyday mutation commands (`poly set`, `poly replace`, `poly set profile`), plan and apply phases run internally, while CLI must show preview, confirmation, and execution report.  
Alternatives considered:
- direct apply without preview (rejected),
- forcing users to manually run separate plan/apply commands for standard flows (rejected for UX).  
Rationale: keep developer UX simple while preserving enterprise-grade mutation safety and auditability.  
Impact:
- no silent mutations on config/runtime surfaces,
- internal plan artifact and execution report should be available for debugging,
- standard users are not required to learn additional command phases.  
Status: ACCEPTED

---

## DEC-2026-03-06-05

Date: 2026-03-06  
Topic: Canonical project state file contract (`config.yaml` vs `project.yaml` vs split model)  
Decision: `.polymoly/config.yaml` is canonical for v2.  
Alternatives considered:
- `.polymoly/project.yaml` canonical (rejected for avoidable migration churn in active v2),
- split canonical files (rejected for v2 because it increases parser and review complexity too early).  
Rationale: locks one deterministic source now, removes docs drift, and keeps migration path open when split-model is truly needed.  
Impact:
- loader and docs must reference `.polymoly/config.yaml` as source of truth,
- root `polymoly.yaml` language is legacy/migration-only and must be labeled as non-canonical.  
Status: ACCEPTED

---

## DEC-2026-03-06-07

Date: 2026-03-06  
Topic: Execution history contract (`poly history`)  
Decision: Introduce structured execution history for mutating commands, stored under `.polymoly/history/` with command, timestamp, plan diff, and result metadata.  
Alternatives considered:
- no history support (rejected),
- plain unstructured logs only (rejected for weak auditability).  
Rationale: debugging and trust require timeline-level auditability, not only runtime logs.  
Impact:
- mutating flows must emit history records,
- history schema/versioning and rotation policy must be defined.  
Status: ACCEPTED

---

## DEC-2026-03-06-08

Date: 2026-03-06  
Topic: Explainability command (`poly explain <target>`)  
Decision: Add reasoning output that states why a component/service exists and which source introduced it (profile, explicit set, recipe, discovery).  
Alternatives considered:
- no explainability surface (rejected),
- explanation without source attribution (rejected).  
Rationale: explainability is required to avoid black-box infrastructure behavior.  
Impact:
- explain output must include traceable reason source,
- inferred reasons should carry confidence labeling when applicable.  
Status: ACCEPTED

---

## DEC-2026-03-06-09

Date: 2026-03-06  
Topic: Automatic service discovery model  
Decision: Enable automatic service discovery (`poly services`) using runtime markers, with explicit sidecar declarations taking precedence on conflicts.  
Alternatives considered:
- manual declaration only (rejected for friction),
- discovery-only without overrides (rejected for low determinism).  
Rationale: developer-first UX needs low-friction discovery, but contracts must stay deterministic.  
Impact:
- discovery results must be inspectable,
- precedence rules must be consistent across `up/services/graph`.  
Status: ACCEPTED

---

## DEC-2026-03-06-10

Date: 2026-03-06  
Topic: Service graph and impact analysis surfaces  
Decision: Add advisory graph commands (`poly graph`, `poly impact <service>`) backed by sidecar metadata.  
Alternatives considered:
- no graph support (rejected),
- blocking startup on graph generation (rejected).  
Rationale: dependency visibility significantly improves debugging and safe refactoring.  
Impact:
- graph generation must be non-blocking for standard startup,
- unresolved dependencies must be shown as warnings.  
Status: ACCEPTED

---

## DEC-2026-03-06-11

Date: 2026-03-06  
Topic: Live feedback mutation policy (`poly watch`)  
Decision: Live feedback is suggestion-first; no destructive mutations are allowed without explicit user command.  
Alternatives considered:
- automatic self-healing apply by default (rejected),
- no watch mode (rejected).  
Rationale: preserve trust and operator control while still providing real-time guidance.  
Impact:
- watch output must distinguish advisory events from explicit apply actions,
- experimental auto-apply requires explicit unsafe opt-in.  
Status: ACCEPTED

---

## DEC-2026-03-06-12

Date: 2026-03-06  
Topic: Command discoverability contract  
Decision: CLI must provide contextual next-step hints, typo correction hints, and ambiguity guidance for common flows.  
Alternatives considered:
- static help-only discoverability (rejected).  
Rationale: learnability improves adoption and reduces documentation dependency.  
Impact:
- command handlers need consistent hint hooks,
- hints must be concise and suppressible to avoid noise.  
Status: ACCEPTED

---

## DEC-2026-03-06-13

Date: 2026-03-06  
Topic: V3 plugin extensibility and executable bridge  
Decision: accept plugin lifecycle command surface (`poly plugin search/install/list/update/remove`) and deterministic executable bridge precedence (`core -> managed lock plugin -> PATH fallback poly-<cmd>`).  
Alternatives considered:
- no executable fallback (rejected for weak extensibility ergonomics),
- PATH fallback before managed lock plugins (rejected due to trust ambiguity).  
Rationale: provides extensibility while preserving deterministic core behavior and explicit precedence.  
Impact:
- `.polymoly/plugins.lock.yaml` becomes plugin state source for managed plugins,
- command namespace collision with core commands is forbidden.  
Status: ACCEPTED

---

## DEC-2026-03-06-14

Date: 2026-03-06  
Topic: V3 plugin trust enforcement  
Decision: plugin trust policy is dual-gated for unsafe mode (`--allow-unsigned` + `POLY_ALLOW_UNSAFE_PLUGIN=1`) with digest verification when executable exists locally.  
Alternatives considered:
- flag-only unsafe override (rejected),
- env-only unsafe override (rejected).  
Rationale: unsafe mode must be deliberate and auditable.  
Impact:
- unsigned or non-trusted source plugins are blocked by default,
- lifecycle events are recorded in `.polymoly/history/plugins-history.jsonl`.  
Status: ACCEPTED

---

## DEC-2026-03-06-15

Date: 2026-03-06  
Topic: V3 golden-path acceleration command  
Decision: `poly demo` is accepted as one-command first-success accelerator, paired with benchmark contract in `v3-golden-path-60s-contract.md`.  
Alternatives considered:
- no demo command (rejected for weaker first-contact UX).  
Rationale: one-command onboarding increases adoption and validates runtime flow quickly.  
Impact:
- golden-path output contract includes readiness and next-step hints,
- benchmark harness is documented for <=60s target tracking.  
Status: ACCEPTED

---

## DEC-2026-03-06-16

Date: 2026-03-06  
Topic: V3 runtime observability surface  
Decision: accept `poly health` and `poly diff --runtime` as deterministic runtime inspection surfaces, aligned with intent-plan-apply model.  
Alternatives considered:
- status/logs only (rejected for weak runtime contract visibility).  
Rationale: explicit runtime health and delta visibility reduce debugging time and drift ambiguity.  
Impact:
- runtime probe contract uses compose status as source of truth,
- output must remain human-readable with remediation hints.  
Status: ACCEPTED

---

## DEC-2026-03-06-17

Date: 2026-03-06  
Topic: `poly new` onboarding default (`wizard` default vs interactive fallback trigger)  
Decision: `poly new <name>` uses interactive fallback when required inputs are missing; `poly wizard` remains explicit onboarding for current-directory bootstrap.  
Alternatives considered:
- always launch full wizard from `poly new <name>`,
- launch wizard only when required inputs are missing and use interactive fallback,
- keep `poly wizard` explicit-only onboarding.  
Rationale: preserves fast-path creation for experienced users while still giving beginners guided input without overloading the default command.  
Impact:
- help and quickstart must show `poly new` as the first path,
- `poly wizard` stays reserved for onboarding an existing directory without sidecar state.  
Status: ACCEPTED

---

## DEC-2026-03-06-18

Date: 2026-03-06  
Topic: `poly up` default path vs advanced `plan/diff/apply` UX formulation  
Decision: `poly up` is the default runtime path; `plan/diff/apply` remain advanced explicit mutation surfaces for intent changes.  
Alternatives considered:
- keep `poly up` as default and position `plan/diff/apply` as advanced explicit surfaces,
- require explicit `plan/apply` in more everyday flows,
- hide advanced surfaces from default help but keep command availability.  
Rationale: developers need one obvious runtime command, while advanced intent mutation remains available without polluting the thin-core surface.  
Impact:
- default help must keep `poly up` in common commands,
- advanced help and docs must explain `plan/diff/apply` as explicit mutation tooling.  
Status: ACCEPTED

---

## DEC-2026-03-06-19

Date: 2026-03-06  
Topic: Canonical product identity sentence  
Decision: Use the sentence `PolyMoly gives developers production-grade infrastructure without becoming DevOps experts.` as the canonical product thesis.  
Alternatives considered:
- `PolyMoly turns infrastructure into a developer runtime.`
- broader multi-definition language (`platform`, `DSL`, `composition engine`) in top-level product copy.  
Rationale: the chosen sentence is the clearest problem/solution statement for first-contact adoption.  
Impact:
- README, WHY, and product-facing docs should center this sentence or a direct short-form derivative,
- CLI copy must stay aligned with developer-first positioning.  
Status: ACCEPTED

---

## DEC-2026-03-06-20

Date: 2026-03-06  
Topic: Thin-core CLI help tree  
Decision: Keep default help limited to onboarding, runtime, mutation, diagnostics, and open-command surfaces; push graph/history/plugin/gate surfaces into advanced help sections.  
Alternatives considered:
- expose the entire command catalog by default,
- hide advanced commands completely.  
Rationale: default help must be discoverable without creating kubectl-style overload.  
Impact:
- `poly help` remains thin-core,
- `poly help --all` remains the canonical full catalog.  
Status: ACCEPTED

---

## DEC-2026-03-06-21

Date: 2026-03-06  
Topic: Sidecar schema freeze and migration posture  
Decision: Freeze v2 on `.polymoly/config.yaml`; any future split-model (`project.yaml`, `services/`, `policies/`) remains roadmap-only until a versioned migration contract is approved.  
Alternatives considered:
- immediate split-model migration,
- continued ambiguity between `config.yaml` and `project.yaml`.  
Rationale: schema churn now would add parser and review debt without increasing near-term product clarity.  
Impact:
- loaders must fail incompatible legacy layouts with migration guidance,
- split-model exploration remains future-plan material, not active execution law.  
Status: ACCEPTED

---

## DEC-2026-03-06-22

Date: 2026-03-06  
Topic: README first-contact contract  
Decision: Keep a 10-second demo, first-60-seconds section, mental model, and `is / is not` boundary in the root README as the canonical first-contact surface.  
Alternatives considered:
- longer concept-first README,
- README as documentation dump instead of pitch.  
Rationale: OSS adoption is decided in seconds, not after deep documentation reading.  
Impact:
- README top section must stay concise and copy/paste runnable,
- deeper details move to Quickstart, Why, and Architecture docs.  
Status: ACCEPTED

---

## DEC-2026-03-06-23

Date: 2026-03-06  
Topic: Mandatory adoption example set  
Decision: Keep `product/examples/php-api`, `product/examples/node-api`, and `product/examples/go-service` as the minimum supported adoption set.  
Alternatives considered:
- fewer examples,
- tutorial placeholder names without runnable sidecar state.  
Rationale: examples should represent real usage lanes and stay runnable with minimal source + sidecar config.  
Impact:
- examples remain part of the onboarding contract,
- future examples are additive, not replacements for the minimum set.  
Status: ACCEPTED

---

## DEC-2026-03-06-24

Date: 2026-03-06  
Topic: `poly doctor` coverage and remediation style  
Decision: `poly doctor` must cover environment, sidecar config/lock, Docker/runtime readiness, and registry/auth distribution checks, with deterministic remediation messaging for failing probes.  
Alternatives considered:
- toolchain-only doctor,
- verbose raw command errors without guidance.  
Rationale: supportability depends on one command that narrows failure class quickly.  
Impact:
- report output stays terse and categorized,
- failing checks should continue to prefer `Fix:` or direct remediation hints where actionable.  
Status: ACCEPTED

---

## DEC-2026-03-06-25

Date: 2026-03-06  
Topic: Engineering polish and visionary feature backlog posture  
Decision: CI setup extraction, caching polish, release workflow split, Active Nudges, local dashboard, and other visionary differentiators remain tracked in future-plan / idea-pool docs and are not kept as active execution TODO once their scope is documented.  
Alternatives considered:
- keep every speculative item in active TODO,
- implement differentiators before trust-core/product-contract closure.  
Rationale: active backlog should contain only current executable work, while speculative expansion stays visible without creating noise.  
Impact:
- `TODO.md` can return to zero without losing future direction,
- future-plan docs become the parking lot for non-active expansion tracks.  
Status: ACCEPTED

---

## DEC-2026-03-12-01

Date: 2026-03-12
Topic: Flow-first naming law
Decision: Adopt `folder says the flow, file says the responsibility, function says the exact action` as the canonical naming law for first-party code and flow docs.
Alternatives considered:
- keep naming as a loose style preference only,
- rely on package context and prose to explain ambiguous ownership,
- tolerate generic wrapper and bucket names without explicit compatibility labeling.
Rationale: the fastest way to make PolyMoly feel absurdly simple without losing enterprise-grade safety is to make navigation deterministic from names alone. Operators should not need tribal knowledge or doc archaeology to guess where behavior lives.
Impact:
- governance and code-quality docs must treat naming as an operability rule, not decoration,
- new or renamed folders/files/functions should optimize for first-glance ownership clarity,
- compatibility wrappers should be named explicitly as compatibility surfaces instead of pretending to own primary behavior,
- future refactors may split overloaded files whose names no longer describe their full responsibility.
Status: ACCEPTED

Offload note: No offload recommended for this step.
