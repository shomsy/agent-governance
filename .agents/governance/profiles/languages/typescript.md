# TypeScript Governance Profile

Use this profile for TypeScript repositories.

## Type Safety Rules

- treat `any` as an explicit exception, not a default
- model domain contracts with stable interfaces and types
- prefer narrow types at boundaries over broad unions without guards
- keep runtime validation for untrusted external input

## Design Defaults

- keep feature entry points explicit
- expose minimal public surface per module
- avoid type-only abstractions that hide runtime complexity

## Build and Tooling Rules

- keep compiler strictness high for new code
- do not silence type errors without documented reason
- align tsconfig with delivery/runtime needs, not fashion

## Testing Rules

- test behavior, not type system internals
- verify critical type guards and boundary adapters
