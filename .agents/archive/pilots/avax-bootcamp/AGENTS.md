# AVAX Bootcamp - Governance & Architecture (AGENTS.md)

Ovaj dokument je kanonski standard za ljude i AI agente koji rade nad **AVAX Bootcamp** repoom.

## 1. Glavna arhitektura

Repo nema `src/` root.

Glavne root celine su:
- **`product/`**: app shell, workspace, routing, navigation i sve što gradi samu aplikaciju.
- **`bootcamp/`**: LMS domen, lekcije i sav tok učenja.
- **`shared/`**: zaista generički UI i util moduli.
- **`assets/`**: statički resursi.

Arhitektura je:

**flow-first, lesson-centered vertical slices**

To znači:
- putanja mora da prati tok proizvoda
- lekcija je osnovna autonomna jedinica
- domen vodi strukturu, ne tehnički layer nazivi

## 2. Kanonska navigacija kroz kod

Pravilo je:

**folder kaže tok, file kaže odgovornost, function kaže tačnu akciju**

Čovek treba iz putanje da pogodi:
- gde se lekcija otvara
- gde je teorija
- gde je praksa
- gde je scena
- gde je kviz
- gde se čuva progres

Ako putanja ne zvuči kao jasna rečenica, naming nije dovoljno dobar.

## 3. Root struktura

Podrazumevana root struktura je:
- **`product/app-shell/`**
- **`product/routes/`**
- **`product/navigation/`**
- **`product/workspace/`**
- **`bootcamp/lessons/`**
- **`shared/lib/`**
- **`shared/ui/`**
- **`assets/`**

Ne vraćati FSD layer navigaciju kao primarni način orijentacije.

## 4. Lekcija je osnovni slice

Svaka lekcija živi u svom folderu:

`bootcamp/lessons/<lesson-name>/`

Svaka lekcija mora da bude dovoljno samostalna da može da nosi:
- svoj opis i sadržaj
- svoj state
- svoju practice logiku
- svoju scene logiku
- svoj quiz tok
- svoj stylesheet

Svaka lekcija sme da ima sopstveni scene engine i drugačiji način rada.

Podrazumevana lesson root struktura je:
- `index.js`
- `content/`
- `scene/`
- `styles/`

Za lesson slice važi strogo pravilo:
- `index.js` je jedini root fajl po defaultu
- root ne treba da ponavlja pomoćne fasade ako ih shared sloj već rešava
- teži sadržaj i definicija lekcije žive ispod `content/`

## 4.1. Kanonsko sastavljanje lekcije

Lesson slice se ne sastavlja kroz više root fajlova koji rade istu stvar.

Kanonski obrazac je:
- `index.js` kao javna fasada lesson slice-a
- `content/lesson-content.js` kao telo lekcije
- `scene/` i `styles/` kao lokalne capability celine

To znači:
- root ostaje mali i prediktivan
- `index.js` povezuje lesson sadržaj sa registracijom i otvaranjem lekcije
- ako lekcija poraste, delovi se izdvajaju u manje domenske foldere i skupljaju ispod `content/`

Na nivou feature root-a važi sledeće:
- ako feature stvarno vodi sekvencijalan tok, root fajl sme biti `pipeline.js`
- ako feature ne vodi sekvencijalan tok, root fajl je mala fasada
- root fajl ne sme biti veliki monolit

Za lesson slice je dozvoljeno da teži sadržaj živi u:
- `content/lesson-content.js`
- `content/theory/`
- `content/practice/`
- `content/quiz/`
- `practice/`
- `theory/`
- `quiz/`
- drugim jasno imenovanim podcelinama kada stvarno smanjuju mentalni trošak

Poželjno:
- `index.js` koji samo povezuje lesson sadržaj, scene update i entry metadata
- `content/lesson-content.js` koji nosi lesson state, controls, theory, quiz i render definiciju
- dodatni folderi tek kada značenje postane jasnije nego jedan veliki fajl

Nepoželjno:
- `define-lesson.js` i `open-lesson.js` kao podrazumevani duplikati u svakom lesson root-u
- jedan golemi lesson definition fajl koji meša sav sadržaj i setup bez jasnog sastavljanja
- tehnički nazivi koji kriju domen (`manager`, `factory`, `service`)

