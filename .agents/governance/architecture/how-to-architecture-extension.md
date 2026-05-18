# Public API Boundary Governance

## 1. Status of This Rule

This document is an architecture extension to the main architecture governance.

It defines when and how a project, library, or component may expose a dedicated public API surface.

This rule is not a style preference.
This rule is not a facade convention.
This rule is not a place to hide unclear design.

It is a boundary rule for stable public API ownership.

---

## 2. Purpose

Some projects expose a public API that external consumers depend on.

Its purpose is to separate:

- what external users are allowed to touch
- what the project owns internally
- what may change freely
- what must remain stable and versioned carefully

A public API is a contract with the outside world.

Internal structure may evolve aggressively.
Public surface must evolve deliberately.

A dedicated public API boundary folder exists to make that boundary visible in the filesystem.

---

## 3. Core Rule

A project may expose a dedicated public API surface when it is consumed by other projects or teams.

However, a public API boundary must be justified.

A project must not create a public API boundary automatically, mechanically, or decoratively.

Use a dedicated public API boundary only when it improves:

- API clarity
- package usability
- boundary safety
- external discoverability
- long-term compatibility
- documentation quality

If a project has no stable external API, it must not create a dedicated public API boundary folder.

---

## 4. Ownership Rule

A public API surface owns external entrypoints only.

It may receive the first user call.

It may normalize simple public input.

It may delegate to internal flows and capabilities.

It must not own the real behavior of the system.

The correct responsibility is:

```text
Public API surface receives external calls.
Internal flows execute behavior.
Internal capabilities provide reusable mechanisms.
Configuration assembles the system.
Foundation provides tiny neutral primitives.
```

A public API surface is a doorway.
It is not the engine.

---

## 5. Mandatory Delegation Rule

Every public surface unit must delegate real work to internal flow, capability, or configuration modules.

A public surface unit may coordinate the first call, but it must not implement the full behavior.

Good:

```text
public/
  Cache.php
    -> delegates to flows that read and store cached values
```

Bad:

```text
public/
  Cache.php
    -> contains storage logic
    -> serializes values directly
    -> calculates TTL internals directly
    -> talks directly to the filesystem
    -> manages driver behavior internally
```

If the public surface starts doing the work, the boundary has failed.

---

## 6. Allowed Contents

A public API boundary folder may contain:

- facade classes
- root public API classes
- public contracts or interfaces
- package entrypoints
- stable aliases
- public DTOs that are part of the external API
- public value objects that are part of the external API
- public factories that protect users from internal construction details

The concrete folder name depends on the project and language.
Some projects use `public/`, `api/`, `exports/`, `surface/`, or another name.
The name should be intuitive for the project context.

---

## 7. Forbidden Contents

A public API boundary folder must not contain:

- business logic
- runtime machinery
- flow implementation
- adapter-specific code
- infrastructure details
- request-scoped mutable state
- service registration internals
- internal registries unless they are intentionally part of the public API
- random helper classes
- generic utility classes
- dumping-ground abstractions
- internals hidden behind public-looking names

---

## 8. Stability Rule

Changing the public API surface is a public API decision.

Any breaking change must be treated as a versioned compatibility change.

This includes:

- renaming public classes or functions
- removing public methods
- changing method signatures
- changing return types
- changing exception behavior
- changing lifecycle guarantees
- changing facade behavior
- changing public DTO or value object shape

Internal modules may change more freely.

The public API surface must change carefully because consumers build code against it.

---

## 9. Small Surface Rule

A public API surface must stay small.

A large public surface is a design warning.

If too many files are needed, ask:

```text
Is the public API too broad?
Are internals leaking?
Are too many concepts exposed?
Is this component doing too much?
Should some APIs be moved behind a smaller facade?
Should some contracts remain internal?
```

A strong public API is usually small, boring, predictable, and easy to document.

---

## 10. No Runtime Leakage Rule

Runtime-specific APIs must not leak into the public API surface.

Project consumers may choose a runtime.

Core public APIs must not force users to know about runtime internals unless the public API is explicitly about runtime
integration.

The public API may expose project-level runtime abstractions.
It must not expose server-specific implementation details.

---

## 11. Request State Rule

A public API surface must not hold request-scoped mutable state.

This is critical for long-lived runtimes.

A public surface unit must not store:

- current request
- current response
- current user
- current session state
- current route match
- current correlation context
- per-request cache
- temporary runtime state

Request-specific state must live in explicit request scope ownership.

This protects the project from leaking state between requests in worker runtimes.

---

## 12. Placement Rule

Use a public API boundary folder inside a project or component root.

The concrete folder name depends on the project.
Do not force a specific name across all projects.

For a framework project, the preferred model is:

```text
project/
  framework/
    System/
      <public-surface-folder>/

  components/
    Cache/
      System/
        <public-surface-folder>/
```

Do not create a top-level repository public surface folder unless the repository itself is a single package with one
system root.

---

## 13. Naming Rule

Files inside a public API boundary folder must use public API names.

Names must be obvious to a user who has not opened the implementation.

A public API name must explain what the user is touching.

---

## 14. Documentation Rule

Every public API boundary folder must be documented.

The documentation must answer:

```text
What is the public API here?
Who is allowed to use it?
What is stable?
What is intentionally hidden?
Which internal flows does it delegate to?
What must not be used directly?
What counts as a breaking change?
```

If the public surface cannot be documented simply, the API is probably too broad or too unclear.

---

## 15. Review Checklist

A public API boundary folder passes architecture review only if all of the following are true:

- every file is externally useful
- every file has a stable reason to exist
- every file is easy to explain to users
- every file delegates instead of implementing internals
- no business logic lives inside it
- no flow implementation lives inside it
- no runtime adapter leaks into it
- no request-scoped mutable state lives inside it
- no service registration internals live inside it
- no random helpers live inside it
- no generic dumping-ground abstractions live inside it
- the public API is small enough to document clearly
- changing it would clearly be understood as a public API change
- removing the folder would make the public API harder to understand

If any item fails, the design must be corrected before the architecture is accepted.

---

## 16. Final Law

A public API boundary folder is allowed only when it protects a real public API boundary.

It must make the system easier to use from the outside and safer to evolve from the inside.

It is not a decoration.
It is not a convenience folder.
It is not a place for internals.

Public surface receives.
Internal flows execute.
Internal capabilities power.
Configuration assembles.
Foundation supports.
