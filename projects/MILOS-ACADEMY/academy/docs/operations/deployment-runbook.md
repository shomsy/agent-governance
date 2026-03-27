# Academy Deployment + Rollback Runbook (No-Docker Profile)

Version: 1.0.0  
Status: Normative / Enforced  
Scope: `academy/**`

## 1) Purpose

Define repeatable release and rollback flow for MILOS Academy runtime without local Docker dependency.

This runbook is compatible with later containerization handoff.

## 2) Preconditions

1. Merge flow followed: `feature/* -> development -> main`.
2. `Academy CI` is green for target commit.
3. Production env variables are set (see root `.env.example`).
4. Postgres is reachable with least-privilege runtime credentials.

## 3) Release Procedure

1. Checkout release commit:
```bash
git fetch origin
git checkout <release-sha>
```

2. Install dependencies:
```bash
npm ci
```

3. Generate Prisma client:
```bash
npm run -s prisma:generate
```

4. Run production dependency audit:
```bash
npm run -s academy:quality
```

5. Apply migrations:
```bash
npm run -s academy:db:migrate:deploy
```

6. Run runtime preflight gates:
```bash
npm run -s academy:check:contracts
npm run -s academy:typecheck
npm run -s academy:test
npm run -s academy:build:runtime
npm run -s academy:smoke:runtime
npm run -s doctor:runtime
```

7. Start application:
```bash
npm run -s serve
```

8. Health/readiness verification:
```bash
curl -sS http://127.0.0.1:4173/api/health
curl -sS http://127.0.0.1:4173/api/ready
```

Expected responses contain `status: "ok"` and `status: "ready"`.

## 4) Rollback Procedure

Use rollback when production behavior regresses and fix-forward is not acceptable within the incident window.

1. Identify last known good SHA.
2. Redeploy same way as Section 3 using known good SHA.
3. Re-run migration deploy:
- If rollback SHA is older but schema is forward-compatible, keep DB at current migration and rollback app only.
- If schema rollback is required, execute manual DB rollback plan first (change-reviewed SQL only).
4. Verify:
- `/api/health`
- one authenticated API call (tenant + token),
- smoke checklist critical path.

## 5) Post-Release Evidence

Record in `academy/docs/governance/Code-Review-And-ToDo/review.md`:

1. release SHA,
2. CI run URL,
3. migration command result,
4. health/smoke verification timestamp.
