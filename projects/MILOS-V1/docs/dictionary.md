# 📖 MILOS Rečnik (Dictionary)

Ovo je tvoj prevodilac sa "tehničkog programerskog" na "ljudski vizuelni" jezik. MILOS (**M**odular **I**ntrinsic **L**ayout **O**rchestration **S**ystem) nije samo CSS, to je logički sistem za građenje prostora.

---

## 🗺️ MILOS Mapa (Ontologija)

Pre nego što kreneš, pogledaj kako je sistem podeljen. Ovo je tvoja navigacija kroz arhitekturu.

```text
SHELL (Oklop)            FLOW (Ritam)           DISTRIBUTION (Podela)
  └─ l-page                └─ l-stack             └─ l-grid
  └─ l-container           └─ l-flow              └─ l-switcher
  └─ l-sidebar             └─ l-region            └─ l-cluster
  └─ l-rails                                      └─ l-reel
  └─ l-bleed*

CONTEXT (Soba)           CHOREOGRAPHY (Ples)    APP LAYER (Van engine-a)
  └─ l-cq                  └─ l-align/justify     └─ app-shell
  └─ l-frame               └─ l-self              └─ app-rail
  └─ l-cover               └─ l-span              └─ app-main
  └─ l-imposter            └─ l-order             └─ app-hero
  └─ l-center
  └─ l-box
```

---

## 🎯 10 Pitanja (Brzi filter)

Ako ne znaš šta da koristiš, prođi kroz ovaj test:

1. **Skeleton**: Da li pravim spoljne zidove strane? → **SHELL**
2. **Ritam**: Da li pravim vertikalni razmak teksta? → **FLOW**
3. **Podela**: Da li delim prostor između više elemenata u redu/mreži? → **DISTRIBUTION**
4. **Ograničenje**: Da li samo limitiram dokle sadržaj sme da ide? → **l-container**
5. **Podloga**: Da li mi treba "soba" sa pozadinom i paddingom? → **l-box**
6. **Pomeranje**: Da li pomeram jedan komad nameštaja (npr. dugme)? → **l-center / l-self**
7. **Dubina**: Da li rešavam šta je iznad čega? → **Z-LAYER**
8. **Vazduh**: Da li dodajem razmak OKO sekcije (spolja)? → **l-region**
9. **Aplikacija**: Da li mi treba semantički naziv za ponovljen pattern? → **app-* layer**
10. **Zabranjeno**: Da li pokušavam da uradim dve stvari jednom klasom? → **STOP! Razbij na roditelja i dete.**

---

## 🏠 1️⃣ SHELL – Oklop (Kostur)

**Layer: [PRIMITIVE]**

Ovo su "spoljni zidovi" tvoje aplikacije. Oni govore gde se šta uopšte nalazi na ekranu.

### 🔵 l-page `[PRIMITIVE]`

**Cela strana.** Najveći omotač. Kao korice knjige. On kaže: "Ovde je header, ovde je main, ovde je footer." On drži čitav tvoj svet na okupu.

```text
┌───────────────────────┐
│        HEADER         │
├───────────┬───────────┤
│           │           │
│  SIDEBAR  │   MAIN    │
│  (opt)    │           │
│           │           │
├───────────┴───────────┤
│        FOOTER         │
└───────────────────────┘
```

👉 “Ovo je kompletna struktura strane.”

### 🔵 l-container `[PRIMITIVE]`

**Kutija za čitanje.** Zamisli ogromnu praznu halu gde želiš da tekst stoji samo u sredini, ne od ivice do ivice. To je tvoj čuvar fokusa. Ne dozvoljava sadržaju da pobegne previše levo ili desno na velikim monitorima.

```text
|---------------------- EKRAN (FULL WIDTH) ----------------------|
|                                                                |
|            ┌────────────────────────────────────┐              |
|            │         L-CONTAINER (MAX)          │              |
|            │                                    │              |
|            │      Sadržaj je ovde siguran       │              |
|            └────────────────────────────────────┘              |
|                                                                |
|----------------------------------------------------------------|
```