## 5. Obavezni naming zakon

Izbegavati kao default nazive:
- `pipeline`
- `manager`
- `service`
- `helpers`
- `utils`
- `orchestrator`
- `controller`
- `manifest`

Dozvoljeni su samo kada stvarno opisuju stvarnu odgovornost i kada nema boljeg domenskog naziva.

Poželjni nazivi fajlova i funkcija su glagolski i direktni:
- `render-theory.js`
- `change-control-value.js`
- `sync-editor.js`
- `apply-live-css.js`
- `save-progress.js`
- `check-answer.js`
- `update-scene.js`

Funkcije treba da zvuče ovako:
- `openLesson`
- `renderTheory`
- `changeControlValue`
- `syncEditor`
- `saveProgress`
- `checkAnswer`

Ne koristiti nazive tipa:
- `handleData`
- `processThing`
- `run`
- `execute`

## 6. Lokalna organizacija složenog domain foldera

Kada je domain folder dovoljno složen, podrazumevana lokalna podela je:
- `state/`
- `render/`
- `actions/`

Pravila:
- `state/` ne zna za DOM
- `render/` samo prikazuje
- `actions/` menja stanje i radi side effect-e

Ako `actions/` postane složen podsistem, ili jedan folder počne da skuplja previše fajlova, tek tada sme dalje da se podeli na:
- `input/`
- `commands/`
- `events/`

To nije default. To je drugi nivo složenosti.

## 6.1. MVC nije javna navigacija

Ne uvoditi MVC po folderima kao glavni jezik repo-a.

To znači:
- ne praviti `model/`, `view/`, `controller/` kao podrazumevanu navigaciju kroz domen
- ne koristiti `controller` kao zamenu za nejasnu akciju
- ne koristiti `MVC` kao glavnu arhitekturu repo-a

Dozvoljeno je samo sledeće:
- odvojiti stanje
- odvojiti prikaz
- odvojiti promene stanja i side effect-e

Ali to treba nazivati jezikom domene:
- `scene/state/scene-state.js`
- `scene/render/render-scene.js`
- `scene/actions/change-view-mode.js`

Dakle:
- **flow-first** je spoljašnja arhitektura
- **state/render/actions** je lokalna unutrašnja disciplina
- **input/commands/events** je opcioni drugi nivo unutar `actions/`

Ako neko kaže "MVC", to u ovom repou znači samo odvajanje odgovornosti, ne i javni folder vocabulary.

## 7. Kada vredi lokalno odvajanje odgovornosti

Uvodi lokalno `state/render/actions` tek kada su prisutna sva tri simptoma:
- deo ima sopstveno stanje
- deo ima više vrsta UI ažuriranja
- deo ima više ulaznih događaja koji menjaju stanje

Ako toga nema, nemoj uvoditi ceremoniju.

Izuzetak od ovog pravila su `scene/` folderi.

Svaki `scene/` folder mora da koristi sledeći raspored:
- `scene/state/scene-state.js`
- `scene/render/render-scene.js`
- `scene/actions/update-scene.js`

Razlog:
- scene je dovoljno važna i česta capability celina
- ljudima je lakše da odmah pogode gde je stanje, gde je prikaz i gde je akcija osvežavanja
- ova kvazi-MVC struktura je u sceni čitljivija nego flat raspored

Ako `scene/actions/` postane složen i ako jedan folder počne da ima previše fajlova, tada je dozvoljeno dodatno unutrašnje grananje na:
- `scene/actions/input/`
- `scene/actions/commands/`
- `scene/actions/events/`

To uvoditi samo kada stvarno poboljšava čitljivost.

Pravilo je:
- `input/` prima spoljne signale ili DOM ulaze
- `commands/` sadrži namerne akcije promene scene
- `events/` sadrži posledice i objave da se nešto u sceni desilo

Ne uvoditi ovaj drugi nivo prerano.

## 8. Jedan izvor istine za lekcije

Sve lekcije, rute i navigacija moraju polaziti iz jednog registra:

- **`bootcamp/lessons/register-lessons.js`**

Nije dozvoljena trostruka registracija kroz:
- HTML
- workspace kod
- poseban lesson registry

HTML ne sme ručno da ponavlja listu lekcija ako ona već postoji u registru.

## 9. Pravila za `index.js`

`index.js` je dozvoljen kao javna fasada slice-a.

Ali:
- mora biti mali
- ne sme postati tajni komandni centar
- ne sme skupljati sav tok i side effect-e

Ako `index.js` postane previše pametan, tok treba razdvojiti u jasnije named fajlove.

## 10. Pravila za scene logiku

Sekcija 7 definiše obaveznu strukturu scene.

Dodatna pravila za scene su:
- ne držati centralni globalni switchboard za sve scene ako lekcije imaju sopstvenu logiku
- zajedničke scene helper-e izdvajati samo kada su stvarno deljeni
- scene update mora biti determinističan i zasnovan isključivo na prosleđenom state-u

## 11. UI, sadržaj i jezik

- Ne uvoditi UI frameworke.
- Ne uvoditi CSS frameworke.
- Koristiti native ES module.
- Ne koristiti placeholder tekst.
- Sadržaj i fallback copy moraju biti smisleni i pretežno na srpskom.
- Engleski je dozvoljen kao alternativni jezik, ne kao slučajan fallback.

## 11.1. Pravila za SVG, dijagrame i ilustracije

Vizuelni asset-i u lekcijama moraju biti čitljivi bez dodatnog zumiranja i bez vizuelnog konflikta.

Obavezna pravila:
- nijedan tekst, label, strelica, panel ili dekorativni oblik ne sme da preklapa drugi sadržaj
- dekorativne forme ne smeju da prolaze preko naslova, objašnjenja, koda ili ključnih oznaka
- između kolona, kartica i callout blokova mora da postoji jasan gutter; ne gurati copy "na ivicu"
- ako sadržaj ne staje, smanji količinu teksta, prelomiti ga u više redova ili povećati canvas; nikad ne ostavljati sudar elemenata
- SVG i slike moraju da budu provereni u stvarnoj širini lesson prikaza, ne samo u izolovanom editor preview-u

## 12. Pravila za izmene repo-a

1. Ne dodavati nove dependency-je bez jakog razloga.
2. Ne uvoditi novu arhitekturu paralelno sa starom ako stara ostaje glavni tok.
3. Ako pomeraš kod, pomeri i registraciju, rute i navigaciju u istom zahvatu.
4. Kad god je moguće, zadrži backward-compatible lesson `id` vrednosti.
5. Pre svake veće podele foldera proveri da li ona stvarno smanjuje mentalni trošak.

## 13. Pravila za `how-this-works` dokumente

`how-this-works.md` dokumenti moraju da budu edukativni flow dokumenti, ne kratki inventari fajlova.

Za `shared/web-components/**/how-this-works.md` važi kanonski standard iz:

- `shared/web-components/how-this-works-rules.md`

Obavezna pravila:
- dokument mora da objasni kretanje kroz sistem, ne samo šta postoji
- dokument mora da bude dovoljno spor i detaljan za potpunog početnika
- dokument mora da koristi human layer pre tehničkog layer-a
- kada je deo sistema interaktivan, dokument mora da ima i author story i user story
- emoji i Mermaid su poželjni kada stvarno pomažu vizuelnom učenju
- banalni, konkretni primeri su bolji od apstraktnih primera
- dokument mora da imenuje prave fajlove i prave funkcije; ne sme da izmišlja magiju
- dokument mora da kaže šta korisnik stvarno vidi u browseru i gde se debaguje prvo

## 14. Disciplina završetka zadatka

Svaki zadatak, bez obzira na veličinu, mora se završiti sledećom sekvencom:
1. **Commit**: Snimiti sve promene sa jasnom porukom.
2. **Push**: Podići promene na remote repozitorijum.
3. **Merge**: Izvršiti `./merge-files.sh .` iz root-a projekta nad celim projektom.

Ovo osigurava da je stanje koda uvek sinhronizovano i da postoji ažuran tekstualni snapshot celog repoa radi lakšeg AI pregleda.

