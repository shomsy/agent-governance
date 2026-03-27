# AVAX Bootcamp

AVAX Bootcamp je self-hosted interaktivni CSS bootcamp za licnu upotrebu. Ideja proizvoda nije klasican kurs sa pasivnim lekcijama, vec radni prostor u kom su teorija, vizuelna scena, kontrole, CSS editor i kviz spojeni u jedan tok ucenja.

## Biznis ideja

Osnovna ideja projekta je da bude privatna obrazovna platforma za brzo i dubinsko usvajanje CSS-a kroz prakticne mikro-lekcije. Umesto skakanja izmedju dokumentacije, playground-a i beleski, korisnik ostaje u jednoj aplikaciji gde odmah vidi:

- objasnjenje koncepta
- vizuelnu reprezentaciju promene
- kontrole za manipulaciju stanjem
- zivi CSS kod
- proveru znanja kroz kviz

Za sada je projekat namenjen licnim potrebama i self-hosted radu. To znaci:

- sadrzaj je pod potpunom lokalnom kontrolom
- nema zavisnosti od LMS platformi ili third-party course builder alata
- lekcije mogu da se razvijaju kao interni knowledge asset
- platforma moze kasnije da preraste u privatni trening alat za mali tim ili internu akademiju

## Sta aplikacija trenutno radi

Trenutni fokus je interaktivno ucenje CSS osnova i layout sistema kroz lesson-centered tok. Aplikacija vec pokriva teme kao sto su:

- box model
- box sizing i spacing
- display
- flex layout, alignment i wrap
- grid layout, template, masonry i subgrid
- transforms
- glass efekti
- mere i jedinice

Svaka lekcija kombinuje sadrzaj, stanje, practice logiku, scene prikaz i quiz tok u svom slice-u.

## Zasto ova arhitektura postoji

Repo je organizovan kao **flow-first, lesson-centered** sistem. To sluzi da nova lekcija moze da se doda bez uvlacenja u opsti framework sloj i bez tehnickih folder naziva koji kriju domenu.

Glavne root celine su:

- `product/`: app shell, routing, navigation i workspace tok
- `bootcamp/`: lesson domen i LMS logika
- `shared/`: genericki UI i util moduli
- `assets/`: staticki resursi

Osnovno pravilo u kodu je:

**folder kaze tok, file kaze odgovornost, function kaze tacnu akciju**

Jedan izvor istine za registraciju lekcija, ruta i navigacije je:

- `bootcamp/lessons/register-lessons.js`

## Brzo pokretanje

Zbog koriscenja native ES modula, aplikaciju treba pokretati preko lokalnog servera.

1. Otvori terminal u root folderu projekta.
2. Pokreni:

```bash
npm run dev
```

3. Otvori lokalnu adresu koju prijavi `serve`.

## Tehnologije

- Vanilla JavaScript bez UI frameworka
- Vanilla CSS bez CSS frameworka
- Native ES modules
- Lokalni template/render sloj za HTML prikaz

## Status

Projekat je privatan i namenjen self-hosted koriscenju. Fokus je na kvalitetu lesson flow-a, lakoci dodavanja novih lekcija i kontroli nad sadrzajem, a ne na javnom SaaS proizvodu.

Detaljna pravila arhitekture, naming standarda i lesson organizacije nalaze se u `AGENTS.md`.
