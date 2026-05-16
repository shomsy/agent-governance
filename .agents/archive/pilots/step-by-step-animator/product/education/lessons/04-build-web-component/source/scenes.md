---
schemaVersion: 1
lessonId: 04-build-web-component
steps:
  - stepId: empty-shell
    title: "Start: Empty App Shell"
    summary: Počinjemo od praznog `.app-shell` prostora. Goal slika iznad pokazuje
      finalni Web Component koji tek treba da oživi kroz HTML, CSS i vanilla
      JavaScript.
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
      atributima. Još nije registrovan, ali browser već vidi custom tag i njegov
      sirovi sadržaj.
    intent: Naziv custom elementa mora da sadrži crticu. To je osnovno pravilo
      registracije custom elementa.
    tag: html:my-first-component
    proTip: Naziv custom elementa mora da sadrži crticu. To je osnovno pravilo
      registracije custom elementa.
    focusHtmlNeedles:
      - <my-first-component
  - stepId: eyebrow-slot-html
    title: "HTML: Named Slot Content"
    summary: U host ubacujemo `<span slot="eyebrow">Vanilla JS</span>`. To je light
      DOM sadržaj koji će kasnije upasti u named slot unutar shadow DOM-a.
    intent: Named slot je najjednostavniji način da spolja projiciraš mali, ciljani
      deo sadržaja u komponentu.
    tag: html:slot-eyebrow
    proTip: Named slot je najjednostavniji način da spolja projiciraš mali, ciljani
      deo sadržaja u komponentu.
    focusHtmlNeedles:
      - slot="eyebrow"
      - <my-first-component
  - stepId: summary-text-html
    title: "HTML: Default Slot Text"
    summary: Dodajemo opisni tekst kao default slot sadržaj. Pre registracije
      komponente vidiš ga kao običan sadržaj custom taga; posle registracije
      odlazi u `<slot>` unutar template-a.
    intent: "Ovo je važan momenat: light DOM i shadow DOM nisu ista stvar, ali mogu
      da sarađuju kroz slot projekciju."
    tag: html:default-slot
    proTip: "Ovo je važan momenat: light DOM i shadow DOM nisu ista stvar, ali mogu
      da sarađuju kroz slot projekciju."
    focusHtmlNeedles:
      - <my-first-component
      - slot="eyebrow"
  - stepId: template-declaration
    title: "JS: Kreiramo Template"
    summary: Počinjemo sa `document.createElement('template')`. Template nam daje
      inertan komad DOM-a koji možemo bezbedno da kloniramo u svakoj instanci
      komponente.
    intent: Template je prirodan temelj kada želiš da isti shadow DOM markup i
      stilovi budu dostupni za svaku novu instancu komponente.
    tag: js:template-declaration
    proTip: Template je prirodan temelj kada želiš da isti shadow DOM markup i
      stilovi budu dostupni za svaku novu instancu komponente.
    focusHtmlNeedles: &a1
      - <my-first-component
      - slot="eyebrow"
  - stepId: template-markup-open
    title: "JS: Otvaramo Template String"
    summary: Dodajemo `template.innerHTML = \`` i od tog trenutka gradimo ceo shadow
      DOM sadržaj iz jednog kontrolisanog izvora.
    intent: Prvo otvaramo template kao mesto gde će nastati shadow DOM skeleton, a
      stilove dodajemo tek kada taj skeleton već postoji.
    tag: js:template-markup-open
    proTip: Prvo otvaramo template kao mesto gde će nastati shadow DOM skeleton, a
      stilove dodajemo tek kada taj skeleton već postoji.
    focusHtmlNeedles: *a1
  - stepId: card-markup
    title: "JS: Dodajemo Shadow DOM Markup"
    summary: "Sada ubacujemo unutrašnji markup: card wrapper, named slot za eyebrow,
      semantički `h2` naslov, paragraf sa default slotom, CTA dugme i `part`
      atribute za kasniji escape hatch."
    intent: Prvo pravimo stvarni shadow DOM markup koji preview može da pokaže;
      stilovi i component polish dolaze odmah posle toga.
    tag: js:card-markup
    proTip: Prvo pravimo stvarni shadow DOM markup koji preview može da pokaže;
      stilovi i component polish dolaze odmah posle toga.
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
    intent: "Shadow root je granica komponente: unutrašnji markup i stilovi žive iza
      nje."
    tag: js:constructor-shadow
    proTip: "Shadow root je granica komponente: unutrašnji markup i stilovi žive iza
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
      `<my-first-component>` u pravu komponentu i preview dobija prvi stvarni,
      još uvek sirovi render.
    intent: Tek kada browser dobije živu komponentu, ima smisla da preko nje gradiš
      spoljašnji i unutrašnji CSS sloj.
    tag: js:define-element
    proTip: Tek kada browser dobije živu komponentu, ima smisla da preko nje gradiš
      spoljašnji i unutrašnji CSS sloj.
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
    intent: I kada komponenta već renderuje shadow DOM, host ostaje spoljašnji API i
      zato mora da ostane jasno obeležen.
    tag: css:host-outline
    proTip: I kada komponenta već renderuje shadow DOM, host ostaje spoljašnji API i
      zato mora da ostane jasno obeležen.
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
    summary: Spolja uvodimo surface token koji shadow DOM kasnije povlači kroz
      `var(...)`.
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
    summary: Accent token će obojiti badge i CTA unutar shadow DOM-a.
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
    title: "JS: template / :host / font-family"
    summary: "Počinje unutrašnji template CSS: host dobija isti font stack kao i
      ostatak scene."
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:host-font
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: &a3
      - <my-first-component
      - slot="eyebrow"
  - stepId: host-color
    title: "JS: template / :host / color"
    summary: Host odmah koristi spoljašnji text token, pa vidiš kako custom property
      prolazi kroz granicu shadow DOM-a.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:host-color
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a3
  - stepId: card-outline
    title: "JS: template / .card / outline"
    summary: Dodajemo helper outline za glavni card blok i držimo ga do završnog
      card rezimea.
    intent: Glavni card outline ostaje dok ne završimo celu unutrašnju celinu.
    tag: js-style:card-outline
    proTip: Glavni card outline ostaje dok ne završimo celu unutrašnju celinu.
    focusHtmlNeedles: &a4
      - <my-first-component
      - slot="eyebrow"
  - stepId: card-display
    title: "JS: template / .card / display"
    summary: Card raspored uvodimo grid-om jer imamo vertikalnu stack strukturu.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:card-display
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a4
  - stepId: card-gap
    title: "JS: template / .card / gap"
    summary: Gap odvaja badge, naslov, opis i CTA.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:card-gap
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a4
  - stepId: card-padding
    title: "JS: template / .card / padding"
    summary: Padding pravi pravi card footprint unutar shadow DOM-a.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:card-padding
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a4
  - stepId: card-radius
    title: "JS: template / .card / border-radius"
    summary: Zaobljenje daje modernu card siluetu.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:card-radius
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a4
  - stepId: card-border
    title: "JS: template / .card / border"
    summary: Ivica koristi host token, pa spoljašnji CSS zaista utiče na unutrašnji
      card.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:card-border
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a4
  - stepId: card-background
    title: "JS: template / .card / background"
    summary: Tamna pozadina sada čita oba surface tokena direktno sa host elementa.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:card-background
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a4
  - stepId: card-shadow
    title: "JS: template / .card / box-shadow"
    summary: Shadow sada takođe čita spoljašnji token, pa i dubina komponente
      postaje deo API-ja.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:card-shadow
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a4
  - stepId: eyebrow-outline
    title: "JS: template / .eyebrow / outline"
    summary: Dodajemo helper outline za eyebrow badge i držimo ga do završnog
      eyebrow rezimea.
    intent: Badge je mali element i zato mu outline posebno pomaže tokom objašnjenja.
    tag: js-style:eyebrow-outline
    proTip: Badge je mali element i zato mu outline posebno pomaže tokom objašnjenja.
    focusHtmlNeedles: &a5
      - slot="eyebrow"
      - <my-first-component
  - stepId: eyebrow-display
    title: "JS: template / .eyebrow / display"
    summary: Badge ostaje kompakatan i prirodno prati svoj sadržaj.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:eyebrow-display
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-align-items
    title: "JS: template / .eyebrow / align-items"
    summary: Vertikalno centriramo sadržaj badge-a da kapsula izgleda urednije.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:eyebrow-align-items
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-justify-content
    title: "JS: template / .eyebrow / justify-content"
    summary: Tekst badge-a ostaje simetrično centriran i kada se sadržaj menja.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:eyebrow-justify-content
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-width
    title: "JS: template / .eyebrow / width"
    summary: Badge širinu vežemo isključivo za sadržaj, ne za širinu roditelja.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:eyebrow-width
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-padding
    title: "JS: template / .eyebrow / padding"
    summary: Padding daje badge-u jasan pill footprint.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:eyebrow-padding
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-radius
    title: "JS: template / .eyebrow / border-radius"
    summary: Veliki radius zatvara badge u kapsulu.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:eyebrow-radius
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-background
    title: "JS: template / .eyebrow / background"
    summary: Poluprovidna pozadina pravi nežan badge signal.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:eyebrow-background
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-color
    title: "JS: template / .eyebrow / color"
    summary: Boju badge-a takođe vežemo za host accent token.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:eyebrow-color
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-font-size
    title: "JS: template / .eyebrow / font-size"
    summary: Manji font čini badge sekundarnim, ali čitljivim.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:eyebrow-font-size
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-font-weight
    title: "JS: template / .eyebrow / font-weight"
    summary: Težina fonta čini badge labelu kompaktnom i jasnom.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:eyebrow-font-weight
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-letter-spacing
    title: "JS: template / .eyebrow / letter-spacing"
    summary: Mali tracking daje badge-u uredniji, label-like karakter.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:eyebrow-letter-spacing
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a5
  - stepId: eyebrow-text-transform
    title: "JS: template / .eyebrow / text-transform"
    summary: Uppercase zatvara eyebrow kao jasnu oznaku kategorije.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:eyebrow-text-transform
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a5
  - stepId: title-display
    title: "JS: template / .title / display"
    summary: Naslovu dajemo sopstveni red da ne deli liniju sa drugim delovima.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:title-display
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: &a6
      - <my-first-component
  - stepId: title-margin
    title: "JS: template / .title / margin"
    summary: Pošto prelazimo na semantički `h2`, prvo gasimo podrazumevani margin.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:title-margin
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a6
  - stepId: title-font-size
    title: "JS: template / .title / font-size"
    summary: Naslov dobija responzivniju veličinu, bližu finalnom polished utisku.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:title-font-size
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a6
  - stepId: title-line-height
    title: "JS: template / .title / line-height"
    summary: Kraći line-height drži naslov zategnutim i čitljivim.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:title-line-height
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a6
  - stepId: title-font-weight
    title: "JS: template / .title / font-weight"
    summary: Pojačavamo naslov da odmah nosi hijerarhiju.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:title-font-weight
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a6
  - stepId: summary-margin
    title: "JS: template / .summary / margin"
    summary: Brišemo podrazumevani paragraf margin da spacing kontrolišemo iz card
      gap-a.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:summary-margin
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: &a7
      - <my-first-component
  - stepId: summary-color
    title: "JS: template / .summary / color"
    summary: Opis dobija muted token, pa i sekundarni tekst postaje deo spoljašnjeg
      theme API-ja.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:summary-color
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a7
  - stepId: summary-line-height
    title: "JS: template / .summary / line-height"
    summary: Line-height otvara tekst i čini ga lakšim za čitanje.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:summary-line-height
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a7
  - stepId: cta-outline
    title: "JS: template / .cta / outline"
    summary: Dodajemo helper outline za CTA i držimo ga do završnog CTA rezimea.
    intent: CTA outline ostaje dok ne zaključimo poslednju interaktivnu zonu.
    tag: js-style:cta-outline
    proTip: CTA outline ostaje dok ne zaključimo poslednju interaktivnu zonu.
    focusHtmlNeedles: &a8
      - <my-first-component
  - stepId: cta-justify-self
    title: "JS: template / .cta / justify-self"
    summary: CTA ostaje uz levu ivicu card sadržaja umesto da se rasteže.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-justify-self
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a8
  - stepId: cta-appearance
    title: "JS: template / .cta / appearance"
    summary: Gasimo browser-native izgled dugmeta da komponenta zadrži konzistentan
      cross-browser izgled.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-appearance
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a8
  - stepId: cta-padding
    title: "JS: template / .cta / padding"
    summary: Padding daje dugmetu njegovu klik zonu.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-padding
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a8
  - stepId: cta-border
    title: "JS: template / .cta / border"
    summary: Uklanjamo podrazumevanu border liniju dugmeta.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-border
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a8
  - stepId: cta-radius
    title: "JS: template / .cta / border-radius"
    summary: Pil radius drži CTA vizuelno bliskim badge logici.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-radius
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a8
  - stepId: cta-background
    title: "JS: template / .cta / background"
    summary: CTA sada koristi i jači accent token za dublji, kontrolisan gradijent.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-background
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a8
  - stepId: cta-color
    title: "JS: template / .cta / color"
    summary: Beli tekst drži jasan kontrast preko gradijenta.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-color
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a8
  - stepId: cta-font
    title: "JS: template / .cta / font"
    summary: Dugme preuzima isti font vocabulary kao i ostatak komponente.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-font
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a8
  - stepId: cta-font-weight
    title: "JS: template / .cta / font-weight"
    summary: Težina fonta zatvara CTA kao jasan action element.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-font-weight
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a8
  - stepId: cta-cursor
    title: "JS: template / .cta / cursor"
    summary: Kursor eksplicitno potvrđuje interaktivnost CTA dugmeta.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-cursor
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a8
  - stepId: cta-transition
    title: "JS: template / .cta / transition"
    summary: Dodajemo finu tranziciju da hover i focus states ne deluju grubo.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-transition
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a8
  - stepId: cta-box-shadow
    title: "JS: template / .cta / box-shadow"
    summary: Mali shadow pojačava CTA kao završni action sloj.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-box-shadow
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a8
  - stepId: cta-hover-filter
    title: "JS: template / .cta:hover / filter"
    summary: Hover blago podiže svetlinu CTA dugmeta bez agresivne promene boje.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-hover-filter
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: &a9
      - <my-first-component
  - stepId: cta-hover-transform
    title: "JS: template / .cta:hover / transform"
    summary: Minimalni lift daje osećaj da dugme odgovara na hover.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-hover-transform
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a9
  - stepId: cta-active-transform
    title: "JS: template / .cta:active / transform"
    summary: Na active vraćamo dugme nazad, da klik ima malu fizičku povratnu
      informaciju.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-active-transform
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles:
      - <my-first-component
  - stepId: cta-focus-outline
    title: "JS: template / .cta:focus-visible / outline"
    summary: Focus-visible dodaje jasan tastaturski focus ring bez oslanjanja na
      browser default.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-focus-outline
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: &a10
      - <my-first-component
  - stepId: cta-focus-outline-offset
    title: "JS: template / .cta:focus-visible / outline-offset"
    summary: Offset odvaja focus ring od same pil ivice dugmeta.
    intent: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    tag: js-style:cta-focus-outline-offset
    proTip: Kod Web Components lekcije i stilovi unutar shadow DOM-a moraju da rastu
      postepeno, ne kao gotov paket.
    focusHtmlNeedles: *a10
  - stepId: card-summary
    title: "Rezime: .card unutar template-a"
    summary: Rezimiramo glavni card blok i tek sada uklanjamo njegov helper outline,
      jer je unutrašnja struktura komponente već potpuno jasna.
    intent: Helper outline za glavni card ostaje dok i markup i stil i ponašanje ne
      budu dovoljno čitljivi.
    tag: summary:card-summary
    proTip: Helper outline za glavni card ostaje dok i markup i stil i ponašanje ne
      budu dovoljno čitljivi.
    focusHtmlNeedles: *a1
  - stepId: eyebrow-summary
    title: "Rezime: .eyebrow unutar template-a"
    summary: Rezimiramo eyebrow badge i uklanjamo njegov helper outline tek sada,
      kada slot projekcija i badge stil rade zajedno.
    intent: Slot je ovde važan deo lekcije, pa helper outline ostaje dok named slot
      ne postane jasan.
    tag: summary:eyebrow-summary
    proTip: Slot je ovde važan deo lekcije, pa helper outline ostaje dok named slot
      ne postane jasan.
    focusHtmlNeedles: *a1
  - stepId: cta-summary
    title: "Rezime: .cta unutar template-a"
    summary: "Rezime za CTA dugme: helper outline više nije potreban, jer završni
      stil, event i hover/focus ponašanje već jasno pokazuju njegovu ulogu."
    intent: Outline služi učenju; kad je element potpuno objašnjen, može da nestane.
    tag: summary:cta-summary
    proTip: Outline služi učenju; kad je element potpuno objašnjen, može da nestane.
    focusHtmlNeedles: *a1
  - stepId: host-summary
    title: "Rezime: my-first-component host"
    summary: "Završni host rezime: spoljašnji outline host elementa više nije
      potreban, jer su API atributi, theme tokeni i safe registration sada
      jasni."
    intent: Host outline ostaje dok ne pokažemo i spoljašnji API i unutrašnju
      implementaciju komponente.
    tag: summary:host-summary
    proTip: Host outline ostaje dok ne pokažemo i spoljašnji API i unutrašnju
      implementaciju komponente.
    focusHtmlNeedles: *a1
  - stepId: shell-summary
    title: "Rezime: .app-shell"
    summary: Tek sada uklanjamo helper outline sa `.app-shell`, jer je cela Web
      Components lekcija kompletna i okvir više nije potreban.
    intent: App shell outline ostaje sve vreme kao teaching okvir i nestaje tek na
      samom kraju lekcije.
    tag: summary:shell-summary
    proTip: App shell outline ostaje sve vreme kao teaching okvir i nestaje tek na
      samom kraju lekcije.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: done
    title: "Done: My First Component Web Component"
    summary: "Lekcija je završena: od praznog shell-a stigli smo do pravog custom
      elementa sa host atributima, slotovima, shadow DOM-om, render
      lifecycle-om, cleanup-om, sigurnom registracijom, izlaznim event-om i
      interaction polish slojem."
    intent: Sledeći logičan korak je da napraviš drugu komponentu sa više slotova,
      `part`/`exportparts` strategijom ili još bogatijim public API-jem.
    tag: success
    proTip: Sledeći logičan korak je da napraviš drugu komponentu sa više slotova,
      `part`/`exportparts` strategijom ili još bogatijim public API-jem.
    focusHtmlNeedles: []
---

# Step: empty-shell

## Scene: empty-shell-scene

narration:
Počinjemo od praznog `.app-shell` prostora. Goal slika iznad pokazuje finalni Web Component koji tek treba da oživi kroz HTML, CSS i vanilla JavaScript.

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
Dodajemo `<my-first-component>` host sa `title` i `cta-label` atributima. Još nije registrovan, ali browser već vidi custom tag i njegov sirovi sadržaj.

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
U host ubacujemo `<span slot="eyebrow">Vanilla JS</span>`. To je light DOM sadržaj koji će kasnije upasti u named slot unutar shadow DOM-a.

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
Dodajemo opisni tekst kao default slot sadržaj. Pre registracije komponente vidiš ga kao običan sadržaj custom taga; posle registracije odlazi u `<slot>` unutar template-a.

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
Počinjemo sa `document.createElement('template')`. Template nam daje inertan komad DOM-a koji možemo bezbedno da kloniramo u svakoj instanci komponente.

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
Dodajemo `template.innerHTML = \`` i od tog trenutka gradimo ceo shadow DOM sadržaj iz jednog kontrolisanog izvora.

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
Sada ubacujemo unutrašnji markup: card wrapper, named slot za eyebrow, semantički `h2` naslov, paragraf sa default slotom, CTA dugme i `part` atribute za kasniji escape hatch.

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
Unutar guard-a pozivamo `customElements.define('my-first-component', MyFirstComponent)`. Od ovog trenutka browser zna kako da upgrade-uje `<my-first-component>` u pravu komponentu i preview dobija prvi stvarni, još uvek sirovi render.

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
Spolja uvodimo surface token koji shadow DOM kasnije povlači kroz `var(...)`.

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
Accent token će obojiti badge i CTA unutar shadow DOM-a.

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
Počinje unutrašnji template CSS: host dobija isti font stack kao i ostatak scene.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: host-color

## Scene: host-color-scene

narration:
Host odmah koristi spoljašnji text token, pa vidiš kako custom property prolazi kroz granicu shadow DOM-a.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: card-outline

## Scene: card-outline-scene

narration:
Dodajemo helper outline za glavni card blok i držimo ga do završnog card rezimea.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: card-display

## Scene: card-display-scene

narration:
Card raspored uvodimo grid-om jer imamo vertikalnu stack strukturu.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: card-gap

## Scene: card-gap-scene

narration:
Gap odvaja badge, naslov, opis i CTA.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: card-padding

## Scene: card-padding-scene

narration:
Padding pravi pravi card footprint unutar shadow DOM-a.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: card-radius

## Scene: card-radius-scene

narration:
Zaobljenje daje modernu card siluetu.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: card-border

## Scene: card-border-scene

narration:
Ivica koristi host token, pa spoljašnji CSS zaista utiče na unutrašnji card.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: card-background

## Scene: card-background-scene

narration:
Tamna pozadina sada čita oba surface tokena direktno sa host elementa.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: card-shadow

## Scene: card-shadow-scene

narration:
Shadow sada takođe čita spoljašnji token, pa i dubina komponente postaje deo API-ja.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-outline

## Scene: eyebrow-outline-scene

narration:
Dodajemo helper outline za eyebrow badge i držimo ga do završnog eyebrow rezimea.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-display

## Scene: eyebrow-display-scene

narration:
Badge ostaje kompakatan i prirodno prati svoj sadržaj.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-align-items

## Scene: eyebrow-align-items-scene

narration:
Vertikalno centriramo sadržaj badge-a da kapsula izgleda urednije.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-justify-content

## Scene: eyebrow-justify-content-scene

narration:
Tekst badge-a ostaje simetrično centriran i kada se sadržaj menja.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-width

## Scene: eyebrow-width-scene

narration:
Badge širinu vežemo isključivo za sadržaj, ne za širinu roditelja.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-padding

## Scene: eyebrow-padding-scene

narration:
Padding daje badge-u jasan pill footprint.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-radius

## Scene: eyebrow-radius-scene

narration:
Veliki radius zatvara badge u kapsulu.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-background

## Scene: eyebrow-background-scene

narration:
Poluprovidna pozadina pravi nežan badge signal.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-color

## Scene: eyebrow-color-scene

narration:
Boju badge-a takođe vežemo za host accent token.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-font-size

## Scene: eyebrow-font-size-scene

narration:
Manji font čini badge sekundarnim, ali čitljivim.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-font-weight

## Scene: eyebrow-font-weight-scene

narration:
Težina fonta čini badge labelu kompaktnom i jasnom.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-letter-spacing

## Scene: eyebrow-letter-spacing-scene

narration:
Mali tracking daje badge-u uredniji, label-like karakter.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: eyebrow-text-transform

## Scene: eyebrow-text-transform-scene

narration:
Uppercase zatvara eyebrow kao jasnu oznaku kategorije.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: title-display

## Scene: title-display-scene

narration:
Naslovu dajemo sopstveni red da ne deli liniju sa drugim delovima.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: title-margin

## Scene: title-margin-scene

narration:
Pošto prelazimo na semantički `h2`, prvo gasimo podrazumevani margin.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: title-font-size

## Scene: title-font-size-scene

narration:
Naslov dobija responzivniju veličinu, bližu finalnom polished utisku.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: title-line-height

## Scene: title-line-height-scene

narration:
Kraći line-height drži naslov zategnutim i čitljivim.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: title-font-weight

## Scene: title-font-weight-scene

narration:
Pojačavamo naslov da odmah nosi hijerarhiju.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: summary-margin

## Scene: summary-margin-scene

narration:
Brišemo podrazumevani paragraf margin da spacing kontrolišemo iz card gap-a.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: summary-color

## Scene: summary-color-scene

narration:
Opis dobija muted token, pa i sekundarni tekst postaje deo spoljašnjeg theme API-ja.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: summary-line-height

## Scene: summary-line-height-scene

narration:
Line-height otvara tekst i čini ga lakšim za čitanje.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-outline

## Scene: cta-outline-scene

narration:
Dodajemo helper outline za CTA i držimo ga do završnog CTA rezimea.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-justify-self

## Scene: cta-justify-self-scene

narration:
CTA ostaje uz levu ivicu card sadržaja umesto da se rasteže.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-appearance

## Scene: cta-appearance-scene

narration:
Gasimo browser-native izgled dugmeta da komponenta zadrži konzistentan cross-browser izgled.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-padding

## Scene: cta-padding-scene

narration:
Padding daje dugmetu njegovu klik zonu.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-border

## Scene: cta-border-scene

narration:
Uklanjamo podrazumevanu border liniju dugmeta.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-radius

## Scene: cta-radius-scene

narration:
Pil radius drži CTA vizuelno bliskim badge logici.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-background

## Scene: cta-background-scene

narration:
CTA sada koristi i jači accent token za dublji, kontrolisan gradijent.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-color

## Scene: cta-color-scene

narration:
Beli tekst drži jasan kontrast preko gradijenta.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-font

## Scene: cta-font-scene

narration:
Dugme preuzima isti font vocabulary kao i ostatak komponente.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-font-weight

## Scene: cta-font-weight-scene

narration:
Težina fonta zatvara CTA kao jasan action element.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-cursor

## Scene: cta-cursor-scene

narration:
Kursor eksplicitno potvrđuje interaktivnost CTA dugmeta.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-transition

## Scene: cta-transition-scene

narration:
Dodajemo finu tranziciju da hover i focus states ne deluju grubo.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-box-shadow

## Scene: cta-box-shadow-scene

narration:
Mali shadow pojačava CTA kao završni action sloj.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-hover-filter

## Scene: cta-hover-filter-scene

narration:
Hover blago podiže svetlinu CTA dugmeta bez agresivne promene boje.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-hover-transform

## Scene: cta-hover-transform-scene

narration:
Minimalni lift daje osećaj da dugme odgovara na hover.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-active-transform

## Scene: cta-active-transform-scene

narration:
Na active vraćamo dugme nazad, da klik ima malu fizičku povratnu informaciju.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-focus-outline

## Scene: cta-focus-outline-scene

narration:
Focus-visible dodaje jasan tastaturski focus ring bez oslanjanja na browser default.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cta-focus-outline-offset

## Scene: cta-focus-outline-offset-scene

narration:
Offset odvaja focus ring od same pil ivice dugmeta.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: card-summary

## Scene: card-summary-scene

narration:
Rezimiramo glavni card blok i tek sada uklanjamo njegov helper outline, jer je unutrašnja struktura komponente već potpuno jasna.

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
Rezimiramo eyebrow badge i uklanjamo njegov helper outline tek sada, kada slot projekcija i badge stil rade zajedno.

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
Rezime za CTA dugme: helper outline više nije potreban, jer završni stil, event i hover/focus ponašanje već jasno pokazuju njegovu ulogu.

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
Završni host rezime: spoljašnji outline host elementa više nije potreban, jer su API atributi, theme tokeni i safe registration sada jasni.

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
Tek sada uklanjamo helper outline sa `.app-shell`, jer je cela Web Components lekcija kompletna i okvir više nije potreban.

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
Lekcija je završena: od praznog shell-a stigli smo do pravog custom elementa sa host atributima, slotovima, shadow DOM-om, render lifecycle-om, cleanup-om, sigurnom registracijom, izlaznim event-om i interaction polish slojem.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom
