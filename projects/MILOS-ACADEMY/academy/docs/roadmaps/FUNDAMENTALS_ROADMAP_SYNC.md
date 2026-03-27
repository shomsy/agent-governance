# MILOS Academy Fundamentals Sync (from CSS roadmap)

Status: planning and content expansion in progress.
Scope: canonical Academy classroom and playground routes only.

## 1) Cilj

Dopuniti Academy content tako da pokrije kljucne CSS fundamentale iz roadmap-a, ali bez narusavanja granice:

- Engine (`l-*`, `u-*`) = geometrija i runtime.
- Academy (`academy/src/presentation/**`) = edukacija, semantika, vezbe, narativ.

Napomena:

- Primarna putanja za osnove je `academy/docs/roadmaps/CSS_FOUNDATIONS_PATH.md`.
- MILOS mapiranje dolazi kao drugi korak (bridge), ne pre osnova.

## 2) Snapshot trenutnog pokrica

Postojece lekcije vec pokrivaju dobar deo osnove:

- `/classroom/lesson/syntax`: selektori, kombinatori, osnove pravila.
- `/classroom/lesson/basics`: box model i sizing.
- `/classroom/lesson/appearance`: tipografija i vizuelni stil.
- `/classroom/lesson/cascade`: specificnost, `:where()`, `@layer`.
- `/classroom/lesson/flex-flow`: flex fundamentals.
- `/classroom/lesson/grid-matrix`: grid fundamentals.
- `/classroom/lesson/positioning`: position i osnove layeringa.
- `/classroom/lesson/responsive`: responsive logika i CQ.
- `/classroom/lesson/variables`: var/calc/clamp logika.
- legacy orchestration module: rails i kompozicija.
- `/playground/challenge`: capstone.

## 3) P0 fundamentals (must-have)

Ovo su kljucne teme koje moraju biti kompletirane prve.

1. CSS connection i cascade redosled

- teme: inline/internal/external, source order
- gde: prosiriti `/classroom/lesson/syntax` i `/classroom/lesson/cascade`

2. Selector grammar komplet

- teme: element, class, id, universal, grouping, attribute selectors
- gde: prosiriti `/classroom/lesson/syntax`

3. Combinatori komplet

- teme: descendant, child, adjacent sibling (`+`), general sibling (`~`)
- gde: prosiriti `/classroom/lesson/syntax`

4. Rules/declarations/comments

- teme: anatomy of rule, declaration validity, comments
- gde: prosiriti `/classroom/lesson/syntax`

5. Box model full paket

- teme: padding, margin, border, outline, width/height, box-shadow
- gde: prosiriti `/classroom/lesson/basics`

6. Units i funkcije

- teme: px/rem/em/%/vw/vh, `min()`, `max()`, `clamp()`, `calc()`
- gde: `/classroom/lesson/basics` + `/classroom/lesson/variables`

7. Display i visibility

- teme: block/inline/inline-block, none vs visibility
- gde: nova lekcija `/classroom/lesson/display-visibility`

8. Boje i opacity

- teme: hex/rgb/hsl, alpha, named colors, opacity
- gde: prosiriti `/classroom/lesson/appearance`

9. Text styling fundamentals

- teme: font-family/style/weight/size, line-height, spacing, align, decoration, transform, shadow
- gde: prosiriti `/classroom/lesson/appearance`

10. Background fundamentals

- teme: color/image/gradient/position/size/repeat/attachment
- gde: prosiriti `/classroom/lesson/appearance`

11. Position i stacking context

- teme: static/relative/absolute/fixed/sticky, z-index context
- gde: prosiriti `/classroom/lesson/positioning`

12. Pseudo-class i pseudo-element osnove

- teme: `:hover`, `:focus-visible`, `:first-child`, `::before`, `::after`
- gde: nova lekcija `/classroom/lesson/pseudo`

13. Responsive osnova

- teme: media queries vs container queries, responsive typography
- gde: prosiriti `/classroom/lesson/responsive`

14. Best practices mini paket

- teme: accessibility, performance, reduced motion, contrast
- gde: nova lekcija `/classroom/lesson/best-practices`

## 4) P1 fundamentals (nice-to-have, odmah posle P0)

1. Motion fundamentals

- teme: transitions, transforms, keyframes
- gde: nova lekcija `/classroom/lesson/motion`

2. Legacy layout awareness

- teme: float i multicolumn (kada i zasto ne)
- gde: kratka sekcija u `/classroom/lesson/grid-matrix` ili posebna mini lekcija

3. Lists/tables/images/filters

- gde: mini modul u okviru fundamentals sprinta

4. Methodologies overview

- teme: BEM, Sass, CSS Modules, CSS-in-JS (bez ulaska u tools rat)
- gde: kratka teorijska lekcija

## 5) Canonical MILOS mapiranje (obavezno u svakoj lekciji)

Za svaku temu eksplicitno navesti:

- canonical primitive/modifier izbor
- sta je overlap i sta se ne koristi
- tipican failure mode

Primer:

- "Asimetrija sa rail-om" -> koristi `l-sidebar`
- "Simetricna 2 kolone distribucija" -> koristi `l-grid l-grid--cols-2`

## 6) Predlog sprint plana (prakticno)

Sprint A (P0 core)

1. Prosiriti: `syntax`, `basics`, `appearance`.
2. Dodati: `display-visibility`.
3. Dodati: `pseudo`.

Sprint B (P0 completion)

1. Prosiriti: `positioning`, `responsive`, `variables`.
2. Dodati: `best-practices`.
3. Proci checklist po `academy/docs/agents/LESSON_TEMPLATE.md`.

Sprint C (P1)

1. Dodati: `motion`.
2. Dodati legacy-awareness i methodology overview.
3. Zavrsni refaktor navigacije na `/`.

## 7) Definition of done za fundamentals sync

1. Sve P0 teme imaju dom u jednoj ili vise lekcija.
2. Svaka P0 lekcija ima challenge + expected outcome.
3. Svaka P0 lekcija ima minimum 2 MDN reference.
4. Svaka P0 lekcija jasno odvaja fundamentals od MILOS-specific canonical izbora.
