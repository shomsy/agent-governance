---
description: "Execution Substrate Architecture — Unified AI SDLC Runtime"
version: 1.0.0
---

# Execution Substrate Architecture

Version: 1.0.0
Status: Normative
Scope: `.agents/.rules/governance/execution/`

This document defines the canonical architecture for the Agent Harness execution substrate —
the unified runtime that transforms Agent Harness from a "governance toolkit" into an
"operational AI SDLC runtime".

---

## 1. Design Principles

```
Local-first:    No network dependencies, no distributed system fantasy.
Deterministic:  Same inputs produce same evidence. No hidden state.
Auditable:      Every claim points to machine-readable evidence.
Minimal:        Real integrity, not crypto theater.
Replay-aware:   Evidence can be re-verified, not just trusted.
Explainable:    Every denial includes why. Every seal includes what was sealed.
```

---

## 2. Trust Model

### 2.1 Trust Tiers

| Tier | Name           | Autonomy                  | Approval                |
|:-----|:---------------|:--------------------------|:------------------------|
| T0   | ReadOnly       | Read workspace only       | Never                   |
| T1   | WorkspaceWrite | Read/write workspace      | On destructive ops      |
| T2   | ExtendedWrite  | Read/write + dependencies | On new deps or external |
| T3   | FullAccess     | Unrestricted              | Always on first use     |

Tier assignment is based on task lane (see approval-policy.md).

### 2.2 Danger Classification

Every command is classified before execution:

| Class     | Meaning                                        | Action              |
|:----------|:-----------------------------------------------|:--------------------|
| SAFE      | Read-only, no side effects                     | Execute immediately |
| REVIEW    | Writes within workspace, no danger patterns    | Log, execute        |
| DANGEROUS | Matches danger patterns (rm -rf, sudo, etc.)   | Require approval    |
| FORBIDDEN | Always blocked (rm -rf /, pipe-to-shell, etc.) | Reject with reason  |

Danger classification is independent of trust tier.
A T3 agent still cannot execute FORBIDDEN commands.

### 2.3 Sandbox Boundary

- Dynamically-generated agent code is **Untrusted Code**.
- Must run with `shell=False` (no shell metacharacters).
- Resource limits applied per tier (memory, CPU time, processes, file size).
- Symlink escape detection active.
- Path traversal protection via realpath validation.

---

## 3. Execution Lifecycle

### 3.1 States

```
CREATED     → Session initialized, ID generated
PLANNED     → Capability tokens validated, nonce registered
EXECUTING   → Command running under sandbox constraints
VALIDATING  → Post-execution boundary enforcement, mutation analysis
REPLAYABLE  → All checks passed, evidence sealed
FAILED      → Boundary violation detected
ROLLED_BACK → Mutations reverted, evidence preserved
INVALIDATED → Seal broken, evidence corrupted
EXPIRED     → Lease expired during execution
```

### 3.2 Canonical Flow

```
REQUEST
  → approval          (trust tier resolved, danger classified)
  → sandbox           (command parsed, shell=False enforced)
  → manifest          (execution manifest created)
  → execute           (command runs under resource limits)
  → validate          (trust boundary enforced, mutations analyzed)
  → seal              (HMAC-SHA256 seal applied)
  → chain             (entry appended to audit chain)
  → evidence          (execution evidence written)
  → closure           (final status emitted)
```

---

## 4. Execution Identity

### 4.1 Deterministic IDs

- `execution_id`: `exec-<uuid>` — unique per execution session
- `delegation_id`: `deleg-<uuid>` — unique per delegation context
- `nonce`: `<uuid>` — prevents replay attacks, expires with lease

### 4.2 Identity Components

Every execution identity includes:

```json
{
  "execution_id": "exec-uuid",
  "delegation_id": "deleg-uuid",
  "nonce": "uuid",
  "task": "task description",
  "trust_tier": "READ_ONLY",
  "domain_scope": "security",
  "actor": "agent-session-id",
  "project": "project-name",
  "profile_chain": ["php", "library"],
  "initiated_at": 1779112800.0
}
```

---

## 5. Manifest Chain

### 5.1 Execution Manifest

Primary artifact of each execution. Contains:

- Identity (execution_id, delegation_id, nonce)
- Task context (task, tier, scope, domain rules loaded)
- Capability token (tools, scopes, trust tier, lease)
- Authority lineage (initiator, parent token, capability signature)
- Environment snapshot (OS, Python version, sanitized env)
- Mutation journal (created, modified, deleted files, violations)
- Replay contract (command, expected exit code, checksum)
- Telemetry (timing, memory, sandbox mode)
- Integrity seal (HMAC-SHA256, key_id, sealed_at)

### 5.2 Delegation Manifest

Tracks parent-child token relationships:

```json
{
  "delegation_id": "deleg-uuid",
  "execution_id": "exec-uuid",
  "nonce": "uuid",
  "token": { ... capability_token ... },
  "parent_token_id": "operator-root",
  "narrowing_valid": true,
  "status": "SUCCESS"
}
```

### 5.3 Replay Manifest

Links original execution to replay attempt:

```json
{
  "replay_id": "replay-uuid",
  "execution_id": "exec-uuid",
  "original_seal": "hmac-sha256-hex",
  "replay_attempted_at": 1779112800.0,
  "reproducibility_score": "FULL_REPLAYABLE",
  "drift_count": 0,
  "seal_valid": true,
  "nonce_valid": true,
  "exit_code_match": true,
  "mutation_count_match": true
}
```

### 5.4 Seal Chain (HMAC Audit Chain)

Each execution appends one entry to the HMAC audit chain:

```json
{
  "chain_position": 0,
  "manifest_data": { "execution_id": "...", "hmac_seal": "...", ... },
  "entry_hash": "hmac-sha256(manifest)",
  "chain_hash": "hmac-sha256(prev_chain_hash + manifest)",
  "timestamp": 1779112800.0
}
```

Chain properties:

- Tamper-evident: modifying any entry breaks its entry_hash
- Order-protected: modifying order breaks chain_hash linkage
- Locally verifiable: same key recomputes all hashes

---

## 6. Replay Model

### 6.1 Reproducibility Scoring

| Score              | Criteria                                                              |
|:-------------------|:----------------------------------------------------------------------|
| FULL_REPLAYABLE    | Seal valid, nonce recorded, zero drift, exit matches, mutations match |
| PARTIAL_REPLAYABLE | Seal valid, some drift or env changed, core command replayable        |
| NON_REPLAYABLE     | Seal invalid, nonce expired, or critical dependency mutated           |

### 6.2 Replay Verification Steps

1. Load execution manifest by execution_id
2. Verify HMAC seal (tamper check)
3. Verify capability token signature
4. Verify nonce was recorded (not replayed)
5. Scan for dependency drift (original vs current checksums)
6. Verify audit chain integrity
7. Replay payload command, assert deterministic exit code
8. Emit replay manifest with reproducibility score

---

## 7. Approval Flow

### 7.1 Approval Decision Matrix

```
Command classified as:
  SAFE      → T0-T3: execute, log evidence
  REVIEW    → T0: require approval
              T1-T3: execute, log evidence
  DANGEROUS → T0-T2: require approval
              T3: execute on first use, then auto-approve per session
  FORBIDDEN → Always: reject with explain-why-denied
```

### 7.2 Approval Record

```json
{
  "approval_id": "approval-uuid",
  "execution_id": "exec-uuid",
  "command": "echo hello",
  "danger_class": "DANGEROUS",
  "trust_tier": "T1",
  "requested_at": 1779112800.0,
  "decision": "approved",
  "decision_by": "human",
  "rationale": "required for build step"
}
```

---

## 8. Evidence Lineage

### 8.1 Evidence Types

| Type                | Location                                 | Format |
|:--------------------|:-----------------------------------------|:-------|
| Execution manifest  | `.agents/management/evidence/execution/` | JSON   |
| Delegation manifest | `.agents/management/evidence/execution/` | JSON   |
| Replay manifest     | `.agents/management/evidence/execution/` | JSON   |
| Approval record     | `.agents/management/evidence/execution/` | JSON   |
| HMAC audit chain    | `.agents/management/evidence/security/`  | JSONL  |
| HMAC key            | `.agents/management/evidence/security/`  | Binary |
| Nonce registry      | `.agents/management/evidence/security/`  | JSONL  |
| Revocation registry | `.agents/management/evidence/security/`  | JSONL  |

### 8.2 Correlation Model

All evidence is machine-referenced, not dumped:

```
execution_manifest
  ├── hmac_seal → hmac_audit_chain[chain_position]
  ├── nonce → nonce_registry[nonce]
  ├── capability_token → delegation_manifest[token]
  ├── parent_token_id → authority_lineage
  ├── replay_contract → replay_manifest[execution_id]
  └── mutation_journal → file system state diff
```

### 8.3 Orphan Detection

Evidence without a corresponding execution manifest is orphan.
Orphan evidence is flagged during release readiness checks.

---

## 9. Runtime States

### 9.1 State Machine

```
                    ┌─────────┐
                    │ CREATED │
                    └────┬────┘
                         │
                    ┌────┴────┐
                    │ PLANNED │
                    └────┬────┘
                         │
                    ┌────┴─────┐
                    │ EXECUTING│
                    └────┬─────┘
                         │
                    ┌────┴──────┐
                    │ VALIDATING│
                    └────┬──────┘
                         │
               ┌─────────┼─────────┐
               │         │         │
          ┌────┴───┐ ┌───┴───┐ ┌──┴─────┐
          │REPLAYABLE│ │FAILED│ │EXPIRED │
          └────┬────┘ └───┬───┘ └────────┘
               │          │
               │     ┌────┴──────┐
               │     │ROLLED_BACK│
               │     └───────────┘
               │
          ┌────┴─────────┐
          │ INVALIDATED   │ (seal broken)
          └──────────────┘
```

### 9.2 State Transitions

- CREATED → PLANNED: tokens validated, nonce registered
- PLANNED → EXECUTING: command begins
- EXECUTING → VALIDATING: command completes
- VALIDATING → REPLAYABLE: no violations
- VALIDATING → FAILED: violations detected
- FAILED → ROLLED_BACK: mutations reverted
- Any → INVALIDATED: seal verification fails
- Any → EXPIRED: lease expired

---

## 10. Failure Model

### 10.1 Failure Types

| Failure             | Detection                   | Recovery                                      |
|:--------------------|:----------------------------|:----------------------------------------------|
| Trust boundary      | Mutation analysis           | Rollback created files, git checkout modified |
| Seal invalidation   | HMAC verification           | Mark INVALIDATED, preserve evidence           |
| Nonce replay        | Nonce registry check        | Reject execution, log evidence                |
| Token escalation    | Capability token validation | Revoke token, reject execution                |
| Symlink escape      | PathGuard detection         | Reject, log evidence                          |
| Resource exhaustion | Timeout / resource limits   | Kill process, log evidence                    |
| Dependency drift    | Checksum comparison         | Flag PARTIAL_REPLAYABLE                       |
| Chain corruption    | Audit chain verification    | Mark from broken index onward                 |

### 10.2 Rollback

On trust boundary violation:

1. Delete all created files
2. `git checkout --` all modified/deleted files
3. Mark mutation_journal.rollback_executed = true
4. Transition to ROLLED_BACK state
5. Seal the violation evidence (do not discard)

---

## 11. Local-First Assumptions

```
No network calls for execution.
No PKI or certificate infrastructure.
No database dependencies — file-backed JSONL registries.
No distributed coordination — single process.
No blockchain — HMAC chain is sufficient for tamper evidence.
No enterprise crypto marketing — HMAC-SHA256, local key.
```

### 11.1 Key Management

- HMAC key: 256-bit random, stored at `.agents/management/evidence/security/hmac-key.bin`
- Permissions: 0o600 (owner read/write only)
- Key ID: SHA-256 hash of key, first 12 hex chars
- Auto-generated on first use if not present
- Key rotation: delete old key, generate new — old seals become unverifiable

---

## 12. Multi-Agent Preparation

### 12.1 Delegation Metadata

Schema supports parent/child execution without implementing distributed orchestration:

```json
{
  "authority_lineage": {
    "initiator": "Operator",
    "parent_token_id": "operator-root",
    "capability_signature": "sha256-hex"
  }
}
```

### 12.1.1 Delegation Narrowing

Child tokens must be strict subsets of parent:

- Child tools ⊆ Parent tools
- Child scopes ⊆ Parent scopes
- Child trust tier ≤ Parent trust tier

### 12.2 Ownership

- Each execution has one initiator (human or parent agent)
- Each execution has one capability token
- Token revocation propagates to descendants

### 12.3 What Is NOT Implemented

- Networked multi-agent communication
- Distributed lock or consensus
- Cross-process execution coordination
- Agent discovery or registry

These are prepared for via schema and lineage metadata.

---

## 13. Subsystem Integration

### 13.1 Existing Subsystems

| Subsystem              | Role                           | Integration Point                            |
|:-----------------------|:-------------------------------|:---------------------------------------------|
| command_sandbox.py     | Safe subprocess execution      | Command parsing, whitelist, resource limits  |
| crypto_seals.py        | HMAC integrity seals           | Seal creation, verification, audit chain     |
| substrate_security.py  | Security primitives            | Nonce, revocation, env sanitizer, path guard |
| execution_analysis.py  | Graph analysis                 | Execution graph, compression audit           |
| replay-evidence.py     | Evidence replay                | Validation replay, event stream              |
| execution-substrate.py | Current orchestration (legacy) | Superseded by execution_runtime.py           |

### 13.2 New Orchestrator

`execution_runtime.py` is the canonical entrypoint that unifies all subsystems.
It imports and coordinates existing utilities as reusable components, not standalone tools.

---

## 14. Limitations

```
File-backed registries are not atomic across crashes.
HMAC key is local — lost key means lost verification.
Replay assumes deterministic environment (time, random, network).
Rollback via git checkout assumes git-tracked files.
Resource limits are Unix-only (no-op on Windows).
Nonce registry grows unbounded (manual cleanup needed).
No real-time monitoring or alerting.
```

These are honest limitations, not bugs. They define the boundary of what this substrate guarantees.
