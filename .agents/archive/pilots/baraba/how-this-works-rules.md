---
title: baraba-how-this-works-rules
owner: platform@baraba
last_reviewed: 2026-03-19
classification: internal
---

# How-This-Works Rules

## Sta je ovaj fajl

Ovo je kanonski standard za `how-this-works.md` dokumente u
`**`.

Ovaj fajl ne opisuje engine logiku.

On opisuje:

- kako `how-this-works` dokument mora da bude napisan
- kojim redosledom mora da uci citaoca
- kako da bude detaljan, vizuelan i lak za potpuno novog coveka

Ovaj standard je preuzeo najjace principe iz PolyMoly flow-doc governance, ali
ih je prilagodio Baraba stilu:

- jos vise edukacije
- jos vise sporog objasnjavanja
- jos vise vizuelnih banalnih primera
- jos vise autor/user price

## 1. Core Idea

`how-this-works` dokument mora da objasnjava kretanje, ne inventar.

To znaci:

- nije dovoljno nabrojati foldere
- nije dovoljno nabrojati fajlove
- nije dovoljno reci sta postoji

Mora da se objasni:

- sta ulazi
- ko prvi prihvata tok
- sta se menja
- sta ide dalje
- sta covek vidi na kraju

Najkrace:

**flow docs moraju da objasnjavaju pricu sistema, ne katalog sistema**

## 2. Kanonski test kvaliteta

Dobar `how-this-works.md` prolazi tek kada potpuni pocetnik moze da preprica:

1. sta ovaj folder stvarno radi
2. koji pravi trigger ili kod ga budi
3. koji fajl i koja funkcija ga hvataju prvi
4. sta je glavni trenutak odluke ili transformacije
5. sta ide dalje
6. sta korisnik vidi u browseru
7. sta autor komponente mora da razume
8. gde treba da debaguje prvo
9. koje termine ce gotovo sigurno pomesati
10. zasto su folder, file i function nazivi posteni

Ako citac to ne moze da preprica svojim recima, dokument nije gotov.

## 3. Redosled ucenja

Svaki `how-this-works` dokument mora da uci ovim redom:

1. human layer
2. author story
3. user story
4. technical layer
5. debug layer
6. dictionary

### 3.1 Human Layer

Otvori dokument kao da ga citas coveku koji:

- nikad nije pravio web komponentu
- nikad nije ulazio u engine kod
- i mora da oseti zasto ovaj folder postoji

Ton mora da bude:

- miran
- prost
- direktan
- strpljiv

Ali ne sme da bude:

- detinjast
- neprecizan
- "slatkast"

Pravilo:

**objasni kao pocetniku, ali tehnicki ostani posten**

### 3.2 Author Story

Ako dokument opisuje interaktivni deo sistema, mora da ima author story.

To znaci:

- 👨‍💻 autor je covek koji zeli da napravi komponentu
- mora da postoji mali scenario sta autor zeli da napravi
- mora da postoji konkretan primer, na primer kalkulator, counter, tabs ili modal

Author story mora da odgovori na pitanja:

- sta autor zeli da napravi
- sta autor pise
- gde engine preuzima njegovu nameru
- gde se autorova ideja pretvara u runtime ponasanje

### 3.3 User Story

Ako dokument opisuje interaktivni deo sistema, mora da ima user story.

To znaci:

- 👤 korisnik je covek koji koristi aplikaciju u browseru
- mora da postoji mali scenario sta korisnik radi
- mora da postoji konkretna radnja: klik, input, change, fokus, otvaranje strane

User story mora da odgovori na pitanja:

- sta korisnik vidi
- sta korisnik radi
- sta se ispod haube desi
- sta korisnik vidi posle toga

### 3.4 Technical Layer

Tek posle author i user price ide tehnicka istina:

- pravi fajlovi
- prave funkcije
- pravi pozivi
- pravi handoff
- pravi rezultat

Tehnicka sekcija mora da bude vezana za realan kod.

Ne sme da zvuci kao da je pisana iz mastanja.

### 3.5 Debug Layer

Na kraju dokument mora da kaze:

- gde gledas prvo ako se nesto pokvari
- koji simptom vodi ka kom fajlu
- gde je najverovatniji kvar

## 4. Vizuelna pravila

Vizuelni deo nije ukras.

Vizuelni deo je obavezni deo ucenja.

### 4.1 Emoji pravilo

U tekstu i Mermaid dijagramima koristi emoji-je kao vizuelne uloge kad god to
pojacava razumevanje.

Kanonske uloge su:

- 👨‍💻 autor
- 👤 korisnik
- 🧠 engine
- 🧩 komponenta
- 🌐 browser
- 💾 state
- ⚡ action
- 🎨 render
- 🔄 update

