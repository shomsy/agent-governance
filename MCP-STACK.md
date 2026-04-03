# MCP Stack Documentation

## Overview

This document describes the MCP (Model Context Protocol) stack configured for fullstack development.

## Quick Start

### 1. Install Dependencies

```bash
# Install MCP stack
./install-mcp-stack.sh --client opencode --stack full
```

### 2. Configure Environment

Edit `.env` with your API keys:

```bash
GITHUB_TOKEN=ghp_your_token
BRAVE_API_KEY=your_brave_key
DATABASE_URL=postgresql://user:pass@localhost:5432/db
```

### 3. Restart AI Client

MCP servers will auto-load on restart.

---

## MCP Servers

### Tier 1: Core (Essential)

| Server | Package | Purpose |
|--------|---------|---------|
| **Filesystem** | `@modelcontextprotocol/server-filesystem` | File operations (RESTRICTED) |
| **GitHub** | `@modelcontextprotocol/server-github` | Repo, PRs, issues |

### Tier 2: Semantic Coding

| Server | Package | Purpose |
|--------|---------|---------|
| **VS Code** | `@modelcontextprotocol/server-vscode` | Symbol search, outlines |
| **Serena** | `serena-mcp` | Semantic code retrieval via LSP |

### Tier 3: Database

| Server | Package | Purpose |
|--------|---------|---------|
| **PostgreSQL** | `@modelcontextprotocol/server-postgres` | Full database access |
| **SQLite** | `@modelcontextprotocol/server-sqlite` | Local lightweight DB |

### Tier 4: Search & Research

| Server | Package | Purpose |
|--------|---------|---------|
| **Brave Search** | `@modelcontextprotocol/server-brave-search` | Web search |
| **Fetch** | `@modelcontextprotocol/server-fetch` | HTTP requests |

### Tier 5: Automation

| Server | Package | Purpose |
|--------|---------|---------|
| **Playwright** | `@anthropic/mcp-server-playwright` | Browser automation |
| **Docker** | `docker-mcp-server` | Container management |
| **Kubernetes** | `kubernetes-mcp-server` | K8s cluster |

### Tier 6: Utilities

| Server | Package | Purpose |
|--------|---------|---------|
| **Memory** | `@modelcontextprotocol/server-memory` | Knowledge graph |
| **Sequential Thinking** | `@modelcontextprotocol/server-sequential-thinking` | Reasoning |

---

## Usage by Agent

### harness-mapper (Code Discovery)
- VS Code MCP (symbol search)
- Serena MCP (semantic retrieval)
- Filesystem (read-only)

### harness-researcher (Documentation)
- Brave Search (web search)
- GitHub (repo docs)
- Fetch (API calls)

### harness-executor (Implementation)
- VS Code MCP
- Serena MCP
- PostgreSQL (schema access)
- Docker (if needed)

### harness-reviewer (Code Review)
- VS Code MCP
- GitHub (PR context)
- Serena MCP

---

## Trust Tiers

| Tier | Access | Requires Approval |
|------|--------|-------------------|
| **T0** | Read-only, local | No |
| **T1** | Workspace write | No |
| **T2** | External operations | **Yes** |

---

## Token Budget

| Agent | Max Tokens |
|-------|------------|
| Mapper | 2,000 |
| Researcher | 3,000 |
| Executor | 15,000 |
| Reviewer | 5,000 |

---

## Best Practices

1. **Use Serena for code** - Don't read entire files, use symbol-level retrieval
2. **Restrict Filesystem** - Only allow specific directories
3. **T2 requires approval** - Kubernetes and external writes need human OK
4. **Monitor tokens** - Track usage in metrics

---

## Troubleshooting

### MCP server not starting
```bash
# Check if package is installed
npm list -g @modelcontextprotocol/server-github

# Try running manually
npx @modelcontextprotocol/server-github
```

### Authentication errors
```bash
# Verify environment variables
echo $GITHUB_TOKEN
echo $DATABASE_URL
```

### Permission denied
- Check `.vscode/mcp.json` or `opencode.json` config
- Ensure correct trust tier settings

---

## API Keys Required

| Key | Where to Get | Purpose |
|-----|--------------|---------|
| `GITHUB_TOKEN` | GitHub Settings → Developer → Personal Access Token | GitHub API |
| `BRAVE_API_KEY` | https://brave.com/search/api/ | Web Search |
| `DATABASE_URL` | Your PostgreSQL connection string | Database |

---

## File Structure

```
.
├── opencode.json           # Main MCP + agent config
├── .env                   # Environment variables (gitignored)
├── .env.example           # Template for env vars
├── .vscode/
│   └── mcp.json          # VS Code MCP config
├── .clinerules/
│   └── 00-mcp-stack.md  # Cline MCP docs
├── install-mcp-stack.sh   # Installer script
└── mcp-stack-config.json # Full configuration reference
```
