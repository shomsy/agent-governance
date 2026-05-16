# UI Layer Contract

Purpose:

- `ui/` is presentation-only.
- `configurator/` remains the active setup product surface.
- `product/inspect/observe/enterprise/web` and `product/inspect/observe/dashboard/web` are baseline shells for future product lanes.

Boundary rules:

1. No runtime logic in `ui/**`.
2. No resolver/business-law duplication in `ui/**`.
3. Any `admin`/`dashboard` expansion must keep:
   - explicit product decision in `TODO.md`,
   - boundary check against core/platform authority,
   - smoke tests before promotion.

Current status:

- `product/inspect/observe/enterprise/web` => baseline shell with auth and telemetry contracts.
- `product/inspect/observe/dashboard/web` => baseline shell with event stream and telemetry contracts.
