# Universal Quality Gates

Version: 1.0.0
Status: Normative / Agnostic

Before any work is marked as **"Production Ready"** or proposed for a final merge, the agent (and developer) must be able to defend these 10 agnostic quality questions.

## The Purity Filter (Agnostic Gates)

1.  **Trust**: Does the change "Fail-Closed"? If a mandatory configuration, dependency, or evidence artifact is missing, does the system safely stop, or does it continue in an unstable state?
2.  **Operator Clarity**: Can another human (or AI) understand the failure, recovery path, and artifact location without any "tribal knowledge" or external explanation?
3.  **Rollback Posture**: Is there an explicit, documented path to reverse this change? If it's a mutation of state (DB/Storage), how do we contain the impact if it fails?
4.  **Contract Stability**: Does this change preserve existing public interfaces (APIs, CLI flags, File schemas)? If not, is the migration path explicitly documented and tested?
5.  **Deterministic Automation**: Can CI scripts, deployment tools, or automated observers consume the results of this change without manual intervention or fuzzy parsing?
6.  **Observability Logic**: Do the logs, telemetry, and exit codes make the *behavior* of this feature diagnosable? Can we "see" the internal state transition through the outputs?
7.  **Performance Posture**: Are there any new claims about speed, scale, or latency? If so, are they measured and recorded as evidence, or are they unproven?
8.  **Security Hygiene**: Does the change respect the Principle of Least Privilege? Are secrets kept out of logs, code, and artifacts? Are policy boundaries preserved?
9.  **Source Truth**: Do the README, help text, and governance documents still describe the *shipped* system accurately? Is there "Docs-Code Drift"?
10. **Evidence Integrity**: Is the proof of validation (tests, snapshots, logs) present, machine-readable, and tied to this specific change?

## Gate Enforcement

- If the answer to any question is **"No"**, the work is not complete.
- The **"Production Ready"** label is only earned when all gates are green.
- Bypassing a gate requires an explicit, recorded **Safety Exception** in the local project's `AGENTS.md`.
