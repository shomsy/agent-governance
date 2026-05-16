---
schemaVersion: 1
lessonId: 03-build-custom-element
steps:
  - stepId: empty-shell
    title: "Start: Empty App Shell"
    summary: Počinjemo od praznog `.app-shell` prostora. Ova prva Web Components
      lekcija objašnjava custom element osnove bez shadow DOM-a.
    intent: Prvo naučimo host element i render flow, pa tek onda prelazimo na shadow
      DOM lekciju.
    tag: html:app-shell
    proTip: Prvo naučimo host element i render flow, pa tek onda prelazimo na shadow
      DOM lekciju.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: component-html
    title: "HTML: my-first-component Host"
    summary: Dodajemo `<my-first-component>` host sa `title` i `cta-label`
      atributima. Browser ga za sada vidi samo kao nepoznati custom tag koji
      čeka registraciju.
    intent: Naziv custom elementa mora da sadrži crticu. To je prvi uslov da ga
      kasnije registruješ.
    tag: html:my-first-component
    proTip: Naziv custom elementa mora da sadrži crticu. To je prvi uslov da ga
      kasnije registruješ.
    focusHtmlNeedles:
      - <my-first-component
  - stepId: class-declaration
    title: "JS: Class Extends HTMLElement"
    summary: Otvaramo `class MyFirstComponent extends HTMLElement` i time zadajemo
      ponašanje budućem custom elementu.
    intent: Custom element je DOM element sa tvojom klasom, ne neka posebna magija
      van platforme.
    tag: js:class-declaration
    proTip: Custom element je DOM element sa tvojom klasom, ne neka posebna magija
      van platforme.
    focusHtmlNeedles: &a1
      - <my-first-component
  - stepId: connected-callback
    title: "JS: connectedCallback"
    summary: Dodajemo `connectedCallback()`, jer je to najjednostavniji lifecycle
      hook za prvi render čim element uđe u DOM.
    intent: Za uvodnu lekciju connectedCallback je najpraktičnija ulazna tačka pre
      nego što uvedemo složeniji render tok.
    tag: js:connected-callback
    proTip: Za uvodnu lekciju connectedCallback je najpraktičnija ulazna tačka pre
      nego što uvedemo složeniji render tok.
    focusHtmlNeedles: *a1
  - stepId: read-title-attribute
    title: "JS: Čitamo title Atribut"
    summary: U lifecycle metodi čitamo `title` atribut sa host elementa. Time host
      HTML postaje spoljašnji API komponente.
    intent: Atributi su najjednostavniji prvi API za custom element koji ne traži
      framework ni dodatni state.
    tag: js:read-title-attribute
    proTip: Atributi su najjednostavniji prvi API za custom element koji ne traži
      framework ni dodatni state.
    focusHtmlNeedles: *a1
  - stepId: read-cta-attribute
    title: "JS: Čitamo cta-label Atribut"
    summary: Na isti način čitamo i `cta-label`, kako bi i tekst CTA dugmeta dolazio
      iz host HTML-a.
    intent: Ako dva podatka dolaze spolja, drži ih u istom, lako čitljivom toku.
    tag: js:read-cta-attribute
    proTip: Ako dva podatka dolaze spolja, drži ih u istom, lako čitljivom toku.
    focusHtmlNeedles: *a1
  - stepId: render-inner-html
    title: "JS: Renderujemo Light DOM Markup"
    summary: Kroz `this.innerHTML` ubacujemo card markup direktno u host element. To
      je najdirektniji put da vidiš kako custom element može da generiše
      sopstveni light DOM.
    intent: Ova lekcija namerno ostaje bez shadow DOM-a, da bi render mehanika i
      globalni CSS bili potpuno transparentni.
    tag: js:render-inner-html
    proTip: Ova lekcija namerno ostaje bez shadow DOM-a, da bi render mehanika i
      globalni CSS bili potpuno transparentni.
    focusHtmlNeedles: *a1
  - stepId: define-element
    title: "JS: Registrujemo my-first-component"
    summary: Pre registracije proveravamo
      `customElements.get('my-first-component')`, pa tek onda unutar guarda
      pozivamo `customElements.define(...)`. Od tog trenutka browser zna kako da
      upgrade-uje svaki `<my-first-component>` u stvarnu komponentu.
    intent: Registracija je trenutak kada nepoznati tag postaje živi custom element,
      a guard nas štiti od duplog define-a pri ponovnom izvršavanju.
    tag: js:define-element
    proTip: Registracija je trenutak kada nepoznati tag postaje živi custom element,
      a guard nas štiti od duplog define-a pri ponovnom izvršavanju.
    focusHtmlNeedles: *a1
  - stepId: shell-outline
    title: "CSS: .app-shell / outline"
    summary: Dodajemo helper outline za `.app-shell` i zadržavamo ga do završnog
      shell rezimea.
    intent: App shell ostaje stalni teaching okvir kroz celu lekciju.
    tag: css:shell-outline
    proTip: App shell ostaje stalni teaching okvir kroz celu lekciju.
    focusHtmlNeedles: &a2
      - <div class="app-shell">
  - stepId: shell-padding
    title: "CSS: .app-shell / padding"
    summary: Padding daje komponenti prostor da se vidi kao zaseban teaching target.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:shell-padding
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a2
  - stepId: shell-display
    title: "CSS: .app-shell / display"
    summary: Grid je dovoljan da centriramo jedan card use case.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:shell-display
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a2
  - stepId: shell-place-items
    title: "CSS: .app-shell / place-items"
    summary: Centar čuva fokus na komponenti koju gradimo.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:shell-place-items
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a2
  - stepId: shell-min-height
    title: "CSS: .app-shell / min-height"
    summary: Puna visina stabilizuje preview scenu.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:shell-min-height
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a2
  - stepId: shell-background
    title: "CSS: .app-shell / background"
    summary: Svetla pozadina daje kontrast tamnom callout card-u.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:shell-background
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a2
  - stepId: host-outline
    title: "CSS: my-first-component / outline"
    summary: Dodajemo helper outline za host element i držimo ga do završnog host
      rezimea.
    intent: I kada light DOM markup već postoji, host ostaje spoljašnji okvir
      komponente i zato mora da ostane jasan.
    tag: css:host-outline
    proTip: I kada light DOM markup već postoji, host ostaje spoljašnji okvir
      komponente i zato mora da ostane jasan.
    focusHtmlNeedles: *a1
  - stepId: host-display
    title: "CSS: my-first-component / display"
    summary: Host pretvaramo u block da dobije pravi footprint.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:host-display
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a1
  - stepId: host-width
    title: "CSS: my-first-component / width"
    summary: Širinu zaključavamo rano da card kasnije uleti u stabilan okvir.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:host-width
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a1
  - stepId: card-outline
    title: "CSS: my-first-component .card / outline"
    summary: Kada komponenta renderuje light DOM markup, glavni `.card` dobija
      helper outline do završnog card rezimea.
    intent: Glavni card outline ostaje dok ceo light DOM blok ne postane jasan.
    tag: css:card-outline
    proTip: Glavni card outline ostaje dok ceo light DOM blok ne postane jasan.
    focusHtmlNeedles: &a3
      - <my-first-component
  - stepId: card-display
    title: "CSS: my-first-component .card / display"
    summary: Card raspored uvodimo grid-om jer imamo vertikalnu stack strukturu.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:card-display
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a3
  - stepId: card-gap
    title: "CSS: my-first-component .card / gap"
    summary: Gap odvaja badge, naslov, opis i CTA.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:card-gap
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a3
  - stepId: card-padding
    title: "CSS: my-first-component .card / padding"
    summary: Padding pravi card footprint unutar host elementa.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:card-padding
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a3
  - stepId: card-radius
    title: "CSS: my-first-component .card / border-radius"
    summary: Zaobljenje daje card-u mekšu siluetu.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:card-radius
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a3
  - stepId: card-border
    title: "CSS: my-first-component .card / border"
    summary: Tanka border linija odvaja card od pozadine.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:card-border
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a3
  - stepId: card-background
    title: "CSS: my-first-component .card / background"
    summary: Tamna pozadina zatvara glavni vizuelni blok.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:card-background
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a3
  - stepId: card-shadow
    title: "CSS: my-first-component .card / box-shadow"
    summary: Shadow daje card-u dubinu i separaciju.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:card-shadow
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a3
  - stepId: eyebrow-outline
    title: "CSS: my-first-component .eyebrow / outline"
    summary: Badge dobija helper outline i zadržava ga do eyebrow rezimea.
    intent: Mali elementi traže poseban outline da bi ostali čitljivi tokom
      objašnjenja.
    tag: css:eyebrow-outline
    proTip: Mali elementi traže poseban outline da bi ostali čitljivi tokom
      objašnjenja.
    focusHtmlNeedles: &a4
      - <my-first-component
  - stepId: eyebrow-display
    title: "CSS: my-first-component .eyebrow / display"
    summary: Badge ostaje kompaktan i prati svoj sadržaj.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:eyebrow-display
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a4
  - stepId: eyebrow-padding
    title: "CSS: my-first-component .eyebrow / padding"
    summary: Padding daje badge-u njegov pill footprint.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:eyebrow-padding
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a4
  - stepId: eyebrow-radius
    title: "CSS: my-first-component .eyebrow / border-radius"
    summary: Veliki radius zatvara badge u kapsulu.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:eyebrow-radius
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a4
  - stepId: eyebrow-background
    title: "CSS: my-first-component .eyebrow / background"
    summary: Blaga pozadina daje badge-u površinu bez agresivnosti.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:eyebrow-background
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a4
  - stepId: eyebrow-color
    title: "CSS: my-first-component .eyebrow / color"
    summary: Accent boja badge signalizira kategoriju.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:eyebrow-color
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a4
  - stepId: eyebrow-font-size
    title: "CSS: my-first-component .eyebrow / font-size"
    summary: Badge ostaje mali i sekundaran.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:eyebrow-font-size
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a4
  - stepId: eyebrow-font-weight
    title: "CSS: my-first-component .eyebrow / font-weight"
    summary: Jača težina fonta čini labelu jasnom.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:eyebrow-font-weight
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a4
  - stepId: title-font-size
    title: "CSS: my-first-component .title / font-size"
    summary: Naslov dobija dominantnu veličinu unutar card-a.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:title-font-size
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: &a5
      - <my-first-component
  - stepId: title-font-weight
    title: "CSS: my-first-component .title / font-weight"
    summary: Pojačavamo naslov da odmah nosi hijerarhiju.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:title-font-weight
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a5
  - stepId: summary-margin
    title: "CSS: my-first-component .summary / margin"
    summary: Brišemo default paragraf margin da spacing bude pod kontrolom.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:summary-margin
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: &a6
      - <my-first-component
  - stepId: summary-color
    title: "CSS: my-first-component .summary / color"
    summary: Opis dobija prigušenu, ali čitljivu boju.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:summary-color
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a6
  - stepId: summary-line-height
    title: "CSS: my-first-component .summary / line-height"
    summary: Veći line-height otvara tekst za lakše čitanje.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:summary-line-height
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a6
  - stepId: cta-outline
    title: "CSS: my-first-component .cta / outline"
    summary: CTA dobija helper outline i zadržava ga do završnog CTA rezimea.
    intent: CTA outline ostaje dok poslednja interaktivna zona ne bude potpuno
      objašnjena.
    tag: css:cta-outline
    proTip: CTA outline ostaje dok poslednja interaktivna zona ne bude potpuno
      objašnjena.
    focusHtmlNeedles: &a7
      - <my-first-component
  - stepId: cta-padding
    title: "CSS: my-first-component .cta / padding"
    summary: Padding daje dugmetu njegovu klik zonu.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:cta-padding
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a7
  - stepId: cta-border
    title: "CSS: my-first-component .cta / border"
    summary: Uklanjamo podrazumevanu border liniju dugmeta.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:cta-border
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a7
  - stepId: cta-radius
    title: "CSS: my-first-component .cta / border-radius"
    summary: Pil oblik čini CTA konzistentnim sa badge oblikom.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:cta-radius
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a7
  - stepId: cta-background
    title: "CSS: my-first-component .cta / background"
    summary: Gradijent daje CTA-u energiju i fokus.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:cta-background
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a7
  - stepId: cta-color
    title: "CSS: my-first-component .cta / color"
    summary: Beli tekst pravi jasan kontrast preko dugmeta.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:cta-color
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a7
  - stepId: cta-font-weight
    title: "CSS: my-first-component .cta / font-weight"
    summary: Jači font zatvara CTA kao jasan action element.
    intent: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    tag: css:cta-font-weight
    proTip: U light DOM custom element lekciji globalni CSS direktno stilizuje
      markup koji komponenta renderuje kroz JavaScript.
    focusHtmlNeedles: *a7
  - stepId: card-summary
    title: "Rezime: .card"
    summary: Rezimiramo glavni `.card` blok i uklanjamo njegov helper outline tek
      sada, kada su host, render i glavni vizuelni sloj zajedno jasni.
    intent: Outline ostaje dok markup i stil ne počnu da pričaju istu priču.
    tag: summary:card-summary
    proTip: Outline ostaje dok markup i stil ne počnu da pričaju istu priču.
    focusHtmlNeedles: *a1
  - stepId: eyebrow-summary
    title: "Rezime: .eyebrow"
    summary: Rezimiramo eyebrow badge i tek sada uklanjamo njegov helper outline,
      jer je cela tekstualna hijerarhija card-a završena.
    intent: Mali badge outline služi orijentaciji dok se ne slože i forma i boja i
      tipografija.
    tag: summary:eyebrow-summary
    proTip: Mali badge outline služi orijentaciji dok se ne slože i forma i boja i
      tipografija.
    focusHtmlNeedles: *a1
  - stepId: cta-summary
    title: "Rezime: .cta"
    summary: "Rezime za CTA dugme: helper outline više nije potreban, jer završni
      stil i render već jasno pokazuju njegovu ulogu."
    intent: Outline služi učenju; kad je CTA jasan, može da nestane.
    tag: summary:cta-summary
    proTip: Outline služi učenju; kad je CTA jasan, može da nestane.
    focusHtmlNeedles: *a1
  - stepId: host-summary
    title: "Rezime: my-first-component host"
    summary: "Završni host rezime: uklanjamo host outline tek sada, kada su i
      atribut API i render flow potpuno jasni."
    intent: Host outline ostaje dok ne objasnimo i HTML API i JavaScript registraciju.
    tag: summary:host-summary
    proTip: Host outline ostaje dok ne objasnimo i HTML API i JavaScript registraciju.
    focusHtmlNeedles: *a1
  - stepId: shell-summary
    title: "Rezime: .app-shell"
    summary: Tek sada uklanjamo helper outline sa `.app-shell`, jer je cela uvodna
      custom element lekcija kompletna.
    intent: App shell outline ostaje sve vreme kao teaching okvir i nestaje tek na
      kraju lekcije.
    tag: summary:shell-summary
    proTip: App shell outline ostaje sve vreme kao teaching okvir i nestaje tek na
      kraju lekcije.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: done
    title: "Done: Light DOM Custom Element"
    summary: Prva Web Components lekcija je gotova. Sad razumeš host tag,
      registraciju, atribute, render kroz light DOM i tek onda stilizaciju nad
      stvarnim renderovanim DOM-om. Sledeći prirodan korak je shadow DOM
      lekcija.
    intent: Najbolji nastavak je lekcija 2/2, gde isti problem rešavamo kroz
      template, shadow DOM i slotove.
    tag: success
    proTip: Najbolji nastavak je lekcija 2/2, gde isti problem rešavamo kroz
      template, shadow DOM i slotove.
    focusHtmlNeedles: []
---

# Step: empty-shell

## Scene: empty-shell-scene

narration:
Počinjemo od praznog `.app-shell` prostora. Ova prva Web Components lekcija objašnjava custom element osnove bez shadow DOM-a.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: component-html

## Scene: component-html-scene

narration:
Dodajemo `<my-first-component>` host sa `title` i `cta-label` atributima. Browser ga za sada vidi samo kao nepoznati custom tag koji čeka registraciju.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: class-declaration

## Scene: class-declaration-scene

narration:
Otvaramo `class MyFirstComponent extends HTMLElement` i time zadajemo ponašanje budućem custom elementu.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: connected-callback

## Scene: connected-callback-scene

narration:
Dodajemo `connectedCallback()`, jer je to najjednostavniji lifecycle hook za prvi render čim element uđe u DOM.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: read-title-attribute

## Scene: read-title-attribute-scene

narration:
U lifecycle metodi čitamo `title` atribut sa host elementa. Time host HTML postaje spoljašnji API komponente.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: read-cta-attribute

## Scene: read-cta-attribute-scene

narration:
Na isti način čitamo i `cta-label`, kako bi i tekst CTA dugmeta dolazio iz host HTML-a.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: render-inner-html

## Scene: render-inner-html-scene

narration:
Kroz `this.innerHTML` ubacujemo card markup direktno u host element. To je najdirektniji put da vidiš kako custom element može da generiše sopstveni light DOM.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: define-element

