# Feature Flags — Conditional Governance Activation

Version: 1.0.0
Status: Normative
Scope: `.agents/governance/**`

This document defines feature flags that control which governance subsystems
are active. Flags enable gradual adoption — new projects can start with
minimal governance and enable subsystems as they mature.

Inspired by feature flag systems that gate runtime behavior through a
layered override model.

---

## 1) Flag Catalog

| Flag | Default | Scope | Description |
|:---|:---:|:---|:---|
| `strict_review` | ON | project | Enforce multi-pass review from `how-to-strict-review.md` |
| `memory_extraction` | ON | global | Auto-extract memories after tasks (Phase 1) |
| `memory_consolidation` | OFF | global | Auto-consolidate memory summaries (Phase 2) |
| `memory_injection` | ON | global | Inject `memory_summary.md` at session start (Phase 3) |
| `continuous_learning` | ON | project | Capture observations and allow the learning pipeline to run |
| `instincts_enabled` | ON | project | Allow instinct generation and application from learned patterns |
| `approval_required` | ON | project | Require human approval for T2+ operations |
| `auto_approval_rules` | ON | project | Use `approved-commands.rules` for prefix matching |
| `dangerous_op_detection` | ON | global | Always detect dangerous operations (§2 of approval-policy) |
| `auto_backlog_update` | ON | project | Auto-update TODO.md on task completion |
| `hooks_enabled` | ON | project | Enable lifecycle hooks from `hooks-policy.md` |
| `offload_notes` | ON | global | Include offload notes in final responses |
| `evidence_required` | ON | project | Require timestamped evidence for DoD |
| `naming_standard` | ON | project | Enforce naming rules from `naming-standard.md` |
| `profile_resolution` | ON | global | Use `profile-resolution-algorithm.md` for stack resolution |
| `security_gates` | ON | global | Enforce security gates from `security/**` |

---

## 2) Override Precedence

Flags are resolved in the following priority order (highest wins):

1. **Session-level override** — Explicit agent instruction for this session.
   _Example_: "Disable strict_review for this task."
2. **Project-level** — Set in root `AGENTS.md` project definitions.
   _Example_: `strict_review: OFF` for a prototype repo.
3. **Global** — Set in `.agents/AGENTS.md` or this file.
4. **Default** — The value in the table above.

### Override Syntax
In root `AGENTS.md`, flags are overridden under the project definitions:

```markdown
## 5) Feature Flag Overrides

| Flag | Value |
|:---|:---:|
| `strict_review` | OFF |
| `memory_consolidation` | ON |
```

---

## 3) Flag Semantics

### ON
The governance subsystem is active. All rules from the referenced document
are enforced.

### OFF
The governance subsystem is inactive. Its rules are still documented but
not enforced. The agent MAY note when it would have triggered a disabled
gate:

```
ℹ️ Note: strict_review is disabled for this project.
   Would have triggered multi-pass review for this change.
```

---

## 4) Immutable Flags

Some flags cannot be set to OFF by project-level overrides. They can only
be disabled at session-level by explicit human instruction:

| Flag | Reason |
|:---|:---|
| `dangerous_op_detection` | Core safety — never disable by default |
| `security_gates` | Core safety — never disable by default |
| `evidence_required` | Audit trail integrity |

---

## 5) Flag Dependencies

Some flags have upstream dependencies. If the upstream flag is OFF, the
downstream flag is implicitly OFF regardless of its own setting:

```
hooks_enabled ──► memory_extraction (PostTask hook fires extraction)
hooks_enabled ──► auto_backlog_update (PostTask hook fires update)
hooks_enabled ──► continuous_learning (PostToolUse hook fires observation capture)
continuous_learning ──► instincts_enabled (no learning input → no instinct generation)
memory_extraction ──► memory_consolidation (no extractions → nothing to consolidate)
memory_extraction ──► memory_injection (no extractions → nothing to inject)
approval_required ──► auto_approval_rules (no approval → rules unused)
```

---

## 6) Relationship to Other Standards

| Standard | Controlled By Flag |
|:---|:---|
| `hooks-policy.md` | `hooks_enabled` |
| `memory-lifecycle.md` | `memory_extraction`, `memory_consolidation`, `memory_injection` |
| `continuous-learning.md` | `continuous_learning`, `instincts_enabled` |
| `approval-policy.md` | `approval_required`, `auto_approval_rules`, `dangerous_op_detection` |
| `how-to-strict-review.md` | `strict_review` |
| `naming-standard.md` | `naming_standard` |
| `quality-gates.md` | `evidence_required` |
| `security/**` | `security_gates` |
| `profile-resolution-algorithm.md` | `profile_resolution` |
