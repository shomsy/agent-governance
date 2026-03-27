---
schemaVersion: 1
lessonId: 07-build-ui-user-avatar
steps:
  - stepId: empty-shell
    title: "Start: Empty App Shell"
    summary: Počinjemo od praznog `.app-shell` prostora. Dashboard widget živi u neutralnom host okruženju.
    intent: Enterprise widget mora da radi u bilo kom host kontekstu, ne samo u specijalnoj demo sceni.
    tag: html:app-shell
    proTip: Enterprise widget mora da radi u bilo kom host kontekstu, ne samo u specijalnoj demo sceni.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: component-html
    title: "HTML: ui-user-avatar Host"
    summary: Dodajemo `<ui-user-avatar>` sa `username` i `role` atributima. Tag odmah govori šta ovaj widget jeste.
    intent: "Domain-driven naming je prvi enterprise signal: ime taga mora da sugeriše business ulogu komponente."
    tag: html:ui-user-avatar
    proTip: "Domain-driven naming je prvi enterprise signal: ime taga mora da sugeriše business ulogu komponente."
    focusHtmlNeedles: []
  - stepId: status-attribute-html
    title: 'HTML: status="online"'
    summary: Dodajemo `status="online"` i uvodimo deklarativni status API. Status je deo HTML contract-a, ne JavaScript stanja.
    intent: Declarative status API znači da tim može da promeni status jedino pisanjem atributa, bez znanja o internim detaljima.
    tag: html:status
    proTip: Declarative status API znači da tim može da promeni status jedino pisanjem atributa, bez znanja o internim detaljima.
    focusHtmlNeedles: []
  - stepId: profile-url-attribute-html
    title: "HTML: profile-url atribut"
    summary: Dodajemo `profile-url` koji ide u event payload pri kliku. Komponenta ne navigira sama.
    intent: Enterprise komponenta emituje event sa payload-om. Ko otvori modal ili navigira — to odlučuje parent, ne komponenta.
    tag: html:profile-url
    proTip: Enterprise komponenta emituje event sa payload-om. Ko otvori modal ili navigira — to odlučuje parent, ne komponenta.
    focusHtmlNeedles: []
  - stepId: initials-slot-html
    title: "HTML: Named Slot — initials"
    summary: Dodajemo `<span slot="initials">AP</span>`. Slot je javna API površina za inicijale ili sliku.
    intent: Named slot dozvoljava parent-u da pošalje custom sadržaj. Komponenta ne zna šta je inicijal ili avatar image — samo pravi prostor.
    tag: html:slot-initials
    proTip: Named slot dozvoljava parent-u da pošalje custom sadržaj. Komponenta ne zna šta je inicijal ili avatar image — samo pravi prostor.
    focusHtmlNeedles: []
  - stepId: tooltip-slot-html
    title: "HTML: Named Slot — tooltip"
    summary: Dodajemo `<span slot="tooltip">` sa punim contextualnim opisom član tima. Tooltip sadržaj kontroliše parent.
    intent: Tooltip je drugi named slot. Sadržaj može biti plain tekst, HTML, pa i keyboard shortcut — komponenta drži samo posuda.
    tag: html:slot-tooltip
    proTip: Tooltip je drugi named slot. Sadržaj može biti plain tekst, HTML, pa i keyboard shortcut — komponenta drži samo posuda.
    focusHtmlNeedles: []
  - stepId: avatar-widget-contract
    title: "Teaching Moment: Dashboard Widget Contract"
    summary: "Ovaj widget ima četiri javna atributa: `username`, `role`, `status`, `profile-url`. Ima dva named slota: `initials` i `tooltip`. Emituje jedan namespaced event: `ui-user-avatar:profile-open`. Nema internog routing-a i nema opisivanja šta parent treba da uradi."
    intent: Enterprise widget API treba da bude uzan, predvidiv i dokumentovan kao javni contract.
    tag: teaching:avatar-widget-contract
    proTip: Enterprise widget API treba da bude uzan, predvidiv i dokumentovan kao javni contract.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: template-html-declaration
    title: "Template JS: Shadow DOM struktura"
    summary: "U `ui-user-avatar.template.js` definiše `templateHtml`: avatar-container, avatar-image sa slot za inicijale, status-badge, avatar-info sa username i role spanovima, i tooltip sa named slotom."
    intent: Template modul nosi samo strukturu. Nema lifecycle-a, nema eventa, nema podataka.
    tag: template-js:template-html-declaration
    proTip: Template modul nosi samo strukturu. Nema lifecycle-a, nema eventa, nema podataka.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: template-element-export
    title: "Template JS: Eksportujemo template element"
    summary: Kreiramo `uiUserAvatarTemplate`, dodajemo `<link>` ka shadow CSS fajlu i ubrizgavamo `${templateHtml}`.
    intent: Template zna za markup i stylesheet ulaz. Klasa ga samo klonira — nikad rekreira.
    tag: template-js:template-element-export
    proTip: Template zna za markup i stylesheet ulaz. Klasa ga samo klonira — nikad rekreira.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: import-template
    title: "JS: Uvozimo template modul"
    summary: Behavior fajl uvozi `uiUserAvatarTemplate` iz template modula. Klasa ne gradi HTML stringove.
    intent: "Ovo je prva jasna granica: class i template su odvojeni fajlovi sa odvojenim odgovornostima."
    tag: js:import-template
    proTip: "Ovo je prva jasna granica: class i template su odvojeni fajlovi sa odvojenim odgovornostima."
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: class-declaration
    title: "JS: UiUserAvatar extends HTMLElement"
    summary: Klasa nosi domain-driven ime, konzistentno sa tagom.
    intent: "Class ime i tag treba da pričaju istu priču: `ui-user-avatar` → `UiUserAvatar`."
    tag: js:class-declaration
    proTip: "Class ime i tag treba da pričaju istu priču: `ui-user-avatar` → `UiUserAvatar`."
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: observed-attributes
    title: "JS: observedAttributes — sva četiri"
    summary: Komponenta prati `username`, `role`, `status` i `profile-url` — tačno onoliko koliko je deklarirano kao javni API.
    intent: Observed attributes su spoljašnji declarative API ulaz. Ne pratimo ništa što nije javno.
    tag: js:observed-attributes
    proTip: Observed attributes su spoljašnji declarative API ulaz. Ne pratimo ništa što nije javno.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: constructor-shadow
    title: "JS: constructor otvara shadow root"
    summary: "Konstruktor samo priprema instancu: shadow root, bind i nulte reference."
    intent: Konstruktor ne radi lifecycle posao. Ne radi render, ne čita DOM, ne zakačuje evente.
    tag: js:constructor-shadow
    proTip: Konstruktor ne radi lifecycle posao. Ne radi render, ne čita DOM, ne zakačuje evente.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: constructor-bind
    title: "JS: constructor pre-binduje click handler"
    summary: Vezujemo `handleAvatarClick` jednom, pri kreiranju instance.
    intent: Pre-bind osigurava stabilan event cleanup — isti objekat koji dodajemo možemo sigurno da uklonimo.
    tag: js:constructor-bind
    proTip: Pre-bind osigurava stabilan event cleanup — isti objekat koji dodajemo možemo sigurno da uklonimo.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: constructor-state
    title: "JS: constructor priprema interne reference"
    summary: Nulujemo DOM reference i state flag za click binding.
    intent: Interno stanje ostaje transparentno i predvidivo od prvog reda.
    tag: js:constructor-state
    proTip: Interno stanje ostaje transparentno i predvidivo od prvog reda.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: connected-callback
    title: "JS: connectedCallback — lifestyle ulaz"
    summary: Connected lifecycle je glavni ulaz kada widget uđe u živi DOM.
    intent: Sve što zavisi od živog DOM-a ide u connectedCallback, ne u constructor.
    tag: js:connected-callback
    proTip: Sve što zavisi od živog DOM-a ide u connectedCallback, ne u constructor.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: connected-callback-setup
    title: "JS: connectedCallback poziva setupTemplateOnce"
    summary: Prvo jednom montiramo template u shadow root.
    intent: Mount i cache imaju odvojene metode i odvojene odgovornosti.
    tag: js:connected-callback-setup
    proTip: Mount i cache imaju odvojene metode i odvojene odgovornosti.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: connected-callback-cache
    title: "JS: connectedCallback poziva cacheDom"
    summary: Kad template postoji, keširamo DOM reference.
    intent: query selector radi samo jednom — reference žive na instanci.
    tag: js:connected-callback-cache
    proTip: query selector radi samo jednom — reference žive na instanci.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: connected-callback-sync
    title: "JS: connectedCallback sinhronizuje atribute"
    summary: Pozivamo `syncFromAttributes()` kao prvi ciljani render pass.
    intent: Ovo nije opšti render — to je skup uskih update metoda koje inicijalizuju tačno ono što treba.
    tag: js:connected-callback-sync
    proTip: Ovo nije opšti render — to je skup uskih update metoda koje inicijalizuju tačno ono što treba.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: setup-template-once
    title: "JS: setupTemplateOnce()"
    summary: Template mount dobija sopstvenu metodu.
    intent: "Jasno ime kaže: montira se jednom, ne na svaki connectedCallback."
    tag: js:setup-template-once
    proTip: "Jasno ime kaže: montira se jednom, ne na svaki connectedCallback."
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: setup-template-once-guard
    title: "JS: guard sprečava dupliranje"
    summary: Kloniramo template samo ako shadow root nema child node-ova.
    intent: Reconnect scenariji moraju biti boring — bez dupliranja DOM-a.
    tag: js:setup-template-once-guard
    proTip: Reconnect scenariji moraju biti boring — bez dupliranja DOM-a.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: cache-dom
    title: "JS: cacheDom — samo kešira reference"
    summary: cacheDom ne montira template i ne radi render. Samo pronalazi reference ako ne postoje.
    intent: "Ime i ponašanje su usklađeni: cache znači pamti referencu, ne gradi DOM."
    tag: js:cache-dom
    proTip: "Ime i ponašanje su usklađeni: cache znači pamti referencu, ne gradi DOM."
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: cache-dom-username
    title: "JS: cacheDom kešira .username element"
    summary: Username span čuvamo jednom da updateUsername ne mora da radi query pri svakoj promeni.
    intent: DOM query jednom; update metode rade nad čuvanom referencom.
    tag: js:cache-dom-username
    proTip: DOM query jednom; update metode rade nad čuvanom referencom.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: cache-dom-role
    title: "JS: cacheDom kešira .role element"
    summary: Role span čuvamo na isti način.
    intent: Svaki DOM element koji menjamo kešira se pojedinačno i eksplicitno.
    tag: js:cache-dom-role
    proTip: Svaki DOM element koji menjamo kešira se pojedinačno i eksplicitno.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: cache-dom-status-badge
    title: "JS: cacheDom kešira .status-badge"
    summary: Status badge element čuvamo za aria-label update.
    intent: I elementi koji ne menjaju textContent treba da budu keširani ako ih update metode diraju.
    tag: js:cache-dom-status-badge
    proTip: I elementi koji ne menjaju textContent treba da budu keširani ako ih update metode diraju.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: sync-from-attributes
    title: "JS: syncFromAttributes()"
    summary: Centralna one-time inicijalizacija koja propagira sve atribute u DOM na prvom connect-u.
    intent: Ovo nije opšti render; to je orchestration metoda koja zove uske update metode.
    tag: js:sync-from-attributes
    proTip: Ovo nije opšti render; to je orchestration metoda koja zove uske update metode.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: sync-from-attributes-calls
    title: "JS: sync poziva sva tri updatera"
    summary: Pozivamo `updateUsername()`, `updateRole()` i `updateStatus()` pri inicijalnom connect-u.
    intent: Svaki poziv je uski i odvojen — lako se testira i debuguje individualno.
    tag: js:sync-from-attributes-calls
    proTip: Svaki poziv je uski i odvojen — lako se testira i debuguje individualno.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: update-username
    title: "JS: updateUsername()"
    summary: Username element dobija tačno ono što property API vrati.
    intent: "Jedna metoda, jedna odgovornost: piše username u DOM."
    tag: js:update-username
    proTip: "Jedna metoda, jedna odgovornost: piše username u DOM."
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: update-role
    title: "JS: updateRole()"
    summary: Role element ažuriramo kroz istu usku metodu.
    intent: Svaki tekstualni DOM element ima svoju update metodu.
    tag: js:update-role
    proTip: Svaki tekstualni DOM element ima svoju update metodu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: update-status
    title: "JS: updateStatus()"
    summary: Status badge dobija ažuriranu aria-label iz `statusAriaLabel` mape.
    intent: Status vizuelna promena se dešava kroz CSS token — JS samo drži aria accessibility u sinhronizaciji.
    tag: js:update-status
    proTip: Status vizuelna promena se dešava kroz CSS token — JS samo drži aria accessibility u sinhronizaciji.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: define-guard
    title: "JS: guard pre registracije"
    summary: Proveravamo da li je element već registrovan pre `customElements.define()`.
    intent: Hot reload i SSR scenariji ne smeju bacati grešku pri ponovnoj evaluaciji modula.
    tag: js:define-guard
    proTip: Hot reload i SSR scenariji ne smeju bacati grešku pri ponovnoj evaluaciji modula.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: define-element
    title: "JS: registrujemo ui-user-avatar"
    summary: 'Komponenta je registrovana: `customElements.define("ui-user-avatar", UiUserAvatar)`.'
    intent: Od ovog momenta svaki `<ui-user-avatar>` u DOM-u dobija pun lifecycle i API.
    tag: js:define-element
    proTip: Od ovog momenta svaki `<ui-user-avatar>` u DOM-u dobija pun lifecycle i API.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: shell-outline
    title: "CSS: .app-shell / outline"
    summary: Dodajemo tanak helper outline za `.app-shell` i držimo ga do završnog shell rezimea.
    intent: App shell ostaje neutralna pozornica za enterprise dashboard widget.
    tag: css:shell-outline
    proTip: App shell ostaje neutralna pozornica za enterprise dashboard widget.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: shell-padding
    title: "CSS: .app-shell / padding"
    summary: Breathing prostor drži scenu urednom.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:shell-padding
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: shell-display
    title: "CSS: .app-shell / display"
    summary: Grid pravi jedinstven container za widget.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:shell-display
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: shell-place-items
    title: "CSS: .app-shell / place-items"
    summary: Widget treba da bude centriran u demo sceni.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:shell-place-items
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: shell-gap
    title: "CSS: .app-shell / gap"
    summary: Gap priprema prostor za eventualni drugi avatar.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:shell-gap
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: shell-min-height
    title: "CSS: .app-shell / min-height"
    summary: Puna visina drži dark pozadinu stabilnom.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:shell-min-height
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: shell-background
    title: "CSS: .app-shell / background"
    summary: Tamna pozadina naglašava avatar widget.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:shell-background
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: host-outline
    title: "CSS: ui-user-avatar / outline"
    summary: Dodajemo host helper outline i držimo ga do završnog host rezimea.
    intent: Host je javni contract surface; outline pomaže orijentaciji.
    tag: css:host-outline
    proTip: Host je javni contract surface; outline pomaže orijentaciji.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: host-display
    title: "CSS: ui-user-avatar / display"
    summary: Avatar ostaje kompaktan inline-block element.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:host-display
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: host-position
    title: "CSS: ui-user-avatar / position"
    summary: Pozicija pravi stacking kontekst za tooltip.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:host-position
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: host-cursor
    title: "CSS: ui-user-avatar / cursor"
    summary: Avatar je klikabilna zona — cursor to mora jasno da kaže.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:host-cursor
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: host-surface-token
    title: "CSS: ui-user-avatar / --avatar-surface"
    summary: "Počinjemo token contract: površina je spolja theme-ovana."
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:host-surface-token
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: host-surface-alt-token
    title: "CSS: ui-user-avatar / --avatar-surface-alt"
    summary: Alternativna površina drži gradijent konzistentnim.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:host-surface-alt-token
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: host-accent-token
    title: "CSS: ui-user-avatar / --avatar-accent"
    summary: Accent token vodi boju avatara i detalja.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:host-accent-token
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: host-text-token
    title: "CSS: ui-user-avatar / --avatar-text"
    summary: Text token čuva kontrast u celom widgetu.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:host-text-token
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: host-muted-token
    title: "CSS: ui-user-avatar / --avatar-muted"
    summary: Muted token pokriva role i sekundarne labele.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:host-muted-token
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: host-border-token
    title: "CSS: ui-user-avatar / --avatar-border"
    summary: Border token drži ivice neagresivnim na tamnoj pozadini.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:host-border-token
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: host-shadow-token
    title: "CSS: ui-user-avatar / --avatar-shadow"
    summary: Shadow token ide kao javni contract, ne internu magiju.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:host-shadow-token
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: host-status-color-token
    title: "CSS: ui-user-avatar / --avatar-status-color"
    summary: Status boja je javni host token — variants ga samo prepišu.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:host-status-color-token
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: variant-online-status-color
    title: 'CSS: ui-user-avatar[status="online"] / --avatar-status-color'
    summary: Online status dobija zeleni signal.
    intent: Variants idu spolja, ne unutar shadow CSS-a.
    tag: css:variant-online-status-color
    proTip: Variants idu spolja, ne unutar shadow CSS-a.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status="online"
  - stepId: variant-idle-status-color
    title: 'CSS: ui-user-avatar[status="idle"] / --avatar-status-color'
    summary: Idle dobija žuti signal.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:variant-idle-status-color
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status="idle"
  - stepId: variant-away-status-color
    title: 'CSS: ui-user-avatar[status="away"] / --avatar-status-color'
    summary: Away dobija narandžasti signal.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:variant-away-status-color
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status="away"
  - stepId: variant-offline-status-color
    title: 'CSS: ui-user-avatar[status="offline"] / --avatar-status-color'
    summary: Offline dobija sivi, neutralni signal.
    intent: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    tag: css:variant-offline-status-color
    proTip: Host CSS drži spoljašnji theme, status variants i token contract na samom custom elementu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status="offline"
  - stepId: host-vs-shadow-styles
    title: "Teaching Moment: Token styling contract"
    summary: Host CSS drži token kontrakt i status variants. Svaka promena statusa menja samo `--avatar-status-color` token — bez diranja shadow internals. Sledeći koraci prelaze u `ui-user-avatar.shadow.css`.
    intent: "Ovde je granica: host/theme/variants spolja, widget internals unutra."
    tag: teaching:host-vs-shadow-styles
    proTip: "Ovde je granica: host/theme/variants spolja, widget internals unutra."
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: shadow-host-display
    title: "Shadow CSS: :host / display"
    summary: Shadow host potvrđuje inline-block model iznutra.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:shadow-host-display
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: shadow-host-font-family
    title: "Shadow CSS: :host / font-family"
    summary: Font stack ostaje interni shadow contract.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:shadow-host-font-family
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: shadow-host-color
    title: "Shadow CSS: :host / color"
    summary: Boja čita spoljašnji text token.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:shadow-host-color
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: container-outline
    title: "Shadow CSS: .avatar-container / outline"
    summary: Dodajemo helper outline za avatar container.
    intent: Container drži sve vizuelne delove avatara na jednom mestu.
    tag: shadow-css:container-outline
    proTip: Container drži sve vizuelne delove avatara na jednom mestu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: container-position
    title: "Shadow CSS: .avatar-container / position"
    summary: Relative pozicija pravi stacking kontekst za status badge i tooltip.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:container-position
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: container-display
    title: "Shadow CSS: .avatar-container / display"
    summary: Flex pravi vertikalni stack avatar delova.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:container-display
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: container-direction
    title: "Shadow CSS: .avatar-container / flex-direction"
    summary: Kolona slaže sliku, info i tooltip vertikalno.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:container-direction
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: container-align
    title: "Shadow CSS: .avatar-container / align-items"
    summary: Sve celine se centriraju horizontalno.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:container-align
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: container-gap
    title: "Shadow CSS: .avatar-container / gap"
    summary: Gap drži rastojanje između slike i info zone.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:container-gap
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-outline
    title: "Shadow CSS: .avatar-image / outline"
    summary: Dodajemo helper outline za avatar sliku.
    intent: Avatar krug je centralni vizuelni element widgeta.
    tag: shadow-css:image-outline
    proTip: Avatar krug je centralni vizuelni element widgeta.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-position
    title: "Shadow CSS: .avatar-image / position"
    summary: Relative pravi stacking kontekst za absolutni status badge.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-position
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-width
    title: "Shadow CSS: .avatar-image / width"
    summary: Avatar krug dobija standardnu veličinu.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-width
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-height
    title: "Shadow CSS: .avatar-image / height"
    summary: Visina odgovara širini — idemo ka krugu.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-height
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-radius
    title: "Shadow CSS: .avatar-image / border-radius"
    summary: Puni radius završava avatar krug.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-radius
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-background
    title: "Shadow CSS: .avatar-image / background"
    summary: Gradijent pozadina koja se vidi iza inicijala.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-background
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-border
    title: "Shadow CSS: .avatar-image / border"
    summary: Border čita host token.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-border
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-shadow
    title: "Shadow CSS: .avatar-image / box-shadow"
    summary: Shadow dolazi iz host contract-a.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-shadow
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-display
    title: "Shadow CSS: .avatar-image / display"
    summary: Flex centrira inicijale unutar kruga.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-display
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-align
    title: "Shadow CSS: .avatar-image / align-items"
    summary: Vertikalno centriranje inicijala.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-align
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-justify
    title: "Shadow CSS: .avatar-image / justify-content"
    summary: Horizontalno centriranje inicijala.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-justify
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-overflow
    title: "Shadow CSS: .avatar-image / overflow"
    summary: Overflow hidden reže bilo koji sadržaj van kruga.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-overflow
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-transition
    title: "Shadow CSS: .avatar-image / transition"
    summary: Tranzicija pravi glatki hover lift.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-transition
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-hover-transform
    title: "Shadow CSS: .avatar-image:hover / transform"
    summary: Blagi scale na hover daje interaktivni feel.
    intent: Hover treba da potvrdi klikabilnost.
    tag: shadow-css:image-hover-transform
    proTip: Hover treba da potvrdi klikabilnost.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-hover-shadow
    title: "Shadow CSS: .avatar-image:hover / box-shadow"
    summary: Accent shadow na hover potvrđuje interakciju.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:image-hover-shadow
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: initials-font-size
    title: 'Shadow CSS: ::slotted([slot="initials"]) / font-size'
    summary: Inicijali dobijaju jasnu veličinu unutar kruga.
    intent: Named slot je javna API površina — stilizujemo ga unutar shadow konteksta.
    tag: shadow-css:initials-font-size
    proTip: Named slot je javna API površina — stilizujemo ga unutar shadow konteksta.
    focusHtmlNeedles:
      - slot="initials"
      - <ui-user-avatar
  - stepId: initials-font-weight
    title: 'Shadow CSS: ::slotted([slot="initials"]) / font-weight'
    summary: Jaki bold drži inicijale čitkim.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:initials-font-weight
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - slot="initials"
      - <ui-user-avatar
  - stepId: initials-color
    title: 'Shadow CSS: ::slotted([slot="initials"]) / color'
    summary: Beli tekst drži kontrast na gradijent pozadini.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:initials-color
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - slot="initials"
      - <ui-user-avatar
  - stepId: initials-letter-spacing
    title: 'Shadow CSS: ::slotted([slot="initials"]) / letter-spacing'
    summary: Mali tracking poboljšava čitljivost.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:initials-letter-spacing
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - slot="initials"
      - <ui-user-avatar
  - stepId: initials-select
    title: 'Shadow CSS: ::slotted([slot="initials"]) / user-select'
    summary: Inicijali ne treba da budu selektabilni.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:initials-select
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - slot="initials"
      - <ui-user-avatar
  - stepId: status-outline
    title: "Shadow CSS: .status-badge / outline"
    summary: Dodajemo helper outline za status badge.
    intent: Status badge je mali ali kritičan signal widgeta.
    tag: shadow-css:status-outline
    proTip: Status badge je mali ali kritičan signal widgeta.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status=
  - stepId: status-position
    title: "Shadow CSS: .status-badge / position"
    summary: Absolute ga pozicionira unutar avatar tipa.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:status-position
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status=
  - stepId: status-bottom
    title: "Shadow CSS: .status-badge / bottom"
    summary: Pozicioniramo badge u donji desni ugao.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:status-bottom
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status=
  - stepId: status-right
    title: "Shadow CSS: .status-badge / right"
    summary: Desno od centra, standardna pozicija status badge-a.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:status-right
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status=
  - stepId: status-width
    title: "Shadow CSS: .status-badge / width"
    summary: Mali kružić.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:status-width
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status=
  - stepId: status-height
    title: "Shadow CSS: .status-badge / height"
    summary: Visina odgovara širini.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:status-height
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status=
  - stepId: status-radius
    title: "Shadow CSS: .status-badge / border-radius"
    summary: Puni radius završava status krug.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:status-radius
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status=
  - stepId: status-background
    title: "Shadow CSS: .status-badge / background"
    summary: Boja čita host status token — nikad hardkodovana iznutra.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:status-background
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status=
  - stepId: status-border
    title: "Shadow CSS: .status-badge / border"
    summary: Border odvaja badge od pozadine avatara.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:status-border
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status=
  - stepId: status-transition
    title: "Shadow CSS: .status-badge / transition"
    summary: Tranzicija pravi glatku promenu statusa.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:status-transition
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - status=
  - stepId: info-outline
    title: "Shadow CSS: .avatar-info / outline"
    summary: Dodajemo helper outline za info zonu.
    intent: Info zona drži username i role labele.
    tag: shadow-css:info-outline
    proTip: Info zona drži username i role labele.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: info-display
    title: "Shadow CSS: .avatar-info / display"
    summary: Flex pravi vertikalni stack tekstova.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:info-display
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: info-direction
    title: "Shadow CSS: .avatar-info / flex-direction"
    summary: Kolona slaže username iznad role-a.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:info-direction
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: info-align
    title: "Shadow CSS: .avatar-info / align-items"
    summary: Centriramo oba teksta ispod avatara.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:info-align
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: info-gap
    title: "Shadow CSS: .avatar-info / gap"
    summary: Minimal gap drži tekstove fokusiranim.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:info-gap
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: username-font-size
    title: "Shadow CSS: .username / font-size"
    summary: Solidna veličina za primarnu labelu.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:username-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: username-font-weight
    title: "Shadow CSS: .username / font-weight"
    summary: Bold drži username kao primarni signal.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:username-font-weight
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: username-color
    title: "Shadow CSS: .username / color"
    summary: Čita text token.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:username-color
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: username-white-space
    title: "Shadow CSS: .username / white-space"
    summary: Username ostaje na jednoj liniji.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:username-white-space
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: role-font-size
    title: "Shadow CSS: .role / font-size"
    summary: Manji font čini role sekundarnim signals.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:role-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - role=
  - stepId: role-font-weight
    title: "Shadow CSS: .role / font-weight"
    summary: Medium weight drži role čitkim ali podređenim.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:role-font-weight
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - role=
  - stepId: role-color
    title: "Shadow CSS: .role / color"
    summary: Muted token daje sekundarni signal.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:role-color
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - role=
  - stepId: role-text-transform
    title: "Shadow CSS: .role / text-transform"
    summary: Uppercase zatvara role kao kategorijsku labelu.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:role-text-transform
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - role=
  - stepId: role-letter-spacing
    title: "Shadow CSS: .role / letter-spacing"
    summary: Tracking čini role urednom.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:role-letter-spacing
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - role=
  - stepId: role-white-space
    title: "Shadow CSS: .role / white-space"
    summary: Role ostaje na jednoj liniji.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:role-white-space
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - role=
  - stepId: tooltip-outline
    title: "Shadow CSS: .tooltip / outline"
    summary: Dodajemo helper outline za tooltip.
    intent: Tooltip je interaktivna informaciona zona.
    tag: shadow-css:tooltip-outline
    proTip: Tooltip je interaktivna informaciona zona.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-position
    title: "Shadow CSS: .tooltip / position"
    summary: Absolute ga odvaja od normalnog toka.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-position
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-bottom
    title: "Shadow CSS: .tooltip / bottom"
    summary: Tooltip se pojavljuje iznad avatara.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-bottom
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-left
    title: "Shadow CSS: .tooltip / left"
    summary: Levim rubom krenemo od centra.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-left
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-transform
    title: "Shadow CSS: .tooltip / transform"
    summary: Negativan translate centrira tooltip.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-transform
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-background
    title: "Shadow CSS: .tooltip / background"
    summary: Très tamna pozadina drži tooltip čitkim.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-background
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-border
    title: "Shadow CSS: .tooltip / border"
    summary: Border tok čita host token.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-border
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-color
    title: "Shadow CSS: .tooltip / color"
    summary: Text čita host token.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-color
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-padding
    title: "Shadow CSS: .tooltip / padding"
    summary: Padding daje tooltip-u pravi footprint.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-padding
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-radius
    title: "Shadow CSS: .tooltip / border-radius"
    summary: Zaobljenje drži tooltip modernim.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-radius
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-font-size
    title: "Shadow CSS: .tooltip / font-size"
    summary: Manji font za tooltip tip.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-font-size
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-white-space
    title: "Shadow CSS: .tooltip / white-space"
    summary: Tooltip ostaje u jednom redu.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-white-space
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-pointer-events
    title: "Shadow CSS: .tooltip / pointer-events"
    summary: Tooltip ne blokirа klik na avatar.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-pointer-events
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-opacity-start
    title: "Shadow CSS: .tooltip / opacity"
    summary: Tooltip startu nevidljiv.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-opacity-start
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-transition
    title: "Shadow CSS: .tooltip / transition"
    summary: Tranzicija pravi glatko prikazivanje.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-transition
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-z-index
    title: "Shadow CSS: .tooltip / z-index"
    summary: Z-index drži tooltip iznad ostatka DOM-a.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-z-index
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-hover-opacity
    title: "Shadow CSS: :host(:hover) .tooltip, :host(:focus-within) .tooltip / opacity"
    summary: Na hover tooltip postaje vidljiv.
    intent: Focus-within pokriva i tastatursku navigaciju.
    tag: shadow-css:tooltip-hover-opacity
    proTip: Focus-within pokriva i tastatursku navigaciju.
    focusHtmlNeedles:
      - <ui-user-avatar
  - stepId: tooltip-hover-transform
    title: "Shadow CSS: :host(:hover) .tooltip, :host(:focus-within) .tooltip / transform"
    summary: Mali lift daje tooltip-u dinamičan ulaz.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:tooltip-hover-transform
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
  - stepId: host-focus-outline
    title: "Shadow CSS: :host(:focus-visible) / outline"
    summary: Focus-visible dodaje tastaturski focus ring.
    intent: Klavijaturska navigacija mora biti jasno vidljiva.
    tag: shadow-css:host-focus-outline
    proTip: Klavijaturska navigacija mora biti jasno vidljiva.
    focusHtmlNeedles:
      - <ui-user-avatar
  - stepId: host-focus-outline-offset
    title: "Shadow CSS: :host(:focus-visible) / outline-offset"
    summary: Offset drži ring dalje od ivice.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:host-focus-outline-offset
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
  - stepId: host-focus-radius
    title: "Shadow CSS: :host(:focus-visible) / border-radius"
    summary: Radius čini focus ring kružnim uz avatar.
    intent: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    tag: shadow-css:host-focus-radius
    proTip: Shadow CSS stilizuje samo unutrašnju strukturu komponente; host token API kontroliše temu spolja.
    focusHtmlNeedles:
      - <ui-user-avatar
  - stepId: container-summary
    title: "Rezime: .avatar-container"
    summary: Uklanjamo container helper outline.
    intent: Container drži sve vizuelne delove u jednom stacking kontekstu.
    tag: summary:container-summary
    proTip: Container drži sve vizuelne delove u jednom stacking kontekstu.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: image-summary
    title: "Rezime: .avatar-image"
    summary: Uklanjamo image helper outline.
    intent: Avatar krug sada ima gradijent, border, shadow i hover interakciju.
    tag: summary:image-summary
    proTip: Avatar krug sada ima gradijent, border, shadow i hover interakciju.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: status-summary
    title: "Rezime: .status-badge"
    summary: Uklanjamo status badge helper outline.
    intent: Status badge čita `--avatar-status-color` token — status varijante menjaju samo taj token.
    tag: summary:status-summary
    proTip: Status badge čita `--avatar-status-color` token — status varijante menjaju samo taj token.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: info-summary
    title: "Rezime: .avatar-info"
    summary: Uklanjamo info zone helper outline.
    intent: Username i role su sada stilizovani sa jasnom hijerarhijom.
    tag: summary:info-summary
    proTip: Username i role su sada stilizovani sa jasnom hijerarhijom.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: tooltip-summary
    title: "Rezime: .tooltip"
    summary: Uklanjamo tooltip helper outline.
    intent: Tooltip se pojavljuje na hover i focus-within sa glatkom animacijom.
    tag: summary:tooltip-summary
    proTip: Tooltip se pojavljuje na hover i focus-within sa glatkom animacijom.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: host-summary
    title: "Rezime: ui-user-avatar host"
    summary: Uklanjamo host helper outline.
    intent: Host nosi token contract, variants i interaktivni cursor. Shadow ostaje izolovan.
    tag: summary:host-summary
    proTip: Host nosi token contract, variants i interaktivni cursor. Shadow ostaje izolovan.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: shell-summary
    title: "Rezime: .app-shell"
    summary: "Uklanjamo shell helper outline. Vizuelni widget je sada kompletan i ovo je prvi trenutak kada kažemo: ovo je ono što želimo."
    intent: Prvo zaključujemo vizuelni rezultat, a tek onda uvodimo funkcionalnosti korak po korak.
    tag: summary:shell-summary
    proTip: Prvo zaključujemo vizuelni rezultat, a tek onda uvodimo funkcionalnosti korak po korak.
    focusHtmlNeedles:
      - <div class="app-shell">
  - stepId: connected-callback-bind
    title: "JS: connectedCallback zakačuje evente"
    summary: Tek na kraju, kad su reference spremne, zakačujemo event listenere.
    intent: Event wiring ide poslednji — DOM mora biti spreman pre binding-a.
    tag: js:connected-callback-bind
    proTip: Event wiring ide poslednji — DOM mora biti spreman pre binding-a.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: normalize-text-helper
    title: "JS: normalizeTextValue() helper"
    summary: Dodajemo `normalizeTextValue()` da username i role ne zavise od sirovog ulaza.
    intent: API border normalizuje ulaz. Komponenta nikad ne radi sa undefined ili praznim stringovima bez fallback-a.
    tag: js:normalize-text-helper
    proTip: API border normalizuje ulaz. Komponenta nikad ne radi sa undefined ili praznim stringovima bez fallback-a.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: allowed-statuses-set
    title: "JS: allowedStatuses Set"
    summary: "Zaključavamo dozvoljene statusne vrednosti: `online`, `idle`, `away`, `offline`."
    intent: Otvoreni string API za status koji direktno utiče na styling je rizičan. Set ga zatvara.
    tag: js:allowed-statuses-set
    proTip: Otvoreni string API za status koji direktno utiče na styling je rizičan. Set ga zatvara.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: normalize-status-helper
    title: "JS: normalizeStatusValue() helper"
    summary: Dodajemo `normalizeStatusValue()`. Svaki nepoznat status automatski pada na `offline`.
    intent: Fallback je deo contract-a. Komponenta ne sme da padne zbog pogrešno napisanog statusa.
    tag: js:normalize-status-helper
    proTip: Fallback je deo contract-a. Komponenta ne sme da padne zbog pogrešno napisanog statusa.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: status-label-map
    title: "JS: statusAriaLabel mapa"
    summary: Dodajemo `statusAriaLabel` objekat koji mapira status vrednosti na human-readable aria labele.
    intent: Accessibility nije opciona. Status badge mora imati smislenu aria labelu na svakom koraku.
    tag: js:status-label-map
    proTip: Accessibility nije opciona. Status badge mora imati smislenu aria labelu na svakom koraku.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: disconnected-callback
    title: "JS: disconnectedCallback cleanup"
    summary: Na izlazu iz DOM-a skidamo event listener.
    intent: Production widget mora biti siguran i pri reconnect scenariju. Leak-ovi eventa su stvarni bug.
    tag: js:disconnected-callback
    proTip: Production widget mora biti siguran i pri reconnect scenariju. Leak-ovi eventa su stvarni bug.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: attribute-changed-callback
    title: "JS: precizan attributeChangedCallback"
    summary: Potpis prima `name`, `oldValue` i `newValue` — tri argumenta su tačan Web Components API.
    intent: Tačan API potpis je uslov za ispravno granularno razlikovanje promena.
    tag: js:attribute-changed-callback
    proTip: Tačan API potpis je uslov za ispravno granularno razlikovanje promena.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: attribute-changed-guard
    title: "JS: guard za iste vrednosti i disconnected stanje"
    summary: Odmah izlazimo ako se vrednost nije promenila ili widget još nije u živom DOM-u.
    intent: Enterprise update path ne troši resurse bez potrebe.
    tag: js:attribute-changed-guard
    proTip: Enterprise update path ne troši resurse bez potrebe.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: attribute-changed-switch
    title: "JS: switch — menjamo samo ono što se promenilo"
    summary: Switch poziva `updateUsername()`, `updateRole()` ili `updateStatus()` zavisno od atributa koji se promenio.
    intent: "Granularni update je ključna razlika: nema slepog full-render poziva za svaku atributsku promenu."
    tag: js:attribute-changed-switch
    proTip: "Granularni update je ključna razlika: nema slepog full-render poziva za svaku atributsku promenu."
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: property-username-getter
    title: "JS: username getter"
    summary: Property getter vraća normalizovani username sa fallback-om.
    intent: Property API otvara čist JS contract pored declarative HTML atributa.
    tag: js:property-username-getter
    proTip: Property API otvara čist JS contract pored declarative HTML atributa.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: property-username-setter
    title: "JS: username setter"
    summary: Setter piše nazad u atribut — source of truth ostaje na atributu.
    intent: Imperative JS i declarative HTML API rade kroz isti kanal.
    tag: js:property-username-setter
    proTip: Imperative JS i declarative HTML API rade kroz isti kanal.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: property-role-getter
    title: "JS: role getter"
    summary: Getter vraća normalizovanu role vrednost.
    intent: Role može biti prazan string — to je validno stanje.
    tag: js:property-role-getter
    proTip: Role može biti prazan string — to je validno stanje.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: property-role-setter
    title: "JS: role setter"
    summary: Setter piše normalizovanu role nazad u atribut.
    intent: "Isti model kao username: atribut je jedini source of truth."
    tag: js:property-role-setter
    proTip: "Isti model kao username: atribut je jedini source of truth."
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: property-status-getter
    title: "JS: status getter"
    summary: Getter vraća normalizovani status sa fallback-om na `offline`.
    intent: Nikad ne vraćamo nevalidni status dalje kroz sistem.
    tag: js:property-status-getter
    proTip: Nikad ne vraćamo nevalidni status dalje kroz sistem.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: property-status-setter
    title: "JS: status setter"
    summary: Setter normalizuje status pre upisa — nevalidni ulaz se pretvara u `offline`.
    intent: Normalizacija ide na granici API-ja, ne usred update logike.
    tag: js:property-status-setter
    proTip: Normalizacija ide na granici API-ja, ne usred update logike.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: property-profile-url-getter
    title: "JS: profileUrl getter"
    summary: Getter vraća `profile-url` atribut bez normalizacije — URL je otvoren string.
    intent: Profile URL nije validovan u widgetu; parent je odgovoran za tačnost URL-a.
    tag: js:property-profile-url-getter
    proTip: Profile URL nije validovan u widgetu; parent je odgovoran za tačnost URL-a.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: bind-events
    title: "JS: bindEvents()"
    summary: Event wiring ostaje u sopstvenoj responsibility metodi.
    intent: Bind i unbind idu uvek u par, sa jasnim imenima.
    tag: js:bind-events
    proTip: Bind i unbind idu uvek u par, sa jasnim imenima.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: bind-events-guard
    title: "JS: bindEvents štiti od duplog binding-a"
    summary: Flag `isClickBound` sprečava dvostruko kačenje listenera. Postavljamo i `tabindex` i `role` atribute za accessibility.
    intent: Widget mora biti navigabilan tastaturom — tabindex i role su deo tog contract-a.
    tag: js:bind-events-guard
    proTip: Widget mora biti navigabilan tastaturom — tabindex i role su deo tog contract-a.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: unbind-events
    title: "JS: unbindEvents()"
    summary: Cleanup metoda postoji za svaki bind scenario.
    intent: Ako postoji bind, mora postojati i cleanup. Bez izuzetka.
    tag: js:unbind-events
    proTip: Ako postoji bind, mora postojati i cleanup. Bez izuzetka.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: unbind-events-guard
    title: "JS: unbindEvents skida listener samo kada postoji"
    summary: Guard sprečava grešku pri pokušaju skidanja listenera koji nije zakačen.
    intent: Reconnect moraju biti dosadni — bez neregularnih situacija.
    tag: js:unbind-events-guard
    proTip: Reconnect moraju biti dosadni — bez neregularnih situacija.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: handle-avatar-click
    title: "JS: handleAvatarClick()"
    summary: Klik handler emituje namespaced event sa punim payload-om.
    intent: "Handler je mali i predvidiv: jedna odgovornost — emitovanje event-a."
    tag: js:handle-avatar-click
    proTip: "Handler je mali i predvidiv: jedna odgovornost — emitovanje event-a."
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: handle-avatar-click-event
    title: "JS: ui-user-avatar:profile-open event"
    summary: "Emitujemo `ui-user-avatar:profile-open` sa `bubbles`, `composed`, `cancelable` i stabilnim `detail`-om: username, role, status, profileUrl, source."
    intent: Event contract je deo javnog API-ja. Parent sluša ovaj event i odlučuje da li otvara modal, navigira ili radi nešto treće.
    tag: js:handle-avatar-click-event
    proTip: Event contract je deo javnog API-ja. Parent sluša ovaj event i odlučuje da li otvara modal, navigira ili radi nešto treće.
    focusHtmlNeedles:
      - <ui-user-avatar
      - username=
  - stepId: done
    title: "Done: UI User Avatar Dashboard Widget"
    summary: "`ui-user-avatar` je završen: `index.html` deklarativno koristi atribute i slotove, `ui-user-avatar.template.js` drži shadow strukturu, `ui-user-avatar.js` vodi property API, lifecycle i namespaced event contract, `style.css` theme-uje host i variants, a `ui-user-avatar.shadow.css` drži unutrašnji styling widgeta."
    intent: "Enterprise widget contract je uzan: četiri atributa, dva slota, jedan event. Parent odlučuje šta se dešava pri kliku — widget samo emituje signal."
    tag: success
    proTip: "Enterprise widget contract je uzan: četiri atributa, dva slota, jedan event. Parent odlučuje šta se dešava pri kliku — widget samo emituje signal."
    focusHtmlNeedles: []
