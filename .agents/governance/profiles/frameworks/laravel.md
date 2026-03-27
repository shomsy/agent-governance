# Laravel Governance Profile

Use this profile for Laravel applications.

## Layering Rules

- keep controllers and routes focused on transport concerns
- keep domain behavior in services/actions with clear ownership
- avoid placing domain logic in views or route closures

## Data and Migration Rules

- keep migrations deterministic and reviewable
- verify seed and migration paths for non-destructive rollout
- enforce model validation and authorization boundaries

## Security and Operations

- protect sensitive actions with policies and gates
- keep secrets and environment policy strict
- include queue and job failure handling in release checks
