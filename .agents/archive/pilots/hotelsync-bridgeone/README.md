# HotelSync BridgeOne

Small procedural PHP 8 integration service for the interview task.

The project is organized as a procedural DSL with feature-first folders:

- the folder says which business flow you are in
- the file says which action or responsibility it covers
- the function says exactly what it does

There is no framework layer, no ORM, and no HTTP/database abstraction package. The core stack stays inside the task constraints:

- PHP 8.x
- MySQL
- `mysqli`
- `cURL`

The original interview brief is kept in [`INTERVIEW_TASK.md`](INTERVIEW_TASK.md) so the submission context stays versioned together with the code.

The root CLI files mirror the exact command names from the interview brief. They stay intentionally thin and delegate into the feature command files, so the business logic remains isolated and testable.

## Project layout

```text
app/
  bootstrap/
    bootstrap.php
  cli/
  config/
  database/
  http/
  integrations/
  logging/
  support/
features/
  catalog/
    catalog_bootstrap.php
    commands/
      run_catalog_sync_command.php
    rooms/
      fetch_rooms_from_hotelsync.php
      transform_room_payload_to_catalog_record.php
      upsert_room_catalog_record.php
    rate_plans/
      fetch_boards_from_hotelsync.php
      fetch_rate_plans_from_hotelsync.php
      transform_boards_payload_to_board_names_by_id.php
      transform_rate_plan_payload_to_catalog_record.php
      upsert_rate_plan_catalog_record.php
    sync_catalog_from_hotelsync.php
  reservations/
    reservations_bootstrap.php
    commands/
      run_reservation_import_command.php
      run_reservation_update_command.php
    import/
      fetch_reservations_from_hotelsync_by_date_range.php
      sync_reservations_from_hotelsync_by_date_range.php
    update/
      fetch_reservation_from_hotelsync_by_id.php
      sync_reservation_from_hotelsync_by_id.php
    local_state/
      detect_cancelled_reservation_from_payload.php
      transform_reservation_payload_to_local_record_set.php
      save_reservation_record_set_to_local_database.php
      sync_reservation_payload_to_local_state.php
      load_or_sync_reservation_by_external_id.php
  invoices/
    invoices_bootstrap.php
    commands/
      run_invoice_generation_command.php
    payload/
      transform_reservation_payload_to_invoice_line_items.php
      transform_local_reservation_to_invoice_payload.php
    queue/
      find_invoice_queue_item_by_id.php
      find_invoice_queue_item_by_reservation_id.php
      mark_invoice_queue_item_as_processing.php
      mark_invoice_queue_item_as_sent.php
      mark_invoice_queue_item_for_retry.php
      reserve_next_invoice_number.php
      save_invoice_queue_item.php
    delivery/
      deliver_invoice_from_queue.php
    generate_and_queue_invoice_for_reservation.php
  webhooks/
    webhooks_bootstrap.php
    reservations/
      transform_webhook_payload_to_webhook_context.php
      manage_webhook_event_inbox.php
      process_reservation_webhook_event.php
      receive_reservation_webhook_request.php
public/
  webhooks/
    otasync.php
config/
docker/
  nginx/
  php/
setup/
  database/
    create_schema.sql
  proof/
    sample_reservation_created_webhook.json
tests/
  integration/
    features/
  unit/
    app/
    features/
.env.example
docker-compose.yml
sync_catalog.php
sync_reservations.php
update_reservation.php
generate_invoice.php
INTERVIEW_TASK.md
```

## Setup

### Docker runtime

This repository now ships with a minimal but non-naive local runtime:

- `nginx` exposes only the webhook entrypoint from `public/`
- `php-fpm` serves inbound HTTP requests
- `php-cli` runs sync commands and tests
- `mysql` provides the task-required persistence layer

Security-minded defaults in the Docker layer:

- code is mounted read-only into the app containers
- only `logs/` and `storage/` stay writable
- MySQL is not exposed on a host port by default
- `nginx` forwards only `/webhooks/otasync.php`
- `server_tokens` and `expose_php` are disabled
- Linux capabilities are dropped and `no-new-privileges` is enabled
- request body limits are aligned with the webhook payload cap
- `app/bootstrap/bootstrap.php` now stays infra-only, while each feature owns its own bootstrap file

