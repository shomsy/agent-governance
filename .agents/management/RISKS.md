# Risks Register

Last updated: 2026-05-16

## Active Risks

### RISK-INSTALLER-01 — Partial Installer Smoke Coverage

| Field | Value |
|---|---|
| **ID** | RISK-INSTALLER-01 |
| **Severity** | MEDIUM |
| **Owner** | maintainer |
| **Description** | `--upgrade` and `--migrate` flags are implemented in `install-os.sh` but not verified against a clean external target in this pass |
| **Impact** | Docs may describe behavior not yet smoke-proven |
| **Likelihood** | LOW — flags are implemented, pattern is consistent with --dry-run |
| **Mitigation** | `--dry-run` works. Profile selection works. Core install works. |
| **Expiry** | 2026-06-16 |
| **Evidence** | `.agents/management/evidence/phases/v3-hardening-05-installer-proof.md` |
| **Blocking Decision** | Accepted as YELLOW debt. Does not block commit. Blocks final productization sign-off. |
| **Status** | ACTIVE |

## Resolved Risks

*(None this pass)*
