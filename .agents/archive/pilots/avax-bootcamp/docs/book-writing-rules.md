# Book Writing Rules

Ovaj dokument definiše kako se u **AVAX Bootcamp** piše sadržaj kada je cilj da proizvod radi kao:

- web aplikacija za učenje
- čitljiva knjiga u fajlovima
- sistem u kome je sadržaj primarno pisan u Markdown-u, a ne u JS copy objektima

## 1. Glavna ideja

U ovom repou **knjiga nije export sa sajta**.

Cilj je obrnut:

- sadržaj se piše kao knjiga
- web aplikacija taj sadržaj čita i renderuje
- agregatni book fajlovi služe za čitanje van aplikacije

Drugim rečima:

**author piše poglavlja, aplikacija renderuje lekciju**

## 2. Source of Truth

Trenutni kanonski source of truth za lesson copy je:

- `bootcamp/lessons/**/content/documents/**`

To znači:

- `section`
- `lessons`
- `theory`
- `theory-easy`
- `theory-pro`
- `preview`
- `quiz`
- `controls`
- `lesson` frontmatter

dolaze iz `.md` fajlova.

JS ne sme da bude mesto gde se ručno piše teorijski sadržaj lekcije.

Dozvoljeno u JS:

- `id`
- `state`
- `controls` struktura bez copy-ja
- `render`
- `cssGen`
- `sceneSelectors`
- scene i practice logika

Nije dozvoljeno u JS kao kanonski sadržaj:

- naslov teorije
- paragrafi teorije
- preview tekst
- quiz copy
- lesson meta copy
- control label copy

## 3. Lesson kao knjiga

Svaka lekcija treba da može da se čita kao jedna knjiga.

Zato svaka lesson može da ima:

- `content/documents/<lesson_name>.md`

Primer:

- `bootcamp/lessons/01-basics/01-box-model/content/documents/box_model_pro.md`

Taj fajl treba da predstavlja **čitljivu linearnu verziju iste lekcije** koju korisnik vidi na web-u.

## 4. Obavezni delovi jedne lesson knjige

Jedna lekcija kao knjiga treba da prati isti redosled kao web lesson page:

1. lesson title + meta
2. preview
3. section intro
4. lesson flow
5. easy view
6. pro view
7. main theory
8. quiz
9. lab controls appendix

Ako neki deo ne postoji, može da izostane.

Ali redosled ne treba nasumično menjati.

## 5. Kako se pišu chapter fajlovi

Lesson chapter fajlovi treba da žive u:

- `content/documents/files/*.md`

Root `content/documents/` je rezervisan za glavni lesson book fajl.

Lesson chapter fajlovi unutar `content/documents/files/` treba da budu:

- kratki kada služe kao uvod
- detaljni kada nose glavnu teoriju
- semantički imenovani po ulozi u toku učenja

Dozvoljeni chapter tipovi u postojećem sistemu:

- `lesson.sr.md`
- `lesson.en.md`
- `section.sr.md`
- `section.en.md`
- `lessons.sr.md`
- `lessons.en.md`
- `theory.sr.md`
- `theory.en.md`
- `theory-easy.sr.md`
- `theory-easy.en.md`
- `theory-pro.sr.md`
- `theory-pro.en.md`
- `preview.sr.md`
- `preview.en.md`
- `quiz.sr.md`
- `quiz.en.md`
- `controls.sr.md`
- `controls.en.md`

Ovaj vocabulary postoji zato što web lesson trenutno zna da učita te delove direktno.

## 6. Frontmatter pravila

`lesson.<lang>.md` koristi frontmatter za metadata deo.

Minimalan primer:

```md
---
title: Flexbox 1: Kontejner i ose
meta:
- Flexbox
- Main Axis
- Direction
---
```

Pravila:

- `title` mora biti jedna jasna lesson naslovna rečenica
- `meta` je kratak niz tagova
- ne stavljati tehničke interne note u frontmatter

## 7. Preview pravila

