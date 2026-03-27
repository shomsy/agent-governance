# MILOS Technical Documentation

## 1. Purpose

This is the complete technical specification for the MILOS layout engine. It mirrors the exact structure of the `styles/` directory, providing a file-by-file breakdown of every CSS mechanism, property, and architectural decision.

## 2. Directory Structure

- **[Master Index](./master-index.md)**: The `index.css` orchestrator and cascade layer definitions.
- **[MILOS Lab 🧪](./milos-lab-spec.md)**: Interactive laboratory for CSS internals.
- **[00-settings](./00-settings/index.md)**: Global configuration (Tokens, Themes). The "DNA".
- **[01-foundation](./01-foundation/index.md)**: Resets and base element styles.
- **[02-layout](./02-layout/index.md)**: The core layout primitives (Grid, Stack, Sidebar, etc.).
- **[03-runtime](./03-runtime/index.md)**: Dynamic modifiers and logic.
- **[04-elements](./04-elements/index.md)**: Reusable atomic patterns (cards, buttons).
- **[05-scenarios](./05-scenarios/index.md)**: Complex compositions (hero sections, reviews).
- **[06-components](./06-components/index.md)**: Framework-agnostic implementations.
- **[07-utilities](./07-utilities/index.md)**: Visual overrides (text, display, debug).

## 3. How to Read This Documentation

Every file documentation follows a strict template:

1. **Purpose**: Why the file exists.
2. **CSS Fundamentals**: A "textbook" explanation of the underlying CSS mechanisms (Grid, Flex, Custom Properties).
3. **MILOS Logic**: How we specifically implement those mechanisms.
4. **Diagrams**: Visual ASCII representations of behavior.

## 4. Architectural Philosophy

MILOS is built on **Modular Intrinsic Layout Orchestration**.

- **Modular**: Small, composeable files.
- **Intrinsic**: Components size themselves based on content and container context, not viewport width.
- **Orchestration**: The system manages the relationships between elements, rather than micromanaging pixels.
