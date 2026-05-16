# Language Profile: Go

Version: 1.0.0
Status: Normative
Applies when: project `AGENTS.md` declares `go` or inference detects `go.mod`.

## Scope

Go-specific coding, tooling, and quality rules.

## Coding Rules

- follow `gofmt` and `go vet` conventions unconditionally
- prefer short package names that describe capability
- use explicit error handling — do not panic in library code
- keep interfaces small and consumer-defined
- use `context.Context` for cancellation and deadline propagation
- avoid global mutable state
- prefer composition over inheritance (Go has no inheritance)

## Module Rules

- use Go modules (`go.mod`) for dependency management
- keep `go.sum` committed
- pin dependencies to specific versions
- avoid `replace` directives in published modules

## Testing Rules

- use `go test` as the canonical test runner
- table-driven tests preferred for combinatorial cases
- use `t.Helper()` in test utilities
- benchmark performance-critical paths with `testing.B`

## Tooling

- `go fmt` — formatting
- `go vet` — static analysis
- `golangci-lint` — extended linting (when configured)
- `go test -race` — race condition detection
- `go build` — compilation verification

## Architecture Notes

See `.agents/governance/architecture/architecture-standard.md` under the Go
section for Go-specific architecture rules.

Package boundary is more important than deeply descriptive filenames.

## Validation Expectations

- (To be defined: validation expectations for go)

## Testing Expectations

- (To be defined: testing expectations for go)

## Static Analysis Expectations

- (To be defined: static analysis expectations for go)

## Security Expectations

- (To be defined: security expectations for go)

## Release Expectations

- (To be defined: release expectations for go)

## Evidence Expectations

- (To be defined: evidence expectations for go)

## Common Failure Patterns

- (To be defined: common failure patterns for go)

## Review Expectations

- (To be defined: review expectations for go)

## Dependency Rules

- (To be defined: dependency rules for go)

## Formatting Rules

- (To be defined: formatting rules for go)

## Runtime Assumptions

- (To be defined: runtime assumptions for go)

## Operational Expectations

- (To be defined: operational expectations for go)
