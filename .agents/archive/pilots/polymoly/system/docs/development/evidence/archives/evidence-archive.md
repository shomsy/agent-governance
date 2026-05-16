# PolyMoly Lock Progress Evidence (Archive)

Archive note:

- This file is historical evidence only (read-only).
- Active evidence source of truth is now in `TODO.md` and `BUGS.md`.

Evidence intent (decision trail):

- Record what problem was discussed.
- Record options considered and why one path was chosen.
- Record tradeoffs and explicit non-goals.
- Record concrete next step and owner lane.

## 2026-03-06 — Active TODO backlog closure (39 -> 0)

Decision context:

- The active feature backlog had accumulated implementation items, already-satisfied product tasks, and visionary parking-lot ideas in one file.
- Objective was to end the iteration with zero active TODO noise while preserving traceability for implemented work and future-plan items.

What changed:

- Closed active product-contract items by implementation:
  - `poly set` with internal `intent -> plan -> apply`,
  - first-class `poly replace` with preview, backup, and `.polymoly` preservation,
  - canonical `--lang` support with `--runtime` deprecation messaging,
  - guided `poly logs`, concise `poly status`, explicit `poly wizard`,
  - structured history, explainability, service discovery, graph, impact, and watch surfaces,
  - legacy sidecar migration guidance for `.polymoly/project.yaml`.
- Closed product-direction and docs backlog by ratifying decisions in `system/docs/development/governance/decision-log.md`:
  - canonical product sentence,
  - thin-core help tree,
  - `poly new` onboarding behavior,
  - `poly up` vs advanced mutation semantics,
  - schema freeze,
  - README first-contact contract,
  - doctor coverage posture,
  - engineering-polish parking policy.
- Moved non-active visionary scope to future-plan / idea-pool posture rather than leaving it as active TODO noise.

Verification commands:

- `go test ./system/tools/poly/internal/cli ./system/tools/poly/internal/projectcfg` -> PASS
- `go test ./system/tools/poly/...` -> PASS
- smoke validation over temp project inside repo root:
  - `poly new demo --lang go` -> PASS
  - `poly set cache=none --yes` -> PASS
  - `poly replace --lang php --yes` -> PASS
  - `poly history` -> PASS
  - `poly services` -> PASS
  - `poly graph` -> PASS
  - `poly explain cache` -> PASS

Outcome:

- `TODO.md` is reduced to `0 open`.
- Future-looking scope remains visible in `v3-future-plan.md` and `v3-idea-pool.md` without polluting the active backlog.
- Product, runtime, and governance surfaces are aligned closely enough to treat this pass as backlog closure rather than another brainstorming draft.

## 2026-03-04 — Contract Integrity Iteration 1 Closure (TODO/BUG convergence)

Decision context:

- Contract-integrity and backlog debt items were open across module contracts, docs governance drift, timeout/evidence behavior, and deterministic core behavior.
- Objective was a single closure iteration with executable proof, not partial planning.

What changed:

- Closed all active TODO lanes for Contract Integrity iteration:
  - module contract major/capability enforcement,
  - transactional `poly lock update`,
  - docs front matter + stale-doc diff guard,
  - typed registry validation,
  - cross-profile monotonicity gate,
  - `task dev` five-minute win path,
  - CI caching and GHCR auth stabilization,
  - typed core render-model wrapper,
  - backlog snapshot source-of-truth,
  - PHP runtime surface rationalization.
- Closed all active BUG lanes for the same iteration:
  - fail-closed evidence writes,
  - shared timeout policy + runner evidence,
  - pinned doc-engine runtime default and explicit fallback labeling,
  - deterministic core diff and parser numeric compatibility,
  - governance reference coverage,
  - canonical wrapper drift (`system/gates/run`, `merge-files.sh`),
  - external contract mismatch blockers and supply-chain contract fields.

Verification commands:

- `cd core && go test ./...` -> PASS
- `cd tools/poly && go test ./...` -> PASS
- `bash system/gates/run p0` -> PASS
- `bash system/gates/run docs` -> PASS
- `bash system/gates/run full` -> PASS

Outcome:

- `TODO.md` and `BUGS.md` are converged to `0 open`.
- Gate profiles and artifacts now prove the updated contract layer and backlog status.
- This unblocks V1 hard-freeze handoff with a single canonical proof surface.

## 2026-03-04 — Local Bootstrap Truth Pass (`poly start` + Taskfile + live Docker proof)

Decision context:

- `poly start` and `task start` were presented as the canonical local bootstrap surface, but the actual Go CLI behavior had drifted.
- The command surface claimed "certs + infra + configurator" while `poly start` delegated to a full local `up`, inflating the runtime surface and making the UX contract false.
- A live Docker-backed proof was required to validate the new `Taskfile` path and the renamed project identity (`poly-moly-local-*`).

What changed:

- Added a Go-owned bootstrap compose contract in `system/tools/poly/internal/contracts/compose.go`.
- Changed `system/tools/poly/internal/cli/runtime.go` so `poly start` uses the minimal bootstrap service set instead of the whole local stack.
- Added compose contract tests in `system/tools/poly/internal/contracts/compose_test.go`.
- Verified `task start` and `task doctor` through the real `Taskfile` surface under Docker.

Verification commands:

- `go test ./system/tools/poly/...` -> PASS
- `bash system/tools/poly/poly.sh start --dry-run` -> PASS
- `sg docker -c 'cd /home/sho/polymoly && task doctor -- --json'` -> PASS
- `sg docker -c 'cd /home/sho/polymoly && task down'` -> PASS
- `sg docker -c 'cd /home/sho/polymoly && task start'` -> PASS

Outcome:

- `poly start` and `task start` now match the promised bootstrap contract.
- Local runtime naming is aligned with the new project slug (`poly-moly-local-*`).
- The Go CLI owns the local bootstrap story truthfully instead of delegating to an inflated compose surface.

## 2026-03-04 — P0 Quality Drift Closure (starter lint + OPA + healthchecks)

Decision context:

- A full canonical `p0` execution exposed several non-theoretical regressions:
  - starter lint drift across PHP, Node, and Go lanes,
  - OPA resource-limit policy drift against `deploy.resources.limits`,
  - false-negative local healthchecks for Mailpit, Configurator, and Grafana,
  - slow first-run database initialization causing local bootstrap flakiness.

What changed:

- Fixed starter lint contracts:
  - `lanes/starters/php/phpstan.neon`
  - `lanes/starters/node/.eslintrc.json`
  - `lanes/starters/node/src/index.js`
  - `lanes/starters/go/cmd/main.go`
- Aligned OPA resource-limit policy with real compose output:
  - `features/security/policies/compose/core-resource-limits.rego`
  - `deployment/compose/compose.yaml`
- Hardened local bootstrap healthchecks and slow-start timing:
  - `deployment/compose/compose.yaml`

Verification commands:

- `sg docker -c 'cd /home/sho/polymoly && bash system/gates/run p0'` -> PASS
- `sg docker -c 'cd /home/sho/polymoly && make lint.node'` -> PASS
- `sg docker -c 'cd /home/sho/polymoly && make lint.go'` -> PASS
- `sg docker -c 'cd /home/sho/polymoly && docker compose --project-directory . -f deployment/compose/compose.yaml -f deployment/compose/compose.local.yaml --env-file environments/shared/.env --env-file environments/local/.env up -d --force-recreate mailpit configurator grafana'` -> PASS
- `sg docker -c 'docker ps --format "table {{.Names}}\\t{{.Status}}" | egrep "poly-moly-local-(mailpit|configurator|grafana)-1"'` -> PASS
- `sg docker -c 'cd /home/sho/polymoly && docker compose --project-directory . -f deployment/compose/compose.yaml -f deployment/compose/compose.prod.yaml --env-file environments/shared/.env --env-file environments/production/.env config > /tmp/prod.rendered.yml && docker run --rm -v /home/sho/polymoly:/workspace -v /tmp:/tmp -w /workspace openpolicyagent/conftest:v0.57.0 test /tmp/prod.rendered.yml -p features/security/policies/compose --output table'` -> PASS

Outcome:

- `p0` no longer fails on stale starter lint debt or policy false negatives.
- Local bootstrap is materially more stable on first run.
- The compose security contract matches the real rendered output instead of an outdated legacy shape.

## 2026-03-04 — GitOps Branch Truth Fix (`repo-lock` resolves origin HEAD)

Decision context:

- ArgoCD manifests were no longer placeholders, but the Go GitOps helper still defaulted `targetRevision` to `main`.
- The actual repository default branch is `master`, so the previous behavior would produce a green artifact and a broken live sync.

What changed:

- Added origin default-branch resolution to `system/tools/poly/internal/policy/gitops.go`.
- Updated `poly argocd repo-lock` / `bootstrap` CLI help to default revision from origin HEAD rather than a hard-coded branch.
- Expanded `deployment/helm/charts/polyglot-engine/values-stage-gitops.yaml` into a proof-safe live-sync profile:
  - public PHP frontend/runtime images,
  - single replica,
  - HPA disabled,
  - PHP worker disabled.
- Updated `system/docs/development/platform-architecture/GO_FIRST_EVOLUTION_V1.md` to reflect the approved Taskfile-canonical direction instead of the older optional-UX framing.

Verification commands:

- `git symbolic-ref refs/remotes/origin/HEAD` -> PASS (`refs/remotes/origin/master`)
- `go test ./system/tools/poly/...` -> PASS
- `bash system/tools/poly/poly.sh argocd repo-lock` -> PASS

Outcome:

- GitOps repo identity lock is now branch-truthful instead of assuming `main`.
- ArgoCD live adoption no longer has a built-in branch mismatch bug before cluster bootstrap even starts.
- The strategy document and execution lane are now materially closer, reducing silent governance drift.

## 2026-03-04 — ArgoCD Live Bootstrap Proof (bootstrap pass, sync blocked on repo auth)

Decision context:

- After fixing GitOps branch truth and pushing the updated repo state to `origin/master`, the remaining question was no longer theoretical bootstrap planning.
- The real question was whether ArgoCD could be installed and reconcile the stage application against the live repository.

What changed:

- Installed local cluster tooling into the repo-local tool cache:
  - `kubectl`
  - `kind`
- Created a real `kind` cluster for the GitOps proof.
- Executed `poly argocd bootstrap` against that cluster.
- Recorded a live stage-sync artifact under `system/gates/artifacts/argocd-live/`.

Verification commands:

- `git push origin master` -> PASS
- `sg docker -c 'cd /home/sho/polymoly && export PATH=$PWD/.cache/bin:$PATH && export KUBECONFIG=$PWD/.cache/kind/polymoly-argocd.kubeconfig && kind create cluster --name polymoly-argocd'` -> PASS
- `cd /home/sho/polymoly && export PATH=$PWD/.cache/bin:$PATH && export KUBECONFIG=$PWD/.cache/kind/polymoly-argocd.kubeconfig && bash system/tools/poly/poly.sh argocd bootstrap --namespace argocd` -> PASS
- `cd /home/sho/polymoly && export PATH=$PWD/.cache/bin:$PATH && export KUBECONFIG=$PWD/.cache/kind/polymoly-argocd.kubeconfig && kubectl -n argocd get pods` -> PASS
- `cd /home/sho/polymoly && export PATH=$PWD/.cache/bin:$PATH && export KUBECONFIG=$PWD/.cache/kind/polymoly-argocd.kubeconfig && kubectl -n argocd get application polymoly-stage -o jsonpath='{.status.conditions[0].type}{\"|\"}{.status.conditions[0].message}{\"|\"}{.status.sync.status}{\"|\"}{.status.health.status}{\"\\n\"}'` -> FAIL intentionally with repository authentication blocker

Outcome:

- Live bootstrap is no longer hypothetical; ArgoCD and Argo Rollouts install successfully in a real local cluster.
- The next blocker is concrete and verified:
  - repository credentials/bridge are required for this private GitHub origin
  - first stage sync is blocked until that bridge exists
- This moved `TODO-ARGOCD-LIVE-01` from blueprint status to a real, bounded productization gap.

## 2026-03-04 — Go Surface Consolidation Pass (`poly doctor` + Taskfile + ArgoCD Dry-Run)

Decision context:

- The Go-first lane had crossed from skeleton into real CLI ownership, but it still had two integrity gaps:
  - `system/tools/poly/poly.sh` could silently execute a stale cached binary instead of the current Go source.
  - the new `poly doctor` path existed, but had not been proven through both direct CLI and `Taskfile` surfaces.
- ArgoCD had a repo contract, but the live adoption lane still lacked an operational bootstrap command surface.

What changed:

- Added Go-owned runtime and GitOps slices:
  - `system/tools/poly/internal/cli/runtime.go`
  - `system/tools/poly/internal/cli/argocd.go`
  - `system/tools/poly/internal/contracts/compose.go`
  - `system/tools/poly/internal/policy/gitops.go`
- Expanded the Go CLI command surface:
  - `poly doctor`
  - `poly up/down/status/logs`
  - `poly argocd repo-lock`
  - `poly argocd bootstrap --dry-run`
- Upgraded `system/tools/poly/poly.sh` to prefer live Go source by default and use the built binary only as an explicit compatibility path (`POLY_USE_BIN=1`) or when Go is unavailable.
- Expanded `Taskfile.yml` to route canonical orchestration through the Go CLI:
  - `task start`
  - `task doctor`
  - `task up`
  - `task down`
  - `task status`
  - `task argocd:repo-lock`
  - `task argocd:bootstrap`
- Locked ArgoCD manifests to the real Git repository URL:
  - `features/gitops/argocd/application-stage.yaml`
  - `features/gitops/argocd/application-prod.yaml`

Verification commands:

- `go test ./system/tools/poly/...` -> PASS
- `bash system/tools/poly/poly.sh doctor` -> FAIL correctly on current shell due Docker daemon permission, but writes:
  - `system/gates/artifacts/poly-doctor/summary.txt`
  - `system/gates/artifacts/poly-doctor/summary.json`
  - `system/gates/artifacts/poly-doctor/checks.tsv`
- `task doctor -- --json` -> FAIL correctly with non-zero task exit when doctor gate is red
- `bash system/tools/poly/poly.sh up local --dry-run` -> PASS
- `bash system/tools/poly/poly.sh argocd repo-lock` -> PASS
- `bash system/tools/poly/poly.sh argocd bootstrap --dry-run` -> PASS
- `task start -- --dry-run` -> PASS
- `task argocd:bootstrap -- --dry-run` -> PASS
- `task poly:build` -> PASS
- `POLY_USE_BIN=1 bash system/tools/poly/poly.sh --version` -> PASS

Outcome:

- Go now owns a real day-to-day operator surface instead of only static checks.
- `Taskfile` is no longer decorative; it now routes to the Go CLI and preserves dry-run/fail semantics.
- ArgoCD live adoption is still open, but identity lock and bootstrap planning are now machine-executable instead of documented placeholders.

## 2026-03-04 — Go/Python Ownership Lock Plan

Decision context:

- Product direction was no longer ambiguous:
  - Go must become the operational/control-plane owner.
  - Taskfile must replace Makefile as the canonical orchestration surface.
  - Python must shrink toward specialized ownership instead of remaining spread across operational paths.
- The remaining ambiguity was timing:
  - whether Python leaves the whole system now,
  - or whether this must be staged to avoid an uncontrolled core rewrite.

Chosen path:

- Split the strategy into two explicit locks:
  - `Lock v1`
    - Go owns the operational surface
    - Taskfile becomes canonical
    - Makefile is decommissioned
    - Python remains in `core/` plus `doc-engine`
  - `Lock v2`
    - decide and execute `core/` migration to Go if still justified
    - Python remains only `doc-engine`
- Defined first execution order:
  - `poly doctor`
  - `poly gate run p0`
  - Taskfile canonicalization
  - deeper verifier digestion
  - ArgoCD later as deployment lane

Reasoning:

- This preserves single-direction momentum without opening an unbounded rewrite.
- It keeps the "single binary" promise honest:
  - not claimed in `Lock v1`
  - only claimable after `Lock v2` if core migration is completed
- It aligns productization with ownership clarity instead of language ideology.

Concrete next step:

- Begin `TODO-GO-FIRST-STRATEGY-01` with `poly doctor` as the first canonical Go execution slice.

## 2026-03-04 — External Tool Closure Pass (`task` + `helm`)

Decision context:

- Two TODO items remained intentionally open because they required real external tools:
  - `TODO-TASK-01` required an actual `task start` proof.
  - `TODO-HELM-01` required an actual `helm template` parity proof.
- The goal was to close them honestly by installing the missing tools in WSL and proving behavior against the live repo state.

What changed:

- Installed external tools in WSL:
  - `task v3.44.1`
  - `helm v3.18.6`
  - `docker.io`
  - `docker compose v2`
- Closed the task bootstrap lane:
  - verified `Taskfile.yml` `start` path goes through `bash system/tools/poly/poly.sh start`
  - ran a real Docker-backed `task start` proof to green
- Closed the Helm consolidation lane:
  - added Helm parity values:
    - `deployment/helm/charts/polyglot-engine/values-proof.yaml`
  - upgraded chart templates to support raw-manifest parity:
    - namespace creation
    - explicit workload names/namespaces
    - postgres PVC parity
    - php env + code mount parity
  - added machine proof:
    - `system/gates/architecture/check-helm-template-proof.py`
- Updated compose startup robustness for slow database initialization:
  - `deployment/compose/compose.yaml`
  - `postgres` healthcheck `start_period: 90s`
  - `mysql` healthcheck `start_period: 180s`

Verification commands:

- `task --version` -> PASS (`3.44.1`)
- `helm version --short` -> PASS (`v3.18.6+gb76a950`)
- `helm template polyglot-engine deployment/helm/charts/polyglot-engine --values deployment/helm/charts/polyglot-engine/values-proof.yaml` -> PASS
- `python3 system/gates/architecture/check-helm-template-proof.py` -> PASS
- `sg docker -c "cd /home/sho/polymoly && task start"` -> PASS

Backlog closure:

- Closed `TODO-TASK-01`
- Closed `TODO-HELM-01`

## 2026-03-04 — Go-First Closure Pass (Binary Preference + Canonical Forwarding)

Decision context:

- The Go-first lane still had three partially closed items:
  - standalone binary contract,
  - Make/Task forwarding drift,
  - shell-backed `poly` commands.
- The goal was to close only what was fully provable and leave external-tool lanes open.

What changed:

- Built and verified a standalone `poly` binary path:
  - `make poly.build-cli`
  - `system/tools/poly/poly.sh` prefers `system/tools/poly/bin/poly` before `go run`
- Removed public-interface drift in `Makefile`:
  - `sec.*` targets now route through `$(POLY_CLI)`
  - `architecture.import-boundaries` routes through `$(POLY_CLI)`
  - `release-toolbox.gate` routes through `$(POLY_CLI)`
- Split public `poly.up` from raw compose execution:
  - added hidden target: `compose.poly.up`
  - public `make poly.up` now forwards to `poly`
  - Go CLI `poly up` now calls `make compose.poly.up ENV=<env>`
- Fixed fallback recursion risk:
  - `system/tools/poly/poly.sh start` fallback now uses `ops-tools/platform/polymoly-cli.sh bootstrap`
  - `system/tools/poly/poly.sh up` fallback now uses `ops-tools/platform/polymoly-cli.sh up`
  - shell fallback helpers now call `make compose.poly.up`, not `make poly.up`
- Closed active TODO lanes:
  - `TODO-GO-01`
  - `TODO-GO-07`
  - `TODO-GO-09`

Verification commands:

- `GOCACHE=/home/sho/polymoly/.cache/go-build GOMODCACHE=/home/sho/polymoly/.cache/go-mod go test ./system/tools/poly/...` -> PASS
- `make poly.build-cli` -> PASS
- `PATH=/bin bash system/tools/poly/poly.sh --version` -> PASS (`0.2.0-go-first`)
- `bash system/tools/poly/poly.sh gate run p0 --dry-run` -> PASS
- `bash system/tools/poly/poly.sh gate check governance-references` -> PASS
- `bash system/tools/poly/poly.sh gate check platform-registry` -> PASS
- `bash system/tools/poly/poly.sh env init` -> PASS (`already exists` safe no-op)
- `make -n poly.up ENV=local` -> PASS (forwards to `poly`)
- `DRY_RUN=true bash ops-tools/platform/polymoly-cli.sh up local` -> PASS
- `DRY_RUN=true bash ops-tools/platform/polymoly-cli.sh bootstrap local` -> PASS
- `make -n sec.all` -> PASS (routes through `poly`)
- `make -n architecture.import-boundaries` -> PASS (routes through `poly`)
- `make -n release-toolbox.gate` -> PASS (routes through `poly`)

Remaining open by design:

- `TODO-TASK-01` stays open until a real `task start` run is verified with the `task` binary.
- `TODO-HELM-01` stays open until a real `helm template` proof is available.

## 2026-03-04 — Go-First Slice Refactor (Vertical Internal Layout)

Decision context:

- The Go migration needed to stop being a loose skeleton and become a real CLI lane.
- Internal layout had to become vertical-slice oriented without breaking root taxonomy from `AGENTS.md`.
- Go internals were required to stop depending on shell orchestration.

What changed:

- Reworked `tools/poly` into a real Go module:
  - `system/tools/poly/go.mod`
  - `go.work`
- Moved the Go entrypoint to:
  - `system/tools/poly/cmd/poly/main.go`
- Replaced horizontal helper packages with vertical internal slices:
  - `system/tools/poly/internal/cli/run.go`
  - `system/tools/poly/internal/contracts/command.go`
  - `system/tools/poly/internal/contracts/root.go`
  - `system/tools/poly/internal/doctor/doctor.go`
  - `system/tools/poly/internal/profiles/profiles.go`
  - `system/tools/poly/internal/policy/governance.go`
  - `system/tools/poly/internal/scanner/registry.go`
  - `system/tools/poly/internal/renderer/summary.go`
  - `system/tools/poly/internal/runner/runner.go`
- Deleted obsolete Go duplicates:
  - `system/tools/poly/internal/app/app.go`
  - `system/tools/poly/internal/checks/docs.go`
  - `system/tools/poly/internal/checks/registry.go`
  - `system/tools/poly/internal/repo/root.go`
- `system/gates/run` now delegates to `system/tools/poly/poly.sh`, which prefers:
  1. built binary,
  2. `go run ./system/tools/poly/cmd/poly`,
  3. safe fallbacks only when Go is unavailable.
- Ported these gate checks to Go:
  - governance references
  - CI profile contract
  - CI runner entrypoint
  - platform registry integrity
- Converted Go internal execution to typed command contracts:
  - no `bash ...` hardcoding inside `internal/**`
  - repo scripts are executed directly through command specs
- Marked runner-used repo scripts executable so Go doctor can validate and run them directly.
- Updated architecture strategy doc with the new Go slice contract:
  - `system/docs/development/platform-architecture/GO_FIRST_EVOLUTION_V1.md`

Verification commands:

- `go test ./system/tools/poly/...` with local Go cache -> PASS
- `go run ./system/tools/poly/cmd/poly --version` -> PASS (`0.2.0-go-first`)
- `go run ./system/tools/poly/cmd/poly gate check governance-references` -> PASS
- `go run ./system/tools/poly/cmd/poly gate check platform-registry` -> PASS
- `go run ./system/tools/poly/cmd/poly gate run p0 --dry-run` -> PASS
- `bash system/gates/system/docs/check-governance-references.sh` -> PASS
- `bash system/gates/engine/check-platform-registry.sh` -> PASS
- `bash system/gates/run p0 --dry-run` -> PASS
- `bash system/gates/run --step docs.governance-integrity --step engine.registry` -> PASS

Open follow-up kept in active TODO:

- standalone binary build/install contract
- Taskfile validation on real `task`
- Helm consolidation
- deeper Make/Task redirection to `poly`
- internalizing remaining shell-backed `poly` commands

## 2026-03-03 — TODO Closure Pass (Runner-Centric Consolidation)

Decision context:

- Active TODO backlog required closure with zero scope expansion.
- Priority was to resolve open technical lanes by implementation, not by reclassification.

What changed:

- Added canonical CI/profile drift checks:
  - `system/gates/system/docs/check-ci-profile-contract.py`
  - `system/gates/system/docs/check-ci-runner-entrypoint.py`
- Added profile visibility/reporting lane:
  - `system/gates/architecture/check-profile-coverage.py`
- Added configurator/platform sync guard:
  - `system/gates/configurator/check-schema-platform-sync.py`
- Extended runner:
  - added docs drift checks to `p0/docs`,
  - added nightly security scan lane (`security.scan-all`),
  - added nightly profile coverage lane,
  - added `--step` execution mode for canonical single entrypoint wrappers.
- Redirected Makefile `sec.*` and `engine.*` verification targets to `bash system/gates/run --step ...`.
- Added CI artifact publication for runner summaries in:
  - `.github/workflows/pr-gates.yml`
  - `.github/workflows/nightly-suite.yml`
  - `.github/workflows/security-suite.yml`
  - `.github/workflows/release-proof.yml` (`full-gates` job)
- Added productization CLI surface:
  - `make poly.init`
  - `make poly.up`
  - `make poly.doctor`
  - `ops-tools/platform/polymoly-cli.sh` commands: `init`, `up`, `doctor`
- Added product contract docs:
  - `system/docs/development/product/five-minute-win.md`
  - `system/docs/development/product/golden-path-demo.md`
  - `system/docs/development/product/adoption-metrics.md`
  - `system/docs/development/product/supportability-contract.md`
- Added stabilization/support docs:
  - `system/docs/development/governance/shell-debt-reduction-plan.md`
  - `system/docs/development/platform-architecture/STABILIZATION_FREEZE_30D.md`
- Updated:
  - `Makefile` start URL messaging,
  - `README.md` quick-start endpoint text,
  - `.gitignore` taxonomy paths,
  - `system/docs/development/governance/release-and-rollback-policy.md` semver section.

Verification commands:

- `python3 -m py_compile system/gates/runner.py system/gates/doctor.py system/gates/system/docs/check-ci-profile-contract.py system/gates/system/docs/check-ci-runner-entrypoint.py system/gates/architecture/check-profile-coverage.py system/gates/configurator/check-schema-platform-sync.py` -> PASS
- `bash system/gates/system/docs/check-ci-profile-contract.sh` -> PASS
- `bash system/gates/system/docs/check-ci-runner-entrypoint.sh` -> PASS
- `bash system/gates/configurator/check-schema-platform-sync.sh` -> PASS
- `bash system/gates/architecture/check-profile-coverage.sh` -> PASS
- `bash system/gates/run p0 --dry-run` -> PASS
- `bash system/gates/run docs --dry-run` -> PASS
- `bash system/gates/run --step engine.registry --dry-run` -> PASS
- `bash system/gates/run --step security.scan-all --dry-run` -> PASS

## 2026-03-03 — Review Round Reopen (Post-Lock Audit)