Ne ubacuj emoji nasumicno.

Koristi ih kao male "slike" koje pomazu da citac prati likove i korake.

### 4.2 Mermaid pravilo

Mermaid nije dekoracija.

Svaki Mermaid mora da uci jedan konkretan tok.

Svaki dijagram mora:

- da ima jasan pocetak
- da ima jasan kraj
- da koristi step logiku
- da prati realan kod

Posle svakog Mermaid dijagrama treba dati kratko objasnjenje:

- sta znaci svaki korak
- zasto je bas taj korak vazan

### 4.3 Banalni primeri

Pozeljni su prosti, banalni, vizuelni primeri:

- calculator
- counter
- tabs
- modal
- toggle
- search box

Primer mora da pomogne coveku da zamisli realnu interakciju.

Ne koristi apstraktne primere ako prost primer radi bolje.

## 5. Obavezna content pravila

Svaki `how-this-works.md` mora da uradi sledece:

1. objasni svrhu foldera prostim jezikom
2. veže priču za pravi trigger
3. imenuje prvi važan fajl i funkciju
4. objasni author flow kada je relevantan
5. objasni user flow kada je relevantan
6. pokaze bar jednu stvarnu putanju od ulaza do rezultata
7. kaze sta ulazi, sta izlazi i sta se menja
8. kaze sta korisnik stvarno vidi u browseru
9. kaze sta ne radi taj folder
10. kaze gde se debaguje prvo
11. zavrsi recnikom

## 6. Obavezna heading struktura

Ako lokalna istina ne trazi bolji naziv, koristi ovaj redosled:

1. `Sta je ovaj folder`
2. `Likovi u ovoj prici`
3. `Dve velike price koje treba da vidis odjednom`
4. `Story 1: Autor ...`
5. `Story 2: Korisnik ...`
6. `Najkraca intuicija`
7. `Sta tacno ulazi u ovaj folder`
8. `U kom trenutku se ... desava`
9. `Glavna putanja kroz sistem`
10. `Prva vazna putanja`
11. `Direktni fajlovi u ovom folderu`
12. `Prvo gledaj ovde kada debagujes`
13. `Sta treba da zapamtis`
14. `Recnik`

Ne mora svaki dokument da ima identicne reci u naslovu, ali mora da prati isti
mentalni redosled.

## 7. Iskrenost prema kodu

Dokument ne sme da izmislja magiju.

Ako je prava putanja:

- `define(...)`
- `constructor()`
- `createActions(...)`
- `renderDisplay(...)`
- `processTemplate(...)`
- `bindEvents(...)`

onda tako mora i da pise.

Ne pisati:

- "sistem nekako poveze klik"
- "engine dalje odradi sta treba"
- "onda se nesto osvezi"

Pisati:

- koji fajl
- koja funkcija
- koji handoff
- koji vidljiv rezultat

Ako nova tvrdnja nije potvrđena kodom, ne ulazi u dokument.

## 8. Zabranjen ton

U `how-this-works` dokument ne ulazi:

- reklama
- meta analiza o tome kako je dokument napisan
- prompt-artifacts
- `contentReference[...]`
- filozofiranje pre svrhe
- genericka arhitektonska poezija
- filler recenice koje zvuce pametno a ne govore nista

Takodje izbegavati:

- previse kratke kosture bez pravog objasnjenja
- suv reference-only stil
- prebrz skok u tehnicke termine bez intuitivnog uvoda

## 9. Naming law mora da se vidi i u dokumentu

`how-this-works` dokument mora da podrzi isto pravilo kao i kod:

- folder kaže tok
- file kaže odgovornost
- function kaže tačnu akciju

Dokument ne sme da ulepsava los naziv.

Ako je naziv mutan, dokument treba to da primeti i prijavi, ne da ga sakrije.

## 10. Mini checklist pre zavrsetka

Pre nego sto oznacis dokument gotov, proveri:

- da li potpuni pocetnik moze da prati pricu
- da li dokument ima i author i user perspektivu
- da li su emoji i Mermaid korisni, ne dekorativni
- da li su primeri banalni i vizuelni
- da li su navedeni pravi fajlovi i funkcije
- da li postoji debug sekcija
- da li recnik zatvara zbunjujuce termine

## 11. Najkraci zakon

Ako zelis da zapamtis samo jednu recenicu, neka bude ova:

> `how-this-works` dokument mora da bude dovoljno detaljan da pocetnik moze da
> vidi pricu, dovoljno vizuelan da moze da je zamisli, i dovoljno posten da je
> svaka recenica vezana za stvarni kod.
