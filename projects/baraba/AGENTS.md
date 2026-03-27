# Baraba - Governance & Architecture (AGENTS.md)

Ovaj dokument je kanonski standard za ljude i AI agente koji rade nad **Baraba** bibliotekom.

## 1. Glavna arhitektura

Repo je biblioteka za modernu izgradnju i orkestraciju web komponenti.

Glavne root celine su:
- **`engine/`**: Core logika, lifecycle, state management i render loop. Tajna moć Barabe.
- **`tests/`**: Automatizovani testovi koji osiguravaju stabilnost engine-a.
- **Root fajlovi**: Direktne komponente ili entry points (npr. `baraba.js`, `baraba.js`).

Arhitektura je **capability-driven** i **vertical slice** orijentisana. Svaki deo engine-a ili složena komponenta treba da bude autonomna celina.

## 2. Kanonska navigacija kroz kod

Pravilo je:

**folder kaže tok, file kaže odgovornost, function kaže tačnu akciju**

Čovek treba iz putanje da pogodi odgovornost svakog dela sistema bez otvaranja fajla.
Ako putanja ne zvuči kao jasna rečenica, naming nije dovoljno dobar.

## 3. Lokalna organizacija složenog foldera

Svi složeni delovi (uključujući `engine/`) moraju pratiti "Holy Trinity" podelu:

- `state/`: Ne zna za DOM, čuva jedini izvor istine.
- `render/`: Samo prikazuje stanje na osnovu promena, ne menja stanje direktno.
- `actions/`: Sadrži logiku koja menja stanje i izvršava side-effect-e.

Ovaj raspored je obavezan za `engine/` i sve veće komponente.

## 4. Obavezni naming zakon

Izbegavati generičke nazive koji kriju nameru:
- `manager`, `service`, `helpers`, `utils`, `orchestrator`, `controller`.

Dozvoljeni su samo kada nema boljeg domenskog naziva.
Poželjni nazivi su glagolski i direktni:
- `render-engine.js`
- `define-component.js`
- `update-core-state.js`
- `apply-styles.js`

## 5. Pravila za `baraba.js`

`baraba.js` je isključivo javna fasada slice-a.
- Mora biti mali (obično samo exporti).
- Ne sme sadržati tešku logiku.
- Služi da poveže unutrašnje foldere (`state`, `render`, `actions`) u jedan modul.

## 6. Native i Zero-Dependency

- Nema UI frameworka (React, Vue, itd).
- Nema CSS frameworka (Tailwind, Bootstrap).
- Koristiti isključivo native Baraba standarde i ES module.
- Svaka komponenta mora biti self-contained.

## 7. Pravila za `how-this-works` dokumente

`how-this-works.md` dokumenti su edukativni artefakti, ne automatski generisani inventory.
- Dokument mora da objasni **životni ciklus** podataka i rendera.
- Mermaid dijagrame koristiti za vizuelizaciju kompleksnih interakcija.
- Dokument mora biti pisan tako da i novi član tima odmah razume "zašto", a ne samo "kako".

## 8. Disciplina završetka zadatka

Svaki zadatak se OBAVEZNO završava ovom sekvencom:
1. **Commit**: Snimiti promene sa smislenom porukom.
2. **Push**: Podići na remote.
3. **Merge**: Izvršiti `./merge-files.sh .` iz root-a projekta.

Ovo osigurava da je `baraba.txt` (tekstualni snapshot) uvek ažuran.
