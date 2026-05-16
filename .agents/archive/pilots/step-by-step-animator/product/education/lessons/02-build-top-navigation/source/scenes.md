---
schemaVersion: 1
lessonId: 02-build-top-navigation
steps:
  - stepId: empty-shell
    title: "Start: Empty App Shell"
    summary: Počinjemo od praznog `.app-shell` prostora. Goal slika iznad pokazuje
      tri varijante, ali u ovoj lekciji gradimo samo prvu.
    intent: Neutralan početak jasno odvaja ono što je postojalo od onoga što tek
      pravimo.
    tag: html:app-shell
    proTip: Neutralan početak jasno odvaja ono što je postojalo od onoga što tek
      pravimo.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: topbar-html
    title: "HTML: Topbar Shell"
    summary: Dodajemo `<header class="topbar">` kao glavni wrapper buduće navigacije.
    intent: Kreni od glavnog semantic wrapper-a pa tek onda popunjavaj njegove zone.
    tag: html:topbar
    proTip: Kreni od glavnog semantic wrapper-a pa tek onda popunjavaj njegove zone.
    focusHtmlNeedles:
      - class="topbar"
  - stepId: shell-outline
    title: "CSS: .app-shell / outline"
    summary: Dodajemo tanak helper outline za `.app-shell` i zadržavamo ga kroz celu
      lekciju, sve do završnog shell rezimea.
    intent: App shell ostaje stalni okvir cele demonstracije dok ne završimo ceo
      tutorijal.
    tag: css:shell-outline
    proTip: App shell ostaje stalni okvir cele demonstracije dok ne završimo ceo
      tutorijal.
    focusHtmlNeedles: &a1
      - <div class="app-shell">
  - stepId: shell-padding
    title: "CSS: .app-shell / padding"
    summary: Dodajemo padding oko cele scene da navbar dobije vazduh i ne stoji
      zalepljen za ivice preview-a.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:shell-padding
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a1
  - stepId: shell-background
    title: "CSS: .app-shell / background"
    summary: Svetla pozadina približava preview referentnoj slici i daje kontrast
      tamnom navbaru.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:shell-background
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a1
  - stepId: shell-min-height
    title: "CSS: .app-shell / min-height"
    summary: Puna visina drži celu scenu stabilnom tokom lekcije.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:shell-min-height
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a1
  - stepId: topbar-outline
    title: "CSS: .topbar / outline"
    summary: Dodajemo tanak pomoćni outline da footprint celog navbara ostane
      vidljiv kroz ceo tok. Skidamo ga tek u završnom rezime koraku za
      `.topbar`.
    intent: Outline ostaje aktivan dok ne završimo rezime za ovaj element.
    tag: css:topbar-outline
    proTip: Outline ostaje aktivan dok ne završimo rezime za ovaj element.
    focusHtmlNeedles: &a2
      - class="topbar"
  - stepId: topbar-padding
    title: "CSS: .topbar / padding"
    summary: Navbar dobija unutrašnji spacing, pa odmah izgleda kao realna UI traka.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:topbar-padding
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a2
  - stepId: topbar-background
    title: "CSS: .topbar / background"
    summary: Dodajemo tamnu pozadinu, ali outline namerno ostaje do završnog rezimea
      za `.topbar`.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:topbar-background
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a2
  - stepId: topbar-border
    title: "CSS: .topbar / border"
    summary: Tanka ivica pomaže da navbar bude čitljiv i na svetloj pozadini.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:topbar-border
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a2
  - stepId: topbar-shadow
    title: "CSS: .topbar / box-shadow"
    summary: Shadow odvaja navbar od pozadine i približava ga referentnoj slici.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:topbar-shadow
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a2
  - stepId: topbar-display
    title: "CSS: .topbar / display"
    summary: Flex uvodi horizontalni raspored elemenata.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:topbar-display
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a2
  - stepId: topbar-align-items
    title: "CSS: .topbar / align-items"
    summary: Vertikalno centriramo sve delove navigacije.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:topbar-align-items
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a2
  - stepId: topbar-justify-content
    title: "CSS: .topbar / justify-content"
    summary: Glavne zone dobijaju početno razdvajanje levo i desno.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:topbar-justify-content
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a2
  - stepId: logo-html
    title: "HTML: Logo Link"
    summary: Dodajemo logo kao klikabilni `.topbar-logo` element na levom kraju
      navigacije.
    intent: Logo je navigacioni landmark i zato ga uvodimo pre linkova.
    tag: html:logo
    proTip: Logo je navigacioni landmark i zato ga uvodimo pre linkova.
    focusHtmlNeedles:
      - class="topbar-logo"
  - stepId: logo-outline
    title: "CSS: .topbar-logo / outline"
    summary: Dodajemo tanak outline za logo i držimo ga do završnog rezime koraka za
      `.topbar-logo`.
    intent: Svaki važan element dobija svoj outline i zadržava ga do svog rezimea.
    tag: css:logo-outline
    proTip: Svaki važan element dobija svoj outline i zadržava ga do svog rezimea.
    focusHtmlNeedles: &a3
      - class="topbar-logo"
  - stepId: logo-color
    title: "CSS: .topbar-logo / color"
    summary: Boju loga postavljamo rano da odmah ima jasan kontrast na tamnoj traci.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:logo-color
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a3
  - stepId: logo-font-size
    title: "CSS: .topbar-logo / font-size"
    summary: Malo povećavamo logo da se odvoji od običnih linkova.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:logo-font-size
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a3
  - stepId: logo-font-weight
    title: "CSS: .topbar-logo / font-weight"
    summary: Težina fonta daje logo signalu identitet.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:logo-font-weight
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a3
  - stepId: logo-letter-spacing
    title: "CSS: .topbar-logo / letter-spacing"
    summary: Blagi spacing pojačava moderni, branded osećaj.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:logo-letter-spacing
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a3
  - stepId: logo-text-decoration
    title: "CSS: .topbar-logo / text-decoration"
    summary: Uklanjamo underline da logo izgleda kao deo UI-ja, ne kao sirov link.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:logo-text-decoration
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a3
  - stepId: nav-html
    title: "HTML: Navigation Links"
    summary: Dodajemo `<nav class="topbar-links">` sa linkovima Services, Projects i
      About. I grupa linkova i sami linkovi dobijaju helper outline koji ostaje
      do završnog rezimea za navigaciju.
    intent: Najbolje je da sve centralne linkove uvedeš kao jednu celinu, pa tek
      onda doteruješ spacing i tipografiju.
    tag: html:nav-links
    proTip: Najbolje je da sve centralne linkove uvedeš kao jednu celinu, pa tek
      onda doteruješ spacing i tipografiju.
    focusHtmlNeedles:
      - class="topbar-links"
      - ">Services</a>"
      - ">Projects</a>"
      - ">About</a>"
  - stepId: nav-outline
    title: "CSS: .topbar-links / outline"
    summary: Dodajemo tanak helper outline za centralnu navigacionu zonu i držimo ga
      do završnog rezime koraka za link sekciju.
    intent: Centralna grupa ostaje obeležena dok ne završimo rezime za nju.
    tag: css:nav-outline
    proTip: Centralna grupa ostaje obeležena dok ne završimo rezime za nju.
    focusHtmlNeedles: &a4
      - class="topbar-links"
  - stepId: nav-display
    title: "CSS: .topbar-links / display"
    summary: Linkove slažemo u jedan red.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:nav-display
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a4
  - stepId: nav-gap
    title: "CSS: .topbar-links / gap"
    summary: Gap daje istu vrstu razmaka kao na referentnoj slici.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:nav-gap
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a4
  - stepId: nav-margin-left
    title: "CSS: .topbar-links / margin-left"
    summary: Navigacija se odvaja od loga i kreće ka sredini.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:nav-margin-left
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a4
  - stepId: nav-margin-right
    title: "CSS: .topbar-links / margin-right"
    summary: Desni auto margin pomaže da grupa linkova ostane vizuelno centrirana.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:nav-margin-right
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a4
  - stepId: nav-link-outline
    title: "CSS: .topbar-links a / outline"
    summary: Svaki navigacioni link dobija svoj tanak outline i zadržava ga do
      završnog rezimea za navigaciju.
    intent: I sama grupa i pojedinačni linkovi treba da ostanu vizuelno čitljivi dok
      traje objašnjenje.
    tag: css:nav-link-outline
    proTip: I sama grupa i pojedinačni linkovi treba da ostanu vizuelno čitljivi dok
      traje objašnjenje.
    focusHtmlNeedles: &a5
      - ">Services</a>"
      - ">Projects</a>"
      - ">About</a>"
  - stepId: nav-link-color
    title: "CSS: .topbar-links a / color"
    summary: Boja linkova prati logo i pravi konzistentan kontrast.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:nav-link-color
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a5
  - stepId: nav-link-font-size
    title: "CSS: .topbar-links a / font-size"
    summary: Linkovi dobijaju čitljivu, ali nenametljivu veličinu.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:nav-link-font-size
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a5
  - stepId: nav-link-text-decoration
    title: "CSS: .topbar-links a / text-decoration"
    summary: Čistimo default underline da linkovi izgledaju kao deo dizajna.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:nav-link-text-decoration
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a5
  - stepId: nav-link-transition
    title: "CSS: .topbar-links a / transition"
    summary: Mala tranzicija omekšava hover promenu.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:nav-link-transition
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a5
  - stepId: nav-link-hover-color
    title: "CSS: .topbar-links a:hover / color"
    summary: Hover ton blago menja boju, bez agresivnog skakanja.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:nav-link-hover-color
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles:
      - ">Services</a>"
      - ">Projects</a>"
      - ">About</a>"
  - stepId: cta-html
    title: "HTML: Contact CTA"
    summary: Dodajemo završni `.topbar-cta` link sa tekstom Contact. Dugme takođe
      dobija svoj helper outline koji ostaje do njegovog završnog rezimea.
    intent: CTA se uvodi na kraju, tek kada su logo i navigacija već stabilni.
    tag: html:cta
    proTip: CTA se uvodi na kraju, tek kada su logo i navigacija već stabilni.
    focusHtmlNeedles:
      - class="topbar-cta"
  - stepId: cta-outline
    title: "CSS: .topbar-cta / outline"
    summary: Dodajemo tanak pomoćni outline za CTA i držimo ga do završnog rezime
      koraka za dugme.
    intent: Kod CTA dugmeta helper outline ostaje sve dok ne zaključimo ceo element.
    tag: css:cta-outline
    proTip: Kod CTA dugmeta helper outline ostaje sve dok ne zaključimo ceo element.
    focusHtmlNeedles: &a6
      - class="topbar-cta"
  - stepId: cta-display
    title: "CSS: .topbar-cta / display"
    summary: CTA prebacujemo u inline-flex da padding i centriranje rade kao na
      pravom dugmetu.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:cta-display
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a6
  - stepId: cta-align-items
    title: "CSS: .topbar-cta / align-items"
    summary: Tekst dugmeta centriramo po visini.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:cta-align-items
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a6
  - stepId: cta-padding
    title: "CSS: .topbar-cta / padding"
    summary: Padding daje CTA dugmetu njegov pravi footprint.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:cta-padding
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a6
  - stepId: cta-radius
    title: "CSS: .topbar-cta / border-radius"
    summary: Pil oblik odmah približava dugme referentnom primeru.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:cta-radius
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a6
  - stepId: cta-background
    title: "CSS: .topbar-cta / background"
    summary: Dodajemo završnu boju CTA dugmeta, ali outline i dalje ostaje do rezime
      koraka za `.topbar-cta`.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:cta-background
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a6
  - stepId: cta-color
    title: "CSS: .topbar-cta / color"
    summary: Beli tekst pravi čist kontrast preko plave pozadine.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:cta-color
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a6
  - stepId: cta-text-decoration
    title: "CSS: .topbar-cta / text-decoration"
    summary: Uklanjamo underline da CTA izgleda kao pravo dugme.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:cta-text-decoration
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a6
  - stepId: cta-shadow
    title: "CSS: .topbar-cta / box-shadow"
    summary: Shadow pojačava prisustvo CTA dugmeta i zatvara vizuelni match sa ciljem.
    intent: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    tag: css:cta-shadow
    proTip: Jedan property po korak drži promenu malom, preglednom i lakom za
      objašnjavanje.
    focusHtmlNeedles: *a6
  - stepId: topbar-summary
    title: "Rezime: .topbar"
    summary: "Završni rezime za `.topbar`: sada kada vidimo kompletan block CSS,
      uklanjamo helper outline sa glavnog wrapper-a."
    intent: Rezime korak je mesto gde helper outline odlazi i ostaje čist završni
      CSS za taj element.
    tag: summary:topbar-summary
    proTip: Rezime korak je mesto gde helper outline odlazi i ostaje čist završni
      CSS za taj element.
    focusHtmlNeedles: *a2
  - stepId: logo-summary
    title: "Rezime: .topbar-logo"
    summary: Rezimiramo `.topbar-logo` i uklanjamo njegov helper outline tek sada,
      kada je sav CSS za logo već jasan i kompletan.
    intent: Logo outline ostaje sve do ovog trenutka da bi fokus bio čitljiv tokom
      cele lekcije.
    tag: summary:logo-summary
    proTip: Logo outline ostaje sve do ovog trenutka da bi fokus bio čitljiv tokom
      cele lekcije.
    focusHtmlNeedles: *a3
  - stepId: navigation-summary
    title: "Rezime: .topbar-links"
    summary: Rezimiramo navigacionu celinu i uklanjamo helper outline i sa wrapper-a
      i sa pojedinačnih linkova.
    intent: Kada završavaš celu navigacionu grupu, tek tada gasiš outline helpere za
      sve njene delove.
    tag: summary:navigation-summary
    proTip: Kada završavaš celu navigacionu grupu, tek tada gasiš outline helpere za
      sve njene delove.
    focusHtmlNeedles: *a4
  - stepId: cta-summary
    title: "Rezime: .topbar-cta"
    summary: "Rezime za CTA dugme: helper outline više nije potreban, jer završni
      stil već jasno govori šta je element i kako izgleda."
    intent: Outline služi učenju; kad je učenje za taj element završeno, može da
      nestane.
    tag: summary:cta-summary
    proTip: Outline služi učenju; kad je učenje za taj element završeno, može da
      nestane.
    focusHtmlNeedles: *a6
  - stepId: shell-summary
    title: "Rezime: .app-shell"
    summary: "Završni shell rezime: tek sada uklanjamo helper outline sa
      `.app-shell`, jer je cela navigaciona lekcija kompletna i okvir više nije
      potreban."
    intent: App shell outline ostaje sve vreme kao teaching okvir, pa nestaje tek na
      samom kraju lekcije.
    tag: summary:shell-summary
    proTip: App shell outline ostaje sve vreme kao teaching okvir, pa nestaje tek na
      samom kraju lekcije.
    focusHtmlNeedles: *a1
  - stepId: done
    title: "Done: Top Navigation"
    summary: Prvi navbar iz reference je gotov. Druga dva rasporeda iz goal slike
      ostaju kao domaći zadatak.
    intent: Kada završiš ovu varijantu, najbolji sledeći korak je da samostalno
      rekreiraš druga dva rasporeda iz iste reference.
    tag: success
    proTip: Kada završiš ovu varijantu, najbolji sledeći korak je da samostalno
      rekreiraš druga dva rasporeda iz iste reference.
    focusHtmlNeedles: []
