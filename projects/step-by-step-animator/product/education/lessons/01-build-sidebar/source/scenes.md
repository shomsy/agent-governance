---
schemaVersion: 1
lessonId: 01-build-sidebar
steps:
  - stepId: empty-shell
    title: "Start: Empty App Shell"
    summary: Počinjemo od praznog `.app-shell` prostora. Sidebar tek dodajemo kao
      prvi pravi element.
    intent: Neutralan početak jasno odvaja ono što je postojalo od onoga što tek
      gradimo.
    tag: html:app-shell
    proTip: Neutralan početak jasno odvaja ono što je postojalo od onoga što tek
      gradimo.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: sidebar-html
    title: "HTML: Sidebar Shell"
    summary: Ubacujemo osnovni `<aside class="sidebar">` blok kao koren cele komponente.
    intent: Semantički HTML ti odmah daje bolju strukturu i čitljiviji DOM.
    tag: html:aside
    proTip: Semantički HTML ti odmah daje bolju strukturu i čitljiviji DOM.
    focusHtmlNeedles:
      - class="sidebar"
  - stepId: shell-outline
    title: "CSS: .app-shell / outline"
    summary: Dodajemo tanak helper outline za `.app-shell` i zadržavamo ga kroz celu
      lekciju, sve do završnog shell rezimea.
    intent: App shell ostaje stalni okvir cele demonstracije dok ne završimo ceo
      tutorijal.
    tag: css:shell-outline
    proTip: App shell ostaje stalni okvir cele demonstracije dok ne završimo ceo
      tutorijal.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: sidebar-outline
    title: "CSS: .sidebar / outline"
    summary: Dodajemo tanak helper outline da footprint sidebara ostane jasan kroz
      ceo lesson tok. Skidamo ga tek u završnom rezime koraku za `.sidebar`.
    intent: Outline ostaje aktivan dok ne završimo rezime za ovaj element.
    tag: css:sidebar-outline
    proTip: Outline ostaje aktivan dok ne završimo rezime za ovaj element.
    focusHtmlNeedles: &a1
      - class="sidebar"
  - stepId: sidebar-width
    title: "CSS: .sidebar / width"
    summary: Kad granica postoji, zaključavamo širinu sidebara da dobije jasan
      footprint.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:sidebar-width
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a1
  - stepId: sidebar-min-height
    title: "CSS: .sidebar / min-height"
    summary: Dajemo sidebaru punu visinu da box postane čitljiv i bez sadržaja.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:sidebar-min-height
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a1
  - stepId: sidebar-border-right
    title: "CSS: .sidebar / border-right"
    summary: Tanka desna linija odvaja sidebar od ostatka layouta.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:sidebar-border-right
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a1
  - stepId: sidebar-background
    title: "CSS: .sidebar / background"
    summary: Dodajemo tamnu pozadinu da sidebar dobije svoj vizuelni identitet, ali
      outline namerno ostaje do rezime koraka za `.sidebar`.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:sidebar-background
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a1
  - stepId: sidebar-color
    title: "CSS: .sidebar / color"
    summary: Osnovnu boju teksta postavljamo rano da nasledi ceo sadržaj.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:sidebar-color
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a1
  - stepId: brand-html
    title: "HTML: Brand Wrapper"
    summary: Dodajemo `.sidebar-brand` kao zonu za logo i naziv proizvoda. Svi brand
      elementi zadržavaju svoje outline helpere do završnog brand rezimea.
    intent: Izdvoj brand deo od navigacije da bi hijerarhija odmah bila jasna.
    tag: html:brand
    proTip: Izdvoj brand deo od navigacije da bi hijerarhija odmah bila jasna.
    focusHtmlNeedles:
      - class="sidebar-brand"
  - stepId: brand-outline
    title: "CSS: .sidebar-brand / outline"
    summary: Dodajemo tanak helper outline za `.sidebar-brand` i držimo ga do
      završnog rezime koraka za brand celinu.
    intent: Svaki deo iste celine može da dobije svoju boju helper linije dok ta
      celina traje.
    tag: css:brand-outline
    proTip: Svaki deo iste celine može da dobije svoju boju helper linije dok ta
      celina traje.
    focusHtmlNeedles: &a2
      - class="sidebar-brand"
  - stepId: brand-padding
    title: "CSS: .sidebar-brand / padding"
    summary: Unutrašnji padding daje brand zoni vazduh.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:brand-padding
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a2
  - stepId: brand-margin-bottom
    title: "CSS: .sidebar-brand / margin-bottom"
    summary: Odvajamo brand blok od navigacije ispod njega.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:brand-margin-bottom
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a2
  - stepId: brand-display
    title: "CSS: .sidebar-brand / display"
    summary: Prebacujemo brand zonu u flex da logo i tekst mogu da stoje u istom redu.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:brand-display
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a2
  - stepId: brand-align-items
    title: "CSS: .sidebar-brand / align-items"
    summary: Vertikalno poravnanje centrira logo i tekst.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:brand-align-items
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a2
  - stepId: brand-gap
    title: "CSS: .sidebar-brand / gap"
    summary: Gap određuje koliko prostora stoji između logotipa i teksta.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:brand-gap
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a2
  - stepId: logo-html
    title: "HTML: Logo Element"
    summary: Ubacujemo `.logo` element sa slovom `A` kao placeholder identitetom.
    intent: Počni od jednostavnog placeholder loga pa tek onda doteruj stil.
    tag: html:logo
    proTip: Počni od jednostavnog placeholder loga pa tek onda doteruj stil.
    focusHtmlNeedles:
      - class="logo"
  - stepId: logo-outline
    title: "CSS: .logo / outline"
    summary: Dodajemo tanak helper outline za `.logo` i držimo ga do završnog brand
      rezimea.
    intent: Logo zadržava svoju helper boju sve dok radimo brand celinu.
    tag: css:logo-outline
    proTip: Logo zadržava svoju helper boju sve dok radimo brand celinu.
    focusHtmlNeedles: &a3
      - class="logo"
  - stepId: logo-width
    title: "CSS: .logo / width"
    summary: Prvo zaključavamo širinu logotipa.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:logo-width
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a3
  - stepId: logo-height
    title: "CSS: .logo / height"
    summary: Visina prati širinu da bismo dobili kvadratnu osnovu.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:logo-height
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a3
  - stepId: logo-display
    title: "CSS: .logo / display"
    summary: Grid nam daje lak centar za jedan znak ili ikonu.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:logo-display
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a3
  - stepId: logo-place-items
    title: "CSS: .logo / place-items"
    summary: Centriramo sadržaj logotipa u oba smera.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:logo-place-items
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a3
  - stepId: logo-radius
    title: "CSS: .logo / border-radius"
    summary: Blago zaobljenje daje moderniji osećaj.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:logo-radius
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a3
  - stepId: logo-font-weight
    title: "CSS: .logo / font-weight"
    summary: Pojačavamo slovo da liči na pravi brand znak.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:logo-font-weight
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a3
  - stepId: logo-background
    title: "CSS: .logo / background"
    summary: Gradijent dodaje energiju i daje logotipu fokus. Outline namerno ostaje
      do brand rezimea.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:logo-background
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a3
  - stepId: logo-color
    title: "CSS: .logo / color"
    summary: Bela boja daje čist kontrast preko gradijenta.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:logo-color
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a3
  - stepId: logo-shadow
    title: "CSS: .logo / box-shadow"
    summary: Shadow dodaje depth i čini logo prisutnijim.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:logo-shadow
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a3
  - stepId: brand-copy-html
    title: "HTML: Brand Copy"
    summary: Dodajemo `.brand-copy` sa naslovom i podnaslovom pored logotipa. I on
      zadržava svoj outline do završnog brand rezimea.
    intent: Tekstualni brand signal pomaže korisniku da zna gde se nalazi.
    tag: html:brand-copy
    proTip: Tekstualni brand signal pomaže korisniku da zna gde se nalazi.
    focusHtmlNeedles:
      - class="brand-copy"
      - <strong>
      - <span>
  - stepId: brand-copy-outline
    title: "CSS: .brand-copy / outline"
    summary: Dodajemo tanak helper outline za tekstualni brand blok i držimo ga do
      završnog brand rezimea.
    intent: Isti wrapper, različiti child elementi, različite helper boje.
    tag: css:brand-copy-outline
    proTip: Isti wrapper, različiti child elementi, različite helper boje.
    focusHtmlNeedles:
      - class="brand-copy"
  - stepId: brand-strong-display
    title: "CSS: .brand-copy strong / display"
    summary: Naslov pretvaramo u blok da zauzme svoj red.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:brand-strong-display
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: &a4
      - <strong>
  - stepId: brand-strong-font-size
    title: "CSS: .brand-copy strong / font-size"
    summary: Naslov dobija čitljiviju veličinu.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:brand-strong-font-size
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a4
  - stepId: brand-span-display
    title: "CSS: .brand-copy span / display"
    summary: Podnaslov spuštamo u novi red.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:brand-span-display
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: &a5
      - <span>
  - stepId: brand-span-margin-top
    title: "CSS: .brand-copy span / margin-top"
    summary: Mali razmak odvaja podnaslov od naslova.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:brand-span-margin-top
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a5
  - stepId: brand-span-font-size
    title: "CSS: .brand-copy span / font-size"
    summary: Podnaslov pravimo suptilnijim od naslova.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:brand-span-font-size
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a5
  - stepId: brand-span-color
    title: "CSS: .brand-copy span / color"
    summary: Muted boja pravi jasnu tekstualnu hijerarhiju.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:brand-span-color
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a5
  - stepId: nav-html
    title: "HTML: Nav Wrapper"
    summary: Ubacujemo `<nav class="nav-list">` kao kontejner za buduće linkove.
      Navigacioni outline helperi ostaju aktivni sve do završnog navigation
      rezimea.
    intent: Semantički `nav` element je prirodan izbor za navigaciju.
    tag: html:nav
    proTip: Semantički `nav` element je prirodan izbor za navigaciju.
    focusHtmlNeedles:
      - class="nav-list"
  - stepId: nav-list-outline
    title: "CSS: .nav-list / outline"
    summary: Dodajemo tanak helper outline za praznu nav zonu i držimo ga do
      završnog navigation rezimea.
    intent: Navigacija zadržava helper linije kroz sve svoje poddelove dok ne
      završimo rezime za nju.
    tag: css:nav-list-outline
    proTip: Navigacija zadržava helper linije kroz sve svoje poddelove dok ne
      završimo rezime za nju.
    focusHtmlNeedles: &a6
      - class="nav-list"
  - stepId: nav-list-padding
    title: "CSS: .nav-list / padding"
    summary: Dodajemo privremeni helper padding da prazna nav zona dobije visinu pre
      prvog linka. I njega držimo do završnog navigation rezimea.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-list-padding
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a6
  - stepId: nav-list-display
    title: "CSS: .nav-list / display"
    summary: Navigaciju slažemo u grid da spacing bude čist.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-list-display
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a6
  - stepId: nav-list-gap
    title: "CSS: .nav-list / gap"
    summary: Gap održava ravnomeran razmak između stavki.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-list-gap
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a6
  - stepId: nav-items-html
    title: "HTML: Nav Items"
    summary: Dodajemo prve `.nav-item` linkove sa ikonama i labelama. I stavke i
      ikonice zadržavaju outline helpere do navigation rezimea.
    intent: Prvo ubaci markup za stavke, pa onda stilizuj svaki sloj ponaosob.
    tag: html:nav-item
    proTip: Prvo ubaci markup za stavke, pa onda stilizuj svaki sloj ponaosob.
    focusHtmlNeedles:
      - class="nav-item
      - class="icon"
      - class="label"
  - stepId: nav-item-outline
    title: "CSS: .nav-item / outline"
    summary: Svaka stavka dobija tanak helper outline i zadržava ga do završnog
      navigation rezimea.
    intent: Svaki deo navigacije zadržava svoju helper boju dok traje cela
      navigaciona celina.
    tag: css:nav-item-outline
    proTip: Svaki deo navigacije zadržava svoju helper boju dok traje cela
      navigaciona celina.
    focusHtmlNeedles: &a7
      - class="nav-item
  - stepId: nav-item-display
    title: "CSS: .nav-item / display"
    summary: Svaka stavka postaje flex red da ikona i tekst stanu jedan do drugog.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-item-display
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a7
  - stepId: nav-item-min-height
    title: "CSS: .nav-item / min-height"
    summary: Klik zona dobija pristojnu visinu.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-item-min-height
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a7
  - stepId: nav-item-padding
    title: "CSS: .nav-item / padding"
    summary: Padding pravi realnu klik zonu i diše bolje od golog teksta.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-item-padding
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a7
  - stepId: nav-item-align-items
    title: "CSS: .nav-item / align-items"
    summary: Vertikalno centriramo sadržaj svake stavke.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-item-align-items
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a7
  - stepId: nav-item-gap
    title: "CSS: .nav-item / gap"
    summary: Gap odvaja ikonu od labele.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-item-gap
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a7
  - stepId: nav-icon-outline
    title: "CSS: .nav-item .icon / outline"
    summary: Ikonica dobija svoj tanak outline i zadržava ga do završnog navigation
      rezimea.
    intent: I ikonica je teaching target i zato ostaje označena dok traje objašnjenje.
    tag: css:nav-icon-outline
    proTip: I ikonica je teaching target i zato ostaje označena dok traje objašnjenje.
    focusHtmlNeedles: &a8
      - class="icon"
  - stepId: nav-icon-width
    title: "CSS: .nav-item .icon / width"
    summary: Ikona dobija fiksnu širinu.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-icon-width
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a8
  - stepId: nav-icon-height
    title: "CSS: .nav-item .icon / height"
    summary: Ikona dobija i fiksnu visinu radi konzistentnog kvadrata.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-icon-height
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a8
  - stepId: nav-icon-display
    title: "CSS: .nav-item .icon / display"
    summary: Grid olakšava centriranje sadržaja ikone.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-icon-display
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a8
  - stepId: nav-icon-place-items
    title: "CSS: .nav-item .icon / place-items"
    summary: Ikonicu centriramo i horizontalno i vertikalno.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-icon-place-items
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a8
  - stepId: nav-label-font-size
    title: "CSS: .nav-item .label / font-size"
    summary: Labela dobija čitljivu veličinu.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-label-font-size
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: &a9
      - class="label"
  - stepId: nav-label-font-weight
    title: "CSS: .nav-item .label / font-weight"
    summary: Blago pojačavamo labelu da zadrži hijerarhiju.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-label-font-weight
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a9
  - stepId: nav-item-radius
    title: "CSS: .nav-item / border-radius"
    summary: Zaobljene ivice daju linkovima mekši, UI osećaj. Outline helper i dalje
      ostaje do rezimea.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-item-radius
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a7
  - stepId: nav-item-margin
    title: "CSS: .nav-item / margin"
    summary: Spoljni razmak odvaja stavke od ivice sidebara.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-item-margin
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a7
  - stepId: nav-item-active-background
    title: "CSS: .nav-item.active / background"
    summary: Aktivna stavka dobija svoju pozadinu, ali helper outline ostaje do
      navigation rezimea.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-item-active-background
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: &a10
      - class="nav-item active"
  - stepId: nav-item-active-color
    title: "CSS: .nav-item.active / color"
    summary: Boju aktivne stavke pojačavamo za bolji kontrast.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-item-active-color
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a10
  - stepId: nav-item-transition
    title: "CSS: .nav-item / transition"
    summary: Dodajemo glatku tranziciju za hover i active stanje.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-item-transition
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a7
  - stepId: nav-item-hover-background
    title: "CSS: .nav-item:hover / background"
    summary: Hover feedback potvrđuje da je stavka interaktivna.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:nav-item-hover-background
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles:
      - class="nav-item
  - stepId: collapse-width
    title: "CSS: .sidebar.is-collapsed / width"
    summary: Collapsed mod sužava sidebar na kompaktnu širinu.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:collapse-width
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles:
      - class="sidebar"
  - stepId: footer-html
    title: "HTML: Sidebar Footer"
    summary: Dodajemo `.sidebar-footer` kao završni informativni blok pri dnu
      sidebara. Footer takođe dobija svoj outline helper koji ostaje do njegovog
      završnog rezimea.
    intent: Footer je i dalje deo sidebara, pa i njega gradimo iz istog toka.
    tag: html:footer
    proTip: Footer je i dalje deo sidebara, pa i njega gradimo iz istog toka.
    focusHtmlNeedles:
      - class="sidebar-footer"
      - <p>Sidebar nije samo lista linkova.
  - stepId: sidebar-display-flex
    title: "CSS: .sidebar / display"
    summary: Sidebar pretvaramo u flex kolonu da footer može da ode na dno.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:sidebar-display-flex
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a1
  - stepId: sidebar-flex-direction
    title: "CSS: .sidebar / flex-direction"
    summary: Kolona omogućava prirodan vertikalni raspored sekcija.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:sidebar-flex-direction
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a1
  - stepId: footer-outline
    title: "CSS: .sidebar-footer / outline"
    summary: Dodajemo tanak helper outline za footer i držimo ga do završnog footer
      rezimea.
    intent: I footer dobija svoju helper boju jer je poseban teaching element.
    tag: css:footer-outline
    proTip: I footer dobija svoju helper boju jer je poseban teaching element.
    focusHtmlNeedles: &a11
      - class="sidebar-footer"
  - stepId: footer-border
    title: "CSS: .sidebar-footer / border"
    summary: Tanka linija razdvaja footer od pozadine.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:footer-border
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a11
  - stepId: footer-background
    title: "CSS: .sidebar-footer / background"
    summary: Blaga pozadina izdvaja footer bez teškog kontrasta.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:footer-background
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a11
  - stepId: footer-padding
    title: "CSS: .sidebar-footer / padding"
    summary: Footer dobija unutrašnji spacing.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:footer-padding
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a11
  - stepId: footer-radius
    title: "CSS: .sidebar-footer / border-radius"
    summary: Zaobljenje usklađuje footer sa ostatkom UI-ja.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:footer-radius
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a11
  - stepId: footer-margin-top
    title: "CSS: .sidebar-footer / margin-top"
    summary: Auto margin gura footer na dno kolone.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:footer-margin-top
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a11
  - stepId: footer-text-margin
    title: "CSS: .sidebar-footer p / margin"
    summary: Odstupamo paragraf od naslova unutar footera.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:footer-text-margin
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: &a12
      - <p>Sidebar nije samo lista linkova.
  - stepId: footer-text-color
    title: "CSS: .sidebar-footer p / color"
    summary: Muted ton čini pomoćni tekst nenametljivim.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:footer-text-color
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a12
  - stepId: footer-text-line-height
    title: "CSS: .sidebar-footer p / line-height"
    summary: Line-height daje tekstu dovoljno vazduha.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:footer-text-line-height
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a12
  - stepId: hide-labels
    title: "CSS: .sidebar.is-collapsed .brand-copy, .sidebar.is-collapsed .nav-item
      .label / display"
    summary: U collapsed modu sakrivamo tekstualne labele i brand copy.
    intent: Collapse ne znači da gubiš strukturu, već da je svodiš na ikone.
    tag: css:hide-labels
    proTip: Collapse ne znači da gubiš strukturu, već da je svodiš na ikone.
    focusHtmlNeedles:
      - class="brand-copy"
      - class="label"
  - stepId: responsive-sidebar-min-height
    title: "CSS: .sidebar / min-height"
    summary: Na manjim ekranima sidebar više ne mora da glumi pun viewport.
    intent: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    tag: css:responsive-sidebar-min-height
    proTip: Jedan property po korak čini promenu jasnom i lakom za praćenje u
      prikazu sidebara.
    focusHtmlNeedles: *a1
  - stepId: sidebar-summary
    title: "Rezime: .sidebar"
    summary: "Završni rezime za `.sidebar`: helper outline više nije potreban, jer
      je sav osnovni CSS za shell već kompletan i jasan."
    intent: Rezime korak je mesto gde helper outline odlazi i ostaje čist završni
      CSS za tu celinu.
    tag: summary:sidebar-summary
    proTip: Rezime korak je mesto gde helper outline odlazi i ostaje čist završni
      CSS za tu celinu.
    focusHtmlNeedles:
      - class="sidebar"
  - stepId: brand-summary
    title: "Rezime: Brand Celina"
    summary: Rezimiramo brand wrapper, logo i brand copy. Tek sada uklanjamo njihove
      outline helpere jer je ceo brand blok završen.
    intent: Kada više povezanih elemenata čine jednu teaching celinu, outline može
      da nestane tek u zajedničkom rezime koraku.
    tag: summary:brand-summary
    proTip: Kada više povezanih elemenata čine jednu teaching celinu, outline može
      da nestane tek u zajedničkom rezime koraku.
    focusHtmlNeedles:
      - class="sidebar-brand"
      - class="logo"
      - class="brand-copy"
  - stepId: navigation-summary
    title: "Rezime: Navigation Celina"
    summary: Rezimiramo nav zonu, stavke i ikonice. Tek sada uklanjamo outline
      helpere sa cele navigacione celine.
    intent: Outline helperi za navigaciju ostaju dok svi delovi navigacije ne budu
      kompletno objašnjeni.
    tag: summary:navigation-summary
    proTip: Outline helperi za navigaciju ostaju dok svi delovi navigacije ne budu
      kompletno objašnjeni.
    focusHtmlNeedles:
      - class="nav-list"
      - class="nav-item
      - class="icon"
  - stepId: footer-summary
    title: "Rezime: Footer"
    summary: Rezimiramo footer blok i uklanjamo njegov helper outline tek sada, kada
      je ceo footer vizuelno završen.
    intent: Outline za footer služi učenju i zato ostaje sve do poslednjeg footer
      rezimea.
    tag: summary:footer-summary
    proTip: Outline za footer služi učenju i zato ostaje sve do poslednjeg footer
      rezimea.
    focusHtmlNeedles:
      - class="sidebar-footer"
      - <p>Sidebar nije samo lista linkova.
  - stepId: shell-summary
    title: "Rezime: .app-shell"
    summary: "Završni shell rezime: tek sada uklanjamo helper outline sa
      `.app-shell`, jer je cela sidebar lekcija kompletna i okvir više nije
      potreban."
    intent: App shell outline ostaje sve vreme kao teaching okvir, pa nestaje tek na
      samom kraju lekcije.
    tag: summary:shell-summary
    proTip: App shell outline ostaje sve vreme kao teaching okvir, pa nestaje tek na
      samom kraju lekcije.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: done
    title: "Done: Sidebar"
    summary: "Tutorijal je sada potpuno detaljan: CSS ide kumulativno, property po
      property, a outline helperi odlaze tek u rezime koracima."
    intent: Kada je tok ovako sitno razbijen, promene su mnogo lakše za praćenje i u
      kodu i u prikazu sidebara.
    tag: success
    proTip: Kada je tok ovako sitno razbijen, promene su mnogo lakše za praćenje i u
      kodu i u prikazu sidebara.
    focusHtmlNeedles: []
---

# Step: empty-shell

## Scene: empty-shell-scene

narration:
Počinjemo od praznog `.app-shell` prostora. Sidebar tek dodajemo kao prvi pravi element.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: sidebar-html

## Scene: sidebar-html-scene

narration:
Ubacujemo osnovni `<aside class="sidebar">` blok kao koren cele komponente.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: shell-outline

## Scene: shell-outline-scene

narration:
Dodajemo tanak helper outline za `.app-shell` i zadržavamo ga kroz celu lekciju, sve do završnog shell rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: sidebar-outline

## Scene: sidebar-outline-scene

narration:
Dodajemo tanak helper outline da footprint sidebara ostane jasan kroz ceo lesson tok. Skidamo ga tek u završnom rezime koraku za `.sidebar`.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: sidebar-width

## Scene: sidebar-width-scene

narration:
Kad granica postoji, zaključavamo širinu sidebara da dobije jasan footprint.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: sidebar-min-height

## Scene: sidebar-min-height-scene

narration:
Dajemo sidebaru punu visinu da box postane čitljiv i bez sadržaja.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: sidebar-border-right

## Scene: sidebar-border-right-scene

narration:
Tanka desna linija odvaja sidebar od ostatka layouta.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: sidebar-background

## Scene: sidebar-background-scene

narration:
Dodajemo tamnu pozadinu da sidebar dobije svoj vizuelni identitet, ali outline namerno ostaje do rezime koraka za `.sidebar`.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: sidebar-color

## Scene: sidebar-color-scene

narration:
Osnovnu boju teksta postavljamo rano da nasledi ceo sadržaj.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-html

## Scene: brand-html-scene

narration:
Dodajemo `.sidebar-brand` kao zonu za logo i naziv proizvoda. Svi brand elementi zadržavaju svoje outline helpere do završnog brand rezimea.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: brand-outline

## Scene: brand-outline-scene

narration:
Dodajemo tanak helper outline za `.sidebar-brand` i držimo ga do završnog rezime koraka za brand celinu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-padding

## Scene: brand-padding-scene

narration:
Unutrašnji padding daje brand zoni vazduh.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-margin-bottom

## Scene: brand-margin-bottom-scene

narration:
Odvajamo brand blok od navigacije ispod njega.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-display

## Scene: brand-display-scene

narration:
Prebacujemo brand zonu u flex da logo i tekst mogu da stoje u istom redu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-align-items

## Scene: brand-align-items-scene

narration:
Vertikalno poravnanje centrira logo i tekst.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-gap

## Scene: brand-gap-scene

narration:
Gap određuje koliko prostora stoji između logotipa i teksta.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-html