Decision context:

- A new deep review round requested strict AGENTS-aligned code/product assessment.
- Backlog was intentionally reopened with concrete unresolved risks instead of keeping an artificial zero-open state.

Backlog actions:

- Added open bug lanes in `BUGS.md` for:
  - security suite scan coverage regression,
  - CI profile contract drift,
  - `make start` endpoint mismatch,
  - stale `.gitignore` taxonomy paths.
- Added open execution lanes in `TODO.md` for:
  - P0 security/CI contract alignment,
  - P1 operator UX and drift guards,
  - P2 engineering discipline targets,
  - P3 design-partner discovery.

Verification commands (this review pass):

- `bash system/gates/architecture/check-import-boundaries.sh` -> PASS
- `bash system/gates/system/docs/check-governance-references.sh` -> PASS

## 2026-03-03 — Lock Closure Iteration (TODO Drain to Zero)

Decision context:

- Owner requested full closure of active TODO and BUG lanes in one execution cycle.
- Priority was execution over further architecture movement.

What was closed in code/docs:

- Added toolchain preflight and wired it into `system/gates/run`:
  - `system/gates/doctor.py`
  - `system/gates/doctor`
  - `system/gates/runner.py` preflight call before profile execution.
- Kept canonical gate profiles frozen (`p0`, `full`, `nightly`, `docs`) and removed ad-hoc profile drift.
- Added `make start` quick-start path:
  - `Makefile` target `start` (certs + infra bootstrap + deterministic next steps).
- Added `make gates.doctor` alias in `Makefile`.
- Added architecture heatmap wrapper and execution path:
  - `system/gates/architecture/check-architecture-heatmap.sh`
  - `system/gates/architecture/check-architecture-heatmap.py` baseline ceiling aligned for drift tracking (`shell<=80`, `workflows<=4`).
- Added typed Python implementations for top shell-heavy gates:
  - `core/verifier/image_hardening.py`
  - `core/verifier/opa_policy.py`
  - `core/verifier/threat_model.py`
  - thin wrappers:
    - `system/gates/hardening/check-image-hardening.sh`
    - `system/gates/policy/check-opa-policy.sh`
    - `system/gates/policy/check-threat-model.sh`
- Added machine-enforced evidence contract gate:
  - `system/gates/policy/check-evidence-contract.py`
  - `system/gates/policy/check-evidence-contract.sh`
  - wired into `p0`.
- Added global cross-layer import guard coverage (`platform/core/features`):
  - `system/gates/architecture/check-import-boundaries.py`.
- Eliminated nightly/security duplicate profile execution:
  - `.github/workflows/security-suite.yml` now executes `bash system/gates/run full`.
- Implemented `ui/admin` and `ui/dashboard` baseline shells:
  - SPA shell + boundary readmes + auth/telemetry/event-stream contracts.
- Added product credibility pack:
  - `system/docs/development/product/ideal-customer-profile.md`
  - `system/docs/development/product/problem-statement.md`
  - `system/docs/development/product/deployment-scenarios.md`
  - `system/docs/development/product/monetization-hypothesis.md`
  - `system/docs/development/product/README.md`
- Active backlog files were reset to open-only empty state:
  - `TODO.md` -> 0 open items
  - `BUGS.md` -> 0 open items

Verification commands (this pass):

- `python3 -m py_compile system/gates/runner.py system/gates/doctor.py system/gates/policy/check-evidence-contract.py system/gates/architecture/check-import-boundaries.py system/gates/architecture/check-architecture-heatmap.py core/verifier/image_hardening.py core/verifier/opa_policy.py core/verifier/threat_model.py` -> PASS
- `bash system/gates/architecture/check-import-boundaries.sh` -> PASS
- `bash system/gates/system/docs/check-governance-references.sh` -> PASS
- `bash system/gates/hardening/check-image-hardening.sh` -> PASS
- `bash system/gates/policy/check-opa-policy.sh` -> PASS (local docker lane skipped as designed)
- `bash system/gates/policy/check-threat-model.sh` -> PASS
- `bash system/gates/doctor` -> PASS
- `bash system/gates/architecture/check-architecture-heatmap.sh` -> PASS
- `bash system/gates/run p0 --dry-run` -> PASS (step contract validated)
- `python3 -m unittest core.tests.test_engine_flow` -> PASS

## 2026-03-03 — Full Closure Iteration (Owner Override)

Decision context:

- Product owner requested full lane closure in one iteration.
- Time-window and long-horizon criteria were force-closed to stop refactor churn.

What was closed in code:

- Added root-surface enforcement gate:
  - `system/gates/architecture/check-root-surface.py`
  - `system/gates/architecture/check-root-surface.sh`
  - wired into `system/gates/runner.py` (`full` profile).
- Added CI profile contract doc:
  - `system/docs/development/governance/ci-profile-contract.md`
  - linked from `AGENTS.md`.
- Added root contract doc:
  - `system/docs/development/platform-architecture/ROOT_SURFACE_CONTRACT_V1.md`
  - linked from `AGENTS.md`.
- Finalized determinism hash artifact output in compose verifier:
  - `core/verifier/compose.py`
  - writes `determinism.json` to canonical artifact path and profile artifact path (`GATE_ARTIFACT_DIR`).
- Updated moved path reference:
  - `README.md` now points to `environments/.env.minimal`.
- Fixed broken docs link after plan relocation:
  - `system/docs/development/implementation_plan.md` (`Makefile` link).
- Collapsed active backlog to zero open items:
  - `TODO.md` rewritten as active-empty state with closure decision.
- Created explicit lock reference:
  - `system/docs/development/enterprise-lock-v1.md`.

Verification commands (this pass):

- `bash system/gates/architecture/check-root-surface.sh` -> PASS
- `bash system/gates/engine/check-compose-renderer.sh` -> PASS
- `bash system/gates/system/docs/check-governance-references.sh` -> PASS
- `bash system/gates/architecture/check-gate-ops-boundaries.sh` -> PASS
- `bash system/gates/architecture/check-import-boundaries.sh` -> PASS
- `PHASE=development STRICT=1 bash system/gates/system/docs/check-doc-governance.sh` -> PASS (`250/250`)
- `PHASE=development STRICT=1 bash system/gates/system/docs/check-markdown-links.sh` -> PASS (`2390/2390`)

Notes:

- `system/gates/run docs` first failed on one broken link in `system/docs/development/implementation_plan.md`; after fix, both docs strict checks pass.
- Closure policy for this pass intentionally favors execution lock over waiting for calendar-based criteria.

## 2026-03-03 — Anta Review Consolidation (Execution Pass)

Decision context:

- Review findings were accepted as valid hardening/clarity risks.
- Scope was kept minimal: fix real blockers, avoid taxonomy churn.

What was closed in code:

- Removed `rg` dependency from hardening gate:
  - `system/gates/hardening/check-hardening.sh`
  - all `rg` checks replaced with grep-based matcher.
- Fixed Dockerfile scan flag bug in hardening gate:
  - `grep -g` -> `grep --include='Dockerfile*'`.
- Enforced fail-on-empty for required platform YAML definitions:
  - `core/engine_platform_loader.py`
  - `module.yaml`, `capability.yaml`, render assets and named docs now reject empty mapping/null docs.
- Reclassified review-pack artifact policy:
  - `polymoly.txt` remains a development review artifact generated by `merge-files.sh`.
  - `polymoly.txt` is ignored by VCS (`.gitignore`) to prevent accidental commits.
- UI ghost placeholders explicitly locked:
  - `ui/README.md`
  - `ui/admin/README.md`
  - `ui/dashboard/README.md`

Verification commands:

- `bash system/gates/hardening/check-hardening.sh` -> PASS
- `tmp_dir=$(mktemp -d); printf '#!/bin/sh\nexit 99\n' > "$tmp_dir/rg"; chmod +x "$tmp_dir/rg"; PATH="$tmp_dir:$PATH" bash system/gates/hardening/check-hardening.sh` -> PASS (proves no `rg` dependency)
- `python3 -m py_compile core/engine_platform_loader.py` -> PASS
- `bash system/gates/engine/check-platform-registry.sh` -> PASS
- `tmp_dir=$(mktemp -d); printf '#!/usr/bin/env bash\necho rg-missing >&2\nexit 127\n' > "$tmp_dir/rg"; chmod +x "$tmp_dir/rg"; PATH="$tmp_dir:$PATH" bash system/gates/run p0` -> PASS through hardening lane; run stops later on missing `make` binary in current environment (non-review issue)

## Completed in current pass

- [x] Traefik dashboard policy hardened:
  - base/stage/prod => `--api.dashboard=false`
  - explicit local/dev override => `deployment/compose/overrides/debug.yaml` with `--api.dashboard=true`
- [x] Policy-as-code baseline enforced in hardening guard:
  - forbid `privileged: true`
  - forbid `network_mode: host`
  - forbid `pid/ipc: host`
  - require healthcheck on core services
  - require prod runtime hardening + `mem_limit` + `cpus` on core services
- [x] Admin allowlist policy tightened:
  - base middleware fail-closed (loopback only)
  - local-only relaxed override via `zz_admin_allowlist_compose.local.yaml`
  - stage/prod explicitly blocked from mounting local relaxed override
- [x] Watchtower reduced risk:
  - moved to opt-in compose profile `ops-watchtower`
  - monitor-only mode asserted by hardening guard
- [x] CI lock gate added:
  - workflow `compose-lock-gates.yml` with:
    - compose render validation (base/stage/prod/debug)
    - minimal smoke bring-up (`docker-socket-proxy` + `traefik`)
    - artifact upload (`compose rendered`, `smoke ps`, `traefik logs`)
    - hardening guard execution
- [x] CI/CD Factory added:
  - workflow `ci-factory.yml` with:
    - language lint suite (`make lint.all`)
    - hardening guard
    - core image build gate (`nginx`, `node`, `go`)
    - artifact upload (rendered compose + built image list)
- [x] Chaos gate added:
  - workflow `chaos-gates.yml` with:
    - minimal stack bring-up (`docker-socket-proxy`, `traefik`, `fallback`, `node`, `go`)
    - k6 circuit-breaker chaos run for `node`
    - k6 circuit-breaker chaos run for `go`
    - artifact upload (k6 summaries + compose ps + service logs)
- [x] Performance bottleneck review workflow added:
  - script `tools/perf/review-bottlenecks.sh`
  - workflow `performance-bottleneck-review.yml`
  - enforces threshold presence for DB/Redis/queue/CPU/IO + SLO latency checks
  - artifacts: `tools/artifacts/performance-review/summary.txt`, `checks.tsv`
- [x] Kubernetes migration readiness scoring added:
  - script `tools/deployment/kubernetes/manifests/readiness-score.sh`
  - workflow `k8s-readiness-gate.yml`
  - weighted score + explicit exit criteria (`score >= 80`, `mandatory_failures = 0`)
  - artifacts: `tools/artifacts/k8s-readiness/summary.txt`, `checks.tsv`
- [x] Formal threat model added:
  - model: `features/security/threat-model.json`
  - validator: `features/security/check-threat-model.sh`
  - workflow: `threat-model-gate.yml`
  - artifacts: `tools/artifacts/security-threat-model/summary.txt`, `checks.tsv`
- [x] Security deep-dive layer audit added:
  - script: `features/security/run-layer-audit.sh`
  - layers: edge, runtime, identity, data, supply-chain
  - tracked findings artifact: `tools/artifacts/security-layer-audit/findings.tsv`
  - workflow: `security-layer-audit.yml`
  - additional artifacts: `summary.txt`, `checks.tsv`, `hardening.log`, `threat-model.log`
- [x] Dual-DB operational boundary review closed (P0):
  - canonical boundary artifact: `tools/ops/dual-db-boundaries.json`
  - validator script: `tools/ops/review-dual-db-boundaries.sh`
  - CI workflow: `dual-db-boundary-review.yml`
  - artifacts: `tools/artifacts/dual-db-review/summary.txt`, `checks.tsv`
- [x] Advanced runtime tuning baseline closed (P0):
  - validator script: `tools/perf/check-runtime-tuning.sh`
  - CI workflow: `runtime-tuning-baseline.yml`
  - scope: Node old-space + threadpool, Go GC/memory/procs, PHP opcache, DB pool caps
  - artifacts: `tools/artifacts/runtime-tuning/summary.txt`, `checks.tsv`
- [x] Hard environment isolation gate closed (P0):
  - validator script: `features/security/check-environment-isolation.sh`
  - CI workflow: `environment-isolation-gate.yml`
  - checks: unique `COMPOSE_PROJECT_NAME`, metrics entrypoints, ACME storage, S3 backup prefixes across `local/stage/prod`
  - artifacts: `tools/artifacts/environment-isolation/summary.txt`, `checks.tsv`
- [x] HA failure demo defined and wired (P0):
  - runtime drill script: `tools/ops/run-ha-failure-demo.sh`
  - CI workflow: `ha-failure-demo.yml`
  - reproducible criteria: baseline 2 healthy replicas -> one node failure -> degraded continuity -> recovery back to 2 healthy replicas
  - artifacts: `tools/artifacts/ha-failure-demo/summary.txt`, `checks.tsv`, `compose.ps.txt`, `compose.logs.txt`
- [x] Hardening guard upgraded with P0 operational baselines:
  - `features/security/check-hardening.sh` now executes:
    - `tools/ops/review-dual-db-boundaries.sh`
    - `tools/perf/check-runtime-tuning.sh`
    - `features/security/check-environment-isolation.sh`
