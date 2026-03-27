# PolyMoly Bug Evidence Archive

Source migration:

- This file is a historical archive migrated from `BUGS.md` on `2026-03-03`.
- It preserves resolved bugs, hotfix trails, and verification notes.
- Active/open bug backlog now lives in `BUGS.md` only.

Evidence intent (decision trail):

- Record bug context and impact.
- Record root cause and considered options.
- Record implemented fix and tradeoffs.
- Record verification evidence and remaining risk.

Last update: 2026-03-06

## Resolved: V3.5 production-ready review bug pack (2026-03-06)

Closed items:

- [x] `BUG-V35-RELEASE-BUNDLE-DIST-GAP-21`
- [x] `BUG-V35-ROLLBACK-WORKFLOW-ANCHOR-22`
- [x] `BUG-V35-RELEASE-HELP-DRIFT-23`
- [x] `BUG-V35-PRODUCTION-READY-DOC-DRIFT-24`
- [x] `BUG-V35-CLI-RELEASE-VERSION-DRIFT-25`

Fix summary:

- release evidence indexing now requires the release distribution bundle, `checksums.txt`, explicit release version anchoring, and the current git SHA before a GO verdict can be emitted,
- release evidence bundles now carry the exact rollback workflow command plus summary/checks artifact anchors instead of only a generic operator note,
- promoted runtime, HA failure demo, and stage-load proof lanes now emit the mandatory top-level `checks.tsv` / `decision.txt` artifacts required by the final release bundle contract,
- release-proof workflow now builds and downloads the distribution bundle before aggregating final release evidence,
- release/distribution/resilience proof artifact writes now use a shared required-write helper for clearer fail-closed evidence behavior,
- the advanced CLI help catalog now matches the full release command surface,
- production-ready status documents now reflect the closed proof state and exact artifact anchors,
- the CLI version string is now aligned to the v3.5 release line.

Verification:

- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go test ./system/tools/poly/internal/checkkit ./system/tools/poly/internal/releaseops ./system/tools/poly/internal/cli` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go test ./system/tools/poly/...` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache ./system/tools/poly/bin/poly gate run full` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache ./system/tools/poly/bin/poly gate run docs` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache ./system/tools/poly/bin/poly review pack .` -> PASS

## Resolved: V3.5 full-system 5x code review bug pack (2026-03-06)

Closed items:

- [x] `BUG-V35-ROOT-SURFACE-BRAINSTORM-DRIFT-20`
- [x] `BUG-V35-RELEASE-EVIDENCE-FAIL-OPEN-17`
- [x] `BUG-V35-ENTERPRISE-NAMESPACE-PARSE-18`
- [x] `BUG-V35-DASHBOARD-FAILURE-VISIBILITY-19`

Fix summary:

- root-surface enforcement and the normative contract now explicitly allow `BRAINSTORMING_REVIEW.md`, matching the actual backlog source policy and tracked repository surface,
- release evidence lane verdicts now fail closed unless mandatory `summary.txt`, `checks.tsv`, and `decision.txt` artifacts exist and are non-empty,
- enterprise cluster target summaries now parse `spec.destination.namespace` instead of accidentally reporting the Argo CD control-plane namespace,
- dashboard doctor cards now prioritize failing and non-pass checks so the visible summary does not hide the actual cause of a failed gate.

Verification:

- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go test ./system/tools/poly/internal/releaseops ./system/tools/poly/internal/enterpriseops ./system/tools/poly/internal/dashboardops` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go test ./system/tools/poly/...` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache ./system/tools/poly/bin/poly gate run full` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache ./system/tools/poly/bin/poly gate run docs` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache ./system/tools/poly/bin/poly review pack .` -> PASS

## Resolved: V3.5 post-closure code review bug pack (2026-03-06)

Closed items:

- [x] `BUG-V35-INSTALL-DIGEST-VERIFY-12`
- [x] `BUG-V35-DIST-CHANNEL-CHECKSUM-13`
- [x] `BUG-V35-TEMPLATE-MINCLI-BYPASS-14`
- [x] `BUG-V35-RECENT-HISTORY-TRIM-15`
- [x] `BUG-V35-RELEASE-DISTRIBUTION-GHCR-PERM-16`

Fix summary:

- project-local install now verifies the copied target binary digest before writing success metadata,
- distribution channel generation now fails closed when required checksums are missing and the install script supports both `sha256sum` and `shasum -a 256` for macOS compatibility,
- template-driven flows now enforce `min_cli` compatibility across `template install` and existing `--from template` entrypoints,
- dashboard snapshot and enterprise audit surfaces now keep the most recent history entries instead of silently trimming to the oldest events,
- release distribution workflow now declares `packages: read` so the canonical GHCR-backed gate/runtime path has the required permissions.

Verification:

- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go test ./system/tools/poly/internal/installops ./system/tools/poly/internal/releaseops` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go test ./system/tools/poly/internal/cli ./system/tools/poly/internal/projectcfg` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go test ./system/tools/poly/internal/dashboardops ./system/tools/poly/internal/enterpriseops ./system/tools/poly/internal/aiops` -> PASS
- `env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go test ./system/tools/poly/...` -> PASS
- `./system/tools/poly/bin/poly gate run p0` -> PASS
- `./system/tools/poly/bin/poly gate run docs` -> PASS
- `./system/tools/poly/bin/poly review pack .` -> PASS

## Resolved: V3.5 mutation-safety and traceability bug pack closure (2026-03-06)

Closed items:

- [x] `BUG-V35-TEMPLATE-OVERRIDE-07`
- [x] `BUG-V35-DATABASE-FLAG-CONFLICT-08`
- [x] `BUG-V35-STALE-PLAN-APPLY-GUARD-09`
- [x] `BUG-V35-REPLACE-SEMANTICS-10`
- [x] `BUG-V35-TRACEABILITY-GAPS-11`

Fix summary:

- verified that template imports now preserve template truth unless a flag was explicitly provided (`applyTemplateOverridePolicy`),
- verified that conflicting database flags fail closed instead of silently re-creating a database service,
- verified that pending plan baseline drift now blocks apply by default and only allows stale apply through explicit unsafe contract,
- verified that scaffold replacement semantics now require explicit `--replace`, while `.polymoly/` is preserved and `--force` no longer implies destructive cleanup,
- closed active traceability gaps by mapping the missing V3 idea lineage entry and removing stale active TODO references from source backlog docs.

Verification:

- `go test ./system/tools/poly/internal/cli ./system/tools/poly/internal/projectcfg` -> PASS
- `./system/tools/poly/bin/poly gate run docs` -> PASS
- `./system/tools/poly/bin/poly review pack .` -> PASS

## Resolved: V3 plugin/runtime bug pack closure (2026-03-06)

Closed items:

- [x] `BUG-V3-PLUGIN-TRUST-PATH-BYPASS-01`
- [x] `BUG-V3-DEMO-RUNTIME-TARGET-MISMATCH-02`
- [x] `BUG-V3-PLUGIN-BRIDGE-FAIL-OPEN-LOCK-ERROR-03`
- [x] `BUG-V3-PLUGIN-INSTALL-UNKNOWN-REGISTRY-UX-04`
- [x] `BUG-V3-PLUGIN-UPDATE-OVERRIDE-PRESERVATION-05`
- [x] `BUG-V3-RUNTIME-DIFF-STRICT-EXITCODE-06`

Fix summary:

- plugin trust verification now resolves PATH executables through `exec.LookPath` and fails closed when digest verification cannot resolve a binary.
- managed plugin bridge no longer falls back to unmanaged PATH execution when plugin lock loading/parsing fails.
- `poly plugin install` now fails clearly for unknown registry plugins unless explicit local install semantics are used.
- `poly plugin update` now requires explicit override strategy when local override fields are present and supports `--preserve-overrides` or `--reset-overrides`.
- `poly demo` no longer starts repository-root runtime implicitly; it now prints a deterministic project runtime target and falls back to scaffold showcase mode when project-local runtime contract is absent.
- `poly diff --runtime --strict` now returns non-zero on runtime drift while the default informational mode remains backward compatible.

Verification:

- `go test ./system/tools/poly/internal/pluginops ./system/tools/poly/internal/cli` -> PASS
- `go test ./system/tools/poly/...` -> PASS
- `./system/tools/poly/bin/poly gate run p0` -> PASS
- `./system/tools/poly/bin/poly gate run docs` -> PASS
- `./system/tools/poly/bin/poly review pack .` -> PASS

## Resolved: Brainstorm doc structure drift closure (2026-03-06)

Closed item:

- [x] `BUG-BRAINSTORM-DOC-STRUCTURE-DRIFT-01`
  - Symptom:
    - brainstorming material mixed findings, execution backlog, and idea pool content in a single stream, reducing signal.
  - Fix:
    - completed Track A split and routing:
      - `system/docs/development/findings/v2-audit-findings.md`
      - `system/docs/development/product/v2-execution-backlog.md`
      - `system/docs/development/product/v3-idea-pool.md`
    - updated triage/doc-split references and marked Track A complete in `TODO.md`.

Verification:

- `./system/tools/poly/bin/poly gate run docs` -> PASS
- `./system/tools/poly/bin/poly review pack .` -> PASS

## Resolved: Contract-integrity bug pack closure (2026-03-04)

Closed items:

- [x] `BUG-EVIDENCE-HARD-FAIL-01`
- [x] `BUG-COMMAND-TIMEOUT-POLICY-01`
- [x] `BUG-DOC-ENGINE-PINNED-RUNTIME-01`
- [x] `BUG-ORCHESTRATION-TEST-COVERAGE-01`
- [x] `BUG-SUPPLY-DIGEST-PINNING-01`
- [x] `BUG-SUPPLY-SIGNATURE-PROOF-01`
- [x] `BUG-GHCR-DISTRIBUTION-RELIABILITY-01`
- [x] `BUG-EXTERNAL-CONTRACT-MISMATCH-BLOCKER-01`
- [x] `BUG-CORE-DIFF-DETERMINISM-01`
- [x] `BUG-CORE-PARSER-NUMERIC-COMPAT-01`
- [x] `BUG-GOVERNANCE-REFERENCE-COVERAGE-01`
- [x] `BUG-DOC-SCOPE-DRIFT-NO-DIFF-GUARD-01`
- [x] `BUG-CANONICAL-GATE-ENTRYPOINT-DRIFT-01`
- [x] `BUG-REVIEW-PACK-COMMAND-DRIFT-01`

Fix summary:

- Evidence writes in release/argocd paths now fail closed.
- Shared exec layer now enforces timeouts with override support.
- Doc-engine runtime policy is deterministic (pinned default, explicit non-canonical fallback markers).
- Core diff/parser behavior is deterministic and regression-tested.
- Governance link coverage and docs scope drift enforcement are now gate-enforced.
- External module contracts enforce host major compatibility and required capability blockers.
- Canonical shell wrappers required by AGENTS contract are restored.

Verification:

- `cd core && go test ./...` -> PASS
- `cd tools/poly && go test ./...` -> PASS
- `bash system/gates/run p0` -> PASS
- `bash system/gates/run docs` -> PASS
- `bash system/gates/run full` -> PASS

## Resolved: GitOps default-branch drift in ArgoCD repo lock (2026-03-04)

Closed items:

- [x] `poly argocd repo-lock` defaulted `targetRevision` to `main` even when the real repository default branch was `master`.
  - Root cause:
    - `system/tools/poly/internal/policy/gitops.go` hard-coded `main` when no revision flag was provided.
  - Fix:
    - added origin HEAD branch resolution via `git symbolic-ref refs/remotes/origin/HEAD`
    - fallback path uses the current checked-out branch when origin HEAD cannot be resolved
    - `poly argocd repo-lock` and `poly argocd bootstrap` now default to the real origin branch instead of an assumed one.

Verification:

- `git symbolic-ref refs/remotes/origin/HEAD` -> PASS (`refs/remotes/origin/master`)
- `go test ./system/tools/poly/...` -> PASS
- `bash system/tools/poly/poly.sh argocd repo-lock` -> PASS (`revision: master`)

## Resolved: `poly start` contract drift inflated local bootstrap scope (2026-03-04)

Closed items:

- [x] `poly start` claimed to bootstrap "certs + infra + configurator" but actually delegated to a much wider local compose surface.
  - Root cause:
    - Go runtime command reused the generic local `up` path instead of a dedicated bootstrap service set.
  - Fix:
    - introduced a Go-owned minimal bootstrap compose contract
    - switched `poly start` to that explicit contract
    - covered the contract with Go tests

Verification:

- `go test ./system/tools/poly/...` -> PASS
- `bash system/tools/poly/poly.sh start --dry-run` -> PASS
- `sg docker -c 'cd /home/sho/polymoly && task start'` -> PASS

## Resolved: P0 contract drift across healthchecks, starter lint, and OPA policy (2026-03-04)

Closed items:

- [x] Local bootstrap produced false-negative health for Mailpit, Configurator, and Grafana.
- [x] Starter lint gates failed on stale PHP/Node/Go starter contracts.
- [x] OPA resource-limit policy rejected valid `deploy.resources.limits` compose output.

Fix:

- hardened healthchecks and first-run timing in `deployment/compose/compose.yaml`
- repaired PHP, Node, and Go starter lint contracts
- updated OPA policy helpers to accept the current compose resource shape
- added missing worker CPU limits in compose

Verification:

- `sg docker -c 'cd /home/sho/polymoly && make lint.node'` -> PASS
- `sg docker -c 'cd /home/sho/polymoly && make lint.go'` -> PASS
- manual conftest over rendered production compose -> PASS
- `sg docker -c 'docker ps --format "table {{.Names}}\\t{{.Status}}" | egrep "poly-moly-local-(mailpit|configurator|grafana)-1"'` -> PASS

## Resolved: Go CLI truthfulness and stale wrapper drift (2026-03-04)

Closed items:

- [x] `poly doctor` could emit a failing JSON report while still printing terminal `PASS` and returning exit `0`.
  - Root cause:
    - report state was copied into `WriteReport`, so required-failure counts mutated only the serialized artifact, not the in-memory report used by the CLI exit path.
    - `poly doctor --json` returned early with `0` after printing JSON, ignoring `report.Gate`.
  - Fix:
    - `WriteReport` now mutates the shared report by pointer.
    - `poly doctor --json` now returns non-zero when the gate is not `PASS`.
- [x] `system/tools/poly/poly.sh` could silently execute a stale built binary and hide the current Go CLI surface.
  - Root cause:
    - wrapper preferred `system/tools/poly/bin/poly` whenever it existed, even if source had advanced.
  - Fix:
    - wrapper now prefers live Go source when Go is available.
    - built binary is now an explicit compatibility path (`POLY_USE_BIN=1`) or fallback when Go is unavailable.

Verification:

- `go test ./system/tools/poly/...` -> PASS
- `bash system/tools/poly/poly.sh doctor; echo EXIT:$?` -> FAIL correctly with `EXIT:1` when Docker daemon access is unavailable
- `task doctor -- --json; echo EXIT:$?` -> FAIL correctly with non-zero task exit
- `POLY_USE_BIN=1 bash system/tools/poly/poly.sh --version` -> PASS

## Resolved: MinIO image tag drift blocked local bootstrap (2026-03-04)

Closed items:

- [x] Local runtime bootstrap failed immediately because the pinned MinIO image tag no longer existed on Docker Hub.
  - Root cause:
    - `deployment/compose/compose.yaml` referenced `minio/minio:RELEASE.2024-03-03T20-21-48Z`, which is no longer published.
  - Fix:
    - updated MinIO to a valid pinned release:
      - `minio/minio:RELEASE.2024-12-18T13-15-44Z`

Verification:

- Docker Hub tag lookup via API -> PASS (tag exists)
- `sg docker -c 'docker pull minio/minio:RELEASE.2024-12-18T13-15-44Z'` -> PASS
- `sg docker -c 'cd /home/sho/polymoly && docker compose --project-directory . -f deployment/compose/compose.yaml -f deployment/compose/compose.local.yaml --env-file environments/shared/.env --env-file environments/local/.env config'` -> PASS
- `sg docker -c 'cd /home/sho/polymoly && task start'` -> advanced past the previous MinIO manifest failure and entered normal image-pull bootstrap

## Resolved: Local bootstrap healthcheck timing regression (2026-03-04)

Closed items:

- [x] `task start` could fail on first bootstrap even when services were healthy-by-design, because database initialization exceeded the shared compose healthcheck `start_period`.
  - Root cause:
    - `postgres` and especially `mysql` inherited `start_period: 30s` from the shared health defaults.
    - first-run init took longer than that, so dependents (`pgbouncer`, `proxysql`, exporters) observed unhealthy dependencies and `task start` failed early.
  - Fix:
    - set `postgres` service healthcheck `start_period: 90s`
    - set `mysql` service healthcheck `start_period: 180s`
- [x] Helm chart existence was not equivalent to raw manifest parity.
  - Root cause:
    - chart rendered a richer workload set than the raw `deployment/kubernetes/manifests/**` baseline, with different resource names and missing raw parity elements such as namespaces and the postgres PVC.
  - Fix:
    - added parity-mode values file and updated chart templates to support explicit names/namespaces, namespace creation, PVC parity, and php env/code mounts
    - added `system/gates/architecture/check-helm-template-proof.py` as a machine parity proof

Verification:

- `python3 system/gates/architecture/check-helm-template-proof.py` -> PASS
- `sg docker -c "cd /home/sho/polymoly && task start"` -> PASS

## Resolved: Docs gate parser drift (2026-03-04)

Closed items:

- [x] `check-doc-governance.sh` fixture assertion now matches TSV rule codes correctly.
  - Root cause:
    - fixture verification used `grep "\tCODE\t"` which does not treat `\t` as a real tab in this path.
    - invalid fixtures failed correctly, but the harness reported false negatives.
  - Fix:
    - replaced code detection with `awk -F '\t' '$3 == expected_code'`.
- [x] `check-markdown-links.sh` no longer parses whole lines as single links.
  - Root cause:
    - link extraction scanned entire lines, then split on the first `:`.
    - `https://...` URLs and bold-wrapped links were misparsed as broken local paths.
  - Fix:
    - switched extraction to `grep -nEo '!?\\[[^][]+\\]\\([^)]+\\)'`.
    - validation now runs on individual markdown link tokens.

Verification:

- `bash system/gates/run docs` -> PASS
- `bash system/tools/poly/poly.sh gate check governance-references` -> PASS
- `bash system/tools/poly/poly.sh gate check ci-profile-contract` -> PASS
- `bash system/tools/poly/poly.sh gate check ci-runner-entrypoint` -> PASS

## Resolved: Bug closure pack (2026-03-03, runner and CI drift)

Closed items:

- [x] Security suite scan coverage restored through canonical profile flow.
  - `security-suite.yml` now runs `bash system/gates/run nightly`.
  - `nightly` profile explicitly includes `security.scan-all`.
- [x] Governance CI-profile contract drift closed.
  - Added machine check: `system/gates/system/docs/check-ci-profile-contract.py`.
  - Added machine check: `system/gates/system/docs/check-ci-runner-entrypoint.py`.
- [x] `make start` endpoint message aligned with host-based routing contract.
  - `Makefile` now prints `https://config.${APP_DOMAIN}` and `make hosts.up` fallback.
  - `README.md` quick-start section aligned.
- [x] `.gitignore` stale taxonomy paths removed.
  - `starters/**` -> `lanes/starters/**`
  - `ui/configurator/**` -> `configurator/**`
- [x] P0 `rg` dependency claim invalidated.
  - Hardening lane validated with intentionally broken `rg` binary in `PATH`.
  - `system/gates/doctor.py` no longer lists `rg` as optional doctor signal.

Verification:

- `bash system/gates/system/docs/check-ci-profile-contract.sh` -> PASS
- `bash system/gates/system/docs/check-ci-runner-entrypoint.sh` -> PASS
- `bash system/gates/run docs --dry-run` -> PASS
- `bash system/gates/configurator/check-schema-platform-sync.sh` -> PASS
- `tmp_dir=$(mktemp -d); printf '#!/usr/bin/env bash\necho rg-missing >&2\nexit 127\n' > "$tmp_dir/rg"; chmod +x "$tmp_dir/rg"; PATH="$tmp_dir:$PATH" bash system/gates/hardening/check-hardening.sh` -> PASS

## Resolved: BUG lane closure pack (2026-03-03)

Closed items:

- [x] Image hardening gate path drift and non-root mismatch fixed.
  - Migrated to typed verifier (`core/verifier/image_hardening.py`).
  - Canonical paths aligned to current repo (`lanes/*/engine` + `lanes/php/fpm`).
  - Numeric non-root users are accepted.
- [x] Core engine tests now enforced in p0.
  - Added `python3 -m unittest core.tests.test_engine_flow` to `P0_BASE_STEPS` in `system/gates/runner.py`.
- [x] Policy gate portability no longer depends on `rg`.
  - OPA and threat-model gates now use Python verifiers:
    - `core/verifier/opa_policy.py`
    - `core/verifier/threat_model.py`
- [x] Nightly/security duplication removed.
  - `security-suite.yml` now runs `bash system/gates/run full` instead of duplicating nightly profile.
- [x] Governance reference drift is merge-path enforced.
  - `docs.governance-integrity` step is present in `p0`.
- [x] Evidence contract is machine-enforced.
  - Added `system/gates/policy/check-evidence-contract.py` and wired into `p0`.
- [x] Cross-layer architecture enforcement upgraded.
  - `system/gates/architecture/check-import-boundaries.py` now enforces forbidden import directions across `platform/core/features`.

Verification:

- `bash system/gates/architecture/check-import-boundaries.sh` -> PASS
- `bash system/gates/system/docs/check-governance-references.sh` -> PASS
- `bash system/gates/hardening/check-image-hardening.sh` -> PASS
- `bash system/gates/policy/check-opa-policy.sh` -> PASS
- `bash system/gates/policy/check-threat-model.sh` -> PASS
- `python3 -m unittest core.tests.test_engine_flow` -> PASS

## Resolved: Database Intent Support Expansion (2026-03-03)

- Issue:
  - Configurator exposed `DATABASE_TYPE=mysql`, but resolver registry allowed only `postgres`.
  - Canonical DSL exported from UI could fail at `plan`.
- Resolution:
  - Extended `features/database/capability.yaml` `type` enum to `postgres|mysql|mongodb`.
  - Added providers and module assets:
    - `state/mysql` (`features/database/providers/mysql/module.yaml`, `base.yaml`)
    - `state/mongodb` (`features/database/providers/mongodb/module.yaml`, `base.yaml`)
  - Updated guided UI database options to include `MongoDB`.
  - Added engine test coverage for MySQL and MongoDB provider selection.
- Evidence:
  - `bash system/gates/engine/check-platform-registry.sh` -> PASS
  - `python3 -m unittest core.tests.test_engine_flow` -> PASS
- Risk note:
  - Runtime compose overlays for native MySQL/Mongo deployment are not yet wired into deployment manifests; this fix covers canonical resolver/provider support.

## Historical Path Notice (Audit Safety)

- Historical evidence entries before the job-oriented migration may still mention legacy `tools/**` paths.
- Canonical active paths are:
  - `system/gates/**` for verification commands,
  - `ops-tools/**` for runtime operation commands,
  - `configurator/**` for configurator surfaces.
- Legacy command strings are retained only as immutable historical evidence.

## Scope (Mandatory)

This file is the **single source of truth for bug/risk/regression findings from review and audit work**.

Rules:

- This file is a bug backlog (not a feature roadmap).
- Every review finding must be tracked here with clear acceptance criteria.
- When a task is done, switch `[ ]` to `[x]` immediately.
- Feature/expansion work goes to `TODO.md`, not `BUGS.md`.

This is the full bug/hardening backlog required for a 10/10 release quality target.

---

## P0 — Must-Have Before Official Launch (Release Blocking)

### 1) Lock all internet-facing admin/UI surfaces

**Goal:** no administrative surface can be publicly reachable without extra protection.

**ToDo:**

- [x] Apply Traefik `dashboard-auth / mTLS / IP allowlist` middleware to RabbitMQ, MinIO Console, Mailpit, Adminer, Grafana, Prometheus, Jaeger, SonarQube, Vault, and Keycloak admin UI.
- [x] Keep public routers only for app traffic (php/node/go) and auth endpoints where needed, with rate-limit/headers.

**Done:** all admin hosts require auth and/or VPN/IP restrictions; no open internet console remains.

### 2) Vault production-correct addresses + explicit config loading

**Goal:** no redirect surprises and no implicit start without config.

- [x] `api_addr` set to real external `https://vault.<domain>` (not `0.0.0.0`) using `VAULT_API_ADDR`.
- [x] Start Vault with explicit `-config=/vault/config/vault.hcl`.
- [x] Document init/unseal and recovery procedure (key shares + storage).

**Done:** clean init/unseal flow, clients work without manual overrides, runbook is documented.

### 3) Production overlay with no bind mounts

**Goal:** production cannot start with local source bind mounts by accident.

- [x] In `deployment/compose/compose.prod.yaml`, explicitly override app `volumes` to `[]` or use image-only flow.
- [x] Keep dev-only mounts only in `deployment/compose/compose.local.yaml`.

**Done:** production start path cannot mount host app source code.

### 4) Close Docker socket risk

**Goal:** remove raw `/var/run/docker.sock` exposure from regular services.

- [x] Add `docker-socket-proxy` and route Traefik/Promtail/CrowdSec/Watchtower through proxy with least privileges.
- [x] Remove direct raw socket mounts where not strictly required.

**Done:** no service keeps direct raw docker socket access except the proxy.

### 5) Real resource limits (no false sense of safety)

**Goal:** limits must be actually enforced in Compose mode.

- [x] Use `mem_limit`, `cpus`, `pids_limit`, `ulimits` where applicable.
- [x] Keep `deploy.resources` only as reference for Swarm/K8s paths; enforce Compose-native fields.

**Done:** configuration supports expected OOM/CPU throttling behavior.
**Status:** canonical proof workflow exists (`promoted-runtime-proof.yml`) and the first green Docker-backed execution completed on `2026-03-01`.

---

## P1 — Next Layer (Stability, Security, Operability)

### 6) End-to-end timeouts and backpressure

**Goal:** avoid slow-death behavior under load.

- [x] Traefik server/forwarding timeouts, max connections, buffering.
- [x] App-level DB/Redis/HTTP client timeouts with selective retries.
- [x] Queue prefetch/ack strategy and dead-letter queues.

**Done:** target behavior is stable under load by design.
**Status:** weekly resilience workflow now includes stage k6 gateway smoke; first green staged execution is still required.

### 7) Circuit breaker validation + fallback strategies

**Goal:** prevent circuit breaker from becoming self-DDoS.

- [x] Test 30% error ratio -> breaker trip -> recovery behavior.
- [x] Define fallback strategies (cached response, try-later, degrade mode).

**Done:** incident behavior is controlled without flapping.
**Status:** `make cb-test` still provides phased validation; weekly resilience proof now covers the recurring runtime path, and dedicated breaker execution remains pending.

### 8) Complete container hardening

**Goal:** all runtime services are non-root, read-only where possible, and minimal capability.

- [x] Explicit `user:` for Node/Go services.
- [x] `cap_drop: [ALL]` with minimal explicit additions only.
- [x] Seccomp/AppArmor baseline with documentation.

**Done:** compose baseline includes seccomp/AppArmor + least privilege defaults.
**Status:** runtime `docker inspect` proof is wired into `promoted-runtime-proof.yml` and completed green on `2026-03-01`.

### 9) Backup + restore drill (not backup-only)

**Goal:** backup without restore proof is invalid.

- [x] Automated restore test (PostgreSQL + MySQL) at least weekly in staging.
- [x] PITR procedure documented and tested path defined.
- [x] MinIO lifecycle/encryption policy support.

**Done:** restore drill pipeline and scripts are implemented.
**Status:** restore-to-serving workflow now exists (`backup-restore-serving-proof.yml`); first green Docker-backed execution remains pending.

### 10) Supply chain discipline: pinned, scanning, SBOM

**Goal:** dependency control and reproducible image provenance.

- [x] Pin image/tool tags (no `latest` where avoidable).
- [x] Trivy/Grype CI gates with fail-on-critical policy.
- [x] SBOM generation (Syft) and optional cosign signing flow.

**Done:** reproducibility and security gate flow implemented.

### 16) Review closure: runtime path must match hardening claims

**Goal:** shipped runtime, CI build path, and hardening gates must prove the same thing.

- [x] Remove mutable `:latest` from hardened Dockerfile paths and extend enforcement to Dockerfiles, not only compose images.
- [x] Wire hardened PHP/Node/Go Dockerfiles into stage/prod overlays and CI factory build evidence.
- [x] Extend hardened promoted-runtime coverage to Python (`python-ai` + `internal-authz`) in stage/prod overlays, CI factory, and hardening gates.
- [x] Isolate `docker-socket-proxy` onto a dedicated internal `docker_api_net` with explicit consumers only.
- [x] Disable unused Swarm API verbs on `docker-socket-proxy` and keep the proxy read-only.
- [x] Keep stage from inheriting local app source bind mounts for PHP/Node/Go services and workers.
- [x] Align prod explicit `user:` overrides with the actual users baked into hardened Node/Go images.
- [x] Replace promoted Node/Go shell-based healthchecks with image-native exec-form checks that do not assume `/bin/sh` or `wget`.
- [x] Keep runnable app source inside promoted PHP/Node/Go images by using a canonical repo-root build context and service-specific Dockerfile copy paths.
- [x] Make `db-backup` share an internal network with MinIO so the backup upload path resolves at runtime.
- [x] Fail hardened PHP builds closed when Composer dependency install fails.

**Done:** hardening policy now aligns with the runtime and CI paths that are actually built and promoted.

### 17) Configurator product contract drift

**Goal:** the configurator must generate only real PolyMoly settings, round-trip exactly, and emit operator commands that match the shipped local/stage/prod/managed paths.

- [x] Replace heuristic env generation with a schema-driven PolyMoly bundle model.
- [x] Make import/export exact through canonical `configurator-state.json` and deterministic env parsing.
- [x] Remove dead or non-wired knobs from the active UI surface.
- [x] Align generated commands with `make ...` flows, promoted Docker secrets, and managed-db mode.
- [x] Add a dedicated configurator validation gate that proves round-trip, runtime mapping, and build correctness.

**Done:** the configurator now behaves like a PolyMoly-specific setup product instead of a generic demo form.

### 18) Configurator governance + design-system drift

**Goal:** the normative Configurator contract must describe the real Vue/FSD architecture, and MILOS-V1 must own generic layout primitives instead of dead or duplicate custom layout rules.

- [x] Update `AGENTS.md` sections 6 and 7 so they describe the real Configurator shell (`index.html` + `app.js`) and the canonical `src/app`, `src/pages`, `src/widgets`, `src/features`, `src/entities`, `src/shared` flow.
- [x] Replace fake/non-canonical `milos-stack-gap-*` usage and obvious duplicate custom layout grids with real MILOS-V1 primitives (`l-stack`, `l-cluster`, `l-grid`, `l-gap-*`) where the mapping is direct.
- [x] Test the review claim that failed bundle import leaves the Configurator in a false-success state, and only change import behavior if the claim is reproducible.

**Done:** governance now matches the shipped Configurator architecture, layout primitives use real MILOS-V1 classes where appropriate, and failed-import behavior is proven deterministic rather than silently successful.

### 19) Configurator secret generation and gate portability hardening

**Goal:** the configurator must never emit predictable fallback secrets, and the lane gate must still run when `rg` is missing from the host.

- [x] Replace deterministic secret fallback with a fail-closed placeholder path that keeps the UI usable and lets doctor/export block unsafe output.
- [x] Remove the `rg` dependency from `system/gates/configurator/check-configurator.sh` so Windows/WSL proof paths can prepare their runtime manifest with standard shell tools.
- [x] Move direct-mapping configurator shell/form layout structure back onto MILOS-V1 primitives where the mapping is exact, while keeping only the custom sidebar width skin in local CSS.

**Done:** secret generation is now CSPRNG-only, missing-entropy paths fail closed instead of generating guessable values, the configurator gate no longer requires `rg`, and the obvious MILOS layout drift is reduced.

### 20) [HIGH] Profile power gate must verify resolver impact (not profile YAML only)

**Goal:** profile strength must be proven from resolved output, not only from static posture declarations.

- [x] Make `system/gates/engine/run-profile-power-check.py` evaluate transition impact from resolver output (`resolvedModel`/`resolutionSnapshot`/render-relevant fields), not only from `platform/profiles/*.yaml`.
- [x] Keep strict transition threshold (`>=4` raised domains) tied to execution artifacts.
- [x] Fail if profile posture claims become stronger while resolved/runtime output remains unchanged for guarded domains.
- [x] Add regression tests proving the gate fails when posture rank changes but resolver impact does not.

**Done:** profile-power now evaluates both claim posture and resolved/runtime posture (`compatibilityEnv` posture keys) and fails on claim-without-resolved drift; transition threshold remains `>=4` on resolved impact, and dedicated regression tests run via `system/gates/engine/tests/test_profile_power.py`.

### 21) [HIGH] Compose renderer must preserve per-service network isolation

**Goal:** renderer must not attach every service to every network.

- [x] Replace global network fan-out in `core/renderers/compose.py` with per-service network mapping from `renderModel`.
- [x] Keep deterministic ordering of network output.
- [x] Add tests with at least two networks and mixed service membership to prevent regression.
- [x] Ensure the gate fails if a service receives undeclared network attachments.

**Done:** compose renderer now uses per-service network declarations, validates undeclared network references, enforces explicit per-service mapping when multiple networks exist, and keeps deterministic ordering; regression coverage was added in `core/tests/test_engine_flow.py`.

### 22) [MEDIUM] Parser DSL input-shape check must use explicit presence semantics

**Goal:** parser diagnostics must distinguish missing input vs empty object input deterministically.

- [x] Replace truthiness-based XOR (`bool(...)`) check in `core/parser/parse_and_validate.py` with explicit `is None` presence checks.
- [x] Preserve rule: exactly one of `dsl_text` or `dsl_document` must be provided.
- [x] Add tests covering empty-object `dsl_document={}` and empty-string `dsl_text=""` edge cases.
- [x] Ensure diagnostics report semantic missing fields instead of input-shape error when `dsl_document={}` is explicitly supplied.

**Done:** parser now uses explicit presence checks (`is not None`) for input-shape validation while preserving the exactly-one rule, and edge-case tests were added for empty-object and empty-string inputs to prove semantic-field diagnostics.

### 23) [MEDIUM] Managed package intent must be traceable in canonical DSL

**Goal:** managed mode must remain audit-visible in canonical intent output.

- [x] Define and lock one explicit canonical representation for managed mode in DSL output (without creating parallel truth).
- [x] Remove ambiguous mapping where managed package is exported as plain production/prod identity without explicit managed intent marker.
- [x] Add round-trip tests proving managed intent survives UI export/import and appears in canonical DSL review diffs.
- [x] Document migration/compatibility behavior for existing managed exports.

**Done:** managed exports now emit canonical `environment: managed` while keeping `profile: production` + `overrides.runtime.deploymentMode=managed`; round-trip tests assert managed intent in both `dslDocument` and YAML preview, and migration/compatibility behavior is documented in `configurator/README.md`.

---

## P2 — 11/10 Platform Track (HA + K8s + Enterprise Process)

### 11) K8s path: full HA discipline

**Goal:** production-grade cloud-native HA controls.

- [x] Requests/limits + HPA/KEDA policies.
- [x] PodDisruptionBudget, anti-affinity, topology spread.
- [x] NetworkPolicy, RBAC, ExternalSecret/Vault-injector options.
- [x] Canary/blue-green rollout path with automated abort/rollback support.

**Done:** chart-level HA controls are in place.
**Status:** node/zone failure runtime proof still required in staging/prod cluster.

### 12) Production-grade observability

**Goal:** SLI/SLO-driven alerting and detection before user impact.

- [x] SLI set: p95/p99 latency, error rate, saturation.
- [x] Alerts for user-facing burn-rate and infra saturation signals.
- [x] Trace sampling + log correlation headers.

**Done:** SLO and incident signal surfaces are implemented.

### 13) Performance/load test package + capacity plan

**Goal:** decisions by numbers, not intuition.

- [x] k6 scenarios: steady, spike, soak, ramp, failure injection.
- [x] Threshold targets defined.
- [x] Bottleneck analysis workflow defined.

**Done:** capacity test package + summary artifacts + GO/NO-GO runbook are available.

### 14) Runbooks + incident process

**Goal:** operational maturity independent of one person.

- [x] Runbooks for Vault init/unseal, Keycloak restore, DB restore, circuit-breaker incident.
- [x] On-call severity levels, comms templates, postmortem templates.

**Done:** operations can run from documented process.

---

## P1 — Docs Governance Compliance (Closed)

### 15) Align chapter docs with flow governance standard

**Goal:** `system/docs/01-*` to `system/docs/05-*` follow `how-to-document.md` skeleton and quality gate.

- [x] Each chapter includes required sections: `Vocabulary Dictionary`, `Problem and Purpose`, `End User Flow`, `How It Works`, `How It Fails`, `How To Fix`, `Pass Signals and Hard Stops`.
- [x] Chapter files follow `NN-kebab-case` flow naming pattern.
- [x] Encoding glitches removed and markdown fences balanced.
- [x] Executable runbook blocks (`bash`) and measurable pass/hard-stop criteria are present.

**Done:** docs governance strict gate is green.
**Status:** closed; canonical docs entrypoint is `system/docs/flow.md` with visual lane map.

---

## Evidence — Bug/Hardening Verification (Source of Truth)

Latest closure snapshot (`2026-03-03`):

- Iteration evidence (`2026-03-03`, SRE-Review-4.8.0-001 remediation pass):
  - `bash system/gates/hardening/check-hardening.sh` => PASS
  - `bash system/gates/engine/check-compose-renderer.sh` => PASS
  - `bash system/gates/engine/check-profile-power.sh` => PASS
  - `bash system/gates/architecture/check-import-boundaries.sh` => PASS
  - minimal-safe-delta fixes in this closure:
    - removed explicit `USER root` declarations from pooled database image Dockerfiles:
      - `features/database/providers/mysql/pooling/proxysql/scripts/Dockerfile`
      - `features/database/providers/postgres/pooling/pgbouncer/scripts/Dockerfile`
    - added hardening enforcement in `system/gates/hardening/check-hardening.sh` to fail if pooled DB Dockerfiles declare `USER root` and to require explicit non-root runtime UID.
    - added historical-path audit notice to `BUGS.md` and `TODO.md` so legacy pre-migration command strings are explicitly scoped as immutable history while active canonical paths remain `system/gates/**`, `ops-tools/**`, and `configurator/**`.

- Iteration evidence (`2026-03-01`, configurator security + gate portability closure):
  - `bash system/gates/configurator/check-configurator.sh` with a failing `rg` shim prepended to `PATH` => PASS (`12/12`)
  - `bash features/security/check-hardening.sh` => PASS
  - minimal-safe-delta fixes in this closure:
    - `createStrongSecret()` now uses Web Crypto only and returns a doctor-blocking placeholder when secure entropy is unavailable instead of emitting a deterministic alphabet loop
    - configurator Windows stage manifest extraction now uses `sed` instead of `rg`, closing the local gate dependency gap
    - configurator page shell and section-form grids now use MILOS `l-grid` / CQ collapse primitives where the mapping is direct, leaving only sidebar-width skinning in custom CSS
  - verification result:
    - Node unit tests ran through the existing Windows stage fallback and included new coverage for crypto-unavailable secret generation
    - browser E2E smoke passed after the same gate path completed the build successfully

- Iteration evidence (`2026-03-01`, local WSL2 + Docker Desktop runtime proof pass):
  - `docker info` => PASS (Docker Engine 29.2.1 reachable from WSL2 session)
  - `bash tools/release/run-promoted-runtime-proof.sh` => FAIL, but host-side Docker Desktop outage is no longer the active blocker
  - `bash features/security/check-hardening.sh` => PASS after compose/user/Traefik overlay alignment
  - fixed in this pass before rerun:
    - Python promoted image now has explicit `lanes/python/requirements.txt` and no longer depends on missing `lanes/python/config/`
    - `docker-socket-proxy` pin corrected from invalid `tecnativa/docker-socket-proxy:0.2.3` to published Docker Hub tag `tecnativa/docker-socket-proxy:v0.4.2`
    - promoted Node/Go runtime users now use explicit numeric IDs (`65532` / `65532:65532`) instead of image-name aliases not guaranteed in `/etc/passwd`
    - stage/prod promoted app overlays now use Compose-spec `!override []` so final merged config actually drops host source bind mounts
    - stage/prod strict TLS override now replaces existing `/etc/traefik/dynamic/traefik-dynamic.yaml` instead of trying to create a new mountpoint inside Traefik read-only rootfs
  - current remaining blockers captured from `tools/artifacts/promoted-runtime-proof/compose.logs.txt`:
    - `postgres` stays unhealthy because secret-wrapper `command` renders as split argv (`export`, `POSTGRES_PASSWORD=...`) and never reaches `exec docker-entrypoint.sh ...`
    - `node-worker` still renders `command: ["node", "src/worker.js"]` on top of an image that already enters through `node`, producing `/app/node` module resolution failure
    - `go-worker` reaches process start but cannot read `/run/secrets/rabbitmq_password` as numeric non-root user (`permission denied`)
    - `traefik` starts, but logs show independent follow-up issues after startup: plugin download `github.com/maxlerebourg/traefik-bouncer@v0.7.3` returns 404, Docker provider negotiates deprecated API `v1.24`, and `/etc/traefik/certs/app.com.crt` is not valid PEM for certificate loading

- Iteration evidence (`2026-03-01`, release-engineering + runtime-hardening closure on WSL2 + Docker Desktop):
  - `bash features/security/check-hardening.sh` => PASS
  - `bash tools/release/run-promoted-runtime-proof.sh` => PASS
  - proof artifacts written under `tools/artifacts/promoted-runtime-proof/`
  - validated smoke targets:
    - `https://php.app.com/health/query`
    - `https://node.app.com/health/dependencies`
    - `https://go.app.com/health/dependencies`
    - `https://ai.app.com/health`
  - minimal-safe-delta fixes in this closure:
    - Traefik static config now declares the `internal` entrypoint and public app routers pin `traefik.docker.network=${COMPOSE_PROJECT_NAME}_edge_net`, closing the wrong-network health-probe gap
    - promoted proof smoke now succeeds against real TLS SNI and image-evidence/runtime-hardening artifact generation completes end-to-end
    - RabbitMQ promoted bootstrap now generates runtime definitions from Docker secrets, creates `app_user` + vhost/permissions/topology on first boot, and uses a metrics-based healthcheck instead of the broken CLI cookie path
    - PgBouncer now generates auth material with `AUTH_TYPE=scram-sha-256`, and stage/prod overlays export `DB_PASSWORD` from the promoted Postgres Docker secret before PgBouncer startup
  - non-blocking follow-up warnings still present in `tools/artifacts/promoted-runtime-proof/compose.logs.txt` and intentionally left for a later pass:
    - Traefik internal routers (`node-internal`, `go-internal`, `python-ai-internal`) still log `invalid certificate(s) content`
    - CrowdSec plugin still logs `CrowdsecLapiKey doesn't validate this regexp` on the RabbitMQ admin route

- Bug evidence governance normalized: standalone root evidence file retired; active evidence is tracked in this file and `TODO.md`.
- `bash features/security/check-hardening.sh` => PASS
- `bash features/security/check-threat-model.sh` => PASS
- `bash features/security/run-layer-audit.sh` => PASS
- `bash features/security/check-environment-isolation.sh` => PASS
- `bash features/security/check-opa-policy.sh` => PASS
- `bash features/security/check-secrets-rotation.sh` => PASS
- `bash features/security/check-sre-observability.sh` => PASS
- `bash tools/chaos/check-training-program.sh` => PASS
- `docker compose --project-directory . -f deployment/compose/compose.yaml -f deployment/compose/compose.stage.yaml config` => PASS on Docker-enabled runner / canonical CI proof
- `docker compose --project-directory . -f deployment/compose/compose.yaml -f deployment/compose/compose.prod.yaml config` => PASS on Docker-enabled runner / canonical CI proof
- `bash features/security/check-hardening.sh` after runtime-path alignment => PASS
- `bash features/security/check-image-hardening.sh` after immutable Node pin + BuildKit validation extension => PASS
- `bash features/security/run-layer-audit.sh` after compose/Dockerfile mutable-tag enforcement => PASS
- `bash features/security/check-threat-model.sh` after docker_api_net + supply-chain control sync => PASS
- `bash features/security/check-hardening.sh` after promoted-runtime user/healthcheck/build-context/python/db-backup remediation => PASS
- `bash features/security/check-image-hardening.sh` after Python hardened-path coverage + PHP fail-closed build enforcement => PASS (`19/19`)
- `bash features/security/run-layer-audit.sh` after promoted-runtime remediation => PASS (`23/23`)
- `bash features/security/check-threat-model.sh` after promoted-runtime remediation => PASS (`12/12`)
- production-trust proof workflows implemented:
  - `.github/workflows/promoted-runtime-proof.yml`
  - `.github/workflows/backup-restore-serving-proof.yml`
  - `.github/workflows/weekly-resilience-proof.yml`
  - `.github/workflows/release-candidate-proof.yml`
  - `tools/release/run-promoted-runtime-proof.sh`
  - `tools/backup/run-restore-serving-proof.sh`
  - `tools/release/run-stage-load-smoke.sh`
  - `tools/release/generate-release-evidence-index.py`
  - `tools/release/run-circuit-breaker-proof.sh`
- promoted-runtime proof contract hardened against recent review gaps:
  - prod Traefik ACME server is now env-overridable and CI/render workflows pin proof runs to Let's Encrypt staging,
  - RabbitMQ stage/prod now load password from `/run/secrets/rabbitmq_password` through explicit wrapper entrypoint,
  - Python promoted lane now uses image-native exec healthchecks via `lanes/python/healthcheck.py`,
  - stage/prod upstream services with secret-bearing runtime contracts (`postgres`, `mysql`, `minio`, `grafana`, `rabbitmq`, `keycloak`) now use explicit secret wrappers instead of relying on upstream `_FILE` parsing behavior.
- wrapper cleanup pass completed:
  - stage/prod secret-wrapped services no longer export empty placeholder secret env vars before wrapper execution,
  - first local configurator-driven promoted proof exposed missing runtime build inputs (`lanes/starters/go/go.sum`, `postgresql-dev` for PHP promoted images, and `linux-headers` for PHP sockets) and all three were fixed in source,
  - the same local proof is currently blocked from a full green runtime result by a host-side Docker Desktop outage (`com.docker.service` stopped after a BuildKit metadata I/O error), not by a remaining repository contract defect,
  - `bash features/security/check-hardening.sh` => PASS,
  - `bash features/security/check-image-hardening.sh` => PASS (`19/19`),
  - `bash features/security/run-layer-audit.sh` => PASS (`23/23`),
  - `bash features/security/check-threat-model.sh` => PASS (`12/12`),
  - `make docs.governance.strict` => PASS (`175/175` governance + `2248/2248` markdown links).
- local Docker Desktop render proof completed:
  - `docker compose --project-directory . -f deployment/compose/compose.yaml config` => PASS,
  - `docker compose --project-directory . -f deployment/compose/compose.yaml -f deployment/compose/compose.prod.yaml config` => PASS,
  - canonical fix moved runtime PID limits into `deploy.resources.limits.pids` in base compose and removed conflicting prod-only runtime-hardening reapplication,
  - artifact written to `tools/artifacts/promoted-runtime-proof/local-render-proof.txt`.
- local Docker Desktop runtime preflight hardened for WSL actionability:
  - added `tools/release/check-docker-runtime.sh` and wired it into promoted runtime, stage load, and circuit-breaker proof scripts before any compose/build action,
  - `bash tools/release/check-docker-runtime.sh` now emits fix-oriented failure output and writes `tools/artifacts/promoted-runtime-proof/local-docker-preflight.txt`,
  - current host-side blocker is now explicitly classified as:
    - `docker-desktop` distro = `Running`,
    - `com.docker.service` = `Stopped`,
    - `docker info` in `Ubuntu-22.04` = `The command 'docker' could not be found in this WSL 2 distro`,
    - conclusion: proof is blocked by Docker Desktop engine / WSL integration state on the host, not by a remaining repository runtime contract defect.
- `bash features/security/check-hardening.sh` after promoted-runtime proof + Docker secrets minimum migration => PASS
- `bash features/security/check-image-hardening.sh` after promoted-runtime proof + Docker secrets minimum migration => PASS (`19/19`)
- configurator product contract closure implemented:
  - schema-driven PolyMoly model under `configurator/src/configurator/`,
  - import/export round-trip tests under `configurator/tests/*.test.mjs`,
  - lane gate under `system/gates/configurator/check-configurator.sh`,
  - operator-facing `make configurator.gate` target in `Makefile`,
  - previously dead ProxySQL configurator knobs now wire into the real runtime through `infrastructure/proxysql/proxysql.cnf.template` + `entrypoint.sh`,
  - `CROWDSEC_BOUNCER_API_KEY` schema validation now targets the real Traefik middleware contract.
- configurator governance/design-system drift closure implemented:
  - `AGENTS.md` sections 6 and 7 now describe the real Vue/FSD Configurator flow instead of legacy `index.html + app.js` business-logic assumptions,
  - fake `milos-stack-gap-*` classes were removed from shipped templates and replaced by real MILOS-V1 primitives (`l-stack`, `l-cluster`, `l-grid`, `l-gap-*`),
  - duplicate custom layout responsibility was reduced in summary/preset/form/output surfaces while keeping PolyMoly skin classes intact,
  - failed-import behavior is now covered by `configurator/tests/import-bundle.test.mjs` and was confirmed to surface an error, preserve state, and clear the file input deterministically.
- `bash system/gates/configurator/check-configurator.sh` after runtime-contract closure => PASS (`7/7`)
- `bash system/gates/configurator/check-configurator.sh` after governance/design-system drift closure => PASS (`12/12`)
- `bash tools/platform/check-productization.sh` after configurator productization => PASS (`8/8`)
- `bash features/security/check-hardening.sh` after configurator/runtime-contract closure => PASS
- `make docs.governance.strict` after configurator evidence/doc sync => PASS (`250/250`)
- `bash tools/system/docs/check-markdown-links.sh --strict` after configurator evidence/doc sync => PASS (`2273/2273`)
- `bash features/security/run-layer-audit.sh` after promoted-runtime proof + Docker secrets minimum migration => PASS (`23/23`)
- Local `docker compose ... config` rendering remains blocked in this WSL context because the Docker binary is unavailable; YAML parse for compose/workflow files passed, and CI Factory now renders stage/prod compose artifacts as the canonical Docker-backed proof path.
- `make docs.governance` => report mode (development), findings documented and non-blocking
- `make docs.governance` after phase-1 remediation => `140/224` failed checks (improved from `157/224`)
- `make docs.governance` => PASS (`224/224`)
- `make docs.governance.strict` => PASS (`224/224`)
- `bash tools/system/docs/check-markdown-links.sh` => PASS (`136/136`) in strict mode
- `make docs.governance.strict` => PASS (`224/224` governance + `136/136` markdown links)
- Manual docs review + visual upgrade pass:
  - `system/docs/guides/getting-started.md` added as onboarding chapter
  - `system/docs/flow.md` added as canonical entrypoint
  - visual flow maps expanded in governance docs
- `system/docs/development/governance/how-to-document.md` synced as explicit child contract of `AGENTS.md` §5:
  - added mandatory `The Scenario` block directly below each diagram,
  - added mandatory `Lemme Explain` ultra-simple term definitions,
  - added mandatory Problem/Purpose clarity answers (purpose, need, solved problem, skip risk),
  - added AGENTS inheritance/scope boundary declaration.
- `make docs.governance` after AGENTS sync => report mode (development), non-blocking findings remained (`101/266` governance report findings, `32/122` markdown-link report findings)
- `system/docs/development/governance/how-to-document.md` GO/NO-GO section strengthened with mandatory visual panel templates:
  - required `🚦 GATEWAY STATUS PANEL` graphic,
  - required `🚨 INCIDENT PANEL` graphic,
  - checklist now explicitly requires both graphics in chapter section 7.
- `make docs.governance` after mandatory GO/NO-GO panel update => report mode (development), non-blocking findings remained (`101/266` governance report findings, `32/122` markdown-link report findings)
- `system/docs/development/governance/how-to-document.md` diagram character policy clarified:
  - ASCII is mandatory for structural characters/connectors,
  - emoji are optional semantic markers for visual explanation,
  - ASCII fallback labels are required when emoji rendering is limited.
- `make docs.governance` after ASCII/emoji clarity update => report mode (development), non-blocking findings remained (`101/266` governance report findings, `32/122` markdown-link report findings)
- `system/docs/architecture/gateway-and-edge/01-user-entry-and-routing.md` was rebuilt as architecture-first chapter:
  - aligned metadata with governance front matter contract,
  - implemented full mandatory structure (`1..10`) plus `What Did We Learn`,
  - added mandatory `The Scenario` blocks below all diagrams,
  - added mandatory `Lemme Explain`,
  - normalized runbook into read-only vs mutation flow with stop conditions,
  - included mandatory GO/NO-GO panel templates.
- `make docs.governance` after chapter rebuild => target chapter checks all PASS; global report remains non-blocking with reduced findings (`94/266` governance report findings, `32/122` markdown-link report findings)
- Emoji-drawing requirement enforced:
  - `system/docs/development/governance/how-to-document.md` now states emoji/icons are mandatory in diagram labels/legends/status cells,
  - `system/docs/architecture/gateway-and-edge/01-user-entry-and-routing.md` diagrams were updated with emoji node markers (`👤`, `🧭`, `💥`, `🛠️`, `✅`, `🏰`, `🌐`, `⚙️`, `🎨`, `🐳`, `🏷️`, `🧠`, `🔐`, `🚀`).
- `make docs.governance` after emoji-must update => target chapter checks all PASS; global report remains non-blocking (`94/266` governance report findings, `32/122` markdown-link report findings)
- Flowchart style normalized to full rectangle diagrams:
  - `system/docs/development/governance/how-to-document.md` visual map switched to box-drawing rectangle flow style,
  - `system/docs/architecture/gateway-and-edge/01-user-entry-and-routing.md` major diagrams (`Visual Contract Map`, `End User Flow`, `How It Works`) switched to box-drawing rectangle flow style.
- Width/clarity policy refined:
  - if emoji byte width pushes a line over limit, split the diagram into two rows instead of shortening meaning,
  - `how-to-document.md` and the updated chapter now have no lines over 100 columns.
- `make docs.governance` after box-style + width-clarity update => target chapter checks all PASS; global report remains non-blocking (`94/266` governance report findings, `32/122` markdown-link report findings)
- Diagram precision refinement (engineering alignment):
  - `how-to-document.md` now explicitly requires exact rectangle border alignment with no protruding lines,
  - visual map connectors were normalized to clean center joins,
  - `01-user-entry-and-routing.md` flow diagrams were adjusted to the same precise box alignment standard.
- `make docs.governance` after precision-alignment update => target chapter checks all PASS; global report remains non-blocking (`94/266` governance report findings, `32/122` markdown-link report findings)
- Text-first diagram construction enforced:
  - node text is finalized first, then border width is drawn around that text,
  - governance visual contract map and chapter visual maps were rebalanced to this method,
  - connector joins were kept centered after box-width recalculation.
- `make docs.governance` after text-first box recalculation => target chapter checks all PASS; global report remains non-blocking (`94/266` governance report findings, `32/122` markdown-link report findings)
- Global Quick Jump + heading governance remediation completed:
  - all chapter quick jumps converted to clickable markdown links (not code-block placeholders),
  - core section headings normalized (`Quick Jump`, `End User Flow`, `How It Works`, `How It Fails`, `How To Fix`, `What Did We Learn`),
  - `system/docs/flow.md` chapter jump paths replaced with concrete, working links.
- Scenario clarity remediation completed:
  - added explicit `The Scenario` + `Real-World Example` blocks in remaining missing chapters.
- Term-link remediation completed:
  - glossary definitions normalized to per-term reference links (`wikipedia.org/wiki/Special:Search?...`) in docs chapters.
- `make docs.governance` after quick-jump/style/link remediation => PASS (`280/280`)
- `bash tools/system/docs/check-markdown-links.sh` after quick-jump/style/link remediation => PASS (`155/155`)
- Documentation style upgrade: dual-mode explanation contract added (`The Scenario` + `Real-World Example` + `Narrative Walkthrough`) in governance; migration note included for legacy labels.
- `system/docs/architecture/gateway-and-edge/01-user-entry-and-routing.md` normalized to `Narrative Walkthrough` naming and consistent `Lemme Explain` casing.
- `make docs.governance` after dual-mode storytelling contract update => PASS (`280/280`)
- `bash tools/system/docs/check-markdown-links.sh` after dual-mode storytelling contract update => PASS (`157/157`)
- Documentation narrative model refined to canonical 4-layer stack:
  - `The Scenario` (technical deterministic),
  - `Real-World Example` (concrete human context),
  - `📖 Story Example (Named Metaphor)` (story memory layer),
  - `Lemme Explain` (ultra-simple compression).
- `system/docs/development/governance/how-to-document.md` switched canonical label from `Narrative Walkthrough` to `📖 Story Example (Named Metaphor)` with migration note for legacy naming.
- `system/docs/architecture/gateway-and-edge/01-user-entry-and-routing.md` updated so diagram sections include `Story Example` + `Lemme Explain` after technical and real-world layers.
- `make docs.governance` after 4-layer narrative contract update => PASS (`280/280`)
- `bash tools/system/docs/check-markdown-links.sh` after 4-layer narrative contract update => PASS (`155/155`)
- Narrative style contract hardened:
  - `Story Example` and `Lemme Explain` now require bullet-only mini-story lines,
  - one sentence per bullet,
  - technical definitions must appear before simplification layers.
- `system/docs/architecture/gateway-and-edge/01-user-entry-and-routing.md` narrative blocks refined to strict mini-story format (Visual, Vocabulary alignment, Failure, GO/NO-GO).
- `make docs.governance` after bullet-mini-story contract update => PASS (`280/280`)
- `bash tools/system/docs/check-markdown-links.sh` after bullet-mini-story contract update => PASS (`155/155`)
- Lemme Explain operational contract refined:
  - `system/docs/development/governance/how-to-document.md` now explicitly forbids glossary/synonym style (`X is Y`, `X means Y`) inside `Lemme Explain`,
  - `Lemme Explain` is enforced as function/boundary/failure-consequence compression (not dictionary prose).
- `make docs.governance` after Lemme Explain operational-contract refinement => PASS (`280/280`)
- `bash tools/system/docs/check-markdown-links.sh` after Lemme Explain operational-contract refinement => PASS (`155/155`)
- Observability chapter narrative + graphics upgrade completed:
  - `system/docs/guides/troubleshooting/01-metrics-and-logs.md` rebuilt with stronger diagram set and
    technical-first storytelling (`Technical Definition` -> `Story Example` -> `Lemme Explain`),
  - added per-pillar `Failure Mode Story` blocks (Metrics, Logs, Traces, Alerts, RED/USE),
  - added dedicated `Debug Order Discipline` section with flow diagram and action sequence,
  - added dedicated `SLO Burn-Rate Narrative` section with multi-window burn-rate diagram.
- Governance standard formalized as named framework:
  - `system/docs/development/governance/how-to-document.md` now defines
    `8.3 PolyMoly Narrative Standard (Mandatory)`,
  - includes mapping-anchor rule, narrative validation checklist, and
    extended guidance for failure-mode story, debug order, and burn-rate narrative.
- `make docs.governance` after observability + narrative-standard upgrade => PASS (`280/280`)
- `bash tools/system/docs/check-markdown-links.sh` after observability + narrative-standard upgrade => PASS (`162/162`)
- How-to governance refined for dual-world narrative precision (`Version: 2.5.0`):
  - added `5.4 Diagram Term Mapping Rule (Mandatory)` for node-level technical ownership,
  - added `5.5 Chapter-Bound Diagram Rule (Mandatory)` for operational (non-decorative) diagrams,
  - added `8.4 Narrative Term Integrity Rule (Mandatory)` for core/new story term mapping behavior,
  - added `9.4 Intro Contract (Mandatory)` to preserve `This chapter explains...` + `Focus is...` before `Quick Jump`.
- `make docs.governance` after term-mapping + chapter-bound rule update => PASS (`280/280`)
- `bash tools/system/docs/check-markdown-links.sh` after term-mapping + chapter-bound rule update => PASS (`162/162`)
- Dual-layer narrative appendix merged into governance (`Version: 2.6.0`):
  - added `16) Dual-Layer Narrative System (Mandatory)` as end-of-file formal contract,
  - added explicit coverage rules for diagram terms, story mapping, legend requirement,
    technical-definition-first order, term consistency guarantee, and both-worlds principle.
- `make docs.governance` after dual-layer narrative appendix => PASS (`280/280`)
- `bash tools/system/docs/check-markdown-links.sh` after dual-layer narrative appendix => PASS (`162/162`)
- Micro-alignment from audit feedback applied:
  - in `5.3 Diagram Narrative Contract`, wording changed to
    `Do not introduce new technical terms without prior definition or inline mapping.`,
  - clarified scope split: `5.4` is diagram-local enforcement; `16.1` is chapter-global narrative enforcement.
- `make docs.governance` after micro-alignment => PASS (`280/280`)
- `bash tools/system/docs/check-markdown-links.sh` after micro-alignment => PASS (`162/162`)
- Scope-jurisdiction cleanup completed (no parallel definitions):
  - `5.4` rewritten to strict diagram-local scope with explicit scope limitation to Section 16,
  - `16.1` rewritten as global semantic invariant (`Global Term Determinism Rule`),
  - `16.7` converted to `Term Redefinition Protocol` to implement `16.1` without duplication.
- `make docs.governance` after scope-jurisdiction cleanup => PASS (`280/280`)
- `bash tools/system/docs/check-markdown-links.sh` after scope-jurisdiction cleanup => PASS (`162/162`)
- Policy-shadow clarity pass completed (term classification alignment):
  - `5.3` now forbids implicit technical terms and allows new technical terms in story only with prior definition or inline mapping,
  - `8.4` now explicitly defines `Technical term` vs `Narrative term` and keeps behavior-impact mapping mandatory.
- `make docs.governance` after policy-shadow clarity pass => PASS (`280/280`)
- `bash tools/system/docs/check-markdown-links.sh` after policy-shadow clarity pass => PASS (`162/162`)
- `PHASE=production STRICT=1 bash tools/system/docs/check-doc-governance.sh` => SKIP (production-safe by design)
- Docs-only iteration (`system/docs/architecture/gateway-and-edge/02-supply-chain-and-ci-cd.md` rewritten from scratch under current ADU / slow-motion technical walkthrough contract).
- Changed files: `system/docs/architecture/gateway-and-edge/02-supply-chain-and-ci-cd.md`, `BUGS.md`, `tools/artifacts/docs-governance/*`, `tools/artifacts/docs-links/*`.
- `make docs.governance` after chapter-02 rewrite => PASS (`54/54`)
- `make docs.governance.strict` after chapter-02 rewrite => PASS (`54/54`)
- `bash tools/system/docs/check-markdown-links.sh` after chapter-02 rewrite => PASS (`794/794`)
- Docs-only iteration (remaining operational chapters rewritten from scratch under current `how-to-document.md` ADU contract).
- Changed files:
  - `system/docs/architecture/gateway-and-edge/03-container-hardening.md`
  - `system/docs/architecture/state-and-runtime/01-stateless-design.md`
  - `system/docs/architecture/state-and-runtime/02-async-and-queues.md`
  - `system/docs/architecture/backing-services/01-redis-and-caching.md`
  - `system/docs/architecture/backing-services/02-databases-and-scaling.md`
  - `system/docs/guides/troubleshooting/02-incident-runbook.md`
  - `system/docs/guides/troubleshooting/03-backup-restore-and-pitr.md`
  - `system/docs/guides/troubleshooting/04-oncall-and-postmortem.md`
  - `system/docs/architecture/deploy-and-scale/01-orchestration-and-ha.md`
  - `system/docs/architecture/deploy-and-scale/02-helm-and-packaging.md`
  - `system/docs/architecture/deploy-and-scale/03-capacity-lab-go-no-go.md`
  - `BUGS.md`
  - `tools/artifacts/docs-governance/*`
  - `tools/artifacts/docs-links/*`
- `make docs.governance` after full remaining-chapter rewrite => PASS (`175/175`)
- `make docs.governance.strict` after full remaining-chapter rewrite => PASS (`175/175`)
- `bash tools/system/docs/check-markdown-links.sh` after full remaining-chapter rewrite => PASS (`2193/2193`)
- Docs-only iteration (`system/docs/flow.md` rewritten as the canonical book index / table of contents entrypoint).
- Changed files: `system/docs/flow.md`, `BUGS.md`, `tools/artifacts/docs-governance/*`, `tools/artifacts/docs-links/*`.
- `make docs.governance.strict` after `flow.md` index rewrite => PASS (`175/175`)
- `bash tools/system/docs/check-markdown-links.sh` after `flow.md` index rewrite => PASS (`2235/2235`)
- `make docs.governance.strict` after promoted-runtime remediation evidence update => PASS (`175/175`)
- `bash tools/system/docs/check-markdown-links.sh` after promoted-runtime remediation evidence update => PASS (`2248/2248`)
- BUG-20..23 closure evidence (2026-03-03):
  - `bash system/gates/engine/check-profile-power.sh` => PASS (includes `gates.engine.tests.test_profile_power`)
  - `bash system/gates/engine/check-compose-renderer.sh` => PASS (`10` engine tests, renderer proof pass)
  - `bash system/gates/configurator/check-configurator.sh` => PASS (`12/12`)
  - `bash system/gates/hardening/check-hardening.sh` => PASS
  - `find . -type f | rg '^\\./ops/.+compose.py|^\\./ops/.+engine_platform_loader.py|^\\./core/renderers/compose.py$'` => only `./core/renderers/compose.py` remains (single renderer truth)
  - managed DSL canonical mapping now emits `environment: managed` and migration compatibility note is documented in `configurator/README.md`.

Primary bug/hardening artifacts:

- `tools/artifacts/security-layer-audit/`
- `tools/artifacts/security-threat-model/`
- `tools/artifacts/environment-isolation/`
- `tools/artifacts/opa-policy/`
- `tools/artifacts/secrets-rotation/`
- `tools/artifacts/sre-observability/`
- `tools/artifacts/chaos-training/`
- `tools/artifacts/docs-governance/`

Known verification gap:

- Runtime `docker compose up`/failover/load proofs must be confirmed on a Docker-enabled CI runner.

Historical full pass log (archive only):

- `system/docs/development/evidence-archive.md`

## 2026-03-05 — BUG Backlog History Migration (open-only policy cleanup)

Decision context:

- `BUGS.md` contract says active unresolved bugs only, but contained a large closed-history section.
- Team requested a cleaner split: active bug queue in `BUGS.md`, historical proof in evidence archive.

What changed:

- Closed bug history from `BUGS.md` was migrated to evidence/changelog trail.
- `BUGS.md` was prepared for active brainstorm-derived bug/risk backlog only.

Migrated closed BUG IDs:

- `BUG-EVIDENCE-HARD-FAIL-01`
- `BUG-COMMAND-TIMEOUT-POLICY-01`
- `BUG-DOC-ENGINE-PINNED-RUNTIME-01`
- `BUG-ORCHESTRATION-TEST-COVERAGE-01`
- `BUG-SUPPLY-DIGEST-PINNING-01`
- `BUG-SUPPLY-SIGNATURE-PROOF-01`
- `BUG-GHCR-DISTRIBUTION-RELIABILITY-01`
- `BUG-EXTERNAL-CONTRACT-MISMATCH-BLOCKER-01`
- `BUG-CORE-DIFF-DETERMINISM-01`
- `BUG-CORE-PARSER-NUMERIC-COMPAT-01`
- `BUG-GOVERNANCE-REFERENCE-COVERAGE-01`
- `BUG-DOC-SCOPE-DRIFT-NO-DIFF-GUARD-01`
- `BUG-CANONICAL-GATE-ENTRYPOINT-DRIFT-01`
- `BUG-REVIEW-PACK-COMMAND-DRIFT-01`
- `BUG-TIMEOUT-ENFORCEMENT-02`
- `BUG-DOCS-CANONICAL-RUNTIME-LOCK-02`
- `BUG-RELEASE-EVIDENCE-DEFER-INTEGRITY-02`
- `BUG-RUNNER-SUMMARY-WRITE-HARDFAIL-02`
- `BUG-CRITICAL-PATH-TEST-COVERAGE-02`
- `BUG-CORE-DIFF-MARSHAL-FALLBACK-02`
- `BUG-SUPPLYCHAIN-VERIFY-REAL-01`
- `BUG-RELEASE-PROOF-TASK-DEPENDENCY-01`
- `BUG-RELEASE-ASSET-PUBLISH-PIPELINE-01`
- `BUG-CI-COMPOSE-PROOF-FIXTURE-DRIFT-01`
- `BUG-CI-GHCR-AUTH-DENIED-01`
- `BUG-CI-ENV-BASELINE-MISSING-01`
- `BUG-CI-RUNTIME-BUILD-CONTEXT-DRIFT-01`
- `BUG-RESTORE-PROOF-LANE-WIRING-02`
- `BUG-COMPOSE-WAIT-HEALTH-EARLY-PASS-02`
- `BUG-STAGE-LOAD-SMOKE-TLS-SNI-02`
- `BUG-CIRCUIT-BREAKER-LANE-STAGE-CONTRACT-02`
- `BUG-PROMOTED-SECRETS-IDEMPOTENCY-02`

Outcome:

- `BUGS.md` can now stay concise and actionable for active risk intake.
- Archive keeps full closure trail as bug changelog evidence.

## 2026-03-06 — V2 Trust-Core Bug Closure Sweep (10/10)

Closed bug IDs:

- `BUG-V2-TEMPLATE-DEFAULT-OVERRIDE-01`
- `BUG-V2-DATABASE-FLAG-CONFLICT-01`
- `BUG-V2-STALE-PLAN-APPLY-SAFETY-01`
- `BUG-DOC-INTENT-SOURCE-OF-TRUTH-DRIFT-01`
- `BUG-V2-FORCE-SCAFFOLD-NONDETERMINISTIC-01`
- `BUG-V2-SIDECAR-TEST-COVERAGE-GAP-01`
- `BUG-V2-CANONICAL-GATE-ENTRYPOINT-DRIFT-01`
- `BUG-CLI-THIN-CORE-DISCOVERY-DRIFT-01`
- `BUG-PRODUCT-STATUS-MESSAGING-DRIFT-01`
- `BUG-TEMPLATE-MONOTONICITY-GLOBAL-LAW-GAP-01`

Implementation summary:

- Template imports now preserve template defaults unless overrides are explicitly provided by the user.
- Database mutation path now hard-fails on conflicting `--database none` + `--database-mode`, and no longer recreates database service implicitly.
- `poly apply` now blocks stale baseline plans by default and allows override only via explicit unsafe contract (`--allow-stale-plan` + `POLY_ALLOW_STALE_PLAN=1`).
- Scaffold replacement path is deterministic for non-empty targets (`--replace`) and emits removal manifest while preserving `.polymoly/` identity.
- `poly verify` is now explicit compatibility alias for canonical `poly gate run`.
- CLI help now defaults to thin-core command surface and uses progressive reveal via `poly help --all`.
- Canonical intent-source docs were aligned to `.polymoly/config.yaml` with legacy root-file references marked migration-only.
- Product status messaging now distinguishes v2 baseline completion from production-readiness hardening proofs.
- Imported templates now run explicit profile-law validation (`ValidateTemplateImportLaw`) before use.
- Mutation and plan safety regression tests were added in CLI and projectcfg packages.

Verification evidence:

- `go test ./system/tools/poly/...` => PASS
- `./system/tools/poly/bin/poly gate run p0` => PASS
- `./system/tools/poly/bin/poly gate run docs` => PASS

Primary changed implementation paths:

- `system/tools/poly/internal/cli/product.go`
- `system/tools/poly/internal/cli/run.go`
- `system/tools/poly/internal/cli/runtime.go`
- `system/tools/poly/internal/cli/product_test.go`
- `system/tools/poly/internal/cli/run_test.go`
- `system/tools/poly/internal/projectcfg/templates.go`
- `system/tools/poly/internal/projectcfg/templates_test.go`

Primary changed documentation paths:

- `README.md`
- `ROADMAP.md`
- `system/docs/development/governance/decision-log.md`
- `system/docs/development/platform-architecture/01-distribution-model.md`
- `system/docs/development/platform-architecture/02-polymoly-lock-spec.md`
- `system/docs/development/platform-architecture/03-polymoly-output-lifecycle.md`
- `system/docs/development/platform-architecture/ARCHITECTURE_FREEZE_V1_FEATURE_SLICED.md`
- `system/docs/development/product/problem-statement.md`
- `system/docs/development/product/golden-path-demo.md`
- `system/docs/development/product/v2-execution-backlog.md`
- `system/docs/development/product/brainstorm-contradiction-matrix.md`
- `system/docs/development/findings/v2-audit-findings.md`
