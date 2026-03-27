# cluster.css

## 1. Purpose

This is the main entry point for the Cluster layout primitive. It imports both the core structure and the extensive alignment modifiers in the correct dependency order.

## 2. Architectural Layer

**Layer: LAYOUT**
It bundles the `l-cluster` component.

## 3. Core Concept

- **Mechanism:** `@import` Aggregation.
- **Why Chosen:** To allow consumers to get the full `l-cluster` feature set with a single line.

## 4. CSS Fundamentals (MANDATORY)

### @import Order

- **Importance:** Base styles must be defined *before* modifiers.

## 5. CSS Properties Breakdown

None.

## 6. MILOS Implementation Logic

We split `base` and `alignment` because the base `l-cluster` is extremely common (gap + center), while `align-start/end/stretch` are specialized tweaks.

## 7. Interaction Matrix

| Works With | Conflicts With | Not Intended With |
| :--- | :--- | :--- |
| Build Tools | Circular imports | |

## 8. Nesting & Collapse Behavior

- **@layer layout:** All cluster styles are contained within the `layout` cascade layer.

## 9. Diagram (MANDATORY)

```text
cluster.css
├── base.css       (.l-cluster)
└── alignment.css  (.l-cluster--)
```

## 10. Valid Example

```css
@import url("./02-layout/cluster.css");
```

## 11. Invalid Example

```css
/* Importing modifiers before base is risky */
@import url("./02-layout/cluster/alignment.css");
@import url("./02-layout/cluster/base.css");
```

## 12. Boundaries

- **Does NOT** contain styles.

## 13. Engine Decision Log

- **Why granular imports?** Separating logic makes it easier to scan for "just the base behavior" vs "what modifiers exist".
