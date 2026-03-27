# JavaScript Governance Profile

Use this profile for JavaScript repositories.

## Design Defaults

- prefer small feature slices over large utility buckets
- keep side effects explicit and near boundaries
- avoid hidden mutation in shared objects
- choose descriptive module names over generic folders

## Runtime and Dependency Rules

- pin behavior by lockfile and reproducible scripts
- avoid unnecessary runtime dependencies
- isolate browser-only and server-only code paths
- prefer explicit import boundaries per slice

## Testing Rules

- cover pure transformations with unit tests
- cover integration at feature entry boundaries
- add regression tests for previously fixed defects

## Security Rules

- validate and constrain all external input
- avoid unsafe HTML injection patterns by default
- keep secrets out of code and fixtures
