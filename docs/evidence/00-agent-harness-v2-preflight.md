# Agent Harness V2 — Preflight Analysis

Date: 2026-05-16
Status: Complete
Scope: Full project audit before V2 evolution

## 1. Current Architecture

```
agent-harness/
├── AGENTS.md                    # Local repo contract (v1.13.0)
├── README.md                    # Adoption docs
├── MCP-STACK.md                 # MCP integration docs
├── install-os.sh                # OS installer script
├── merge-files.sh               # Merged snapshot generator
├── .agents/
│   ├── AGENTS.md                # Global master contract (v2.4.0)
│   ├── README.md                # .agents domain index
│   ├── governance/              # 12 subdomain folders
│   │   ├── core/                # quality-gates, resolution, flags
│   │   ├── execution/           # policy, routing, hooks, approvals, sandbox
│   │   ├── standards/           # review, coding, documentation, governance
│   │   ├── architecture/        # universal standard + profiles
│   │   ├── security/            # OWASP, auth, secrets, SDL, CI/CD, etc.
│   │   ├── delivery/            # release, workflows, operations
│   │   ├── intelligence/        # memory, context, learning
│   │   ├── profiles/            # languages, frameworks, repo-kinds, roles
│   │   ├── agents/              # roles, orchestration
│   │   ├── integrations/        # platforms, MCP
│   │   ├── skills/              # skill contract
│   │   └── product/             # product management standard
│   ├── management/              # ACTIVE, TODO, BUGS, DECISIONS, evidence/
│   ├── templates/               # review, plan, ADR, task, etc.
│   ├── hooks/                   # runtime hooks
│   ├── skills/                  # reusable skills
│   ├── business-logic/          # placeholder for child repos
│   ├── language-specific/       # placeholder for child repos
│   ├── glossary/                # shared vocabulary
│   ├── onboarding/              # contributor flows
│   ├── review/                  # review archive
│   └── mcp/                     # MCP configuration
├── scaffolds/                   # AGENTS.md scaffold, agent-skeleton
├── tests/                       # smoke-routing-hooks.sh, smoke-subagent-delegation.sh
└── projects/                    # raw material from real projects (legacy reference)
```

## 2. Current Strengths

1. **Generic core governance**: `.agents/AGENTS.md` and core governance docs are
   already language-agnostic and project-agnostic
2. **Profile system exists**: `profiles/languages/`, `profiles/frameworks/`,
   `profiles/repository-kinds/` — PHP, JS, TS, CSS, Node.js, Laravel, Express,
   React, Next.js, Web Components all present
3. **Architecture profiles exist**: separate language and framework arch overlays
4. **Profile resolution algorithm**: deterministic, well-documented 10-step
   resolver in `core/resolution/profile-resolution-algorithm.md`
5. **Quality gates**: universal 13-question quality filter with production
   amplifiers — no language bias
6. **Installer works**: `install-os.sh` handles language/framework/platform
   selection, scaffold templating, and adapter generation
7. **Scaffold system works**: `scaffolds/AGENTS.md` provides a clean child-repo
   template with placeholder substitution
8. **Security governance**: comprehensive OWASP-aligned security baseline
9. **Review standard**: architecture-first self-healing review loop
10. **Governance authoring and evolution**: explicit standards for writing and
    changing governance without duplication or drift
11. **No AvaX leakage in core**: core governance, resolution, and execution
    policies contain zero PHP-only or AvaX-specific assumptions

## 3. Current Weaknesses

1. **No root EVIDENCE/ dashboard**: evidence is buried in
   `.agents/management/evidence/` — no human-readable dashboard at root
2. **Evidence model is flat**: `CHANGELOG.md`, `TEST_REPORTS.md`,
   `TRACE_REPORTS.md`, `RISK_REGISTER.md` all in one folder with no
   phase/review/validation separation
3. **Management model is minimal**: `ACTIVE.md`, `TODO.md`, `BUGS.md`,
   `DECISIONS.md` exist but no `CURRENT.md`, `RISKS.md`, or `STATUS.md`
4. **No machine-readable project config**: profile selection is human-only via
   `AGENTS.md` text or CLI flags — no `.agents/config/project.json`
5. **No project-type profiles**: only repository-kind profiles exist
   (`governance-source`) — no `web-app`, `library`, `cli`, `monorepo` profiles
6. **No recursive governance review contract**: review standards exist but no
   explicit "implement → validate → review → fix → revalidate → only then
   commit" loop is documented as a normative policy
7. **No AGENTS bootstrap contract**: agents are told to follow precedence order
   but there's no explicit step-by-step bootstrap + evidence lifecycle contract
8. **EVIDENCE/ vs .agents/management/evidence/ separation not defined**: the
   concept of human dashboard vs machine evidence doesn't exist yet
9. **Scaffolds missing**: no evidence dashboard scaffold, no management scaffold,
   no project config scaffold, no recursive review template
