---
scope: system/docs/development/governance/**,system/docs/development/standards/**,system/docs/development/release/**
contract_ref: v1
status: stable
---

# How To Strict Review

Version: 1.0.0
Status: Normative / Enforced
Scope: `./**`

This document defines the cold independent review path.

It exists to answer one question:

- if a strong engineer saw this repository for the first time and had no loyalty
  to its current shape, would they keep it, redesign it, or start over?

Strict review is part of the development process, but it is intentionally
outside the normal `AGENTS.md` compliance lens.
`AGENTS.md`, backlog files, and repository narrative are context only.
They are not proof that the product is good.

---

## 1) Purpose

Use strict review to test reality against first principles:

- product truth over repository self-description
- cold operator experience over internal familiarity
- maintainability over sunk-cost defense
- rewrite honesty over incremental optimism

The goal is not to be fair to the repository.
The goal is to be fair to the next competent engineer who would inherit it.

---

## 2) Reviewer Posture

Strict review must be:

- cold
- impartial
- first-contact
- rewrite-capable
- evidence-first

Reviewer assumptions:

1. act as if this is the first time seeing the project
2. assume nothing is correct because the repository says it is correct
3. give no credit for governance density, naming, or ambition unless runtime,
   product surface, and maintainability justify it
4. ask what would be kept if the system were rebuilt from zero today
5. treat decorative layers, stale contracts, and placeholder-success behavior
   as defects, not style differences

Reviewer prohibitions:

- do not defer to `AGENTS.md` as proof of quality
- do not accept old intent as defense against current bad shape
- do not soften findings to preserve morale or narrative consistency
- do not confuse green local gates with product truth

---

## 3) When To Run

Strict review is required when any of these are true:

1. a `Production Ready` claim is being prepared or defended
2. a release claims major convergence or architectural closure
3. a large migration, restructuring wave, or boundary rewrite has just landed
4. the system feels internally disciplined but externally unconvincing
5. a user explicitly asks for an independent first-principles review

Strict review is recommended after any long hardening wave that closes many
internal TODO or BUG items at once.

---

## 4) Inputs And Non-Inputs

Use as primary inputs:

- shipped command paths
- install and first-run behavior
- runtime behavior
- gates and test evidence
- release and rollback behavior
- code structure and ownership seams
- active docs that claim current truth

Use as secondary inputs:

- `AGENTS.md`
- `README.md`
- `TODO.md`
- `BUGS.md`
- older evidence reports

Treat as non-inputs:

- project pride
- legacy intent
- promises not backed by a shipped path
- labels such as `enterprise-grade`, `stable`, or `production ready`

---

## 5) Strict Review Flow

Strict review should run in five passes.

### Pass 1: Cold Start And Product Truth

Check:

- install path
- first-run help and version trust
- repo independence
- mismatch between promised workflow and shipped behavior

Question:

- would a new user believe the product after the first ten minutes?

### Pass 2: Architecture And Ownership Honesty

Check:

- whether ownership boundaries match the real implementation path
- whether wrappers are real seams or decorative shells
- whether architecture claims reduce or increase cognitive load

Question:

- if rebuilt from zero, which layers would remain exactly as they are?

### Pass 3: Trust, Safety, And Fail-Closed Behavior

Check:

- secret handling
- trust downgrade paths
- placeholder-success behavior
- unsafe defaults
- policy bypasses

Question:

- where does the system silently succeed when it should stop?

### Pass 4: Release And Operator Reality

Check:

- evidence quality
- rollback clarity
- diagnostics
- machine-readable outputs
- reproducibility of release claims

Question:

- could another operator reconstruct failure and recovery without tribal memory?

### Pass 5: From-Scratch Rewrite Test

Check:

- what should be kept
- what should be collapsed
- what should be deleted
- what is too expensive to defend long-term

Question:

- if this had to be written again next week, what would not survive?

---

## 6) Output Contract

Every strict review must produce all of the following:

1. overall quality score from `0.0` to `10.0`
2. final decision:
   - `Keep and Improve`
   - `Redesign`
   - `Rewrite Candidate`
3. findings ordered by severity
4. evidence for every `high` or `critical` claim
5. from-scratch rewrite priorities
6. keep / collapse / delete recommendations
7. clear distinction between:
   - internal governance strength
   - actual product quality

Recommended output sections:

- overall assessment
- pass-by-pass findings
- quality summary by axis
- first rewrite priorities

---

## 7) Severity Standard

- `critical`: trust, safety, release, or outage-class flaw that would block
  serious adoption
- `high`: productization, correctness, or architectural honesty flaw that
  makes the system materially weaker than its narrative
- `medium`: meaningful debt or inconsistency, but not a release blocker by
  itself
- `low`: useful improvement or cleanup

Strict review must be harsher than routine code review.
If the reviewer would not willingly inherit the current shape, the report must
say so plainly.

---

## 8) Translation Into Action

Strict review itself does not execute fixes.
It produces an independent judgment record.

After the review closes:

1. actionable defects move to `BUGS.md`
2. product or platform improvement follow-ups move to `TODO.md`
3. execution work then follows the normal local delivery contract

That separation is intentional:

- strict review stays independent
- execution stays disciplined

---

## 9) Evidence And Storage

Store strict review reports under:

- `system/docs/development/evidence/findings/`

Suggested naming:

- `strict-review-<date>.md`
- `strict-review-<wave>-<date>.md`

Each report should state:

- review date
- review posture
- review scope
- whether the reviewer ignored repository self-description as ground truth

---

## 10) Process Boundary

Strict review is part of the repository process.
It is not part of `AGENTS.md` law.

That means:

- `AGENTS.md` governs how work is executed and closed
- strict review governs how the system is challenged from the outside

Both are needed.

Without execution law, the repository drifts.
Without strict review, the repository can become internally tidy but externally
self-deceived.
