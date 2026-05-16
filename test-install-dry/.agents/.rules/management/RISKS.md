# Risks — Accepted Debt and Risk

## Entry Format

- `id`:
- `recorded_at`:
- `updated_at`:
- `status`: open | accepted | mitigated | closed
- `severity`: low | medium | high | critical
- `owner`:
- `description`:
- `target_resolution`:
- `expiry`:
- `evidence`:
- `blocking_decision`:

## Current Risks

- `id`: RISK-V3-TRANSITION
- `recorded_at`: 2026-05-16
- `updated_at`: 2026-05-16
- `status`: open
- `severity`: medium
- `owner`: harness-architect
- `description`: Massive overhaul across 17 phases could introduce regressions in existing installations.
- `target_resolution`: Maintain continuous backward compatibility through scaffolding and migration systems.
- `expiry`: 2026-06-01
- `evidence`: V3 Productization Pass
- `blocking_decision`: Accept risk, proceed with V3 evolution.
