# Project Type Profile: CLI

Version: 1.0.0
Status: Normative
Applies when: project `AGENTS.md` declares `cli` or inference detects a
command-line tool structure.

## Scope

This profile applies to projects that provide command-line interfaces as their
primary user surface.

## Architecture Expectations

- clear separation between CLI parsing and core logic
- exit codes are meaningful and documented
- help text is accurate and generated from the same source as behavior
- stdin/stdout/stderr usage is deliberate

## Validation Expectations

- automated tests for argument parsing and core commands
- error output tested for user clarity
- cross-platform behavior documented when relevant

## Evidence Expectations

- help text output captured as evidence
- exit code behavior documented
