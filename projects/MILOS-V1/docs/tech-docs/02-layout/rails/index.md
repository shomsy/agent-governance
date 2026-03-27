# 02-layout/rails/

## 1. Folder Purpose

This directory contains the `l-rails` system, which is a specialized grid for editorial content that mixes standard-width text with wide-width media (the "Medium.com" style).

## 2. Layer Definition

**Layer: LAYOUT**
It defines a specific reading environment layout.

## 3. Dependency Direction

- **Imports:** `00-settings/tokens` (for container sizes).
- **Imported By:** `02-layout/rails.css` (aggregator).
- **Forbidden:** No responsive logic that breaks reading flow.

## 4. File Relationships

- `base.css`: Defines the 5-track grid.
- `spans.css`: Defines classes to place items into those tracks.

## 5. Known Overlaps

- `l-grid` is for 2D item placement (cards). `l-rails` is for 1D flow that breaks out horizontally.

## 6. Architectural Notes

The "Rails" name comes from the idea of content running along a central rail with occasional deviations.
