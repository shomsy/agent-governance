---
schemaVersion: 1
lessonId: 05-clean-web-component-with-adopted-stylesheets
lessonTitle: 05 · Web Components 3/3 · Now Let's Clean The Mess
lessonIntro: "Treća Web Components lekcija prvo zadržava isti vidljivi card rezultat kao vizuelnu fazu, a tek onda čisti stilsku priču komponente kao logičku fazu: CSS više ne živi ni u template markup-u ni u velikom JS string-u, nego u posebnom shadow CSS fajlu koji JavaScript uvozi kao tekst i usvaja preko adoptedStyleSheets."
status: active
courseId: step-by-step-animator
order: 5
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
  title: Live adoptedStyleSheets preview
  address: browser://05-clean-web-component-with-adopted-stylesheets-preview
goal:
  title: Šta gradimo u ovoj lekciji
  imageSrc: ./assets/web-component-goal.svg
  imageAlt: Referentna slika tamnog my first component card Web Component-a na
    svetloj pozadini, sa badge oznakom, velikim naslovom, opisom i CTA dugmetom.
  imageCaption: "Prvo ostaje isti vidljivi card, a tek onda CSS prelazi u poseban
    `shadow-dom-style.css` sloj koji shadow root usvaja."
---

Treća Web Components lekcija prvo zadržava isti vidljivi card rezultat kao vizuelnu fazu, a tek onda čisti stilsku priču komponente kao logičku fazu: CSS više ne živi ni u template markup-u ni u velikom JS string-u, nego u posebnom shadow CSS fajlu koji JavaScript uvozi kao tekst i usvaja preko adoptedStyleSheets.
