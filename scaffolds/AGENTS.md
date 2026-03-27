# AGENTS.md — Local Project Contract

Version: 1.0.0
Status: Normative / Local
Scope: `./**`

This file is the project-specific child contract.
The reusable base contract lives in `PARENT-AGENTS.md`.
Detailed procedures live in `docs/governance/**`.

## 0) Order Of Precedence

Agents MUST follow this order:

1. `AGENTS.md`
2. `PARENT-AGENTS.md`
3. [Insert Specialized Profiles if needed, e.g., `.agents/governance/profiles/frameworks/v-web-components.md`]
4. `docs/governance/execution-policy.md`
5. `docs/governance/how-to-code-review.md`
6. `docs/governance/how-to-coding-standards.md`
7. `docs/governance/naming-standard.md`
8. `docs/governance/how-to-document.md`
9. `docs/governance/release-and-rollback-policy.md`
10. `TODO.md`
11. `BUGS.md`
12. `README.md`
13. `docs/**`

## 1. Local Definitions

Replace this section with project-specific truth:

1. **Canonical Validation Entrypoint**: (e.g., `npm test`, `./verify.sh`)
2. **Canonical Local Development Entrypoint**: (e.g., `npm run dev`)
3. **Canonical Release or Publish Entrypoint**: (e.g., `./publish.sh`)
4. **Project-Specific Architecture Boundaries**: (e.g., `product/`, `system/`)
5. **Project-Specific Exceptions or Forbidden Shortcuts**:

Keep this file short. Long procedures belong in governance docs.

---
*No offload recommended for this step.*

