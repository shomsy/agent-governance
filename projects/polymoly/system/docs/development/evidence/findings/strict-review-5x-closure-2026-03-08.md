---
scope: system/tools/poly/**,system/shared/**,product/**,README.md,Taskfile.yml,system/gates/run,system/docs/development/**
status: archived
date: 2026-03-08
review_mode: execution
---

# Strict Review 5x Closure

Decision:

- Keep and Improve

Reviewed scope:

- repo-independent CLI behavior, module trust enforcement, release secret handling, internal JWT artifact completeness, and product-layer ownership honesty
- review basis: five-pass independent review executed on `2026-03-08`, followed by remediation and verification on the same date

Context gate:

- system/layer in scope: `system/tools/poly`, `system/shared`, selected `product/**` wrappers, release/install docs, and evidence docs
- runtime context: local Go test verification plus canonical `p0`, `docs`, and `full` gate runs on a Docker-enabled host
- compatibility constraints: AGENTS hard contract, fail-closed trust posture, release evidence law, and project-local install story promised in `README.md`
- expectations: no open `high`/`critical` findings from the original five-pass review, deterministic operator behavior, and truthful ownership surfaces

## Findings Closure

### 1) CLOSED — installed CLI now works outside the source monorepo

Original risk:

- high

Root cause:

- CLI root discovery hard-failed before command dispatch and assumed a source-repo `AGENTS.md` marker.

Resolution:

- introduced command-aware runtime resolution so `help`, `version`, `install`, and `self-update` no longer require repository-root detection before dispatch
- added project-local manifest source-root support so installed binaries can resolve the canonical source binary for maintenance flows without treating the generated project as the source repository
- removed the stale hardcoded CLI version constant and replaced it with build-time injected `Version`

Primary implementation paths:

- `system/tools/poly/internal/cli/route_root_commands.go`
- `system/tools/poly/internal/cli/resolve_cli_runtime.go`
- `system/tools/poly/internal/cli/expand_variable_placeholders.go`
- `product/deploy/prepare/install_project_cli.go`
- `Taskfile.yml`
- `system/gates/run`

Verification:

- `go test ./system/tools/poly/internal/cli ./system/tools/poly/internal/installops -run 'TestRunVersionDoesNotRequireRepoRoot|TestResolveProjectLocalSourceRoot|TestInstallProjectBinarySupportsSelfCopyWithoutCorruption'` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go build -o /tmp/poly-review-bin ./system/tools/poly/cmd/poly` -> PASS
- `/tmp/poly-review-bin help` from a temp directory -> PASS
- `/tmp/poly-review-bin version` from a temp directory -> `dev`
- `/tmp/poly-review-bin install --project <tmp-project>` -> PASS
- `<tmp-project>/.polymoly/bin/poly help` -> PASS

### 2) CLOSED — external module verification no longer downgrades trust on registry auth denial

Original risk:

- critical

Root cause:

- registry auth failures dropped descriptor verification from strict digest/provenance enforcement to relaxed local-tag acceptance.

Resolution:

- local fallback verification now stays strict and requires the locked digest and provenance labels instead of relaxing trust
- source-bootstrap image builds stamp source and revision labels so strict local verification has real metadata to validate
- stale local images are invalidated when their metadata no longer matches the descriptor lock
- external module lock digests were refreshed to the deterministic local build outputs used by the canonical runtime

Primary implementation paths:

- `system/shared/config/resolve_module_from_registry.go`
- `system/shared/config/configure_module_runtime.go`
- `system/shared/config/external-modules.lock.json`
- `system/shared/config/check_external_module_contract.go`

Verification:

- `go test ./system/shared/config -run 'TestVerifyDescriptorMetadata'` -> PASS
- `sg docker -c 'cd /home/shomsy/projects/polymoly && env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run p0'` -> PASS
- `sg docker -c 'cd /home/shomsy/projects/polymoly && env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run full'` -> PASS

### 3) CLOSED — promoted secret preparation is fail-closed and private by default

Original risk:

- high for placeholder-success behavior
- medium for file permissions

Root cause:

- promoted secret preparation silently replaced missing values with hardcoded defaults and then relaxed file permissions to world-readable.

Resolution:

- removed hardcoded placeholder fallback values from promoted secret preparation
- missing or placeholder inputs now hard-fail unless the operator explicitly opts into unsafe ephemeral generation
- unsafe path requires `POLY_ALLOW_EPHEMERAL_PROMOTED_SECRETS=1` and emits visible unsafe output
- secret files stay at `0600`

Primary implementation paths:

- `system/shared/utils/rotate_system_secrets.go`
- `system/shared/utils/rotate_system_secrets_test.go`

Verification:

- `go test ./system/shared/utils -run 'TestPreparePromotedSecrets'` -> PASS
- `sg docker -c 'cd /home/shomsy/projects/polymoly && env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run full'` -> PASS

### 4) CLOSED — internal JWT generation now emits the verification artifacts the runtime expects

Original risk:

- medium

Root cause:

- token generation produced only a private key and signed token, while runtime verification expects a public PEM and JWKS.

Resolution:

- generation now writes matching public PEM and JWKS artifacts alongside the private key and token
- token output is no longer printed by default; explicit opt-in is required for stdout exposure
- token artifact permissions stay private

Primary implementation paths:

- `system/shared/utils/sign_and_validate_jwt_tokens.go`
- `system/shared/utils/sign_and_validate_jwt_tokens_test.go`

Verification:

- `go test ./system/shared/utils -run 'TestGenerateInternalJWT'` -> PASS
- `sg docker -c 'cd /home/shomsy/projects/polymoly && env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run full'` -> PASS

### 5) CLOSED — decorative product-layer seams were either wired into real paths or removed

Original risk:

- medium

Root cause:

- parts of `product/**` advertised ownership that did not match the real command path, and one production function lived in a `_test.go` file.

Resolution:

- runtime and release CLI paths now call the product-layer wrappers where those wrappers are the intended ownership seam
- empty or decorative product-layer files were removed
- stage-smoke implementation was moved out of a `_test.go` file into compiled production code

Primary implementation paths:

- `system/tools/poly/internal/cli/route_operator_commands.go`
- `system/tools/poly/internal/cli/invoke_v3_legacy_commands.go`
- `system/tools/poly/internal/cli/route_runtime_commands.go`
- `product/deploy/validate/check_stage_smoke.go`
- `product/project/lifecycle/access/expose_project_url.go`

Verification:

- `go test ./product/... ./system/tools/poly/... ./system/shared/...` -> PASS
- `sg docker -c 'cd /home/shomsy/projects/polymoly && env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run p0'` -> PASS
- `sg docker -c 'cd /home/shomsy/projects/polymoly && env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run full'` -> PASS

## Final Decision

- All five findings from the independent strict review are closed in this scope.
- Open `high` findings in scope: `0`
- Open `critical` findings in scope: `0`
- The original review basis is now materially stronger on product-local execution, fail-closed trust, release secret hygiene, zero-trust artifact completeness, and ownership honesty.

## Verification Bundle

- `git diff --check` -> PASS
- `go test ./system/tools/poly/internal/cli ./system/tools/poly/internal/installops -run 'TestRunVersionDoesNotRequireRepoRoot|TestResolveProjectLocalSourceRoot|TestInstallProjectBinarySupportsSelfCopyWithoutCorruption'` -> PASS
- `go test ./system/shared/config ./system/shared/utils -run 'TestVerifyDescriptorMetadata|TestPreparePromotedSecrets|TestGenerateInternalJWT'` -> PASS
- `go test ./product/... ./system/tools/poly/... ./system/shared/...` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go build -o /tmp/poly-review-bin ./system/tools/poly/cmd/poly` -> PASS
- repo-independent CLI probes (`help`, `version`, `install`, installed `help`) -> PASS
- `sg docker -c 'cd /home/shomsy/projects/polymoly && env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run p0'` -> PASS
- `sg docker -c 'cd /home/shomsy/projects/polymoly && env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run docs'` -> PASS
- `sg docker -c 'cd /home/shomsy/projects/polymoly && env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly gate run full'` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly review pack .` -> PASS

## Pass Notes

- Pass 1: repo-independent CLI and install story were corrected first because the product promise was directly broken.
- Pass 2: supply-chain fallback was tightened to fail closed even when registry access is degraded.
- Pass 3: release proof secret handling and JWT generation were hardened to remove placeholder-success and incomplete verification flows.
- Pass 4: product-layer honesty was improved by wiring real ownership seams and deleting decorative files.
- Pass 5: canonical gates and review pack were rerun; no additional `high` or `critical` findings remained in scope.

Offload note: No offload recommended for this step.
