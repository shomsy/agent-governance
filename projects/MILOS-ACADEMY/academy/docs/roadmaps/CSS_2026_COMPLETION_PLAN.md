# CSS Foundations 2026 Completion Plan

Status date: February 18, 2026  
Scope: canonical Academy classroom and playground content only (CSS motor first, MILOS bridge second).

## 1) Status update (Bootcamp conversion complete)

U medjuvremenu je odradjen veliki rez i ovo je sada nova baza:

1. svih 11 core classroom lekcija je prebaceno na Engineering Bootcamp format
2. uveden je zajednicki unlock flow (`cascade.html` -> `playground.html`)
3. lekcije koriste zajednicki mentor model (`academy/src/presentation/apps/lessons/engine/*`)
4. uvedeni su repetitive drills + broken mode + progress validation
5. uklonjeni su inline style blokovi iz core lesson markup-a

Znacenje za plan:

1. vise ne planiramo "osnovnu konverziju" lekcija
2. plan prelazi na hardening, 2026 patch i completion milestone

## 2) Canonical target: 18 sekcija / 62 lekcije (core)

Ovo je baseline koji treba da ispratimo 1:1 sa kursom koji si poslao.

1. Welcome + setup (6)
2. Selectors intro + types (5)
3. CSS syntax + rule anatomy (4)
4. Box model core (6)
5. Typography + text (8)
6. Visual styling: shadows, border, background (8)
7. Display + dimensions (4)
8. Flexbox (3)
9. Grid (3)
10. Spacing formats (padding/margin forms) (5)
11. Position (6)
12. Layering + z-index (2)
13. Media queries (2)

Total: 62

## 3) 2026 completion patch (must add on top of 62)

Core 62 nije dovoljno za 2026 praksu. Dodajemo modern patch kao obavezne mini-module.

1. `@scope` essentials
2. Container queries + CQ units (`cqw`, `cqh`, `cqi`, `cqb`, `cqmin`, `cqmax`)
3. `subgrid` fundamentals
4. CSS math functions `abs()` i `sign()`
5. `content-visibility` i `contain-intrinsic-size`
6. View transitions (`view-transition-name`, `view-transition-class`)
7. `print-color-adjust`
8. Root font metric units: `rcap`, `rch`, `rex`, `ric`

Rule: 62 core ostaje "motor", patch je "2026 upgrade layer".

## 4) Mapiranje na trenutni academy runtime (post-bootcamp)

Bootcamp classroom jezgro (`COMPLETE`):

1. Level 01 Hierarchy -> `/classroom/lesson/cascade`
2. Level 02 Syntax -> `/classroom/lesson/syntax`
3. Level 03 The Box -> `/classroom/lesson/basics`
4. Level 04 Flow -> `/classroom/lesson/display-visibility`
5. Level 05 Pseudo -> `/classroom/lesson/pseudo`
6. Level 06 Styles -> `/classroom/lesson/appearance`
7. Level 07 Flex -> `/classroom/lesson/flex-flow`
8. Level 08 Grid -> `/classroom/lesson/grid-matrix`
9. Level 09 Physics -> `/classroom/lesson/positioning`
10. Level 10 Logic -> `/classroom/lesson/variables`
11. Level 11 Future -> `/classroom/lesson/responsive`

Capstone i pomocni lab:

1. `/playground/challenge` (final challenge lane, in progress)
2. support engine lab module (support tool)

Nedostaje za full production path:

1. capstone rubric inside `/playground/challenge`

Novo dodato (post bootcamp hardening):

1. `/classroom/lesson/motion`
2. `/classroom/lesson/best-practices`
3. `/classroom/lesson/methodologies`
4. `/classroom/lesson/legacy-corner`
5. `academy/AGENTS.md` + architecture docs (feature-sliced app contract)

## 5) Deprecated and legacy in 2026 (teach as legacy only)

As of February 18, 2026.

Deprecated (ne koristiti u canonical resenjima):

1. `clip` -> koristi `clip-path`
2. `page-break-before` -> koristi `break-before`
3. `page-break-after` -> koristi `break-after`
4. `page-break-inside` -> koristi `break-inside`
5. stari flexbox draft API (`box-flex`, `box-orient`, itd.) -> koristi standardni `display: flex` + `flex-*`

Legacy aliases/notacija (dozvoljeno samo kao napomena):

1. `overflow: overlay` (legacy alias za `auto`)
2. `grid-gap` (legacy alias, koristi `gap`)
3. `:before` / `:after` (legacy notacija, koristi `::before` / `::after`)

Policy:

1. legacy/deprecated ide samo u "Legacy Corner"
2. nikad u default starter kodu
3. nikad u expected answer kod challenge zadatka

## 6) Novo za 2026 (obavezno dopuniti u sadrzaj)

As of February 18, 2026.

Baseline 2025 additions koje kurs mora da pokrije:

