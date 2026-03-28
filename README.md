# Agent Governance & OS Hub

> [!IMPORTANT]
> This repository is a **Portable Agent Operating System**. The core "brain" lives entirely inside the [`.agents/`](.agents/) folder. Copying this folder into any project instantly installs the governance, standards, and AI-alignment rules required for high-performance collaboration.

## Vision: The Portable Brain

Instead of managing floating markdown files, this project centralizes the entire governance system into a single, structured directory.

1.  **Shared Master Contract**: [`.agents/AGENTS.md`](.agents/AGENTS.md) is the global source of truth in this source repo.
2.  **Specialized Profiles**: Modular governance grouped by **Language**, **Framework**, and **Architecture**.
3.  **Process Policies**: Shared standards for review, strict-review, execution, release, and documentation.
4.  **Resolution Algorithm**: A deterministic stack and SDLC resolver that maps root `AGENTS.md` + repo signals into the exact rule pack.
5.  **Operations Contracts**: Reusable observability, smoke, security, recovery, and handoff rules.
6.  **Flow-Doc Law**: Reusable trigger-to-result documentation contract for `how-this-works` style docs.
7.  **Child Layout**: In adopting projects, the reusable `.agents` project is mounted into hidden `.agents/.rules/`, and the project workspace skeleton lives in visible `.agents/`.

---

## 🏗️ OS Architecture

- **`/.agents/AGENTS.md`**: The Master Contract. Defines the Order of Precedence and non-negotiable rules.
- **`/.agents/.rules/`**: Hidden mounted copy of the reusable `.agents` project in adopting repos. The installer places the full rules tree here.
- **`/.agents/`**: Visible project workspace skeleton in adopting repos. This is where `business-logic/`, `language-specific/`, `management/`, and `review/` live.
- **`/.agents/governance/profile-resolution-algorithm.md`**: Resolves the active SDLC lane plus the correct language, framework, architecture, security, and operations overlays.
- **`/.agents/governance/profiles/`**: Tech-specific rules (PHP, JavaScript, TypeScript, Node.js, CSS, React, Laravel, etc.) that can be plugged into the project.
- **`/.agents/governance/app-architecture/profiles/`**: Architecture overlays that translate the universal vertical-slice law into PHP, Laravel, React, Next.js, Express, and Web Components repo shapes.
- **`/.agents/governance/security/`**: Secure SDLC, OWASP-aligned web and API baseline, auth/session, secrets, supply-chain, CI/CD, and incident-response governance.
- **`/.agents/governance/execution-policy.md`**: The standard for how tasks are started, validated, and finished.
- **`/.agents/governance/how-to-strict-review.md`**: Independent first-principles review lane for high-stakes claims.
- **`/.agents/governance/how-to-document-flow.md`**: The trigger-to-result law for flow documentation.
- **`/.agents/governance/operations/`**: Runtime, release, and recovery governance for deployable systems.
- **`/.agents/governance/naming-standard.md`**: The "Flow -> Responsibility -> Action" naming law.

---

## 📂 The `projects/` Directory (Temporary Knowledge Base)

The [**`projects/`**](projects/) folder is a temporary, local repository of documentation and governance files vacuumed from real-world projects (`avax-bootcamp`, `baraba`, `polymoly`, etc.).

- **Purpose**: It serves as the raw material and inspiration for generalizing rules into the core `.agents` OS.
- **Usage**: Use it to extract patterns, architecture boundaries, and "Naming Laws" that have proven effective in specific project contexts. 
- **Destiny**: Once a rule is successfully generalized into the `.agents/` folder, the corresponding project-specific reference in this folder becomes legacy data.

---

## 🚀 How to Adopt (The "OS Installation")

To "install" this Agent OS into a project:

```bash
# Preferred: use the bootstrap script
/path/to/agent-governance/install-os.sh /path/to/your/project

# The result is:
# - .agents/.rules/ for the mounted reusable rules project
# - .agents/ for the project workspace skeleton
# - merge-files.sh at the project root, kept in sync
```

The root `AGENTS.md` in your project should be minimal, only containing:
- Path definitions (where is your source code?)
- Entrypoints (how do we run/test the code?)
- Applied governance stack (which languages, frameworks, and architecture overlays are active?)
- Any specific overrides that differ from the global OS rules.

The installer keeps `merge-files.sh` in the child repo on the latest version so
the portable merged snapshot stays consistent across projects.

Canonical backlog and evidence files already live under `.agents/management/**`.

---

## 🧪 Generalizing from Projects

We continuously "vacuum" the best rules from active projects to improve the global OS.

| Project Source | Generalized Rule | Destination in OS |
|:---|:---|:---|
| `avax-bootcamp` | Naming Laws (Flow -> Resp -> Action) | `.agents/governance/naming-standard.md` |
| `avax-bootcamp` | `state/render/actions` Pattern | `.agents/governance/app-architecture/architecture-standard.md` |
| `avax-bootcamp` | Canonical source vs generated book/output discipline | `.agents/governance/how-to-document.md` |
| `baraba` | Web Component Facades | `.agents/governance/profiles/frameworks/v-web-components.md` |
| `components` | Public facade/kernel/pipeline law translated into screaming feature-first clean architecture | `.agents/governance/app-architecture/architecture-standard.md`, `.agents/governance/app-architecture/profiles/languages/php.md`, `.agents/governance/app-architecture/profiles/frameworks/laravel.md` |
| `OWASP` anchors | Web, API, ASVS, DevSecOps, and supply-chain security baseline | `.agents/governance/security/**` |
| `polymoly` | Flow-document contract | `.agents/governance/how-to-document-flow.md` |
| `polymoly` + `hotelsync-bridgeone` | Runtime hardening and proof posture | `.agents/governance/app-architecture/runtime-hardening.md` |

---

## 📋 Completion Criteria for Changes

1.  Does the rule belong in the **Master Contract** or a **Specialized Profile**?
2.  Does it maintain the **Order of Precedence**?
3.  Is it documented in simple, direct English or Serbian?

---
*No offload recommended for this step.*
