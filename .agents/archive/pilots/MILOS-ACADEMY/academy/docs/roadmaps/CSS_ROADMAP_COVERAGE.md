# CSS Roadmap Coverage (Academy)

Purpose: Jasno mapiranje roadmap tema na trenutne lekcije, sa statusom i sledećim koracima.

## 🏁 Bootcamp Conversion Progress

All core labs are now converted to the **Engineering Bootcamp** format with:

- ✅ **Repetitive Drills** for muscle memory.
- ✅ **Broken Mode** for debugging practice.
- ✅ **Formal Validation** with progress bars.
- ✅ **Specificity Meters** for real-time score.
- ✅ **Standardized lesson navigation** across the full unlock path.
- ✅ **Shared validation runtime** via `academy/src/presentation/apps/lessons/engine/*`.
- ✅ **A11y baseline** (editor labeling + keyboard-first controls).
- ✅ **No inline styles in core lesson pages** (clean CSS classes in `academy.css`).

---

Status legenda:

- `DONE` = postoji lekcija sa teorijom + sandbox + editor.
- `BOOTCAMP` = lekcija je nadograđena na interaktivni Bootcamp format.
- `TODO` = nema zasebnog kvalitetnog pokrića još.

## 1) Introduction + CSS Hierarchy

1. Cascade strategy: `BOOTCAMP` (`/classroom/lesson/cascade`)
2. Specificity War: `BOOTCAMP` (`/classroom/lesson/cascade`)

## 2) Syntax & Selectors

1. Combinators & Attributes: `BOOTCAMP` (`/classroom/lesson/syntax`)

## 3) Box Model + DNA

1. box-sizing, rem, min/max-width: `BOOTCAMP` (`/classroom/lesson/basics`)

## 4) Flow & Visibility

1. Display/Visibility: `BOOTCAMP` (`/classroom/lesson/display-visibility`)

## 5) Pseudo States

1. Hover, After, Focus: `BOOTCAMP` (`/classroom/lesson/pseudo`)

## 6) Appearance & Paint

1. HSL, Glassmorphism, Shadows: `BOOTCAMP` (`/classroom/lesson/appearance`)

## 7) Layout Engines

1. Flexbox Mastery: `BOOTCAMP` (`/classroom/lesson/flex-flow`)
2. Grid RAM Engine: `BOOTCAMP` (`/classroom/lesson/grid-matrix`)

## 8) Positioning Physics

1. Absolute, Relative, Z-index: `BOOTCAMP` (`/classroom/lesson/positioning`)

## 9) Variable Logic

1. Custom Props, Calc, Clamp: `BOOTCAMP` (`/classroom/lesson/variables`)

## 10) Responsive Future

1. MQ vs CQ Collision: `BOOTCAMP` (`/classroom/lesson/responsive`)

## 11) Motion Branch

1. Transition, Transform, Keyframes: `BOOTCAMP` (`/classroom/lesson/motion`)

## 12) Production Discipline

1. Accessibility + Performance habits: `BOOTCAMP` (`/classroom/lesson/best-practices`)
2. Naming + methodology basics: `BOOTCAMP` (`/classroom/lesson/methodologies`)

## 13) Legacy Awareness

1. Deprecated CSS map (2026): `DONE` (legacy module)

---

## Next Steps

- **2026 Patch**: Add dedicated drills for `@scope`, `abs()`, `sign()`, and root metric units.
- **Capstone**: Finalize `/playground/challenge` with a complete "Milos Challenge".
