---
schemaVersion: 1
lessonId: 05-clean-web-component-with-adopted-stylesheets
steps:
  - stepId: empty-shell
    title: "Start: Empty App Shell"
    summary: Počinjemo od praznog `.app-shell` prostora. Goal slika iznad pokazuje
      istu komponentu, ali sada je cilj da očistimo način na koji njeni stilovi
      žive pored JavaScript logike.
    intent: Neutralan početak odvaja postojeći page shell od komponente koju tek
      gradimo.
    tag: html:app-shell
    proTip: Neutralan početak odvaja postojeći page shell od komponente koju tek
      gradimo.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: component-html
    title: "HTML: My First Component Host"
    summary: Dodajemo `<my-first-component>` host sa `title` i `cta-label`
      atributima. Host API ostaje isti; menja se samo način na koji komponenta
      organizuje sopstveni CSS.
    intent: Naziv custom elementa mora da sadrži crticu. To je osnovno pravilo
      registracije custom elementa.
    tag: html:my-first-component
    proTip: Naziv custom elementa mora da sadrži crticu. To je osnovno pravilo
      registracije custom elementa.
    focusHtmlNeedles:
      - <my-first-component
  - stepId: eyebrow-slot-html
    title: "HTML: Named Slot Content"
    summary: U host ubacujemo `<span slot="eyebrow">Vanilla JS</span>`. Light DOM
      sadržaj ostaje isti i u ovoj čistijoj verziji komponente.
    intent: Named slot je i dalje najjednostavniji način da spolja projiciraš mali,
      ciljani deo sadržaja u komponentu.
    tag: html:slot-eyebrow
    proTip: Named slot je i dalje najjednostavniji način da spolja projiciraš mali,
      ciljani deo sadržaja u komponentu.
    focusHtmlNeedles:
      - slot="eyebrow"
      - <my-first-component
  - stepId: summary-text-html
    title: "HTML: Default Slot Text"
    summary: Dodajemo opisni tekst kao default slot sadržaj. Čišćenje stila ne menja
      slot logiku; menja samo gde CSS živi.
    intent: "Ovo je važna poenta: refactor styling pristupa ne bi trebalo da razbije
      HTML API komponente."
    tag: html:default-slot
    proTip: "Ovo je važna poenta: refactor styling pristupa ne bi trebalo da razbije
      HTML API komponente."
    focusHtmlNeedles:
      - <my-first-component
      - slot="eyebrow"
  - stepId: template-declaration
    title: "JS: Template Sada Čuva Samo Markup"
    summary: Kreiramo `document.createElement('template')`, ali ovoga puta template
      više nije zadužen i za stilove. Čuvamo ga samo za shadow DOM markup.
    intent: Kada template više ne nosi i markup i CSS zajedno, komponenta postaje
      čitljivija i lakša za održavanje.
    tag: js:template-declaration
    proTip: Kada template više ne nosi i markup i CSS zajedno, komponenta postaje
      čitljivija i lakša za održavanje.
    focusHtmlNeedles: &a1
      - <my-first-component
      - slot="eyebrow"
  - stepId: cleanup-intro
    title: Now Let's Clean The Mess
    summary: "Ovde pravimo glavni refactor: CSS više ne guramo u `<style>` unutar
      `template.innerHTML`, niti ga držimo kao veliki inline string u JavaScript
      fajlu. Prebacujemo ga u poseban `shadow-dom-style.css` koji komponenta
      kasnije samo usvoji."
    intent: Suština ovog koraka je da CSS može da bude odvojen i od class logike i
      od template markup-a, umesto da sve bude zbijeno u jedan veliki string.
    tag: js:cleanup-intro
    proTip: Suština ovog koraka je da CSS može da bude odvojen i od class logike i
      od template markup-a, umesto da sve bude zbijeno u jedan veliki string.
    focusHtmlNeedles: *a1
  - stepId: shadow-css-import
    title: "JS: Uvozimo shadow-dom-style.css kao tekst"
    summary: Dodajemo `import shadowDomStyleCssText from
      './shadow-dom-style.css?raw';`, pa JavaScript više ne nosi same CSS linije
      nego samo učitava gotov stylesheet source.
    intent: "Ovo je najčistiji Vite-friendly model za ovu lekciju: CSS fizički živi
      u svom fajlu, a komponenta ga samo pretvara u `CSSStyleSheet`."
    tag: js:shadow-css-import
    proTip: "Ovo je najčistiji Vite-friendly model za ovu lekciju: CSS fizički živi
      u svom fajlu, a komponenta ga samo pretvara u `CSSStyleSheet`."
    focusHtmlNeedles: *a1
  - stepId: stylesheet-declaration
    title: "JS: Kreiramo CSSStyleSheet"
    summary: Dodajemo `new CSSStyleSheet()` i otvaramo poseban objekat koji će
      čuvati CSS komponente van same klase.
    intent: To je prvi konkretan signal da stil više nije spakovan zajedno sa
      markup-om u jednom template bloku.
    tag: js:stylesheet-declaration
    proTip: To je prvi konkretan signal da stil više nije spakovan zajedno sa
      markup-om u jednom template bloku.
    focusHtmlNeedles: *a1
  - stepId: stylesheet-replace-sync
    title: "JS: replaceSync Prima Uvezeni CSS"
    summary: Kroz `myFirstComponentStyles.replaceSync(shadowDomStyleCssText)` punimo
      constructed stylesheet tekstom koji stiže iz posebnog CSS fajla.
      JavaScript više ne nosi stil pravila u sebi.
    intent: "Ovo je najvažniji mentalni model cele lekcije: CSS je izdvojen u
      poseban fajl, a JavaScript ga samo povezuje sa shadow root-om."
    tag: js:stylesheet-replace-sync
    proTip: "Ovo je najvažniji mentalni model cele lekcije: CSS je izdvojen u
      poseban fajl, a JavaScript ga samo povezuje sa shadow root-om."
    focusHtmlNeedles: *a1
  - stepId: template-markup-open
    title: "JS: Template Markup Bez <style>"
    summary: Sada otvaramo `template.innerHTML = \`` i ubacujemo samo card markup.
      Nema više embedded `<style>` bloka u template string-u.
    intent: Kad neko otvori template, vidi isključivo strukturu DOM-a. To je mnogo
      čistiji signal odgovornosti.
    tag: js:template-markup-open
    proTip: Kad neko otvori template, vidi isključivo strukturu DOM-a. To je mnogo
      čistiji signal odgovornosti.
    focusHtmlNeedles: *a1
  - stepId: card-markup
    title: "JS: Dodajemo Shadow DOM Markup"
    summary: U template ubacujemo card wrapper, named slot za eyebrow, semantički
      `h2` naslov, paragraf sa default slotom, CTA dugme i `part` atribute za
      kasniji escape hatch.
    intent: Template sada stvarno priča samo markup priču.
    tag: js:card-markup
    proTip: Template sada stvarno priča samo markup priču.
    focusHtmlNeedles: *a1
  - stepId: class-declaration
    title: "JS: Class Extends HTMLElement"
    summary: Otvaramo `class MyFirstComponent extends HTMLElement`. Time browseru
      kažemo da naš custom element ima sopstveno ponašanje.
    intent: Custom element je i dalje običan DOM element, samo sa tvojom klasom i
      tvojim lifecycle ponašanjem.
    tag: js:class-declaration
    proTip: Custom element je i dalje običan DOM element, samo sa tvojom klasom i
      tvojim lifecycle ponašanjem.
    focusHtmlNeedles: *a1
  - stepId: constructor-shadow
    title: "JS: constructor + attachShadow"
    summary: "U konstruktoru pozivamo `super()` i odmah otvaramo `const shadowRoot =
      this.attachShadow({ mode: 'open' })` da komponenta dobije sopstveni shadow
      root."
    intent: "Shadow root je granica komponente: markup i adopted stylesheet žive iza
      nje."
    tag: js:constructor-shadow
    proTip: "Shadow root je granica komponente: markup i adopted stylesheet žive iza
      nje."
    focusHtmlNeedles: *a1
  - stepId: constructor-clone
    title: "JS: Kloniramo Template"
    summary: Dodajemo
      `appendChild(myFirstComponentTemplate.content.cloneNode(true))`, pa svaka
      instanca komponente dobija isti početni shadow DOM skeleton.
    intent: Kloniranje template-a je najčistiji način da jednu definiciju koristiš u
      više instanci.
    tag: js:constructor-clone
    proTip: Kloniranje template-a je najčistiji način da jednu definiciju koristiš u
      više instanci.
    focusHtmlNeedles: *a1
  - stepId: constructor-adopt-stylesheet
    title: "JS: Shadow Root Usvaja Stylesheet"
    summary: Dodajemo `shadowRoot.adoptedStyleSheets = [myFirstComponentStyles]`, pa
      shadow root dobija stil bez ubacivanja `<style>` taga u template.
    intent: "Ovo je trenutak kada čisti separation stvarno proradi: stylesheet je
      izdvojen, a shadow root ga samo preuzima."
    tag: js:constructor-adopt-stylesheet
    proTip: "Ovo je trenutak kada čisti separation stvarno proradi: stylesheet je
      izdvojen, a shadow root ga samo preuzima."
    focusHtmlNeedles: *a1
  - stepId: constructor-cache-title
    title: "JS: Keširamo Title Element"
    summary: U konstruktoru čuvamo referencu na `.title` element, da ga kasnije ne
      tražimo iznova pri svakom renderu.
    intent: Mali cache DOM referenci drži render jasan i predvidiv.
    tag: js:constructor-cache-title
    proTip: Mali cache DOM referenci drži render jasan i predvidiv.
    focusHtmlNeedles: *a1
  - stepId: constructor-cache-cta
    title: "JS: Keširamo CTA Element"
    summary: Na isti način čuvamo referencu na `.cta`, jer će tekst dugmeta stizati
      iz atributa host elementa.
    intent: Render treba da govori šta menja, ne da svaki put iznova objašnjava kako
      traži iste čvorove.
    tag: js:constructor-cache-cta
    proTip: Render treba da govori šta menja, ne da svaki put iznova objašnjava kako
      traži iste čvorove.
    focusHtmlNeedles: *a1
  - stepId: constructor-bind-click
    title: "JS: Bindujemo CTA Handler"
    summary: U konstruktoru vezujemo `this.handleClick =
      this.handleClick.bind(this)`, da isti handler može bezbedno da se koristi
      i za add i za remove listener.
    intent: Ako komponenta ima cleanup, stabilna referenca handlera više nije
      optional polish nego deo korektnog lifecycle ponašanja.
    tag: js:constructor-bind-click
    proTip: Ako komponenta ima cleanup, stabilna referenca handlera više nije
      optional polish nego deo korektnog lifecycle ponašanja.
    focusHtmlNeedles: *a1
  - stepId: render-declaration
    title: "JS: Uvodimo render()"
    summary: Dodajemo `render()` metodu kao jedno mesto gde atributi host elementa
      prelaze u konkretan UI tekst unutar shadow DOM-a.
    intent: Jedan render ulaz čini komponentu lakšom za kasnije promene i objašnjenja.
    tag: js:render-declaration
    proTip: Jedan render ulaz čini komponentu lakšom za kasnije promene i objašnjenja.
    focusHtmlNeedles: *a1
  - stepId: render-title
    title: "JS: render() Popunjava Title"
    summary: U `render()` čitamo `title` atribut i upisujemo ga u `.title` element.
      Time host atribut postaje stvaran UI sadržaj u komponenti.
    intent: Atributi su spoljašnji API komponente; render je mesto gde taj API
      dobija vizuelni rezultat.
    tag: js:render-title
    proTip: Atributi su spoljašnji API komponente; render je mesto gde taj API
      dobija vizuelni rezultat.
    focusHtmlNeedles: *a1
  - stepId: render-cta
    title: "JS: render() Popunjava CTA"
    summary: Na isti način `cta-label` atribut pretvaramo u tekst CTA dugmeta.
    intent: Kad dve stvari rade istu vrstu posla, drži ih u istom render toku.
    tag: js:render-cta
    proTip: Kad dve stvari rade istu vrstu posla, drži ih u istom render toku.
    focusHtmlNeedles: *a1
  - stepId: connected-callback
    title: "JS: connectedCallback Lifecycle"
    summary: Dodajemo `connectedCallback()` kao mesto gde komponenta obavlja prvi
      render i povezuje runtime ponašanje.
    intent: Kada komponenta pređe iz statičnog prikaza u živi UI, connectedCallback
      postaje prirodan lifecycle ulaz.
    tag: js:connected-callback
    proTip: Kada komponenta pređe iz statičnog prikaza u živi UI, connectedCallback
      postaje prirodan lifecycle ulaz.
    focusHtmlNeedles: *a1
  - stepId: connected-callback-render
    title: "JS: connectedCallback Pokreće Prvi Render"
    summary: U `connectedCallback()` pozivamo `this.render()`, pa komponenta dobija
      sadržaj čim uđe u DOM.
    intent: Prvi render je prirodno vezati za trenutak kada je element stvarno
      povezan sa dokumentom.
    tag: js:connected-callback-render
    proTip: Prvi render je prirodno vezati za trenutak kada je element stvarno
      povezan sa dokumentom.
    focusHtmlNeedles: *a1
  - stepId: connected-callback-listener
    title: "JS: connectedCallback Vezuje Click Listener"
    summary: U istom lifecycle koraku vezujemo click listener na CTA dugme, pa
      komponenta više ne samo prikazuje UI nego i emituje akciju.
    intent: Tek ovde komponenta postaje i interaktivna, ne samo vizuelno renderovana.
    tag: js:connected-callback-listener
    proTip: Tek ovde komponenta postaje i interaktivna, ne samo vizuelno renderovana.
    focusHtmlNeedles: *a1
  - stepId: disconnected-callback
    title: "JS: disconnectedCallback Cleanup"
    summary: Dodajemo `disconnectedCallback()` i skidamo CTA listener kada
      komponenta izađe iz DOM-a.
    intent: Cleanup je pravi production-grade signal da komponenta poštuje ceo
      lifecycle, ne samo mount.
    tag: js:disconnected-callback
    proTip: Cleanup je pravi production-grade signal da komponenta poštuje ceo
      lifecycle, ne samo mount.
    focusHtmlNeedles: *a1
  - stepId: observed-attributes
    title: "JS: observedAttributes"
    summary: Dodajemo `static observedAttributes = ['title', 'cta-label']`, pa
      browser zna koje promene atributa treba da javi komponenti.
    intent: Ako komponenta treba da reaguje na promenu atributa, prvo mora
      eksplicitno da kaže koje atribute prati.
    tag: js:observed-attributes
    proTip: Ako komponenta treba da reaguje na promenu atributa, prvo mora
      eksplicitno da kaže koje atribute prati.
    focusHtmlNeedles: *a1
  - stepId: attribute-changed-callback
    title: "JS: attributeChangedCallback"
    summary: Dodajemo `attributeChangedCallback()` sa guard-om za `isConnected`, pa
      render radimo samo kada komponenta zaista živi u DOM-u.
    intent: "To je mali, ali važan robustness detalj: lifecycle više nije samo
      ispravan, nego i disciplinovan."
    tag: js:attribute-changed-callback
    proTip: "To je mali, ali važan robustness detalj: lifecycle više nije samo
      ispravan, nego i disciplinovan."
    focusHtmlNeedles: *a1
  - stepId: handle-click-dispatch-event
    title: "JS: CTA Emituje component-action"
    summary: Dodajemo `handleClick()` i iz njega emitujemo
      `CustomEvent('component-action', ...)`, pa komponenta dobija jasan izlazni
      signal.
    intent: "Komponenta time dobija izlazni API: ne prima samo atribute, nego i
      javlja korisničku akciju spolja."
    tag: js:handle-click-dispatch-event
    proTip: "Komponenta time dobija izlazni API: ne prima samo atribute, nego i
      javlja korisničku akciju spolja."
    focusHtmlNeedles: *a1
  - stepId: define-guard
    title: "JS: Čuvamo se duplog define-a"
    summary: Pre registracije proveravamo
      `customElements.get('my-first-component')`, da isti custom element ne
      pokušamo da definišemo dva puta.
    intent: Ovo nije samo defensive code; u okruženjima sa hot reload-om ili više
      mount ciklusa to je praktično obavezna zaštita.
    tag: js:define-guard
    proTip: Ovo nije samo defensive code; u okruženjima sa hot reload-om ili više
      mount ciklusa to je praktično obavezna zaštita.
    focusHtmlNeedles: *a1
  - stepId: define-element
    title: "JS: Registrujemo Custom Element"
    summary: Unutar guard-a pozivamo `customElements.define('my-first-component',
      MyFirstComponent)`. Od ovog trenutka browser zna kako da upgrade-uje
      `<my-first-component>` u pravu komponentu i preview dobija render bez
      style taga u template-u.
    intent: "Sada je i struktura koda čistija: template čuva markup, stylesheet čuva
      CSS, a klasa orkestrira ponašanje."
    tag: js:define-element
    proTip: "Sada je i struktura koda čistija: template čuva markup, stylesheet čuva
      CSS, a klasa orkestrira ponašanje."
    focusHtmlNeedles: *a1
  - stepId: shell-outline
    title: "CSS: .app-shell / outline"
    summary: Dodajemo tanak helper outline za `.app-shell` i zadržavamo ga kroz celu
      lekciju, sve do završnog shell rezimea.
    intent: App shell ostaje stalni okvir cele demonstracije dok ne završimo ceo
      tutorijal.
    tag: css:shell-outline
    proTip: App shell ostaje stalni okvir cele demonstracije dok ne završimo ceo
      tutorijal.
    focusHtmlNeedles: &a2
      - <div class="app-shell">
  - stepId: shell-padding
    title: "CSS: .app-shell / padding"
    summary: Dodajemo padding da komponenta dobije vazduh čim se pojavi u preview-u.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:shell-padding
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a2
  - stepId: shell-display
    title: "CSS: .app-shell / display"
    summary: Grid je jednostavan način da centralno postavimo jedan teaching target.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:shell-display
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a2
  - stepId: shell-place-items
    title: "CSS: .app-shell / place-items"
    summary: Centar zadržava fokus korisnika na jednoj komponenti.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:shell-place-items
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a2
  - stepId: shell-min-height
    title: "CSS: .app-shell / min-height"
    summary: Puna visina drži scenu stabilnom kroz celu lekciju.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:shell-min-height
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a2
  - stepId: shell-background
    title: "CSS: .app-shell / background"
    summary: Svetla pozadina daje kontrast tamnoj komponenti koju gradimo.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:shell-background
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a2
  - stepId: host-outline
    title: "CSS: my-first-component / outline"
    summary: Dodajemo tanak helper outline za host element i držimo ga do završnog
      host rezimea.
    intent: Host i dalje ostaje spoljašnji API komponente, čak i kada unutrašnji CSS
      više ne živi u template string-u.
    tag: css:host-outline
    proTip: Host i dalje ostaje spoljašnji API komponente, čak i kada unutrašnji CSS
      više ne živi u template string-u.
    focusHtmlNeedles: *a1
  - stepId: host-display
    title: "CSS: my-first-component / display"
    summary: Host pretvaramo u block da zauzme svoj red i dobije realan footprint.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:host-display
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a1
  - stepId: host-width
    title: "CSS: my-first-component / width"
    summary: Širinu zaključavamo rano da card skeleton ne šeta po sceni.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:host-width
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a1
  - stepId: host-surface-token
    title: "CSS: my-first-component / --callout-surface"
    summary: Spolja uvodimo surface token koji adopted stylesheet kasnije povlači
      kroz `var(...)`.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:host-surface-token
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a1
  - stepId: host-surface-alt-token
    title: "CSS: my-first-component / --callout-surface-alt"
    summary: Dodajemo i drugi surface ton da unutrašnji gradijent ne zavisi od
      hardkodovanog fallback-a.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:host-surface-alt-token
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a1
  - stepId: host-border-token
    title: "CSS: my-first-component / --callout-border"
    summary: Border token služi da spolja theme-ujemo ivicu komponente.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:host-border-token
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a1
  - stepId: host-accent-token
    title: "CSS: my-first-component / --callout-accent"
    summary: Accent token će obojiti badge i CTA unutar komponente.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:host-accent-token
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a1
  - stepId: host-accent-strong-token
    title: "CSS: my-first-component / --callout-accent-strong"
    summary: Jači accent ton služi za dublji kraj CTA gradijenta.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:host-accent-strong-token
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a1
  - stepId: host-text-token
    title: "CSS: my-first-component / --callout-text"
    summary: Text token daje konzistentnu boju celom Web Component sadržaju.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:host-text-token
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a1
  - stepId: host-muted-token
    title: "CSS: my-first-component / --callout-muted"
    summary: Muted token služi sekundarnom tekstu unutar komponente.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:host-muted-token
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a1
  - stepId: host-shadow-token
    title: "CSS: my-first-component / --callout-shadow"
    summary: Shadow token prebacuje i dubinu komponente u spoljašnji theme sloj.
    intent: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    tag: css:host-shadow-token
    proTip: Spoljašnji CSS ovde ne stilizuje samo shell, već i theme tokene koje će
      Web Component povući iz host elementa.
    focusHtmlNeedles: *a1
  - stepId: host-font
    title: "Shadow CSS: :host / font-family"
    summary: "Počinje constructed stylesheet: host dobija isti font stack kao i
      ostatak scene."
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:host-font
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: &a3
      - <my-first-component
      - slot="eyebrow"
  - stepId: host-color
    title: "Shadow CSS: :host / color"
    summary: Host odmah koristi spoljašnji text token, pa vidiš kako custom property
      prolazi kroz granicu shadow DOM-a.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:host-color
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a3
  - stepId: card-outline
    title: "Shadow CSS: .card / outline"
    summary: Dodajemo helper outline za glavni card blok i držimo ga do završnog
      card rezimea.
    intent: Glavni card outline ostaje dok ne završimo celu unutrašnju celinu.
    tag: shadow-css:card-outline
    proTip: Glavni card outline ostaje dok ne završimo celu unutrašnju celinu.
    focusHtmlNeedles: &a4
      - <my-first-component
      - slot="eyebrow"
  - stepId: card-display
    title: "Shadow CSS: .card / display"
    summary: Card raspored uvodimo grid-om jer imamo vertikalnu stack strukturu.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:card-display
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a4
  - stepId: card-gap
    title: "Shadow CSS: .card / gap"
    summary: Gap odvaja badge, naslov, opis i CTA.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:card-gap
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a4
  - stepId: card-padding
    title: "Shadow CSS: .card / padding"
    summary: Padding pravi pravi card footprint unutar komponente.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:card-padding
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a4
  - stepId: card-radius
    title: "Shadow CSS: .card / border-radius"
    summary: Zaobljenje daje modernu card siluetu.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:card-radius
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a4
  - stepId: card-border
    title: "Shadow CSS: .card / border"
    summary: Ivica koristi host token, pa spoljašnji CSS zaista utiče na unutrašnji
      card.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:card-border
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a4
  - stepId: card-background
    title: "Shadow CSS: .card / background"
    summary: Tamna pozadina sada čita oba surface tokena direktno sa host elementa.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:card-background
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a4
  - stepId: card-shadow
    title: "Shadow CSS: .card / box-shadow"
    summary: Shadow sada takođe čita spoljašnji token, pa i dubina komponente
      postaje deo API-ja.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:card-shadow
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a4
  - stepId: eyebrow-outline
    title: "Shadow CSS: .eyebrow / outline"
    summary: Dodajemo helper outline za eyebrow badge i držimo ga do završnog
      eyebrow rezimea.
    intent: Badge je mali element i zato mu outline posebno pomaže tokom objašnjenja.
    tag: shadow-css:eyebrow-outline
    proTip: Badge je mali element i zato mu outline posebno pomaže tokom objašnjenja.
    focusHtmlNeedles: &a5
      - slot="eyebrow"
      - <my-first-component
  - stepId: eyebrow-display
    title: "Shadow CSS: .eyebrow / display"
    summary: Badge ostaje kompakatan i prirodno prati svoj sadržaj.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:eyebrow-display
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-align-items
    title: "Shadow CSS: .eyebrow / align-items"
    summary: Vertikalno centriramo sadržaj badge-a da kapsula izgleda urednije.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:eyebrow-align-items
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-justify-content
    title: "Shadow CSS: .eyebrow / justify-content"
    summary: Tekst badge-a ostaje simetrično centriran i kada se sadržaj menja.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:eyebrow-justify-content
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-width
    title: "Shadow CSS: .eyebrow / width"
    summary: Badge širinu vežemo isključivo za sadržaj, ne za širinu roditelja.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:eyebrow-width
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-padding
    title: "Shadow CSS: .eyebrow / padding"
    summary: Padding daje badge-u jasan pill footprint.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:eyebrow-padding
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-radius
    title: "Shadow CSS: .eyebrow / border-radius"
    summary: Veliki radius zatvara badge u kapsulu.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:eyebrow-radius
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-background
    title: "Shadow CSS: .eyebrow / background"
    summary: Poluprovidna pozadina pravi nežan badge signal.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:eyebrow-background
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-color
    title: "Shadow CSS: .eyebrow / color"
    summary: Boju badge-a takođe vežemo za host accent token.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:eyebrow-color
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-font-size
    title: "Shadow CSS: .eyebrow / font-size"
    summary: Manji font čini badge sekundarnim, ali čitljivim.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:eyebrow-font-size
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-font-weight
    title: "Shadow CSS: .eyebrow / font-weight"
    summary: Težina fonta čini badge labelu kompaktnom i jasnom.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:eyebrow-font-weight
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-letter-spacing
    title: "Shadow CSS: .eyebrow / letter-spacing"
    summary: Mali tracking daje badge-u uredniji, label-like karakter.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:eyebrow-letter-spacing
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-text-transform
    title: "Shadow CSS: .eyebrow / text-transform"
    summary: Uppercase zatvara eyebrow kao jasnu oznaku kategorije.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:eyebrow-text-transform
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a5
  - stepId: title-display
    title: "Shadow CSS: .title / display"
    summary: Naslovu dajemo sopstveni red da ne deli liniju sa drugim delovima.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:title-display
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: &a6
      - <my-first-component
  - stepId: title-margin
    title: "Shadow CSS: .title / margin"
    summary: Pošto koristimo semantički `h2`, prvo gasimo podrazumevani margin.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:title-margin
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a6
  - stepId: title-font-size
    title: "Shadow CSS: .title / font-size"
    summary: Naslov dobija responzivniju veličinu, bližu finalnom polished utisku.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:title-font-size
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a6
  - stepId: title-line-height
    title: "Shadow CSS: .title / line-height"
    summary: Kraći line-height drži naslov zategnutim i čitljivim.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:title-line-height
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a6
  - stepId: title-font-weight
    title: "Shadow CSS: .title / font-weight"
    summary: Pojačavamo naslov da odmah nosi hijerarhiju.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:title-font-weight
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a6
  - stepId: summary-margin
    title: "Shadow CSS: .summary / margin"
    summary: Brišemo podrazumevani paragraf margin da spacing kontrolišemo iz card
      gap-a.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:summary-margin
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: &a7
      - <my-first-component
  - stepId: summary-color
    title: "Shadow CSS: .summary / color"
    summary: Opis dobija muted token, pa i sekundarni tekst postaje deo spoljašnjeg
      theme API-ja.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:summary-color
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a7
  - stepId: summary-line-height
    title: "Shadow CSS: .summary / line-height"
    summary: Line-height otvara tekst i čini ga lakšim za čitanje.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:summary-line-height
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a7
  - stepId: cta-outline
    title: "Shadow CSS: .cta / outline"
    summary: Dodajemo helper outline za CTA i držimo ga do završnog CTA rezimea.
    intent: CTA outline ostaje dok ne zaključimo poslednju interaktivnu zonu.
    tag: shadow-css:cta-outline
    proTip: CTA outline ostaje dok ne zaključimo poslednju interaktivnu zonu.
    focusHtmlNeedles: &a8
      - <my-first-component
  - stepId: cta-justify-self
    title: "Shadow CSS: .cta / justify-self"
    summary: CTA ostaje uz levu ivicu card sadržaja umesto da se rasteže.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-justify-self
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a8
  - stepId: cta-appearance
    title: "Shadow CSS: .cta / appearance"
    summary: Gasimo browser-native izgled dugmeta da komponenta zadrži konzistentan
      cross-browser izgled.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-appearance
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a8
  - stepId: cta-padding
    title: "Shadow CSS: .cta / padding"
    summary: Padding daje dugmetu njegovu klik zonu.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-padding
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a8
  - stepId: cta-border
    title: "Shadow CSS: .cta / border"
    summary: Uklanjamo podrazumevanu border liniju dugmeta.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-border
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a8
  - stepId: cta-radius
    title: "Shadow CSS: .cta / border-radius"
    summary: Pil radius drži CTA vizuelno bliskim badge logici.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-radius
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a8
  - stepId: cta-background
    title: "Shadow CSS: .cta / background"
    summary: CTA sada koristi i jači accent token za dublji, kontrolisan gradijent.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-background
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a8
  - stepId: cta-color
    title: "Shadow CSS: .cta / color"
    summary: Beli tekst drži jasan kontrast preko gradijenta.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-color
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a8
  - stepId: cta-font
    title: "Shadow CSS: .cta / font"
    summary: Dugme preuzima isti font vocabulary kao i ostatak komponente.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-font
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a8
  - stepId: cta-font-weight
    title: "Shadow CSS: .cta / font-weight"
    summary: Težina fonta zatvara CTA kao jasan action element.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-font-weight
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a8
  - stepId: cta-cursor
    title: "Shadow CSS: .cta / cursor"
    summary: Kursor eksplicitno potvrđuje interaktivnost CTA dugmeta.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-cursor
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a8
  - stepId: cta-transition
    title: "Shadow CSS: .cta / transition"
    summary: Dodajemo finu tranziciju da hover i focus states ne deluju grubo.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-transition
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a8
  - stepId: cta-box-shadow
    title: "Shadow CSS: .cta / box-shadow"
    summary: Mali shadow pojačava CTA kao završni action sloj.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-box-shadow
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a8
  - stepId: cta-hover-filter
    title: "Shadow CSS: .cta:hover / filter"
    summary: Hover blago podiže svetlinu CTA dugmeta bez agresivne promene boje.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-hover-filter
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: &a9
      - <my-first-component
  - stepId: cta-hover-transform
    title: "Shadow CSS: .cta:hover / transform"
    summary: Minimalni lift daje osećaj da dugme odgovara na hover.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-hover-transform
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a9
  - stepId: cta-active-transform
    title: "Shadow CSS: .cta:active / transform"
    summary: Na active vraćamo dugme nazad, da klik ima malu fizičku povratnu
      informaciju.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-active-transform
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles:
      - <my-first-component
  - stepId: cta-focus-outline
    title: "Shadow CSS: .cta:focus-visible / outline"
    summary: Focus-visible dodaje jasan tastaturski focus ring bez oslanjanja na
      browser default.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-focus-outline
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: &a10
      - <my-first-component
  - stepId: cta-focus-outline-offset
    title: "Shadow CSS: .cta:focus-visible / outline-offset"
    summary: Offset odvaja focus ring od same pil ivice dugmeta.
    intent: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    tag: shadow-css:cta-focus-outline-offset
    proTip: Ovde je poenta da CSS ostane u sopstvenom fajlu, dok JavaScript samo
      uvozi tekst i usvaja ga kroz Web Components API.
    focusHtmlNeedles: *a10
  - stepId: card-summary
    title: "Rezime: .card u shadow-dom-style.css"
    summary: Rezimiramo glavni card blok i tek sada uklanjamo njegov helper outline,
      jer su struktura, stil iz posebnog CSS fajla i način usvajanja
      stylesheet-a potpuno jasni.
    intent: Helper outline za glavni card ostaje dok i markup i poseban shadow CSS
      tok ne budu dovoljno čitljivi.
    tag: summary:card-summary
    proTip: Helper outline za glavni card ostaje dok i markup i poseban shadow CSS
      tok ne budu dovoljno čitljivi.
    focusHtmlNeedles: *a1
  - stepId: eyebrow-summary
    title: "Rezime: .eyebrow u shadow-dom-style.css"
    summary: Rezimiramo eyebrow badge i uklanjamo njegov helper outline tek sada,
      kada slot projekcija i badge stil rade zajedno iz izdvojenog CSS fajla.
    intent: Slot je ovde važan deo lekcije, pa helper outline ostaje dok named slot
      ne postane jasan.
    tag: summary:eyebrow-summary
    proTip: Slot je ovde važan deo lekcije, pa helper outline ostaje dok named slot
      ne postane jasan.
    focusHtmlNeedles: *a1
  - stepId: cta-summary
    title: "Rezime: .cta u shadow-dom-style.css"
    summary: "Rezime za CTA dugme: helper outline više nije potreban, jer završni
      stil iz posebnog CSS fajla, event i hover/focus ponašanje već jasno
      pokazuju njegovu ulogu."
    intent: Outline služi učenju; kad je element potpuno objašnjen, može da nestane.
    tag: summary:cta-summary
    proTip: Outline služi učenju; kad je element potpuno objašnjen, može da nestane.
    focusHtmlNeedles: *a1
  - stepId: host-summary
    title: "Rezime: my-first-component host"
    summary: "Završni host rezime: spoljašnji outline host elementa više nije
      potreban, jer su API atributi, theme tokeni i adopted stylesheet tok sada
      jasni."
    intent: Host outline ostaje dok ne pokažemo i spoljašnji API i unutrašnju
      implementaciju komponente.
    tag: summary:host-summary
    proTip: Host outline ostaje dok ne pokažemo i spoljašnji API i unutrašnju
      implementaciju komponente.
    focusHtmlNeedles: *a1
  - stepId: shell-summary
    title: "Rezime: .app-shell"
    summary: Tek sada uklanjamo helper outline sa `.app-shell`, jer je cela cleanup
      lekcija kompletna i okvir više nije potreban.
    intent: App shell outline ostaje sve vreme kao teaching okvir i nestaje tek na
      samom kraju lekcije.
    tag: summary:shell-summary
    proTip: App shell outline ostaje sve vreme kao teaching okvir i nestaje tek na
      samom kraju lekcije.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: done
    title: "Done: Clean My First Component with adoptedStyleSheets"
    summary: "Lekcija je završena: ista komponenta sada ima čistiji raspored
      odgovornosti. Host HTML ostaje mali, template čuva samo markup,
      `shadow-dom-style.css` čuva CSS, a klasa samo uvozi tekst, usvaja
      stylesheet i vodi lifecycle ponašanje."
    intent: Sledeći logičan korak je da isti stylesheet podeliš između više shadow
      root instanci ili da uvedeš još jedan komponentni stil sloj.
    tag: success
    proTip: Sledeći logičan korak je da isti stylesheet podeliš između više shadow
      root instanci ili da uvedeš još jedan komponentni stil sloj.
    focusHtmlNeedles: []
---

# Step: empty-shell

## Scene: empty-shell-scene

narration:
Počinjemo od praznog `.app-shell` prostora. Goal slika iznad pokazuje istu komponentu, ali sada je cilj da očistimo način na koji njeni stilovi žive pored JavaScript logike.

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
Dodajemo `<my-first-component>` host sa `title` i `cta-label` atributima. Host API ostaje isti; menja se samo način na koji komponenta organizuje sopstveni CSS.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: eyebrow-slot-html

## Scene: eyebrow-slot-html-scene

narration:
U host ubacujemo `<span slot="eyebrow">Vanilla JS</span>`. Light DOM sadržaj ostaje isti i u ovoj čistijoj verziji komponente.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: summary-text-html

## Scene: summary-text-html-scene

narration:
Dodajemo opisni tekst kao default slot sadržaj. Čišćenje stila ne menja slot logiku; menja samo gde CSS živi.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: template-declaration

## Scene: template-declaration-scene

narration:
Kreiramo `document.createElement('template')`, ali ovoga puta template više nije zadužen i za stilove. Čuvamo ga samo za shadow DOM markup.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cleanup-intro

## Scene: cleanup-intro-scene

narration:
Ovde pravimo glavni refactor: CSS više ne guramo u `<style>` unutar `template.innerHTML`, niti ga držimo kao veliki inline string u JavaScript fajlu. Prebacujemo ga u poseban `shadow-dom-style.css` koji komponenta kasnije samo usvoji.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: shadow-css-import

## Scene: shadow-css-import-scene

narration:
Dodajemo `import shadowDomStyleCssText from './shadow-dom-style.css?raw';`, pa JavaScript više ne nosi same CSS linije nego samo učitava gotov stylesheet source.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: stylesheet-declaration

## Scene: stylesheet-declaration-scene

narration:
Dodajemo `new CSSStyleSheet()` i otvaramo poseban objekat koji će čuvati CSS komponente van same klase.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: stylesheet-replace-sync

## Scene: stylesheet-replace-sync-scene

narration:
Kroz `myFirstComponentStyles.replaceSync(shadowDomStyleCssText)` punimo constructed stylesheet tekstom koji stiže iz posebnog CSS fajla. JavaScript više ne nosi stil pravila u sebi.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: template-markup-open

## Scene: template-markup-open-scene

narration:
Sada otvaramo `template.innerHTML = \`` i ubacujemo samo card markup. Nema više embedded `<style>` bloka u template string-u.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: card-markup

## Scene: card-markup-scene

narration:
U template ubacujemo card wrapper, named slot za eyebrow, semantički `h2` naslov, paragraf sa default slotom, CTA dugme i `part` atribute za kasniji escape hatch.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: class-declaration

## Scene: class-declaration-scene

narration:
Otvaramo `class MyFirstComponent extends HTMLElement`. Time browseru kažemo da naš custom element ima sopstveno ponašanje.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: constructor-shadow

## Scene: constructor-shadow-scene

narration:
U konstruktoru pozivamo `super()` i odmah otvaramo `const shadowRoot = this.attachShadow({ mode: 'open' })` da komponenta dobije sopstveni shadow root.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: constructor-clone

## Scene: constructor-clone-scene

narration:
Dodajemo `appendChild(myFirstComponentTemplate.content.cloneNode(true))`, pa svaka instanca komponente dobija isti početni shadow DOM skeleton.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: constructor-adopt-stylesheet

## Scene: constructor-adopt-stylesheet-scene

narration:
Dodajemo `shadowRoot.adoptedStyleSheets = [myFirstComponentStyles]`, pa shadow root dobija stil bez ubacivanja `<style>` taga u template.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: constructor-cache-title

## Scene: constructor-cache-title-scene

narration:
U konstruktoru čuvamo referencu na `.title` element, da ga kasnije ne tražimo iznova pri svakom renderu.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: constructor-cache-cta

## Scene: constructor-cache-cta-scene

narration:
Na isti način čuvamo referencu na `.cta`, jer će tekst dugmeta stizati iz atributa host elementa.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: constructor-bind-click

## Scene: constructor-bind-click-scene

narration:
U konstruktoru vezujemo `this.handleClick = this.handleClick.bind(this)`, da isti handler može bezbedno da se koristi i za add i za remove listener.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: render-declaration

## Scene: render-declaration-scene

narration:
Dodajemo `render()` metodu kao jedno mesto gde atributi host elementa prelaze u konkretan UI tekst unutar shadow DOM-a.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: render-title

## Scene: render-title-scene

narration:
U `render()` čitamo `title` atribut i upisujemo ga u `.title` element. Time host atribut postaje stvaran UI sadržaj u komponenti.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: render-cta

## Scene: render-cta-scene

narration:
Na isti način `cta-label` atribut pretvaramo u tekst CTA dugmeta.

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
Dodajemo `connectedCallback()` kao mesto gde komponenta obavlja prvi render i povezuje runtime ponašanje.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: connected-callback-render

## Scene: connected-callback-render-scene

narration:
U `connectedCallback()` pozivamo `this.render()`, pa komponenta dobija sadržaj čim uđe u DOM.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: connected-callback-listener

## Scene: connected-callback-listener-scene

narration:
U istom lifecycle koraku vezujemo click listener na CTA dugme, pa komponenta više ne samo prikazuje UI nego i emituje akciju.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: disconnected-callback

## Scene: disconnected-callback-scene

narration:
Dodajemo `disconnectedCallback()` i skidamo CTA listener kada komponenta izađe iz DOM-a.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: observed-attributes

## Scene: observed-attributes-scene

narration:
Dodajemo `static observedAttributes = ['title', 'cta-label']`, pa browser zna koje promene atributa treba da javi komponenti.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: attribute-changed-callback

## Scene: attribute-changed-callback-scene

narration:
Dodajemo `attributeChangedCallback()` sa guard-om za `isConnected`, pa render radimo samo kada komponenta zaista živi u DOM-u.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: handle-click-dispatch-event

## Scene: handle-click-dispatch-event-scene

narration:
Dodajemo `handleClick()` i iz njega emitujemo `CustomEvent('component-action', ...)`, pa komponenta dobija jasan izlazni signal.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: define-guard

## Scene: define-guard-scene

narration:
Pre registracije proveravamo `customElements.get('my-first-component')`, da isti custom element ne pokušamo da definišemo dva puta.

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
Unutar guard-a pozivamo `customElements.define('my-first-component', MyFirstComponent)`. Od ovog trenutka browser zna kako da upgrade-uje `<my-first-component>` u pravu komponentu i preview dobija render bez style taga u template-u.

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
Dodajemo padding da komponenta dobije vazduh čim se pojavi u preview-u.

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
Grid je jednostavan način da centralno postavimo jedan teaching target.

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
Centar zadržava fokus korisnika na jednoj komponenti.

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
Puna visina drži scenu stabilnom kroz celu lekciju.

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
Svetla pozadina daje kontrast tamnoj komponenti koju gradimo.

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
Dodajemo tanak helper outline za host element i držimo ga do završnog host rezimea.

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
Host pretvaramo u block da zauzme svoj red i dobije realan footprint.

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
Širinu zaključavamo rano da card skeleton ne šeta po sceni.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-surface-token

## Scene: host-surface-token-scene

narration:
Spolja uvodimo surface token koji adopted stylesheet kasnije povlači kroz `var(...)`.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-surface-alt-token

## Scene: host-surface-alt-token-scene

narration:
Dodajemo i drugi surface ton da unutrašnji gradijent ne zavisi od hardkodovanog fallback-a.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-border-token

## Scene: host-border-token-scene

narration:
Border token služi da spolja theme-ujemo ivicu komponente.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-accent-token

## Scene: host-accent-token-scene

narration:
Accent token će obojiti badge i CTA unutar komponente.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-accent-strong-token

## Scene: host-accent-strong-token-scene

narration:
Jači accent ton služi za dublji kraj CTA gradijenta.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-text-token

## Scene: host-text-token-scene

narration:
Text token daje konzistentnu boju celom Web Component sadržaju.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-muted-token

## Scene: host-muted-token-scene

narration:
Muted token služi sekundarnom tekstu unutar komponente.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-shadow-token

## Scene: host-shadow-token-scene

narration:
Shadow token prebacuje i dubinu komponente u spoljašnji theme sloj.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-font

## Scene: host-font-scene

narration:
Počinje constructed stylesheet: host dobija isti font stack kao i ostatak scene.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: host-color

## Scene: host-color-scene

narration:
Host odmah koristi spoljašnji text token, pa vidiš kako custom property prolazi kroz granicu shadow DOM-a.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: card-outline

## Scene: card-outline-scene

narration:
Dodajemo helper outline za glavni card blok i držimo ga do završnog card rezimea.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: card-display

## Scene: card-display-scene

narration:
Card raspored uvodimo grid-om jer imamo vertikalnu stack strukturu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: card-gap

## Scene: card-gap-scene

narration:
Gap odvaja badge, naslov, opis i CTA.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: card-padding

## Scene: card-padding-scene

narration:
Padding pravi pravi card footprint unutar komponente.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: card-radius

## Scene: card-radius-scene

narration:
Zaobljenje daje modernu card siluetu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: card-border

## Scene: card-border-scene

narration:
Ivica koristi host token, pa spoljašnji CSS zaista utiče na unutrašnji card.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: card-background

## Scene: card-background-scene

narration:
Tamna pozadina sada čita oba surface tokena direktno sa host elementa.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: card-shadow

## Scene: card-shadow-scene

narration:
Shadow sada takođe čita spoljašnji token, pa i dubina komponente postaje deo API-ja.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-outline

## Scene: eyebrow-outline-scene

narration:
Dodajemo helper outline za eyebrow badge i držimo ga do završnog eyebrow rezimea.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-display

## Scene: eyebrow-display-scene

narration:
Badge ostaje kompakatan i prirodno prati svoj sadržaj.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-align-items

## Scene: eyebrow-align-items-scene

narration:
Vertikalno centriramo sadržaj badge-a da kapsula izgleda urednije.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-justify-content

## Scene: eyebrow-justify-content-scene

narration:
Tekst badge-a ostaje simetrično centriran i kada se sadržaj menja.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-width

## Scene: eyebrow-width-scene

narration:
Badge širinu vežemo isključivo za sadržaj, ne za širinu roditelja.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-padding

## Scene: eyebrow-padding-scene

narration:
Padding daje badge-u jasan pill footprint.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-radius

## Scene: eyebrow-radius-scene

narration:
Veliki radius zatvara badge u kapsulu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-background

## Scene: eyebrow-background-scene

narration:
Poluprovidna pozadina pravi nežan badge signal.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-color

## Scene: eyebrow-color-scene

narration:
Boju badge-a takođe vežemo za host accent token.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-font-size

## Scene: eyebrow-font-size-scene

narration:
Manji font čini badge sekundarnim, ali čitljivim.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-font-weight

## Scene: eyebrow-font-weight-scene

narration:
Težina fonta čini badge labelu kompaktnom i jasnom.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-letter-spacing

## Scene: eyebrow-letter-spacing-scene

narration:
Mali tracking daje badge-u uredniji, label-like karakter.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: eyebrow-text-transform

## Scene: eyebrow-text-transform-scene

narration:
Uppercase zatvara eyebrow kao jasnu oznaku kategorije.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: title-display

## Scene: title-display-scene

narration:
Naslovu dajemo sopstveni red da ne deli liniju sa drugim delovima.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: title-margin

## Scene: title-margin-scene

narration:
Pošto koristimo semantički `h2`, prvo gasimo podrazumevani margin.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: title-font-size

## Scene: title-font-size-scene

narration:
Naslov dobija responzivniju veličinu, bližu finalnom polished utisku.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: title-line-height

## Scene: title-line-height-scene

narration:
Kraći line-height drži naslov zategnutim i čitljivim.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: title-font-weight

## Scene: title-font-weight-scene

narration:
Pojačavamo naslov da odmah nosi hijerarhiju.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: summary-margin

## Scene: summary-margin-scene

narration:
Brišemo podrazumevani paragraf margin da spacing kontrolišemo iz card gap-a.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: summary-color

## Scene: summary-color-scene

narration:
Opis dobija muted token, pa i sekundarni tekst postaje deo spoljašnjeg theme API-ja.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: summary-line-height

## Scene: summary-line-height-scene

narration:
Line-height otvara tekst i čini ga lakšim za čitanje.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-outline

## Scene: cta-outline-scene

narration:
Dodajemo helper outline za CTA i držimo ga do završnog CTA rezimea.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-justify-self

## Scene: cta-justify-self-scene

narration:
CTA ostaje uz levu ivicu card sadržaja umesto da se rasteže.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-appearance

## Scene: cta-appearance-scene

narration:
Gasimo browser-native izgled dugmeta da komponenta zadrži konzistentan cross-browser izgled.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-padding

## Scene: cta-padding-scene

narration:
Padding daje dugmetu njegovu klik zonu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-border

## Scene: cta-border-scene

narration:
Uklanjamo podrazumevanu border liniju dugmeta.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-radius

## Scene: cta-radius-scene

narration:
Pil radius drži CTA vizuelno bliskim badge logici.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-background

## Scene: cta-background-scene

narration:
CTA sada koristi i jači accent token za dublji, kontrolisan gradijent.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-color

## Scene: cta-color-scene

narration:
Beli tekst drži jasan kontrast preko gradijenta.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-font

## Scene: cta-font-scene

narration:
Dugme preuzima isti font vocabulary kao i ostatak komponente.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-font-weight

## Scene: cta-font-weight-scene

narration:
Težina fonta zatvara CTA kao jasan action element.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-cursor

## Scene: cta-cursor-scene

narration:
Kursor eksplicitno potvrđuje interaktivnost CTA dugmeta.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-transition

## Scene: cta-transition-scene

narration:
Dodajemo finu tranziciju da hover i focus states ne deluju grubo.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-box-shadow

## Scene: cta-box-shadow-scene

narration:
Mali shadow pojačava CTA kao završni action sloj.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-hover-filter

## Scene: cta-hover-filter-scene

narration:
Hover blago podiže svetlinu CTA dugmeta bez agresivne promene boje.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-hover-transform

## Scene: cta-hover-transform-scene

narration:
Minimalni lift daje osećaj da dugme odgovara na hover.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-active-transform

## Scene: cta-active-transform-scene

narration:
Na active vraćamo dugme nazad, da klik ima malu fizičku povratnu informaciju.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-focus-outline

## Scene: cta-focus-outline-scene

narration:
Focus-visible dodaje jasan tastaturski focus ring bez oslanjanja na browser default.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-focus-outline-offset

## Scene: cta-focus-outline-offset-scene

narration:
Offset odvaja focus ring od same pil ivice dugmeta.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: card-summary

## Scene: card-summary-scene

narration:
Rezimiramo glavni card blok i tek sada uklanjamo njegov helper outline, jer su struktura, stil iz posebnog CSS fajla i način usvajanja stylesheet-a potpuno jasni.

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
Rezimiramo eyebrow badge i uklanjamo njegov helper outline tek sada, kada slot projekcija i badge stil rade zajedno iz izdvojenog CSS fajla.

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
Rezime za CTA dugme: helper outline više nije potreban, jer završni stil iz posebnog CSS fajla, event i hover/focus ponašanje već jasno pokazuju njegovu ulogu.

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
Završni host rezime: spoljašnji outline host elementa više nije potreban, jer su API atributi, theme tokeni i adopted stylesheet tok sada jasni.

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
Tek sada uklanjamo helper outline sa `.app-shell`, jer je cela cleanup lekcija kompletna i okvir više nije potreban.

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
Lekcija je završena: ista komponenta sada ima čistiji raspored odgovornosti. Host HTML ostaje mali, template čuva samo markup, `shadow-dom-style.css` čuva CSS, a klasa samo uvozi tekst, usvaja stylesheet i vodi lifecycle ponašanje.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom
