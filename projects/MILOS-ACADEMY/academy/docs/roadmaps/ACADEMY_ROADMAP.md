# MILOS Academy Roadmap

Status: core classroom bootcamp conversion complete; now in hardening + completion phase on canonical Academy paths.

Architecture note:

- Canonical app source is `academy/src/**`.
- Legacy `lab/*` paths are redirect compatibility only (not source of truth).
- Detailed rules are in `academy/AGENTS.md` and `academy/docs/**`.

## 1) Cilj

MILOS Academy je edukativni sloj iznad MILOS Engine-a.

- Engine (`l-*`, `u-*`) ostaje geometrijski i neutralan.
- Academy (`academy-*`, `app-*`, `c-*`, `js-*`) daje narativ, vezbe i mentorisani tok ucenja.

## 2) Granice sistema

- Engine source of truth: `styles/`, `AGENTS.md`, `docs/HOW_TO_BIBLE.md`
- Academy source of truth: `academy/src/**`, `academy/docs/**`
- Zabranjeno: uvodjenje novih framework semantickih klasa kroz Academy.
- Dozvoljeno: app/demo semantika i stilovi samo u canonical academy sloju (`academy/src/presentation/**`).

## 3) Produktni stubovi

1. Campus (`/`)

- mapa puta i progresija kroz nivoe
- "sta i zasto" kontekst

2. Classrooms (`/classroom/lesson/:lessonId`)

- teorija: kratko, jasno, bez buke
- sandbox: kontrolisani slider/select eksperimenti
- editor: rucno kucanje i instant feedback
- reference: MDN linkovi kao eksterni standard

3. Playground (`/playground/challenge`)

- capstone zona: slobodna kompozicija primitiva
- bez novih API trikova, samo primena naucenog

## 4) Kurikulum okvir 

1. Level 01 Syntax & Cascade: 
2. Level 02 Box & Sizing: 
3. Level 03 Paint & Typography: 
4. Level 04 Flex & Flow: 
5. Level 05 Grid & Distribution: 
6. Level 06 Positioning & Layering:
7. Level 07 Responsive & CQ Logic: 

Ukupno: 62

## 5) Definicija gotove lekcije (DoD)

Lekcija je gotova tek kad ima sve:

1. Jednu jasnu "core ideju" u jednoj recenici.
2. Jedan canonical MILOS izbor (npr. kada `l-sidebar`, kada `l-grid--cols-2`).
3. Sandbox kontrole koje menjaju isti koncept, ne vise nepovezanih stvari.
4. Manual CSS editor sa reset + apply.
5. Jedan mini challenge i expected outcome.
6. Minimum 2 MDN linka.
7. Kratku "failure mode" napomenu (sta ljudi najcesce pogrese).
8. Bez inline style i inline lesson logic (use shared modules in `academy/src/presentation/apps/**`).

## 6) Content protokol (rad sa kolegom)

1. Definisati cilj lekcije.
2. Zakljucati canonical primitive.
3. Napraviti sandbox interakcije.
4. Dodati challenge.
5. Dodati MDN proveru.
6. Uraditi tech/content review.

## 7) Exit kriterijum za kasnije izdvajanje u poseban projekat

1. Stabilan lesson template primenjen na vecinu lekcija.
2. Jedinstvena navigacija i metadata model.
3. Bez curenja Academy semantike u engine sloj.
4. Jasna granica: Academy je proizvod, Engine je infrastruktura.

## 8) Fundamentals sync (roadmap-driven)

Prioritet dopune fundamentala vodi se kroz:

- `academy/docs/roadmaps/FUNDAMENTALS_ROADMAP_SYNC.md`
- `academy/docs/roadmaps/CSS_FOUNDATIONS_PATH.md` (CSS-first learning order)
- `academy/docs/roadmaps/CSS_ROADMAP_COVERAGE.md` (coverage + gaps + sprint priority)
- `academy/docs/roadmaps/CSS_2026_COMPLETION_PLAN.md` (canonical backlog: core 62 + 2026 patch)

Pravilo:

- Svaka fundamental tema mora imati:
  - gde se uci (lekcija)
  - kako se vezuje za MILOS canonical izbor
  - koji je tipican anti-pattern koji se eksplicitno pokazuje
