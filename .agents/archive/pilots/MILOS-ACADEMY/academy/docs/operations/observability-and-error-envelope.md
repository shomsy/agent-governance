# Academy Observability + Error Envelope Contract

Version: 1.0.0  
Status: Normative / Enforced  
Scope: `academy/src/domain/core/**`, API surfaces

## 1) Machine-Readable Error Envelope

All API errors must follow this structure:

```json
{
  "status": "error",
  "code": "MACHINE_CODE",
  "message": "Human-readable message",
  "details": [],
  "traceId": "uuid-or-client-request-id"
}
```

Notes:

1. `traceId` is always attached in error responses.
2. `code` is stable for client-side error handling.
3. `details` may be empty.

## 2) Error Code Baseline

1. `VALIDATION_ERROR` -> 400
2. `AUTH_ERROR` -> 401
3. `FORBIDDEN` -> 403
4. `NOT_FOUND` -> 404
5. `CONFLICT` -> 409
6. `DOMAIN_ERROR` -> 422
7. `INTERNAL_SERVER_ERROR` -> 500
8. `SERVICE_UNAVAILABLE` -> 503

## 3) Request Tracing Contract

1. `request-id` middleware sets `req.traceId` from header or generated UUID.
2. Tenant context middleware sets `req.tenantId` for `/api` chain.
3. Request logger emits structured fields:
- `traceId`
- `tenantId`
- `authSubject`
- `authRole`
- `authSource`
- `authTokenId` (when JWT `jti` exists)
- `method`
- `url`
- `statusCode`
- `durationMs`

## 4) Operational Usage

For incident triage always capture:

1. CI run URL (if deployment-related),
2. `traceId`,
3. `tenantId`,
4. request path and timestamp.

This tuple is minimum correlation set for deterministic debugging.
