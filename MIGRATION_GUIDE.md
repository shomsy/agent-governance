# Agent Harness V3 Migration Guide

This guide describes how to migrate a repository to the Agent Harness V3 OS.

## 1. Automated Migration
The easiest way to migrate is using the installer:
```bash
./install-os.sh /path/to/project --migrate --upgrade
```
This will:
- Archive legacy `TODO.md` and `BUGS.md` into `.agents/archive/legacy/`.
- Upgrade the `.rules` engine to V3.0.0.
- Initialize the new V3 machine evidence directories.

## 2. Manual Migration Steps
If you prefer manual migration:
1. Copy the new `.agents/` structure from the harness.
2. Update your root `AGENTS.md` to follow the V3 scaffold.
3. Move any machine evidence to `.agents/management/evidence/raw/`.
4. Create a `project.json` in `.agents/config/` with your project metadata.

## 3. Post-Migration Validation
After migration, run:
```bash
./install-os.sh /path/to/project --validate
```
Verify that all mandatory governance files are present and that the `AGENTS.md` precedence is correct.
