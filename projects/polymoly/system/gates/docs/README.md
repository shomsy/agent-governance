# PolyMoly Docs Consumer Surface

This directory contains the mono-repo consumer inputs for the external doc-engine.

## Role

- `system/gates/system/docs/rules/` contains the PolyMoly rules JSON.
- `system/gates/system/docs/tests/` contains consumer fixtures.
- `go run ./system/tools/poly/cmd/poly docs governance` is the gate entrypoint.

## Consumption Contract

The Python engine now lives in the standalone repository and image:

- `https://github.com/shomsy/poly-moly-doc-engine`
- `ghcr.io/shomsy/poly-moly-doc-engine`

The mono-repo keeps only consumer-owned law and fixtures:

- `system/gates/system/docs/rules/polymoly.rules.json`
- `system/gates/system/docs/tests/*.md`
