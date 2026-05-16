# PR Title

<!--
Use clear, mechanical naming.
Examples:
feat(policy): add tenant-aware rule evaluation
fix(cms): deterministic conflict mapping for duplicate create
refactor(auth): isolate role guard logic
docs(governance): update review contract
-->

---

# PR Description

## What

<!-- Short factual description of what changed. No storytelling. -->

## Why

<!-- Why this change exists. Bug? Feature? Refactor? Governance alignment? -->

## Scope

- [ ] Backend
- [ ] Frontend
- [ ] DB / Prisma
- [ ] Governance / Docs
- [ ] CI
- [ ] Security

---

# Risk Classification

Type: feature / fix / refactor / docs  
Risk Level: low / medium / high  
Version Impact: patch / minor / major  
Merge Target: development / main

---

# Execution Metadata (Mandatory)

Review Mode: delta / full  
CI Run URL:  
Head SHA:  
Related Issue/Task:

---

# PRE-MERGE CHECKLIST

## 1) Scope Discipline

- [ ] Scope is clear and bounded
- [ ] No stealth architecture redesign
- [ ] No scope expansion beyond PR intent
- [ ] Docs-only PR has no runtime changes
- [ ] Branch discipline followed (`feature/* -> development -> main`)

---

## 2) Backend Boundary Contract (if applicable)

- [ ] API layer contains transport only
- [ ] API does not access Prisma/storage directly
- [ ] Actions do not import Express
- [ ] Storage contains no orchestration logic
- [ ] DTO-only external output (no ORM leaks)

---

## 3) Frontend Contract (if applicable)

- [ ] SSR routes remain thin and deterministic
- [ ] App boot logic localized in app asset
- [ ] No cross-app DOM coupling
- [ ] No misuse of `l-*` / `u-*` DSL for business semantics

---

## 4) Tenant & Auth Discipline (if API touched)

- [ ] tenantId propagated transport -> action -> storage
- [ ] Proper role/permission enforcement present
- [ ] No unauthenticated write endpoints
- [ ] No secrets hardcoded

---

## 5) Determinism & Error Mapping

- [ ] Validation executes before action
- [ ] 4xx/5xx mapping deterministic
- [ ] Stable error shape
- [ ] No sensitive info in logs/responses

---

## 6) CI Gate

- [ ] `academy:check:contracts` pass evidence
- [ ] `academy:typecheck` pass evidence
- [ ] `academy:test` pass evidence
- [ ] `academy:quality` pass evidence
- [ ] `academy:smoke:runtime` pass evidence
- [ ] CI workflow green

If DB schema changed:

- [ ] Migration created
- [ ] `migrate deploy` passes
- [ ] No schema drift

---

## 7) Governance Evidence

- [ ] `review.md` updated (if architecture affected)
- [ ] Version impact documented
- [ ] Changelog/ToDo updated (if required)

---

# POST-MERGE CHECKLIST (Release Merge Only)

For `development -> main`:

- [ ] CI green on main
- [ ] Health endpoint verified (`/api/health`)
- [ ] Smoke tested:
  - [ ] `/`
  - [ ] `/classroom/lesson/:id`
  - [ ] `/playground/challenge`
  - [ ] `/api/health`
- [ ] Protected endpoint tested with valid token
- [ ] Tenant isolation confirmed (if relevant)
- [ ] Merge Commit SHA recorded

Merge Commit SHA:

---

# Migration Notes (Optional)

<!-- Describe forward-only strategy or rollback plan. -->

---

# Minimal Merge Summary (For Changelog)

<!-- 3-5 bullet points max. Mechanical. No marketing tone. -->
- 
- 
- 

---

# ChatGPT Offload Note (Mandatory)

Offloaded Task:  
Recommended Model: instant / auto / thinking / extended thinking  
Reason / Risk Note:

If not used:

`ChatGPT Offload Note: No offload recommended for this step.`
