# Projects Portfolio Inventory

Centralni pregled svih top-level projekata iz `~/projects`, sa governance mapom i tehnickim profilom (jezici, framework-i, biblioteke, ulazne tacke).

Last updated: 2026-03-27

## Scope i metod

- Scope: samo top-level direktorijumi direktno ispod `~/projects`.
- Izvori: root `README.md`, `AGENTS.md`, `.agents/**`, `package.json`, `composer.json`, `go.mod`, i root struktura fajlova.
- Biblioteke: kod JS/TS/PHP/Go projekata navodi se root-level dependency profil (ne kompletan vendor lock dump).
- Governance: naveden je red precedence-a i najvazniji policy slojevi kada postoje.

## Portfolio indeks

Top-level projekti:

1. `MILOS-ACADEMY`
2. `MILOS-V1`
3. `STANKOVICH`
4. `admin-dashboard`
5. `agent-governance`
6. `avax-bootcamp`
7. `baraba`
8. `components`
9. `hotelsync-bridgeone`
10. `polymoly`
11. `step-by-step-animations`
12. `step-by-step-animator`
13. `step-by-step-lesson-engine`

---

## 1) `MILOS-ACADEMY`

- Tip: standalone academy monolith (`domain + presentation`) sa runtime i docs-gate governance.
- Jezici: TypeScript (dominantno), JavaScript, EJS, HTML, CSS.
- Framework-i i platforme:
  - Node.js + Express 5
  - Prisma + PostgreSQL
  - SSR/EJS render sloj
  - Vite (tooling), TSX (dev runtime)
- Biblioteke (root `package.json` + vendored layout engine):
  - `@prisma/client`, `prisma`, `pg`
  - `zod`
  - `helmet`, `cors`, `express-rate-limit`, `body-parser`
  - `pino`, `pino-pretty`
  - `codemirror`, `monaco-editor`
  - `@codemirror/*`, `specificity`
  - internal/vendor: `@milos/layout-os` (`academy/vendor/layout-os`)
- Governance:
  - Local contract: `academy/AGENTS.md`
  - Jasno definisan precedence (`academy/AGENTS.md` -> backend/frontend arhitektura -> governance docs)
  - Stroga canonical/legacy granica (`academy/src/**` canonical, `lab/*` legacy alias)
  - Git discipline i CI-first pravila su eksplicitno normirana.

## 2) `MILOS-V1`

- Tip: MILOS layout engine + local Academy/lab surface.
- Jezici: CSS (jak signal), Markdown, JavaScript, HTML.
- Framework-i i platforme:
  - Nema UI framework-a (framework-agnostic layout engine)
  - Node-based local server/lab tooling
  - Playwright za visual testove
  - Stylelint + Prettier
- Biblioteke (root `package.json`):
  - `@playwright/test`
  - `stylelint`, `stylelint-config-standard`, `stylelint-order`
  - `prettier`
  - plus editor/server stack slican layout-os lab profilu
- Governance:
  - Root `AGENTS.md` ima strict execution mode i enterprise enforcement pravila
  - Dodatni execution policy pod `lab/docs/governance/**`.

## 3) `STANKOVICH`

- Tip: minimalist signal-driven web components engine.
- Jezici: JavaScript (dominantno), HTML, TypeScript d.ts.
- Framework-i:
  - Native Web Components (bez React/Vue/VDOM)
  - signal/effect/computed reaktivni model (custom runtime)
- Biblioteke:
  - Nema vidljivog velikog eksternog package manager sloja na root nivou (engine-first, lightweight setup).
- Governance:
  - Primarno kroz `README.md` filozofiju i source-of-truth sekcije.

## 4) `admin-dashboard`

- Tip: static landing/dashboard prototype.
- Jezici: HTML, CSS, JavaScript.
- Framework-i i biblioteke:
  - CDN biblioteke u `index.html`: Three.js, GSAP + ScrollTrigger.
  - Nema package manager manifesta na root-u.
- Governance:
  - Minimalno; postoji `TODO.md` kao task evidence.

## 5) `agent-governance`

