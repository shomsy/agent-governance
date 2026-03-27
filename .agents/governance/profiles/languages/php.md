# PHP Governance Profile

Use this profile for PHP applications and services.

## Code Organization Rules

- prefer clear domain modules over global helper sprawl
- keep controllers thin and business behavior in domain slices
- keep framework glue separate from core domain logic

## Safety Rules

- validate and sanitize all request input
- use parameterized queries and safe ORM patterns
- escape output by context to reduce injection risk
- avoid dynamic include and eval patterns

## Delivery Rules

- keep migrations explicit, reversible where practical
- verify backward compatibility for public API and schema contracts
- record production-impacting config changes in release evidence