- [x] Managed database mode added as first-class deployment option (P1):
  - managed overlay: `deployment/compose/overrides/managed-db.yaml`
  - managed env profile: `environments/managed/.env`
  - make support: `ENV=managed`
  - validator: `tools/ops/check-managed-db-mode.sh`
  - CI workflow: `managed-db-mode-gate.yml`
  - artifacts: `tools/artifacts/managed-db-mode/summary.txt`, `checks.tsv`
- [x] FinOps cost baseline + monthly guardrails closed (P1):
  - guardrail script: `tools/finops/cost-guardrails.sh`
  - CI workflow: `finops-cost-guardrails.yml`
  - outputs: `tools/artifacts/finops/summary.txt`, `service-costs.tsv`
- [x] Adaptive autoscaling baseline on custom metrics closed (P1):
  - Helm values extended for queue depth + p95 latency + warmup windows
  - template upgraded: `deployment/helm/charts/polyglot-engine/templates/keda-scaler.yaml`
  - validator: `tools/deployment/kubernetes/manifests/check-adaptive-autoscaling.sh`
  - CI workflow: `adaptive-autoscaling-gate.yml`
  - artifacts: `tools/artifacts/adaptive-autoscaling/summary.txt`, `checks.tsv`
- [x] Failure-mode simulation framework added (P1):
  - scenario runner: `tools/chaos/run-chaos-scenario.sh`
  - make targets: `chaos.postgres`, `chaos.redis`, `chaos.network`
  - CI workflow: `chaos-failure-modes.yml`
  - artifacts: `tools/artifacts/chaos-scenarios/*.summary.txt`, `*.checks.tsv`, `*.compose.*.txt`
- [x] Internal API policy engine baseline (OPA/Conftest) closed (P1):
  - policy bundle: `features/security/policies/compose/*.rego`
  - gate script: `features/security/check-opa-policy.sh`
  - CI workflow: `opa-policy-gate.yml`
  - artifacts: `tools/artifacts/opa-policy/summary.txt`, `checks.tsv`, `conftest.log`, `prod.rendered.yml`
- [x] GitOps rollout flow closed (P1):
  - ArgoCD project/app manifests: `infrastructure/gitops/argocd/*.yaml`
  - rollout value profiles: `deployment/helm/charts/polyglot-engine/values-stage-gitops.yaml`, `values-prod-gitops.yaml`
  - gate script: `tools/ops/check-gitops-rollout.sh`
  - CI workflow: `gitops-rollout-gate.yml`
  - watchtower remains monitor-only + opt-in, rollout ownership moves to GitOps path
- [x] Image hardening level 2 closed (P1):
  - hardened Dockerfiles:
    - `lanes/go/engine/Dockerfile.distroless`
    - `lanes/node/engine/Dockerfile.wolfi`
    - `lanes/php/fpm/Dockerfile.rootless-buildkit`
  - BuildKit secret mounts included (`git_auth`, `npmrc`, `composer_auth`)
  - gate script: `features/security/check-image-hardening-level2.sh`
  - CI workflow: `image-hardening-level2-gate.yml`
- [x] Secrets rotation automation closed (P1):
  - rotator: `features/security/rotate-secrets.sh` (dry-run by default)
  - validator: `features/security/check-secrets-rotation.sh`
  - CI workflow: `secrets-rotation-gate.yml` (weekly + on-demand)
  - artifacts: `tools/artifacts/secrets-rotation/*` including `.env.rotated` and `rotation-report.json`
- [x] SRE observability extension closed (P1):
  - blackbox exporter service + config: `monitoring/blackbox/blackbox.yaml`
  - Prometheus synthetic scrape + SRE recording rules:
    - `monitoring/prometheus/prometheus.yaml`
    - `monitoring/prometheus/sre-recording.yaml`
    - `monitoring/prometheus/alerts.yaml` (synthetic + journey + error budget alerts)
  - Grafana dashboard: `monitoring/grafana/dashboards/sre-red-use-and-synthetic.json`
  - gate script/workflow:
    - `features/security/check-sre-observability.sh`
    - `sre-observability-gate.yml`
- [x] Performance engineering lab baseline closed (P1):
  - lab collector: `tools/perf/performance-lab.sh`
  - lab gate: `tools/perf/check-performance-lab.sh`
  - CI workflow: `performance-lab-gate.yml`
  - artifacts: `tools/artifacts/performance-lab/*` (pprof source, heatmap, DB sampling, worker lag histogram)
- [x] Modular infrastructure packs closed (P1):
  - overlays: `deployment/compose/overrides/pack-minimal.yaml`, `deployment/compose/overrides/pack-enterprise.yaml`, `deployment/compose/overrides/pack-high-security.yaml`
  - high-security Traefik override: `traefik/dynamic-overrides/zz-pack-high-security.yaml`
  - make targets: `pack.minimal.up`, `pack.enterprise.up`, `pack.high-security.up`
  - gate script/workflow:
    - `tools/ops/check-modular-packs.sh`
    - `modular-packs-gate.yml`
- [x] Zero-trust service networking baseline closed (P1):
  - internal mTLS + JWT middleware: `traefik/dynamic/zero-trust.yaml`
  - internal PKI/JWT public material:
    - `traefik/certs/internal-ca.crt`
    - `infrastructure/zero-trust/jwt/internal_jwt_public.pem`
    - `infrastructure/zero-trust/jwt/internal_jwt_jwks.json`
  - runtime services:
    - `python-ai` (FastAPI AI district)
    - `internal-authz` (internal JWT verifier)
  - gate script/workflow:
    - `features/security/check-zero-trust.sh`
    - `zero-trust-gate.yml`
- [x] FinOps layer closed (P1):
  - recording rules: `monitoring/prometheus/finops-recording.yaml`
  - alerts: `FinOpsEfficiencyDegraded`, `FinOpsCostPer1kHigh`
  - dashboard: `monitoring/grafana/dashboards/finops-efficiency.json`
  - scripts:
    - `tools/finops/cost-efficiency.sh`
    - `tools/finops/check-finops-layer.sh`
  - workflow: `finops-layer-gate.yml`
  - artifacts: `tools/artifacts/finops/cost-per-request.tsv`, `rps-per-cpu.tsv`, `efficiency-summary.txt`
- [x] Incident replay mode closed (P1):
  - replay pipeline: `tools/replay/run-incident-replay.sh`
  - gate script/workflow:
    - `tools/replay/check-incident-replay.sh`
    - `incident-replay-gate.yml`
  - make target: `replay.run`
  - artifacts: `tools/artifacts/incident-replay/{requests.tsv,replay.js,summary.txt}`
- [x] AI & Python district closed (P2):
  - runtime service: `lanes/python/app/main.py` (FastAPI inference + health + internal JWT verify endpoint)
  - compose integration:
    - `deployment/compose/compose.yaml` (`python-ai`, `internal-authz`, internal entrypoint routers)
    - `deployment/compose/compose.local.yaml`, `deployment/compose/compose.stage.yaml`, `deployment/compose/compose.prod.yaml`, `deployment/compose/overrides/managed-db.yaml`
  - make targets: `python.up`, `python.down`, `python.build`, `python.logs`, `python.shell`, `python.restart`, `python.status`
- [x] Chaos training program closed (P2):
  - drill runner: `tools/chaos/run-training-program.sh`
  - gate: `tools/chaos/check-training-program.sh`
  - make target: `chaos.training`
  - artifacts: `tools/artifacts/chaos-training/*`
- [x] FinOps guide/playbook closed (P2):
  - operating playbook: `infrastructure/finops/PLAYBOOK.md`
  - integrated with FinOps layer checks/artifacts already in CI
- [x] Platform productization closed (P2):
  - CLI bootstrap/domain/wizard: `tools/platform/polymoly-cli.sh`
  - gate: `tools/platform/check-productization.sh`
  - make targets: `platform.bootstrap`, `platform.wizard`, `platform.domain`
  - tenant provisioning path exposed: `tenant.provision`
- [x] Multi-tenant mode baseline closed (P3):
  - tenant model: `infrastructure/multi-tenant/tenants-example.yaml`
  - provisioning: `tools/platform/tenant-provision.sh`
  - gate: `tools/platform/check-multitenant.sh`
  - artifacts: `tools/artifacts/multi-tenant/*`
- [x] Strategic direction decided and documented (P3):
  - direction artifact: `system/docs/development/PLATFORM_DIRECTION.yaml`
  - gate: `tools/ops/check-strategic-direction.sh`
  - artifacts: `tools/artifacts/strategic-direction/*`

## Validation commands run

- `bash features/security/check-hardening.sh` => PASS
- `bash -n features/security/check-hardening.sh` => PASS
- `bash tools/perf/review-bottlenecks.sh` => PASS (26/26)
- `bash tools/deployment/kubernetes/manifests/readiness-score.sh` => PASS (100/100)
- `bash features/security/check-threat-model.sh` => PASS (12/12)
- `bash features/security/run-layer-audit.sh` => PASS (22/22)
- `bash tools/ops/review-dual-db-boundaries.sh` => PASS (17/17)
- `bash tools/perf/check-runtime-tuning.sh` => PASS (16/16)
- `bash features/security/check-environment-isolation.sh` => PASS (23/23)
- `bash -n tools/ops/run-ha-failure-demo.sh` => PASS (syntax)
- `bash tools/ops/check-managed-db-mode.sh` => PASS (25/25)
- `bash tools/finops/cost-guardrails.sh` => PASS
- `bash tools/deployment/kubernetes/manifests/check-adaptive-autoscaling.sh` => PASS (13/13)
- `bash features/security/check-opa-policy.sh` => PASS (10/10)
- `bash -n tools/chaos/run-chaos-scenario.sh` => PASS (syntax)
- `bash tools/ops/check-gitops-rollout.sh` => PASS (18/18)
- `bash features/security/check-image-hardening-level2.sh` => PASS (12/12)
- `bash features/security/check-secrets-rotation.sh` => PASS (9/9)
- `bash features/security/check-sre-observability.sh` => PASS (20/20)
- `bash tools/perf/check-performance-lab.sh` => PASS (11/11)
- `bash tools/ops/check-modular-packs.sh` => PASS (7/7)
- `bash features/security/check-zero-trust.sh` => PASS (11/11)
- `bash tools/finops/check-finops-layer.sh` => PASS (8/8)
- `bash tools/replay/check-incident-replay.sh` => PASS (6/6)
- `bash features/security/check-hardening.sh` => PASS
- `bash tools/chaos/check-training-program.sh` => PASS (4/4)
- `bash tools/platform/check-productization.sh` => PASS (6/6)
- `bash tools/platform/check-multitenant.sh` => PASS (5/5)
- `bash tools/ops/check-strategic-direction.sh` => PASS (4/4)
- `test -f lanes/python/app/main.py` => PASS
- `test -f infrastructure/finops/PLAYBOOK.md` => PASS

## Notes

- Local runtime `docker compose` execution could not be completed in this WSL instance because Docker daemon is not reachable.
- HA runtime evidence is produced by `ha-failure-demo.yml` on docker-enabled CI runners.
- Chaos scenario runtime evidence is produced by `chaos-failure-modes.yml` on docker-enabled CI runners.
- OPA Conftest runtime evaluation is enforced in CI (`opa-policy-gate.yml`) when docker daemon is available.

## Final Backlog State

- `P0`: 15/15
- `P1`: 14/14
- `P2`: 4/4
- `P3`: 2/2
- Total: 35/35 closed

## TODO Cleanup Migration (2026-03-03)

Purpose:

- Move checked backlog items out of `TODO.md` so TODO stays active-only.
- Keep historical completed checklist items in evidence archives.

Migrated checked items snapshot:

- [x] CI/CD Factory workflow to test and ship automatically.
- [x] Traefik dashboard disabled by default in base compose.
- [x] Dashboard enabled only through explicit local/dev override.
- [x] Compose lock-gate CI workflow (validate + smoke + hardening guard).
- [x] Fail-closed admin allowlist in base, local-only relaxed override.
- [x] Watchtower made opt-in (profile-based), not default-on.
- [x] Formal threat model (assets, trust boundaries, attack paths, mitigations, residual risk).
- [x] Security deep-dive audit by layers with tracked findings.
- [x] Performance bottleneck review workflow with thresholds.
- [x] Kubernetes migration readiness scoring + exit criteria.
- [x] Policy-as-code for compose in CI (no privileged/host network, required healthchecks and limits).
- [x] Review dual-DB operational complexity (PostgreSQL + MySQL) and define canonical usage boundaries.
- [x] Define and execute full HA failure demo (node failure + recovery) with reproducible pass/fail criteria.
- [x] Add advanced runtime tuning baseline (Go GC/memory, PHP worker/JIT profile, DB pool upper bounds per CPU).
- [x] Enforce hard environment isolation (`local/stage/prod`) with unique networks, entrypoints, ACME storage, and S3 prefixes.
- [x] Replace Watchtower-driven updates with GitOps rollout flow (ArgoCD/Flux) with canary + health validation + rollback.
- [x] Add managed database mode (RDS-style path) as first-class deployment option.
- [x] Add cloud cost baseline and monthly guardrails (FinOps thresholds + alerts).
- [x] Add adaptive autoscaling logic on custom metrics (queue depth, p95 latency, scheduled warmup/predictive scale).
- [x] Upgrade image hardening to level 2 (distroless/Wolfi where possible, rootless runtime path, BuildKit secrets over ARG).
- [x] Automate secrets rotation (DB credentials, RabbitMQ users, internal TLS cert rotation).
- [x] Extend observability with SRE-grade views (error budget tracking, synthetic checks, user-journey tracing, RED vs USE).
- [x] Add performance engineering lab features (flamegraphs, heatmaps, DB query sampling, worker lag histogram).
- [x] Refactor to modular infrastructure packs (`minimal`, `enterprise`, `high-security`) via profiles/feature flags.
- [x] Implement zero-trust service networking (mTLS service-to-service, identity-based auth, signed internal JWT flow).
- [x] Build failure-mode simulation framework (`make chaos.postgres`, `make chaos.redis`, `make chaos.network`, CPU/disk stress).
- [x] Add internal API policy engine (OPA/Conftest runtime policy checks, tenant-aware rate/quota enforcement).
- [x] Add FinOps layer (cost per service, cost per request, RPS-per-CPU efficiency dashboards/alerts).
- [x] Add incident replay mode (capture traffic, replay in staging, compare latency/error deltas).
- [x] Add canonical promoted-runtime proof workflow (build + up + gateway smoke + artifact bundle).
- [x] Add runtime hardening inspect proof as audit-friendly artifacts from the promoted stack.
- [x] Generate image-level SBOM + provenance artifacts for promoted runtime images.
- [x] Add restore-to-serving proof workflow (restore drill + app DB read smoke).
- [x] Migrate stage/prod minimum critical credentials to Docker secrets file paths.
- [x] Add periodic resilience proof workflow (weekly HA drill + k6 gateway smoke).
- [x] Add AI & Python district (FastAPI service path for AI/ML workloads).
- [x] Add Chaos Training program (planned resilience drills beyond baseline failure tests).
- [x] Add FinOps guide/playbook for cloud operating model.
- [x] Productize platform UX (one-click bootstrap, domain generator, interactive CLI wizard, telemetry opt-in).
- [x] Productize Configurator as a PolyMoly-only setup console with schema-driven env/secrets bundles, exact round-trip import/export, and promoted-runtime-accurate commands.
- [x] Refactor Configurator into a strict Feature-Sliced Architecture (app/page shell, widgets, features, entities, shared) without changing the PolyMoly runtime contract.
- [x] Design multi-tenant mode (tenant isolation, queue namespace isolation, Redis prefixing, per-tenant limits).
- [x] Decide and document PolyMoly strategic product direction (showcase vs SaaS base vs internal PaaS vs OSS platform vs lab).
- [x] Implement one canonical `release-candidate-proof.yml` run that generates `release-evidence/index.json`, aggregates upstream runtime proofs, and uploads one reviewable evidence bundle.
- [x] Add one canonical release toolbox image for operator-side `git`, `gh`, and `npm` workflows without widening runtime images.
- [x] Add one canonical external review-pack flow and simple-English publish rule for Codex/ChatGPT handoff.
- [x] Keep one typed simple-English git commit format for publish steps.
- [x] Make review-pack generation a required finish step for every completed execution pass.
- [x] Add one configurator DX pass for schema-aware imports, granular promoted lane commands, per-command copy, and secret strength guidance.
- [x] Add one canonical PolyMoly DSL live preview from existing configurator packages without reducing current UI detail.
- [x] Define one canonical `core / platform / ops` architecture contract for PolyMoly as an Infrastructure Composition Engine.
- [x] Define one stable UI/API contract between PolyMoly UI surfaces and the future `core` engine.
- [x] Publish one `System Design v1` document for the PolyMoly engine pipeline.
- [x] Create one initial repository skeleton for `core/`, `platform/`, and `ops/` without stealth-migrating the current runtime in the same pass.
- [x] Publish one project-facing distribution contract for PolyMoly dependency install, `polymoly.lock`, and `.polymoly/` output boundaries.
- [x] Harden build context hygiene for generated PolyMoly outputs and review packs.
- [x] Execute one phased repository folder-restructure pass after UI/DSL closure (no stealth migration).
- [x] Feature 1 (restructure): lock the target ownership map and migration ledger as executable backlog data.
- [x] Feature 2 (restructure): move Configurator UI-only assets into one stable subtree without changing DSL mapping behavior.
- [x] Feature 3 (restructure): isolate engine-facing mappers and contracts into one stable integration edge.
- [x] Feature 4 (restructure): normalize tooling roots by lane (`system/gates/**`, `ops-tools/**`, `configurator/**`) and remove cross-lane script drift.
- [x] Add one architecture import-boundary gate so `core/**` cannot import runtime/UI/deployment layers.
- [x] Publish one simple product goal and user-story document for the composition engine.
- [x] Define one canonical PolyMoly YAML DSL as the only source of truth for infrastructure intent.
- [x] Define one capability/module registry contract for profiles, environments, and reusable infrastructure modules.
- [x] Define one resolver contract for dependency graph building, merge precedence, and policy enforcement.
- [x] Define one compose-first generator roadmap with a clean render-target path for Kubernetes later.
- [x] Create one first compose renderer proof that emits generated compatibility artifacts from `renderModel`.
- [x] Define one composition-engine development flow that keeps engine work aligned with locked contracts and higher-order governance.
- [x] Amend the baby DSL so `enable` supports flat and object form while normalized engine input stays capability-based.
- [x] Define one UI-mapper contract from baby-like operator choices to canonical DSL.
- [x] Lock Baby DSL knob eligibility and publish canonical product-intent examples.
- [x] Add one review-grade knob checklist and anti-pattern guardrail for Baby DSL review.
- [x] Add one canonical profile-power gate backed by executable posture bundles (`localhost`, `production`, `enterprise`).
- [x] Feature 1: Guided multi-step UX surface implemented from schema contracts (no hardcoded form logic).
- [x] Feature 2: Field stratification metadata (`layer`, `stepId`, `learnMoreUrl`) applied across configurator schema.
- [x] Feature 3: Authority guardrails locked (`intent` vs `operator`) with fail-closed schema validation.
- [x] Feature 4: Guided navigation + educational links added without changing canonical DSL mapping.
- [x] Feature 5: Advanced surface preserved as full operator panel (no feature loss).
- [x] Feature 6: Test gates extended for step lockset and authority-boundary invariants.
- [x] Feature 7: UI mapper contract updated with layer-authority matrix and stratification rules.

Decision trail entry (TODO cleanup migration):

- Context:
  - `TODO.md` mixed active work and historical completed checklists, which increased scanning friction.
- Options considered:
  - keep mixed file and only add tags,
  - move completed checklist items to evidence and keep TODO active-only.
- Decision:
  - keep `TODO.md` active-only (`[ ]` tasks), move completed (`[x]`) checklist items into this archive.
- Tradeoff:
  - TODO becomes operationally clean; historical context stays available in evidence.
- Non-goal:
  - no rewrite of historical technical evidence semantics.
- Next step:
  - continue logging future closure decisions in this same decision-trail format.

## Iteration evidence (2026-03-03, TODO fast-lane pass)

Context:

- Goal was to resolve the fastest open TODO items first, keep `TODO.md` active-only, and preserve evidence as decision trail.

Decisions and completed outcomes:

- Closed `enterprise-clean-mode` lane and moved completion record to evidence.
- Closed `governance-integrity-lock-v1` lane:
  - extraction contract locked in `system/gates/system/docs/check-governance-references.py`,
  - runtime measured (`duration_ms: 0`) and promotion candidate note recorded,
  - non-goals kept (no orphan hard-fail, no feature-evidence enforcement, no global version sync).
- Closed `anta-review-consolidation` sub-items:
  - feature maturity visibility map added in `features/README.md`,
  - shell-debt phase 1 and canonical migration records moved from TODO to evidence.
- Added onboarding/clarity artifacts:
  - concise root contract and command-path README rewrite,
  - `system/gates/README.md` security suite aggregation,
  - `system/gates/artifacts/README.md` artifact hierarchy contract,
  - `system/docs/development/operational-noise-index.md` baseline metrics.

Operational metrics baseline recorded:

- workflows: 5
- shell scripts: 76
- governance docs: 8
- top-level directories: 12

Command evidence:

- `bash system/gates/system/docs/check-governance-references.sh` => PASS (17 refs checked, 0 fail, `duration_ms: 0`)

Tradeoffs:

- Did not force additional heavy gate runs during TODO cleanup to keep iteration fast.
- Kept unresolved review items open where acceptance depends on time window or runtime exercise (`taxonomy freeze`, `human proof`, `ci overlap/release overlap`).

Non-goals for this pass:

- no core semantic rewrite,
- no new gate profile categories,
- no folder taxonomy reset.

## Iteration evidence (2026-03-03, CI collapse alignment pass)

Context:

- Remaining high-leverage TODO items were in workflow sprawl and review overlap.

Decisions and completed outcomes:

- Merged release-candidate flow into canonical release lane:
  - `.github/workflows/release-proof.yml` now contains full gate + promoted runtime + HA + stage load + circuit breaker + restore + evidence bundle.
  - removed `.github/workflows/release-candidate-proof.yml`.
- Removed stale workflow dump artifact:
  - deleted `.github/workflows/workflows.txt`.
- Updated release evidence generator workflow references:
  - `ops-tools/release/generate-release-evidence-index.py` now references `release-proof.yml`.
- Updated release docs references:
  - `system/docs/development/production-ready-ci-plan.md`
  - `system/docs/development/production-ready-checklist.md`

Operational metrics after collapse:

- workflows: 4 (`pr-gates.yml`, `nightly-suite.yml`, `security-suite.yml`, `release-proof.yml`)
- shell scripts: 76
- governance docs: 8
- top-level directories: 12

Command evidence:

- `find .github/workflows -maxdepth 1 -type f -name '*.yml' -printf '%f\n' | sort`
- `python3` metrics collector (workflows/shell/governance/top-level counts)
- `bash system/gates/system/docs/check-governance-references.sh` => PASS

Tradeoffs:

- Release lane remains operationally heavy by design; merge law still anchored on canonical gate runner for PR/nightly/security/full guard.
- Guided drift acceptance could not be fully validated in this environment because Node/Playwright runtime is unavailable.

## Iteration evidence (2026-03-04, ArgoCD live adoption + Go-first ownership pass)

Context:

- Goal was to close the live ArgoCD lane and remove more public `make` / shell ownership from the active operator surface without rewriting the Python core.

Decisions and completed outcomes:

- Closed the live ArgoCD adoption lane with real cluster evidence:
  - bootstrap executed against a local `kind` cluster,
  - repository bridge secret applied into `argocd`,
  - both `polymoly-stage` and `polymoly-prod` reconciled to `Synced/Healthy`,
  - promotion proof executed from stage revision to prod,
  - rollback proof executed through an intentionally invalid revision and recovery path.
- Hardened Go GitOps handling:
  - `poly argocd repo-bridge`
  - `poly argocd wait`
  - `poly argocd promote`
  - `poly argocd rollback-proof`
  - added refresh/retry behavior so transient ArgoCD stale conditions do not break recovery proofs.
- Made the public local operator surface more Go/Task owned:
  - `Taskfile.yml` now exposes `init`, `hosts:*`, `pack:*`, and `lint:*`.
  - `p0` lint ownership now routes through `task lint:all` instead of `make lint.all`.
  - configurator-generated operator commands now emit `task` / `poly` commands instead of public `make` lane commands.
  - active README/product docs now show `task` / `poly` as the public path.
- Frozen Python into a clearer specialization path:
  - added `system/gates/system/docs/pyproject.toml`,
  - added `doc_engine/__main__.py`,
  - documented the reusable `polymoly-doc-engine` package contract.
- Resolved strategy drift:
  - updated `GO_FIRST_EVOLUTION_V1.md` so Taskfile/Makefile/Python ownership matches the active implementation.

Command evidence:

- `go test ./system/tools/poly/...` => PASS
- `task --list` => PASS
- `task init` => PASS
- `bash system/gates/run p0 --dry-run` => PASS
- `bash system/gates/run docs` => PASS
- `sg docker -c 'cd /home/sho/polymoly && docker run --rm -v $PWD:/workspace -w /workspace/configurator node:22-alpine sh -lc "node --test tests/runtime-contract.test.mjs"'` => PASS
- `bash system/tools/poly/poly.sh argocd bootstrap --namespace argocd` => PASS
- `bash system/tools/poly/poly.sh argocd repo-bridge --namespace argocd` => PASS
- `bash system/tools/poly/poly.sh argocd wait --app polymoly-stage --timeout 600` => PASS
- `bash system/tools/poly/poly.sh argocd wait --app polymoly-prod --timeout 600` => PASS
- `bash system/tools/poly/poly.sh argocd promote --timeout 600` => PASS
- `bash system/tools/poly/poly.sh argocd rollback-proof --timeout 600` => PASS

Machine-verifiable artifacts:

- `system/gates/artifacts/argocd-live/repo-bridge-checks.tsv`
- `system/gates/artifacts/argocd-live/wait-polymoly-stage-checks.tsv`
- `system/gates/artifacts/argocd-live/wait-polymoly-prod-checks.tsv`
- `system/gates/artifacts/argocd-live/promotion-checks.tsv`
- `system/gates/artifacts/argocd-live/rollback-proof-checks.tsv`
- `system/gates/artifacts/poly-doctor/summary.txt`

Tradeoffs:

- `Taskfile.yml` is now the public human-facing surface, but `Makefile` still exists as compatibility-only until the remaining decommission work is finished.
- Python packaging is now explicit for the doc auditor, but extraction into a separate reusable project is still a later productization step.
- The Python core engine remains intentionally untouched in this pass.

Non-goals for this pass:

- no `core/` migration to Go,
- no CI migration into Argo,
- no configurator repo extraction,
- no ideological zero-shell rewrite.

## Iteration evidence (2026-03-04, backlog intake for modular spin-off strategy)

Context:

- Reviewed the newer "Go-First / multi-repo ecosystem" text and reconciled it against the active backlog.

Decision:

- No new bug was opened because the text did not describe a concrete regression, runtime defect, or broken contract.
- One new TODO lane was added to capture the missing execution contract for future spin-offs:
  - `TODO-MODULE-SPINOFFS-01`
- The new lane keeps the current repo operational while freezing:
  - which spin-offs are real,
  - which interfaces must be frozen first,
  - and which speculative repo splits are explicitly out of scope.

Command evidence:

- `sed -n '1,260p' TODO.md`
- `sed -n '1,220p' BUGS.md`
- `nl -ba poly-modules.md | sed -n '1,340p'`

Tradeoffs:

- The spin-off vision remains valid as a north-star, but it is not treated as an immediate rewrite wave.
- `configurator` extraction stays on its own active lane.
- `doc-engine` and governance-template extraction remain gated by interface stability and proof of reuse.

## Iteration evidence (2026-03-04, step-by-step roadmap refinement)

Context:

- The roadmap already had phases, but the execution order was still too easy to interpret differently.
- A stricter sequence was needed so the team can follow one step at a time from the current repo state to the `poly-modules` release milestone.

Decision:

- Added a `Step By Step Execution Order` section to `TODO.md`.
- Kept the phased roadmap, but made the operative sequence explicit:
  - finish `Lock v1`,
  - freeze Python and shell ownership,
  - freeze modular contracts,
  - execute Configurator first,
  - extract `doc-engine` only if ready,
  - then declare `poly-modules` release.

Command evidence:

- `sed -n '1,220p' TODO.md`
- `sed -n '1,220p' poly-modules.md`

Tradeoffs:

- This is still planning/evidence work, not runtime change.
- The stricter sequence reduces ambiguity, but it intentionally does not auto-approve the `doc-engine` or governance-template spin-offs.

## Iteration evidence (2026-03-04, orientation title refinement)

Context:

- The step-by-step sequence in `TODO.md` was clear enough structurally, but the heading was still generic.

Decision:

- Renamed the section heading from `Step By Step Execution Order` to `Orientation Sequence — Road To poly-modules Release`.
- The content and priority order remained unchanged.

Command evidence:

- `sed -n '1,120p' TODO.md`

Tradeoffs:

- This is a clarity-only update meant to make the roadmap easier to scan during team work.

## Iteration evidence (2026-03-04, poly-modules plan intake and publish)

Context:

- `poly-modules.md` existed only as an untracked working draft.
- The plan needed to become a committed roadmap artifact without silently overruling the active execution order in `TODO.md`.

Decision:

- Promoted `poly-modules.md` into a committed vision document.
- Added an explicit contract at the top of the file:
  - vision / modularization north-star,
  - execution authority remains `TODO.md`,
  - no same-day rewrite or premature multi-repo split is implied.
- Linked `TODO.md` back to `poly-modules.md` as the planning source for the modular release lane.

Command evidence:

- `git status --short`
- `sed -n '1,220p' poly-modules.md`
- `sed -n '1,260p' TODO.md`
- `bash system/gates/run docs`
- `./merge-files.sh . --exclude=png,jpg,jpeg,gif,webp,svg,pdf,ico,lock,pyc,class,bin,exe,dll,so,dylib,woff,woff2,ttf,eot`

Tradeoffs:

- `poly-modules.md` is now a real project artifact, but it is still intentionally subordinate to the active TODO execution order.
- This keeps the vision visible without turning it into an uncontrolled rewrite trigger.

## Iteration evidence (2026-03-04, Phase 0/1 operator-surface lock and spin-off contract freeze)

Context:

- Goal was to close the remaining practical gaps in the public `task` / `poly` surface for `Lock v1` without claiming that external repo extraction is already done.
- The active gaps were still concentrated in three places:
  - public `Taskfile` coverage,
  - `poly` compatibility fallback coverage,
  - and the absence of one explicit v1 modularization contract.

Decisions and completed outcomes:

- Moved another public operator contract out of `Makefile` and into canonical shared surfaces:
  - extracted hosts management into `ops-tools/platform/hosts.sh`,
  - wired both `Taskfile.yml` and `Makefile` compatibility targets to that one implementation.
- Locked the remaining human-facing `Taskfile` surface around `task` / `poly`:
  - added `env:init`, `logs`, `verify:changed`, `gate:summary`,
  - added docs helpers (`docs:governance`, `docs:governance:strict`, `docs:links`, `docs:links:strict`),
  - added `platform:*`, `configurator:*`, and `engine:*` helpers so the public operator path no longer depends on `make` discovery.
- Fixed compatibility drift instead of keeping silent mismatch:
  - `Makefile` now states clearly that it is compatibility-only,
  - `make docs.governance` now forwards to the report-mode task instead of silently running the strict docs profile,
  - `make configurator.gate` now forwards to the canonical task surface.
- Completed more CLI lock coverage in the shell fallback path:
  - `system/tools/poly/poly.sh` now keeps fallback coverage for `up`, `down`, `status`, `logs`, and `gate summary`,
  - `ops-tools/platform/polymoly-cli.sh` now runs the compose contract directly instead of delegating through `make`.
- Removed another remaining public `make` dependency from the canonical gate runner:
  - Python `system/gates/runner.py` now uses `task lint:all`, matching the Go profile model.
- Froze the v1 modularization contract in one execution document:
  - added `system/docs/development/product/modularization-contract-v1.md`,
  - linked `poly-modules.md` and `TODO.md` back to that contract,
  - froze the v1 spin-off set, extraction order, and the `poly` contracts for `configurator` and `doc-engine`.
- Updated active docs and fixtures so current user-facing command references now point at `task` / `poly` instead of legacy `make` examples.

Changed files:

- `Taskfile.yml`
- `Makefile`
- `README.md`
- `TODO.md`
- `system/tools/poly/poly.sh`
- `ops-tools/platform/polymoly-cli.sh`
- `ops-tools/platform/hosts.sh`
- `system/gates/runner.py`
- `system/gates/platform/check-productization.sh`
- `configurator/README.md`
- `poly-modules.md`
- `system/docs/development/platform-architecture/GO_FIRST_EVOLUTION_V1.md`
- `system/docs/development/product/modularization-contract-v1.md`
- active docs / fixture references under `system/docs/**` and `system/gates/system/docs/tests/**` that still advertised `make` as the public path

Command evidence:

- `task --list` => PASS
- `go test ./system/tools/poly/...` => PASS
- `bash ops-tools/platform/hosts.sh up --dry-run` => PASS
- `bash system/tools/poly/poly.sh gate summary --profile p0 --json | head -n 5` => PASS
- `task gate:summary -- --profile p0 --json | head -n 5` => PASS
- `bash system/gates/platform/check-productization.sh` => PASS
- `bash system/gates/run docs` => PASS
- `bash system/gates/run p0 --dry-run` => PASS
- `bash system/gates/run p0` => FAIL in this sandbox at `lint.all` because Docker socket access is denied for `docker run`
- `sg docker -c 'cd /home/sho/polymoly && bash system/gates/run p0'` => FAIL (`Cannot open audit interface - aborting.`) in this host sandbox

Tradeoffs:

- `Makefile` still exists as a compatibility layer, but its public ownership is reduced again and its system/docs/configurator helpers now forward into the canonical task surface.
- The modularization contract is now frozen, but the actual Configurator and `doc-engine` repo extractions remain separate later execution work.
- Full `p0` could not be proven green inside this sandbox because Docker daemon access is blocked for the lint containers; the dry-run contract and all non-Docker checks still validated.
- No new bug was added to `BUGS.md` because the failing `p0` condition was host-permission related, not a source regression.

## Iteration evidence (2026-03-04, backlog closure after Lock v1 and contract freeze)

Context:

- After the operator-surface and modular-contract work landed, `TODO.md` still listed closed lock/freeze lanes as open items.
- The `doc-engine` proof commands also needed one accurate repo-local invocation form instead of implying that the package was already installed globally.

Decision:

- Closed and archived the completed planning lanes:
  - `TODO-GO-FIRST-STRATEGY-01`
  - `TODO-MODULE-SPINOFFS-01`
- Opened only the remaining real follow-up lanes:
  - `TODO-MAKEFILE-DECOMMISSION-01`
  - `TODO-DOC-ENGINE-SPINOFF-01`
- Adjusted the frozen `doc-engine` contract so the local proof uses the real repo-local module form:
  - `PYTHONPATH=$PWD/system/gates/docs python3 -m doc_engine ...`
  - packaged entrypoint remains `doc-engine ...`
- Extended the productization gate so `doc-engine` module entrypoints are now machine-checked.

Command evidence:

- `PYTHONPATH=$PWD/system/gates/docs python3 -m doc_engine audit --help` => PASS
- `PYTHONPATH=$PWD/system/gates/docs python3 -m doc_engine.validate --help` => PASS
- `python3 system/gates/system/docs/doc-engine.py audit --help` => PASS
- `bash system/gates/platform/check-productization.sh` => PASS
- `sed -n '1,260p' TODO.md`

Tradeoffs:

- A root-level `doc_engine/` wrapper was rejected because it would have violated the root surface contract.
- `doc-engine` extraction remains intentionally separate from the contract-freeze lane; the backlog now reflects that split explicitly.

## Iteration evidence (2026-03-04, root surface contract reconciliation)

Context:

- The root surface gate still failed because its allowlist no longer matched the actual tracked root entries that the repo already uses.
- The drift affected current execution-critical entries:
  - `Taskfile.yml`
  - `go.work`
  - `poly-modules.md`
  - `tools/`

Decision:

- Updated `AGENTS.md` to recognize `tools/` as the product tooling namespace.
- Updated `ROOT_SURFACE_CONTRACT_V1.md` and the root-surface gate allowlist so the enforced contract matches the real tracked root surface.

Command evidence:

- `bash system/gates/architecture/check-root-surface.sh`
- `sed -n '1,120p' AGENTS.md`
- `sed -n '1,120p' system/docs/development/platform-architecture/ROOT_SURFACE_CONTRACT_V1.md`

Tradeoffs:

- This is a contract-reconciliation change, not permission for uncontrolled new root entries.
- The allowed root surface is still explicit and still enforced by gate.

## Iteration evidence (2026-03-04, TODO-MAKEFILE-DECOMMISSION-01 closure)

Context:

- `Taskfile.yml` and `poly` were already the public operator surface, but the repo still carried a compatibility-only `Makefile`.
- Remaining internal validators, configurator/runtime checks, and active release docs still mentioned or depended on that removed surface.

Decision:

- Removed the last required internal `Makefile` dependencies:
  - hardening, managed-db, modular-pack, incident-replay, chaos-training, and release-toolbox gates now validate `Taskfile`, `poly`, or one canonical script instead of `Makefile`
  - configurator runtime discovery and Windows staging now use `Taskfile.yml` plus real runtime files
  - diff-aware runner mapping and doctor/root-surface contracts no longer treat `Makefile` as a live root surface
- Added the missing canonical runtime wrappers:
  - `ops-tools/toolbox/run.sh`
  - `ops-tools/performance/run-k6.sh`
- Removed the compatibility file itself:
  - deleted `Makefile`
  - updated root contract system/docs/gates and active operator docs to the post-`Makefile` state
- Fixed one real managed-db runtime bug discovered during validation:
  - `deployment/compose/overrides/managed-db.yaml` now resets `keycloak.depends_on` with `!reset []`
  - managed mode compose rendering now works without re-enabling local database services

Changed files:

- `Taskfile.yml`
- `TODO.md`
- `deployment/compose/compose.yaml`
- `deployment/compose/overrides/managed-db.yaml`
- `ops-tools/toolbox/run.sh`
- `ops-tools/performance/run-k6.sh`
- `ops-tools/database/check-managed-db-mode.sh`
- `system/gates/hardening/check-environment-isolation.sh`
- `system/gates/platform/check-modular-packs.sh`
- `system/gates/resilience/check-training-program.sh`
- `system/gates/resilience/check-incident-replay.sh`
- `system/gates/release/check-release-toolbox.sh`
- `system/gates/configurator/check-configurator.sh`
- `system/gates/runner.py`
- `system/gates/architecture/check-root-surface.py`
- `system/tools/poly/internal/profiles/profiles.go`
- `system/tools/poly/internal/doctor/doctor.go`
- `configurator/tests/runtime-contract.test.mjs`
- `configurator/src/entities/configurator-state/model/schema.js`
- `configurator/src/widgets/topbar/ui/ConfiguratorHero.vue`
- `system/docs/development/platform-architecture/ROOT_SURFACE_CONTRACT_V1.md`
- `system/docs/development/platform-architecture/GO_FIRST_EVOLUTION_V1.md`
- active operator/release docs updated to `task` / `poly` under `system/docs/**`
- `Makefile` (deleted)

Command evidence:

- `task --list` => PASS
- `go test ./system/tools/poly/...` => PASS
- `bash system/gates/architecture/check-root-surface.sh` => PASS
- `bash system/gates/hardening/check-environment-isolation.sh` => PASS
- `bash ops-tools/database/check-managed-db-mode.sh` => PASS
- `bash system/gates/platform/check-modular-packs.sh` => PASS
- `bash system/gates/resilience/check-training-program.sh` => PASS
- `bash system/gates/resilience/check-incident-replay.sh` => PASS
- `bash system/gates/release/check-release-toolbox.sh` => PASS
- `bash system/gates/configurator/check-configurator.sh` => PASS
- `bash system/gates/policy/check-evidence-contract.sh` => PASS
- `bash system/gates/run docs` => PASS
- `bash system/gates/run p0` => PASS

Tradeoffs:

- `system/docs/development/implementation_plan.md` and `poly-modules.md` still mention `Makefile` as historical context, but not as a live operator path.
- The managed-db fix was kept minimal and local to the override contract; no profile semantics were widened.

## Iteration evidence (2026-03-04, Go-first adapter decommission pass)

Context:

- The repo had already moved its public control-plane to `poly`, but active verification and ops leaf flows still depended on a spread of shell and Python wrapper files.
- The goal of this pass was not a silent full core-engine rewrite; it was to remove as much wrapper debt as possible in one controlled iteration while keeping `p0` green and `doc-engine` ownership unchanged.

Decision:

- Added Go-owned vertical slices for the remaining high-frequency operator jobs:
  - `tls certs`
  - `toolbox build|shell|exec`
  - `performance k6 <load|capacity|circuit-breaker>`
  - `performance lab`
  - `resilience replay`
  - `secrets rotate`
  - `finops guardrails|efficiency`
- Added new Go gate checks for the migrated active lanes:
  - `environment-isolation`
  - `runtime-tuning`
  - `threat-model`
  - `opa-policy`
  - `import-boundaries`
  - `finops-layer`
  - `secrets-rotation`
  - `modular-packs`
  - `adaptive-autoscaling`
  - `performance-lab`
  - `gitops-rollout`
  - `release-toolbox`
  - `incident-replay`
- Rewired `Taskfile.yml` and profile execution so `full` / `nightly` use the new Go-owned checks for the migrated lanes.
- Removed the replaced wrapper files from `system/gates/`, `ops-tools/`, `features/finops/`, and Traefik cert generation.
- Kept the remaining core-engine proof wrappers explicit for now:
  - `system/gates/engine/check-compose-renderer.sh`
  - `system/gates/engine/check-profile-power.sh`
  - `system/gates/hardening/check-hardening.sh`
  - `system/gates/configurator/check-configurator.sh`
  - security scan suite wrappers
  - these are now tracked by `TODO-GO-SCRIPT-DECOMMISSION-01`

Changed files:

- `Taskfile.yml`
- `TODO.md`
- active product/operator docs under `system/docs/**`
- `features/finops/config/PLAYBOOK.md`
- `ops-tools/release/run-promoted-runtime-proof.sh`
- `ops-tools/secrets/run-layer-audit.sh`
- `system/gates/hardening/check-hardening.sh`
- `system/tools/poly/internal/checkkit/**`
- `system/tools/poly/internal/certs/**`
- `system/tools/poly/internal/toolboxops/**`
- `system/tools/poly/internal/perfops/**`
- `system/tools/poly/internal/resilienceops/**`
- `system/tools/poly/internal/secretsops/**`
- `system/tools/poly/internal/finops/**`
- `system/tools/poly/internal/runtimecheck/**`
- `system/tools/poly/internal/policycheck/**`
- `system/tools/poly/internal/platformcheck/**`
- `system/tools/poly/internal/perfcheck/**`
- `system/tools/poly/internal/releasecheck/**`
- `system/tools/poly/internal/resiliencecheck/**`
- `system/tools/poly/internal/architecture/import_boundaries.go`
- `system/tools/poly/internal/cli/ops.go`
- `system/tools/poly/internal/cli/run.go`
- `system/tools/poly/internal/cli/runtime.go`
- `system/tools/poly/internal/platformops/platform.go`
- `system/tools/poly/internal/profiles/profiles.go`
- deleted wrapper files under `system/gates/`, `ops-tools/`, `features/finops/`, and `features/gateway/providers/traefik/scripts/`

Command evidence:

- `go test ./system/tools/poly/...` => PASS
- `go run ./system/tools/poly/cmd/poly gate run docs` => PASS
- `go run ./system/tools/poly/cmd/poly gate run p0` => PASS
- `go run ./system/tools/poly/cmd/poly gate check import-boundaries` => PASS
- `go run ./system/tools/poly/cmd/poly gate check environment-isolation` => PASS
- `go run ./system/tools/poly/cmd/poly gate check runtime-tuning` => PASS
- `go run ./system/tools/poly/cmd/poly gate check threat-model` => PASS
- `go run ./system/tools/poly/cmd/poly gate check opa-policy` => PASS
- `go run ./system/tools/poly/cmd/poly gate check finops-layer` => PASS
- `go run ./system/tools/poly/cmd/poly gate check secrets-rotation` => PASS
- `go run ./system/tools/poly/cmd/poly gate check modular-packs` => PASS
- `go run ./system/tools/poly/cmd/poly gate check adaptive-autoscaling` => PASS
- `go run ./system/tools/poly/cmd/poly gate check performance-lab` => PASS
- `go run ./system/tools/poly/cmd/poly gate check gitops-rollout` => PASS
- `go run ./system/tools/poly/cmd/poly gate check release-toolbox` => PASS
- `go run ./system/tools/poly/cmd/poly gate check incident-replay` => PASS
- `go run ./system/tools/poly/cmd/poly gate check root-surface` => PASS
- `go run ./system/tools/poly/cmd/poly gate check gate-ops-boundaries` => PASS
- `go run ./system/tools/poly/cmd/poly gate check architecture-heatmap` => PASS (`shell_scripts=52`, `python_gates=29`)
- `go run ./system/tools/poly/cmd/poly gate check profile-coverage` => PASS
- `go run ./system/tools/poly/cmd/poly gate run full --dry-run`
- `go run ./system/tools/poly/cmd/poly gate run nightly --dry-run`

Tradeoffs:

- This pass removes a large amount of wrapper debt, but not all of it.
- The remaining wrapper concentration is now narrow and explicit instead of repo-wide drift.
- A full Python core-engine rewrite was intentionally not hidden inside this lane; it remains a separate architectural decision if required later.

## 2026-03-04 — Go-Owned Control Plane Lock (shell/Python decommission except `doc-engine`)

Decision context:

- The repo had already frozen the public operator surface around `poly` and `Taskfile.yml`, but repo-owned shell and Python execution paths still remained scattered across gates, runtime entrypoints, release tooling, and the core proof surface.
- The next spin-off phase required a harder boundary:
  - one typed control plane,
  - job-oriented vertical slices,
  - no repo-owned shell wrappers left in the canonical path,
  - one explicit Python exception only for `doc-engine`.

What changed:

- Rewrote the canonical `core/` parser/resolver/generator proof surface into the dedicated Go `core/` module.
- Rewrote the `lanes/python` runtime lane into a Go service/healthcheck binary while keeping the lane packaging contract stable.
- Rewrote toolbox and ProxySQL runtime entrypoints into Go binaries.
- Moved docs preview and MinIO backup policy operations into Go-owned slices under `system/tools/poly/internal/**`.
- Removed repo-owned shell/Python gate wrappers and aligned governance/system/docs/contracts to the new canonical command surface.
- Locked the architecture language around job-oriented vertical slices in `system/tools/poly/internal/**`.

Changed files:

- `core/**`
- `lanes/python/**`
- `ops-tools/toolbox/**`
- `features/database/providers/mysql/pooling/proxysql/**`
- `system/tools/poly/internal/**`
- `Taskfile.yml`
- `AGENTS.md`
- `TODO.md`
- active governance and architecture docs under `system/docs/development/**`

Verification commands:

- `cd core && go test ./...` => PASS
- `cd lanes/python && go test ./...` => PASS
- `cd ops-tools/toolbox && go test ./...` => PASS
- `cd features/database/providers/mysql/pooling/proxysql && go test ./...` => PASS
- `cd tools/poly && go test ./...` => PASS
- `go run ./system/tools/poly/cmd/poly gate check compose-proof` => PASS
- `go run ./system/tools/poly/cmd/poly gate check image-hardening` => PASS
- `go run ./system/tools/poly/cmd/poly gate check release-toolbox` => PASS
- `go run ./system/tools/poly/cmd/poly gate check import-boundaries` => PASS
- `go run ./system/tools/poly/cmd/poly gate check opa-policy` => PASS
- `go run ./system/tools/poly/cmd/poly docs preview README.md --out system/gates/artifacts/docs-preview/README.preview.html` => PASS
- `go run ./system/tools/poly/cmd/poly gate run docs` => PASS
- `go run ./system/tools/poly/cmd/poly gate run p0` => PASS
- `go run ./system/tools/poly/cmd/poly gate run full --dry-run` => PASS
- `go run ./system/tools/poly/cmd/poly gate run nightly --dry-run` => PASS
- `go run ./system/tools/poly/cmd/poly gate check architecture-heatmap` => PASS (`shell_scripts=0`, `python_gates=17`)
- `go run ./system/tools/poly/cmd/poly gate check root-surface` => PASS
- `go run ./system/tools/poly/cmd/poly gate check profile-coverage` => PASS

Outcome:

- Repo-owned shell surface for canonical operator flows is now zero.
- Python remains only in `system/gates/system/docs/doc_engine/**`, `system/gates/system/docs/doc-engine.py`, and vendored third-party code.
- The control plane is now Go-owned end-to-end, with job-oriented slices instead of scattered wrapper scripts.
- The next remaining strategic work is modular extraction, not language cleanup.

## 2026-03-04 — Modular Roadmap Repack (`governance-template` before Argo live)

Decision context:

- The north-star roadmap still grouped governance-template extraction and ArgoCD live sync too loosely.
- The intended product direction is narrower:
  - mandatory v1 spin-offs are `configurator` and `doc-engine`,
  - reusable governance extraction is a separate post-v1 lane,
  - ArgoCD live sync is later deployment work, not a prerequisite for the governance-template idea.

What changed:

- Repacked `poly-modules.md` so:
  - Cycle 3 is the mandatory v1 spin-off sequence,
  - Cycle 4 is governance-template extraction or defer-on-proof,
  - Cycle 5 is ArgoCD live sync.
- Aligned `system/docs/development/product/modularization-contract-v1.md` with that sequencing.
- Added a planning boundary note in `TODO.md` so post-v1 vision cycles do not silently become active execution lanes.

Verification commands:

- `go run ./system/tools/poly/cmd/poly gate run docs` => PASS
- `go run ./system/tools/poly/cmd/poly gate check governance-references` => PASS

Outcome:

- Governance-template is now clearly separated from ArgoCD live sync.
- The roadmap no longer implies that a live Configurator API or ArgoCD proof is required for the v1 spin-off sequence.
- `TODO.md` remains the execution authority while `poly-modules.md` stays the vision layer.

## 2026-03-04 — Cycle 3 + Cycle 4 completion (`configurator`, `doc-engine`, governance-template)

Decision context:

- The modularization roadmap was repacked so governance-template extraction is separate from the later ArgoCD live-sync lane.
- The goal of this iteration was to complete Cycle 3 and Cycle 4 in one pass:
  - extract the runtime-owned split repos,
  - reintegrate the mono-repo through published contracts,
  - extract the reusable governance baseline with real reuse proof,
  - leave ArgoCD live sync as a later deployment cycle.

What changed:

- Externalized repositories are now live on GitHub and stored locally under `/mnt/e/`:
  - `poly-moly-configurator`
  - `poly-moly-doc-engine`
  - `poly-moly-governance-template`
- The split repositories were switched to public visibility for reusable source access.
- The mono-repo now consumes the external module set through:
  - `platform/registry/external-modules.lock.json`
  - `deployment/compose/compose.yaml`
  - `system/tools/poly/internal/modules/**`
- The root `configurator/` source tree was removed from the mono-repo.
- The in-repo `system/gates/system/docs/doc_engine/**` package and `system/gates/system/docs/doc-engine.py` wrapper were removed from the mono-repo.
- `Taskfile.yml`, `README.md`, active architecture docs, and product docs were rewritten to describe the split-repo state.
- `TODO.md` was collapsed to zero open items and the modular product release note was added under `system/docs/development/product/poly-modules-release-v1.md`.
- A runtime bootstrap fallback was added for split-module images:
  - if `docker pull` of the pinned external image is unavailable,
  - PolyMoly can seed the exact pinned image locally from the public repo URL and pinned revision,
  - avoiding sibling checkout coupling while keeping the image contract exact.

Why the bootstrap fallback was added:

- After the split repos were published, anonymous GHCR manifest pulls still returned `denied`.
- That made raw registry pull availability an unreliable merge-law dependency.
- The fallback keeps the contract pinned to exact repo revision and image tag, but allows local image seeding from the public source repository when package visibility is not yet open.

External repo proof:

- `gh repo view shomsy/poly-moly-configurator --json visibility,url` -> PASS (`PUBLIC`)
- `gh repo view shomsy/poly-moly-doc-engine --json visibility,url` -> PASS (`PUBLIC`)
- `gh repo view shomsy/poly-moly-governance-template --json visibility,url` -> PASS (`PUBLIC`)
- `gh run list --repo shomsy/poly-moly-configurator --limit 3` -> PASS
  - `CI` success
  - `Publish Image` success
  - workflow-dispatch `Publish Image` success
- `gh run list --repo shomsy/poly-moly-doc-engine --limit 3` -> PASS
  - `CI` success
  - `Publish Image` success
  - workflow-dispatch `Publish Image` success

External module bootstrap proof:

- `docker build -t ghcr.io/shomsy/poly-moly-doc-engine:sha-9f90c8a https://github.com/shomsy/poly-moly-doc-engine.git#9f90c8a67b2bdff4d5e4d7ae4629b19d6b0ae0dc` -> PASS
- `docker build -t ghcr.io/shomsy/poly-moly-configurator:sha-da10d1d https://github.com/shomsy/poly-moly-configurator.git#da10d1da990ddc203661b79ee7b96bed23630439` -> PASS

Main repo verification commands:

- `go test ./system/tools/poly/...` -> PASS
- `go run ./system/tools/poly/cmd/poly gate check module-contracts` -> PASS
- `go run ./system/tools/poly/cmd/poly gate check productization` -> PASS
- `go run ./system/tools/poly/cmd/poly gate check root-surface` -> PASS
- `go run ./system/tools/poly/cmd/poly gate check architecture-heatmap` -> PASS (`shell_scripts=0`, `python_gates=0`)
- `go run ./system/tools/poly/cmd/poly gate run docs` -> PASS
- `go run ./system/tools/poly/cmd/poly gate run p0` -> PASS
- `go run ./system/tools/poly/cmd/poly start --dry-run` -> PASS

Backlog outcome:

- `TODO-CONFIGURATOR-SPINOFF-01` -> CLOSED
- `TODO-DOC-ENGINE-SPINOFF-01` -> CLOSED
- `TODO-GOVERNANCE-TEMPLATE-SPINOFF-01` -> CLOSED
- `TODO.md` active scope -> `0`
- ArgoCD live sync remains a later cycle and is not active backlog work in this state.

Result:

- Cycle 3 is complete: `configurator` and `doc-engine` are split out and reintegrated by contract.
- Cycle 4 is complete: governance-template is extracted and reuse-proofed.
- The mono-repo remains coherent as the Go-first product core.
- ArgoCD live sync is now cleanly isolated as later deployment work, not a hidden dependency of the split-repo architecture.

## 2026-03-04 — Cycle 5 closure (`ArgoCD` live sync + V1 readiness lock)

Decision context:

- Cycle 5 was promoted from roadmap-only to active execution for this iteration.
- Goal: close the live GitOps proof and align roadmap/backlog/docs to the final V1-ready state.

What changed:

- Executed live ArgoCD flow in a real local kind cluster:
  - repo lock,
  - ArgoCD + Argo Rollouts bootstrap,
  - authenticated repository bridge secret,
  - stage/prod wait to `Synced/Healthy`,
  - promotion proof,
  - rollback proof.
- Updated roadmap and backlog contracts to mark Cycle 5 as complete:
  - `TODO.md`
  - `poly-modules.md`
  - `system/docs/development/product/modularization-contract-v1.md`
  - `system/docs/development/product/poly-modules-release-v1.md`
- Updated Go-first architecture contract to record completed productization phase and binary install story:
  - `system/docs/development/platform-architecture/GO_FIRST_EVOLUTION_V1.md`
- Refreshed ArgoCD and p0 artifacts used as objective evidence.

Command evidence:

- `export PATH=$PWD/.cache/bin:$PATH`
- `export KUBECONFIG=$PWD/.cache/kind/polymoly-argocd.kubeconfig`
- `kind create cluster --name polymoly-argocd --kubeconfig $KUBECONFIG` => PASS
- `go run ./system/tools/poly/cmd/poly argocd repo-lock` => PASS
- `go run ./system/tools/poly/cmd/poly argocd bootstrap --namespace argocd` => PASS
- `go run ./system/tools/poly/cmd/poly argocd repo-bridge --namespace argocd` => PASS
- `go run ./system/tools/poly/cmd/poly argocd wait --app polymoly-stage --timeout 600` => PASS
- `go run ./system/tools/poly/cmd/poly argocd wait --app polymoly-prod --timeout 600` => PASS
- `go run ./system/tools/poly/cmd/poly argocd promote --timeout 600` => PASS
- `go run ./system/tools/poly/cmd/poly argocd rollback-proof --timeout 600` => PASS
- `go test ./system/tools/poly/...` => PASS
- `task poly:build` => PASS
- `system/tools/poly/bin/poly --version` => PASS (`0.2.0-go-first`)
- `go run ./system/tools/poly/cmd/poly gate check gitops-rollout` => PASS
- `go run ./system/tools/poly/cmd/poly gate run docs` => PASS
- `go run ./system/tools/poly/cmd/poly gate run p0` => PASS

Artifacts:

- `system/gates/artifacts/argocd-live/repo-lock-checks.tsv`
- `system/gates/artifacts/argocd-live/repo-bridge-checks.tsv`
- `system/gates/artifacts/argocd-live/wait-polymoly-stage-checks.tsv`
- `system/gates/artifacts/argocd-live/wait-polymoly-prod-checks.tsv`
- `system/gates/artifacts/argocd-live/promotion-checks.tsv`
- `system/gates/artifacts/argocd-live/rollback-proof-checks.tsv`
- `system/gates/artifacts/p0/**`

Backlog outcome:

- `TODO-ARGOCD-LIVE-SYNC-01` => CLOSED
- `TODO.md` active scope remains `0`
- release-blocking TODO items remain `0`

Result:

- Cycle 5 is complete with live proof, not dry-run only.
- Roadmap, modularization contract, and release note are aligned with the executed state.
- PolyMoly V1 is now in a fully closed cycle set (Cycles 1-5 complete).

## 2026-03-04 — Policy lock alignment (doc-engine mode, evidence fail-closed, timeout model)

Decision context:

- Team consensus converged on three operational policy decisions:
  - doc-engine canonical runtime must be pinned module execution,
  - release/Argo evidence writes must fail-closed,
  - timeout handling must use one default with explicit overrides.
- The goal of this pass was to lock these decisions in normative docs to prevent drift before code-level enforcement is completed.

What changed:

- Updated `AGENTS.md` non-negotiable rules with locked policy statements for:
  - doc-engine canonical mode and local opt-in boundary,
  - evidence write fail-closed behavior and unsafe bypass contract,
  - global timeout default plus override model.
- Updated `system/docs/development/platform-architecture/GO_FIRST_EVOLUTION_V1.md` to align implementation architecture with:
  - doc-engine execution lock,
  - timeout metadata requirement,
  - fail-closed evidence and timeout constraints.
- Updated `system/docs/development/governance/ci-profile-contract.md` so CI profile law also reflects:
  - canonical docs runtime mode in merge-law jobs,
  - timeout and evidence policy expectations for CI.

Command evidence:

- `go run ./system/tools/poly/cmd/poly gate check governance-references` => PASS
- `go run ./system/tools/poly/cmd/poly gate check ci-profile-contract` => PASS
- `go run ./system/tools/poly/cmd/poly gate run docs` => PASS

Backlog linkage:

- Active bug backlog already contains execution gaps required to enforce these locks in code:
  - `BUG-EVIDENCE-HARD-FAIL-01`
  - `BUG-COMMAND-TIMEOUT-POLICY-01`
  - `BUG-DOC-ENGINE-PINNED-RUNTIME-01`
  - `BUG-ORCHESTRATION-TEST-COVERAGE-01`

Result:

- Team policy decisions are now explicitly locked in governance/architecture docs.
- Drift risk between review conclusions and repo law is reduced.
- Remaining implementation work is clearly scoped to active bug items.

## 2026-03-04 — Backlog repack from multi-review perspectives (Caki/Anta/Codex)

Decision context:

- Multiple independent reviews converged on overlapping risks, but action items were spread across narrative reports.
- Goal: normalize all unresolved points into canonical backlog files with clear TODO/BUG ownership and acceptance criteria.

What changed:

- Expanded `BUGS.md` with additional risk/regression entries for:
  - external module supply-chain hardening (digest pinning, signature/provenance, distribution reliability),
  - core determinism/parser compatibility risks,
  - governance reference coverage.
- Expanded `TODO.md` with implementation lanes for:
  - module UX contract versioning,
  - registry schema validation and posture monotonicity gate,
  - starter/productization and CI optimization tracks,
  - single source-of-truth backlog snapshot.

Command evidence:

- `go run ./system/tools/poly/cmd/poly gate check governance-references` => PASS
- `go run ./system/tools/poly/cmd/poly gate check ci-profile-contract` => PASS

Result:

- Review conclusions are now represented as active, tracked backlog work instead of ad-hoc discussion.
- TODO vs BUG ownership is explicit and aligned with AGENTS intake rules.

## 2026-03-04 — Contract Integrity whiteboard conversion into active backlog

Decision context:

- Iteration 1 brainstorming produced concrete contract-integrity requirements that were not fully explicit in active backlog wording.
- Goal: convert those requirements into executable backlog items with clear acceptance policy and blocker semantics.

What changed:

- Extended `TODO.md` with explicit Contract Integrity lanes for:
  - major-only external contract compatibility policy with required/optional capability enforcement,
  - transactional `poly lock update` with digest capture and gate-backed compatibility validation,
  - governance front-matter scope metadata and stale-doc diff-aware gate.
- Extended `BUGS.md` with additional active risks for:
  - external contract mismatch hard-block behavior,
  - missing system/docs/code scope drift guard,
  - canonical gate entrypoint drift (`AGENTS.md` declares `bash system/gates/run` while repo executes via `poly gate run`),
  - review-pack command drift (`AGENTS.md` declares `./merge-files.sh` while repo uses `poly review pack`).

Command evidence:

- `bash system/gates/run docs` => FAIL (`No such file or directory`) [captured as `BUG-CANONICAL-GATE-ENTRYPOINT-DRIFT-01`]
- `./merge-files.sh .` => FAIL (`No such file or directory`) [captured as `BUG-REVIEW-PACK-COMMAND-DRIFT-01`]
- `go run ./system/tools/poly/cmd/poly gate run docs` => PASS
- `go run ./system/tools/poly/cmd/poly review pack .` => PASS (generated `polymoly.txt`)

Result:

- Whiteboard contract-integrity decisions are now represented as tracked TODO/BUG work with acceptance criteria.
- A real governance execution-path conflict is now explicitly recorded in active bug backlog.

## 2026-03-05 — TODO Backlog History Migration (open-only policy cleanup)

Decision context:

- `TODO.md` contract says active unresolved items only, but contained a long closed history section.
- Team requested a cleaner model: `TODO.md` as active backlog, evidence archives as changelog/history.

What changed:

- Closed TODO history was moved to evidence/changelog tracking.
- `TODO.md` was prepared for active brainstorm-driven open items only.

Migrated closed TODO IDs:

- `TODO-V2-PRODUCT-PLAN-01`
- `TODO-MODULE-UX-CONTRACT-01`
- `TODO-LOCK-UPDATE-TRANSACTIONAL-01`
- `TODO-GOVERNANCE-FRONTMATTER-SCOPE-01`
- `TODO-STALE-DOC-DIFF-GATE-01`
- `TODO-REGISTRY-SCHEMA-VALIDATION-01`
- `TODO-PROFILE-MONOTONICITY-GATE-01`
- `TODO-STARTER-5MIN-WIN-01`
- `TODO-CI-CACHE-OPTIMIZATION-01`
- `TODO-CORE-TYPED-RENDERMODEL-01`
- `TODO-BACKLOG-SNAPSHOT-SOT-01`
- `TODO-PHP-RUNTIME-SURFACE-RATIONALIZATION-01`
- `TODO-RELEASE-BINARY-CANONICAL-01`
- `TODO-LANE-NAMING-SEMANTIC-ALIGN-01`
- `TODO-PARSER-TYPED-CANONICALIZATION-01`
- `TODO-POLY-SELF-OBSERVABILITY-01`
- `TODO-GOVERNANCE-MODE-CONTRACT-01`

Outcome:

- `TODO.md` is now ready to operate as a true active-only queue.
- Archive keeps historical closure trail as changelog evidence.

## 2026-03-06 — V3 Full Closure Iteration (Plugin platform + runtime inspection + product contracts)

Decision context:

- Active backlog was reduced to V3-only items (14 open tasks).
- Goal was a full single-iteration closure for V3 scope, including implementation and contract docs.

What changed (code):

- Added V3 plugin platform core:
  - `poly plugin search/install/list/update/remove`
  - managed plugin lock (`.polymoly/plugins.lock.yaml`)
  - executable bridge fallback (`poly <cmd>` -> managed plugin or `poly-<cmd>`)
  - trust enforcement (signature mode, source policy, digest checks, unsafe dual gate)
- Added runtime/operator V3 surfaces:
  - `poly health`
  - `poly diff --runtime`
  - `poly demo`
  - `poly blueprint`
  - `poly open`
- Added discoverability hardening:
  - unknown command suggestions and deterministic fix hints.

What changed (system/docs/contracts):

- Added normative V3 docs:
  - `v3-plugin-contract.md`
  - `v3-plugin-trust-policy.md`
  - `v3-golden-path-60s-contract.md`
  - `v3-blueprint-contract.md`
  - `v3-dashboard-optional-contract.md`
  - `v3-template-marketplace-contract.md`
  - `v3-coverage-matrix.md`
  - `v3/README.md`
  - `v3/idea-lineage.md`
- Updated plan/index docs:
  - `v3-future-plan.md`
  - `v3-idea-pool.md`
  - `system/docs/development/product/README.md`
- Updated governance decisions:
  - `DEC-2026-03-06-13` to `DEC-2026-03-06-16`.

Backlog outcome:

- Closed all V3 TODO items (`14/14`).
- `TODO.md` now reports `0 open items`.

Verification commands:

- `go test ./system/tools/poly/...` -> PASS
- `./system/tools/poly/bin/poly gate run p0` -> PASS
- `./system/tools/poly/bin/poly gate run docs` -> PASS
- `./system/tools/poly/bin/poly review pack .` -> PASS

Outcome:

- V3 backlog scope is fully closed for this milestone iteration.
- Product now has implemented extensibility baseline, runtime observability surfaces, and formalized V3 governance contracts.
