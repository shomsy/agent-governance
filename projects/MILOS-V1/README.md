# MILOS V1

MILOS is a CQ-first layout engine with a local Academy app in `lab/`.

## Quick Start

Requirements:

- Node.js 18+ (Node 20+ recommended)
- npm

Install:

```bash
npm install
```

Run local server:

```bash
npm run lab:serve
```

Open:

- `http://127.0.0.1:4173/lab/index.html`
- `http://127.0.0.1:4173/lab/classroom/lesson/cascade`
- `http://127.0.0.1:4173/lab/classroom/lesson/cascade/challenge`
- `http://127.0.0.1:4173/lab/classroom/lesson/cascade/practice`
- `http://127.0.0.1:4173/lab/playground/lesson/display-and-flow`

## Lesson Model

Each lesson uses exactly 3 pages:

- `Level 1 - Explore`
- `Level 2 - Fix`
- `Level 3 - Build`

Lessons include live sandbox, debug panel, and real-time CSS lint feedback.

## Scripts

- `npm run build` build `dist/*` from framework source
- `npm run dev` alias for `npm run lab:serve`
- `npm run lab:serve` run local Node server
- `npm run lab:simulate-editable` run editable control simulation (legacy bootcamp pages)
- `npm run lab:regression-abcd` run focused A/B/C/D runtime regression checks
- `npm run lint:css` stylelint for framework CSS
- `npm run lint:guards` layout contract guards
- `npm run lint:docs` prettier check
- `npm run lint` run all lint steps
- `npm run format` prettier write
- `npm run test:guards` guard tests
- `npm run test:visual` Playwright visual tests
- `npm run ci` build + lint + visual tests

## Project Structure

- `styles/` framework source layers
- `dist/` built CSS artifacts
- `scripts/` build and guard tooling
- `docs/` HOW_TO_BIBLE and framework docs
- `demo/` demo HTMLs
- `tests/visual/` visual regression tests
- `lab/` Academy campus, classroom lessons, and playground

## Contract and API

- `AGENTS.md` is the normative contract
- `docs/HOW_TO_BIBLE.md` is the software delivery bible

If implementation and contract conflict, contract wins and code should be fixed.

## License

MIT
