# Agent Harness

> [!IMPORTANT]
> This repository is a **Portable AI SDLC Operating System**. The core governance lives entirely inside the [`.agents/`](.agents/) folder. Copying this folder into any project instantly installs the governance, evidence model, management lifecycle, and profile system required for high-performance AI collaboration.

## What This Is

The Agent Harness is a project-agnostic, language-agnostic operating system for
AI-assisted software development. It defines universal process and governance
that any project can adopt, regardless of language, framework, or architecture.

**The parent harness defines:**

- Rule precedence and resolution
- Execution lifecycle (explore vs execute modes)
- Validation lifecycle and quality gates
- Recursive governance review
- Evidence model (human dashboard + machine evidence)
- Management model (operational truth, backlog, decisions, risks)
- Risk and debt handling
- Commit and release discipline
- Profile selection and resolution
- Bootstrap contract for AI agents

**The parent harness does NOT define:**

- Language-specific tooling (lives in optional language profiles)
- Framework-specific patterns (lives in optional framework profiles)
- Project-specific business rules (lives in local AGENTS.md overlays)
- Runtime-specific assumptions (lives in project-type profiles)

---

## Architecture

### Three Layers

```
┌─────────────────────────────────┐
│  LOCAL PROJECT LAYER            │  ← AGENTS.md + .agents/ overrides
│  Project-specific rules         │
├─────────────────────────────────┤
│  PROFILE LAYER                  │  ← Optional overlays
│  Languages · Frameworks ·      │
│  Project types · Repo kinds    │
├─────────────────────────────────┤
│  PARENT / CORE GOVERNANCE      │  ← Universal rules
│  Quality gates · Bootstrap ·   │
│  Execution · Review · Evidence │
└─────────────────────────────────┘
```

### Rule Precedence (in adopting projects)

1. Local `AGENTS.md` (project-specific overrides)
2. `.agents/.rules/AGENTS.md` (global shared rules)
3. Core governance (quality gates, bootstrap, resolution)
4. Selected profiles (languages, frameworks, project-types)
5. Architecture, security, execution, standards
6. Management state and evidence

### Key Surfaces

| Surface | Location | Purpose |
|:---|:---|:---|
| **Master Contract** | `.agents/AGENTS.md` | Universal rules |
| **Bootstrap** | `.agents/governance/core/bootstrap/` | Agent startup sequence |
| **Resolution** | `.agents/governance/core/resolution/` | Profile and stack resolution |
| **Quality Gates** | `.agents/governance/core/quality/` | Universal quality filter |
| **Profiles** | `.agents/governance/profiles/` | Language, framework, project-type overlays |
| **Architecture** | `.agents/governance/architecture/` | Universal + overlay arch rules |
| **Review** | `.agents/governance/standards/review/` | Code review + recursive review |
| **Evidence Model** | `.agents/governance/standards/documentation/evidence-model.md` | Human vs machine evidence |
| **Management Model** | `.agents/governance/delivery/operations/management-model.md` | Operational management |
| **Security** | `.agents/governance/security/` | OWASP-aligned security baseline |
| **Config** | `.agents/config/` | Machine-readable project config |

---

## Evidence Model (V2)

Evidence is split into two layers:

- **`EVIDENCE/`** — human-readable dashboard at project root. Small summaries
  that link to machine evidence.
- **`.agents/management/evidence/`** — machine evidence. Verbose, detailed,
  agent-generated data organized into `phases/`, `reviews/`, `validation/`,
  `security/`, `performance/`, `releases/`, `truth/`, and `raw/`.

Rule: the human dashboard summarizes and links. Raw data stays in machine
evidence. Duplication is forbidden.

---

## Management Model (V2)

```
.agents/management/
├── CURRENT.md     # Operational truth now
├── ACTIVE.md      # Active work board
├── TODO.md        # Planned work queue
├── BUGS.md        # Defect/regression queue
├── DECISIONS.md   # Architecture/process decisions
├── RISKS.md       # Accepted debt and risk register
├── STATUS.md      # GREEN/YELLOW/RED snapshot
└── evidence/      # Machine evidence tree
```

---

## Profile System

Profiles are **optional overlays** that add language-specific, framework-specific,
or project-type-specific rules. The parent harness works without them.

### Available Profiles

| Category | Profiles |
|:---|:---|
| **Languages** | `php`, `javascript`, `typescript`, `css`, `nodejs`, `go` |
| **Frameworks** | `laravel`, `express`, `react`, `nextjs`, `v-web-components` |
| **Project Types** | `web-app`, `library`, `cli`, `api-service`, `monorepo` |
| **Repository Kinds** | `governance-source` |

### Profile Selection

Projects declare their profiles in `AGENTS.md` under "Applied Governance Stack"
or in `.agents/config/project.json`. If neither exists, the resolution algorithm
infers profiles from repository signals (e.g., `go.mod` → Go, `package.json` → Node.js).

---

## Recursive Governance Review

Every change must pass the recursive review loop before commit:

```
implement → validate → run gates → recursive review →
fix findings → revalidate → re-review → commit
```

Passing tests alone is not commit permission. Passing static analysis alone is
not commit permission. The full loop must be clean.

---

## How to Adopt ("OS Installation")

```bash
# Install the harness into a project
/path/to/agent-harness/install-os.sh /path/to/your/project

# With language and framework profiles
/path/to/agent-harness/install-os.sh /path/to/your/project \
  --language=typescript --language=nodejs --framework=react

# With platform adapters
/path/to/agent-harness/install-os.sh /path/to/your/project --platform=opencode,cline

# The result:
# - .agents/.rules/         ← mounted reusable rules
# - .agents/                ← project workspace skeleton
# - .agents/config/         ← machine-readable project config
# - .agents/management/     ← management model with evidence tree
# - EVIDENCE/               ← human-readable dashboard
# - AGENTS.md               ← project-local contract
# - merge-files.sh          ← snapshot generator
# - Platform adapters       ← CLAUDE.md, .cursorrules, etc.
```

### After Installation

1. Edit `AGENTS.md` to declare your applied governance stack
2. Edit `.agents/config/project.json` to set language/framework/project-type
3. Fill in your canonical validation, development, and release entrypoints
4. Keep `AGENTS.md` short — long procedures belong in governance docs

---

## How to Choose Profiles

- **Language profiles**: one per language your project actively uses
- **Framework profiles**: only if the framework is genuinely in use
- **Project-type profiles**: match your project's primary delivery shape
- **Repository-kind profiles**: only for non-standard repos (governance sources, etc.)

Combine profiles freely: `typescript` + `nodejs` + `react` + `web-app` is valid.
The resolution algorithm composes all active profiles.

---

## `projects/` Directory (Legacy Reference)

The [`projects/`](projects/) folder is a temporary knowledge base of
documentation vacuumed from real-world projects. It serves as raw material for
generalizing rules into the core `.agents` OS. Once a rule is generalized, the
project-specific reference becomes legacy data.

---

## Validation

```bash
./tests/smoke-routing-hooks.sh
./tests/smoke-subagent-delegation.sh
```

---

## Completion Criteria for Changes

1. Does the rule belong in the **Master Contract** or a **Specialized Profile**?
2. Does it maintain the **Order of Precedence**?
3. Is the parent harness still generic and language-agnostic?
4. Are scaffolds consistent with the documented model?
5. Is the evidence model respected (human dashboard vs machine evidence)?

---
*No offload recommended for this step.*
