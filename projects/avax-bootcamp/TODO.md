# TODO: Web Components Engine Hardening

## Status
- [ ] Engine je i dalje edukativan runtime, ne produkcioni renderer
- [ ] Ukloniti "enterprise grade" ton dok ne resimo glavne tehnicke limite

## P0 - Ukloniti destruktivni full re-render
- [ ] Zameniti `shadowRoot.innerHTML = ...` patch pristupom koji ne ubija ceo subtree
- [ ] Sacuvati fokus aktivnog input elementa kroz update
- [ ] Sacuvati selection range za `input` i `textarea` gde je moguce
- [ ] Sacuvati scroll poziciju unutar relevantnih scroll container-a
- [ ] Dodati demo primer sa formom koji dokazuje da update ne resetuje unos

## P1 - Zameniti krhki regex parser
- [ ] Ukloniti regex-oslonjen event parsing iz current template flow-a
- [ ] Uvesti stabilniji marker pristup preko `template` / DOM prolaza
- [ ] Omoguciti robusno vezivanje `@event` bez oslanjanja na krhak levi string segment
- [ ] Pokriti edge-case scenarije: prazne vrednosti, nizovi, nested templejti, mix string + event

## P1 - Smanjiti grubu invalidaciju i nepotrebne render-e
- [ ] Uvesti osnovni dirty-check ili changed-path signal umesto "svaka promena = full render"
- [ ] Spustiti broj nepotrebnih `_requestUpdate()` poziva za no-op promene
- [ ] Ispitati da li prvo treba uvesti fine-grained signals ili laksi intermediate korak
- [ ] Napraviti benchmark scenarijo za vecu listu / dashboard-like prikaz

## P1 - Ojacati props <-> attributes semantiku
- [ ] Preskociti property update kada je nova vrednost semanticki ista kao stara
- [ ] Preskociti reflection u atribut kada se serijalizovana vrednost nije promenila
- [ ] Razmotriti opt-in reflection umesto automatskog reflection-a za svaki prop
- [ ] Dodati test scenario za dve komponente koje medjusobno propagiraju atribute
- [ ] Dokumentovati granicu izmedju internog state-a i javnog prop/attribute contract-a

## P2 - Smanjiti mentalni trosak engine strukture
- [ ] Posle stabilizacije runtime-a proceniti da li neki folderi treba da se spoje
- [ ] Izmeriti da li `define/`, `actions/`, `lifecycle/` zaista smanjuju citanje ili samo sire mapu
- [ ] Zadrzati "folder kaze tok" samo tamo gde realno pomaze sledecem coveku
- [ ] Ako ostaje vise slice-eva, osigurati da svaki ima kratak i jasan `how-this-works.md`

## P2 - Poravnati dokumentaciju sa realnim limitima
- [ ] U `shared/web-components/how-this-works.md` jasno napisati da je engine trenutno learning/runtime-lab sloj
- [ ] U `shared/web-components/engine/how-this-works.md` dodati sekciju "trenutna ogranicenja"
- [ ] Objasniti zasto bi neko birao ovaj engine za ucenje, a ne Lit/Preact za genericki produkcioni UI
- [ ] Dodati roadmap redosled: DOM patching -> parser hardening -> invalidation precision -> API refinement

# TODO: Web Components Authoring API Lockdown

## P0 - Zakljucati jedan kanonski authoring shape
- [ ] Doneti odluku da postoji samo jedan zvanicni `definition` shape za autore komponenti
- [ ] Dokumentovati taj shape kao zakon, ne kao jednu od opcija
- [ ] Uskladiti sve primere i docs da koriste isti shape bez paralelnih stilova
- [ ] Jasno odvojiti author vocabulary od engine vocabulary

## P0 - Zakljucati jedan kanonski event model
- [ ] Doneti odluku da li je template event syntax jedini zvanicni stil
- [ ] Ako ostaje template event syntax, ograniciti `onConnect` na spoljne side effect-e i integracije
- [ ] Zabraniti paralelni drugi mentalni model za DOM event binding u author docs
- [ ] U dokumentaciji objasniti zasto postoji bas taj jedan izbor

## P1 - Precizno definisati semantiku author sekcija
- [ ] Zakljucati semantiku za `props`
- [ ] Zakljucati semantiku za `state`
- [ ] Zakljucati semantiku za `actions`
- [ ] Zakljucati semantiku za `render`
- [ ] Zakljucati semantiku za `onConnect`
- [ ] Zakljucati semantiku za `onCleanup`
- [ ] Zakljucati semantiku za `onPropsChanged`
- [ ] Jasno napisati sta nije dozvoljeno u svakoj od ovih sekcija

## P1 - Brze odvojiti author API od engine unutrasnjosti
- [ ] Tretirati `shared/web-components/index.js` kao jedini kanonski author ulaz
- [ ] Svesti author dokumentaciju na minimalni javni API koji autor zaista koristi
- [ ] Ostaviti `engine/` dokumentaciju kao maintainer mapu, ne kao author početnu tačku
- [ ] Proveriti da author docs ne cure u engine detalje bez potrebe

## P1 - Uvesti contract tests za author API
- [ ] Dodati testove za props parsing
- [ ] Dodati testove za state update flow
- [ ] Dodati testove za cleanup kroz `disconnectedCallback`
- [ ] Dodati testove za event binding i unbinding
- [ ] Dodati testove za update scheduling
- [ ] Dodati testove za javni contract `define`, `html`, `css`

## P2 - Dodati 3 kanonske referentne komponente
- [ ] Napraviti najjednostavniji primer komponente
- [ ] Napraviti srednje interaktivan primer sa `state` i `actions`
- [ ] Napraviti slozeniji primer sa props, event flow i cleanup-om
- [ ] Koristiti te primere kao zvanicni stil kroz dokumentaciju i lekcije

## Definition of Done za authoring API iteraciju
- [ ] Autor komponente vidi jedan jedini kanonski shape
- [ ] Autor komponente vidi jedan jedini kanonski event model
- [ ] Razlika izmedju author docs i engine docs je jasna na prvi pogled
- [ ] Contract tests cuvaju author API od tihog raspadanja
- [ ] Tri referentne komponente pokazuju isti stil bez kontradikcija

## Definition of Done za sledecu iteraciju
- [ ] Komponenta sa input poljem vise ne gubi fokus pri svakom update-u
- [ ] Scroll unutar komponente ostaje stabilan kroz update
- [ ] Event binding ne zavisi od regex hack-a nad static string delovima
- [ ] No-op prop set ne zakazuje novi render
- [ ] Dokumentacija otvoreno navodi sta engine jeste, a sta jos nije
