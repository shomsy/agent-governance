# PolyMoly Platform

This directory owns the declarative platform vocabulary.

Ownership contract:

- `platform/` defines policy and posture law.
- `core/` interprets and enforces platform law.
- `features/` implement capability behavior.
- `features/` may harden platform defaults but may not weaken platform law.

Current scope:

- capability schemas for baby DSL validation and defaults
- module metadata
- profile bundles
- environment bundles
- policy bundles
- target-neutral render assets used by the first proof

This directory must not contain:

- shell commands
- runtime execution logic
- Docker daemon calls
- filesystem discovery inside `core`

The first proof bundle is intentionally small.
It exists to make the `platform` boundary real before a larger migration from the current runtime.