👉 “Ograniči širinu i centriraj me.”

### 🔵 l-rails `[PRIMITIVE]`

**Magazin Layout.** Ovo je tvoj "Vogue" ili "National Geographic" alat. Dozvoljava deci da plutaju u različitim "stazama" širine unutar iste sekcije. Rezultat je dinamičan, editorijalni osećaj.

```text
┌─────────────────────────────────────────────────┐
│              [ FULL ] SLIKA PREKO SVEGA         │
├─────────────────────────────────────────────────┤
│        ┌───────────────────────────────┐        │
│        │      [ WIDE ] VAŽAN CITAT     │        │
│    ┌───┴───────────────────────────────┴───┐    │
│    │        [ TEXT ] OBIČAN PASUS          │    │
│    └───────────────────────────────────────┘    │
└─────────────────────────────────────────────────┘
```

👉 “Više širina u istom kontekstu.”

### 🔵 l-bleed-root `[PRIMITIVE]`

**Sidro okeana.** Ovo je nevidljivi čuvar koji ide na sam vrh sajta (obično `body`). On kaže: "Sve što probije zidove (bleed) ne sme da napravi horizontalni scroll." Bez njega, tvoj l-bleed bi napravio haos na ekranu.

```text
|   Kontejner   |
| (Horizontalni) |
| ( Scroll ) NO! | ← l-bleed-root (Overflow Clip)
```

👉 “Zabranjuje ljuljanje broda (horizontalni scroll).”

---

## 📐 2️⃣ FLOW – Tok (Ritam)

**Layer: [PRIMITIVE]**

Ovo određuje kako tekst i elementi "dišu" dok teku od vrha ka dnu. Vertikalni ritam koji ne dozvoljava elementima da se guše.

### 🟢 l-stack `[PRIMITIVE]`

**Lego kocke.** Vertikalno ređanje jedne stvari na drugu. On automatski dodaje razmak **IZMEĐU** dece. Zaboravi na `margin-top` na svakom elementu; stack to rešava sistemski.

```text
┌───────────────┐
│    ITEM 1     │
└───────────────┘
        ↕ (Gap)
┌───────────────┐
│    ITEM 2     │
└───────────────┘
        ↕ (Gap)
┌───────────────┐
│    ITEM 3     │
└───────────────┘
```

👉 “Složi nas vertikalno i razmakni nas.”

### 🟢 l-flow `[PRIMITIVE]`

**Reka teksta.** Pametan stek za čitanje artikala. On poznaje tipografiju — zna da naslov treba da bude bliži pasusu koji sledi nego onom iznad.

```text
┌─────────────────────────┐
│  NASLOV (Blizu teksta)  │
│  Pasus teksta...        │
│                         │
│  Pasus teksta...        │
│  (Veći razmak pre sl)   │
│                         │
│  PODNASLOV              │
└─────────────────────────┘
```

👉 “Pusti tekst da teče prirodno (za čitanje).”

### 🟢 l-region `[PRIMITIVE]`

**Vertikalni vazduh.** Razmak **OKO** čitave sekcije (spoljašnji padding). Služi da velike celine sajta udahnu duboko. Hero sekcija ne sme da udara u Features sekciju.

```text
     ↑ (Region Padding Top)
┌───────────────────────────┐
│                           │
│     SEKCIJA SADRŽAJA      │
│                           │
└───────────────────────────┘
     ↓ (Region Padding Bottom)
```

👉 “Ova sekcija mora da udahne duboko.”

### 🟢 l-gap `[MODIFIER]`

**Nevidljiva rukovanja.** Ovo je kontroler razmaka unutar bilo kog layouta. Ne baviš se marginama dece, samo kažeš roditelju koliko jako deca treba da se "drže za ruke".

```text
[ ITEM A ] <---> [ ITEM B ]
               ↑
          (l-gap: gap)
```

👉 “Podesi koliko se elementi drže za ruke.”

---

## 🏁 3️⃣ DISTRIBUTION – Podela (Prostor)

**Layer: [PRIMITIVE]**

Kako se elementi raspoređuju kada se sretnu u istom redu. Horizontalna harmonija.

### 🔶 l-grid `[PRIMITIVE]`

**Matematička mreža.** Kolone i redovi. Precizna 2D podela prostora. Tvoj najbolji alat za kartice, galerije i dashboard panele.

```text
L-GRID--COLS-3              L-SPAN--FULL
┌─────┬─────┬─────┐         ┌─────────────────┐
│  1  │  2  │  3  │         │      S P A N    │
├─────┼─────┼─────┤         ├─────┬─────┬─────┤
│  4  │  5  │  6  │         │  1  │  2  │  3  │
└─────┴─────┴─────┘         └─────┴─────┴─────┘
```

#### 🎨 Katalog Šablona (The Patterns)

- `.l-grid--auto`: **Beskonačna traka.** Ređa elemente dok god staju, bez pitanja.

```text
[      ][      ][      ][      ]
[      ][      ] (Popunjava red)
```

- `.l-grid--balanced`: **Vaga.** Trudi se da svi elementi budu približno iste širine.

```text
[   ITEM   ][   ITEM   ][   ITEM   ]
(Svi dišu istim plućima)
```

- `.l-grid--feature`: **Glavna bina.** Prvi element je ogroman, ostali su manji.

```text
┌───────────────┬───────┐
│               │   2   │
│       1       ├───────┤
│    (HERO)     │   3   │
└───────────────┴───────┘
```

#### �️ Modifikatori Moći

- `.l-grid--collapse-{sm,md,lg}`: **Dugme za paniku.** Instrukcija gridu da se prisilno složi u jednu kolonu kada kontejner postane uži od zadate granice (S, M ili L).

```text
 NORMAL: [A] [B] [C]
COLLAPSE: [ A ]
          [ B ]
          [ C ]
```

�👉 “Složi nas u preciznu mrežu.”

### 🔶 l-switcher `[PRIMITIVE]`

**Pametni lomač.** Savršen za landing page sekcije. U jednom redu je dok ima mesta, a čim postane tesno i počne da se "gužva", svi elementi automatski skaču jedan ispod drugog u punoj širini.

```text
    DESKTOP (Dovoljno mesta)           MOBILE (Premalo mesta)
┌─────────┬─────────┬─────────┐         ┌─────────────────┐
│ CARD 1  │ CARD 2  │ CARD 3  │         │     CARD 1      │
└─────────┴─────────┴─────────┘         ├─────────────────┤
                                        │     CARD 2      │
                                        ├─────────────────┤
                                        │     CARD 3      │
                                        └─────────────────┘
```

- `l-switcher--min-{sm,md,lg,xl}`: **Pravednik.** Ako bilo koji element padne ispod ove širine, svi skaču u kolonu.

```text
      (Wide / Safe)           (Narrow / Panic)
  [  Item  ] [  Item  ]  ->   [      Item      ]
                              [      Item      ]
     (Width > Min)              (Width < Min)
```

👉 “Budi red, postani kolona kad pukneš.”

### 🔶 l-cluster `[PRIMITIVE]`

**Puna činija.** Ređa elemente (npr. tagove, dugmad ili logos) u red, a kad dođu do ivice, samo pređu u sledeći red bez menjanja veličine. Kao voće u činiji.

```text
[A] [B] [C] [D] [E]
[F] [G] [H] (prelom)
```

- `.l-cluster--no-wrap`: **Zid od stakla.** Zabranjuje prelazak u novi red. Svi ostaju u jednoj liniji, pa makar ispali sa ekrana (koristi oprezno!).

```text
[A][B][C][D][E][F][G]... → (Probija zid)
```

👉 “Ređaj nas dok ima mesta, pa u novi red.”

### 🔶 l-reel `[PRIMITIVE]`

**Netflix traka.** Elementi se nikada ne lome u novi red, nego nastavljaju u stranu i prave horizontalni scroll. Idealno za galerije proizvoda na mobilnom.

```text
┌───────────────────────────────┐
│ [A] [B] [C] [D] [E] [F] [G]...│  ← Horizontalni
└───────────────────────────────┘      Scroll
```

👉 “Vrti nas u stranu bez prestanka.”

---

## 🖼️ 4️⃣ CONTEXT – Okruženje (Soba)

**Layer: [PRIMITIVE]**

Kako se element oseća u svom neposrednom okruženju. Ram, podloga i taj "osećaj" prostora.

### 🟣 l-box `[PRIMITIVE]`

**Podloga (Soba).** Kartica sa paddingom. Daje unutrašnji prostor i pozadinu. Box je osnovna gradivna jedinica svake sekcije ili kartice.

```text
┌── (Boundary) ─────────────────┐
│   ┌───────────────────────┐   │
│   │  (Padding)            │   │
│   │    SADRŽAJ JE OVDE    │   │
│   │                       │   │
│   └───────────────────────┘   │
└───────────────────────────────┘

```

- `l-box--{sm,lg,none}`: **Veličina sobe.** Podesi koliko su zidovi (padding) udaljeni od sadržaja. Malo, veliko ili nikako.

```text
  l-box--none      l-box--sm        l-box--lg
┌───────────┐    ┌───────────┐    ┌─────────────┐
│[TEKST]    │    │ ( ) TEKST │    │ (   ) TEKST │
└───────────┘    └───────────┘    └─────────────┘
```

👉 “Napravi mi sobu sa zidovima.”

### 🟣 l-frame `[PRIMITIVE]`

**Ram za sliku.** Čuvar proporcija. Ne dozvoljava slikama ili videu da se deformišu. Kažeš mu "budu uvek 16:9" i on to drži bez obzira na širinu ekrana.

```text
1:1 (Kvadrat)      16:9 (Video)
┌───────────┐      ┌─────────────────────┐
│           │      │                     │
│           │      │                     │
└───────────┘      └─────────────────────┘
```

👉 “Drži mi oblik bez obzira na sve.”

### 🟣 l-cover `[PRIMITIVE]`

**Centar pažnje.** Veliki blok (često punog ekrana) gde je sadržaj tačno u sredini, i horizontalno i vertikalno. Tvoj Hero alat.

```text
┌───────────────────────┐
│                       │
│       ┌───────┐       │
│       │ CENTER│       │
│       └───────┘       │
│                       │
└───────────────────────┘
```

👉 “Pokrij ceo ekran i stavi me u centar.”

### 🟣 l-center `[PRIMITIVE]`

**Sidro.** Uzima jedan element i "usidri" ga horizontalno u samu sredinu roditelja. Za dugmad, logotipe ili naslove koji moraju da budu perfektno centrirani.

```text
┌───────────────────────────────┐
│                               │
│       ┌───────────────┐       │
│       │   CENTRIRAN   │       │
│       └───────────────┘       │
│                               │
└───────────────────────────────┘
```

👉 “Centriraj samo mene vodoravno.”

### 🟣 l-imposter `[PRIMITIVE]`

**Duh.** Element koji lebdi iznad sadržaja (npr. modalni prozor, "X" dugme ili bedž). On nije deo normalnog toka, on je uljez koji dominira.

- `.l-imposter--fixed`: **Zaleđeni duh.** On lebdi iznad čitavog ekrana, čak i dok ti skroluješ. Ništa ga ne pomera.

```text
┌────────────────┐
│  POZADINA      │
│     ┌───────┐  │
│     │ MODAL │  │  ← Lebdi iznad (Z-Layer)
│     └───────┘  │
└────────────────┘
```

👉 “Lebdi iznad svega ostalog.”

### 🟣 l-bleed `[PRIMITIVE]`

**Iskorak (Bekstvo).** Kada si unutar sigurnog kontejnera, ali želiš da slika ili pozadina "pobegne" do same ivice ekrana. Probija zidove bez rušenja strukture.

```text
       ║ l-container ║
       ║             ║
  [====== l-bleed ========]  ← Probija zidove
       ║             ║
```

- `.l-bleed-safe`: **Sigurnosni pojas.** Drži sadržaj dalje od iPhone "notcha" ili zakrivljenih ivica ekrana.

```text
| ( )  SADRŽAJ OVDE  ( ) |
   ↑                  ↑
(Safe Area)        (Safe Area)
```

👉 “Izađi iz kutije i zauzmi ceo ekran.”

### 🟣 l-cq `[PRIMITIVE]`

**Pametna soba.** Nevidljiva granica koja kaže: "Sve unutar mene gleda koliko *ja* (roditelj) imam mesta, a ne koliko je velik ekran telefona." Srce modernog, modularnog dizajna.

```text
┌── Roditelj (l-cq) ──┐
│  ┌─ Dete (Query) ─┐  │
│  │   [ Sadržaj ]   │  │
│  └────────────────┘  │
└──────────────────────┘
```

👉 “Moja soba je moj svet (Container Queries).”

---

## 🩰 5️⃣ CHOREOGRAPHY – Koreografija (Ples)

**Layer: [MODIFIER]**

Kako dirigujemo pokretima elemenata unutar layouta. Fino podešavanje svakog plesača.

### 💃 l-align / l-justify

**Plesna scena.** Dirigovanje čitavom grupom: "Svi u centar!", "Svi levo!", "Svi se rastegnite!".

```text
ALIGN-CENTER (Vertical)     JUSTIFY-END (Horizontal)
┌───────────────────┐       ┌───────────────────┐
│                   │       │                   │
│   [A]  [B]  [C]   │       │           [A][B][C]
│                   │       │                   │
└───────────────────┘       └───────────────────┘
┌─ l-align-center ─────────────┐
│                              │
│  [A]     [B]     [C]         │  ← Svi u istoj liniji
│                              │
└──────────────────────────────┘
```

👉 “Diriguj pokretima čitave grupe.”

### 🕴️ l-self

**Solo plesač.** Menja pravilo za samo jedan specifičan element. Dok svi drugi u grupi stoje verno levo, on može da odluči da skače udesno ili u sredinu.

```text
┌───────────────────────┐
│ [Group] [Group]       │
│                       │
│             [SELF]    │ <--- Skrenuo sa puta
└───────────────────────┘
```

👉 “Pravila samo za mene.”

### 🕴️ l-span

**Kvadratura.** Koliko "polja" ili kolona element zauzima unutar grid mreže ili rails sistema. On kaže: "Ovaj element traži više prostora!"

```text
┌─────────┬─────────┐
│    SPAN FULL      │
├─────────┼─────────┤
│    1    │    2    │
└─────────┴─────────┘
```

👉 “Zauzmi ovoliko kvadrata u gridu.”

### 🔢 l-order

**Preko reda.** Vizuelno pomeranje elementa na početak ili kraj, bez obzira na to gde se nalazi u HTML kodu.

```text
HTML: [ A ] [ B ] [ C ]
            ↓
VISUAL: [ B ] [ C ] [ A ]  ← (.l-order--last)
```

👉 “Promeni redosled bez diranja koda.”

---

## 🧪 6️⃣ MATERIAL BEHAVIOR – Materijali

**Layer: [MODIFIER]**

Od čega su napravljeni tvoji elementi? Kako se ponašaju pod pritiskom?

### 💎 Kamen (`l-shrink`)

**Tvrdo.** Neuništivo. Ne možeš me skupiti ni milimetar. Ja sam ovoliki i takav ostajem, makar razbio layout oko sebe. (Savršeno za ikonice ili fiksne sidebar-ove).

```text
┌───────┐
│ KAMEN │  (Pritisak => Isto ostaje)
└───────┘
```

### 🧽 Sunđer (`l-fill`)

**Meko.** Sunđer upija sav slobodan prostor. On se širi koliko god mu roditelj dozvoli da bi popunio praznine.

```text
┌── Roditelj ───────┐
│[ SUNĐER -------->]│ (Popunjava sve)
└───────────────────┘
```

### 🤵 Odelo po meri (`l-fit`)

**Savršeno pristajanje.** Element će biti tačno onolik koliki mu je sadržaj. Ni milimetar više, ni milimetar manje. Prati te u stopu.

```text
┌───┐
│FIT│ (Nema lufta)
└───┘
```

### 🏙️ Oblakoder (`l-height--full`)

**Visoko.** Proteže se od poda do plafona roditelja bez obzira na sve.

```text
┌──────────┐
│    ↑     │
│  HEIGHT  │
│    ↓     │
└──────────┘
```

### 🖼️ Panoramski pogled (`l-width--wide`)

**Široko.** Više od običnog kontejnera, ali manje od punog ekrana. Idealno za velike grafikone ili galerije unutar teksta.

```text
|------- EK (Full) -------|
|   ┌─────────────────┐   |
|   │     WIDE        │   |
|   │ ┌─────────────┐ │   |
|   │ │    TEXT     │ │   |
|   │ └─────────────┘ │   |
|   └─────────────────┘   |
|-------------------------|
```

👉 “Pusti me da se raširim malo više.”

### 📏 Krojački metar (`l-width--measure`)

**Čitljivo.** Ne dozvoljava tekstu da bude preširok. Oči se umore ako moraju previše da putuju levo-desno. Ovo je tvoj garant uživanja u čitanju.

```text
┌─────────────────┐
│ Idealna širina  │
│ za tvoje oči    │
└─────────────────┘
```

---

## 🏙️ 7️⃣ Z-LAYERS – Spratovi dubine

**Layer: [SETTINGS/MODIFIER]**

Ekrani su ravni, ali MILOS ima nevidljive spratove. Ko je na vrhu, a ko u podrumu?

```text
[ KROV ]     ------------------ l-z-modal
      |
[ 1. SPRAT ] ------------------ l-z-overlay
      |
[ TEPIH ]    ------------------ l-z-raised
      |
[ PRIZEMLJE ] ----------------- l-z-flat
      |
[ PODRUM ]   ------------------ l-z-negative
```

👉 “Na kom si spratu dubine?”

---

## 🍭 Sloj POGODNOSTI (Application Layer)

**Layer: [APP]**

U strict engine režimu nema framework sugar klasa.
Semantičke prečice (`app-shell`, `app-navbar`, `app-hero`, `app-carousel`) pripadaju application layer-u i grade se kompozicijom core primitiva.

---

## 🪄 9️⃣ UTILITIES – Pomagači

**Layer: [UTILITY]**

Specijalni alati za "magične" promene u hodu.

### 🪄 u-hide / u-show

**Nevidljivi ogrtač.** Sakriva ili pokazuje elemente na osnovu širine njihove "pametne sobe" (Container Queries). Nestani na mobilnom, pojavi se na desktopu.

- `--cq-narrow`: Kada je soba uska (kao hodnik).
- `--cq-medium`: Standardna soba.
- `--cq-wide`: Ogromna dvorana.

```text
Desktop: [ Vidljiv ]
Mobile:  [         ]  <-- u-hide--cq-narrow
```

👉 “Hokus Pokus - sada me vidiš, sada ne.”

### 🔍 u-debug

**Rendgen.** Tvoj najbolji prijatelj dok kucaš kod. Boji sve layoute u lude boje tako da tačno vidiš gde se koja kutija završava.

```text
┌── RED (Container) ──────────────┐
│ ┌── BLUE (Stack) ─────────────┐ │
│ │ [ Element ]                 │ │
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

👉 “Vidi kroz zidove layout-a.”

---

## 🎯 Avoid Overlapping (Brutalni Tie-breakers)

Zlatna pravila da ne uzmeš pogrešan alat iz kutije:

### 🟦 l-container vs l-center

- **Container = Zidovi hrama.** Oni drže vernike unutra i određuju širinu čitave zgrade.
- **Center = Oltar.** On stoji u sredini hrama. On je jedan element.

### 🟦 l-stack vs l-region

- **Stack = Police.** Razmak između knjiga u biblioteci (unutrašnja struktura).
- **Region = Sprat.** Razmak između plafona i poda (disanje čitave sekcije).

### 🟦 l-reel vs app-carousel

- **l-reel = Engine.** Horizontalni scroll primitive.
- **app-carousel = Aplikacija.** UI semantika + kontrole iznad `l-reel`.

---

---

## 🔒 ARCHITECTURE FREEZE (Stability Matrix)

| Layer | Definition | Valid Members (Whitelist) | Architecture Status |
| :--- | :--- | :--- | :--- |
| **PRIMITIVE** | Root layout element.<br>Owns structural logic. | `l-page` `l-container` `l-sidebar` `l-rails` `l-bleed-root`<br>`l-stack` `l-flow` `l-region`<br>`l-grid` `l-switcher` `l-cluster` `l-reel`<br>`l-box` `l-frame` `l-cover` `l-center` `l-imposter` `l-bleed` `l-cq` | **🔒 LOCKED**<br>(Zero Additions) |
| **MODIFIER** | Helper class.<br>Modifies specific property. | `l-gap` `l-align` `l-justify` `l-self` `l-span` `l-order`<br>`l-shrink` `l-fill` `l-fit`<br>`l-width--*` `l-height--*`<br>`l-z-*` | **🔒 LOCKED**<br>(Zero Additions) |
| **UTILITY** | Runtime helper.<br>Visual override. | `u-hide` `u-show` `u-debug` | **🔒 LOCKED**<br>(Zero Additions) |
| **SETTINGS** | Global Design Tokens.<br>CSS Variables. | `settings/tokens` `settings/themes`<br>`styles/00-settings/` | **⚠️ CONFIG**<br>(Project specific) |
| **APP LAYER** | Semantic composition.<br>User-land components. | `app-shell` `app-card` `app-hero`<br>`app-*` | **🟢 OPEN**<br>(Infinite Growth) |

- **LOCKED**: Modifying this layer is a Breaking Change (v3.0.0).
- **CONFIG**: Modifying this layer is a Configuration Change (v2.x.0).
- **OPEN**: Modifying this layer is an Additive Change (v2.x.x).

---

## 🏁 MINI RULEBOOK (Zlatni zakoni)

1. **SHELL** = Gde sam na mapi?
2. **FLOW** = Kako dišem dok me čitaju?
3. **DISTRIBUTION** = Kako delim prostor sa drugima?
4. **CONTEXT** = Kakav mi je ram i podloga?
5. **CHOREOGRAPHY** = Gde stojim u sobi?
6. **MATERIAL** = Od čega sam napravljen?
7. **Z-LAYER** = Na kom sam spratu dubine?
8. **APP LAYER** = Imam li semantički naziv za ponovljen pattern?

**ZAKON**: Prvo biraš kategoriju (stub), pa onda alat unutar nje. Ako pokušavaš da uradiš dve stvari odjednom istom klasom — stani i razbij layout na roditelja i dete. **Dizajniramo sistem, ne ad-hoc rešenja.**

**PRIJAVI ONTOLOŠKI DRIFT !!!**
