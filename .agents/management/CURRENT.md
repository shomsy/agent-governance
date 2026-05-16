# Current — Operational Truth

Last updated: 2026-05-16
Commit: 4563b3aab20e00cd5880ec40720c1e820c12b9b9 (pre-hardening pass)

## What Is True Right Now

- Agent Harness Version: **V3.0.0 (Truth Hardening Pass)**
- Active State: **GREEN_WITH_ACCEPTED_YELLOW_DEBT**
- Branch: main
- Governance: Unified V3 OS (single canonical precedence chain)
- Evidence Model: V3 Enterprise (human dashboard + machine evidence + JSON schemas)
- Profile System: Languages (5), Project types (7), Overlays (4), Arch styles (4), Repo kinds (1)
- Security: LOUD — OWASP-aligned, explicit blocker matrix
- Trust: T0–T3 tiers, sandbox boundaries, approval policy
- Installer: V3 with --dry-run (proven), --validate, --upgrade, --migrate (implemented, partial smoke)

## Accepted YELLOW Debt

| ID | Item | Expiry |
|---|---|---|
| DEBT-INSTALLER-01 | Upgrade/migrate not smoke-tested against external target | 2026-06-16 |

## Next Allowed Action

Commit all V3 hardening changes to main.
Suggested message: `hardening: align agent harness v3 productization truth`
