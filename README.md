# Agent Governance & OS Hub

> [!IMPORTANT]
> This repository is a **Portable Agent Operating System**. The core "brain" lives entirely inside the [`.agents/`](.agents/) folder. Copying this folder into any project instantly installs the governance, standards, and AI-alignment rules required for high-performance collaboration.

## Vision: The Portable Brain

Instead of managing floating markdown files, this project centralizes the entire governance system into a single, structured directory.

1.  **Shared Master Contract**: [`.agents/AGENTS.md`](.agents/AGENTS.md) is the global source of truth.
2.  **Specialized Profiles**: Modular governance grouped by **Language**, **Framework**, and **Architecture**.
3.  **Process Policies**: Shared standards for code review, execution, and documentation.

---

## 🏗️ OS Architecture

- **`/.agents/AGENTS.md`**: The Master Contract. Defines the Order of Precedence and non-negotiable rules.
- **`/.agents/governance/profiles/`**: Tech-specific rules (React, JS, Python, etc.) that can be plugged into the project.
- **`/.agents/governance/execution-policy.md`**: The standard for how tasks are started, validated, and finished.
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
# 1. Copy the portable brain
cp -r /path/to/agent-governance/.agents /path/to/your/project/

# 2. Create your project-specific AGENTS.md at the root
# Use scaffolds/AGENTS.md as a template
cp /path/to/agent-governance/scaffolds/AGENTS.md /path/to/your/project/AGENTS.md
```

The root `AGENTS.md` in your project should be minimal, only containing:
- Path definitions (where is your source code?)
- Entrypoints (how do we run/test the code?)
- Any specific overrides that differ from the global OS rules.

---

## 🧪 Generalizing from Projects

We continuously "vacuum" the best rules from active projects to improve the global OS.

| Project Source | Generalized Rule | Destination in OS |
|:---|:---|:---|
| `avax-bootcamp` | Naming Laws (Flow -> Resp -> Action) | `naming-standard.md` |
| `avax-bootcamp` | `state/render/actions` Pattern | `app-architecture/architecture-standard.md` |
| `baraba` | Web Component Facades | `profiles/frameworks/v-web-components.md` |

---

## 📋 Completion Criteria for Changes

1.  Does the rule belong in the **Master Contract** or a **Specialized Profile**?
2.  Does it maintain the **Order of Precedence**?
3.  Is it documented in simple, direct English or Serbian?

---
*No offload recommended for this step.*