- Tip: reusable parent governance contract repo.
- Jezici: Markdown (normativna dokumentacija).
- Framework-i: N/A (policy repo).
- Governance sadržaj:
  - `PARENT-AGENTS.md` kao reusable base contract
  - `AGENTS.md` za local maintenance contract
  - `docs/governance/**` i `.agents/governance/**` policy set
  - `scaffolds/**` za adopciju u drugim repo-ima
- Ključna namena:
  - Source repo za prenos execution/review/documentation/release policy-a u product repoe.

## 6) `avax-bootcamp`

- Tip: self-hosted interaktivni CSS bootcamp (lesson-centered app).
- Jezici: JavaScript, Markdown, CSS, SVG.
- Framework-i:
  - Vanilla JS + native ES modules
  - Bez UI framework-a i bez CSS framework-a
  - Node test runner
- Biblioteke (root `package.json`):
  - `jsdom` (dev/test)
  - ostatak je namerno lightweight, native stack.
- Governance:
  - `AGENTS.md` definise flow-first, lesson-centered arhitekturu
  - naming i structure discipline (`folder -> file -> function` semantika)
  - slicna governance filozofija kao animator family projekti.

## 7) `baraba`

- Tip: capability-driven web components library/engine.
- Jezici: JavaScript, Markdown.
- Framework-i:
  - Native Web Components
  - Zero-dependency authoring model (bez React/Vue i bez CSS framework-a)
- Biblioteke:
  - Nema root package manager dependency surface vidljive iz root manifesta.
- Governance:
  - `AGENTS.md` sa obaveznim pravilima za engine strukturu (`state/render/actions`)
  - Dokumentacioni standard kroz `how-this-works*.md`.

## 8) `components`

- Tip: PHP component/integration workspace sa jakim vendor ekosistemom.
- Jezici: PHP (dominantno), Markdown, shell.
- Framework-i i biblioteke:
  - Core: procedural + componentized PHP arhitektura
  - Root `composer.json` ukazuje na:
    - PHP `^8.3`
    - `guzzlehttp/guzzle`, `vlucas/phpdotenv`, `firebase/php-jwt`
    - `sentry/sentry`, `ramsey/uuid`, `psr/log`, `psr/simple-cache`
    - `illuminate/view`, `jenssegers/blade`, `eftec/bladeone`, `clickfwd/yoyo`
    - `amphp/*`, `rakibtg/sleekdb`, `wyndow/fuzzywuzzy`
  - Dev/tooling:
    - `phpunit/phpunit`, `phpinsights`, `rector`, `laravel/pint`, `php-cs-fixer`, `php_codesniffer`
- Governance:
  - Delimicno signalizovan preko folder-level policy fajlova (npr. `Foundation/.../agents.md`) i compose/tool contracts.

## 9) `hotelsync-bridgeone`

- Tip: small procedural PHP 8 integration service (interview/task aligned).
- Jezici: PHP (dominantno), SQL, YAML, Markdown.
- Framework-i:
  - Namerno bez full-stack framework-a
  - `mysqli` + `cURL`
  - Docker Compose lokalni runtime (nginx + php-fpm/php-cli + mysql)
- Biblioteke:
  - Minimal dependency pristup; fokus na procedural DSL i feature folders.
- Governance:
  - Strongly documented operational contract kroz `README.md`
  - Jasan proof path, test discipline i security notes.

## 10) `polymoly`

- Tip: developer-first infrastructure runtime + CLI platform.
- Jezici: Go (dominantno), Markdown, YAML, JSON.
- Framework-i/platforme:
  - Go CLI/runtime (`poly`)
  - Template/catalog/release channels/tooling ecosystem
- Biblioteke (root `go.mod`):
  - `github.com/google/go-containerregistry`
  - `gopkg.in/yaml.v3`
  - plus veliki interni modulni sistem kroz `system/**` i `product/**`.
- Governance:
  - Root `AGENTS.md` sa vrlo detaljnim precedence-om i local non-negotiable pravilima
  - Vendored shared governance (`agent-governance`) + local overlays
  - Canonical gate entrypoint: `poly gate run <profile>`.

## 11) `step-by-step-animations`

- Tip: animator-family lesson engine repo (praktično twin/copy profil `step-by-step-animator`).
- Jezici: JavaScript, Markdown, CSS, HTML.
- Framework-i:
  - Vite
  - Node test runner
- Biblioteke (root `package.json`):
  - `@mintplex-labs/piper-tts-web`
  - `onnxruntime-web`
  - `yaml`
- Governance:
  - Root `AGENTS.md`
  - `.agents/` governance stack (`QUALITY`, execution/review/coding/docs/release policy).

## 12) `step-by-step-animator`

- Tip: interaktivni lesson engine za HTML/CSS/JS tutorijale.
- Jezici: JavaScript, Markdown, CSS, HTML.
- Framework-i:
  - Vite (`product/app` root)
  - Node test runner (`tests/contracts`, `tests/flows`, `tests/smoke`)
  - Internal lesson pipeline (`system/lesson-engine` -> `system/animator-engine`)
- Biblioteke:
  - `@mintplex-labs/piper-tts-web`
  - `onnxruntime-web`
  - `yaml`
- Governance:
  - Root `AGENTS.md` (thin entrypoint)
  - `.agents/` kao kanonski operativni sistem:
    - `governance/QUALITY.md`
    - `governance/execution-policy.md`
    - `governance/how-to-code-review.md`
    - `governance/how-to-coding-standards.md`
    - `governance/how-to-document.md`
    - `governance/release-and-rollback-policy.md`
    - `governance/app-architecture/**`
    - `business-logic/**`, `management/**`, `review/**`, `templates/**`, `glossary/**`, `onboarding/**`
- Napomena:
  - Ovaj dokument je smesten ovde da ovaj repo bude centralna evidencija za portfolio mapu.

## 13) `step-by-step-lesson-engine`

- Tip: mali, framework-agnostic lesson markdown engine.
- Jezici: JavaScript, Markdown.
- Framework-i:
  - Nema UI framework-a
  - Content engine fokus (`parse/read/render/sync` pipeline)
- Biblioteke:
  - Minimal root dependency surface (prakticno bez eksternih deps na root-u).
- Governance:
  - Root `AGENTS.md` sa naming i source discipline pravilima
  - Jasno razdvajanje source markdown i generated output contracta.

---

## Cross-portfolio governance mapa

## A) Reusable governance lineage

- `agent-governance` je reusable baza (parent + governance docs + scaffolds).
- `step-by-step-animator` i `step-by-step-animations` koriste `.agents/` model sa slicnim policy granama.
- `polymoly` koristi parent-child contract model i vendored shared governance snapshot.
- `MILOS-*` family i `baraba` imaju jake local AGENTS contracts.

## B) Dominantni jezici kroz portfolio

- JavaScript/TypeScript: `MILOS-ACADEMY`, `avax-bootcamp`, `baraba`, `STANKOVICH`, `step-by-step-*`, `admin-dashboard`.
- PHP: `components`, `hotelsync-bridgeone`.
- Go: `polymoly`.
- Markdown kao governance/content backbone: skoro svi projekti.

## C) Dominantne biblioteke/framework-i kroz portfolio

- JS build/runtime: Vite, Node test runner, Express, Prisma, CodeMirror/Monaco.
- Frontend grafika/prototipi: Three.js, GSAP.
- PHP backend/tooling: Guzzle, Dotenv, Sentry, JWT, PHPUnit, Rector, Pint, PHPCS.
- Go infra/runtime: go-containerregistry, YAML v3, custom CLI/gate ekosistem.

## D) Projekti bez jakog package manager surface-a

- `admin-dashboard`, `baraba`, `STANKOVICH` imaju lightweight ili custom-runtime setup na root nivou.
- To ne znaci da su tehnicki "mali"; znaci da dependency management nije centralizovan kroz root npm/composer/go manifest.

---

## Odrzavanje ovog dokumenta

- Kad se doda novi projekat u `~/projects`, upisati ga ovde kao novu sekciju.
- Kad se promeni root stack (jezik/framework/dependency), azurirati odgovarajucu sekciju.
- Kad se promeni governance precedence ili policy source-of-truth, upisati u "Cross-portfolio governance mapa".
