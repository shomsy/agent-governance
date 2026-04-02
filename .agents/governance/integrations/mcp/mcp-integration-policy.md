---
description: "Model Context Protocol (MCP) Integration Policy"
version: 1.0.0
---

# MCP Integration Policy

Agent OS natively supports extending its capabilities through the **Model Context Protocol (MCP)**. While `SKILL.md` operates as local file-based capabilities, MCP serves as the bridge to living, dynamic external services securely.

## 1. When to Use MCP vs SKILL.md

| Feature Need                  | Recommendation               |
|:------------------------------|:-----------------------------|
| File system editing           | `SKILL.md`                   |
| Repository-local execution    | `SKILL.md`                   |
| Remote API connectivity       | `MCP Server`                 |
| Dynamic context streaming     | `MCP Server`                 |
| Persistent stateful sessions  | `MCP Server`                 |

## 2. Integration Tiers (Trust Model)

Before any MCP Server is integrated, it must be evaluated under the OS trust tiers:

- **T0 (System / Local-only)**: MCP Servers running locally without external internet access (e.g., local database read). Trusted; auto-approved.
- **T1 (Read-only External)**: MCP Servers fetching data from known external APIs (e.g., Weather API, GitHub Read-only). Requires initial user consent, then persisted.
- **T2 (Write External)**: MCP Servers that modify external systems (e.g., sending emails, pushing to remote repositories). **Must use human-in-the-loop approval at invocation time.**

## 3. Server Registration & Discovery

MCP servers should be registered per-project or globally via the agent client environment (e.g., `claude_desktop_config.json`, or `.cursor-plugin/mcp.json`).

The Agent OS assumes MCP capabilities are dynamically injected into its tool-calling context. When delegating tasks to specific agent roles (see `society-of-mind-pattern.md`), ensure that the specific sub-agent holds the required MCP tool context.

Every MCP server should also publish a capability manifest that states:

- read and write scope
- network scope
- credential requirements
- approval posture
- audit events and disable path

## 4. Sandboxing MCP Data

All incoming data from `T1` and `T2` MCP Servers is considered **untrusted context**. Before invoking an MCP tool, the OS must check if the tool is being used to inject malicious prompt instructions. Avoid blindly writing large MCP responses to governance files or the core context loop without summarization or sanitization.

For broader least-privilege and execution-boundary rules, see
`../../security/tool-and-plugin-capability-isolation.md`.
