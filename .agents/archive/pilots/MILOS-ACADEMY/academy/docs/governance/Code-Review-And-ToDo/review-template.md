# Enterprise-Grade System Code Review Template

Version: 1.3.0
Status: Normative / Enforced
Scope: Backend + Frontend + Web Components readiness

---

## Review Contract

This review is system-level, architecture-first, and decision-oriented.
It is not a style review or PR nitpick.

Final outcome must be exactly one:

- Keep and Improve
- Redesign
- Rewrite Candidate

---

## Mandatory Finding Format

Every finding must use this format:

### Finding: `<short title>`

- **Symptom:** what is observed
- **Root Cause:** why it exists
- **Impact:** why it matters
- **Evidence:** concrete file/class/flow pointers
- **Risk:** Low / Medium / High / Rewrite Risk

---

# PHASE 0 — Context Gate

## 0.1 System Identity

- System Type:
- Primary Consumers:
- Runtime Context:
- Lifecycle:

## 0.2 Scope and Non-Scope

- In Scope:
- Out of Scope:

## 0.3 Compatibility Contract

- Public API Stability:
- Backward Compatibility:
- Performance Budget:

---

# PHASE 1 — As-Built Reconstruction

## 1.1 Execution Flow

`Public API -> ? -> ? -> Final Effect`

- Where state is created:
- Where state is mutated:
- Where decisions are made:
- Where execution is mechanical:

## 1.2 Primary Axis

`This system is fundamentally organized around <PRIMARY_AXIS>.`

Optional:
`Secondary axis: <SECONDARY_AXIS> (justified).`

## 1.3 Responsibility Map

| Component | Orchestrates | Executes | Holds State | Notes |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

---

# PHASE 2 — Backend Architecture Review (Node/Express)

## 2.1 Boundary Checks (`api -> actions -> models -> storage`)

- API contains transport only: Yes/No
- API calls Prisma/storage directly: Yes/No
- Actions import Express: Yes/No
- Actions import Prisma: Yes/No
- Storage contains orchestration logic: Yes/No

## 2.2 Determinism and Failure-Mode Checks

- Deterministic route behavior under same inputs: Yes/No
- Validation before action execution: Yes/No
- DTO-only external output: Yes/No
- Error classes carry machine code: Yes/No
- 4xx/5xx mapping is deterministic: Yes/No

## 2.3 Security Baseline Checks

- Helmet/CORS/Rate limit policy enforced: Yes/No
- No secrets in source: Yes/No
- Parameterized queries only: Yes/No
- Correlation id propagation: Yes/No

---

# PHASE 3 — Frontend Architecture Review

## 3.1 Canonical Flow Checks

- SSR routes remain thin and deterministic: Yes/No
- App boot is localized to app assets: Yes/No
- App runtime logic localized to app engine modules: Yes/No
- Hidden cross-app DOM coupling detected: Yes/No

## 3.2 Frontend Quality Checks

- Accessibility baseline (keyboard + aria): Pass/Fail
- Runtime determinism (lesson/playground): Pass/Fail
- Naming boundaries (`l-*`,`u-*` vs app classes): Pass/Fail

---

# PHASE 4 — Web Components Readiness Assessment

## 4.1 Promotion Criteria

For each candidate component:

| Candidate | Reused >=2 pages/apps | Stable contract | Independent lifecycle | Isolated testable | Result |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  | Promote / Wait |

## 4.2 Contract Readiness

- Tag naming `academy-*` policy defined: Yes/No
- Attribute/property input contract defined: Yes/No
- `CustomEvent` output contract defined: Yes/No
- ARIA/keyboard contract defined: Yes/No
- Style scoping strategy defined (`:host`, CSS vars): Yes/No

---

# Decision Matrix

Select exactly one:

- Keep and Improve
- Redesign
- Rewrite Candidate

## Decision Justification

- Findings referenced:
- Constraints considered:
- Why this path is correct now:

## Stability Status

Select one:

- Not Stable
- Stable (Pre-Production)
- Production Ready

### Stability Evidence Checklist

- No High/Rewrite findings remain open: Yes/No
- `academy:check:contracts` pass evidence logged: Yes/No
- `academy:typecheck` pass evidence logged: Yes/No
- Tests (incl. integration where applicable) pass evidence logged: Yes/No
- Migration discipline (`prisma/migrations/**`) verified: Yes/No
- AuthN/AuthZ baseline on protected APIs verified: Yes/No
- CI required gates configured and active: Yes/No
- Branch policy (`feature/* -> development -> main`) evidence logged: Yes/No
- CI run URL(s) for branch tip recorded: Yes/No
- `academy:quality` evidence logged: Yes/No
- `academy:smoke:runtime` evidence logged (`/api/health`, `/api/ready`, auth/tenant checks): Yes/No

---

# Next Steps (Action-Oriented)

## Constraints

- API stability:
- Security boundaries:
- Performance budget:
- Migration expectations:

## First 3 Actions

1.
2.
3.

## Kill Criteria

- Signal 1:
- Signal 2:
- Signal 3:

---

# Decisions Log Entry

- **Date:**
- **Context:**
- **Decision:**
- **Alternatives Rejected:**
- **Consequences/Risks:**
- **Evidence:**
