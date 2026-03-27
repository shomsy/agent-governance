# Web Components Plan

## Cilj

Napraviti jasnu sledecu iteraciju projekta u kojoj se uvode Web Components u vanilla JavaScript-u, bez rusenja postojece flow-first, lesson-centered arhitekture.

Ova iteracija treba da ostavi vidljiv trag evolucije na GitHub-u:

- `v0.1-baseline-dom` kao stanje pre komponenti
- `v0.2-web-components-foundation` kao prva komponentna iteracija

## Faza 0: Zakucavanje trenutnog stanja

1. Oznaciti trenutno stanje tag-om `v0.1-baseline-dom`.
2. Pushovati tag na GitHub.
3. Po zelji napraviti GitHub Release za baseline verziju.

```bash
git checkout main
git pull
git tag -a v0.1-baseline-dom -m "Baseline before web components"
git push origin v0.1-baseline-dom
```

## Faza 1: Nova razvojna grana

1. Otvoriti posebnu granu za komponentnu etapu.
2. Sav rad za ovu iteraciju raditi van `main`.

```bash
git checkout -b feature/web-components-foundation
git push -u origin feature/web-components-foundation
```

## Faza 2: Scope za v0.2

U ovoj iteraciji uvoditi samo male i stabilne UI primitive.

Dozvoljeno:

- Custom Elements
- `customElements.define(...)`
- klase koje `extends HTMLElement`
- `CustomEvent`
- light DOM

Nije cilj ove iteracije:

- Shadow DOM
- migracija celog workspace-a
- prepisivanje routinga
- uvodjenje nove globalne arhitekture

## Faza 3: Prve komponente

Prvi kandidati za uvodjenje:

1. `avax-control-row`
2. `avax-lesson-preview`
3. `avax-quiz-question`

Razlog:

- mali su i jasno ograniceni
- vec postoje kao izdvojivi render delovi
- dobri su za poredjenje starog DOM pristupa i komponentnog pristupa

## Faza 4: Tehnicka pravila

1. State ostaje van komponenti.
2. Komponente su presentational i interaktivne, ali nisu novi app orchestrator.
3. Parent lesson/workspace sloj i dalje odlucuje sta se desava sa state-om.
4. Komponente emituju `CustomEvent` napolje.
5. U ovoj fazi koristiti light DOM da bi postojeci CSS ostao jednostavan za rad i debug.

## Faza 5: Redosled implementacije

1. Napraviti registry/import tacku za shared custom elements.
2. Uvesti `avax-control-row`.
3. Zameniti postojeci render controls tok novom komponentom.
4. Uvesti `avax-lesson-preview`.
5. Uvesti `avax-quiz-question`.
6. Proci kroz smoke test glavnih tokova.

## Faza 6: Commit strategija

Raditi u vise malih commit-ova da bi se video tok nadogradnje.

Predlog commit poruka:

```text
feat(components): register shared custom elements
feat(controls): add avax-control-row element
refactor(controls): render lesson controls with avax-control-row
feat(lesson-page): add avax-lesson-preview element
feat(quiz): add avax-quiz-question element
docs(readme): describe web components iteration
```

## Faza 7: Provera pre merge-a

Pre spajanja proveriti:

- navigacija lekcija radi
- slider i select menjaju stanje
- preview se pravilno renderuje
- quiz radi bez regresija
- language switch ne puca
- mermaid prikaz ostaje ispravan

## Faza 8: Merge i nova verzija

1. Spojiti feature granu u `main` sa `--no-ff`.
2. Pushovati `main`.
3. Oznaciti novu verziju tag-om `v0.2-web-components-foundation`.
4. Po zelji napraviti GitHub Release za ovu iteraciju.

```bash
git checkout main
git pull
git merge --no-ff feature/web-components-foundation -m "Merge web components foundation"
git push
git tag -a v0.2-web-components-foundation -m "First web components iteration"
git push origin v0.2-web-components-foundation
```

## Definicija uspeha

Ova iteracija je uspesna kada:

- Git istorija jasno pokazuje prelaz iz tradicionalnog DOM renderinga u prvu komponentnu iteraciju
- `main` ostaje citljiv i stabilan
- Web Components su uvedene kao shared UI primitives, ne kao nova paralelna arhitektura
- lako se vidi razlika izmedju starog i novog pristupa
