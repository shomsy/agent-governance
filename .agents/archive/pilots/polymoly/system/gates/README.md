# Gates Suite

`system/gates/` is the non-mutating verification layer.

## Canonical Runner

Use only:

```bash
go run ./system/tools/poly/cmd/poly gate run <profile>
```

Canonical profiles:

- `p0`: merge-law baseline
- `full`: extended verification
- `nightly`: heavy scans and deep checks
- `docs`: documentation integrity

`--changed` is local optimization only.

## Profile Responsibilities and Runtime Cost

| Profile | Responsibility | Expected Cost |
| --- | --- | --- |
| `p0` | merge-law baseline for engine + hardening contracts | low (target: fast PR loop) |
| `full` | release-quality extension over `p0` | medium |
| `nightly` | deep security/perf/resilience scans | high |
| `docs` | documentation/governance integrity only | low |

Profile names are frozen by contract: `p0`, `full`, `nightly`, `docs`.
New profile names are not allowed without explicit architecture decision.

## Security Suite (Aggregated View)

Security checks are documented as one suite with subdomains:

- `policy/`: policy and model checks (OPA, threat model, secrets rotation, SRE observability)
- `hardening/`: runtime/image/isolation hardening checks
- `security-scanning/`: supply-chain and SBOM scans

This keeps one security narrative while preserving per-gate depth.

## Artifacts

All evidence is written to `system/gates/artifacts/**`.
See [`system/gates/artifacts/README.md`](./artifacts/README.md) for lookup rules.