---

# Step: empty-shell

## Scene: empty-shell-scene

narration:
Počinjemo od praznog `.app-shell` prostora. Goal slika iznad pokazuje tri varijante, ali u ovoj lekciji gradimo samo prvu.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: topbar-html

## Scene: topbar-html-scene

narration:
Dodajemo `<header class="topbar">` kao glavni wrapper buduće navigacije.

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

# Step: shell-padding

## Scene: shell-padding-scene

narration:
Dodajemo padding oko cele scene da navbar dobije vazduh i ne stoji zalepljen za ivice preview-a.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: shell-background

## Scene: shell-background-scene

narration:
Svetla pozadina približava preview referentnoj slici i daje kontrast tamnom navbaru.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: shell-min-height

## Scene: shell-min-height-scene

narration:
Puna visina drži celu scenu stabilnom tokom lekcije.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: topbar-outline

## Scene: topbar-outline-scene

narration:
Dodajemo tanak pomoćni outline da footprint celog navbara ostane vidljiv kroz ceo tok. Skidamo ga tek u završnom rezime koraku za `.topbar`.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: topbar-padding

## Scene: topbar-padding-scene

narration:
Navbar dobija unutrašnji spacing, pa odmah izgleda kao realna UI traka.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: topbar-background

## Scene: topbar-background-scene

