---
description: "Execution Lifecycle — Agent Harness Execution Substrate"
version: 1.0.0
---

# Execution Lifecycle

Version: 1.0.0
Status: Normative
Scope: `.agents/.rules/governance/execution/`

This document defines the execution lifecycle for the Agent Harness execution substrate.

---

## 1. Lifecycle States

| State       | Meaning                                | Next States        |
|:------------|:---------------------------------------|:-------------------|
| CREATED     | Session initialized, ID generated      | PLANNED            |
| PLANNED     | Tokens validated, nonce registered     | EXECUTING          |
| EXECUTING   | Command running under sandbox          | VALIDATING         |
| VALIDATING  | Post-execution boundary enforcement    | REPLAYABLE, FAILED |
| REPLAYABLE  | All checks passed, evidence sealed     | (terminal)         |
| FAILED      | Boundary violation detected            | ROLLED_BACK        |
| ROLLED_BACK | Mutations reverted, evidence preserved | (terminal)         |
| INVALIDATED | Seal verification failed               | (terminal)         |
| EXPIRED     | Lease expired during execution         | (terminal)         |

---

## 2. State Transitions

### 2.1 CREATED → PLANNED

Occurs when:

- Capability tokens validated (parent → child narrowing)
- Nonce registered in nonce registry
- Revocation check passes

Fails when:

- Parent token revoked
- Nonce already used (replay attack)
- Delegation narrowing violated (escalation attempt)

### 2.2 PLANNED → EXECUTING

Occurs when:

- Approval enforcement passes (danger class × trust tier)
- Domain rules resolved
- Baseline file state captured

Fails when:

- Command classified as FORBIDDEN
- Command classified as DANGEROUS without approval
- Trust tier does not permit the operation

### 2.3 EXECUTING → VALIDATING

Occurs when:

- Command completes (success or failure exit code)
- Timeout expires
- Resource limit exceeded

### 2.4 VALIDATING → REPLAYABLE

Occurs when:

- No trust boundary violations
- No symlink escapes
- File mutations within tier constraints

Actions:

- HMAC seal applied to manifest
- Entry appended to audit chain
- Execution manifest written to evidence
- Delegation manifest written to evidence

### 2.5 VALIDATING → FAILED → ROLLED_BACK

Occurs when:

- Trust boundary violation detected
- Symlink escape in restricted tier
- Governance path modified by wrong tier

Actions:

- Created files deleted
- Modified/deleted files restored via git checkout
- Mutation journal marked rollback_executed = true
- Evidence sealed (violations are evidence, not discarded)

### 2.6 Any → INVALIDATED

Occurs when:

- HMAC seal verification fails on existing manifest
- Audit chain integrity broken
- Manifest tampered after sealing

### 2.7 Any → EXPIRED

Occurs when:

- Capability token lease expires during execution
- Nonce expires before completion

---

## 3. Execution Session

### 3.1 Session Creation

Each execution session is created by `execution_runtime.py run`:

```bash
python3 .agents/.rules/skills/bin/execution_runtime.py run \
    --task "description" \
    --tier "READ_ONLY" \
    --scope "security" \
    --cmd "echo hello" \
    --dir /path/to/project
```

### 3.2 Dry Run

```bash
python3 .agents/.rules/skills/bin/execution_runtime.py run \
    --task "description" \
    --tier "READ_ONLY" \
    --scope "security" \
    --cmd "echo hello" \
    --dry-run \
    --dir /path/to/project
```

Dry run validates the execution path without running the command.
It produces: execution_id, danger classification, approval decision.

### 3.3 Session Output

On success:

- execution-manifest-<exec_id>.json in evidence/execution/
- delegation-manifest-<deleg_id>.json in evidence/execution/
- Audit chain entry appended in evidence/security/

---

## 4. Evidence Lifecycle

### 4.1 Evidence Creation Order

1. Execution manifest (with HMAC seal)
2. Delegation manifest
3. Audit chain entry (appended)
4. Nonce registry entry (appended)

### 4.2 Evidence Correlation

All evidence is cross-referenced by ID:

```
execution_manifest.execution_id
  → delegation_manifest.execution_id
  → replay_contract.execution_id
  → hmac_audit_chain[entry].manifest_data.execution_id
  → nonce_registry[entry].token_id (via capability_token.token_id)
```

### 4.3 Evidence Retention

Evidence is never deleted. Old evidence may be archived but not removed.
Tampered evidence must be preserved as evidence of tampering.

---

## 5. Replay Lifecycle

### 5.1 Replay Initiation

```bash
python3 .agents/.rules/skills/bin/execution_runtime.py replay <exec_id> --dir /path/to/project
```

### 5.2 Replay Steps

1. Load execution manifest
2. Verify HMAC seal
3. Verify capability token signature
4. Check nonce status
5. Verify audit chain integrity
6. Scan for dependency drift
7. Score reproducibility
8. Write replay manifest

### 5.3 Replay Outcomes

| Score              | Meaning                                        |
|:-------------------|:-----------------------------------------------|
| FULL_REPLAYABLE    | Perfect reproduction: seal, nonce, drift, exit |
| PARTIAL_REPLAYABLE | Seal valid but environment drifted             |
| NON_REPLAYABLE     | Seal broken or critical dependency mutated     |

---

## 6. Failure Recovery

### 6.1 Trust Boundary Violation

On violation:

1. Rollback created files (delete)
2. Rollback modified files (git checkout)
3. Record violations in mutation journal
4. Seal the violation evidence
5. Transition to ROLLED_BACK

### 6.2 Seal Invalidation

If a seal becomes invalid:

1. Mark manifest as INVALIDATED
2. Do NOT attempt to re-seal
3. Preserve as evidence of tampering
4. Flag in audit chain verification

### 6.3 Interrupted Execution

If execution is interrupted:

1. Manifest may not exist
2. Nonce may be registered but execution incomplete
3. This is detected as orphan nonce during audit
4. Manual cleanup required

---

## 7. Approval Lifecycle

### 7.1 Approval Flow

1. Command classified (SAFE, REVIEW, DANGEROUS, FORBIDDEN)
2. Trust tier resolved (T0-T3)
3. Approval decision matrix applied
4. If approval required → human intervention
5. If auto-approved → execution proceeds
6. Approval record written to evidence

### 7.2 Approval Record

Approval records are written as JSON in the execution evidence directory.
They link to the execution that required approval.

---

## 8. Limitations

```
File-backed registries are not crash-atomic.
Lost HMAC key means lost verification capability.
Replay assumes deterministic environment.
Rollback requires git-tracked files.
Resource limits are Unix-only.
No real-time monitoring.
```

These are intentional design tradeoffs, not bugs.
