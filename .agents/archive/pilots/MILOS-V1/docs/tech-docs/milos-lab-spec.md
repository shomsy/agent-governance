# MILOS Lab Spec 1.0 🧪

## Overview

The MILOS Lab is an interactive "CSS Internals" environment. Its primary objective is to teach the **mechanics** of the Layout Engine, focusing on modern CSS features like Cascade Layers, Zero-Specificity selectors, and Intrinsic sizing.

## Core Pillars

### 1. Transparency (X-Ray)

Every layout primitive in the preview stage must be "inspectable".

- **Visual Overlays**: Show padding (green), margin (orange), and content (blue) areas.
- **Axis visualization**: Show flex directions and grid tracks.

### 2. Specificity Awareness

The Lab must always display the **Specificity Score** (A, B, C) of the generated CSS.

- **Why**: To prove that `l-box` vs `:where(.l-box)` is a fundamental architectural choice, not a stylistic one.

### 3. The "Why" Panel

Every control must be linked to a mechanical explanation.

- **Toggle @layer** -> Explain global vs layered cascade.
- **Toggle :where()** -> Explain specificity reset.
- **Change var()** -> Explain the Custom Property API.

## Implementation Roadmap

### Phase 1: The Box Foundation (Current)

- Basic UI with Sidebars.
- Live CSS injection.
- Specificity tracker alpha.
- Module: `l-box`.

### Phase 2: Flow & Distribution

- Module: `l-stack` (Flex vertical alignment).
- Module: `l-cluster` (Wrapping mechanics).
- Visualization of "Gaps".

### Phase 3: The Grid Lab

- Module: `l-grid`.
- Interactive track editor (changing `repeat(auto-fit, ...)`).
- Breakpoint-less responsiveness visualization.

### Phase 4: Stress Testing

- **Viewport Resizer**: Handle for scaling the preview area to see intrinsic behavior in action.

## Design System

- **Background**: #0d0f12 (Deep Space).
- **Accents**: #00f2ff (Electric Cyan).
- **Typography**: `JetBrains Mono` for all mechanical data.

---

*This document defines the standard for MILOS interactive learning modules.*
