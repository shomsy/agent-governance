# SECURITY.md — Agent Harness Threat Model & Security Controls

Version: 1.0.0
Status: Normative / Local
Scope: `.agents/**`, `EVIDENCE/**`, `*.sh`, `.agents/skills/bin/**/*.py`

## 0) Security Posture Summary

Agent Harness is an **AI execution operating substrate** that runs untrusted
prompts through governed execution lanes. The security model must survive:

- Hostile prompt injection
- Malicious agent behavior
- Subprocess escape attempts
- Evidence tampering
- Token replay attacks
- Delegation escalation
- Environment poisoning
- Path traversal attacks
- Concurrent state corruption

## 1) Threat Model (STRIDE)

### 1.1 Spoofing

| ID | Threat | Surface | Severity | Mitigation |
|----|--------|---------|----------|------------|
| SP-01 | Agent impersonates another agent's identity | Delegation manifests | HIGH | Capability token signatures with SHA-256 lineage seals |
| SP-02 | Forged evidence files claim false validation | EVIDENCE/**, evidence/generated/** | HIGH | SHA-256 hash verification in verify-governance.sh |
| SP-03 | Replay of expired capability tokens | execution-substrate.py | MEDIUM | Lease expiration + nonce validation (see §3) |

### 1.2 Tampering

| ID | Threat | Surface | Severity | Mitigation |
|----|--------|---------|----------|------------|
| TM-01 | Evidence file modification after generation | .agents/management/evidence/** | CRITICAL | Immutable append-only index with hash chain |
| TM-02 | Governance rule modification during execution | .agents/governance/** | HIGH | Frozen baseline (.agents/.rules) + trust boundary enforcement |
| TM-03 | Replay contract manipulation | execution-manifest-*.json | HIGH | Replay contract checksums + drift detection |
| TM-04 | Mutation journal corruption | mutation_journal in manifests | MEDIUM | Pre/post state hash snapshots |
| TM-05 | Log injection / fake telemetry | telemetry fields | MEDIUM | Telemetry sealed after execution, not before |

### 1.3 Repudiation

| ID | Threat | Surface | Severity | Mitigation |
|----|--------|---------|----------|------------|
| RP-01 | Agent denies executing a task | Execution manifests | HIGH | Authority lineage chain (initiator → parent → child) |
| RP-02 | Evidence destruction to hide failures | EVIDENCE/**, evidence/** | HIGH | Hash chain prevents silent deletion without detection |
| RP-03 | Governance bypass without audit trail | Hook system | MEDIUM | pre-tool-use.sh logs all decisions |

### 1.4 Information Disclosure

| ID | Threat | Surface | Severity | Mitigation |
|----|--------|---------|----------|------------|
| ID-01 | Secret leakage through command output | subprocess stdout/stderr | HIGH | is_dangerous_command() filter in lib.sh |
| ID-02 | Evidence files contain sensitive data | .agents/management/evidence/raw/** | MEDIUM | Evidence retention policies + archive encryption support |
| ID-03 | Environment variable exfiltration | env injection in execute() | HIGH | Whitelist-only env propagation (see §4) |

### 1.5 Denial of Service

| ID | Threat | Surface | Severity | Mitigation |
|----|--------|---------|----------|------------|
| DS-01 | Infinite evidence growth fills disk | evidence/** | HIGH | Retention policies + storage quotas (Phase 4) |
| DS-02 | Governance resolution loop | profile-resolution-algorithm.md | MEDIUM | Max resolution depth + cycle detection |
| DS-03 | Fork bomb via subprocess | execute() shell=True | CRITICAL | Process limits + timeout enforcement (see §5) |
| DS-04 | Concurrent execution deadlock | Lock files | MEDIUM | Stale lock cleanup + timeout (Phase 6) |

### 1.6 Elevation of Privilege

| ID | Threat | Surface | Severity | Mitigation |
|----|--------|---------|----------|------------|
| EP-01 | Child token requests higher trust tier | validate_delegation() | CRITICAL | Tier rank comparison blocks escalation |
| EP-02 | Scope expansion beyond delegation | allowed_scopes narrowing | HIGH | Strict subset validation |
| EP-03 | Tool set expansion | allowed_tools narrowing | HIGH | Strict subset validation |
| EP-04 | Confused deputy: agent acts with inherited authority it shouldn't have | Delegation chain | HIGH | Authority lineage chain + capability narrowing proofs (Phase 5) |
| EP-05 | Path traversal escapes sandbox | file operations | HIGH | Path normalization + scope validation (see §6) |

## 2) Attack Surface Inventory

### 2.1 External Surfaces

| Surface | Entry Point | Trust Boundary |
|---------|-------------|----------------|
| User prompts | resolve-task-context.py | Prompt classification → lane assignment |
| Shell commands | pre-tool-use.sh, execution-substrate.py | Trust tier → approval mode |
| Governance files | install-os.sh, verify-governance.sh | Frozen baseline protection |
| Evidence files | replay-evidence.py | Hash chain verification |

### 2.2 Internal Surfaces

| Surface | Entry Point | Trust Boundary |
|---------|-------------|----------------|
| Delegation chain | execution-substrate.py execute() | Capability token validation |
| File mutations | enforce_trust_boundary() | Trust tier → allowed paths |
| Environment | subprocess env= parameter | Frozen time + limited vars |
| Replay engine | replay_execution() | Signature + drift verification |

### 2.3 Third-Party Surfaces

| Surface | Entry Point | Trust Boundary |
|---------|-------------|----------------|
| MCP servers | MCP integration policy | Platform compatibility layer |
| External APIs | search_web tool | Network command detection |
| Package managers | install commands | Dangerous command detection |

## 3) Privilege Escalation Analysis

### 3.1 Current Controls

1. **Capability Token Narrowing**: Child tokens must be strict subsets of parent
2. **Trust Tier Ranking**: READ_ONLY < WORKSPACE_WRITE < GOVERNANCE_WRITE < TRUSTED
3. **Scope Bounding**: Domain scope limits rule loading
4. **Trust Boundary Enforcement**: Post-execution mutation analysis + rollback

### 3.2 Gaps (Addressed in This Phase)

1. **No nonce validation**: Tokens can be replayed within lease window
2. **No revocation mechanism**: Once issued, tokens are valid until expiration
3. **No execution tampering detection**: Manifests can be modified after sealing
4. **No subprocess isolation**: shell=True allows arbitrary command chains
5. **No path canonicalization**: Relative paths may escape intended scope

### 3.3 Implemented Controls

See §8 for implementation details of:
- Token replay prevention via nonce
- Execution nonce validation
- Capability lease expiration enforcement
- Revocation propagation
- Immutable audit chain
- Execution integrity seals
- Trusted execution assertions

## 4) Subprocess Execution Review

### 4.1 Current State

`execution-substrate.py:execute()` uses `subprocess.run(shell=True)`. This allows:
- Command chaining via `;`, `&&`, `||`
- Variable expansion
- Subshell execution via `$()` and backticks
- File redirection

### 4.2 Risk Assessment

| Risk | Level | Mitigation |
|------|-------|------------|
| Command injection | HIGH | Pre-task validation in pre-tool-use.sh |
| Shell expansion abuse | MEDIUM | Environment variable control |
| Resource exhaustion | HIGH | Timeout enforcement (Phase 6) |
| Signal handling bypass | MEDIUM | Process group isolation (Phase 6) |

### 4.3 Environment Controls

The execute() function propagates `os.environ.copy()` with additions. This is
a potential information disclosure vector. Controls:
- Filter sensitive env vars (AWS_*, GOOGLE_*, *_SECRET, *_KEY, *_TOKEN)
- Set LANG/LC_ALL for deterministic output
- Set EXECUTION_ID, DELEGATION_ID, TRUST_TIER for audit

## 5) Symlink & Path Traversal Protection

### 5.1 Attack Vector

A malicious agent could:
1. Create symlinks pointing outside the workspace
2. Use `..` in paths to escape the target directory
3. Follow symlinks to read/modify protected files

### 5.2 Current State

`enforce_trust_boundary()` checks path prefixes but does NOT:
- Resolve symlinks before checking
- Canonicalize paths before comparison
- Validate that final resolved path is within scope

### 5.3 Implemented Protection

See §8.6 — all file operations now resolve symlinks and validate canonical
paths against the allowed scope.

## 6) Prompt Injection Boundary Analysis

### 6.1 Attack Vectors

1. **Direct injection**: Prompt contains instructions to ignore governance
2. **Context poisoning**: Evidence files contain injected instructions
3. **Governance manipulation**: Agent creates fake governance files
4. **Lane bypass**: Agent tricks classifier into lower-trust lane

### 6.2 Current Controls

1. `resolve-task-context.py` classifies prompts independently
2. Trust tiers are assigned by the system, not the agent
3. Pre-tool-use.sh enforces tier-based approval

### 6.3 Implemented Enhancements

See §8.7 — prompt injection boundary hardening:
- Governance file integrity verification
- Evidence file hash validation before use
- Lane assignment tamper detection

## 7) Environment Poisoning Detection

### 7.1 Attack Vectors

1. **PATH manipulation**: Insert malicious binary in PATH
2. **LD_PRELOAD injection**: Override library functions
3. **Config file poisoning**: Modify .bashrc, .profile
4. **Temp directory hijacking**: Race condition in /tmp

### 7.2 Implemented Detection

See §8.8 — environment poisoning detection:
- PATH integrity verification
- Known-binary checksum validation
- Config file hash monitoring
- Secure temp directory usage

## 8) Implemented Security Controls

### 8.1 Token Replay Prevention

Each capability token includes a unique nonce (UUID v4). The nonce is recorded
in an execution nonce registry. Reusing a nonce within the revocation window
is rejected.

### 8.2 Execution Nonce Validation

Every execution generates a unique nonce that is:
- Included in the execution manifest
- Recorded in the nonce registry
- Verified during replay to prevent replay-within-replay attacks

### 8.3 Capability Lease Expiration

Tokens check `is_expired()` before AND after execution. A token that expires
mid-execution is flagged but not rolled back (partial execution is valid).
The manifest records `lease_expired_during_execution` for audit.

### 8.4 Revocation Propagation

A revocation registry tracks revoked token IDs. When a parent token is
revoked, all child tokens in its delegation chain are also revoked.
The revocation propagates through the authority lineage chain.

### 8.5 Immutable Audit Chain

Each execution manifest includes:
- `chain_hash`: SHA-256 of previous manifest's chain_hash + current manifest
- `chain_position`: Sequential position in the chain
- `chain_head`: Hash of the latest manifest in the chain

This creates a hash chain that makes tampering detectable.

### 8.6 Execution Integrity Seals

After execution, the manifest is sealed with:
- `integrity_seal`: SHA-256 of the manifest JSON (before seal field)
- `seal_timestamp`: When the seal was created
- `seal_algorithm`: "sha256-of-JSON"

Any modification to the manifest breaks the seal.

### 8.7 Trusted Execution Assertions

Before execution, the substrate verifies:
- Governance files have not been modified since resolution
- Capability token signature matches
- Nonce has not been used
- Token is not revoked
- Lease has not expired

### 8.8 Path Traversal Protection

All file paths are:
1. Normalized with `os.path.realpath()` (resolves symlinks)
2. Checked against the target directory root
3. Validated against the trust tier's allowed scope

### 8.9 Environment Sanitization

Before subprocess execution:
1. Sensitive environment variables are filtered
2. LANG and LC_ALL are set to C.UTF-8
3. EXECUTION_ID, DELEGATION_ID, TRUST_TIER are injected
4. SUBSTRATE_FROZEN_TIME is set for deterministic replay

### 8.10 Unsafe Mutation Detection

The trust boundary enforcement now:
1. Detects symlink creation
2. Detects permission changes
3. Detects hidden file creation (dotfiles)
4. Validates mutation count against expected mutations

## 9) Adversarial Execution Proofs

See `EVIDENCE/security/adversarial-proofs/` for:
- Token replay attack simulation
- Escalation attempt simulation
- Path traversal attempt simulation
- Environment poisoning simulation
- Evidence tampering simulation

## 10) Security Testing

Run security tests with:

```bash
# Full security validation
bash tests/security-adversarial.sh

# Individual attack simulations
python3 .agents/skills/bin/security-adversary.py --attack replay
python3 .agents/skills/bin/security-adversary.py --attack escalation
python3 .agents/skills/bin/security-adversary.py --attack traversal
python3 .agents/skills/bin/security-adversary.py --attack tampering
python3 .agents/skills/bin/security-adversary.py --attack poisoning
```

## 11) Security Contact

Report security issues to the repository maintainer. Do not open public issues
for security vulnerabilities.

## 12) Security Changelog

| Version | Date | Change |
|---------|------|--------|
| 1.0.0 | 2026-05-17 | Initial threat model and security controls |