## Scene: logo-html-scene

narration:
Ubacujemo `.logo` element sa slovom `A` kao placeholder identitetom.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: logo-outline

## Scene: logo-outline-scene

narration:
Dodajemo tanak helper outline za `.logo` i držimo ga do završnog brand rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-width

## Scene: logo-width-scene

narration:
Prvo zaključavamo širinu logotipa.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-height

## Scene: logo-height-scene

narration:
Visina prati širinu da bismo dobili kvadratnu osnovu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-display

## Scene: logo-display-scene

narration:
Grid nam daje lak centar za jedan znak ili ikonu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-place-items

## Scene: logo-place-items-scene

narration:
Centriramo sadržaj logotipa u oba smera.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-radius

## Scene: logo-radius-scene

narration:
Blago zaobljenje daje moderniji osećaj.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-font-weight

## Scene: logo-font-weight-scene

narration:
Pojačavamo slovo da liči na pravi brand znak.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-background

## Scene: logo-background-scene

narration:
Gradijent dodaje energiju i daje logotipu fokus. Outline namerno ostaje do brand rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-color

## Scene: logo-color-scene

narration:
Bela boja daje čist kontrast preko gradijenta.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-shadow

## Scene: logo-shadow-scene

narration:
Shadow dodaje depth i čini logo prisutnijim.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-copy-html

