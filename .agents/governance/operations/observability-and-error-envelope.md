# Observability And Error Envelope Contract

Version: 1.0.0
Status: Normative

Use this contract for APIs, jobs, CLI tools, or services that expose operator
visible failures.

## Machine-Readable Error Envelope

All externalized errors should expose a stable structure such as:

```json
{
  "status": "error",
  "code": "MACHINE_CODE",
  "message": "Human-readable message",
  "details": [],
  "traceId": "request-or-operation-id"
}
```

Rules:

- `code` is stable for automation and client handling
- `message` is human-readable but should not leak secrets
- `details` may be empty, but should stay machine-parseable
- `traceId` or equivalent correlation identifier should always exist

## Error Code Baseline

Each child repository should define a stable mapping for:

- validation failures
- auth or trust failures
- permission failures
- not found cases
- conflict cases
- domain rule failures
- internal failures
- unavailable dependency failures

## Tracing Contract

Where the runtime model allows it, logs and telemetry should expose:

- `traceId`
- actor or subject identifier when safe
- tenant, account, or workspace identifier when relevant
- request or operation path
- status or result
- duration
- release or version identifier for deploy-related triage

## Operational Usage

Incident triage should capture at least:

1. deployment or CI reference when relevant
2. `traceId` or equivalent operation identifier
3. actor, tenant, or scoped ownership identifier when relevant
4. path or operation name and timestamp

If this tuple cannot be reconstructed, diagnosability is too weak.
