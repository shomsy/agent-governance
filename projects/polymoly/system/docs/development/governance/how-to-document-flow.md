---
scope: product/**,system/**,system/tools/poly/**,system/docs/development/governance/**
contract_ref: v3
status: stable
---

# How To Document Flow (PolyMoly)

Version: 3.1.0
Status: Normative / Enforced
Scope: `product/**`, `system/**`, `system/tools/poly/**`

This file is the law for programming-facing `how-this-works.md` pages.

Use it when the question is:

- how should a `how-this-works.md` page be written
- what must a folder doc explain so a new operator can really use it
- how should files and functions be attached to real command flow
- how do we stop generated filler from looking complete when it is not

If [how-this-works-template.md](./how-this-works-template.md) ever drifts from
this file, this file wins.

Keep deeper shared writing doctrine in
[how-to-document.md](./how-to-document.md).
Keep naming law in
[how-to-coding-standards.md](./how-to-coding-standards.md).

## 0) Core Idea

Flow docs must explain movement, not inventory.

The reader should be able to retell one concrete path like this:

`command or trigger -> first file -> first function -> main decision -> handoff -> visible result -> failure path`

If the page only says what folders, files, or functions exist, it is not done.

Checklist completion is not success.
Reader retellability is success.

## 1) Canonical Success Test

A 10/10 `how-this-works.md` page lets a new reader answer all of these without
guessing:

1. What is this folder really for?
2. Which exact command or trigger wakes it up?
3. Which file and function catch that flow first?
4. Which function makes the main decision?
5. Which files only help that decision happen?
6. What gets written, changed, rendered, or executed?
7. What does the user see on screen?
8. What does the system leave behind on disk or as evidence?
9. What does refusal or failure look like?
10. Where should I debug first?
11. Which terms are easy to confuse here?
12. Why are these folder, file, and function names honest?

If any answer is missing, the page is incomplete.

## 2) Naming Mirror Rule

Flow docs must reinforce the code naming law instead of compensating for weak
names with prettier prose.

Use this exact mnemonic:

- folder says the flow
- file says the responsibility
- function says the exact action

Rules:

1. If the described behavior does not match the folder, file, or function name,
   say so plainly.
2. Do not normalize ambiguous naming drift through explanation alone.
3. If the drift matters to operability, record it in `TODO.md` or `BUGS.md`.
4. Do not hide broad or technical verbs behind softer prose.
5. Do not pretend a name is honest when the code says otherwise.

## 3) Writing Posture

Every flow doc teaches in this order:

1. human layer
2. command-story layer
3. technical layer

### 3.1 Human Layer

Start like you are explaining the system to:

- a new teammate on day one
- an operator who does not know Go yet
- or your own child sitting next to you

That does not mean childish.
It means plain, direct, and calm.

### 3.2 Command-Story Layer

After the simple opening, show one real story:

- the exact command or trigger
- the first file
- the first function
- the main decision point
- the next handoff
- the visible result
- the failure path

### 3.3 PM Story Rule

The page must read like a guided walkthrough, not like a generated checklist.

Preferred tone:

- `When you type \`poly ...\`, the first files and functions that matter are:`
- `This is the moment the story stops being just a command and becomes a file
  write, runtime check, proof artifact, or next handoff.`
- `At the end, the user sees ...`

Avoid generic stand-ins when the code can name a real thing.

Bad:

- `the current command or parent caller reaches this folder`
- `the next layer gets a cleaner handoff`

Better:

- `When you type \`poly install\`, the CLI lands in \`runInstall(...)\`, then
  this slice copies the binary into \`.polymoly/bin/poly\` and writes
  \`poly-install.json\`.`

### 3.4 Technical Layer

After the reader understands the story, explain the direct files and functions
that make it real.

### 3.5 Forbidden Tone

Do not open with:

- philosophy
- architecture poetry
- taxonomy before purpose
- vague words like `handles`, `works with`, `supports`, or `does the step`
- abstract placeholders instead of real code names
- generic filler like `the flow reaches this slice` when the file and function
  names are known

## 4) Required Folder Contract

Each first-party ownership folder must contain `how-this-works.md`.

The page must explain:

- what real flow this folder owns
- how that flow is reached
- which direct files matter first
- what the folder changes, writes, returns, or reads
- what happens next
- what can go wrong

### 4.1 Canonical Folder Heading Shape

Use this heading order unless a stricter local truth requires a slightly plainer
name.

1. `What this folder is`
2. `Real commands that reach this folder`
   or `Real commands or triggers that reach this folder`
3. `Exact CLI front doors`
   or `Exact upstream handoffs`
4. `The simplest story`
   or `The shortest mental model`
5. `The first important path`
6. `Direct files in this folder`
7. `Child folders in this folder` when child folders exist
8. `Debug first`
9. `What to remember`
10. `Dictionary`

Do not invent a different heading set just to sound fresh.

### 4.2 Required Folder Content

Every folder page must:

1. name at least one real command or trigger
2. explain the folder in a calm tutorial tone before it turns into reference
   prose
2. name the first relevant file and function
3. show one concrete path from entry to result
4. say what comes in
5. say what decision or transformation happens here
6. say what goes out
7. say what gets written, changed, or observed
8. say what the user sees or what artifact exists because of it
9. say what refusal, fallback, or failure looks like
10. say where to debug first
11. end with a dictionary for the terms that the page depends on

### 4.3 Command-Facing Folders

If a user can type a real `poly ...` command that reaches this folder, the page
must use:

- `Real commands that reach this folder`
- `Exact CLI front doors`

The page must show the exact CLI entry file and entry function.

Example shape:

- `system/tools/poly/internal/cli/route_root_commands.go`
- function: `RouteRootCommands(args []string) int`
- `poly new ...` -> `runProjectNew(...)`

### 4.4 Internal-Only Folders

If the folder is not directly reached by a typed command, the page may use:

- `Real commands or triggers that reach this folder`
- `Exact upstream handoffs`

But the page must still connect itself to a real command story through the
nearest honest caller.

Bad:

- `this slice wakes up when the flow reaches this slice`

Good:

- `poly preview` reaches `RouteRootCommands(...)`, then the engine hands a
  resolved step into `system/engine/apply/`

## 5) The First Important Path Rule

Every folder page must include one concrete path that a new reader can follow
without guessing.

### 5.1 Required Story Shape

When possible, start with the exact command:

```bash
poly ...
```

Then show:

1. the first file and function that catch it
2. the main decision or transformation inside this folder
3. the next file, function, or layer that receives the result
4. what the user sees or what artifact exists at the end

The prose around that path should feel like a guided tour.

Preferred opener:

- `When you type \`poly ...\`, the first files and functions that matter are:`

### 5.2 Mermaid Rule

Use Mermaid `sequenceDiagram` by default for the first important path.

Rules:

1. start with `autonumber` unless it would clearly make the picture worse
2. use real participant names like `RouteRootCommands`, `runProjectNew`,
   `ApplyCommandSpec`, or `projectcfg.WriteProject`
3. do not use fake participants like `Upstream Flow`, `This Folder`, or
   `Next Handoff`
4. show real arguments, return values, file writes, prints, and refusals
5. use `alt`, `opt`, and `loop` for real branches only
6. the prose immediately after the diagram must follow the same step order
7. if a command writes a file, proof, or manifest, show that write in the
   story instead of leaving the result abstract

### 5.3 Flowchart Exception

Use `flowchart` only when topology or branching teaches better than call order.

If you use `flowchart`:

1. put `1.`, `2.`, `3.` inside the nodes
2. keep the labels short and concrete
3. make the colors carry meaning, not decoration
4. keep the same step order in the prose under the diagram

## 6) File-First Contract

A folder page must explain the folder file by file.

Do not split files and functions into disconnected inventories.
Every function must appear under the file that owns it or under the parent
function context that owns it.

### 6.1 Honest File Classes

When you describe a file, say what kind of file it is:

- contract file
- entrypoint or router file
- decision or orchestrator file
- transform or render file
- mutation or write file
- observe or read file
- compatibility or bridge file
- proof or test file

### 6.2 Required File Content

Every direct first-party file chapter must say:

1. what this file is in one plain sentence
2. why this file name is the honest responsibility name
3. when this file wakes up in a real story
4. which caller or parent function reaches it
5. what inputs it receives
6. what outputs, side effects, or artifacts it produces
7. what the user may see because of this file, when that is true
8. what it does not own, when confusion is likely
9. where to open first when debugging

### 6.3 Contract-Only Files

If a file only defines request or config shape and has no functions, say that
directly.

Good:

- `This file is only the poly new request contract.`
- `There are no functions here. That is fine.`

Bad:

- `This file works with new project behavior.`

### 6.4 Compatibility Files

If a file mainly forwards to another surface, the page must say that openly.

Use words like:

- compatibility
- forwarding wrapper
- bridge
- adapter handoff

Do not present a wrapper as if it owns the behavior.

## 7) Function Coverage Contract

Every function must be covered.

That does not mean every function gets the same amount of prose.

### 7.1 Depth Levels

- Level A: front doors, major pivots, major decisions, major mutations
- Level B: important helpers that shape validation, transformation, writes, or
  failure behavior
- Level C: tiny helpers with no standalone teaching value

### 7.2 Level A And Level B Function Minimum

Every Level A or Level B function needs:

1. what this function does
2. why it exists
3. what input it receives
4. what main decision, transform, or write it performs
5. what output or side effect it produces
6. why that result matters next
7. what command story it belongs to
8. what symptom should send a debugger here first
9. a visual function flow
10. a numbered walkthrough under that diagram

### 7.3 Level C Helper Minimum

Tiny helpers may stay inside parent context, but they still need:

- who calls them
- why the parent needs them
- what they return or change
- why the caller cares

Helper coverage is mandatory.
Helper over-expansion is optional.

## 8) What Must Be Explained Absurdly Simply

Do not assume the reader can infer these distinctions.
Spell them out.

### 8.1 Decision Owner Versus Executor

Say who decides and who only carries out the result.

Examples:

- CLI routes
- product expresses user-facing story
- engine decides
- adapter touches the outside world

### 8.2 Intent Versus Runtime State

Say whether the page is talking about:

- the desired shape
- the rendered plan
- the live observed state

Do not blur them together.

### 8.3 Disk Writes Versus In-Memory Work

Say whether the step:

- only shapes data in memory
- writes files to disk
- updates `.polymoly`
- starts or reads runtime
- writes release evidence

### 8.4 What The User Sees

If the code prints a summary, warning, preview, diff, refusal, or next step,
the page should say so.

### 8.5 Safety Shape

If the flow mutates anything important, the page must say which safety shape
exists:

- preview
- diff
- confirmation
- refusal
- rollback
- evidence

### 8.6 Wizard And Prompt Flows

If the flow is interactive, explain:

1. what the wizard asks
2. in what order it asks
3. what each answer changes later
4. where the answers are written or reused

### 8.7 Commonly Confused Terms

When relevant, explain the difference between pairs like:

- `intent` and `runtime state`
- `preview` and `apply`
- `plan` and `command spec`
- `template` and `starter`
- `service` and `plugin`
- `rendered file` and `live runtime`

## 9) Dictionary And Link Rule

Every `how-this-works.md` page should end with `## Dictionary`.

Use it for:

- page-critical terms
- easily confused terms
- local terms that the reader will click more than once

Rules:

1. give each important term an anchor like `<a id="dictionary-project"></a>`
2. use relative Markdown links to local or sibling definitions
3. keep dictionary wording simple enough for a child, but technically honest
4. if one folder owns the canonical meaning for a term, child pages may link to
   that definition instead of rewriting it badly

## 10) Visual Quality Rule

Mermaid is not decoration.
It is a teaching tool.

### 10.1 Required

1. every folder page needs at least one main path diagram
2. every materially revised direct file needs a file diagram
3. every Level A or Level B function needs a function diagram
4. every such diagram needs a numbered prose walkthrough directly under it
5. colors must carry meaning, not random styling

### 10.2 Strongly Preferred

- use one calm palette per page
- make input, main work, output, and refusal visually distinct
- use notes for args, returns, written artifacts, or warnings
- use `autonumber` in `sequenceDiagram`

## 11) Anti-Filler Rule

The following patterns are not acceptable as final prose:

- `handles`
- `works with`
- `for this file`
- `use the owned file or child slice`
- `return the local result`
- `this slice wakes up when the flow reaches this slice`
- `this folder is the X lane` with no concrete behavior after it

The following patterns are also invalid:

- file and function lists with no real behavior explanation
- diagrams with fake participants instead of real file or function names
- invented behavior that the code does not prove
- generic debugging advice that does not point to a specific function

If a page could have been written without opening the code, it is probably too
generic.

## 12) Review Scorecard

Before you ship or approve a page, ask:

1. Can a new reader retell one concrete flow from command to result?
2. Did the page name the exact first file and function?
3. Did it name the main decision owner?
4. Did it distinguish helpers from decision points?
5. Did it say what gets written, changed, or executed?
6. Did it say what the user sees?
7. Did it say what refusal or failure looks like?
8. Did it say where to debug first?
9. Did it explain the confusing terms?
10. Did it avoid filler and fake diagrams?

If any answer is `no`, the page is not 10/10 yet.

## 13) Relationship To The Template

The template is a writing scaffold.
This file is the law.

Use the template to start fast.
Use this file to finish honestly.
