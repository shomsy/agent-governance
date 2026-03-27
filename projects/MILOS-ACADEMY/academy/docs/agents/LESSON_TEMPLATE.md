# MILOS Academy Lesson Template (Lab)

Koristi ovaj template za svaku novu lekciju.

## 1) Lesson metadata

- `lesson_id`: `L01-01`
- `level`: `01..07`
- `title`: kratko i konkretno
- `slug`: `syntax`, `basics`, `grid-matrix`, ...
- `core_question`: "Sta ovde tacno ucim?"
- `canonical_choice`: koji MILOS primitive/modifier je fokus
- `overlap_rule`: sta NE koristiti i zasto

## 2) Struktura strane

1. `Lecture` (teorija)

- 3 do 6 kratkih pasusa
- jedna "Rule #1" kartica
- jedna "Failure mode" kartica

2. `Desk` (sandbox)

- 1 do 3 kontrole (range/select/toggle)
- svaka kontrola menja isti koncept
- live preview mora biti vizuelno ocigledan

3. `Editor`

- reset stanje
- apply akcija
- prikaz trenutnog CSS output-a

4. `References`

- minimum 2 MDN linka
- linkovi vode na primarni standard

5. `Next step`

- jedna jasna CTA putanja ka sledecoj lekciji

## 3) HTML skeleton

```html
<main class="classroom-main">
  <aside class="lecture-sidebar l-stack" style="--gap: 2rem">
    <!-- Theory + controls + next -->
  </aside>

  <section class="interactive-desk">
    <!-- Preview -->
    <!-- Source/Editor -->
  </section>
</main>
```

## 4) JS minimal contract

```js
const el = {
  controls: {},
  preview: null,
  editor: null,
  output: null,
  resetBtn: null,
  submitBtn: null,
};

function update() {}
function reset() {}
function applyManualCss() {}
```

Pravilo:

- Jedna lekcija = jedan mentalni model.
- Ako JS raste preko toga, lekcija je preopterecena.

## 5) Content quality checklist

1. Mogu li pocetnik i mid-level da razumeju razliku izmedju "sta" i "zasto"?
2. Da li je canonical MILOS izbor eksplicitno naveden?
3. Da li postoji konkretan anti-pattern primer?
4. Da li challenge zaista testira razumevanje, ne pamcenje?
5. Da li editor output odgovara onome sto se vidi u preview-u?

## 6) Technical checklist

1. Nema uvodjenja novih `l-*` ili `u-*` klasa.
2. Academy semantika ostaje u `lab/*`.
3. Nema lomljenja postojece navigacije.
4. Stranica radi na 320px, 768px i 1440px.
5. Nema JS gresaka u konzoli.

## 7) Review checklist (pair workflow)

1. Autor: implementira lekciju.
2. Reviewer: proverava canonical choice i overlap disciplinu.
3. Obojica: potvrda da lekcija vodi ka Playground primeni.
