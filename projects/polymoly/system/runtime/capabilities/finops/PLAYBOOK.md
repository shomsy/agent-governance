# FinOps Operating Playbook

## Scope
- Monthly budget guardrails for core platform services.
- Cost per service, cost per request, and RPS-per-CPU efficiency tracking.

## Operating Cadence
- Weekly: run `go run ./system/tools/poly/cmd/poly finops guardrails` and `go run ./system/tools/poly/cmd/poly finops efficiency`.
- Monthly: review `system/gates/artifacts/finops/*.tsv` trends and adjust limits.
- Release gate: `go run ./system/tools/poly/cmd/poly gate check finops-layer` must pass.

## Decision Rules
- If monthly_total_usd exceeds budget: freeze non-critical scaling changes.
- If projected USD/1k requests increases >20% month over month: trigger optimization sprint.
- If RPS-per-CPU drops below threshold: investigate latency path and worker saturation.

## Escalation
- Infra owner: tune CPU/memory limits and autoscaling thresholds.
- App owner: reduce expensive endpoints and cache misses.
- Security owner: verify hardening changes did not regress efficiency excessively.