---

# Step: empty-shell

## Scene: empty-shell-scene

narration:
Počinjemo od praznog `.app-shell` prostora. Dashboard widget živi u neutralnom host okruženju.

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
Dodajemo `<ui-user-avatar>` sa `username` i `role` atributima. Tag odmah govori šta ovaj widget jeste.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: status-attribute-html

## Scene: status-attribute-html-scene

narration:
Dodajemo `status="online"` i uvodimo deklarativni status API. Status je deo HTML contract-a, ne JavaScript stanja.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: profile-url-attribute-html

## Scene: profile-url-attribute-html-scene

narration:
Dodajemo `profile-url` koji ide u event payload pri kliku. Komponenta ne navigira sama.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: initials-slot-html

## Scene: initials-slot-html-scene

narration:
Dodajemo `<span slot="initials">AP</span>`. Slot je javna API površina za inicijale ili sliku.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: tooltip-slot-html

## Scene: tooltip-slot-html-scene

narration:
Dodajemo `<span slot="tooltip">` sa punim contextualnim opisom član tima. Tooltip sadržaj kontroliše parent.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom

# Step: avatar-widget-contract

## Scene: avatar-widget-contract-scene

narration:
Ovaj widget ima četiri javna atributa: `username`, `role`, `status`, `profile-url`. Ima dva named slota: `initials` i `tooltip`. Emituje jedan namespaced event: `ui-user-avatar:profile-open`. Nema internog routing-a i nema opisivanja šta parent treba da uradi.

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
U `ui-user-avatar.template.js` definiše `templateHtml`: avatar-container, avatar-image sa slot za inicijale, status-badge, avatar-info sa username i role spanovima, i tooltip sa named slotom.

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
Kreiramo `uiUserAvatarTemplate`, dodajemo `<link>` ka shadow CSS fajlu i ubrizgavamo `${templateHtml}`.

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
Behavior fajl uvozi `uiUserAvatarTemplate` iz template modula. Klasa ne gradi HTML stringove.

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
Klasa nosi domain-driven ime, konzistentno sa tagom.

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
Komponenta prati `username`, `role`, `status` i `profile-url` — tačno onoliko koliko je deklarirano kao javni API.

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
Konstruktor samo priprema instancu: shadow root, bind i nulte reference.

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
Vezujemo `handleAvatarClick` jednom, pri kreiranju instance.

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
Nulujemo DOM reference i state flag za click binding.

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
Connected lifecycle je glavni ulaz kada widget uđe u živi DOM.

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
Prvo jednom montiramo template u shadow root.

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
Kad template postoji, keširamo DOM reference.

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
Pozivamo `syncFromAttributes()` kao prvi ciljani render pass.

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
Template mount dobija sopstvenu metodu.

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
Kloniramo template samo ako shadow root nema child node-ova.

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
cacheDom ne montira template i ne radi render. Samo pronalazi reference ako ne postoje.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cache-dom-username

## Scene: cache-dom-username-scene

narration:
Username span čuvamo jednom da updateUsername ne mora da radi query pri svakoj promeni.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cache-dom-role

## Scene: cache-dom-role-scene

narration:
Role span čuvamo na isti način.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: cache-dom-status-badge

## Scene: cache-dom-status-badge-scene

narration:
Status badge element čuvamo za aria-label update.

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
Centralna one-time inicijalizacija koja propagira sve atribute u DOM na prvom connect-u.

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
Pozivamo `updateUsername()`, `updateRole()` i `updateStatus()` pri inicijalnom connect-u.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: update-username

## Scene: update-username-scene

narration:
Username element dobija tačno ono što property API vrati.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: update-role

## Scene: update-role-scene

narration:
Role element ažuriramo kroz istu usku metodu.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: update-status

## Scene: update-status-scene

narration:
Status badge dobija ažuriranu aria-label iz `statusAriaLabel` mape.

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
Proveravamo da li je element već registrovan pre `customElements.define()`.

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
Komponenta je registrovana: `customElements.define("ui-user-avatar", UiUserAvatar)`.

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
Breathing prostor drži scenu urednom.

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
Grid pravi jedinstven container za widget.

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
Widget treba da bude centriran u demo sceni.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: shell-gap

## Scene: shell-gap-scene

narration:
Gap priprema prostor za eventualni drugi avatar.

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
Puna visina drži dark pozadinu stabilnom.

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
Tamna pozadina naglašava avatar widget.

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
Dodajemo host helper outline i držimo ga do završnog host rezimea.

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
Avatar ostaje kompaktan inline-block element.

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
Pozicija pravi stacking kontekst za tooltip.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-cursor

## Scene: host-cursor-scene

narration:
Avatar je klikabilna zona — cursor to mora jasno da kaže.

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
Počinjemo token contract: površina je spolja theme-ovana.

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
Alternativna površina drži gradijent konzistentnim.

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
Accent token vodi boju avatara i detalja.

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
Text token čuva kontrast u celom widgetu.

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
Muted token pokriva role i sekundarne labele.

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
Border token drži ivice neagresivnim na tamnoj pozadini.

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
Shadow token ide kao javni contract, ne internu magiju.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: host-status-color-token

## Scene: host-status-color-token-scene

narration:
Status boja je javni host token — variants ga samo prepišu.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: variant-online-status-color

## Scene: variant-online-status-color-scene

narration:
Online status dobija zeleni signal.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: variant-idle-status-color

## Scene: variant-idle-status-color-scene

narration:
Idle dobija žuti signal.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: variant-away-status-color

## Scene: variant-away-status-color-scene

narration:
Away dobija narandžasti signal.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: variant-offline-status-color

## Scene: variant-offline-status-color-scene

narration:
Offline dobija sivi, neutralni signal.

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
Host CSS drži token kontrakt i status variants. Svaka promena statusa menja samo `--avatar-status-color` token — bez diranja shadow internals. Sledeći koraci prelaze u `ui-user-avatar.shadow.css`.

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
Shadow host potvrđuje inline-block model iznutra.

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
Font stack ostaje interni shadow contract.

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

# Step: container-outline

## Scene: container-outline-scene

narration:
Dodajemo helper outline za avatar container.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: container-position

## Scene: container-position-scene

narration:
Relative pozicija pravi stacking kontekst za status badge i tooltip.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: container-display

## Scene: container-display-scene

narration:
Flex pravi vertikalni stack avatar delova.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: container-direction

## Scene: container-direction-scene

narration:
Kolona slaže sliku, info i tooltip vertikalno.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: container-align

## Scene: container-align-scene

narration:
Sve celine se centriraju horizontalno.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: container-gap

## Scene: container-gap-scene

narration:
Gap drži rastojanje između slike i info zone.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-outline

## Scene: image-outline-scene

narration:
Dodajemo helper outline za avatar sliku.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-position

## Scene: image-position-scene

narration:
Relative pravi stacking kontekst za absolutni status badge.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-width

## Scene: image-width-scene

narration:
Avatar krug dobija standardnu veličinu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-height

## Scene: image-height-scene

narration:
Visina odgovara širini — idemo ka krugu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-radius

## Scene: image-radius-scene

narration:
Puni radius završava avatar krug.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-background

## Scene: image-background-scene

narration:
Gradijent pozadina koja se vidi iza inicijala.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-border

## Scene: image-border-scene

narration:
Border čita host token.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-shadow

## Scene: image-shadow-scene

narration:
Shadow dolazi iz host contract-a.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-display

## Scene: image-display-scene

narration:
Flex centrira inicijale unutar kruga.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-align

## Scene: image-align-scene

narration:
Vertikalno centriranje inicijala.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-justify

## Scene: image-justify-scene

narration:
Horizontalno centriranje inicijala.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-overflow

## Scene: image-overflow-scene

narration:
Overflow hidden reže bilo koji sadržaj van kruga.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-transition

## Scene: image-transition-scene

narration:
Tranzicija pravi glatki hover lift.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-hover-transform

## Scene: image-hover-transform-scene

narration:
Blagi scale na hover daje interaktivni feel.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: image-hover-shadow

## Scene: image-hover-shadow-scene

narration:
Accent shadow na hover potvrđuje interakciju.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: initials-font-size

## Scene: initials-font-size-scene

narration:
Inicijali dobijaju jasnu veličinu unutar kruga.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: initials-font-weight

## Scene: initials-font-weight-scene

narration:
Jaki bold drži inicijale čitkim.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: initials-color

## Scene: initials-color-scene

narration:
Beli tekst drži kontrast na gradijent pozadini.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: initials-letter-spacing

## Scene: initials-letter-spacing-scene

narration:
Mali tracking poboljšava čitljivost.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: initials-select

## Scene: initials-select-scene

narration:
Inicijali ne treba da budu selektabilni.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: status-outline

## Scene: status-outline-scene

narration:
Dodajemo helper outline za status badge.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: status-position

## Scene: status-position-scene

narration:
Absolute ga pozicionira unutar avatar tipa.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: status-bottom

## Scene: status-bottom-scene

narration:
Pozicioniramo badge u donji desni ugao.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: status-right

## Scene: status-right-scene

narration:
Desno od centra, standardna pozicija status badge-a.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: status-width

## Scene: status-width-scene

narration:
Mali kružić.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: status-height

## Scene: status-height-scene

narration:
Visina odgovara širini.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: status-radius

## Scene: status-radius-scene

narration:
Puni radius završava status krug.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: status-background

## Scene: status-background-scene

narration:
Boja čita host status token — nikad hardkodovana iznutra.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: status-border

## Scene: status-border-scene

narration:
Border odvaja badge od pozadine avatara.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: status-transition

## Scene: status-transition-scene

narration:
Tranzicija pravi glatku promenu statusa.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: info-outline

## Scene: info-outline-scene

narration:
Dodajemo helper outline za info zonu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: info-display

## Scene: info-display-scene

narration:
Flex pravi vertikalni stack tekstova.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: info-direction

## Scene: info-direction-scene

narration:
Kolona slaže username iznad role-a.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: info-align

## Scene: info-align-scene

narration:
Centriramo oba teksta ispod avatara.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: info-gap

## Scene: info-gap-scene

narration:
Minimal gap drži tekstove fokusiranim.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: username-font-size

## Scene: username-font-size-scene

narration:
Solidna veličina za primarnu labelu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: username-font-weight

## Scene: username-font-weight-scene

narration:
Bold drži username kao primarni signal.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: username-color

## Scene: username-color-scene

narration:
Čita text token.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: username-white-space

## Scene: username-white-space-scene

narration:
Username ostaje na jednoj liniji.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: role-font-size

## Scene: role-font-size-scene

narration:
Manji font čini role sekundarnim signals.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: role-font-weight

## Scene: role-font-weight-scene

narration:
Medium weight drži role čitkim ali podređenim.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: role-color

## Scene: role-color-scene

narration:
Muted token daje sekundarni signal.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: role-text-transform

## Scene: role-text-transform-scene

narration:
Uppercase zatvara role kao kategorijsku labelu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: role-letter-spacing

## Scene: role-letter-spacing-scene

narration:
Tracking čini role urednom.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: role-white-space

## Scene: role-white-space-scene

narration:
Role ostaje na jednoj liniji.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-outline

## Scene: tooltip-outline-scene

narration:
Dodajemo helper outline za tooltip.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-position

## Scene: tooltip-position-scene

narration:
Absolute ga odvaja od normalnog toka.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-bottom

## Scene: tooltip-bottom-scene

narration:
Tooltip se pojavljuje iznad avatara.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-left

## Scene: tooltip-left-scene

narration:
Levim rubom krenemo od centra.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-transform

## Scene: tooltip-transform-scene

narration:
Negativan translate centrira tooltip.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-background

## Scene: tooltip-background-scene

narration:
Très tamna pozadina drži tooltip čitkim.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-border

## Scene: tooltip-border-scene

narration:
Border tok čita host token.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-color

## Scene: tooltip-color-scene

narration:
Text čita host token.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-padding

## Scene: tooltip-padding-scene

narration:
Padding daje tooltip-u pravi footprint.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-radius

## Scene: tooltip-radius-scene

narration:
Zaobljenje drži tooltip modernim.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-font-size

## Scene: tooltip-font-size-scene

narration:
Manji font za tooltip tip.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-white-space

## Scene: tooltip-white-space-scene

narration:
Tooltip ostaje u jednom redu.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-pointer-events

## Scene: tooltip-pointer-events-scene

narration:
Tooltip ne blokirа klik na avatar.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-opacity-start

## Scene: tooltip-opacity-start-scene

narration:
Tooltip startu nevidljiv.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-transition

## Scene: tooltip-transition-scene

narration:
Tranzicija pravi glatko prikazivanje.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-z-index

## Scene: tooltip-z-index-scene

narration:
Z-index drži tooltip iznad ostatka DOM-a.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-hover-opacity

## Scene: tooltip-hover-opacity-scene

narration:
Na hover tooltip postaje vidljiv.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: tooltip-hover-transform

## Scene: tooltip-hover-transform-scene

narration:
Mali lift daje tooltip-u dinamičan ulaz.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: host-focus-outline

## Scene: host-focus-outline-scene

narration:
Focus-visible dodaje tastaturski focus ring.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: host-focus-outline-offset

## Scene: host-focus-outline-offset-scene

narration:
Offset drži ring dalje od ivice.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: host-focus-radius

## Scene: host-focus-radius-scene

narration:
Radius čini focus ring kružnim uz avatar.

focus:
  artifactId: shadow-css

code:
  activeArtifactId: shadow-css

preview:
  action: apply-state
  target: dom

# Step: container-summary

## Scene: container-summary-scene

narration:
Uklanjamo container helper outline.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: image-summary

## Scene: image-summary-scene

narration:
Uklanjamo image helper outline.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: status-summary

## Scene: status-summary-scene

narration:
Uklanjamo status badge helper outline.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: info-summary

## Scene: info-summary-scene

narration:
Uklanjamo info zone helper outline.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: tooltip-summary

## Scene: tooltip-summary-scene

narration:
Uklanjamo tooltip helper outline.

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
Uklanjamo shell helper outline. Vizuelni widget je sada kompletan i ovo je prvi trenutak kada kažemo: ovo je ono što želimo.

focus:
  artifactId: css

code:
  activeArtifactId: css

preview:
  action: apply-state
  target: dom

# Step: connected-callback-bind

## Scene: connected-callback-bind-scene

narration:
Tek na kraju, kad su reference spremne, zakačujemo event listenere.

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
Dodajemo `normalizeTextValue()` da username i role ne zavise od sirovog ulaza.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: allowed-statuses-set

## Scene: allowed-statuses-set-scene

narration:
Zaključavamo dozvoljene statusne vrednosti: `online`, `idle`, `away`, `offline`.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: normalize-status-helper

## Scene: normalize-status-helper-scene

narration:
Dodajemo `normalizeStatusValue()`. Svaki nepoznat status automatski pada na `offline`.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: status-label-map

## Scene: status-label-map-scene

narration:
Dodajemo `statusAriaLabel` objekat koji mapira status vrednosti na human-readable aria labele.

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
Na izlazu iz DOM-a skidamo event listener.

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
Potpis prima `name`, `oldValue` i `newValue` — tri argumenta su tačan Web Components API.

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
Odmah izlazimo ako se vrednost nije promenila ili widget još nije u živom DOM-u.

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
Switch poziva `updateUsername()`, `updateRole()` ili `updateStatus()` zavisno od atributa koji se promenio.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-username-getter

## Scene: property-username-getter-scene

narration:
Property getter vraća normalizovani username sa fallback-om.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-username-setter

## Scene: property-username-setter-scene

narration:
Setter piše nazad u atribut — source of truth ostaje na atributu.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-role-getter

## Scene: property-role-getter-scene

narration:
Getter vraća normalizovanu role vrednost.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-role-setter

## Scene: property-role-setter-scene

narration:
Setter piše normalizovanu role nazad u atribut.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-status-getter

## Scene: property-status-getter-scene

narration:
Getter vraća normalizovani status sa fallback-om na `offline`.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-status-setter

## Scene: property-status-setter-scene

narration:
Setter normalizuje status pre upisa — nevalidni ulaz se pretvara u `offline`.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: property-profile-url-getter

## Scene: property-profile-url-getter-scene

narration:
Getter vraća `profile-url` atribut bez normalizacije — URL je otvoren string.

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

# Step: bind-events-guard

## Scene: bind-events-guard-scene

narration:
Flag `isClickBound` sprečava dvostruko kačenje listenera. Postavljamo i `tabindex` i `role` atribute za accessibility.

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
Cleanup metoda postoji za svaki bind scenario.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: unbind-events-guard

## Scene: unbind-events-guard-scene

narration:
Guard sprečava grešku pri pokušaju skidanja listenera koji nije zakačen.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: handle-avatar-click

## Scene: handle-avatar-click-scene

narration:
Klik handler emituje namespaced event sa punim payload-om.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: handle-avatar-click-event

## Scene: handle-avatar-click-event-scene

narration:
Emitujemo `ui-user-avatar:profile-open` sa `bubbles`, `composed`, `cancelable` i stabilnim `detail`-om: username, role, status, profileUrl, source.

focus:
  artifactId: js

code:
  activeArtifactId: js

preview:
  action: apply-state
  target: dom

# Step: done

## Scene: done-scene

narration:
`ui-user-avatar` je završen: `index.html` deklarativno koristi atribute i slotove, `ui-user-avatar.template.js` drži shadow strukturu, `ui-user-avatar.js` vodi property API, lifecycle i namespaced event contract, `style.css` theme-uje host i variants, a `ui-user-avatar.shadow.css` drži unutrašnji styling widgeta.

focus:
  artifactId: html

code:
  activeArtifactId: html

preview:
  action: apply-state
  target: dom
