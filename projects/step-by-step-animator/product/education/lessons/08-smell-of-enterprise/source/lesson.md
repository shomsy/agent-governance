---
schemaVersion: 1
lessonId: 08-smell-of-enterprise
lessonTitle: 08 · UI Pricing Card — SaaS Pricing Table
lessonIntro: "Gradimo `ui-pricing-card` u dve faze: prvo zatvaramo kompletan vizuelni shell sa HTML, template i CSS slojem kao vizuelnu fazu, a tek onda uključujemo tier varijante, popular highlight, yearly/monthly billing toggle, CTA dugme sa urgency countdown timerom i feature matrix slotove kao logičku fazu."
status: active
courseId: step-by-step-animator
order: 8
theory:
  enabled: false
scenes:
  file: ./scenes.md
artifacts:
  - artifactId: html
    file: ./artifacts/html.timeline.md
    language: html
    kind: timeline
    label: index.html
    isPrimary: true
  - artifactId: css
    file: ./artifacts/css.rules.md
    language: css
    kind: rules
    label: style.css
    isPrimary: false
  - artifactId: js
    file: ./artifacts/js.timeline.md
    language: js
    kind: timeline
    label: ui-pricing-card.js
    isPrimary: false
  - artifactId: template-js
    file: ./artifacts/template-js.timeline.md
    language: js
    kind: timeline
    label: ui-pricing-card.template.js
    isPrimary: false
  - artifactId: shadow-css
    file: ./artifacts/shadow-dom-style.css.md
    language: css
    kind: rules
    label: ui-pricing-card.shadow.css
    isPrimary: false
preview:
  type: dom
  title: Live SaaS Pricing Card Preview
  address: browser://08-ui-pricing-card-preview
ideMode: true
goal:
  title: "Cilj: SaaS Pricing Card Widget"
  imageSrc: ./assets/web-component-goal.svg
  imageAlt: Referentna slika ui-pricing-card sa Pro tier-om, billing toggle-om,
    feature listom i urgency timer-om.
  imageCaption: Prvo gradimo vizuelnu pricing karticu, a tek onda na nju
    primenjujemo tier varijante, toggle i countdown urgency ponašanje.
homework:
  enabled: true
  title: Varijante za samostalnu vežbu
  items:
    - Napravi grid od tri kartice (starter/pro/enterprise) sa različitim feature
      listama i cenama.
    - Dodaj `urgency-seconds` atribut umesto hardkodovanih 3600 sekundi za veću
      fleksibilnost.
    - "Implementiraj dynamic pricing calc: dodaj `seats` atribut i množji cenu
      sa brojem mesta."
    - Dodaj `discount-code` atribut koji primeni popust i prikaže precrtan
      originalni iznos.
---

Gradimo `ui-pricing-card` u dve faze: prvo zatvaramo kompletan vizuelni shell sa HTML, template i CSS slojem kao vizuelnu fazu, a tek onda uključujemo tier varijante, popular highlight, yearly/monthly billing toggle, CTA dugme sa urgency countdown timerom i feature matrix slotove kao logičku fazu.
