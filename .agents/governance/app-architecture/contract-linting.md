# Contract Linting

This document defines machine checks for authored contracts such as
configuration, policies, content manifests, and declarative workflows.

## Required Checks

- required fields are present
- identifiers are unique within their documented scope
- references resolve to known targets
- enum values use allowed vocabulary
- numeric limits stay within documented bounds
- deprecated fields are rejected or explicitly migrated
- unsafe executable payloads are blocked or explicitly gated

## Rule

Lint protects contract integrity, not style preference.
If lint finds a contract break, the authored artifact is not release-ready.
