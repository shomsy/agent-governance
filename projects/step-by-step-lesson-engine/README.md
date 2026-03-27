# Step By Step Lesson Engine

`Step By Step Lesson Engine` je mali, framework-agnostic engine za lesson markdown sadržaj.

Ne rešava ceo tutorijal UI.
Ne rešava ceo preview shell.

Rešava baš ono što treba da se lako izdvoji i deli između projekata:

- frontmatter parsing
- markdown rendering
- lesson metadata reading
- quiz question reading
- generated lesson book sync

## Zašto postoji

Ovaj repo izdvaja najkorisniji lesson-content sloj iz većih teaching proizvoda kao što su:

- `Step By Step Animator`
- `avax-bootcamp`

Cilj je da lesson copy i quiz source mogu da žive u `.md` fajlovima bez CMS-a, a da aplikacija i dalje dobije jasan, prediktivan lesson contract.

## Shape

```txt
read-lesson-documents/
  parse-frontmatter.js
  render-markdown.js
  read-lesson-metadata.js
  read-knowledge-check-questions.js
  sync-lesson-documents.js

examples/
  build-sidebar/
    content/
      documents/
        build_sidebar.md
        files/
          lesson.sr.md
          quiz.sr.md
```

## API

```js
import {
  parseFrontmatter,
  renderMarkdown,
  readLessonMetadata,
  readKnowledgeCheckQuestions,
  syncLessonDocuments
} from 'step-by-step-lesson-engine';
```

### `readLessonMetadata(markdown, defaults?)`

Čita `lesson.sr.md` i vraća:

- `lessonTitle`
- `lessonIntro`
- `lessonIntroHtml`
- `previewAddress`
- `previewTitle`
- `htmlFileName`
- `cssFileName`

### `readKnowledgeCheckQuestions(markdown)`

Čita `quiz.sr.md` i vraća pitanja u formatu:

```js
[
  {
    question: '...',
    options: ['...', '...'],
    correct: 0,
    explanation: '...'
  }
]
```

## Lesson Markdown Format

### `lesson.sr.md`

```md
---
title: Kako se pravi moderan sidebar
previewAddress: browser://build-sidebar-preview
previewTitle: Live build sidebar preview
htmlFileName: index.html
cssFileName: style.css
---

Koraci po korak gradiš sidebar od osnove do gotove navigacije.
```

### `quiz.sr.md`

```md
## Question 1
? Koji HTML tag se koristi za bočnu navigaciju?
- [ ] `<div>`
- [x] `<aside>`
- [ ] `<nav>`
! `aside` je prirodan semantički izbor.
```

## Generated Lesson Book

Pokreni:

```bash
npm run sync:documents
```

To generiše linearni `content/documents/<lesson_name>.md` iz source markdown fajlova.

Generated output se ne održava ručno.

## Scope

Ovaj repo namerno ne pokušava da rešava:

- live code preview shell
- step-by-step HTML/CSS delta engine
- lesson registry UI
- routing

To ostaje odgovornost proizvoda koji koristi ovaj content engine.
