# Next.js Governance Profile

Use this profile for Next.js applications.

## Boundary Rules

- keep server and client responsibilities explicit
- avoid leaking server-only secrets into client bundles
- choose rendering mode per route deliberately

## Data and Caching Rules

- define cache strategy per route and fetch layer
- document invalidation and revalidation behavior
- avoid implicit stale data behavior for critical paths

## Delivery Rules

- verify runtime target compatibility (node or edge)
- track route-level performance and error behavior
- include SSR/ISR/CSR behavior in testing scope
