# Architecture

This repo follows a small business-first screaming architecture.

Read the tree in this order:

1. Flow
2. File responsibility
3. Function action

Current shape:

```txt
read-lesson-documents/
  parse-frontmatter.js
  render-markdown.js
  read-lesson-metadata.js
  read-knowledge-check-questions.js
  sync-lesson-documents.js
```

Rules:

- `parse...` reads raw markdown structure
- `read...` returns app-ready lesson data
- `render...` returns HTML from markdown
- `sync...` writes generated lesson book files

This repo is intentionally narrow.
It is not a full LMS.
It is not a full tutorial shell.
