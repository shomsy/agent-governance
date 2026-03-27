---
title: baraba-how-this-works
owner: platform@baraba
last_reviewed: 2026-03-19
classification: internal
---

# Baraba How This Works

## Sta je ovaj folder

`Baraba` je javna kapija ka Baraba sistemu.

Kad autor u ovom repou zeli da napravi custom element bez frameworka, ovde
počinje priča.

Spolja sve mora da izgleda malo i jednostavno:

- uvezi `define`
- uvezi `html`
- uvezi `css`
- napravi komponentu

Iza te male kapije postoji ozbiljan engine.

Ali poenta ovog foldera je da autor ne mora odmah da zna celu unutrašnjost.

Ovaj folder postoji da bi authoring ulaz ostao ljudski.

## Likovi u ovoj prici

Ovde imamo pet glavnih likova:

- 👨‍💻 **Autor**: programer koji želi da napiše web komponentu
- 🧠 **Engine**: unutrašnji sistem koji od authoring opisa pravi radnu komponentu
- 🧩 **Komponenta**: konkretna instanca koju browser napravi
- 🌐 **Browser**: okruženje koje registruje tag, pravi instancu i pušta lifecycle
- 👤 **Korisnik**: osoba koja vidi komponentu i koristi je u aplikaciji

Kad čitaš ovaj dokument, zamišljaj ovu kratku sliku:

- 👨‍💻 autor napiše komponentu
- `Baraba` je preda engine-u
- 🧠 engine je pretvori u pravi custom element
- 🌐 browser je registruje i kasnije napravi instancu
- 👤 korisnik vidi i koristi komponentu

## Dve velike price koje treba da vidis odjednom

Ovaj folder je mnogo lakše razumeti ako ga gledaš iz dve perspektive.

### 👨‍💻 Priča autora

Autor razmišlja ovako:

- gde da uvezem API
- kako da napišem `define(...)`
- kako da dam komponenti `state`, `actions`, `render` i `styles`
- kako da ne razmišljam odmah o svakom browser detalju

### 👤 Priča korisnika

Korisnik razmišlja potpuno drugačije:

- da li vidim komponentu na ekranu
- da li klik radi
- da li se prikaz menja kako očekujem

Ovaj folder je most između te dve priče.

On autoru daje mali, čist ulaz, a korisniku kasnije omogućava da vidi stvarnu,
radnu komponentu.

## Story 1: 👨‍💻 Autor zeli da napravi web komponentu

Zamisli autora po imenu Milos.

Milos želi da napravi:

- `<note-card>`

Hoće da ova komponenta bude mala kartica sa naslovom, tekstom i dugmetom
"Sakrij detalje".

Milos ne želi da razmišlja odmah o:

- `customElements.define(...)`
- `HTMLElement`
- `shadowRoot`
- `connectedCallback()`
- `attributeChangedCallback()`

On želi da razmišlja ovako:

- "Kako se komponenta zove?"
- "Šta prikazuje?"
- "Šta radi kad korisnik klikne?"

Tu ovaj folder radi veliku stvar.

On Milosu daje miran authoring API:

 ```js
import { define, html, css } from "./baraba.js"
 ```

Drugim rečima:

- 👨‍💻 autor dobija mali ulaz
- 🧠 engine preuzima teži tehnički posao

### Autorov flow

 ```mermaid
flowchart TD
    A["👨‍💻 Milos želi da napravi <note-card>"] --> B["📦 Uveze define, html i css iz baraba"]
    B --> C["🧾 Napiše define('note-card', definition)"]
    C --> D["🧠 Ovaj folder preda definiciju engine-u"]
    D --> E["🧩 Engine pripremi pravi custom element"]
 ```

### Objasnjenje autorovog flow-a

- **👨‍💻 Milos** polazi od komponente koju želi da vidi u aplikaciji.
- **📦 Javni ulaz** mu ne traži da ulazi direktno u engine foldere.
- **🧾 `define(...)`** je authoring jezik koji mu je dovoljan za početak.
- **🧠 Ovaj folder** zatim vodi tu priču ka pravoj mašineriji.
- **🧩 Rezultat** je komponenta koju browser može da registruje i koristi.

## Story 2: 👤 Korisnik zeli da koristi komponentu u browseru

Sada zamisli Anu.

Ana otvara aplikaciju i vidi:

- `<note-card>`

Ona ne zna ništa o:

- `baraba.js`
- `define(...)`
- `createDefinedComponent(...)`
- `customElements.define(...)`

I ne treba da zna.

Nju zanima samo:

- da li kartica postoji
- da li je lepo prikazana
- da li dugme radi

Ono što je za Milosa authoring priča, za Anu je korisničko iskustvo.

### Korisnicki flow

 ```mermaid
flowchart TD
    A["👤 Ana otvori stranicu"] --> B["🌐 Browser vidi registrovani custom tag"]
    B --> C["🧩 Napravi instancu komponente"]
    C --> D["🎨 Komponenta se prikaže na ekranu"]
    D --> E["👆 Ana klikne dugme ili koristi komponentu"]
 ```

### Objasnjenje korisnickog flow-a

- **👤 Ana** vidi gotovu stvar, ne engine.
- **🌐 Browser** je taj koji kasnije oživi registrovani tag.
- **🧩 Komponenta** postaje konkretna instanca u DOM-u.
- **🎨 Prikaz** je ono što Ana stvarno oseća kao "komponenta radi".
- **👆 Interakcija** tek tada dobija smisao.

## Najkraca intuicija

Ako želiš najkraću moguću sliku u glavi, ova je dobra:

`Baraba` je kao recepcija hotela.

- 👨‍💻 autor dolazi sa namerom: "želim da napravim komponentu"
- recepcija ga ne tera odmah u podrum sa mašinama
- recepcija ga uputi u pravi unutrašnji tok

Drugim rečima:

- ovaj folder nije cela zgrada
- ovaj folder je čist ulaz u zgradu

## Sta tacno ulazi u ovaj folder

Pravi ulazi su:

- [`baraba.js`](./baraba.js)
- [`baraba.js`](./baraba.js)

U praksi, autor najčešće piše:

 ```js
import { define, html, css } from "./baraba.js"
 ```

Oba javna ulaza trenutno predaju u isti engine:

- `baraba.js`
- `baraba.js`

To je namerno, zato što je `baraba.js` backward-compatible most dok se
repo konsoliduje.

## U kom trenutku se ovaj folder desava

Ovaj folder ulazi u priču u dva odvojena trenutka.

### 1. 🧾 Authoring trenutak

Autor uveze `define`, `html` i `css`, pa napiše komponentu.

To je trenutak kada priča tek nastaje.

### 2. 🌐 Browser startup i runtime trenutak

Kasnije, kada se modul izvrši:

- browser dobije registraciju taga
- kada taj tag vidi u DOM-u, pravi instancu komponente

Važna razlika:

- `define(...)` se desava kada se JavaScript modul izvrši
- instanca komponente nastaje tek kasnije kada browser vidi tag u DOM-u

## Glavna putanja kroz sistem

 ```mermaid
flowchart TD
    A["👨‍💻 Autor uveze define/html/css"] --> B["📦 baraba primi authoring ulaz"]
    B --> C["🧠 Ulaz preda pricu engine-u"]
    C --> D["🌐 Browser dobije registrovan custom element"]
    D --> E["🧩 Kasnije nastane prava instanca u DOM-u"]
    E --> F["👤 Korisnik vidi i koristi komponentu"]
 ```

### Objasnjenje crteza

