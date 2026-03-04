# Governance Template

This repository provides a reusable governance baseline for software projects.
It is language-agnostic and repository-agnostic.

## Included baseline

- `AGENTS.md`
- `docs/governance/execution-policy.md`
- `docs/governance/how-to-code-review.md`
- `docs/governance/how-to-coding-standards.md`
- `docs/governance/how-to-document.md`
- `docs/governance/release-and-rollback-policy.md`
- `scaffolds/TODO.md`
- `scaffolds/BUGS.md`

## Adoption model

1. Copy the baseline into the target repository.
2. Keep the global rules intact.
3. Add project-specific overlays only below the baseline contract.
4. Define canonical commands and lane-specific policy in the adopting repository.

## Design rule

The template should stay generic.
Project-specific runtime names, products, folders, and team lore belong in the adopting repository, not here.
