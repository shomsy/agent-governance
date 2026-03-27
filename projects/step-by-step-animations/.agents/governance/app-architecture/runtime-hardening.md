# Runtime Hardening

This document hardens runtime behavior without changing canonical architecture boundaries.

## Determinism Contract

- scene execution is deterministic from same snapshot and input
- replay produces same result
- runtime does not infer canonical state from incidental DOM

## Scene Execution Phases

1. resolve scene payload
2. validate prereq and allowed operations
3. restore baseline state
4. apply code effects
5. apply preview patches
6. apply UI overlays
7. run visual transitions
8. emit debug events

## Undo and Restore

- use snapshot plus inverse-patch hybrid model
- snapshot at stable boundaries (at minimum by step)
- inverse patches are generated from runtime pre-state when feasible
- replay remains safe fallback

## Reconnect Strategy

- restore nearest valid snapshot
- replay deterministic deltas to active point
- reapply visual overlays after state consistency is restored

## Accessibility and Performance

- keyboard navigation for next and previous is mandatory
- autoplay must be pausable
- reduced-motion mode must be available
- visual polish must not degrade runtime responsiveness

## Observability

Runtime should emit events for:

- scene enter and exit
- patch apply and undo
- snapshot create and restore
- prereq failures
