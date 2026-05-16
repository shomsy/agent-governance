# MCP Stack (Optional Integration)

> **This file is an OPTIONAL integration reference, not a parent OS requirement.**
> MCP integration is opt-in. Projects that do not use MCP are fully supported.
> Do not treat any server listed here as mandatory.

## Overview

The Agent Harness supports extending agent capabilities via the
[Model Context Protocol (MCP)](https://modelcontextprotocol.io/).
The core governance in `.agents/governance/integrations/mcp/mcp-integration-policy.md`
defines the trust model, forbidden operations, and sandbox rules.

This file describes *example* MCP server configurations for projects that opt in.

---

## Example Server Categories

| Category | Purpose | Trust Tier |
|:---|:---|:---|
| Docs MCP | Project docs and external API knowledge | T0 (ReadOnly) |
| GitHub Read-only MCP | Issues, PRs, diffs | T0 (ReadOnly) |
| CI / Logs MCP | Build logs, test summaries | T0 (ReadOnly) |
| Database Write MCP | **FORBIDDEN** for autonomous use | T2+ Human Approval |
| Deployment MCP | **FORBIDDEN** for autonomous use | T2+ Human Approval |

---

## Configuration

MCP servers are configured per-project via the AI client environment.
See your client's documentation (e.g., `claude_desktop_config.json`, `.cursor/mcp.json`).

**Required environment variables are project-specific and MUST NOT be committed.**
Use `.env.example` (no real values) and `.gitignore` your `.env`.

Example variables a project MAY need (never commit real values):
```
GITHUB_TOKEN=          # Read-only GitHub PAT — optional
BRAVE_API_KEY=         # Web search — optional
DATABASE_URL=          # Only if project uses DB MCP — optional
```

For installation of the full example MCP stack, see `install-mcp-stack.sh`.
This is an optional helper script, not a requirement of the Agent Harness OS.
