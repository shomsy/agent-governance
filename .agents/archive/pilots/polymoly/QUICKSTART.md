# Quickstart

## Goal

Get a running PolyMoly project in minutes.

## 1) Start The CLI

```bash
alias poly='env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly'
```

Source-native entrypoint:

```text
env TMPDIR=/tmp GOTMPDIR=/tmp GOCACHE=/tmp/gocache go run ./system/tools/poly/cmd/poly
```

Optional local build:

```bash
task poly:build
```

Generated local binary path (not tracked source):

```text
./system/tools/poly/bin/poly
```

## 2) Create A Project

```bash
poly new billing --usage api --lang php
cd billing
```

## 3) Start Environment

```bash
poly up
```

Expected style of output:

```text
Application ready

HTTP: http://localhost:8080
DB: localhost:3306
Redis: localhost:6379
```

## 4) Understand The Project Layout

```text
billing/
 ├─ src/
 └─ .polymoly/
     ├─ config.yaml
     └─ polymoly.lock
```

## 5) Useful Next Commands

```bash
poly configure
poly plan --profile production --recipe hardened
poly diff
poly apply
poly describe
poly logs
poly doctor
poly down
```

Flag vocabulary:

- `--lang` is canonical for project creation.
- `--runtime` remains compatibility-only during v2 and prints a deprecation note when used.

## Troubleshooting

Run:

```bash
poly doctor
```

This checks Docker, common port collisions, and configuration validity.

Optional experimental commands:

```bash
poly configure --live-map --chaos-sim --dry-run
poly ghost map
poly chaos sim --scenario db-failover
```
