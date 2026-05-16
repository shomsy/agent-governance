# 03-runtime/

## 1. Folder Purpose

This directory contains utility classes that modify the layout behavior of **individual items** within a layout primitive. While `02-layout` defines the container rules (Grid/Stack), `03-runtime` allows children to override those rules (e.g. "I want to be last" or "I want to fill the remaining space").

## 2. Layer Definition

**Layer: LAYOUT**
These are atomic layout modifiers.

## 3. Dependency Direction

- **Imported By:** `styles/03-runtime/runtime.css` (aggregator).
- **Forbidden:** No complex structures. Single property overrides only.

## 4. File Relationships

- `sizing.css`: Flex grow/shrink/fit logic.
- `ordering.css`: Flex/Grid order.
- `self.css`: Self-alignment.

## 5. Architectural Notes

These are "Runtime" utilities because they are often applied dynamically or as one-off overrides in the template logic.
