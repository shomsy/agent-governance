---
schemaVersion: 1
lessonId: 06-modular-web-components
lessonTitle: 06 · Modular Web Components (IDE View)
lessonIntro: Ova lekcija demonstrira novi IDE mode playera. Prvo ostaje vidljiv
  stvarni UI rezultat komponente kao vizuelna faza, a tek onda koristimo file
  browser i automatsko prebacivanje fokusa kao logičku fazu da raspodelimo
  fajlove i ponašanje.
status: active
courseId: step-by-step-animator
order: 6
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
    label: my-first-component.js
    isPrimary: false
  - artifactId: shadow-css
    file: ./artifacts/shadow-dom-style.css.md
    language: css
    kind: rules
    label: shadow-dom-style.css
    isPrimary: false
preview:
  type: dom
  title: IDE View Web Components Preview
  address: browser://06-modular-web-components-preview
ideMode: true
goal:
  title: "Cilj: IDE Iskustvo"
  imageSrc: ./assets/web-component-goal.svg
  imageAlt: Referentna slika IDE view-a.
  imageCaption: U ovoj lekciji prvo čuvamo vidljiv rezultat komponente, a tek
    onda IDE layout koristi fajlove da razdvoji odgovornosti.
---

Ova lekcija demonstrira novi IDE mode playera. Prvo ostaje vidljiv stvarni UI rezultat komponente kao vizuelna faza, a tek onda koristimo file browser i automatsko prebacivanje fokusa kao logičku fazu da raspodelimo fajlove i ponašanje.
