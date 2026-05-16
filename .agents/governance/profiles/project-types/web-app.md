# Project Type Profile: Web Application

Version: 1.0.0
Status: Normative
Applies when: project `AGENTS.md` declares `web-app` or inference detects a
web application structure.

## Scope

This profile applies to projects that serve HTML/HTTP responses to users
through a browser or equivalent client.

## Architecture Expectations

- clear separation between transport (HTTP) and domain logic
- input validation before side effects
- session and auth boundaries explicit
- static asset handling documented or delegated
- error pages and degraded-mode behavior defined

## Security Expectations

- OWASP Web baseline applies: `.agents/governance/security/owasp-web-and-api-baseline.md`
- authentication and session security applies
- CSRF, XSS, and injection defenses required
- secrets must not appear in client-side bundles

## Validation Expectations

- browser-accessible smoke test or equivalent
- health endpoint or equivalent readiness signal
- accessibility baseline when the project claims production readiness

## Evidence Expectations

- deployment evidence must include the served URL or equivalent
- rollback must restore the previous served state
