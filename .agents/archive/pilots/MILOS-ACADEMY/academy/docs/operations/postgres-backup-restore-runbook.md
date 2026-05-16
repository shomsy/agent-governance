# Academy Postgres Backup + Restore Runbook

Version: 1.0.0  
Status: Normative / Enforced  
Scope: `academy/prisma/**`, production/staging databases

## 1) Backup Command (Logical)

Use `pg_dump` custom format:

```bash
export PGPASSWORD="<db-password>"
pg_dump \
  --host="<db-host>" \
  --port="5432" \
  --username="<db-user>" \
  --dbname="<db-name>" \
  --format=custom \
  --file="academy-backup-$(date +%Y%m%d-%H%M%S).dump"
```

## 2) Restore Command (Logical)

Restore into an empty or disposable verification database first:

```bash
export PGPASSWORD="<db-password>"
createdb --host="<db-host>" --port="5432" --username="<db-user>" "<restore-db-name>"
pg_restore \
  --host="<db-host>" \
  --port="5432" \
  --username="<db-user>" \
  --dbname="<restore-db-name>" \
  --clean \
  --if-exists \
  --no-owner \
  --no-privileges \
  "academy-backup-YYYYMMDD-HHMMSS.dump"
```

## 3) Recovery Verification Checklist

1. `academy:db:verify` passes against restored DB.
2. Row counts for critical tables are non-zero as expected:
- `users`
- `lessons`
- `lesson_progress`
- `policy_packs`
- `tenant_active_policies`
3. API smoke passes with restored DB:
- `/api/health`
- `/api/cms/lessons` (authenticated)
- `/api/policy/evaluate` (authenticated)

## 4) Drill Evidence Template

Record every drill in release evidence:

1. backup file name and timestamp,
2. restore target DB name,
3. verification command outputs summary,
4. operator and reviewer sign-off.
