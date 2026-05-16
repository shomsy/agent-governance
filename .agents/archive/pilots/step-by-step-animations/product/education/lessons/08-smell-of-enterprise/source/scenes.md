---
schemaVersion: 1
lessonId: 08-smell-of-enterprise
steps:
  - stepId: empty-shell
    title: "Start: Empty App Shell"
    summary: Počinjemo od praznog `.app-shell`. SaaS pricing kartica živi u
      neutralnom host okruženju.
    intent: Pricing table komponenta radi u bilo kom kontekstu — landing page,
      modal, dashboard.
    tag: html:app-shell
    proTip: Pricing table komponenta radi u bilo kom kontekstu — landing page,
      modal, dashboard.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: component-html
    title: "HTML: ui-pricing-card Host"
    summary: Dodajemo `<ui-pricing-card>` sa `tier="pro"`, `price-monthly="29"` i
      `price-yearly="290"`. Tag odmah kaže šta widget radi.
    intent: "Domain-driven naming: ime taga govori business use case, ne tehničku
      implementaciju."
    tag: html:ui-pricing-card
    proTip: "Domain-driven naming: ime taga govori business use case, ne tehničku
      implementaciju."
    focusHtmlNeedles: []
  - stepId: popular-attribute-html
    title: "HTML: popular Boolean Attribute"
    summary: Dodajemo `popular` atribut. Njegova prisutnost znači da je ova kartica
      istaknuta — nema vrednosti, samo postoji ili ne postoji.
    intent: "Boolean atribut je najčistiji deklarativni state signal: prisutnost =
      true, odsustvo = false."
    tag: html:popular
    proTip: "Boolean atribut je najčistiji deklarativni state signal: prisutnost =
      true, odsustvo = false."
    focusHtmlNeedles: []
  - stepId: cta-label-attribute-html
    title: "HTML: cta-label Attribute"
    summary: Dodajemo `cta-label="Start free trial"`. CTA tekst je deo javnog
      contract-a, ne hardkodovan u shadow DOM-u.
    intent: Svaki tekst koji parent može da želi da promeni mora biti atribut, ne
      interni string.
    tag: html:cta-label
    proTip: Svaki tekst koji parent može da želi da promeni mora biti atribut, ne
      interni string.
    focusHtmlNeedles: []
  - stepId: badge-slot-html
    title: "HTML: Named Slot — badge"
    summary: Dodajemo `<span slot="badge">⭐ Most Popular</span>`. Parent kontroliše
      badge sadržaj.
    intent: Named slot daje parent-u slobodu da pošalje emoji, tekst, ili čak custom
      HTML za badge.
    tag: html:slot-badge
    proTip: Named slot daje parent-u slobodu da pošalje emoji, tekst, ili čak custom
      HTML za badge.
    focusHtmlNeedles: []
  - stepId: features-slot-html
    title: "HTML: Named Slot — features"
    summary: Dodajemo `<ul slot="features">` sa pet feature stavki. Feature matrix
      je javna powierzchina.
    intent: Feature lista kao slot znači da svaki tier može imati drugačije stavke
      bez promene komponente.
    tag: html:slot-features
    proTip: Feature lista kao slot znači da svaki tier može imati drugačije stavke
      bez promene komponente.
    focusHtmlNeedles: []
  - stepId: pricing-widget-contract
    title: "Teaching Moment: SaaS Pricing Contract"
    summary: "Widget ima šest atributa: `tier`, `price-monthly`, `price-yearly`,
      `billing`, `popular`, `cta-label`. Ima dva named slota: `badge` i
      `features`. Emituje jedan namespaced event: `ui-pricing-card:subscribe`.
      Urgency timer je interni lifecycle detalj."
    intent: "SaaS pricing widget API treba da budi uzan: parent zna cenu i tier,
      widget zna visual i behavior."
    tag: teaching:pricing-widget-contract
    proTip: "SaaS pricing widget API treba da budi uzan: parent zna cenu i tier,
      widget zna visual i behavior."
    focusHtmlNeedles:
      - <ui-pricing-card
      - tier=
  - stepId: template-html-declaration
    title: "Template JS: Shadow DOM struktura"
    summary: "U `ui-pricing-card.template.js` definišemo `templateHtml`: card sa
      badge, tier-name, price-block (currency/amount/period), billing-toggle sa
      knob switch-em, feature-list slot, CTA dugme i urgency timer zona."
    intent: Template fajl drži kompletnu shadow strukturu. Klasa ga samo klonira —
      nikad ne rekreira.
    tag: template-js:template-html-declaration
    proTip: Template fajl drži kompletnu shadow strukturu. Klasa ga samo klonira —
      nikad ne rekreira.
    focusHtmlNeedles: &a1
      - <ui-pricing-card
      - tier=
  - stepId: template-element-export
    title: "Template JS: Eksportujemo template element"
    summary: Kreiramo `uiPricingCardTemplate`, dodajemo `<link>` ka shadow CSS fajlu
      i ubrizgavamo `${templateHtml}`.
    intent: Template modul zna za markup i stylesheet. Klasa uopšte ne zna kako
      izgleda HTML.
    tag: template-js:template-element-export
    proTip: Template modul zna za markup i stylesheet. Klasa uopšte ne zna kako
      izgleda HTML.
    focusHtmlNeedles: *a1
  - stepId: import-template
    title: "JS: Uvozimo template modul"
    summary: Behavior fajl uvozi `uiPricingCardTemplate` iz template modula.
    intent: Klasa i template su u odvojenim fajlovima sa odvojenim odgovornostima.
    tag: js:import-template
    proTip: Klasa i template su u odvojenim fajlovima sa odvojenim odgovornostima.
    focusHtmlNeedles: *a1
  - stepId: normalize-text-helper
    title: "JS: normalizeTextValue() helper"
    summary: Dodajemo `normalizeTextValue()` za tekst normalizaciju sa fallback-om.
    intent: Enterprise API normalizuje ulaz na granici, ne unutar poslovne logike.
    tag: js:normalize-text-helper
    proTip: Enterprise API normalizuje ulaz na granici, ne unutar poslovne logike.
    focusHtmlNeedles: *a1
  - stepId: allowed-tiers-set
    title: "JS: allowedTiers Set"
    summary: "Zaključavamo dozvoljene tier vrednosti: `starter`, `pro`, `enterprise`."
    intent: Otvoreni string za tier koji utiče na pricing i styling je neprihvatljiv
      rizik.
    tag: js:allowed-tiers-set
    proTip: Otvoreni string za tier koji utiče na pricing i styling je neprihvatljiv
      rizik.
    focusHtmlNeedles: *a1
  - stepId: normalize-tier-helper
    title: "JS: normalizeTierValue() helper"
    summary: Nepoznat tier automatski pada na `starter`.
    intent: Fallback je deo contract-a. Komponenta ne padne na pogresan tier string.
    tag: js:normalize-tier-helper
    proTip: Fallback je deo contract-a. Komponenta ne padne na pogresan tier string.
    focusHtmlNeedles: *a1
  - stepId: parse-price-helper
    title: "JS: parsePriceValue() helper"
    summary: Dodajemo `parsePriceValue()` koji parira cenu u broj i vraća 0 za
      nevalidan ulaz.
    intent: Cena se prikazuje korisnicima — mora biti sigurna od NaN-a i negativnih
      vrednosti.
    tag: js:parse-price-helper
    proTip: Cena se prikazuje korisnicima — mora biti sigurna od NaN-a i negativnih
      vrednosti.
    focusHtmlNeedles: *a1
  - stepId: format-time-helper
    title: "JS: formatTimeRemaining() helper"
    summary: Dodajemo `formatTimeRemaining()` koji formatira sekunde u `HH:MM:SS`
      string za urgency timer.
    intent: Timer format je odvojenom helperu — lako se testira i zameni.
    tag: js:format-time-helper
    proTip: Timer format je odvojenom helperu — lako se testira i zameni.
    focusHtmlNeedles: *a1
  - stepId: tier-display-map
    title: "JS: tierDisplayName mapa"
    summary: Dodajemo mapu tier → display name. UI labela ne sme da bude isti string
      kao API vrednost.
    intent: API koristi lowercase slug, UI prikazuje capitalized ime — mapa ih
      razdvaja.
    tag: js:tier-display-map
    proTip: API koristi lowercase slug, UI prikazuje capitalized ime — mapa ih
      razdvaja.
    focusHtmlNeedles: *a1
  - stepId: class-declaration
    title: "JS: UiPricingCard extends HTMLElement"
    summary: Klasa nosi domain-driven ime konzistentno sa tagom.
    intent: "`ui-pricing-card` → `UiPricingCard`. Tag i class govore istu priču."
    tag: js:class-declaration
    proTip: "`ui-pricing-card` → `UiPricingCard`. Tag i class govore istu priču."
    focusHtmlNeedles: *a1
  - stepId: observed-attributes
    title: "JS: observedAttributes — svih šest"
    summary: Komponenta prati `tier`, `price-monthly`, `price-yearly`, `billing`,
      `popular` i `cta-label`.
    intent: Pratimo tačno onoliko atributa koliko je definisano kao javni API.
    tag: js:observed-attributes
    proTip: Pratimo tačno onoliko atributa koliko je definisano kao javni API.
    focusHtmlNeedles: *a1
  - stepId: constructor-shadow
    title: "JS: constructor otvara shadow root"
    summary: "Konstruktor samo priprema instancu: shadow root, bind-ove i nulte
      reference."
    intent: Konstruktor ne radi lifecycle posao niti čita DOM.
    tag: js:constructor-shadow
    proTip: Konstruktor ne radi lifecycle posao niti čita DOM.
    focusHtmlNeedles: *a1
  - stepId: constructor-bind
    title: "JS: constructor pre-binduje handlere"
    summary: Vezujemo `handleCtaClick` i `handleToggleClick` jednom pri kreiranju
      instance.
    intent: Dva handlera, dva pre-bind-a — stabilan cleanup je zagarantovan.
    tag: js:constructor-bind
    proTip: Dva handlera, dva pre-bind-a — stabilan cleanup je zagarantovan.
    focusHtmlNeedles: *a1
  - stepId: constructor-state
    title: "JS: constructor priprema interne reference"
    summary: Nulujemo DOM reference, binding flagove, timer ID i urgency preostalo
      vreme.
    intent: Interno stanje je transparentno od prvog reda. Timer state je deo
      instanace.
    tag: js:constructor-state
    proTip: Interno stanje je transparentno od prvog reda. Timer state je deo
      instanace.
    focusHtmlNeedles: *a1
  - stepId: connected-callback
    title: "JS: connectedCallback — lifecycle ulaz"
    summary: Connected lifecycle je glavni ulaz kada pricing kartica uđe u DOM.
    intent: Sve što zavisi od živog DOM-a ide u connectedCallback.
    tag: js:connected-callback
    proTip: Sve što zavisi od živog DOM-a ide u connectedCallback.
    focusHtmlNeedles: *a1
  - stepId: connected-callback-setup
    title: "JS: connectedCallback poziva setupTemplateOnce"
    summary: Montiramo template u shadow root jednom.
    intent: Mount i cache imaju odvojene metode.
    tag: js:connected-callback-setup
    proTip: Mount i cache imaju odvojene metode.
    focusHtmlNeedles: *a1
  - stepId: connected-callback-cache
    title: "JS: connectedCallback poziva cacheDom"
    summary: Keširamo pet DOM referenci.
    intent: Query radimo jednom. Update metode rade nad keširanima.
    tag: js:connected-callback-cache
    proTip: Query radimo jednom. Update metode rade nad keširanima.
    focusHtmlNeedles: *a1
  - stepId: connected-callback-sync
    title: "JS: connectedCallback sinhronizuje atribute"
    summary: Pozivamo `syncFromAttributes()` za inicijalni render pass.
    intent: Četiri uske update metode inicijalizuju tačno ono što treba.
    tag: js:connected-callback-sync
    proTip: Četiri uske update metode inicijalizuju tačno ono što treba.
    focusHtmlNeedles: *a1
  - stepId: connected-callback-bind
    title: "JS: connectedCallback zakačuje evente"
    summary: Vezujemo CTA i toggle click listenere.
    intent: Event wiring je poslednji korak — DOM mora biti spreman.
    tag: js:connected-callback-bind
    proTip: Event wiring je poslednji korak — DOM mora biti spreman.
    focusHtmlNeedles: *a1
  - stepId: connected-callback-urgency
    title: "JS: connectedCallback pokreće urgency timer"
    summary: Pozivamo `startUrgencyTimer()` koji pokreće interval sa countdown-om od 1h.
    intent: Timer je deo lifecycle-a — start na connect, stop na disconnect.
    tag: js:connected-callback-urgency
    proTip: Timer je deo lifecycle-a — start na connect, stop na disconnect.
    focusHtmlNeedles: *a1
  - stepId: disconnected-callback
    title: "JS: disconnectedCallback — čisti sve"
    summary: Na izlazu iz DOM-a skidamo evente i zaustavljamo urgency timer.
    intent: Nema leaking intervala ni event listener-a — čist disconnect.
    tag: js:disconnected-callback
    proTip: Nema leaking intervala ni event listener-a — čist disconnect.
    focusHtmlNeedles: *a1
  - stepId: attribute-changed-callback
    title: "JS: precizan attributeChangedCallback"
    summary: Potpis prima `name`, `oldValue` i `newValue` za granularni update.
    intent: Preciznost omogućava da menjamo samo tu jednu stvar koja se zaista
      promenila.
    tag: js:attribute-changed-callback
    proTip: Preciznost omogućava da menjamo samo tu jednu stvar koja se zaista
      promenila.
    focusHtmlNeedles: *a1
  - stepId: attribute-changed-guard
    title: "JS: guard za iste vrednosti i disconnected stanje"
    summary: Odmah izlazimo ako se vrednost nije promenila ili widget nije u DOM-u.
    intent: Enterprise update path ne troši resurse bespotrebno.
    tag: js:attribute-changed-guard
    proTip: Enterprise update path ne troši resurse bespotrebno.
    focusHtmlNeedles: *a1
  - stepId: attribute-changed-switch
    title: "JS: switch — precizan update po atributu"
    summary: Tier menja labelu, price/billing/yearly menjaju prikazanu cenu i
      toggle, cta-label menja dugme.
    intent: Svaki atribut ima svoju granu — nema slepog full render-a.
    tag: js:attribute-changed-switch
    proTip: Svaki atribut ima svoju granu — nema slepog full render-a.
    focusHtmlNeedles: *a1
  - stepId: property-tier-getter
    title: "JS: tier getter"
    summary: Getter vraća normalizovani tier sa fallback-om na `starter`.
    intent: Property API otvara JS pristup pored HTML contract-a.
    tag: js:property-tier-getter
    proTip: Property API otvara JS pristup pored HTML contract-a.
    focusHtmlNeedles: *a1
  - stepId: property-tier-setter
    title: "JS: tier setter"
    summary: Setter normalizuje i piše nazad u atribut.
    intent: Source of truth ostaje na atributu.
    tag: js:property-tier-setter
    proTip: Source of truth ostaje na atributu.
    focusHtmlNeedles: *a1
  - stepId: property-price-monthly-getter
    title: "JS: priceMonthly getter"
    summary: Getter parsira mesečnu cenu u bezbedan broj.
    intent: Nikad ne vraćamo NaN ili negativan broj korisniku.
    tag: js:property-price-monthly-getter
    proTip: Nikad ne vraćamo NaN ili negativan broj korisniku.
    focusHtmlNeedles: *a1
  - stepId: property-price-yearly-getter
    title: "JS: priceYearly getter"
    summary: Getter parsira godišnju cenu na isti način.
    intent: Oba pricing getter-a koriste istu `parsePriceValue()` logiku.
    tag: js:property-price-yearly-getter
    proTip: Oba pricing getter-a koriste istu `parsePriceValue()` logiku.
    focusHtmlNeedles: *a1
  - stepId: property-billing-getter
    title: "JS: billing getter"
    summary: Getter vraća `monthly` ili `yearly` — samo dve opcije.
    intent: Binary state ne treba Set. Simple conditional je dovoljno.
    tag: js:property-billing-getter
    proTip: Binary state ne treba Set. Simple conditional je dovoljno.
    focusHtmlNeedles: *a1
  - stepId: property-billing-setter
    title: "JS: billing setter"
    summary: Setter piše normalizovani billing nazad u atribut.
    intent: Toggle menja atribut → attributeChangedCallback → updatePrice() +
      updateToggleState(). Jednosmerni tok.
    tag: js:property-billing-setter
    proTip: Toggle menja atribut → attributeChangedCallback → updatePrice() +
      updateToggleState(). Jednosmerni tok.
    focusHtmlNeedles: *a1
  - stepId: property-popular-getter
    title: "JS: popular getter"
    summary: Boolean getter čita hasAttribute.
    intent: "Boolean atribut: prisutnost = true, odsustvo = false."
    tag: js:property-popular-getter
    proTip: "Boolean atribut: prisutnost = true, odsustvo = false."
    focusHtmlNeedles: *a1
  - stepId: property-cta-label-getter
    title: "JS: ctaLabel getter"
    summary: Getter vraća normalizovan CTA tekst sa fallback-om.
    intent: Fallback osigurava da dugme nikad ne bude prazno.
    tag: js:property-cta-label-getter
    proTip: Fallback osigurava da dugme nikad ne bude prazno.
    focusHtmlNeedles: *a1
  - stepId: setup-template-once
    title: "JS: setupTemplateOnce()"
    summary: Template mount za reusable kloniranje.
    intent: Mount se dešava jednom. Reconnect ne remontira.
    tag: js:setup-template-once
    proTip: Mount se dešava jednom. Reconnect ne remontira.
    focusHtmlNeedles: *a1
  - stepId: setup-template-once-guard
    title: "JS: guard sprečava dupliranje"
    summary: Kloniramo template samo ako shadow root nema dece.
    intent: Reconnect mora biti boring. Bez dupliranja DOM-a.
    tag: js:setup-template-once-guard
    proTip: Reconnect mora biti boring. Bez dupliranja DOM-a.
    focusHtmlNeedles: *a1
  - stepId: cache-dom
    title: "JS: cacheDom — samo kešira reference"
    summary: Querijemo šest internih elemenata i čuvamo na instanci.
    intent: Cache znači pamti, ne gradi. Ime i ponašanje su usklađeni.
    tag: js:cache-dom
    proTip: Cache znači pamti, ne gradi. Ime i ponašanje su usklađeni.
    focusHtmlNeedles: *a1
  - stepId: cache-dom-tier-name
    title: "JS: cacheDom kešira .tier-name"
    summary: Tier name span čuvamo za updateTierName.
    intent: DOM query jednom, updates bez novog querySelector-a.
    tag: js:cache-dom-tier-name
    proTip: DOM query jednom, updates bez novog querySelector-a.
    focusHtmlNeedles: *a1
  - stepId: cache-dom-price-amount
    title: "JS: cacheDom kešira .price-amount"
    summary: Price amount element čuvamo za dinamičko menjanje cene.
    intent: Cena se menja na toggle klik — keš ubrzava taj update.
    tag: js:cache-dom-price-amount
    proTip: Cena se menja na toggle klik — keš ubrzava taj update.
    focusHtmlNeedles: *a1
  - stepId: cache-dom-price-period
    title: "JS: cacheDom kešira .price-period"
    summary: Price period span čuvamo za dinamičko menjanje tekstualne labele (/mo
      ili /yr).
    intent: Vizuelni tekst perioda mora pratiti iznos cene.
    tag: js:cache-dom-price-period
    proTip: Vizuelni tekst perioda mora pratiti iznos cene.
    focusHtmlNeedles: *a1
  - stepId: cache-dom-cta
    title: "JS: cacheDom kešira .cta"
    summary: CTA dugme čuvamo za tekst i event binding.
    intent: "Jedno dugme, dva posla: tekst update i event listener."
    tag: js:cache-dom-cta
    proTip: "Jedno dugme, dva posla: tekst update i event listener."
    focusHtmlNeedles: *a1
  - stepId: cache-dom-toggle
    title: "JS: cacheDom kešira .toggle-switch"
    summary: Toggle switch čuvamo za aria-checked i event.
    intent: Toggle je interaktivni element sa sopstvenim listenerom.
    tag: js:cache-dom-toggle
    proTip: Toggle je interaktivni element sa sopstvenim listenerom.
    focusHtmlNeedles: *a1
  - stepId: cache-dom-urgency
    title: "JS: cacheDom kešira .urgency-text"
    summary: Urgency text element čuvamo za timer update.
    intent: Timer menja ovaj element svake sekunde — keš je obavezan.
    tag: js:cache-dom-urgency
    proTip: Timer menja ovaj element svake sekunde — keš je obavezan.
    focusHtmlNeedles: *a1
  - stepId: sync-from-attributes
    title: "JS: syncFromAttributes()"
    summary: Centralna one-time inicijalizacija DOM-a iz atributa.
    intent: Četiri uske update metode inicijalizuju sve vidljive zone.
    tag: js:sync-from-attributes
    proTip: Četiri uske update metode inicijalizuju sve vidljive zone.
    focusHtmlNeedles: *a1
  - stepId: sync-from-attributes-calls
    title: "JS: sync poziva četiri update metode"
    summary: Pozivamo `updateTierName()`, `updatePrice()`, `updateToggleState()` i
      `updateCtaLabel()`.
    intent: Svaki poziv je uski i individualno testabilan.
    tag: js:sync-from-attributes-calls
    proTip: Svaki poziv je uski i individualno testabilan.
    focusHtmlNeedles: *a1
  - stepId: update-tier-name
    title: "JS: updateTierName()"
    summary: Piše display name tiera u naslov. `pro` → `Pro`.
    intent: API slug i UI labela su razdvojeni mapom.
    tag: js:update-tier-name
    proTip: API slug i UI labela su razdvojeni mapom.
    focusHtmlNeedles: *a1
  - stepId: update-price
    title: "JS: updatePrice()"
    summary: Čita `billing` da odluči monthly ili yearly cenu i piše broj u DOM.
    intent: "Dinamički pricing: toggle kontroliše šta se prikazuje, update je
      automatski."
    tag: js:update-price
    proTip: "Dinamički pricing: toggle kontroliše šta se prikazuje, update je
      automatski."
    focusHtmlNeedles: *a1
  - stepId: update-cta-label
    title: "JS: updateCtaLabel()"
    summary: Piše CTA tekst i postavlja aria-label sa tier kontekstom.
    intent: Accessibility je deo istog update contract-a, ne naknadan fix.
    tag: js:update-cta-label
    proTip: Accessibility je deo istog update contract-a, ne naknadan fix.
    focusHtmlNeedles: *a1
  - stepId: update-toggle-state
    title: "JS: updateToggleState()"
    summary: Ažurira `aria-checked` na toggle switch-u prema billing stanju.
    intent: Vizuelni toggle se oslanja na CSS :host([billing]) — JS samo drži ARIA u
      sinhronu.
    tag: js:update-toggle-state
    proTip: Vizuelni toggle se oslanja na CSS :host([billing]) — JS samo drži ARIA u
      sinhronu.
    focusHtmlNeedles: *a1
  - stepId: start-urgency-timer
    title: "JS: startUrgencyTimer()"
    summary: Pokreće setInterval koji svake sekunde smanjuje urgencyRemaining i
      ažurira prikaz.
    intent: "Timer je lifecycle-aware: živi koliko i komponenta u DOM-u."
    tag: js:start-urgency-timer
    proTip: "Timer je lifecycle-aware: živi koliko i komponenta u DOM-u."
    focusHtmlNeedles: *a1
  - stepId: stop-urgency-timer
    title: "JS: stopUrgencyTimer()"
    summary: Čisti interval i postavlja ID na null.
    intent: Lifecycle cleanup sprečava memory leak i ghost updates.
    tag: js:stop-urgency-timer
    proTip: Lifecycle cleanup sprečava memory leak i ghost updates.
    focusHtmlNeedles: *a1
  - stepId: update-urgency-display
    title: "JS: updateUrgencyDisplay()"
    summary: Formatira preostalo vreme u `HH:MM:SS` i piše u urgency-text element.
    intent: Display helper je odvojen od timer logike — jednostavno za test i zamenu
      formata.
    tag: js:update-urgency-display
    proTip: Display helper je odvojen od timer logike — jednostavno za test i zamenu
      formata.
    focusHtmlNeedles: *a1
  - stepId: bind-events
    title: "JS: bindEvents()"
    summary: Event wiring ostaje u sopstvenoj responsibility metodi.
    intent: Bind i unbind su uvek u paru.
    tag: js:bind-events
    proTip: Bind i unbind su uvek u paru.
    focusHtmlNeedles: *a1
  - stepId: bind-cta-event
    title: "JS: bindEvents kači CTA listener"
    summary: Guard sprečava dvostruki binding. CTA click emituje subscribe event.
    intent: Jedan listener, jedan flag, jedan cleanup.
    tag: js:bind-cta-event
    proTip: Jedan listener, jedan flag, jedan cleanup.
    focusHtmlNeedles: *a1
  - stepId: bind-toggle-event
    title: "JS: bindEvents kači toggle listener"
    summary: Toggle click menja billing atribut. Guard sprečava dvostruki binding.
    intent: Toggle je interni UI, ali njegov efekat se propagira kroz attribute
      pipeline.
    tag: js:bind-toggle-event
    proTip: Toggle je interni UI, ali njegov efekat se propagira kroz attribute
      pipeline.
    focusHtmlNeedles: *a1
  - stepId: unbind-events
    title: "JS: unbindEvents()"
    summary: Cleanup metoda za oba listenera.
    intent: Svaki bind ima svoj unbind par.
    tag: js:unbind-events
    proTip: Svaki bind ima svoj unbind par.
    focusHtmlNeedles: *a1
  - stepId: unbind-cta-event
    title: "JS: unbindEvents skida CTA listener"
    summary: Proveri flag pre skidanja — izbjagava grešku na disconnect bez
      prethodnog bind-a.
    intent: Defensive coding za lifecycle edge case-ove.
    tag: js:unbind-cta-event
    proTip: Defensive coding za lifecycle edge case-ove.
    focusHtmlNeedles: *a1
  - stepId: unbind-toggle-event
    title: "JS: unbindEvents skida toggle listener"
    summary: "Isti pattern: flag check, remove, reset."
    intent: Dva listenera, dva cleanup-a, isti model.
    tag: js:unbind-toggle-event
    proTip: Dva listenera, dva cleanup-a, isti model.
    focusHtmlNeedles: *a1
  - stepId: handle-cta-click
    title: "JS: handleCtaClick()"
    summary: CTA handler emituje namespaced event.
    intent: "Handler je mali: samo emituj signal sa payload-om."
    tag: js:handle-cta-click
    proTip: "Handler je mali: samo emituj signal sa payload-om."
    focusHtmlNeedles: *a1
  - stepId: handle-cta-click-event
    title: "JS: ui-pricing-card:subscribe event"
    summary: Emitujemo `ui-pricing-card:subscribe` sa `{tier, price, billing,
      ctaLabel, source}` detail-om.
    intent: Event contract je javni API. Parent ga sluša i odlučuje o checkout flow-u.
    tag: js:handle-cta-click-event
    proTip: Event contract je javni API. Parent ga sluša i odlučuje o checkout flow-u.
    focusHtmlNeedles: *a1
  - stepId: handle-toggle-click
    title: "JS: handleToggleClick() — billing toggle"
    summary: Klik na toggle menja billing sa monthly na yearly (ili obrnuto). Setter
      upisuje atribut → attributeChangedCallback → updatePrice +
      updateToggleState.
    intent: "Jednosmerni tok: klik → setter → atribut → callback → DOM update. Nema
      shortcut-a."
    tag: js:handle-toggle-click
    proTip: "Jednosmerni tok: klik → setter → atribut → callback → DOM update. Nema
      shortcut-a."
    focusHtmlNeedles: *a1
  - stepId: define-guard
    title: "JS: guard pre registracije"
    summary: Proveravamo da li je element već registrovan.
    intent: Hot reload i SSR ne smeju da bacaju grešku.
    tag: js:define-guard
    proTip: Hot reload i SSR ne smeju da bacaju grešku.
    focusHtmlNeedles: *a1
  - stepId: define-element
    title: "JS: registrujemo ui-pricing-card"
    summary: '`customElements.define("ui-pricing-card", UiPricingCard)` — pricing
      kartica je spremna.'
    intent: Od ovog momenta svaki `<ui-pricing-card>` u DOM-u dobija pun lifecycle,
      billing toggle i urgency timer.
    tag: js:define-element
    proTip: Od ovog momenta svaki `<ui-pricing-card>` u DOM-u dobija pun lifecycle,
      billing toggle i urgency timer.
    focusHtmlNeedles: *a1
  - stepId: shell-outline
    title: "CSS: .app-shell / outline"
    summary: Dodajemo tanak helper outline za `.app-shell` i držimo ga do završnog
      shell rezimea.
    intent: App shell ostaje neutralna pozornica za SaaS pricing demo.
    tag: css:shell-outline
    proTip: App shell ostaje neutralna pozornica za SaaS pricing demo.
    focusHtmlNeedles: &a2
      - <div class="app-shell">
  - stepId: shell-padding
    title: "CSS: .app-shell / padding"
    summary: Padding drži scenu urednom.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:shell-padding
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a2
  - stepId: shell-display
    title: "CSS: .app-shell / display"
    summary: Grid pravi jedinstven host za pricing card.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:shell-display
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a2
  - stepId: shell-place-items
    title: "CSS: .app-shell / place-items"
    summary: Centar drži fokus na jednom pricing card-u.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:shell-place-items
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a2
  - stepId: shell-min-height
    title: "CSS: .app-shell / min-height"
    summary: Puna visina drži tamnu pozadinu stabilnom.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:shell-min-height
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a2
  - stepId: shell-background
    title: "CSS: .app-shell / background"
    summary: Tamna pozadina naglašava SaaS pricing card.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:shell-background
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a2
  - stepId: host-outline
    title: "CSS: ui-pricing-card / outline"
    summary: Dodajemo host helper outline i držimo ga do završnog rezimea.
    intent: Host je javni contract surface pricing kartice.
    tag: css:host-outline
    proTip: Host je javni contract surface pricing kartice.
    focusHtmlNeedles: *a1
  - stepId: host-display
    title: "CSS: ui-pricing-card / display"
    summary: Block display pravi stabilan footprint.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:host-display
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a1
  - stepId: host-width
    title: "CSS: ui-pricing-card / width"
    summary: Širina pricing card-a ostaje ograničena i predvidiva.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:host-width
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a1
  - stepId: host-position
    title: "CSS: ui-pricing-card / position"
    summary: Relative za popular state i buduće overlay-e.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:host-position
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a1
  - stepId: host-surface-token
    title: "CSS: ui-pricing-card / --pricing-surface"
    summary: Surface token vodi pozadinu card-a.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:host-surface-token
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a1
  - stepId: host-surface-alt-token
    title: "CSS: ui-pricing-card / --pricing-surface-alt"
    summary: Alternativna površina zatvara gradijent.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:host-surface-alt-token
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a1
  - stepId: host-border-token
    title: "CSS: ui-pricing-card / --pricing-border"
    summary: Border token drži ivice nežnim.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:host-border-token
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a1
  - stepId: host-accent-token
    title: "CSS: ui-pricing-card / --pricing-accent"
    summary: Accent token vodi CTA, badge i tier boju.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:host-accent-token
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a1
  - stepId: host-accent-strong-token
    title: "CSS: ui-pricing-card / --pricing-accent-strong"
    summary: Jači accent zatvara CTA gradijent.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:host-accent-strong-token
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a1
  - stepId: host-text-token
    title: "CSS: ui-pricing-card / --pricing-text"
    summary: Text token čuva kontrast.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:host-text-token
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a1
  - stepId: host-muted-token
    title: "CSS: ui-pricing-card / --pricing-muted"
    summary: Muted token pokriva sekundarne labele.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:host-muted-token
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a1
  - stepId: host-shadow-token
    title: "CSS: ui-pricing-card / --pricing-shadow"
    summary: Shadow je javni token, ne interni magic number.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:host-shadow-token
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a1
  - stepId: host-popular-glow-token
    title: "CSS: ui-pricing-card / --pricing-popular-glow"
    summary: Popular glow token priprema highlight efekat za istaknutu karticu.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:host-popular-glow-token
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a1
  - stepId: tier-starter-accent
    title: 'CSS: ui-pricing-card[tier="starter"] / --pricing-accent'
    summary: Starter tier dobija ljubičasti accent.
    intent: Tier variants menjaju samo token — bez diranja shadow internals.
    tag: css:tier-starter-accent
    proTip: Tier variants menjaju samo token — bez diranja shadow internals.
    focusHtmlNeedles: &a3
      - <ui-pricing-card
      - tier=
  - stepId: tier-starter-accent-strong
    title: 'CSS: ui-pricing-card[tier="starter"] / --pricing-accent-strong'
    summary: Jači ljubičasti ton za CTA gradijent.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:tier-starter-accent-strong
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a3
  - stepId: tier-pro-accent
    title: 'CSS: ui-pricing-card[tier="pro"] / --pricing-accent'
    summary: Pro tier koristi default sky blue accent.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:tier-pro-accent
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: &a4
      - <ui-pricing-card
      - tier="pro"
  - stepId: tier-pro-accent-strong
    title: 'CSS: ui-pricing-card[tier="pro"] / --pricing-accent-strong'
    summary: Jači blue ton za pro CTA.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:tier-pro-accent-strong
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a4
  - stepId: tier-enterprise-accent
    title: 'CSS: ui-pricing-card[tier="enterprise"] / --pricing-accent'
    summary: Enterprise tier dobija amber accent.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:tier-enterprise-accent
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: &a5
      - <ui-pricing-card
      - tier=
  - stepId: tier-enterprise-accent-strong
    title: 'CSS: ui-pricing-card[tier="enterprise"] / --pricing-accent-strong'
    summary: Jači amber ton za enterprise CTA.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:tier-enterprise-accent-strong
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a5
  - stepId: popular-host-shadow
    title: "CSS: ui-pricing-card[popular] / box-shadow"
    summary: Popular kartica dobija glow efekat.
    intent: Popular state je boolean atribut — prisutnost znači aktivan.
    tag: css:popular-host-shadow
    proTip: Popular state je boolean atribut — prisutnost znači aktivan.
    focusHtmlNeedles: &a6
      - <ui-pricing-card
      - popular
  - stepId: popular-host-transform
    title: "CSS: ui-pricing-card[popular] / transform"
    summary: Blagi scale ističe popularnu opciju.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:popular-host-transform
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a6
  - stepId: popular-host-z-index
    title: "CSS: ui-pricing-card[popular] / z-index"
    summary: Z-index drži popularnu karticu iznad susednih u grid-u.
    intent: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    tag: css:popular-host-z-index
    proTip: Host CSS drži tier variants, popular state i token contract na samom
      custom elementu.
    focusHtmlNeedles: *a6
  - stepId: host-vs-shadow-styles
    title: "Teaching Moment: Tier + Popular + Billing Contract"
    summary: 'Host CSS je definisao token contract, tier accent varijante i popular
      state highlight. Shadow CSS sada stilizuje card internals: badge, cenu,
      toggle switch, feature listu, CTA i urgency timer. Toggle vizuelni efekat
      dolazi iz `:host([billing="yearly"])` selectora — CSS automatski reaguje
      na atribut.'
    intent: "Pravilo: tier/popular/billing spolja, card internals unutra."
    tag: teaching:host-vs-shadow-styles
    proTip: "Pravilo: tier/popular/billing spolja, card internals unutra."
    focusHtmlNeedles: *a1
  - stepId: shadow-host-display
    title: "Shadow CSS: :host / display"
    summary: Shadow host potvrđuje block model iznutra.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:shadow-host-display
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: &a7
      - <ui-pricing-card
      - tier=
  - stepId: shadow-host-font-family
    title: "Shadow CSS: :host / font-family"
    summary: Font stack je interni shadow contract.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:shadow-host-font-family
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a7
  - stepId: shadow-host-color
    title: "Shadow CSS: :host / color"
    summary: Boja čita spoljašnji text token.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:shadow-host-color
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a7
  - stepId: card-outline
    title: "Shadow CSS: .card / outline"
    summary: Dodajemo helper outline za card blok.
    intent: Card outline ostaje dok ne završimo unutrašnju celinu.
    tag: shadow-css:card-outline
    proTip: Card outline ostaje dok ne završimo unutrašnju celinu.
    focusHtmlNeedles: &a8
      - <ui-pricing-card
      - tier=
  - stepId: card-display
    title: "Shadow CSS: .card / display"
    summary: Card koristi grid za vertikalni stack svih zona.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:card-display
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a8
  - stepId: card-gap
    title: "Shadow CSS: .card / gap"
    summary: Gap odvaja badge, tier, cenu, toggle, feature listu i CTA.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:card-gap
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a8
  - stepId: card-padding
    title: "Shadow CSS: .card / padding"
    summary: Padding pravi pravi card footprint.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:card-padding
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a8
  - stepId: card-radius
    title: "Shadow CSS: .card / border-radius"
    summary: Zaobljenje daje modernu siluetu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:card-radius
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a8
  - stepId: card-border
    title: "Shadow CSS: .card / border"
    summary: Border čita host token.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:card-border
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a8
  - stepId: card-background
    title: "Shadow CSS: .card / background"
    summary: Card pozadina čita host surface tokene.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:card-background
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a8
  - stepId: card-shadow
    title: "Shadow CSS: .card / box-shadow"
    summary: Shadow dolazi iz host contract-a.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:card-shadow
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a8
  - stepId: card-text-align
    title: "Shadow CSS: .card / text-align"
    summary: Card sadržaj se centrira.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:card-text-align
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a8
  - stepId: badge-outline
    title: "Shadow CSS: .popular-badge / outline"
    summary: Dodajemo helper outline za popular badge.
    intent: Badge je skriven po default-u, vidljiv samo kada je popular atribut
      prisutan.
    tag: shadow-css:badge-outline
    proTip: Badge je skriven po default-u, vidljiv samo kada je popular atribut
      prisutan.
    focusHtmlNeedles: &a9
      - <ui-pricing-card
      - popular
  - stepId: badge-display
    title: "Shadow CSS: .popular-badge / display"
    summary: Badge je sakriveno po defaultu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:badge-display
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a9
  - stepId: badge-padding
    title: "Shadow CSS: .popular-badge / padding"
    summary: Padding pravi pill footprint.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:badge-padding
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a9
  - stepId: badge-radius
    title: "Shadow CSS: .popular-badge / border-radius"
    summary: Veliki radius pravi kapsulu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:badge-radius
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a9
  - stepId: badge-background
    title: "Shadow CSS: .popular-badge / background"
    summary: Badge pozadina čita tier accent tokene.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:badge-background
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a9
  - stepId: badge-color
    title: "Shadow CSS: .popular-badge / color"
    summary: Beli tekst drži kontrast.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:badge-color
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a9
  - stepId: badge-font-size
    title: "Shadow CSS: .popular-badge / font-size"
    summary: Mali font čini badge kompaktnim.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:badge-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a9
  - stepId: badge-font-weight
    title: "Shadow CSS: .popular-badge / font-weight"
    summary: Bold drži badge labelu čitkom.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:badge-font-weight
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a9
  - stepId: badge-letter-spacing
    title: "Shadow CSS: .popular-badge / letter-spacing"
    summary: Tracking drži badge urednim.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:badge-letter-spacing
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a9
  - stepId: badge-text-transform
    title: "Shadow CSS: .popular-badge / text-transform"
    summary: Uppercase za badge kategorijsku labelu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:badge-text-transform
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a9
  - stepId: badge-width
    title: "Shadow CSS: .popular-badge / width"
    summary: Širina samo za sadržaj.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:badge-width
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a9
  - stepId: badge-justify-self
    title: "Shadow CSS: .popular-badge / justify-self"
    summary: Centriramo badge horizontalno.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:badge-justify-self
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a9
  - stepId: badge-popular-display
    title: "Shadow CSS: :host([popular]) .popular-badge / display"
    summary: Kada je popular atribut prisutan, badge postaje vidljiv.
    intent: CSS čita host atribut — JS ne mora ručno da toggle-uje visibility.
    tag: shadow-css:badge-popular-display
    proTip: CSS čita host atribut — JS ne mora ručno da toggle-uje visibility.
    focusHtmlNeedles:
      - <ui-pricing-card
      - popular
  - stepId: badge-slotted-font
    title: 'Shadow CSS: ::slotted([slot="badge"]) / font'
    summary: Slotovani badge sadržaj nasleđuje font.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:badge-slotted-font
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles:
      - slot="badge"
      - <ui-pricing-card
  - stepId: tier-name-margin
    title: "Shadow CSS: .tier-name / margin"
    summary: Brišemo podrazumevani heading margin.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:tier-name-margin
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: &a10
      - <ui-pricing-card
      - tier=
  - stepId: tier-name-font-size
    title: "Shadow CSS: .tier-name / font-size"
    summary: Tier ime dobija kompaktnu veličinu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:tier-name-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a10
  - stepId: tier-name-font-weight
    title: "Shadow CSS: .tier-name / font-weight"
    summary: Bold drži tier ime jasnim.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:tier-name-font-weight
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a10
  - stepId: tier-name-text-transform
    title: "Shadow CSS: .tier-name / text-transform"
    summary: Uppercase pojačava hijerarhiju.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:tier-name-text-transform
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a10
  - stepId: tier-name-letter-spacing
    title: "Shadow CSS: .tier-name / letter-spacing"
    summary: Tracking za tier labelu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:tier-name-letter-spacing
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a10
  - stepId: tier-name-color
    title: "Shadow CSS: .tier-name / color"
    summary: Tier ime čita accent token — menja se sa tier variantom.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:tier-name-color
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a10
  - stepId: price-outline
    title: "Shadow CSS: .price-block / outline"
    summary: Dodajemo helper outline za price blok.
    intent: Cena je centralni element pricing kartice.
    tag: shadow-css:price-outline
    proTip: Cena je centralni element pricing kartice.
    focusHtmlNeedles: &a11
      - <ui-pricing-card
      - price-monthly=
  - stepId: price-display
    title: "Shadow CSS: .price-block / display"
    summary: Flex pravi horizontalni raspored valuta/iznos/period.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-display
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a11
  - stepId: price-align
    title: "Shadow CSS: .price-block / align-items"
    summary: Baseline poravnavanje drži $ i /mo uz velik iznos.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-align
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a11
  - stepId: price-justify
    title: "Shadow CSS: .price-block / justify-content"
    summary: Centriramo cenu horizontalno.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-justify
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a11
  - stepId: price-gap
    title: "Shadow CSS: .price-block / gap"
    summary: Minimalni gap između delova cene.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-gap
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a11
  - stepId: price-currency-font-size
    title: "Shadow CSS: .price-currency / font-size"
    summary: Valuta dobija manji ali jasno vidljiv font.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-currency-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: &a12
      - <ui-pricing-card
      - price-monthly=
  - stepId: price-currency-font-weight
    title: "Shadow CSS: .price-currency / font-weight"
    summary: Bold za valutu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-currency-font-weight
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a12
  - stepId: price-currency-color
    title: "Shadow CSS: .price-currency / color"
    summary: Valuta čita muted token.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-currency-color
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a12
  - stepId: price-amount-font-size
    title: "Shadow CSS: .price-amount / font-size"
    summary: Velika veličina dominira karticom.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-amount-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: &a13
      - <ui-pricing-card
      - price-monthly=
  - stepId: price-amount-font-weight
    title: "Shadow CSS: .price-amount / font-weight"
    summary: Extra bold naglašava cenu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-amount-font-weight
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a13
  - stepId: price-amount-line-height
    title: "Shadow CSS: .price-amount / line-height"
    summary: Line-height drži broj zategnutim.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-amount-line-height
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a13
  - stepId: price-amount-transition
    title: "Shadow CSS: .price-amount / transition"
    summary: Tranzicija omogućava future animaciju pri promeni.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-amount-transition
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a13
  - stepId: price-period-font-size
    title: "Shadow CSS: .price-period / font-size"
    summary: Period je sekundaran.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-period-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: &a14
      - <ui-pricing-card
      - price-monthly=
  - stepId: price-period-color
    title: "Shadow CSS: .price-period / color"
    summary: Period čita muted token.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-period-color
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a14
  - stepId: price-period-font-weight
    title: "Shadow CSS: .price-period / font-weight"
    summary: Medium weight za period.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:price-period-font-weight
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a14
  - stepId: toggle-outline
    title: "Shadow CSS: .billing-toggle / outline"
    summary: Dodajemo helper outline za billing toggle.
    intent: Toggle je interaktivni UI deo koji menja prikazanu cenu.
    tag: shadow-css:toggle-outline
    proTip: Toggle je interaktivni UI deo koji menja prikazanu cenu.
    focusHtmlNeedles: &a15
      - <ui-pricing-card
      - tier=
  - stepId: toggle-display
    title: "Shadow CSS: .billing-toggle / display"
    summary: Flex slaže labele i switch horizontalno.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-display
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a15
  - stepId: toggle-align
    title: "Shadow CSS: .billing-toggle / align-items"
    summary: Centriramo elemente vertikalno.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-align
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a15
  - stepId: toggle-justify
    title: "Shadow CSS: .billing-toggle / justify-content"
    summary: Centriramo ceo toggle.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-justify
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a15
  - stepId: toggle-gap
    title: "Shadow CSS: .billing-toggle / gap"
    summary: Gap odvaja labele od switch-a.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-gap
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a15
  - stepId: toggle-label-font-size
    title: "Shadow CSS: .toggle-label / font-size"
    summary: Kompaktan font za toggle labele.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-label-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: &a16
      - <ui-pricing-card
      - tier=
  - stepId: toggle-label-color
    title: "Shadow CSS: .toggle-label / color"
    summary: Muted boja za neupadljivost.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-label-color
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a16
  - stepId: toggle-label-font-weight
    title: "Shadow CSS: .toggle-label / font-weight"
    summary: Medium weight za labele.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-label-font-weight
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a16
  - stepId: toggle-label-transition
    title: "Shadow CSS: .toggle-label / transition"
    summary: Tranzicija za smooth promenu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-label-transition
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a16
  - stepId: toggle-switch-appearance
    title: "Shadow CSS: .toggle-switch / appearance"
    summary: Gasimo native izgled.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-switch-appearance
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: &a17
      - <ui-pricing-card
      - tier=
  - stepId: toggle-switch-width
    title: "Shadow CSS: .toggle-switch / width"
    summary: Switch širina.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-switch-width
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a17
  - stepId: toggle-switch-height
    title: "Shadow CSS: .toggle-switch / height"
    summary: Switch visina.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-switch-height
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a17
  - stepId: toggle-switch-radius
    title: "Shadow CSS: .toggle-switch / border-radius"
    summary: Zaobljenje za pill oblik.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-switch-radius
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a17
  - stepId: toggle-switch-border
    title: "Shadow CSS: .toggle-switch / border"
    summary: Uklanjamo border.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-switch-border
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a17
  - stepId: toggle-switch-background
    title: "Shadow CSS: .toggle-switch / background"
    summary: Neutralna toggle pozadina — menja se na yearly.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-switch-background
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a17
  - stepId: toggle-switch-cursor
    title: "Shadow CSS: .toggle-switch / cursor"
    summary: Pointer kursor za klikabilnost.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-switch-cursor
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a17
  - stepId: toggle-switch-position
    title: "Shadow CSS: .toggle-switch / position"
    summary: Relative za knob pozicioniranje.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-switch-position
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a17
  - stepId: toggle-switch-padding
    title: "Shadow CSS: .toggle-switch / padding"
    summary: Padding oko knob-a.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-switch-padding
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a17
  - stepId: toggle-switch-transition
    title: "Shadow CSS: .toggle-switch / transition"
    summary: Glatki prelaz pozadine.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-switch-transition
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a17
  - stepId: toggle-knob-display
    title: "Shadow CSS: .toggle-knob / display"
    summary: Block za knob.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-knob-display
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: &a18
      - <ui-pricing-card
      - tier=
  - stepId: toggle-knob-width
    title: "Shadow CSS: .toggle-knob / width"
    summary: Knob veličina.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-knob-width
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a18
  - stepId: toggle-knob-height
    title: "Shadow CSS: .toggle-knob / height"
    summary: Visina jednaka širini.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-knob-height
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a18
  - stepId: toggle-knob-radius
    title: "Shadow CSS: .toggle-knob / border-radius"
    summary: Kružni knob.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-knob-radius
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a18
  - stepId: toggle-knob-background
    title: "Shadow CSS: .toggle-knob / background"
    summary: Beli knob.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-knob-background
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a18
  - stepId: toggle-knob-transition
    title: "Shadow CSS: .toggle-knob / transition"
    summary: Glatki prelaz pozicije.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-knob-transition
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a18
  - stepId: toggle-yearly-bg
    title: 'Shadow CSS: :host([billing="yearly"]) .toggle-switch / background'
    summary: Na yearly, switch postaje accent boja.
    intent: CSS čita billing atribut — JS samo menja atribut, vizuelni efekat je
      automatski.
    tag: shadow-css:toggle-yearly-bg
    proTip: CSS čita billing atribut — JS samo menja atribut, vizuelni efekat je
      automatski.
    focusHtmlNeedles:
      - <ui-pricing-card
      - tier=
  - stepId: toggle-yearly-knob
    title: 'Shadow CSS: :host([billing="yearly"]) .toggle-knob / transform'
    summary: Knob se pomera desno na yearly.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:toggle-yearly-knob
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles:
      - <ui-pricing-card
      - tier=
  - stepId: save-badge-font-size
    title: "Shadow CSS: .save-badge / font-size"
    summary: Save badge je mali ali upadljiv.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:save-badge-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: &a19
      - <ui-pricing-card
      - tier=
  - stepId: save-badge-background
    title: "Shadow CSS: .save-badge / background"
    summary: Zelena pozadina signalizira uštedu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:save-badge-background
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a19
  - stepId: save-badge-color
    title: "Shadow CSS: .save-badge / color"
    summary: Zeleni tekst za save signal.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:save-badge-color
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a19
  - stepId: save-badge-padding
    title: "Shadow CSS: .save-badge / padding"
    summary: Mali padding.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:save-badge-padding
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a19
  - stepId: save-badge-radius
    title: "Shadow CSS: .save-badge / border-radius"
    summary: Blago zaobljenje.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:save-badge-radius
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a19
  - stepId: save-badge-font-weight
    title: "Shadow CSS: .save-badge / font-weight"
    summary: Bold za isticanje.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:save-badge-font-weight
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a19
  - stepId: features-outline
    title: "Shadow CSS: .feature-list / outline"
    summary: Dodajemo helper outline za feature listu.
    intent: Feature list slot je javna površina za marketing sadržaj.
    tag: shadow-css:features-outline
    proTip: Feature list slot je javna površina za marketing sadržaj.
    focusHtmlNeedles: &a20
      - <ui-pricing-card
      - slot="features"
  - stepId: features-padding
    title: "Shadow CSS: .feature-list / padding"
    summary: Vertikalni padding za feature zonu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:features-padding
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a20
  - stepId: features-slotted-list-style
    title: "Shadow CSS: ::slotted(ul) / list-style"
    summary: Brišemo bullet-e.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:features-slotted-list-style
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: &a21
      - slot="features"
      - <ui-pricing-card
  - stepId: features-slotted-margin
    title: "Shadow CSS: ::slotted(ul) / margin"
    summary: Brišemo default margin.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:features-slotted-margin
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a21
  - stepId: features-slotted-padding
    title: "Shadow CSS: ::slotted(ul) / padding"
    summary: Brišemo default padding.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:features-slotted-padding
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a21
  - stepId: features-slotted-display
    title: "Shadow CSS: ::slotted(ul) / display"
    summary: Grid za feature listu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:features-slotted-display
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a21
  - stepId: features-slotted-gap
    title: "Shadow CSS: ::slotted(ul) / gap"
    summary: Razmak između feature stavki.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:features-slotted-gap
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a21
  - stepId: features-slotted-text-align
    title: "Shadow CSS: ::slotted(ul) / text-align"
    summary: Feature stavke su levo poravnate.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:features-slotted-text-align
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a21
  - stepId: features-slotted-font-size
    title: "Shadow CSS: ::slotted(ul) / font-size"
    summary: Kompaktan font za feature listu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:features-slotted-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a21
  - stepId: features-slotted-color
    title: "Shadow CSS: ::slotted(ul) / color"
    summary: Feature tekst čita muted token.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:features-slotted-color
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a21
  - stepId: cta-outline
    title: "Shadow CSS: .cta / outline"
    summary: Dodajemo helper outline za CTA dugme.
    intent: CTA je centralni action element pricing kartice.
    tag: shadow-css:cta-outline
    proTip: CTA je centralni action element pricing kartice.
    focusHtmlNeedles: &a22
      - <ui-pricing-card
      - cta-label=
  - stepId: cta-appearance
    title: "Shadow CSS: .cta / appearance"
    summary: Gasimo native button izgled.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-appearance
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-width
    title: "Shadow CSS: .cta / width"
    summary: CTA zauzima punu širinu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-width
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-padding
    title: "Shadow CSS: .cta / padding"
    summary: Padding pravi klik zonu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-padding
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-border
    title: "Shadow CSS: .cta / border"
    summary: Brišemo border.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-border
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-radius
    title: "Shadow CSS: .cta / border-radius"
    summary: Zaobljeno dugme.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-radius
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-background
    title: "Shadow CSS: .cta / background"
    summary: CTA gradijent čita tier tokene — menja se sa varijantom.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-background
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-color
    title: "Shadow CSS: .cta / color"
    summary: Beli tekst za kontrast.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-color
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-font
    title: "Shadow CSS: .cta / font"
    summary: Preuzima font.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-font
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-font-size
    title: "Shadow CSS: .cta / font-size"
    summary: Solidna veličina za action.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-font-weight
    title: "Shadow CSS: .cta / font-weight"
    summary: Bold za jasnoću.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-font-weight
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-cursor
    title: "Shadow CSS: .cta / cursor"
    summary: Kursor potvrđuje interakciju.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-cursor
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-transition
    title: "Shadow CSS: .cta / transition"
    summary: Tranzicije za glatki response.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-transition
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-box-shadow
    title: "Shadow CSS: .cta / box-shadow"
    summary: CTA shadow dodaje dubinu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-box-shadow
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a22
  - stepId: cta-hover-filter
    title: "Shadow CSS: .cta:hover / filter"
    summary: Na hover blago podižemo svetlinu.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-hover-filter
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: &a23
      - <ui-pricing-card
      - cta-label=
  - stepId: cta-hover-transform
    title: "Shadow CSS: .cta:hover / transform"
    summary: Blagi lift na hover.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-hover-transform
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a23
  - stepId: cta-active-transform
    title: "Shadow CSS: .cta:active / transform"
    summary: Na active vraćamo dugme.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-active-transform
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles:
      - <ui-pricing-card
      - cta-label=
  - stepId: cta-focus-outline
    title: "Shadow CSS: .cta:focus-visible / outline"
    summary: Focus ring za tastatursku navigaciju.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-focus-outline
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: &a24
      - <ui-pricing-card
      - cta-label=
  - stepId: cta-focus-outline-offset
    title: "Shadow CSS: .cta:focus-visible / outline-offset"
    summary: Offset odvaja ring od dugmeta.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:cta-focus-outline-offset
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a24
  - stepId: urgency-outline
    title: "Shadow CSS: .urgency / outline"
    summary: Dodajemo helper outline za urgency timer zonu.
    intent: Urgency timer pojačava konverziju — mora biti vizuelno jasan ali ne
      agresivan.
    tag: shadow-css:urgency-outline
    proTip: Urgency timer pojačava konverziju — mora biti vizuelno jasan ali ne
      agresivan.
    focusHtmlNeedles: &a25
      - <ui-pricing-card
      - tier=
  - stepId: urgency-display
    title: "Shadow CSS: .urgency / display"
    summary: Flex slaže ikonu i tekst.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:urgency-display
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a25
  - stepId: urgency-align
    title: "Shadow CSS: .urgency / align-items"
    summary: Centriramo vertikalno.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:urgency-align
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a25
  - stepId: urgency-justify
    title: "Shadow CSS: .urgency / justify-content"
    summary: Centriramo horizontalno.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:urgency-justify
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a25
  - stepId: urgency-gap
    title: "Shadow CSS: .urgency / gap"
    summary: Gap između ikone i teksta.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:urgency-gap
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a25
  - stepId: urgency-font-size
    title: "Shadow CSS: .urgency / font-size"
    summary: Kompaktan font.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:urgency-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a25
  - stepId: urgency-color
    title: "Shadow CSS: .urgency / color"
    summary: Narandžasta boja za urgency signal.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:urgency-color
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a25
  - stepId: urgency-font-weight
    title: "Shadow CSS: .urgency / font-weight"
    summary: Semi-bold za urgentnost.
    intent: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    tag: shadow-css:urgency-font-weight
    proTip: Shadow CSS stilizuje samo unutrašnju card strukturu. Host tokeni
      kontrolišu temu spolja.
    focusHtmlNeedles: *a25
  - stepId: card-summary
    title: "Rezime: .card"
    summary: Uklanjamo card helper outline.
    intent: Card čita sve styling tokene iz host contract-a.
    tag: summary:card-summary
    proTip: Card čita sve styling tokene iz host contract-a.
    focusHtmlNeedles: *a1
  - stepId: badge-summary
    title: "Rezime: .popular-badge"
    summary: Uklanjamo badge helper outline.
    intent: Badge se pojavljuje samo kada je popular atribut prisutan — CSS
      controlled visibility.
    tag: summary:badge-summary
    proTip: Badge se pojavljuje samo kada je popular atribut prisutan — CSS
      controlled visibility.
    focusHtmlNeedles: *a1
  - stepId: price-summary
    title: "Rezime: .price-block"
    summary: Uklanjamo price helper outline.
    intent: "Cena se dinamički menja toggle-om: monthly/yearly → billing atribut →
      updatePrice()."
    tag: summary:price-summary
    proTip: "Cena se dinamički menja toggle-om: monthly/yearly → billing atribut →
      updatePrice()."
    focusHtmlNeedles: *a1
  - stepId: toggle-summary
    title: "Rezime: .billing-toggle"
    summary: Uklanjamo billing toggle helper outline.
    intent: Toggle switch vizuelno reaguje na :host([billing="yearly"]) bez JS
      direktne manipulacije stila.
    tag: summary:toggle-summary
    proTip: Toggle switch vizuelno reaguje na :host([billing="yearly"]) bez JS
      direktne manipulacije stila.
    focusHtmlNeedles: *a1
  - stepId: features-summary
    title: "Rezime: .feature-list"
    summary: Uklanjamo feature list helper outline.
    intent: Feature lista je named slot — sadržaj kontroliše parent, stilizovanje
      kontroliše shadow.
    tag: summary:features-summary
    proTip: Feature lista je named slot — sadržaj kontroliše parent, stilizovanje
      kontroliše shadow.
    focusHtmlNeedles: *a1
  - stepId: cta-summary
    title: "Rezime: .cta"
    summary: Uklanjamo CTA helper outline.
    intent: CTA emituje ui-pricing-card:subscribe event. Parent odlučuje o checkout
      flow-u.
    tag: summary:cta-summary
    proTip: CTA emituje ui-pricing-card:subscribe event. Parent odlučuje o checkout
      flow-u.
    focusHtmlNeedles: *a1
  - stepId: urgency-summary
    title: "Rezime: .urgency"
    summary: Uklanjamo urgency timer helper outline.
    intent: "Timer je lifecycle-aware: startuje na connect, zaustavlja se na
      disconnect."
    tag: summary:urgency-summary
    proTip: "Timer je lifecycle-aware: startuje na connect, zaustavlja se na
      disconnect."
    focusHtmlNeedles: *a1
  - stepId: host-summary
    title: "Rezime: ui-pricing-card host"
    summary: Uklanjamo host helper outline.
    intent: Host nosi kompletno tier/popular/billing token contract bez mešanja sa
      shadow-om.
    tag: summary:host-summary
    proTip: Host nosi kompletno tier/popular/billing token contract bez mešanja sa
      shadow-om.
    focusHtmlNeedles: *a1
  - stepId: shell-summary
    title: "Rezime: .app-shell"
    summary: Uklanjamo shell helper outline.
    intent: Pricing kartica živi u neutralnoj sceni, spremna za integraciju u pravi
      pricing page.
    tag: summary:shell-summary
    proTip: Pricing kartica živi u neutralnoj sceni, spremna za integraciju u pravi
      pricing page.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: done
    title: "Done: UI Pricing Card — SaaS Pricing Table"
    summary: "`ui-pricing-card` je završen: `index.html` deklarativno koristi
      tier/price/popular atribute i feature slot, `ui-pricing-card.template.js`
      drži shadow strukturu, `ui-pricing-card.js` vodi property API, billing
      toggle, urgency timer i subscribe event, `style.css` theme-uje host sa
      tier varijantama, a `ui-pricing-card.shadow.css` drži unutrašnji styling
      sa toggle animacijom."
    intent: "Enterprise pricing widget: šest atributa, dva slota, jedan event,
      billing toggle, urgency timer, tri tier varijante. Ceo tok je jednosmeran:
      atribut → callback → DOM."
    tag: success
    proTip: "Enterprise pricing widget: šest atributa, dva slota, jedan event,
      billing toggle, urgency timer, tri tier varijante. Ceo tok je jednosmeran:
      atribut → callback → DOM."
    focusHtmlNeedles: []
---

# Step: empty-shell

## Scene: empty-shell-scene

narration:
Počinjemo od praznog `.app-shell`. SaaS pricing kartica živi u neutralnom host okruženju.

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
Dodajemo `<ui-pricing-card>` sa `tier="pro"`, `price-monthly="29"` i `price-yearly="290"`. Tag odmah kaže šta widget radi.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: popular-attribute-html

## Scene: popular-attribute-html-scene

narration:
Dodajemo `popular` atribut. Njegova prisutnost znači da je ova kartica istaknuta — nema vrednosti, samo postoji ili ne postoji.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: cta-label-attribute-html

## Scene: cta-label-attribute-html-scene

narration:
Dodajemo `cta-label="Start free trial"`. CTA tekst je deo javnog contract-a, ne hardkodovan u shadow DOM-u.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: badge-slot-html

## Scene: badge-slot-html-scene

narration:
Dodajemo `<span slot="badge">⭐ Most Popular</span>`. Parent kontroliše badge sadržaj.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: features-slot-html

## Scene: features-slot-html-scene

narration:
Dodajemo `<ul slot="features">` sa pet feature stavki. Feature matrix je javna powierzchina.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: pricing-widget-contract

## Scene: pricing-widget-contract-scene

narration:
Widget ima šest atributa: `tier`, `price-monthly`, `price-yearly`, `billing`, `popular`, `cta-label`. Ima dva named slota: `badge` i `features`. Emituje jedan namespaced event: `ui-pricing-card:subscribe`. Urgency timer je interni lifecycle detalj.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: template-html-declaration