## Scene: brand-copy-html-scene

narration:
Dodajemo `.brand-copy` sa naslovom i podnaslovom pored logotipa. I on zadržava svoj outline do završnog brand rezimea.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: brand-copy-outline

## Scene: brand-copy-outline-scene

narration:
Dodajemo tanak helper outline za tekstualni brand blok i držimo ga do završnog brand rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-strong-display

## Scene: brand-strong-display-scene

narration:
Naslov pretvaramo u blok da zauzme svoj red.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-strong-font-size

## Scene: brand-strong-font-size-scene

narration:
Naslov dobija čitljiviju veličinu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-span-display

## Scene: brand-span-display-scene

narration:
Podnaslov spuštamo u novi red.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-span-margin-top

## Scene: brand-span-margin-top-scene

narration:
Mali razmak odvaja podnaslov od naslova.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-span-font-size

## Scene: brand-span-font-size-scene

narration:
Podnaslov pravimo suptilnijim od naslova.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-span-color

## Scene: brand-span-color-scene

narration:
Muted boja pravi jasnu tekstualnu hijerarhiju.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-html

## Scene: nav-html-scene

narration:
Ubacujemo `<nav class="nav-list">` kao kontejner za buduće linkove. Navigacioni outline helperi ostaju aktivni sve do završnog navigation rezimea.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: nav-list-outline

## Scene: nav-list-outline-scene

narration:
Dodajemo tanak helper outline za praznu nav zonu i držimo ga do završnog navigation rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-list-padding

## Scene: nav-list-padding-scene

narration:
Dodajemo privremeni helper padding da prazna nav zona dobije visinu pre prvog linka. I njega držimo do završnog navigation rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-list-display

## Scene: nav-list-display-scene

narration:
Navigaciju slažemo u grid da spacing bude čist.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-list-gap

## Scene: nav-list-gap-scene

narration:
Gap održava ravnomeran razmak između stavki.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-items-html

## Scene: nav-items-html-scene

narration:
Dodajemo prve `.nav-item` linkove sa ikonama i labelama. I stavke i ikonice zadržavaju outline helpere do navigation rezimea.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: nav-item-outline

## Scene: nav-item-outline-scene

narration:
Svaka stavka dobija tanak helper outline i zadržava ga do završnog navigation rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-item-display

## Scene: nav-item-display-scene

narration:
Svaka stavka postaje flex red da ikona i tekst stanu jedan do drugog.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-item-min-height

## Scene: nav-item-min-height-scene

narration:
Klik zona dobija pristojnu visinu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-item-padding

## Scene: nav-item-padding-scene

narration:
Padding pravi realnu klik zonu i diše bolje od golog teksta.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-item-align-items

## Scene: nav-item-align-items-scene

narration:
Vertikalno centriramo sadržaj svake stavke.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-item-gap

## Scene: nav-item-gap-scene

narration:
Gap odvaja ikonu od labele.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-icon-outline

## Scene: nav-icon-outline-scene

narration:
Ikonica dobija svoj tanak outline i zadržava ga do završnog navigation rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-icon-width

## Scene: nav-icon-width-scene

narration:
Ikona dobija fiksnu širinu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-icon-height

## Scene: nav-icon-height-scene

narration:
Ikona dobija i fiksnu visinu radi konzistentnog kvadrata.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-icon-display

## Scene: nav-icon-display-scene

narration:
Grid olakšava centriranje sadržaja ikone.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-icon-place-items

## Scene: nav-icon-place-items-scene

narration:
Ikonicu centriramo i horizontalno i vertikalno.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-label-font-size

## Scene: nav-label-font-size-scene

narration:
Labela dobija čitljivu veličinu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-label-font-weight

## Scene: nav-label-font-weight-scene

narration:
Blago pojačavamo labelu da zadrži hijerarhiju.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-item-radius

## Scene: nav-item-radius-scene

narration:
Zaobljene ivice daju linkovima mekši, UI osećaj. Outline helper i dalje ostaje do rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-item-margin

## Scene: nav-item-margin-scene

narration:
Spoljni razmak odvaja stavke od ivice sidebara.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-item-active-background

## Scene: nav-item-active-background-scene

narration:
Aktivna stavka dobija svoju pozadinu, ali helper outline ostaje do navigation rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-item-active-color

## Scene: nav-item-active-color-scene

narration:
Boju aktivne stavke pojačavamo za bolji kontrast.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-item-transition

## Scene: nav-item-transition-scene

narration:
Dodajemo glatku tranziciju za hover i active stanje.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-item-hover-background

## Scene: nav-item-hover-background-scene

narration:
Hover feedback potvrđuje da je stavka interaktivna.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: collapse-width

## Scene: collapse-width-scene

narration:
Collapsed mod sužava sidebar na kompaktnu širinu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: footer-html

## Scene: footer-html-scene

narration:
Dodajemo `.sidebar-footer` kao završni informativni blok pri dnu sidebara. Footer takođe dobija svoj outline helper koji ostaje do njegovog završnog rezimea.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: sidebar-display-flex

## Scene: sidebar-display-flex-scene

narration:
Sidebar pretvaramo u flex kolonu da footer može da ode na dno.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: sidebar-flex-direction

## Scene: sidebar-flex-direction-scene

narration:
Kolona omogućava prirodan vertikalni raspored sekcija.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: footer-outline

## Scene: footer-outline-scene

narration:
Dodajemo tanak helper outline za footer i držimo ga do završnog footer rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: footer-border

## Scene: footer-border-scene

narration:
Tanka linija razdvaja footer od pozadine.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: footer-background

## Scene: footer-background-scene

narration:
Blaga pozadina izdvaja footer bez teškog kontrasta.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: footer-padding

## Scene: footer-padding-scene

narration:
Footer dobija unutrašnji spacing.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: footer-radius

## Scene: footer-radius-scene

narration:
Zaobljenje usklađuje footer sa ostatkom UI-ja.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: footer-margin-top

## Scene: footer-margin-top-scene

narration:
Auto margin gura footer na dno kolone.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: footer-text-margin

## Scene: footer-text-margin-scene

narration:
Odstupamo paragraf od naslova unutar footera.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: footer-text-color

## Scene: footer-text-color-scene

narration:
Muted ton čini pomoćni tekst nenametljivim.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: footer-text-line-height

## Scene: footer-text-line-height-scene

narration:
Line-height daje tekstu dovoljno vazduha.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: hide-labels

## Scene: hide-labels-scene

narration:
U collapsed modu sakrivamo tekstualne labele i brand copy.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: responsive-sidebar-min-height

## Scene: responsive-sidebar-min-height-scene

narration:
Na manjim ekranima sidebar više ne mora da glumi pun viewport.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: sidebar-summary

## Scene: sidebar-summary-scene

narration:
Završni rezime za `.sidebar`: helper outline više nije potreban, jer je sav osnovni CSS za shell već kompletan i jasan.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: brand-summary

## Scene: brand-summary-scene

narration:
Rezimiramo brand wrapper, logo i brand copy. Tek sada uklanjamo njihove outline helpere jer je ceo brand blok završen.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: navigation-summary

## Scene: navigation-summary-scene

narration:
Rezimiramo nav zonu, stavke i ikonice. Tek sada uklanjamo outline helpere sa cele navigacione celine.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: footer-summary

## Scene: footer-summary-scene

narration:
Rezimiramo footer blok i uklanjamo njegov helper outline tek sada, kada je ceo footer vizuelno završen.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: shell-summary

## Scene: shell-summary-scene

narration:
Završni shell rezime: tek sada uklanjamo helper outline sa `.app-shell`, jer je cela sidebar lekcija kompletna i okvir više nije potreban.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: done

## Scene: done-scene

narration:
Tutorijal je sada potpuno detaljan: CSS ide kumulativno, property po property, a outline helperi odlaze tek u rezime koracima.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom
