#!/bin/bash
# =============================================================================
# MCP Stack Installer
# 
# Installs and configures complete MCP stack for fullstack development.
# Supports VS Code, Cursor, Cline, OpenCode, and Blackbox.
#
# Usage:
#   ./install-mcp-stack.sh [--client vscode|cursor|cline|opencode|blackbox] [--stack full|minimal]
#
# Environment Variables Required:
#   GITHUB_TOKEN       - GitHub Personal Access Token
#   BRAVE_API_KEY      - Brave Search API Key  
#   DATABASE_URL       - PostgreSQL Connection String
#   DOCKER_HOST        - Docker Daemon Socket (optional)
#   KUBECONFIG         - Kubernetes Config (optional)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${PROJECT_ROOT:-$SCRIPT_DIR}"
CLIENT="${CLIENT:-vscode}"
STACK="${STACK:-full}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        log_success "$1 installed"
        return 0
    else
        log_warn "$1 not found"
        return 1
    fi
}

check_dependencies() {
    log_info "Checking dependencies..."
    
    local missing=()
    
    check_command "node" || missing+=("node")
    check_command "npm" || missing+=("npm")
    check_command "npx" || missing+=("npx")
    
    if ! command -v "uv" >/dev/null 2>&1; then
        log_warn "uv not found (required for Serena)"
        log_info "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing required commands: ${missing[*]}"
        log_info "Please install: npm install -g ${missing[*]}"
        exit 1
    fi
    
    log_success "All dependencies installed"
}

install_mcp_server() {
    local name="$1"
    local command="$2"
    local args="$3"
    local env="$4"
    
    log_info "Installing $name..."
    
    if [ -n "$env" ]; then
        eval "$command $args" 2>/dev/null || log_warn "$name installation may have issues"
    else
        $command $args 2>/dev/null || log_warn "$name installation may have issues"
    fi
}

generate_vscode_config() {
    log_info "Generating VS Code MCP configuration..."
    
    mkdir -p "$PROJECT_ROOT/.vscode"
    
    cat > "$PROJECT_ROOT/.vscode/mcp.json" <<'EOF'
{
  "mcpServers": {
    "vscode": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-vscode"]
    },
    "serena": {
      "command": "uvx",
      "args": ["serena-mcp"],
      "env": {}
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "${BRAVE_API_KEY}"
      }
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-playwright"]
    },
    "docker": {
      "command": "npx",
      "args": ["-y", "docker-mcp-server"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": ["${PROJECT_ROOT}"]
      }
    }
  }
}
EOF

    log_success "Created .vscode/mcp.json"
}

generate_opencode_config() {
    log_info "Generating OpenCode MCP configuration..."
    
    cat > "$PROJECT_ROOT/opencode.json" <<EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "permission": {
    "*": "ask",
    "read": "allow",
    "bash": {
      "*": "ask",
      "git status*": "allow",
      "git diff*": "allow",
      "git log*": "allow",
      "grep *": "allow",
      "rg *": "allow",
      "find *": "allow",
      "ls *": "allow",
      "cat *": "allow"
    },
    "task": {
      "*": "deny",
      "harness-*": "allow"
    }
  },
  "mcpServers": {
    "vscode": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-vscode"]
    },
    "serena": {
      "command": "uvx",
      "args": ["serena-mcp"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_TOKEN": "\${GITHUB_TOKEN}" }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": { "DATABASE_URL": "\${DATABASE_URL}" }
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": { "BRAVE_API_KEY": "\${BRAVE_API_KEY}" }
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-playwright"]
    },
    "docker": {
      "command": "npx",
      "args": ["-y", "docker-mcp-server"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "${PROJECT_ROOT}"]
    }
  },
  "agents": {
    "harness-supervisor": {
      "description": "Main orchestration agent",
      "mode": "subagent",
      "hidden": true,
      "permission": {
        "edit": "deny",
        "task": { "*": "deny", "harness-*": "allow" },
        "mcp": {
          "vscode": "allow",
          "serena": "allow",
          "github": "read",
          "filesystem": "read"
        }
      }
    },
    "harness-mapper": {
      "description": "Code mapping and file discovery",
      "mode": "subagent",
      "hidden": true,
      "permission": {
        "edit": "deny",
        "mcp": {
          "vscode": "allow",
          "serena": "allow",
          "filesystem": "read"
        }
      }
    },
    "harness-researcher": {
      "description": "Documentation and API research",
      "mode": "subagent",
      "hidden": true,
      "permission": {
        "edit": "deny",
        "webfetch": "allow",
        "mcp": {
          "brave-search": "allow",
          "github": "read",
          "docs": "allow"
        }
      }
    },
    "harness-executor": {
      "description": "Code implementation and changes",
      "mode": "subagent",
      "hidden": true,
      "permission": {
        "edit": "allow",
        "bash": { "*": "ask", "npm *": "ask", "pytest *": "allow" },
        "mcp": {
          "vscode": "allow",
          "serena": "allow",
          "postgres": "read"
        }
      }
    },
    "harness-reviewer": {
      "description": "Code review and risk analysis",
      "mode": "subagent",
      "hidden": true,
      "permission": {
        "edit": "deny",
        "mcp": {
          "vscode": "allow",
          "github": "read"
        }
      }
    }
  }
}
EOF

    log_success "Created opencode.json"
}

