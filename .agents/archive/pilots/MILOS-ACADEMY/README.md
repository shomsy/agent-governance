# MILOS ACADEMY

Standalone MILOS Academy monolith (`domain + presentation`).

Core layout dependency:
`@milos/layout-os` (vendored under `academy/vendor/layout-os` for CI reliability)

## Requirements

- Node.js 20+
- npm 10+
- PostgreSQL (for API/CMS endpoints)

## Quick Start (Linux / WSL)

```bash
npm install
npm run prisma:generate
npm run dev
```

Optional env bootstrap:

```bash
cp .env.example .env
```

Open:

- `http://127.0.0.1:4173/`
- `http://127.0.0.1:4173/classroom/lesson/cascade`
- `http://127.0.0.1:4173/playground/challenge`

## Quick Start (Windows PowerShell)

```powershell
npm install
npm run prisma:generate
npm run dev
```

## Runtime Doctor (cross-platform)

Before server startup, `npm run dev` now runs:

```bash
npm run doctor:runtime
```

It fails fast when platform binaries are wrong (example: `@esbuild/win32-x64` inside WSL).

## If You Switch Between Windows <-> WSL

Always reinstall dependencies on the platform where you run the app.

Linux/WSL:

```bash
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
npm run prisma:generate
```

Windows PowerShell:

```powershell
Remove-Item -Recurse -Force node_modules
Remove-Item -Force package-lock.json
npm cache clean --force
npm install
npm run prisma:generate
```

WSL sanity check:

```bash
which node
which npm
```

Neither should point to `/mnt/c/Program Files/nodejs` when running inside WSL.

## Scripts

```bash
npm run dev
npm run serve
npm run lab:serve
npm run academy:build:runtime
npm run academy:typecheck
npm run prisma:generate
npm run lab:simulate-editable
npm run lab:regression-abcd
```

## Canonical vs Legacy Paths

- Canonical runtime routes:
  - `/`
  - `/classroom/lesson/:lessonId`
  - `/playground/challenge`
- Legacy compatibility routes (`/lab/*`) are redirects only.
- Source of truth is `academy/src/**`; `academy/dist/**` is build output.

## API Endpoints

- `GET /api/health`
- `GET /api/users`
- `GET /api/cms/lessons`
- `GET /api/policy/packs`
- `POST /api/policy/packs` (ADMIN)
- `POST /api/policy/activate` (ADMIN)
- `POST /api/policy/evaluate`

## Operations Docs

- `academy/docs/operations/deployment-runbook.md`
- `academy/docs/operations/postgres-backup-restore-runbook.md`
- `academy/docs/operations/staging-smoke-checklist.md`
- `academy/docs/operations/observability-and-error-envelope.md`
- `academy/docs/operations/security-launch-checklist.md`
- `academy/docs/operations/container-handoff-contract.md`
