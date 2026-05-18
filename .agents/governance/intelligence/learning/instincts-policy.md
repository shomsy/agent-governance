# Instincts Policy — Atomic Behavioral Patterns

Version: 1.0.0
Status: Normative
Scope: `.agents/management/learning/instincts/**`

This document defines the instinct system — a lightweight alternative to
formal skills and governance rules. Instincts are atomic behavioral nudges
that accumulate confidence through repeated observation, bridging the gap
between raw session observations and formalized governance.

Instincts are the core data structure of the Continuous Learning system
defined in `continuous-learning.md`. This document specifies their format,
lifecycle, and management rules in detail.

Inspired by ECC's Instinct Structure with YAML-frontmatter markdown, domain
taxonomies, and confidence-based promotion to formal artifacts.

---

## 1) What Is an Instinct?

An instinct is a **single atomic behavioral pattern** observed during agent
sessions. It represents a preference, habit, or best practice that the agent
or user consistently follows.

Examples:

- "Always use `const` over `let` in TypeScript" (language-specific observation)
- "Run the test suite after every file change" (ecosystem-neutral instinct)
- "Commit messages follow Conventional Commits format"
- "Use early returns instead of nested if/else"

Instincts are **not** rules — they are observations that may become rules.

---

## 2) Instinct File Format

Each instinct is stored as a YAML-frontmatter markdown file in
`.agents/management/learning/instincts/`:

```markdown
---
id: prefer-const-over-let
trigger: "When declaring variables in TypeScript"
action: "Use const unless reassignment is explicitly needed"
confidence: 0.7
domain: code-style
scope: project
occurrences: 8
first_seen: 2026-04-01T10:00:00+02:00
last_seen: 2026-04-02T19:30:00+02:00
promoted: false
contradicts: []
---

## Evidence

Observed in 8 sessions:
- sess-001 (2026-04-01): Used const in 12/14 declarations
- sess-003 (2026-04-01): Refactored 3 let→const during review
- sess-007 (2026-04-02): User explicitly requested const-first style

## Rationale

const declarations prevent accidental reassignment and signal intent.
This aligns with TypeScript best practices and many ESLint configs.
```

---

## 3) Required Fields

| Field         | Type     | Description                            |
|:--------------|:---------|:---------------------------------------|
| `id`          | string   | Unique kebab-case identifier           |
| `trigger`     | string   | When this instinct applies (condition) |
| `action`      | string   | What the agent should do (behavior)    |
| `confidence`  | float    | Current confidence score (0.0–1.0)     |
| `domain`      | enum     | Category of the instinct (see §5)      |
| `scope`       | enum     | `project` or `global`                  |
| `occurrences` | integer  | Number of times observed               |
| `first_seen`  | ISO 8601 | Timestamp of first observation         |
| `last_seen`   | ISO 8601 | Timestamp of most recent observation   |
| `promoted`    | boolean  | Whether instinct has been promoted     |
| `contradicts` | string[] | IDs of contradicting instincts         |

---

## 4) Confidence Model

Confidence scores are calculated based on occurrence frequency:

| Occurrences | Confidence | Label       | Agent Behavior                         |
|:-----------:|:----------:|:------------|:---------------------------------------|
|     1–2     |    0.3     | Tentative   | Noted but not applied                  |
|     3–5     |    0.5     | Emerging    | Applied when no conflict               |
|    6–10     |    0.7     | Established | Applied by default                     |
|     11+     |    0.85    | Mature      | Always applied; eligible for promotion |

### Confidence Modifiers

| Condition                     |    Modifier    | Rationale              |
|:------------------------------|:--------------:|:-----------------------|
| User explicitly endorses      |      +0.2      | Direct validation      |
| User explicitly rejects       |  Reset to 0.0  | Invalidated            |
| Contradicting instinct exists |      −0.1      | Ambiguity              |
| No occurrence in 30 days      | −0.1 per month | Staleness decay        |
| Applied and succeeded         |     +0.05      | Positive reinforcement |
| Applied and caused error      |     −0.15      | Negative reinforcement |

### Confidence Bounds

- Minimum: 0.0 (instinct is archived/deleted)
- Maximum: 0.85 (instinct becomes promotion candidate)
- Instincts at 0.0 are moved to `.agents/management/learning/archived/`

---

## 5) Domain Taxonomy

| Domain          | Description                       | Examples                     |
|:----------------|:----------------------------------|:-----------------------------|
| `code-style`    | Formatting and naming conventions | const-first, camelCase       |
| `testing`       | Test patterns and practices       | test-first, assertion style  |
| `git`           | Version control habits            | commit format, branching     |
| `architecture`  | Code structure and design         | module patterns, DI          |
| `workflow`      | Development process               | tool sequences, review order |
| `security`      | Security-related patterns         | input validation, auth       |
| `performance`   | Performance-related patterns      | caching, lazy loading        |
| `documentation` | Documentation habits              | JSDoc, README updates        |

---

## 6) Scope Rules

### Project Scope (`scope: project`)

- Only applies to the project where it was observed
- Stored with project-scoped observations
- Does not leak to other projects

### Global Scope (`scope: global`)

- Applies across all projects
- Requires explicit human promotion from project→global
- Agent MUST NOT auto-promote to global scope

### Scope Promotion

A project-scoped instinct may be promoted to global if:

1. Same pattern observed in 3+ different projects
2. Confidence ≥ 0.7 in each project
3. Human has reviewed and approved the promotion

---

## 7) Contradiction Resolution

When two instincts contradict each other:

1. **Flag both** with `contradicts: [other-id]` field
2. **Reduce confidence** by 0.1 on both
3. **Do not apply either** until resolved
4. **Require human decision** to resolve:
    - Keep one, archive the other
    - Merge into a nuanced combined instinct
    - Scope one to a specific context

Example contradiction:

- `prefer-tabs` (confidence: 0.6) vs `prefer-spaces` (confidence: 0.7)
- Resolution: Check project's `.editorconfig` and keep the matching one

---

## 8) Instinct Lifecycle

```
                    Observe
                       │
                       ▼
                  ┌─────────┐
     Observe     │Tentative │  confidence < 0.3
     more ──────►│  (0.3)   │──────► Archive
                  └────┬────┘        (decay)
                       │ 3+ occurrences
                       ▼
                  ┌─────────┐
                  │Emerging │
                  │  (0.5)  │
                  └────┬────┘
                       │ 6+ occurrences
                       ▼
                  ┌─────────────┐
                  │Established  │
                  │   (0.7)     │
                  └──────┬──────┘
                         │ 11+ occurrences
                         ▼
                  ┌──────────────┐
                  │   Mature     │
                  │   (0.85)     │──────► Promotion Review
                  └──────────────┘        (human approves)
                                               │
                                               ▼
                                         Formal Rule/Skill
```

---

## 9) Relationship to Other Standards

| Standard                 | Relationship                                           |
|:-------------------------|:-------------------------------------------------------|
| `continuous-learning.md` | Instincts are the Phase 2 output                       |
| `skill-contract.md`      | Promoted instincts become skills                       |
| `quality-gates.md`       | Promoted instincts become quality gates                |
| `memory-lifecycle.md`    | Instincts are a form of learned memory                 |
| `feature-flags.md`       | Instinct application controlled by `instincts_enabled` |