## Scene: template-html-declaration-scene

narration:
U `ui-pricing-card.template.js` definišemo `templateHtml`: card sa badge, tier-name, price-block (currency/amount/period), billing-toggle sa knob switch-em, feature-list slot, CTA dugme i urgency timer zona.

focus:
  artifactId: template-js

code:
  activeArtifactId: template-js

preview:
  action: apply-state
  target: dom

# Step: template-element-export

## Scene: template-element-export-scene

narration:
Kreiramo `uiPricingCardTemplate`, dodajemo `<link>` ka shadow CSS fajlu i ubrizgavamo `${templateHtml}`.

focus:
  artifactId: template-js

code:
  activeArtifactId: template-js

preview:
  action: apply-state
  target: dom

# Step: import-template

## Scene: import-template-scene

narration:
Behavior fajl uvozi `uiPricingCardTemplate` iz template modula.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: normalize-text-helper

## Scene: normalize-text-helper-scene

narration:
Dodajemo `normalizeTextValue()` za tekst normalizaciju sa fallback-om.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: allowed-tiers-set

## Scene: allowed-tiers-set-scene

narration:
Zaključavamo dozvoljene tier vrednosti: `starter`, `pro`, `enterprise`.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: normalize-tier-helper

## Scene: normalize-tier-helper-scene

narration:
Nepoznat tier automatski pada na `starter`.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: parse-price-helper

## Scene: parse-price-helper-scene

narration:
Dodajemo `parsePriceValue()` koji parira cenu u broj i vraća 0 za nevalidan ulaz.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: format-time-helper

## Scene: format-time-helper-scene

narration:
Dodajemo `formatTimeRemaining()` koji formatira sekunde u `HH:MM:SS` string za urgency timer.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: tier-display-map

## Scene: tier-display-map-scene

narration:
Dodajemo mapu tier → display name. UI labela ne sme da bude isti string kao API vrednost.

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
Klasa nosi domain-driven ime konzistentno sa tagom.

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
Komponenta prati `tier`, `price-monthly`, `price-yearly`, `billing`, `popular` i `cta-label`.

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
Konstruktor samo priprema instancu: shadow root, bind-ove i nulte reference.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: constructor-bind

## Scene: constructor-bind-scene

narration:
Vezujemo `handleCtaClick` i `handleToggleClick` jednom pri kreiranju instance.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: constructor-state

## Scene: constructor-state-scene

narration:
Nulujemo DOM reference, binding flagove, timer ID i urgency preostalo vreme.

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
Connected lifecycle je glavni ulaz kada pricing kartica uđe u DOM.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: connected-callback-setup

## Scene: connected-callback-setup-scene

narration:
Montiramo template u shadow root jednom.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: connected-callback-cache

## Scene: connected-callback-cache-scene

narration:
Keširamo pet DOM referenci.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: connected-callback-sync

## Scene: connected-callback-sync-scene

narration:
Pozivamo `syncFromAttributes()` za inicijalni render pass.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: connected-callback-bind

## Scene: connected-callback-bind-scene

narration:
Vezujemo CTA i toggle click listenere.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: connected-callback-urgency

## Scene: connected-callback-urgency-scene

narration:
Pozivamo `startUrgencyTimer()` koji pokreće interval sa countdown-om od 1h.

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
Na izlazu iz DOM-a skidamo evente i zaustavljamo urgency timer.

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
Potpis prima `name`, `oldValue` i `newValue` za granularni update.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: attribute-changed-guard

## Scene: attribute-changed-guard-scene

narration:
Odmah izlazimo ako se vrednost nije promenila ili widget nije u DOM-u.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: attribute-changed-switch

## Scene: attribute-changed-switch-scene

narration:
Tier menja labelu, price/billing/yearly menjaju prikazanu cenu i toggle, cta-label menja dugme.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-tier-getter

## Scene: property-tier-getter-scene

narration:
Getter vraća normalizovani tier sa fallback-om na `starter`.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-tier-setter

## Scene: property-tier-setter-scene

narration:
Setter normalizuje i piše nazad u atribut.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-price-monthly-getter

## Scene: property-price-monthly-getter-scene

narration:
Getter parsira mesečnu cenu u bezbedan broj.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-price-yearly-getter

## Scene: property-price-yearly-getter-scene

narration:
Getter parsira godišnju cenu na isti način.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-billing-getter

## Scene: property-billing-getter-scene

narration:
Getter vraća `monthly` ili `yearly` — samo dve opcije.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-billing-setter

## Scene: property-billing-setter-scene

narration:
Setter piše normalizovani billing nazad u atribut.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-popular-getter

## Scene: property-popular-getter-scene

narration:
Boolean getter čita hasAttribute.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-cta-label-getter

## Scene: property-cta-label-getter-scene

narration:
Getter vraća normalizovan CTA tekst sa fallback-om.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: setup-template-once

## Scene: setup-template-once-scene

narration:
Template mount za reusable kloniranje.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: setup-template-once-guard

## Scene: setup-template-once-guard-scene

narration:
Kloniramo template samo ako shadow root nema dece.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cache-dom

## Scene: cache-dom-scene

narration:
Querijemo šest internih elemenata i čuvamo na instanci.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cache-dom-tier-name

## Scene: cache-dom-tier-name-scene

narration:
Tier name span čuvamo za updateTierName.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cache-dom-price-amount

## Scene: cache-dom-price-amount-scene

narration:
Price amount element čuvamo za dinamičko menjanje cene.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cache-dom-price-period

## Scene: cache-dom-price-period-scene

narration:
Price period span čuvamo za dinamičko menjanje tekstualne labele (/mo ili /yr).

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cache-dom-cta

## Scene: cache-dom-cta-scene

narration:
CTA dugme čuvamo za tekst i event binding.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cache-dom-toggle

## Scene: cache-dom-toggle-scene

narration:
Toggle switch čuvamo za aria-checked i event.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cache-dom-urgency

## Scene: cache-dom-urgency-scene

narration:
Urgency text element čuvamo za timer update.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: sync-from-attributes

## Scene: sync-from-attributes-scene

narration:
Centralna one-time inicijalizacija DOM-a iz atributa.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: sync-from-attributes-calls

## Scene: sync-from-attributes-calls-scene

narration:
Pozivamo `updateTierName()`, `updatePrice()`, `updateToggleState()` i `updateCtaLabel()`.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: update-tier-name

## Scene: update-tier-name-scene

narration:
Piše display name tiera u naslov. `pro` → `Pro`.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: update-price

## Scene: update-price-scene

narration:
Čita `billing` da odluči monthly ili yearly cenu i piše broj u DOM.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: update-cta-label

## Scene: update-cta-label-scene

narration:
Piše CTA tekst i postavlja aria-label sa tier kontekstom.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: update-toggle-state

## Scene: update-toggle-state-scene

narration:
Ažurira `aria-checked` na toggle switch-u prema billing stanju.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: start-urgency-timer

## Scene: start-urgency-timer-scene

narration:
Pokreće setInterval koji svake sekunde smanjuje urgencyRemaining i ažurira prikaz.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: stop-urgency-timer

## Scene: stop-urgency-timer-scene

narration:
Čisti interval i postavlja ID na null.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: update-urgency-display

## Scene: update-urgency-display-scene

narration:
Formatira preostalo vreme u `HH:MM:SS` i piše u urgency-text element.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: bind-events

## Scene: bind-events-scene

narration:
Event wiring ostaje u sopstvenoj responsibility metodi.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: bind-cta-event

## Scene: bind-cta-event-scene

narration:
Guard sprečava dvostruki binding. CTA click emituje subscribe event.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: bind-toggle-event

## Scene: bind-toggle-event-scene

narration:
Toggle click menja billing atribut. Guard sprečava dvostruki binding.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: unbind-events

## Scene: unbind-events-scene

narration:
Cleanup metoda za oba listenera.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: unbind-cta-event

## Scene: unbind-cta-event-scene

narration:
Proveri flag pre skidanja — izbjagava grešku na disconnect bez prethodnog bind-a.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: unbind-toggle-event

## Scene: unbind-toggle-event-scene

narration:
Isti pattern: flag check, remove, reset.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: handle-cta-click

## Scene: handle-cta-click-scene

narration:
CTA handler emituje namespaced event.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: handle-cta-click-event

## Scene: handle-cta-click-event-scene

narration:
Emitujemo `ui-pricing-card:subscribe` sa `{tier, price, billing, ctaLabel, source}` detail-om.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: handle-toggle-click

## Scene: handle-toggle-click-scene

narration:
Klik na toggle menja billing sa monthly na yearly (ili obrnuto). Setter upisuje atribut → attributeChangedCallback → updatePrice + updateToggleState.

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
Proveravamo da li je element već registrovan.

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
`customElements.define("ui-pricing-card", UiPricingCard)` — pricing kartica je spremna.

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
Dodajemo tanak helper outline za `.app-shell` i držimo ga do završnog shell rezimea.

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
Padding drži scenu urednom.

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
Grid pravi jedinstven host za pricing card.

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
Centar drži fokus na jednom pricing card-u.

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
Puna visina drži tamnu pozadinu stabilnom.

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
Tamna pozadina naglašava SaaS pricing card.

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
Dodajemo host helper outline i držimo ga do završnog rezimea.

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
Block display pravi stabilan footprint.

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
Širina pricing card-a ostaje ograničena i predvidiva.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-position

## Scene: host-position-scene

narration:
Relative za popular state i buduće overlay-e.

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
Surface token vodi pozadinu card-a.

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
Alternativna površina zatvara gradijent.

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
Border token drži ivice nežnim.

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
Accent token vodi CTA, badge i tier boju.

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
Jači accent zatvara CTA gradijent.

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
Text token čuva kontrast.

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
Muted token pokriva sekundarne labele.

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
Shadow je javni token, ne interni magic number.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-popular-glow-token

## Scene: host-popular-glow-token-scene

narration:
Popular glow token priprema highlight efekat za istaknutu karticu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: tier-starter-accent

## Scene: tier-starter-accent-scene

narration:
Starter tier dobija ljubičasti accent.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: tier-starter-accent-strong

## Scene: tier-starter-accent-strong-scene

narration:
Jači ljubičasti ton za CTA gradijent.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: tier-pro-accent

## Scene: tier-pro-accent-scene

narration:
Pro tier koristi default sky blue accent.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: tier-pro-accent-strong

## Scene: tier-pro-accent-strong-scene

narration:
Jači blue ton za pro CTA.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: tier-enterprise-accent

## Scene: tier-enterprise-accent-scene

narration:
Enterprise tier dobija amber accent.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: tier-enterprise-accent-strong

## Scene: tier-enterprise-accent-strong-scene

narration:
Jači amber ton za enterprise CTA.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: popular-host-shadow

## Scene: popular-host-shadow-scene

narration:
Popular kartica dobija glow efekat.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: popular-host-transform

## Scene: popular-host-transform-scene

narration:
Blagi scale ističe popularnu opciju.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: popular-host-z-index

## Scene: popular-host-z-index-scene

narration:
Z-index drži popularnu karticu iznad susednih u grid-u.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-vs-shadow-styles

## Scene: host-vs-shadow-styles-scene

narration:
Host CSS je definisao token contract, tier accent varijante i popular state highlight. Shadow CSS sada stilizuje card internals: badge, cenu, toggle switch, feature listu, CTA i urgency timer. Toggle vizuelni efekat dolazi iz `:host([billing="yearly"])` selectora — CSS automatski reaguje na atribut.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: shadow-host-display

## Scene: shadow-host-display-scene

narration:
Shadow host potvrđuje block model iznutra.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: shadow-host-font-family

## Scene: shadow-host-font-family-scene

narration:
Font stack je interni shadow contract.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: shadow-host-color

## Scene: shadow-host-color-scene

narration:
Boja čita spoljašnji text token.

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
Dodajemo helper outline za card blok.

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
Card koristi grid za vertikalni stack svih zona.

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
Gap odvaja badge, tier, cenu, toggle, feature listu i CTA.

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
Padding pravi pravi card footprint.

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
Zaobljenje daje modernu siluetu.

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
Border čita host token.

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
Card pozadina čita host surface tokene.

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
Shadow dolazi iz host contract-a.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: card-text-align

## Scene: card-text-align-scene

narration:
Card sadržaj se centrira.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-outline

## Scene: badge-outline-scene

narration:
Dodajemo helper outline za popular badge.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-display

## Scene: badge-display-scene

narration:
Badge je sakriveno po defaultu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-padding

## Scene: badge-padding-scene

narration:
Padding pravi pill footprint.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-radius

## Scene: badge-radius-scene

narration:
Veliki radius pravi kapsulu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-background

## Scene: badge-background-scene

narration:
Badge pozadina čita tier accent tokene.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-color

## Scene: badge-color-scene

narration:
Beli tekst drži kontrast.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-font-size

## Scene: badge-font-size-scene

narration:
Mali font čini badge kompaktnim.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-font-weight

## Scene: badge-font-weight-scene

narration:
Bold drži badge labelu čitkom.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-letter-spacing

## Scene: badge-letter-spacing-scene

narration:
Tracking drži badge urednim.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-text-transform

## Scene: badge-text-transform-scene

narration:
Uppercase za badge kategorijsku labelu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-width

## Scene: badge-width-scene

narration:
Širina samo za sadržaj.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-justify-self

## Scene: badge-justify-self-scene

narration:
Centriramo badge horizontalno.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-popular-display

## Scene: badge-popular-display-scene

narration:
Kada je popular atribut prisutan, badge postaje vidljiv.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: badge-slotted-font

## Scene: badge-slotted-font-scene

narration:
Slotovani badge sadržaj nasleđuje font.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tier-name-margin

## Scene: tier-name-margin-scene

narration:
Brišemo podrazumevani heading margin.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tier-name-font-size

## Scene: tier-name-font-size-scene

narration:
Tier ime dobija kompaktnu veličinu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tier-name-font-weight

## Scene: tier-name-font-weight-scene

narration:
Bold drži tier ime jasnim.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tier-name-text-transform

## Scene: tier-name-text-transform-scene

narration:
Uppercase pojačava hijerarhiju.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tier-name-letter-spacing

## Scene: tier-name-letter-spacing-scene

narration:
Tracking za tier labelu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tier-name-color

## Scene: tier-name-color-scene

narration:
Tier ime čita accent token — menja se sa tier variantom.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-outline

## Scene: price-outline-scene

narration:
Dodajemo helper outline za price blok.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-display

## Scene: price-display-scene

narration:
Flex pravi horizontalni raspored valuta/iznos/period.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-align

## Scene: price-align-scene

narration:
Baseline poravnavanje drži $ i /mo uz velik iznos.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-justify

## Scene: price-justify-scene

narration:
Centriramo cenu horizontalno.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-gap

## Scene: price-gap-scene

narration:
Minimalni gap između delova cene.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-currency-font-size

## Scene: price-currency-font-size-scene

narration:
Valuta dobija manji ali jasno vidljiv font.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-currency-font-weight

## Scene: price-currency-font-weight-scene

narration:
Bold za valutu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-currency-color

## Scene: price-currency-color-scene

narration:
Valuta čita muted token.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-amount-font-size

## Scene: price-amount-font-size-scene

narration:
Velika veličina dominira karticom.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-amount-font-weight

## Scene: price-amount-font-weight-scene

narration:
Extra bold naglašava cenu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-amount-line-height

## Scene: price-amount-line-height-scene

narration:
Line-height drži broj zategnutim.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-amount-transition

## Scene: price-amount-transition-scene

narration:
Tranzicija omogućava future animaciju pri promeni.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-period-font-size

## Scene: price-period-font-size-scene

narration:
Period je sekundaran.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-period-color

## Scene: price-period-color-scene

narration:
Period čita muted token.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: price-period-font-weight

## Scene: price-period-font-weight-scene

narration:
Medium weight za period.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-outline

## Scene: toggle-outline-scene

narration:
Dodajemo helper outline za billing toggle.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-display

## Scene: toggle-display-scene

narration:
Flex slaže labele i switch horizontalno.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-align

## Scene: toggle-align-scene

narration:
Centriramo elemente vertikalno.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-justify

## Scene: toggle-justify-scene

narration:
Centriramo ceo toggle.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-gap

## Scene: toggle-gap-scene

narration:
Gap odvaja labele od switch-a.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-label-font-size

## Scene: toggle-label-font-size-scene

narration:
Kompaktan font za toggle labele.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-label-color

## Scene: toggle-label-color-scene

narration:
Muted boja za neupadljivost.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-label-font-weight

## Scene: toggle-label-font-weight-scene

narration:
Medium weight za labele.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-label-transition

## Scene: toggle-label-transition-scene

narration:
Tranzicija za smooth promenu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-switch-appearance

## Scene: toggle-switch-appearance-scene

narration:
Gasimo native izgled.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-switch-width

## Scene: toggle-switch-width-scene

narration:
Switch širina.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-switch-height

## Scene: toggle-switch-height-scene

narration:
Switch visina.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-switch-radius

## Scene: toggle-switch-radius-scene

narration:
Zaobljenje za pill oblik.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-switch-border

## Scene: toggle-switch-border-scene

narration:
Uklanjamo border.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-switch-background

## Scene: toggle-switch-background-scene

narration:
Neutralna toggle pozadina — menja se na yearly.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-switch-cursor

## Scene: toggle-switch-cursor-scene

narration:
Pointer kursor za klikabilnost.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-switch-position

## Scene: toggle-switch-position-scene

narration:
Relative za knob pozicioniranje.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-switch-padding

## Scene: toggle-switch-padding-scene

narration:
Padding oko knob-a.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-switch-transition

## Scene: toggle-switch-transition-scene

narration:
Glatki prelaz pozadine.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-knob-display

## Scene: toggle-knob-display-scene

narration:
Block za knob.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-knob-width

## Scene: toggle-knob-width-scene

narration:
Knob veličina.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-knob-height

## Scene: toggle-knob-height-scene

narration:
Visina jednaka širini.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-knob-radius

## Scene: toggle-knob-radius-scene

narration:
Kružni knob.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-knob-background

## Scene: toggle-knob-background-scene

narration:
Beli knob.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-knob-transition

## Scene: toggle-knob-transition-scene

narration:
Glatki prelaz pozicije.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-yearly-bg

## Scene: toggle-yearly-bg-scene

narration:
Na yearly, switch postaje accent boja.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: toggle-yearly-knob

## Scene: toggle-yearly-knob-scene

narration:
Knob se pomera desno na yearly.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: save-badge-font-size

## Scene: save-badge-font-size-scene

narration:
Save badge je mali ali upadljiv.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: save-badge-background

## Scene: save-badge-background-scene

narration:
Zelena pozadina signalizira uštedu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: save-badge-color

## Scene: save-badge-color-scene

narration:
Zeleni tekst za save signal.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: save-badge-padding

## Scene: save-badge-padding-scene

narration:
Mali padding.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: save-badge-radius

## Scene: save-badge-radius-scene

narration:
Blago zaobljenje.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: save-badge-font-weight

## Scene: save-badge-font-weight-scene

narration:
Bold za isticanje.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: features-outline

## Scene: features-outline-scene

narration:
Dodajemo helper outline za feature listu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: features-padding

## Scene: features-padding-scene

narration:
Vertikalni padding za feature zonu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: features-slotted-list-style

## Scene: features-slotted-list-style-scene

narration:
Brišemo bullet-e.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: features-slotted-margin

## Scene: features-slotted-margin-scene

narration:
Brišemo default margin.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: features-slotted-padding

## Scene: features-slotted-padding-scene

narration:
Brišemo default padding.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: features-slotted-display

## Scene: features-slotted-display-scene

narration:
Grid za feature listu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: features-slotted-gap

## Scene: features-slotted-gap-scene

narration:
Razmak između feature stavki.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: features-slotted-text-align

## Scene: features-slotted-text-align-scene

narration:
Feature stavke su levo poravnate.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: features-slotted-font-size

## Scene: features-slotted-font-size-scene

narration:
Kompaktan font za feature listu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: features-slotted-color

## Scene: features-slotted-color-scene

narration:
Feature tekst čita muted token.

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
Dodajemo helper outline za CTA dugme.

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
Gasimo native button izgled.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-width

## Scene: cta-width-scene

narration:
CTA zauzima punu širinu.

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
Padding pravi klik zonu.

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
Brišemo border.

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
Zaobljeno dugme.

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
CTA gradijent čita tier tokene — menja se sa varijantom.

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
Beli tekst za kontrast.

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
Preuzima font.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: cta-font-size

## Scene: cta-font-size-scene

narration:
Solidna veličina za action.

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
Bold za jasnoću.

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
Kursor potvrđuje interakciju.

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
Tranzicije za glatki response.

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
CTA shadow dodaje dubinu.

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
Na hover blago podižemo svetlinu.

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
Blagi lift na hover.

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
Na active vraćamo dugme.

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
Focus ring za tastatursku navigaciju.

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
Offset odvaja ring od dugmeta.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: urgency-outline

## Scene: urgency-outline-scene

narration:
Dodajemo helper outline za urgency timer zonu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: urgency-display

## Scene: urgency-display-scene

narration:
Flex slaže ikonu i tekst.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: urgency-align

## Scene: urgency-align-scene

narration:
Centriramo vertikalno.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: urgency-justify

## Scene: urgency-justify-scene

narration:
Centriramo horizontalno.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: urgency-gap

## Scene: urgency-gap-scene

narration:
Gap između ikone i teksta.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: urgency-font-size

## Scene: urgency-font-size-scene

narration:
Kompaktan font.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: urgency-color

## Scene: urgency-color-scene

narration:
Narandžasta boja za urgency signal.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: urgency-font-weight

## Scene: urgency-font-weight-scene

narration:
Semi-bold za urgentnost.

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
Uklanjamo card helper outline.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: badge-summary

## Scene: badge-summary-scene

narration:
Uklanjamo badge helper outline.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: price-summary

## Scene: price-summary-scene

narration:
Uklanjamo price helper outline.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: toggle-summary

## Scene: toggle-summary-scene

narration:
Uklanjamo billing toggle helper outline.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: features-summary

## Scene: features-summary-scene

narration:
Uklanjamo feature list helper outline.

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
Uklanjamo CTA helper outline.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: urgency-summary

## Scene: urgency-summary-scene

narration:
Uklanjamo urgency timer helper outline.

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
Uklanjamo host helper outline.

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
Uklanjamo shell helper outline.

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
`ui-pricing-card` je završen: `index.html` deklarativno koristi tier/price/popular atribute i feature slot, `ui-pricing-card.template.js` drži shadow strukturu, `ui-pricing-card.js` vodi property API, billing toggle, urgency timer i subscribe event, `style.css` theme-uje host sa tier varijantama, a `ui-pricing-card.shadow.css` drži unutrašnji styling sa toggle animacijom.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom
