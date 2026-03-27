# Architecture Manifesto: Minimalist Signal-Driven Web Components Engine

Dobrodošli u tehnički dokument arhitekture našeg `zero-dependency` engine-a. Cilj ovog dokumenta je da pojasni inženjerske i filozofske odluke koje stoje iza sistema, omogućavajući svakom programeru ili arhitekti da tačno razume kako **reaktivnost** i **DOM manipulacija** funkcionišu ispod haube.

---

## 1. Filozofija (Zašto "Architecture 🅱"?)

Većina modernih framework-a (React, Vue) se oslanja na koncept VDOM-a (Virtual DOM) gde se reaktivno stanje prevodi u celokupno novo DOM stablo, a zatim se vrši takozvani *diffing* i *patching* promena.

Ovaj framework obacuje taj teški pristup u korist **Čiste Signal Arhitekture**.

Princip se sastoji iz sledećeg:

1. **Nema Renderovanih Ciklusa:** Komponenta se *crta* u DOM-u **samo jednom** (kroz `mount()`). Ne postoji VDOM pomirenje (reconciliation).
2. **Reaktivnost Kao Prva Klasa Građanin:** Svi podaci žive u *Signalima*, izgrađenim na modelu "pub-sub" (Observer obrazac).
3. **Direktni Binders:** Ovi signali se privezuju direktno na HTML Node elemente posredstvom mikroskopskih efekata (effects). Kada signal promeni vrednost, obnavlja se samo onaj najmanji mogući atribut i element umesto rerenderisanja komponenti.

---

## 2. Prikaz Strukture Fajlova

Za stabilno upravljanje i lako snalaženje, arhitektura je podeljena u funkcionalne blokove nezavisne namene:

```text
/core
  ├── signals.js     # Čist reaktivni observer. Nije svestan postojanja DOM-a.
  ├── dom.js         # Manipulacija nad nativnim elementima (O(1) DOM bind-ovanje).
  ├── component.js   # Encapsulacija Shadow DOM-a i Web Komponente. Upravlja životnim vekom.
  └── builder.js     # Razvojno-prijemčiv, Fluent DSL API lančani konstrukt.
index.js             # Centralni interfejs ka razvoju same aplikacije (Facade layer).
```

---

## 3. Tehnički Stubovi Sistema

### I. Signal Engine (`core/signals.js`)

*SolidJS stil reaktivnosti.* Ne postoji globalno prop-drilovanje.
Sve reaguje oko tri tačke:

- **`signal(value)`**: Wrappovana reaktivna vrednost.
- **`effect(fn)`**: Radnik. Svaki put kada se signal na koji ukazuje ova funkcija (njen dependency graph) promeni, ova funkcija će se reizvršiti.
- **`computed(fn)`**: Derivirani signal koji emituje nove rezultate tek po promeni pratećih signala.

> **Leak-Safe Pravilo (uz ownership disciplinu)**: Sve efekte koji se pokrenu za vreme *mount*-a jedne komponente, centralna matica registruje unutar komponente. Kada browser ukloni komponentu (`disconnectedCallback()`), registrovani efekti se momentalno uništavaju (`stop(runner)`).

### II. Nativni DOM Alati (`core/dom.js`)

Nismo pravili prevođenje (kompajler), već smo ostali pri brutalno čistom API-ju.
Funkcija `h()` kreira direktan **nativan DOM element** `document.createElement()`, dok se ostali `bindXxx` alati oslanjaju na efekte nad tim DOM-om.

```javascript
const clicks = signal(0);
const spanEl = h("span", { class: "value" });

// DOM element je odmah vezan na Signal
bindText(spanEl, clicks);
```

Ova akcija generiše skriveni Effect u pozadini i svaka izmena unutar `clicks.value++` direktno ažurira tekstualni node. Ne postoji nikakvo brisanje ili preklapanje celog roditeljskog drveta!

### III. Web Komponenta i Sigurnost (`core/component.js`)

Klasa `BaseComponent` nadograđuje standardni standard browsera obezbeđujući nativnu izolaciju CSS modula - `ShadowRoot`.

- Pored stila i inkapsulacije, pretvara primitivna polja za unos HTML atributa (npr. `<m-counter step="5">`) direktno u interne signale unutar samog frameworka. Lookupi su asimptotske složenosti O(1) zahvaljujući asocijativnim hash poljima instanciranim pre renderovanja.
- Takođe, implementiran je domorodački nativni mehanizam Dependency Injection-a tj. **Context API** (preko standardnih *Event Bubble* tehnologija) gde unutrašnje strukture lako dohvaćaju spoljašnje Provider elemente ne dirajući signale.

### IV. Fluent DSL Builder (`core/builder.js`)

Kreiranje Web Komponenti kroz čist JavaScript može izgledati nezgrapno zbog količine protokola koju je neophodno ispratiti.
DSL lanac je tu da taj teret oduzme sa inzenjera i dopusti brz prelaz sa prototipa na "Production" nivo kvaliteta.

```javascript
Component.define("my-button")
   .props({
       theme: { type: "string", default: "light", reflect: true }
   })
   .setup(function() {
      // Inicijalizacije logike pre kreiranja DOM-a
   })
   .mount(function(root, ctx) {
      // Izgradnja interfejsa 1 na 1 i umetanje u root (Shadow/HTML) element
   })
   .register();
```

---

## 4. Zaključak

Primenjujući ovu paradigmu, ovaj framwork uspeva da pretekne standardne reaktivne VDOM mehanizme u performansama. Kriterijumi koji važe su:

- *Očuvani mentalni fokus* developera. Nema "čarolija" ni globalnog praćenja.
- Apsolutna O(1) asimptotika u renderu na UI nivo.
- Jednostavnost implementacije bez paketa veličine 14MB. Svega `<450` probranih linija inženjeringa!
