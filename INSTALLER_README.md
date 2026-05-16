# Agent Harness V3 Installer Guide

The `install-os.sh` script is the primary entry point for installing or upgrading the Agent Harness OS.

## Usage
```bash
./install-os.sh <TARGET_DIR> [OPTIONS]
```

## Options
- `--language=<NAME>`: Select a language profile (e.g., `php`, `go`, `nodejs`).
- `--framework=<NAME>`: Select a framework profile (e.g., `laravel`, `nextjs`).
- `--repository-profile=<NAME>`: Select a repo kind (e.g., `governance-source`).
- `--platform=<LIST>`: Generate adapters for specific AI platforms (e.g., `claude,cursor,gemini`).
- `--dry-run`: Test the installation without modifying files.
- `--validate`: Verify an existing installation.
- `--upgrade`: Update the `.rules` engine to the latest version.
- `--migrate`: Archive legacy structures and prepare for V3.

## Idempotency
The installer is idempotent. Running it multiple times on the same directory will ensure the structure is correct without overwriting project-specific local configurations (unless `--upgrade` is used).
