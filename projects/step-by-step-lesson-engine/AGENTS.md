# AGENTS

Ovaj repo je mali, izdvojeni lesson-content engine.

## Product Intent

Repo postoji da lesson metadata, intro copy i quiz pitanja mogu da žive u markdown fajlovima, a da JS aplikacija dobije čist i prediktivan contract.

## Architecture

Pravilo ostaje isto:

**folder kaže flow, file kaže odgovornost, function kaže tačnu akciju**

Kanonski tree:

```txt
read-lesson-documents/
  parse-frontmatter.js
  render-markdown.js
  read-lesson-metadata.js
  read-knowledge-check-questions.js
  sync-lesson-documents.js
```

## Naming Rules

- ne uvoditi `utils`, `helpers`, `shared`, `common`, `manager`, `service`
- `parse...` parsira source
- `read...` pretvara source u app-ready shape
- `render...` renderuje markdown u HTML
- `sync...` pravi generated output iz source fajlova

## Source Rules

Source markdown živi u:

```txt
<lesson>/
  content/
    documents/
      files/
        lesson.sr.md
        quiz.sr.md
```

Generated book output živi u:

```txt
<lesson>/
  content/
    documents/
      <lesson_name>.md
```

Generated output se ne uređuje ručno.

## Delivery Discipline

Na kraju svakog većeg završenog rada:

1. pokreni `npm run sync:documents` ako su menjani markdown source fajlovi
2. uradi `git add -A`
3. napravi normalan `git commit`
4. uradi `git push`
