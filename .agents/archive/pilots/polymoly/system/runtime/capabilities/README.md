# Feature Maturity Map

This file exposes feature maturity without changing taxonomy.

## Status Levels

- `Active`: used in current runtime/gates paths.
- `Experimental`: implemented baseline, still evolving.
- `Planned`: reserved taxonomy slot; not in active runtime path yet.

## Current Status

| Feature | Status | Notes |
| --- | --- | --- |
| `database` | Active | Postgres/MySQL + pooling providers are wired in runtime and gates. |
| `gateway` | Active | Traefik and gateway security paths are actively validated. |
| `cache` | Active | Redis/varnish paths are used in current compose/runtime flows. |
| `messaging` | Active | RabbitMQ integration is part of baseline runtime contract. |
| `identity` | Active | Keycloak module and profile wiring are present. |
| `observability` | Active | Prometheus/Grafana/Loki/Promtail checks are wired. |
| `security` | Active | Hardening/policy/scan suites are actively enforced. |
| `backup` | Active | Restore and serving proof flows exist. |
| `ai` | Experimental | Nanoclaw integration is present; product surface still evolving. |
| `finops` | Experimental | Cost/efficiency checks exist; reporting model is evolving. |
| `gitops` | Experimental | GitOps rollout checks exist; target policy is still stabilizing. |
| `multi-tenant` | Experimental | Baseline config exists; broader runtime coverage pending. |
| `storage` | Experimental | MinIO baseline exists; enterprise posture integration pending. |