1. Copy the example environment file:

```bash
cp .env.example .env
```

2. Fill the HotelSync credentials in `.env`.

Note:
`HOST_UID` and `HOST_GID` are there so bind-mounted `logs/` and `storage/` stay writable from the PHP containers on Linux hosts.
Set `HS_TOKEN` to the demo token from the interview brief instead of committing a concrete token value into the repository.

3. Start the runtime:

```bash
docker compose up -d mysql php-fpm nginx
```

4. Run tests and commands through the CLI container:

```bash
docker compose run --rm php-cli tests/run.php
docker compose run --rm php-cli sync_catalog.php
docker compose run --rm php-cli sync_reservations.php --from=2026-01-01 --to=2026-01-31
docker compose run --rm php-cli update_reservation.php --reservation_id=606308
docker compose run --rm php-cli generate_invoice.php --reservation_id=606308
```

5. The webhook endpoint becomes available at:

```text
POST http://localhost:8080/webhooks/otasync.php
```

6. Replay the same local proof path used during the final verification pass:

```bash
docker compose run --rm php-cli tests/run.php

curl -i http://localhost:8080/webhooks/otasync.php

curl -i \
  -X POST http://localhost:8080/webhooks/otasync.php \
  -H 'Content-Type: application/json' \
  --data @setup/proof/sample_reservation_created_webhook.json

curl -i \
  -X POST http://localhost:8080/webhooks/otasync.php \
  -H 'Content-Type: application/json' \
  --data @setup/proof/sample_reservation_created_webhook.json
```

### Manual local setup

1. Create the database and import [`setup/database/create_schema.sql`](setup/database/create_schema.sql).
2. Export environment variables:

```bash
export DB_HOST=127.0.0.1
export DB_PORT=3306
export DB_DATABASE=hotelsync_bridgeone
export DB_USERNAME=root
export DB_PASSWORD=secret

export HS_USERNAME=your-demo-username
export HS_PASSWORD=your-demo-password
export HS_TOKEN=your-hotelsync-demo-token

# If HotelSync login payload does not expose these fields in your demo account,
# provide them explicitly:
export HS_PROPERTY_ID=93
export HS_API_KEY=your-api-key

# Optional for invoice delivery
export BRIDGEONE_INVOICE_ENDPOINT=https://bridgeone.example.com/invoices

# Only disable this for local development tunnels or mock endpoints
export BRIDGEONE_INVOICE_REQUIRE_HTTPS=1
```

3. Run the flows:

```bash
php sync_catalog.php
php sync_reservations.php --from=2026-01-01 --to=2026-01-31
php update_reservation.php --reservation_id=606308
php generate_invoice.php --reservation_id=606308
```

4. Expose the webhook endpoint through your local web server:

```text
POST /webhooks/otasync.php
```

## Tests

The test layer is intentionally dependency-free, so it can run on plain PHP without PHPUnit installation.

The test tree mirrors the same boundary as the source code:

- `tests/unit/app` covers technical runtime helpers
- `tests/unit/features/*` covers pure business mapping and feature logic
- `tests/integration/features/*` covers DB-backed end-to-end feature behavior

```bash
php tests/run.php
```

When you want the fully reproducible path, run the same suite through Docker:

```bash
docker compose run --rm php-cli tests/run.php
```

If you use PHP_CodeSniffer locally, the repository already ships with [`phpcs.xml.dist`](phpcs.xml.dist) and targets PSR-12.

The suite now covers both pure mapping rules and DB-backed integration flows:

- stable payload hashing
- CLI input parsing and fail-closed validation
- HotelSync client auth/request failure paths
- rate plan local code generation
- room local code generation
- lock id generation
- invoice line item building
- invoice queue idempotency and retry exhaustion
- webhook event extraction
- webhook transport validation for method, content type, and payload size
- catalog upsert id stability
- reservation import, unchanged hash detection, and cancel handling
- invoice numbering, queue persistence, and retry-to-failed behavior
- webhook inbox persistence and duplicate suppression

The naming style is intentional. For example:

- `features/webhooks/reservations/transform_webhook_payload_to_webhook_context.php`
- `extract_reservation_id_from_webhook()`