generate_cline_config() {
    log_info "Generating Cline MCP configuration..."
    
    mkdir -p "$PROJECT_ROOT/.clinerules"
    
    cat > "$PROJECT_ROOT/.clinerules/00-mcp-stack.md" <<'EOF'
# MCP Stack Configuration

This project uses the following MCP servers:

| Server | Purpose | Trust Tier |
|:-------|:--------|:-----------|
| VS Code | Editor integration | T0 |
| Serena | Semantic code retrieval | T0 |
| GitHub | Repository operations | T1 |
| PostgreSQL | Database access | T1 |
| Brave Search | Web search | T0 |
| Playwright | E2E testing | T1 |
| Docker | Container ops | T1 |

## Environment Variables

Set these in your shell profile:

```bash
export GITHUB_TOKEN="ghp_..."
export BRAVE_API_KEY="..."
export DATABASE_URL="postgresql://..."
```

## Usage

MCP servers are automatically available in supported AI clients.
For Cline, ensure MCP servers are configured in settings.
EOF

    log_success "Created .clinerules/00-mcp-stack.md"
}

create_env_template() {
    log_info "Creating environment template..."
    
    cat > "$PROJECT_ROOT/.env.example" <<'EOF'
# Required for MCP servers
GITHUB_TOKEN=ghp_your_token_here
BRAVE_API_KEY=your_brave_api_key

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Optional
DOCKER_HOST=unix:///var/run/docker.sock
KUBECONFIG=/path/to/kubeconfig
EOF

    log_success "Created .env.example"
    
    if [ ! -f "$PROJECT_ROOT/.env" ]; then
        cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/.env"
        log_info "Created .env from template - fill in your values!"
    fi
}

preinstall_servers() {
    log_info "Pre-installing MCP servers..."
    
    local servers=(
        "@modelcontextprotocol/server-vscode"
        "@modelcontextprotocol/server-github"
        "@modelcontextprotocol/server-postgres"
        "@modelcontextprotocol/server-brave-search"
        "@anthropic/mcp-server-playwright"
        "docker-mcp-server"
        "@modelcontextprotocol/server-filesystem"
        "@modelcontextprotocol/server-memory"
        "@modelcontextprotocol/server-sequential-thinking"
        "@modelcontextprotocol/server-fetch"
    )
    
    for server in "${servers[@]}"; do
        log_info "Installing $server..."
        npm install -g "$server" 2>/dev/null || log_warn "$server install failed, will use npx"
    done
    
    log_success "MCP servers pre-installed"
}

parse_args() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --client)
                CLIENT="$2"
                shift 2
                ;;
            --stack)
                STACK="$2"
                shift 2
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --client CLIENT    Target client: vscode, cursor, cline, opencode, blackbox (default: vscode)"
                echo "  --stack STACK      Stack size: minimal, full (default: full)"
                echo "  --help, -h         Show this help"
                echo ""
                echo "Examples:"
                echo "  $0 --client vscode --stack full"
                echo "  $0 --client opencode --stack minimal"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
}

main() {
    parse_args "$@"
    
    echo ""
    echo "=========================================="
    echo "   MCP Stack Installer"
    echo "   Client: $CLIENT"
    echo "   Stack:  $STACK"
    echo "=========================================="
    echo ""
    
    check_dependencies
    
    if [ "$STACK" == "full" ]; then
        preinstall_servers
    fi
    
    case "$CLIENT" in
        vscode|cursor)
            generate_vscode_config
            ;;
        opencode)
            generate_opencode_config
            ;;
        cline)
            generate_cline_config
            ;;
        blackbox)
            generate_vscode_config
            log_info "Blackbox uses VS Code MCP settings"
            ;;
        all)
            generate_vscode_config
            generate_opencode_config
            generate_cline_config
            ;;
    esac
    
    create_env_template
    
    echo ""
    echo "=========================================="
    echo -e "${GREEN}   MCP Stack Installation Complete!"
    echo "==========================================${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Edit .env with your API keys"
    echo "  2. Restart your AI client"
    echo "  3. Test MCP servers"
    echo ""
    echo "For VS Code: The servers will auto-load"
    echo "For OpenCode: Use opencode.json"
    echo "For Cline: Use .clinerules/"
    echo ""
}

main "$@"