1. `@scope`
2. view transitions + `view-transition-class`
3. `content-visibility`
4. `abs()`
5. `sign()`
6. `print-color-adjust`

Baseline 2026 additions za CSS fundamentals:

1. `rcap`
2. `rch`
3. `rex`
4. `ric`

Already-modern but mandatory in fundamentals track:

1. container queries (`@container`)
2. subgrid

## 7) Struktura svake lekcije (hard DoD)

Svaka lekcija mora imati:

1. jednu recenicu "core ideja"
2. 1 vizuelni sandbox
3. 1 manual editor task (type it yourself)
4. 1 debug task (pokvaren primer)
5. 1 mini-quiz (3-5 pitanja)
6. 2 MDN reference linka
7. 1 MILOS bridge blok ("isti problem, canonical MILOS izbor")
8. validaciju pokusaja kroz shared mentor engine (`academy/src/presentation/apps/lessons/engine/*`)
9. unlock uslov za "Next Lesson" tek na 100% task completion

Ako ijedna stavka fali, lekcija je `PARTIAL`.

## 8) Sprint plan (enterprise pace)

Sprint 0: Bootcamp conversion (DONE)

1. core classroom lekcije prebacene na drill + validation model
2. standardizovana navigacija kroz curriculum
3. unlock path povezan kroz nivoe

Sprint 1: Bootcamp hardening (7 dana)

1. zatvoriti preostale a11y/lint detalje po svim lesson fajlovima
2. zavrsiti utility migration (ukloniti preostali inline styling gde je smisleno) -> DONE for core lessons
3. uskladiti task quality (isti nivo tezine kroz sve level-e)

Sprint 2: Modern patch 2026 (7 dana)

1. dodati `@scope`, `abs()`, `sign()`, root metric units
2. dodati `content-visibility` i view transitions awareness
3. dodati `print-color-adjust` i print CSS mini practice
4. dopuniti `grid-matrix` sa jasnim `subgrid` drill-om

Sprint 3: Completion milestones (7 dana)

1. prosiriti motion/best/methodologies lekcije 2026 patch temama
2. final capstone rubric i score model

Sprint 4: Capstone release (7 dana)

1. finalizovati `playground.html` kao "Milos Challenge"
2. definisati capstone rubric (grading + pass criteria)
3. final QA: content integrity + link integrity + progression sanity

## 9) Release gates (kada je "spremno za ozbiljan rad")

Kurs je spreman tek kada:

1. core 62 je kompletno pokriven (bez `TODO`)
2. 2026 patch je dodat u relevantne sekcije
3. legacy/deprecated je jasno odvojen
4. svaka lekcija prolazi Hard DoD iz sekcije 7
5. unlock lane radi od `cascade.html` do `playground.html`
6. student moze sam da uradi:
   - layout bez frameworka
   - debug specificity konflikta
   - objasni izbor MQ vs CQ
   - mapira cist CSS izbor na MILOS primitive

## 10) Sources (primary)

1. Web.dev Baseline 2025: https://web.dev/baseline/2025
2. Web.dev Baseline 2026: https://web.dev/baseline/2026
3. MDN `@scope`: https://developer.mozilla.org/en-US/docs/Web/CSS/@scope
4. MDN `@container`: https://developer.mozilla.org/en-US/docs/Web/CSS/@container
5. MDN `subgrid`: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_grid_layout/Subgrid
6. MDN `abs()`: https://developer.mozilla.org/en-US/docs/Web/CSS/abs
7. MDN `sign()`: https://developer.mozilla.org/en-US/docs/Web/CSS/sign
8. MDN `content-visibility`: https://developer.mozilla.org/en-US/docs/Web/CSS/content-visibility
9. MDN `print-color-adjust`: https://developer.mozilla.org/en-US/docs/Web/CSS/print-color-adjust
10. MDN `<length>` (root metric units): https://developer.mozilla.org/en-US/docs/Web/CSS/length
11. MDN `clip` (deprecated): https://developer.mozilla.org/en-US/docs/Web/CSS/clip
12. MDN `page-break-before` (deprecated): https://developer.mozilla.org/en-US/docs/Web/CSS/page-break-before
13. MDN `page-break-after` (deprecated): https://developer.mozilla.org/en-US/docs/Web/CSS/page-break-after
14. MDN `page-break-inside` (deprecated): https://developer.mozilla.org/en-US/docs/Web/CSS/page-break-inside
15. MDN `box-flex` (deprecated, non-standard): https://developer.mozilla.org/en-US/docs/Web/CSS/box-flex
16. MDN `overflow` (overlay legacy alias): https://developer.mozilla.org/en-US/docs/Web/CSS/overflow
17. MDN `gap` (`grid-gap` alias note): https://developer.mozilla.org/en-US/docs/Web/CSS/gap
18. MDN `::before` (legacy single-colon note): https://developer.mozilla.org/en-US/docs/Web/CSS/::before