That keeps the code readable even for someone who is new to the codebase.

## Proof of behavior

Verified locally through Docker on 2026-03-12:

- `docker compose run --rm php-cli tests/run.php` passed with `passed=41 failed=0`
- `GET /webhooks/otasync.php` returned `405 Method Not Allowed`, which proves the public ingress path is alive and transport guards are active
- `POST /webhooks/otasync.php` with [`setup/proof/sample_reservation_created_webhook.json`](setup/proof/sample_reservation_created_webhook.json) returned `200 OK` with `{"status":"ok","action":"unchanged","reservation_id":"606308"}` immediately after the integration suite
- replaying the same webhook payload right after that returned `200 OK` with `{"status":"duplicate","message":"Webhook already processed."}`
- sending one fresh webhook payload twice in parallel returned one normal `200 OK` processing response and one duplicate-safe `200 OK` response, which proves the DB-backed inbox insert now fails closed under replay races
- running the invoice generation command twice in parallel for the same reservation returned one `queued` result and one `existing` result, which proves queue creation now serializes safely on the reservation row

The proof path is intentionally split in two parts:

- deterministic local proof through tests and webhook replay
- real HotelSync command execution once valid demo credentials are present in `.env`

## What the service does

### Catalog sync

- logs in to HotelSync
- fetches boards
- fetches rooms
- fetches pricing plans
- persists rooms with `HS-{ROOM_ID}-{slug_room_name}`
- persists rate plans with `RP-{RATE_PLAN_ID}-{meal_plan}`

Note:
The task mentions rooms and rate plans, but the real API exposes meal plan semantics through `boards`. That is why the catalog sync also pulls boards.

### Reservation sync

- imports reservations by date range
- imports one reservation by id
- computes canonical payload hashes
- avoids duplicate writes when the hash is unchanged
- keeps reservation rows even when status becomes canceled
- replaces child room and rate plan rows on payload changes
- writes audit rows for imported, updated, canceled, invoice, and webhook events

### Invoice flow

- builds invoice payloads from stored reservation payloads
- generates concurrency-safe numbers through `invoice_counters`
- queues invoices in `invoice_queue`
- retries failed delivery attempts up to the configured limit

Note:
The task does not define a real BridgeOne invoice endpoint. Delivery is therefore implemented as a configurable HTTP target through `BRIDGEONE_INVOICE_ENDPOINT`.

### Webhook flow

- accepts JSON webhooks only
- requires `POST`
- rejects oversized payloads
- hashes payloads for deduplication when event id is missing
- stores every event in `webhook_events`
- reuses reservation sync logic instead of duplicating update code

## Design decisions

- `app/bootstrap/bootstrap.php` loads only technical runtime pieces. Business files are loaded by feature bootstraps such as [`features/catalog/catalog_bootstrap.php`](features/catalog/catalog_bootstrap.php) and [`features/webhooks/webhooks_bootstrap.php`](features/webhooks/webhooks_bootstrap.php). That keeps `app/` technical and keeps business composition close to each feature.
- The project stays procedural on purpose. The task explicitly asks for procedural PHP and forbids frameworks that abstract HTTP or DB layers, so the code leans into a feature-first DSL instead of pretending to be a mini framework.
- Catalog sync reads `boards` before pricing plans because the upstream API exposes meal-plan semantics there. That is why local rate-plan codes use `RP-{RATE_PLAN_ID}-{meal_plan}` even though the task itself only names rate plans.
- Webhook dedupe prefers the upstream event id when it exists and falls back to a canonical payload hash when it does not. That makes duplicate handling stable across both rich and minimal webhook payloads.
- Webhook inbox persistence uses a DB-backed insert-or-reuse pattern on the unique dedupe key, so two near-simultaneous deliveries of the same event do not crash the endpoint or create duplicate rows.
- Invoice numbering is locked in MySQL through `invoice_counters` plus `SELECT ... FOR UPDATE`, because uniqueness matters more than optimistic convenience in this flow.
- Invoice queue creation also locks the local reservation row before queue insertion, so two concurrent invoice commands for the same reservation settle into `queued` plus `existing` instead of a unique-key collision.
- Docker is included as a reproducible local verification tool, not as a final production deployment manifest.
- The repository does not add Redis or a general cache layer because this service is correctness-first and the database is already the source of truth for idempotency, queue state, and auditability.
- Reservation persistence now loads only the room ids and rate plan ids referenced by the current payload instead of reading the full local catalog on every sync.

