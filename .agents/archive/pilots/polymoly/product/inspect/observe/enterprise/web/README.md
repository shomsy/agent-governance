# Admin UI Baseline

Status: Baseline implemented.

Scope:

- SPA shell (`index.html`, `app.js`, `styles.css`)
- Authentication middleware contract (`auth-middleware.js`)
- Telemetry contract (`telemetry.js`)

Boundary:

- No resolver or platform-law logic in UI.
- This surface consumes state; it does not define infrastructure intent.
