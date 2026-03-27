# Legacy vs Canonical Boundary (Academy)

Version: 1.0.0
Status: Normative / Enforced
Scope: `academy/**`

## Purpose

Eliminate dual source-of-truth risk between historical `lab/*` references and canonical `academy/src/**` architecture.

## Canonical Source of Truth

- Runtime source: `academy/src/**`
- Governance source: `academy/docs/**`
- Canonical lesson route: `/classroom/lesson/:lessonId`
- Canonical playground route: `/playground/challenge`

## Legacy Compatibility Only

- Legacy route namespace: `/lab/*`
- Legacy docs references to `lab/*` are historical compatibility markers.
- Legacy namespace must not receive new features.

## Path Mapping

- `lab/index.html` -> `/` (Campus)
- `lab/<lesson>.html` -> `/classroom/lesson/<lessonId>`
- `lab/playground.html` -> `/playground/challenge`
- `lab/playground/lesson/<lesson>` -> `/playground/lesson/<lesson>`

## Migration Plan

### Phase 1 (now)

- Mark canonical + legacy boundary in AGENTS and governance docs.
- Update roadmap docs to stop declaring `lab/*` as source of truth.
- Keep `/lab/*` redirects for backward compatibility.

### Phase 2

- Replace residual `lab/*` roadmap references with canonical routes or canonical source paths.
- Add review gate: new roadmap/ADR entries must use canonical paths only.

### Phase 3

- Remove `/lab/*` redirect layer after compatibility window closes.
- Remove all legacy route mentions from active docs.

## Enforcement

Any new feature implemented under `lab/*` is a governance violation.
