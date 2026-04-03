# MCP Stack for Cline

This project uses the complete MCP stack for fullstack development.

## MCP Servers Configured

| Server | Package | Purpose | Trust |
|--------|---------|---------|-------|
| VS Code | `@modelcontextprotocol/server-vscode` | Editor integration | T0 |
| Serena | `serena-mcp` | Semantic code retrieval | T0 |
| GitHub | `@modelcontextprotocol/server-github` | Repo operations | T1 |
| PostgreSQL | `@modelcontextprotocol/server-postgres` | Database | T1 |
| Brave Search | `@modelcontextprotocol/server-brave-search` | Web search | T0 |
| Playwright | `@anthropic/mcp-server-playwright` | Browser automation | T1 |
| Docker | `docker-mcp-server` | Container ops | T1 |

## Environment Variables

Set these in your shell:

```bash
export GITHUB_TOKEN="ghp_..."
export BRAVE_API_KEY="..."
export DATABASE_URL="postgresql://..."
```

## Sub-Agent Workflow

Use the sub-agent system for token efficiency:

1. **Map tasks** → Use `harness-mapper` or VS Code symbols
2. **Research** → Use `harness-researcher` with Brave Search
3. **Execute** → Use `harness-executor` for code changes
4. **Review** → Use `harness-reviewer` for risk analysis

## Token Budget

- Mapper: 2,000 tokens max
- Researcher: 3,000 tokens max
- Executor: 15,000 tokens max
- Reviewer: 5,000 tokens max

## Key Principles

1. **Serena > Filesystem** - Use semantic retrieval, not full file reads
2. **Codex is NOT default** - Use read-only agents first
3. **Trust tiers** - T0 for read, T1 for write, T2 for external