10. **README is good but needs V2 model updates**: missing evidence model,
    management model, recursive review, and project config documentation

## 4. What Should Remain Generic

- Quality gates
- Profile resolution algorithm
- Execution policy (explore/execute modes)
- Architecture standard (with language exception sections)
- Security governance
- Review standards
- Release and rollback policy
- Governance authoring and evolution standards
- All core, execution, standards, delivery, intelligence, and integration docs
- Installer and scaffold mechanism

## 5. What Should Become Optional Profiles

Already profiles (keep as-is):
- `profiles/languages/php.md`, `javascript.md`, `typescript.md`, `css.md`, `nodejs.md`
- `profiles/frameworks/laravel.md`, `express.md`, `react.md`, `nextjs.md`, `v-web-components.md`
- `profiles/repository-kinds/governance-source.md`
- `architecture/profiles/languages/php.md`, `javascript.md`, `typescript.md`
- `architecture/profiles/frameworks/laravel.md`, `express.md`, `react.md`, `nextjs.md`, `v-web-components.md`

New profiles needed:
- `profiles/project-types/web-app.md`
- `profiles/project-types/library.md`
- `profiles/project-types/cli.md`
- `profiles/project-types/api-service.md`
- `profiles/project-types/monorepo.md`
- `profiles/languages/go.md` (stub)

## 6. Proposed Target Structure

```
agent-harness/
├── AGENTS.md                         # Local repo contract (v2.0.0)
├── README.md                         # Updated adoption docs
├── install-os.sh                     # Updated installer
├── merge-files.sh                    # Unchanged
├── docs/
│   └── evidence/                     # Preflight and validation evidence
├── EVIDENCE/                         # Human-readable dashboard (NEW)
│   ├── README.md
│   ├── CURRENT.md
│   ├── ACTIVE_PLAN.md
│   ├── FLOW.md
│   ├── CHANGELOG.md
│   ├── DONE.md
│   └── LINKS.md
├── .agents/
│   ├── AGENTS.md                     # Global contract (v3.0.0)
│   ├── config/                       # Machine-readable config (NEW)
│   │   └── project.schema.json
│   ├── governance/
│   │   ├── core/
│   │   │   ├── quality/
│   │   │   ├── resolution/
│   │   │   ├── flags/
│   │   │   └── bootstrap/            # NEW: agent bootstrap contract
│   │   ├── profiles/
│   │   │   ├── languages/
│   │   │   ├── frameworks/
│   │   │   ├── project-types/        # NEW
│   │   │   ├── repository-kinds/
│   │   │   └── roles/
│   │   ├── standards/
│   │   │   └── review/
│   │   │       └── recursive-review-contract.md  # NEW
│   │   └── [other domains unchanged]
│   ├── management/
│   │   ├── CURRENT.md                # NEW: operational truth now
│   │   ├── ACTIVE.md
│   │   ├── TODO.md
│   │   ├── BUGS.md
│   │   ├── DECISIONS.md
│   │   ├── RISKS.md                  # NEW: accepted debt/risk
│   │   ├── STATUS.md                 # NEW: GREEN/YELLOW/RED snapshot
│   │   └── evidence/
│   │       ├── phases/               # NEW: phase evidence
│   │       ├── reviews/              # NEW: review evidence
│   │       ├── raw/                  # NEW: raw machine outputs
│   │       ├── validation/           # NEW: validation logs
│   │       ├── security/             # NEW: security evidence
│   │       ├── performance/          # NEW: performance evidence
│   │       ├── releases/             # NEW: release evidence
│   │       └── truth/                # NEW: truth reconciliation
│   └── [other domains unchanged]
├── scaffolds/
│   ├── AGENTS.md                     # Updated scaffold
│   ├── agents-skeleton/              # Updated skeleton
│   └── evidence-dashboard/           # NEW: EVIDENCE/ scaffold
└── tests/
```

## 7. Migration Safety Concerns

1. **Backward compatibility**: existing child repos using the current installer
   and scaffold must not break — the new evidence and management structure
   should be additive, not destructive
2. **Installer update**: `install-os.sh` must create the new directory structure
   when installing into child repos
3. **Precedence chain**: adding new docs (bootstrap, recursive review) to the
   precedence list must be reflected in all three `AGENTS.md` files (root,
   `.agents/`, scaffold)
4. **Profile path stability**: new `project-types/` folder must be wired into
   the profile resolution algorithm
5. **Scaffold coherence**: all scaffolds must reflect the V2 model

## 8. Validation Strategy

1. Verify no AvaX leakage in any core or parent-level governance doc
2. Verify all three `AGENTS.md` files have consistent precedence chains
3. Verify installer creates the V2 directory structure correctly
4. Verify scaffolds match the documented model
5. Verify all links in docs resolve to real files
6. Verify profiles remain optional — parent works without them
7. Run existing smoke tests to verify no regression
8. Verify human dashboard files link to machine evidence
9. Verify no evidence duplication between EVIDENCE/ and .agents/management/evidence/
