# AGENTS.md — Agent Harness Repository Contract

Version: 3.0.0
Status: Normative / Local
Scope: `./**`

This repository maintains the reusable shared **Agent Harness** base for other
projects. The canonical reusable contract lives in `.agents/AGENTS.md`.
Deep procedures live in `.agents/governance/**`.

## 0) Order Of Precedence

Agents MUST follow this order in this repository:

1. `AGENTS.md`
2. `.agents/AGENTS.md`
3. `.agents/governance/core/quality/quality-gates.md`
4. `.agents/governance/core/bootstrap/agent-bootstrap.md`
5. `.agents/governance/core/resolution/profile-resolution-algorithm.md`
6. `.agents/governance/standards/documentation/evidence-model.md`
7. `.agents/management/TODO.md` | `.agents/management/BUGS.md`
8. `.agents/skills/**` (Reusable Agent Skills)
9. `EVIDENCE/**`
10. `README.md`
11. `scaffolds/**`

**Governance directories** (loaded on demand, not by precedence order):

- `.agents/governance/profiles/**` — language, framework, project-type profiles
- `.agents/governance/architecture/**` — architecture profiles and standards
- `.agents/governance/security/**` — threat models, abuse cases, security lanes
- `.agents/governance/delivery/operations/**` — runbooks, operational procedures
- `.agents/governance/core/flags/` — feature flag definitions

The precedence chain MUST NOT reference files that do not exist on disk.

## 1) Local Rules

1. Keep `.agents/AGENTS.md` generic and reusable across unrelated projects.
2. Do not hardcode product-specific runtime paths, toolchains, or release tools
   into the global contract.
3. If an example is needed, put it in `scaffolds/**` or `README.md`, not in the
   global contract.
4. Keep this repository understandable as a portable OS source:
   - global contract in `.agents/AGENTS.md`
   - local project overrides in `AGENTS.md`
   - specialized rules in `.agents/governance/**`
5. Prefer subtraction over expansion. If a rule can move out of the global and
   still work, move it out.

## 2) Completion Criteria

A change here is complete only when:

1. `.agents/AGENTS.md` remains generic
2. the local repository contract remains short
3. README adoption instructions still match the file layout
4. scaffold files still reflect the documented precedence model

## 3) Offload Output Contract

Final user-facing responses must include one short offload note:

- either a short recommendation, or
- `No offload recommended for this step.`

## 4) Local Applied Governance Stack

This repository should dogfood its own reusable governance where that improves
the Agent Harness as a portable OS source.

- Repository Kind: `governance source`
- Applied Repository Profile:
  `.agents/governance/profiles/repository-kinds/governance-source.md`
- Primary Surfaces: `.agents/**`, `scaffolds/**`, `install-os.sh`,
  `merge-files.sh`, root documentation, and generated adapters
- Structural Change Ceremony: update precedence, indexes, installer/scaffold
  paths, validation commands, and merged snapshot together