`preview.<lang>.md` treba da bude čitljiv i kao web preview i kao knjiga.

Poželjna struktura:

```md
# Preview naslov

Jedan kratak uvodni pasus.

## Quick Tips
- ...
- ...

## Saveti za Pro (Tips and Tricks)
...
```

Ako postoji dijagram:

- koristiti Mermaid blok ili jasan markdown prikaz

## 8. Theory pravila

`theory.<lang>.md` je glavno poglavlje lekcije.

Pravila:

- piši kao poglavlje knjige, ne kao UI tooltip
- koristi prave naslove i podnaslove
- primeri koda moraju biti konkretni
- tekst treba da bude dovoljan i bez scene
- kada uvodiš termin, definiši ga odmah

Poželjno:

- kratko objašnjenje
- analogija
- konkretan CSS/HTML primer
- posledica u realnom layout-u

## 9. Easy i Pro pogledi

`theory-easy` i `theory-pro` nisu marketinški slojevi.

Njihova uloga je:

- `easy`: brza mentalna mapa
- `pro`: stručniji ugao i praktična posledica

`easy` mora biti kratak.

`pro` mora da doda novu vrednost, ne samo da preformuliše isto.

## 10. Quiz pravila

Quiz se piše u markdown formatu koji parser već razume.

Primer:

```md
## Question 1
? Šta se dešava kada...
- [ ] Pogrešno
- [x] Tačno
! Kratko objašnjenje zašto je tačan odgovor tačan.
```

Pravila:

- pitanje mora proveravati stvarno razumevanje
- explanation mora biti kratka, ali konkretna
- ne praviti trivijalna pitanja bez didaktičke vrednosti

## 11. Controls pravila

`controls.<lang>.md` nije teorija.

To je glossary za lab i treba da ostane kratak.

Primer:

```md
- `gap`: Razmak između elemenata
- `direction`: Smer slaganja
```

Pravila:

- jedna linija po kontroli
- bez dugih objašnjenja
- isti ključ kao u control strukturi

## 12. Bilingual pravila

Repo treba da podrži srpski i engleski bez duplog haosa.

Pravila:

- svaki chapter može imati `sr` i `en` varijantu
- ako jedna varijanta ne postoji, fallback je dozvoljen
- terminologija mora biti stabilna kroz celu sekciju
- engleski nazivi CSS termina ostaju u code formi kad treba

Primer:

- `main axis`
- `cross axis`
- `flex container`
- `flex item`

## 13. Group i Root books

Pored lesson knjiga postoje i agregatne knjige:

- group book, npr. `bootcamp/lessons/02-flexbox/flexbox.md`
- root book, npr. `bootcamp/lessons/lessons.md`

Njihova pravila:

- ne pišu se ručno
- generišu se iz lesson source markdown-a
- moraju pratiti isti redosled kao aplikacija

## 14. Zabranjeni obrasci

Ne raditi sledeće:

- pisati teoriju direktno u `lesson-content.js`
- praviti posebnu “CMS” kopiju istog teksta
- držati jednu verziju za web i drugu za knjigu
- gurati bitan sadržaj samo u screenshot, scenu ili dekorativni panel
- pisati chapter naslove kao tehničke interne task nazive

## 15. Kanonski authoring tok

Dok ne uvedemo puni book-first parser, kanonski tok je:

1. napiši ili izmeni chapter `.md` fajlove u `content/documents/...`
2. pokreni `npm run sync:lesson-files`
3. proveri lesson book
4. proveri group book
5. proveri root `lessons.md`

## 16. Ciljni sledeći korak

Dugoročni cilj nije “više markdown fajlova”.

Cilj je:

- da lesson book bude authoring-first format
- da chapter delovi mogu da se izvuku iz knjige deterministički
- da web lesson i knjiga budu dva pogleda nad istim sadržajem

Dok taj parser ne postoji, `content/documents/files/*.md` ostaje source of truth, a `content/documents/<lesson>.md`, group books i `lessons.md` su generated reading views.
