# STANKOVICH v2 Roadmap

Ovo je praktični ToDo za verziju 2. Fokus: zadržati minimalistički core, dodati samo ono što diže realnu upotrebljivost.

## Must-Have (v2.0.0)

- [ ] `@stankovich/router` kao opcioni modul (van core-a).
Acceptance: podržava `history` i `hash` mode, `navigate(path)`, route params (`/users/:id`), i `notFound`.

- [ ] CI release gate (unit + browser integration).
Acceptance: PR ne može da se merge-uje ako padne `tests/signals.test.js` ili `tests/browser.html` suite.

- [ ] Security docs + safe defaults stranica.
Acceptance: dokumentovano da `h()` ignoriše non-function `on*`, plus primeri za bezbedan rad sa user inputom.

- [ ] Release packaging discipline.
Acceptance: NPM package uključuje samo canonical source (`core/*`, `index.js`, `index.d.ts`, docs), bez internog “noise”.

- [ ] Stabilan semver + changelog.
Acceptance: `CHANGELOG.md` postoji i svaka verzija ima migration notes.

## Should-Have (v2.x)

- [ ] `createStore()` helper za strukturirano stanje preko signala.
Acceptance: immutable update helper + granular signal update bez re-render thrash-a.

- [ ] Route-level lazy loading helper.
Acceptance: router može da učita route module na demand bez menjanja core API-ja.

- [ ] Devtools events timeline.
Acceptance: overlay prikazuje poslednje flush cikluse i route promene sa vremenom.

- [ ] Stronger TypeScript ergonomics za `Component.define()`.
Acceptance: bolji infer za `props/setup/mount` i manje `any` u javnom API-ju.

## Nice-To-Have (post v2)

- [ ] SSR-friendly rendering helper (core ostaje DOM-agnostic).
Acceptance: osnovni string render helper + hydration hook za web components.

- [ ] Community examples repo.
Acceptance: 3 reference app-a (dashboard, forms-heavy app, docs site) na istom API-u.

## Non-Goals Za v2

- Ne uvoditi Virtual DOM.
- Ne uvoditi globalni magic state.
- Ne razbijati “one-time mount + fine-grained binders” filozofiju.
