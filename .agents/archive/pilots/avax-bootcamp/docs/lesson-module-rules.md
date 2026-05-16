# Lesson Module Rules

Ovaj dokument definiše šta znači da je nova lekcija u **AVAX Bootcamp** validan modul.

Cilj nije da “dodamo još jedan folder”.

Cilj je da svaka nova lekcija bude:

- predvidiva za autora
- predvidiva za aplikaciju
- predvidiva za AI agente
- dovoljno samostalna da nosi svoj sadržaj, praksu i scenu

## 1. Lesson je modul

Nova lekcija nije slobodan skup fajlova.

Nova lekcija je **modul** koji mora da ispuni jasan contract.

To znači:

- ima svoj entry
- ima svoj content
- ima svoj scene engine
- ima svoj stylesheet
- ima svoj book output
- ima svoje markdown source fajlove

Ako neki od tih delova nedostaje, lekcija nije kompletan modul.

## 2. Obavezna putanja

Lesson modul mora da živi unutar numerisane grupe i numerisanog lesson foldera:

```text
bootcamp/lessons/<group-order>-<group-name>/<lesson-order>-<lesson-name>/
```

Primer:

```text
bootcamp/lessons/02-flexbox/01-flex-layout/
```

Pravila:

- group folder koristi format `NN-name`
- lesson folder koristi format `NN-name`
- redni broj mora da prati flow aplikacije

## 3. Obavezni fajlovi modula

Svaki lesson modul mora da sadrži:

```text
index.js
content/lesson-content.js
scene/actions/update-scene.js
scene/render/render-scene.js
scene/state/scene-state.js
styles/lesson.css
```

Ovo nije preporuka. Ovo je contract.

## 4. Obavezni content source

Svaki lesson modul mora da ima:

```text
content/documents/files/*.md
```

To su source chapter fajlovi koje web lesson učitava.

Najmanje očekivani delovi su:

- `lesson`
- `section`
- `theory`
- `controls`

Poželjno je da lekcija ima i:

- `preview`
- `lessons`
- `theory-easy`
- `theory-pro`
- `quiz`

## 5. Obavezni book output

Svaki lesson modul mora da ima:

```text
content/documents/<lesson_name>.md
```

Taj fajl je linearna, čitljiva “book” verzija iste lekcije.

Pravilo:

- ne održava se ručno
- generiše se iz source markdown chapter fajlova

## 6. Lesson entry contract

`index.js` mora da registruje lekciju preko `createLessonEntry`.

Lesson entry mora da definiše:

- `lesson`
- `sectionTitle`
- `navigationLabel`
- `icon`
- `showCameraControls`
- `updateScene`

Bez toga lekcija nije validan entry modul.

## 7. Lesson content contract

`content/lesson-content.js` mora da definiše lesson object sa obaveznim poljima:

- `id`
- `cssPath`
- `contentPath`
- `documentsPath`
- `state`
- `controls`
- `render`
- `cssGen`

Ovo je minimum koji lesson page i loader očekuju.

## 8. Scene contract

Svaka lekcija mora da ima scene capability sa ovim rasporedom:

- `scene/state/scene-state.js`
- `scene/render/render-scene.js`
- `scene/actions/update-scene.js`

Pravila:

- `state` ne zna za DOM
- `render` prikazuje
- `update-scene` spaja state i render

## 9. Style contract

Svaka lekcija mora da ima lokalni stylesheet:

- `styles/lesson.css`

Dozvoljeno je da importuje shared style fajlove.

Nije dozvoljeno da lesson zavisi od skrivenog globalnog CSS copy-ja bez lokalnog entry stylesheet-a.

## 10. Registration contract

Lesson modul nije gotov dok nije u:

- `bootcamp/lessons/register-lessons.js`

Pravila:

- import mora da pokazuje na numerisanu putanju
- redosled registracije mora da prati flow aplikacije
- lesson `id` mora ostati stabilan kad god je moguće

## 11. Group contract

Svaka numerisana grupa treba da ima generated group book:

- `01-basics/basic.md`
- `02-flexbox/flexbox.md`
- `03-css-grid/css_grid.md`
- ...

To znači da grupa nije samo folder za organizaciju nego i čitljiva zbirka lekcija.

## 12. Root contract

Ceo lessons sistem treba da ima:

- `bootcamp/lessons/lessons.md`

Taj fajl je root knjiga koja spaja ceo learning flow.

## 13. Kako se dodaje nova lekcija

Kanonski tok za novu lekciju je:

1. odaberi group folder po toku učenja
2. odredi sledeći redni broj
3. napravi lesson folder `NN-lesson-name`
4. dodaj obavezne scene/content/style fajlove
5. napiši markdown chapter fajlove u `content/documents/...`
6. registruj lesson u `register-lessons.js`
7. pokreni `npm run sync:lesson-files`
8. pokreni testove

## 14. Šta nije modularni sistem

Ovo nisu prihvatljivi obrasci:

- nova lekcija koja ima samo `index.js` i veliki copy blob
- lekcija bez `documentsPath`
- lekcija bez `content/documents/<lesson>.md`
- lekcija bez scene contract-a
- lekcija koja nije registrovana centralno
- lekcija čiji redni broj ne prati flow

## 15. Pravilo za budući razvoj

Kad uvedemo puni book-first authoring parser, lesson modul i dalje ostaje modul.

Menja se samo authoring source.

Contract ostaje:

- lesson ima jasan ulaz
- lesson ima jasan render tok
- lesson ima jasan book output
- lesson može da se čita i u aplikaciji i van nje
