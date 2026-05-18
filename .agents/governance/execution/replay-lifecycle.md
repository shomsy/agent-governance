---
description: "Replay Lifecycle — Agent Harness Execution Substrate"
version: 1.0.0
---

# Replay Lifecycle

Version: 1.0.0
Status: Normative
Scope: `.agents/.rules/governance/execution/`

This document defines the replay lifecycle for the Agent Harness execution substrate.

Replay is the process of verifying that an existing execution can be reproduced
and that its evidence remains intact.

---

## 1. Purpose

Replay serves three purposes:

1. **Integrity verification**: Prove the execution manifest has not been tampered.
2. **Reproducibility scoring**: Classify how replayable an execution is.
3. **Drift detection**: Identify environmental changes between execution and replay time.

---

## 2. Replay Initiation

```bash
python3 .agents/.rules/skills/bin/execution_runtime.py replay <exec_id> --dir /path/to/project
```

The execution_id references an existing execution manifest in
`.agents/management/evidence/execution/execution-manifest-<exec_id>.json`.

---

## 3. Replay Verification Steps

### 3.1 Seal Verification

The HMAC-SHA256 seal on the execution manifest is recomputed and compared
to the stored seal. If they differ, the manifest has been tampered.

### 3.2 Token Signature Verification

The capability token signature is recomputed from the token fields
and compared to the stored signature. If they differ, the token has
been modified (context poisoning attempt).

### 3.3 Nonce Verification

The nonce from the execution is checked against the nonce registry.
It may be expired (expected for old executions) but should still be
recorded. If the nonce is not in the registry at all, the execution
may be fabricated.

### 3.4 Audit Chain Verification

The entire HMAC audit chain is verified:

- Each entry_hash is recomputed
- Each chain_hash linkage is verified
- If any entry is broken, the chain is invalid from that point

### 3.5 Dependency Drift Scan

The file checksums from the original execution (stored in
`context_package.dependency_checksums`) are compared against
the current filesystem state.

Drift types:

- **missing**: file existed at execution time, no longer exists
- **mutated**: file exists but content has changed

### 3.6 Replay Contract

The replay_contract in the manifest specifies:

- `payload_command`: the original command
- `expected_exit_code`: what the command returned
- `expected_mutation_count`: how many files were modified

These are compared against the replay attempt.

---

## 4. Reproducibility Scoring

### 4.1 FULL_REPLAYABLE

Criteria:

- HMAC seal valid
- Capability token signature valid
- Zero dependency drift
- Exit code matches
- Mutation count matches

Meaning: The execution environment is identical to the original.
The execution could be reproduced deterministically.

### 4.2 PARTIAL_REPLAYABLE

Criteria:

- HMAC seal valid
- Capability token signature valid
- Some dependency drift OR environment changed
- Core command is still replayable

Meaning: The evidence is intact but the environment has changed.
Reproduction may yield different results due to environmental factors.

### 4.3 NON_REPLAYABLE

Criteria:

- HMAC seal invalid (tamper detected)
- Nonce not in registry (fabricated execution)
- Critical dependency mutated

Meaning: The execution evidence cannot be trusted.
The manifest may have been tampered or the environment is too different.

---

## 5. Replay Manifest

Each replay attempt produces a replay manifest:

```json
{
  "replay_id": "replay-uuid",
  "execution_id": "exec-uuid",
  "original_seal": "hmac-sha256-hex",
  "replay_attempted_at": 1779112800.0,
  "reproducibility_score": "FULL_REPLAYABLE",
  "seal_valid": true,
  "nonce_valid": true,
  "nonce_expired": false,
  "token_signature_valid": true,
  "audit_chain_valid": true,
  "drift_count": 0,
  "drift_details": [],
  "exit_code_match": true,
  "mutation_count_match": true,
  "notes": []
}
```

Replay manifests are stored in `.agents/management/evidence/execution/replay-manifest-<replay_id>.json`.

---

## 6. Replay and Evidence Integrity

### 6.1 Replay Does Not Modify Evidence

Replay reads existing manifests and produces new replay manifests.
It does NOT modify the original execution manifest or audit chain.

### 6.2 Multiple Replays Allowed

The same execution_id can be replayed multiple times.
Each replay produces a new replay_manifest with its own replay_id.

### 6.3 Replay as Evidence

A replay manifest IS evidence about the original execution.
It records the state of integrity at replay time.

---

## 7. Replay Limitations

```
Replay does not re-execute the original command.
It verifies integrity and scores reproducibility.
Full command re-execution would require the same environment.
Deterministic replay of I/O-bound commands is not possible.
Time-dependent commands (date, sleep) will differ.
Network-dependent commands cannot be deterministically replayed.
```

---

## 8. Automated Replay

Replay should be run as part of:

- Release readiness gates
- Periodic integrity audits
- Before merging significant changes
- After governance modifications

The `replay-integrity-test.sh` test suite automates replay verification.