narration:
Dodajemo tamnu pozadinu, ali outline namerno ostaje do završnog rezimea za `.topbar`.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: topbar-border

## Scene: topbar-border-scene

narration:
Tanka ivica pomaže da navbar bude čitljiv i na svetloj pozadini.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: topbar-shadow

## Scene: topbar-shadow-scene

narration:
Shadow odvaja navbar od pozadine i približava ga referentnoj slici.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: topbar-display

## Scene: topbar-display-scene

narration:
Flex uvodi horizontalni raspored elemenata.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: topbar-align-items

## Scene: topbar-align-items-scene

narration:
Vertikalno centriramo sve delove navigacije.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: topbar-justify-content

## Scene: topbar-justify-content-scene

narration:
Glavne zone dobijaju početno razdvajanje levo i desno.

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
Dodajemo logo kao klikabilni `.topbar-logo` element na levom kraju navigacije.

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
Dodajemo tanak outline za logo i držimo ga do završnog rezime koraka za `.topbar-logo`.

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
Boju loga postavljamo rano da odmah ima jasan kontrast na tamnoj traci.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-font-size

## Scene: logo-font-size-scene

narration:
Malo povećavamo logo da se odvoji od običnih linkova.

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
Težina fonta daje logo signalu identitet.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-letter-spacing

## Scene: logo-letter-spacing-scene

narration:
Blagi spacing pojačava moderni, branded osećaj.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-text-decoration

## Scene: logo-text-decoration-scene

narration:
Uklanjamo underline da logo izgleda kao deo UI-ja, ne kao sirov link.

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
Dodajemo `<nav class="topbar-links">` sa linkovima Services, Projects i About. I grupa linkova i sami linkovi dobijaju helper outline koji ostaje do završnog rezimea za navigaciju.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: nav-outline

## Scene: nav-outline-scene

narration:
Dodajemo tanak helper outline za centralnu navigacionu zonu i držimo ga do završnog rezime koraka za link sekciju.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-display

## Scene: nav-display-scene

narration:
Linkove slažemo u jedan red.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-gap

## Scene: nav-gap-scene

narration:
Gap daje istu vrstu razmaka kao na referentnoj slici.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-margin-left

## Scene: nav-margin-left-scene

narration:
Navigacija se odvaja od loga i kreće ka sredini.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-margin-right

## Scene: nav-margin-right-scene

narration:
Desni auto margin pomaže da grupa linkova ostane vizuelno centrirana.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-link-outline

## Scene: nav-link-outline-scene

narration:
Svaki navigacioni link dobija svoj tanak outline i zadržava ga do završnog rezimea za navigaciju.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-link-color

## Scene: nav-link-color-scene

narration:
Boja linkova prati logo i pravi konzistentan kontrast.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-link-font-size

## Scene: nav-link-font-size-scene

narration:
Linkovi dobijaju čitljivu, ali nenametljivu veličinu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-link-text-decoration

## Scene: nav-link-text-decoration-scene

narration:
Čistimo default underline da linkovi izgledaju kao deo dizajna.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-link-transition

## Scene: nav-link-transition-scene

narration:
Mala tranzicija omekšava hover promenu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: nav-link-hover-color

## Scene: nav-link-hover-color-scene

narration:
Hover ton blago menja boju, bez agresivnog skakanja.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-html

## Scene: cta-html-scene

narration:
Dodajemo završni `.topbar-cta` link sa tekstom Contact. Dugme takođe dobija svoj helper outline koji ostaje do njegovog završnog rezimea.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: cta-outline

## Scene: cta-outline-scene

narration:
Dodajemo tanak pomoćni outline za CTA i držimo ga do završnog rezime koraka za dugme.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-display

## Scene: cta-display-scene

narration:
CTA prebacujemo u inline-flex da padding i centriranje rade kao na pravom dugmetu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-align-items

## Scene: cta-align-items-scene

narration:
Tekst dugmeta centriramo po visini.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-padding

## Scene: cta-padding-scene

narration:
Padding daje CTA dugmetu njegov pravi footprint.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-radius

## Scene: cta-radius-scene

narration:
Pil oblik odmah približava dugme referentnom primeru.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-background

## Scene: cta-background-scene

narration:
Dodajemo završnu boju CTA dugmeta, ali outline i dalje ostaje do rezime koraka za `.topbar-cta`.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-color

## Scene: cta-color-scene

narration:
Beli tekst pravi čist kontrast preko plave pozadine.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-text-decoration

## Scene: cta-text-decoration-scene

narration:
Uklanjamo underline da CTA izgleda kao pravo dugme.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-shadow

## Scene: cta-shadow-scene

narration:
Shadow pojačava prisustvo CTA dugmeta i zatvara vizuelni match sa ciljem.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: topbar-summary

## Scene: topbar-summary-scene

narration:
Završni rezime za `.topbar`: sada kada vidimo kompletan block CSS, uklanjamo helper outline sa glavnog wrapper-a.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: logo-summary

## Scene: logo-summary-scene

narration:
Rezimiramo `.topbar-logo` i uklanjamo njegov helper outline tek sada, kada je sav CSS za logo već jasan i kompletan.

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
Rezimiramo navigacionu celinu i uklanjamo helper outline i sa wrapper-a i sa pojedinačnih linkova.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-summary

## Scene: cta-summary-scene

narration:
Rezime za CTA dugme: helper outline više nije potreban, jer završni stil već jasno govori šta je element i kako izgleda.

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
Završni shell rezime: tek sada uklanjamo helper outline sa `.app-shell`, jer je cela navigaciona lekcija kompletna i okvir više nije potreban.

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
Prvi navbar iz reference je gotov. Druga dva rasporeda iz goal slike ostaju kao domaći zadatak.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom
