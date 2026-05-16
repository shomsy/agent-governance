---
schemaVersion: 1
lessonId: 04-build-web-component
lessonTitle: 04 · Web Components 2/2 · Shadow DOM my first component
lessonIntro: "Druga Web Components lekcija prvo sastavlja vidljivi card shell
  kroz host, template i slotove kao vizuelnu fazu, a tek onda dodaje shadow DOM
  behavior, render lifecycle, cleanup i sigurniju registraciju kao logičku
  fazu."
status: active
courseId: step-by-step-animator
order: 4
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
preview:
  type: dom
  title: Live Web Component preview
  address: browser://04-build-web-component-preview
goal:
  title: Šta gradimo u ovoj lekciji
  imageSrc: ./assets/web-component-goal.svg
  imageAlt: Referentna slika tamnog my first component card Web Component-a na
    svetloj pozadini, sa badge oznakom, velikim naslovom, opisom i CTA dugmetom.
  imageCaption: "Prvo završavamo vidljivi card shell, a onda kroz shadow DOM,
    slotove i lifecycle uvodimo behavior i polish."
---

Druga Web Components lekcija prvo sastavlja vidljivi card shell kroz host, template i slotove kao vizuelnu fazu, a tek onda dodaje shadow DOM behavior, render lifecycle, cleanup i sigurniju registraciju kao logičku fazu.
