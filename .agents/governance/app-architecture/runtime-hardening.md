# Runtime Hardening

This document hardens runtime behavior without changing canonical architecture
boundaries.

## Determinism Contract

- same input plus same starting state must produce the same canonical result
- replay from a known checkpoint must produce the same result
- the system must not infer canonical state from incidental transport or UI artifacts

## Execution Phases

1. resolve input payload
2. validate preconditions and allowed operations
3. restore or allocate a known state boundary
4. apply canonical mutations
5. project outputs
6. emit diagnostic events and final status

## Undo and Restore

- use checkpoints plus inverse or compensating actions when feasible
- create checkpoints at stable boundaries
- derive inverse behavior from pre-state when feasible
- replay from a known checkpoint remains the safe fallback

## Reconnect Strategy

- restore nearest valid checkpoint
- replay deterministic deltas to the active point
- only then resume external effects or presentation layers

## Performance and Safety

- timeouts, retries, and degraded modes must be explicit
- long-running work must be stoppable or recoverable
- non-functional polish must not degrade correctness or recovery

## Observability

Runtime should emit events for:

- input accepted or rejected
- state transition start, finish, and failure
- checkpoint create and restore
- rollback or compensation paths