- **👨‍💻 Autor** polazi od authoring API-ja.
- **📦 Ovaj folder** drži taj API malim i čistim.
- **🧠 Engine** preuzima tehničku odgovornost.
- **🌐 Browser** pamti šta znači dati custom tag.
- **🧩 Instanca** nastaje tek kada tag stvarno uđe u DOM.
- **👤 Korisnik** na kraju vidi gotov rezultat.

## Prva vazna putanja

Kada autor napiše:

 ```js
import { define, html } from "./baraba.js"

define("hello-card", {
  render() {
    return html`<p>Zdravo</p>`
  }
})
 ```

najvažnija putanja je:

 ```mermaid
sequenceDiagram
    autonumber
    participant Author as 👨‍💻 Autor
    participant Public as 📦 baraba.js
    participant Engine as 🧠 engine/baraba.js
    participant Registry as 🌐 customElements registry
    participant Browser as 🌐 Browser
    participant User as 👤 Korisnik

    Author->>Public: Step 1: uveze define i pozove define("hello-card", ...)
    Public->>Engine: Step 2: javni ulaz preda definiciju engine-u
    Engine->>Registry: Step 3: engine registruje tag
    Registry-->>Browser: Step 4: browser sada zna šta je <hello-card>
    Browser->>Browser: Step 5: kada tag udje u DOM, browser pravi instancu
    Browser-->>User: Step 6: korisnik vidi komponentu na ekranu
 ```

- **Step 1:** Authoring priča počinje na javnom ulazu, ne duboko u engine-u.
- **Step 2:** `Baraba` ne radi celu magiju, nego predaje priču dalje.
- **Step 3:** Registracija taga je granica posle koje browser može da razume komponentu.
- **Step 4:** Browser sada pamti značenje tog taga.
- **Step 5:** Tek u DOM trenutku nastaje živa instanca.
- **Step 6:** Korisnik vidi rezultat čitavog authoring lanca.

## Direktni fajlovi u ovom folderu

### [`baraba.js`](./baraba.js)

Glavni javni ulaz.

Ovo je prvo mesto za nove import putanje.

### [`baraba.js`](./baraba.js)

Kompatibilni most ka istom engine ulazu.

Koristan je dok stari importi još postoje.

### [`how-this-works-rules.md`](./how-this-works-rules.md)

Kanonski standard za sve `how-this-works.md` dokumente u ovom delu repoa.

### [`how-this-works.md`](./how-this-works.md)

Mapa ovog root foldera.

## Podfolderi u ovom folderu

### `engine/`

Otvori [`engine/how-this-works.md`](./engine/how-this-works.md).

Koristi ga kada priča uključuje:

- kako `define(...)` postaje klasa
- kako props i state rade
- kako `render()` stiže do `shadowRoot`
- kako eventi i cleanup rade

## Prvo gledaj ovde kada debagujes

- otvori [`baraba.js`](./baraba.js) ako sumnjaš da je problem u javnom authoring ulazu
- otvori [`baraba.js`](./baraba.js) ako proveravaš backward compatibility import
- otvori [`engine/how-this-works.md`](./engine/how-this-works.md) čim znaš da je problem već ušao u engine tok

## Sta treba da zapamtis

- `Baraba` je authoring ulaz, ne ceo runtime sistem
- javni ulaz mora da ostane mali i predvidiv
- browser ne pravi instancu kad vidi `define(...)`, nego kasnije kad vidi tag u DOM-u
- autor i korisnik gledaju isti sistem iz dve potpuno različite perspektive
- ako želiš unutrašnju mehaniku, sledeći korak je `engine/`

## Recnik

- **`define(...)`**: authoring ulaz kojim autor opisuje komponentu
- **`custom element`**: HTML tag koji browser zna da poveže sa klasom komponente
- **`registry`**: mesto gde browser pamti koji tag pripada kojoj klasi
- **`instance`**: konkretna, živa verzija komponente u DOM-u
- **`authoring`**: trenutak kada programer piše i uvozi komponentu
- **`runtime`**: trenutak kada browser i korisnik stvarno koriste komponentu
