---
title: project-lifecycle-access-how-this-works
owner: product@polymoly
last_reviewed: 2026-03-13
classification: internal
---

# Project Lifecycle Access How This Works

## What this folder is

`product/project/lifecycle/access/` is the folder that answers:

- what [URLs](#dictionary-url) belong to this project?
- can PolyMoly open one of them for me?

## Real commands or triggers that reach this folder

- `poly open`
- helper callers that only want the [endpoint](#dictionary-endpoint) map

## Exact CLI front doors

When you type `poly open`, the command path is:

- `RouteRootCommands(...)`
- `runOpen(...)`
- `access.Open(...)`
- `gateway.LaunchLocalBrowser(...)`

If a caller only wants URLs, it usually skips `runOpen(...)` and calls
`ResolveEndpoints(...)` directly.

## The simplest story

- a caller wants either one project URL or the full endpoint map
- this folder either resolves endpoints or opens one chosen URL
- the gateway adapter returns the endpoint map or performs the browser launch

```mermaid
flowchart TD
    classDef step1 fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#1B5E20;
    classDef step2 fill:#E3F2FD,stroke:#1565C0,stroke-width:2px,color:#0D47A1;
    classDef step3 fill:#FFF3E0,stroke:#EF6C00,stroke-width:2px,color:#E65100;
    classDef step4 fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px,color:#4A148C;

    A["1. caller wants a project URL answer"]:::step1 --> B["2. this folder either resolves endpoints or opens one URL"]:::step2
    B --> C["3. gateway adapter builds the endpoint map"]:::step3
    B --> D["3. gateway adapter launches the local browser"]:::step4
```

## The first important path

When you type:

```bash
poly open
```

the important path is:

```mermaid
sequenceDiagram
    autonumber
    participant CLI as runOpen
    participant Access as Open
    participant Gateway as LaunchLocalBrowser
    participant Result as VisibleResult

    CLI->>Access: Step 1: hand over the chosen project URL
    Access->>Gateway: Step 2: ask the OS/browser boundary to open it
    Gateway-->>Access: Step 3: return nil or error
    Access-->>Result: Step 4: hand the CLI a success or fallback result
```

- **Step 1:** The CLI already chose the URL it wants to open.
- **Step 2:** This folder crosses into the adapter boundary instead of opening
  browsers by itself.
- **Step 3:** The gateway adapter returns success or error.
- **Step 4:** The caller decides whether to print success or a manual-open
  fallback message.

## Direct files in this folder

### `resolve_service_endpoints.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- it owns the endpoint-map handoff and nothing else

When the story opens this file:

- a caller only wants URLs and does not need browser launch

What arrives here:

- the current project intent

What leaves this file:

- the endpoint map for that intent
- one clean gateway handoff for URL discovery

Why you open it first:

- endpoint names are wrong
- endpoint values are wrong
- a project URL is missing

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as resolve_service_endpoints.go
    participant Next as gateway.EndpointMap

    Note over Caller,File: Input: project intent
    Caller->>File: Step 1: call `ResolveEndpoints(intent)`
    File->>Next: Step 2: forward into the gateway adapter
    Next-->>Caller: Step 3: return the endpoint map
```

- **Step 1:** The caller already has the project shape it wants to inspect.
- **Step 2:** This file forwards URL discovery into the adapter boundary.
- **Step 3:** The caller gets one endpoint map back.

Important functions:

- `ResolveEndpoints(intent)`
  Main action in this file. It forwards the project intent into the gateway
  adapter and returns the resulting endpoint map.

### `expose_project_url.go`

This file is one direct stop in the story for this folder.

Why this name is honest:

- it owns one browser-open handoff and nothing else

When the story opens this file:

- `poly open` or another caller already knows which URL should be opened

What arrives here:

- the repo root
- one chosen URL

What leaves this file:

- a nil-or-error browser-open result
- one clean handoff into the gateway adapter

Why you open it first:

- `poly open` cannot launch the browser
- browser launch behavior changes

```mermaid
sequenceDiagram
    autonumber
    participant Caller as ParentFlow
    participant File as expose_project_url.go
    participant Next as gateway.LaunchLocalBrowser

    Note over Caller,File: Input: repo root, chosen URL
    Caller->>File: Step 1: call `Open(root, url)`
    File->>Next: Step 2: ask the gateway adapter to launch the browser
    Next-->>Caller: Step 3: return nil or error
```

- **Step 1:** The caller already chose the URL.
- **Step 2:** This file pushes browser work into the adapter boundary.
- **Step 3:** The caller gets one success-or-error result back.

Important functions:

- `Open(root, url)`
  Main action in this file. It forwards one chosen URL into the gateway adapter
  so the local browser can be opened.

## Child folders in this folder

This folder has no child folders in scope.

## Debug first

- start in `ResolveEndpoints(...)` when the URL map itself is wrong
- start in `Open(...)` when browser launch is wrong

## What to remember

- [endpoint](#dictionary-endpoint) truth comes from the
  [gateway](#dictionary-gateway) adapter
- this folder keeps the product-facing names simple
- it does not implement browsers or endpoint rules by itself

## Dictionary

<a id="dictionary-endpoint"></a>
- `endpoint`: An endpoint is one concrete address the user or another tool can
  call, such as `http://localhost:8080`. It is the "here is where the app
  lives" answer.
<a id="dictionary-url"></a>
- `URL`: A URL is the literal text form of that address. It is what `poly open`
  eventually hands to the browser layer.
<a id="dictionary-gateway"></a>
- `gateway`: Gateway is the routing edge that knows how requests enter the
  project. In simple terms, it is the traffic doorman that tells requests where
  to go.
<a id="dictionary-browser-launch"></a>
- `browser launch`: Browser launch means asking the operating system to open a
  URL in a local browser. This folder does not implement browsers itself; it
  forwards that work to the adapter layer.
<a id="dictionary-adapter"></a>
- `adapter`: An adapter is the boundary piece that talks to the outside world
  for the product layer. Here the gateway adapter knows how to build endpoint
  maps and how to ask the OS to open a browser.
