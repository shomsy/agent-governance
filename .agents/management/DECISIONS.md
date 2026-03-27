# DECISIONS

ADR-lite decision log for non-trivial choices.

## Entry Format

- `id`:
- `date`:
- `status`: proposed | accepted | superseded
- `context`:
- `decision`:
- `consequences`:
- `links`:

## Decisions

1. `id`: D-001
   `date`: 2026-03-27
   `status`: accepted
   `context`: The `.agents` scaffold had started to mix reusable governance with project residue, legacy paths, and duplicate laws.
   `decision`: Keep `.agents` strictly agnostic in the `agent-governance` source repo. Move all project-local meaning into child repos or external snapshots, and keep one canonical file per governance theme.
   `consequences`: The kernel stays smaller, clearer, and safer to install across unrelated repositories. Project examples must live outside `.agents`.
   `links`: `.agents/README.md`, `.agents/governance/app-architecture/ARCHITECTURE.md`