## Scene: define-element-scene

narration:
Pre registracije proveravamo `customElements.get('my-first-component')`, pa tek onda unutar guarda pozivamo `customElements.define(...)`. Od tog trenutka browser zna kako da upgrade-uje svaki `<my-first-component>` u stvarnu komponentu.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: shell-outline

## Scene: shell-outline-scene

narration:
Dodajemo helper outline za `.app-shell` i zadržavamo ga do završnog shell rezimea.

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
Padding daje komponenti prostor da se vidi kao zaseban teaching target.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: shell-display

## Scene: shell-display-scene

narration:
Grid je dovoljan da centriramo jedan card use case.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: shell-place-items

## Scene: shell-place-items-scene

narration:
Centar čuva fokus na komponenti koju gradimo.

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
Puna visina stabilizuje preview scenu.

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
Svetla pozadina daje kontrast tamnom callout card-u.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-outline

## Scene: host-outline-scene

narration:
Dodajemo helper outline za host element i držimo ga do završnog host rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-display

## Scene: host-display-scene

narration:
Host pretvaramo u block da dobije pravi footprint.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-width

## Scene: host-width-scene

narration:
Širinu zaključavamo rano da card kasnije uleti u stabilan okvir.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: card-outline

## Scene: card-outline-scene

narration:
Kada komponenta renderuje light DOM markup, glavni `.card` dobija helper outline do završnog card rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: card-display

## Scene: card-display-scene

narration:
Card raspored uvodimo grid-om jer imamo vertikalnu stack strukturu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: card-gap

## Scene: card-gap-scene

narration:
Gap odvaja badge, naslov, opis i CTA.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: card-padding

## Scene: card-padding-scene

narration:
Padding pravi card footprint unutar host elementa.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: card-radius

## Scene: card-radius-scene

narration:
Zaobljenje daje card-u mekšu siluetu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: card-border

## Scene: card-border-scene

narration:
Tanka border linija odvaja card od pozadine.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: card-background

## Scene: card-background-scene

narration:
Tamna pozadina zatvara glavni vizuelni blok.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: card-shadow

## Scene: card-shadow-scene

narration:
Shadow daje card-u dubinu i separaciju.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-outline

## Scene: eyebrow-outline-scene

narration:
Badge dobija helper outline i zadržava ga do eyebrow rezimea.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-display

## Scene: eyebrow-display-scene

narration:
Badge ostaje kompaktan i prati svoj sadržaj.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-padding

## Scene: eyebrow-padding-scene

narration:
Padding daje badge-u njegov pill footprint.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-radius

## Scene: eyebrow-radius-scene

narration:
Veliki radius zatvara badge u kapsulu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-background

## Scene: eyebrow-background-scene

narration:
Blaga pozadina daje badge-u površinu bez agresivnosti.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-color

## Scene: eyebrow-color-scene

narration:
Accent boja badge signalizira kategoriju.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-font-size

## Scene: eyebrow-font-size-scene

narration:
Badge ostaje mali i sekundaran.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-font-weight

## Scene: eyebrow-font-weight-scene

narration:
Jača težina fonta čini labelu jasnom.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: title-font-size

## Scene: title-font-size-scene

narration:
Naslov dobija dominantnu veličinu unutar card-a.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: title-font-weight

## Scene: title-font-weight-scene

narration:
Pojačavamo naslov da odmah nosi hijerarhiju.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: summary-margin

## Scene: summary-margin-scene

narration:
Brišemo default paragraf margin da spacing bude pod kontrolom.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: summary-color

## Scene: summary-color-scene

narration:
Opis dobija prigušenu, ali čitljivu boju.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: summary-line-height

## Scene: summary-line-height-scene

narration:
Veći line-height otvara tekst za lakše čitanje.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-outline

## Scene: cta-outline-scene

narration:
CTA dobija helper outline i zadržava ga do završnog CTA rezimea.

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
Padding daje dugmetu njegovu klik zonu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-border

## Scene: cta-border-scene

narration:
Uklanjamo podrazumevanu border liniju dugmeta.

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
Pil oblik čini CTA konzistentnim sa badge oblikom.

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
Gradijent daje CTA-u energiju i fokus.

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
Beli tekst pravi jasan kontrast preko dugmeta.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: cta-font-weight

## Scene: cta-font-weight-scene

narration:
Jači font zatvara CTA kao jasan action element.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: card-summary

## Scene: card-summary-scene

narration:
Rezimiramo glavni `.card` blok i uklanjamo njegov helper outline tek sada, kada su host, render i glavni vizuelni sloj zajedno jasni.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-summary

## Scene: eyebrow-summary-scene

narration:
Rezimiramo eyebrow badge i tek sada uklanjamo njegov helper outline, jer je cela tekstualna hijerarhija card-a završena.

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
Rezime za CTA dugme: helper outline više nije potreban, jer završni stil i render već jasno pokazuju njegovu ulogu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-summary

## Scene: host-summary-scene

narration:
Završni host rezime: uklanjamo host outline tek sada, kada su i atribut API i render flow potpuno jasni.

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
Tek sada uklanjamo helper outline sa `.app-shell`, jer je cela uvodna custom element lekcija kompletna.

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
Prva Web Components lekcija je gotova. Sad razumeš host tag, registraciju, atribute, render kroz light DOM i tek onda stilizaciju nad stvarnim renderovanim DOM-om. Sledeći prirodan korak je shadow DOM lekcija.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom
