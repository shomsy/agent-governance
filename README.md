# agent-governance

Reusable parent agent contract and governance ruleset for software projects.

This repository exists to hold the quality bar you want to reuse across future
repositories without copying one project's internal layout into every other
project.

## Layout

- `PARENT-AGENTS.md`
  The reusable base contract meant to be copied into adopting repositories.
- `AGENTS.md`
  The local maintenance contract for this repository itself.
- `docs/governance/**`
  Reusable detailed rules that the parent and child contracts can point to.
- `scaffolds/AGENTS.md`
  Example child `AGENTS.md` showing local override over the parent contract.
- `scaffolds/TODO.md`
  Minimal active backlog scaffold.
- `scaffolds/BUGS.md`
  Minimal defect and risk backlog scaffold.

## Intended Model

Use this repository as `base + local override`, not as hidden inheritance.

The intended precedence in an adopting project is:

1. local `AGENTS.md`
2. copied `PARENT-AGENTS.md`
3. copied governance docs under `docs/governance/**`
4. local project backlog and README

That means:

- the parent defines reusable engineering quality expectations
- the local child defines repository-specific commands, paths, and architecture
- detailed process stays in the governance docs
- executable truth stays in scripts, task runners, and automated gates

## Adoption Workflow

1. Copy `PARENT-AGENTS.md` into the target repository.
2. Copy `docs/governance/**` into the target repository.
3. Copy `scaffolds/TODO.md` and `scaffolds/BUGS.md` if you want the backlog base.
4. Create a local `AGENTS.md` using `scaffolds/AGENTS.md` as the starting point.
5. Define the target repository's canonical dev, validation, and release
   entrypoints in the local `AGENTS.md`.

## Design Rules

- Keep the parent generic.
- Keep the local child short and specific.
- Move broad procedures into governance docs.
- Move concrete commands into tooling whenever possible.
- If a rule changes often, it probably does not belong in the parent contract.
