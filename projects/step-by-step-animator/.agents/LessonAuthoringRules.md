# 📜 Lesson Authoring Contract: "Human-First" Script Standard

Ovaj dokument definiše **kanonski ugovor** za pisanje lekcija u *human-first* Write Mode sistemu. Cilj je da autor napiše interaktivnu, animiranu lekciju jednostavno i predvidivo, dok parser i player dobijaju strogu strukturu za pouzdanu validaciju i playback.

---

## 🎯 1. Misija: "Gledaj me dok radim"
Lekcija nije statični tutorijal. To je živi scenario u kojem:
- Autor piše lekciju kao **neprekinuti tok** (scenario).
- Student prati **male, logične promene** koda uživo.
- Svaka promena je pokrivena usmenim objašnjenjem (**Narration**).
- Svaka scena je **pun, funkcionalan trenutak** vremena.

---

## 🏛️ 2. Arhitektura Dokumenta
Lesson Script se sastoji iz dva neodvojiva dela:

### A. Frontmatter (Mašinska glava) ⚙️
Registruje resurse lekcije. Postavlja se na sam vrh između `---`.
- Definiše `lessonId`, `courseId` i `order`.
- Navodi sve fajlove koji će se menjati kroz `artifacts` listu.
- Konfiguriše `preview` prozor u kojem se vidi rezultat.

### B. Body (Pedagoško telo) 🧒
Počinje odmah ispod frontmatter-a. **Prvi stvarni sadržaj** (ne računajući prazne redove) mora biti naslov prvog koraka:
```md
# Step: <step-id>
```

---

## ⚖️ 3. "The Hard Contract" (Parser pravila)
Ova pravila su **obavezna**. Bez njih lekcija neće proći validaciju.

### 📜 Pravilo Step-a (Korak)
- Svaki `# Step: <step-id>` mora imati `title:`, `summary:` i `intent:`.
- `stepId` mora biti stabilan i machine-safe (npr. `visual-shell`).

### 🎬 Pravilo Scene (Kadar)
- Svaki Step mora imati **najmanje jednu** `## Scene: <scene-id>`.
- Svaka scena mora imati `### Narration`.
- Svaka scena mora imati **bar jedan** `### Show Code: <artifactId>`.

### 📸 Pravilo Snapshota (Bez isečaka!)
- Svaki kôd blok mora biti **KOMPLETAN I VALIDAN SNAPSHOT** fajla.
- **ZABRANJENO**: Korišćenje `// ...`, "ostatak klase je isti" ili patch-ova.

---

## 🎨 4. Pedagoški Model: Vizuelna Gradnja i Disciplinovano Oživljavanje
Lekcije za UI i Web Komponente moraju pratiti ovaj strogi pedagoški put:

### Faza 1: Vizuelna Kompozicija (Ljuska)
Prvo gradimo vizuelni deo komponente. Koristimo HTML i CSS. JavaScript u ovoj fazi koristimo **samo onoliko koliko je neophodno** da se taj vizuelni deo izgradi i prikaže.

### Faza 2: Logičko "Oživljavanje" (Mozak)
Kada imamo vizuelnu širu sliku, prelazimo na ponašanje, ali **disciplinovano, deo po deo**:
1. **Jedan Step = Jedna pedagoška celina**: Logika za određeni deo (npr. dugme) je jedan poseban step.
2. **Postepeno oživljavanje**: Oživljavamo vizuelne delove redom, prateći logičke celine.
3. **Koncepti kao alati**: `Lifecycle`, `Events`, `Setup` su oruđa za oživljavanje koji se uvode po potrebi.

---

## 🛠️ 5. Tehničke Zamke (Saveti za Parser) 🧱
- **Prvi Red Nakon Frontmatter-a**: Posle frontmatter-a smeju postojati prazni redovi, ali prvi **stvarni sadržaj** mora biti `# Step:`.
- **ID-evi Bez Specijalnih Karaktera**: Koristi isključivo **kebab-case**. Ne stavljaj dvotačku (:) unutar samog ID-a.
- **Code Fence Mismatch**: Jezik code fence-a (` ``` `) mora odgovarati artifact tipu koji se prikazuje u `### Show Code: <artifactId>`.
- **Unique IDs**: Svaki ID mora biti jedinstven u celoj lekciji radi stabilnosti.

---

## 🌟 6. Zlatna Pravila za Autora (Author Guidance) 💡
- **Vizuelni Delta**: U naraciji uvek usmeri studenta gde da gleda u *Preview* prozoru.
- **Čišćenje pomoćnih stilova**: Svaki Step koji uvodi privremene stilove mora ih ukloniti.
- **Artifact Order (isPrimary)**: Definiši bar jedan artefakt kao `isPrimary: true`.

---

## 🚫 7. Kritične Napomene (Pedagoške smernice) 🙅
- **Tišina u Preview-u (No Ghost States)**: Svaka scena mora ostaviti stabilan vizuelni trag.
- **Skraćivanje Koda**: Čitljivost koda je važnija od kraće skripte. Ne skraćivati snapshots.
- **Fragmentacija Logike**: Nemoj mešati logiku više nepovezanih elemenata u istu scenu.

---

## 🏗️ 8. Minimalni "Playable" Primer

```md
---
schemaVersion: 1
lessonId: human-first-example
lessonTitle: Human-First Standard Example
lessonIntro: Build a tiny card.
status: active
courseId: demo-course
order: 1
artifacts:
  - artifactId: html
    language: html
    label: index.html
    isPrimary: true
preview:
  type: dom
  title: Preview
  address: browser://preview-url
---

# Step: empty-shell
title: Start from an empty shell
summary: Kreiramo prazan prostor za rad.
intent: Vizuelna neutralnost pre prve promene.

## Scene: start-intro
### Narration
Počinjemo od bazičnog HTML-a. Ovo je naša prazna tabla na kojoj ćemo graditi.

### Show Code: html
```html
<div class="app-shell">
  <!-- Prazan shell -->
</div>
```
```

---

## ✅ 9. Brza Provera (Čeklista za Autora)
- [ ] Da li prvi red tela (odmah ispod `---`) počinje sa `# Step:`?
- [ ] Da li se jezik code fence-a poklapa sa tipom artefakta u `Show Code`?
- [ ] Da li naracija usmerava pažnju studenta na konkretnu vizuelnu promenu?
- [ ] Da li se logika uvodi disciplinovano, deo po deo, prateći pedagoške celine?
- [ ] Da li su ID-jevi koraka i scena bez kvačica i dvotački?

---

## 💎 10. Dopuna i Refinements (v1.1 - Final Polishing)
Ovaj deo dopunjuje prethodna pravila dodatnom preciznošću:

### 📍 Re-definicija praznih redova (Parser nuance)
Prazni redovi nakon frontmatter-a **su dozvoljeni**. Ključno tehničko pravilo je da parser ne sme da naiđe na bilo koji tekst (naslov nivoa 2, pasus, komentar) pre nego što naiđe na prvi `# Step:`.

### 📍 Re-definicija Code Fence-a
Pravilo o podudaranju jezika u ogradama (` ``` `) nije vezano za `language` polje iz frontmatter-a, već za konkretan tip koji sistem očekuje za dati `Show Code` blok (npr. `template-js`, `shadow-css`).

### 📍 Balans u Stepovima
Umesto striktnog "Jedan Step = Jedan Element", autor treba da teži pravilu: **"Jedan Step = Jedan pedagoški cilj"**. To može biti jedan kompleksan UI element, ali i grupa povezanih manjih promena koje čine jednu fazu rada.

### 📍 Fleksibilnost Vizuelnog Shell-a
Vizuelna faza ne mora biti 100% statična. Fokus je na tome da student vidi **kompletan i čitljiv vizuelni shell** pre nego što počne implementacija šire logike i API interfejsa. Logika u ovoj fazi treba da ostane niske složenosti.

### 📍 Razdvajanje Contract-a i Guidance-a
- **CONTRACT** (Parser pravila): Sekcije 2, 3 i 5 (naslovi, snapshoti, ID-jevi). Neuspeh ovde znači "Broken Lesson".
- **GUIDANCE** (Pedagoške smernice): Sekcije 1, 4, 6 i 7 (naracija, teaching order, quick wins). Neuspeh ovde znači "Loše iskustvo za studenta".