## Data integrity guarantees

The local schema is designed so the database makes important mistakes impossible:

- [`setup/database/create_schema.sql`](setup/database/create_schema.sql) locks rooms by `external_room_type_id` and rate plans by `external_rate_plan_id`
- reservations are unique by both `external_reservation_id` and `lock_id`
- invoice queue rows are unique by both `reservation_id` and `invoice_number`
- webhook inbox rows are unique by `dedupe_key`
- helper indexes support reservation-centric audit history, queue status scans, and webhook history reads
- reservation child rows are replaced inside one sync flow, which keeps room and rate-plan snapshots aligned with the latest payload

In practice, that means the source of truth is split cleanly:

- HotelSync payloads are the source of truth for reservation state
- the local database is the source of truth for idempotency, auditability, queue state, and stable local mappings

## Security notes

The code intentionally covers the interview-grade security basics that matter in integration work:

- prepared statements everywhere through `mysqli`
- hash-based idempotency for reservation updates
- webhook method and content-type validation
- webhook size limit to reduce noisy abuse vectors
- HTTPS enforcement for invoice delivery by default
- correlation ids carried through CLI entrypoints, webhook requests, logs, and outbound HTTP headers
- no raw secrets written into logs

This is not full production hardening yet. If this were a real service, I would add:

- webhook signature verification
- rate limiting
- structured logs
- queue worker separation
- dead-letter handling for repeated invoice failures
- stronger outbound HTTP allow-listing
- secret rotation and dedicated webhook signature verification, if the upstream sender supports it

## Known limitations

- The Docker proof path is fully reproducible locally, but the real HotelSync command flows still require valid demo credentials in `.env`
- Invoice delivery is modeled as a synchronous HTTP call plus queue state updates; a production version would move delivery and retries into a worker lane
- Webhook authenticity currently relies on transport and payload validation because the upstream brief does not define a signature scheme
- Logs are intentionally plain text for the interview scope; correlation ids already exist, and a production service would add structured logs on top of them
- `.env.example` intentionally keeps `HS_TOKEN` as a placeholder so the repository does not ship with a concrete demo token value
- Invoice retries currently follow one bounded retry budget; a production version would classify transient and permanent errors differently
- Reservation import currently processes the requested range directly; a production version would add chunking/checkpointing and shorter transaction scopes for larger date windows

## How I would extend this

- move invoice delivery into a dedicated worker loop with retry scheduling and dead-letter handling
- add webhook signature verification when the upstream sender provides a signing contract
- enforce an outbound allow-list for invoice destinations
- add structured logs on top of the existing correlation ids across CLI, webhook, and outbound invoice flows
- classify outbound retry behavior by error type, so timeouts and 5xx responses retry while permanent 4xx validation failures fail fast
- add chunked reservation imports with smaller transaction scopes and resumable checkpoints for larger sync windows
- expose a lightweight health/probe surface for operators once the service becomes long-running

## Assumptions

- The HotelSync Postman collection is the source of truth for endpoint shapes.
- The Docker setup is meant for reproducible local verification, not as a final production deployment manifest.
- `pricing plans` use `boards` for readable meal plan naming.
- Reservation ids are numeric in CLI and webhook flows.
- Re-running `generate_invoice.php` for the same reservation reuses the existing queue row instead of minting a second invoice.
- Webhook payloads may contain either:
  - the full reservation payload
  - or only a reservation id, in which case the service fetches the latest reservation from HotelSync

## Verification note

The final verification pass for this repository was done through Docker on 2026-03-12. Plain local `php` and `mysql` binaries were not available in the original workspace, so Docker is the canonical proof path included in this submission.

Live HotelSync catalog and reservation commands were not executed in this workspace because they require valid demo credentials. Once those credentials are present in `.env`, the command entrypoints in `features/*/commands/` are ready to be exercised through the same Docker runtime.
