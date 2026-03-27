#

```text
   ____ _   _    _    ____ _____ _____ ____     ___  
  / ___| | | |  / \  |  _ \_   _| ____|  _ \   / _ \ 
 | |   | |_| | / _ \ | |_) || | |  _| | |_) | | | | |
 | |___|  _  |/ ___ \|  __/ | | | |___|  _ <  | |_| |
  \____|_| |_/_/   \_\_|    |_| |_____|_| \_\  \___/ 
                                                     
  🛒 HOW TO READ THE DOCS 🛍️
```

One sentence: This chapter explains the canonical reading sequence and operational standards for all PolyMoly documentation.
One sentence: It matters because skipping these rules leads to fragmented understanding, dangerous command execution, and failure to capture required evidence during incidents.

---

## Quick Jump

- [Vocabulary Dictionary](#vocabulary-dictionary-this-chapter)
- [Problem and Purpose](#problem-and-purpose)
- [End User Flow](#end-user-flow)
- [How It Works](#how-it-works)
- [How It Fails](#how-it-fails)
- [How To Fix](#how-to-fix)
- [Pass Signals and Hard Stops](#pass-signals-and-hard-stops)
- [What Did We Learn](#what-did-we-learn)

---

## Vocabulary Dictionary (This Chapter)
- 🛣️ **[Flow Lane](https://en.wikipedia.org/wiki/Special:Search?search=Flow%20Lane)** = One path in the system story (user, runtime, security, ops).
- 🚪 **[Gate](https://en.wikipedia.org/wiki/Special:Search?search=Gate)** = An executable check that must pass before closure.
- 📦 **[Evidence Pack](https://en.wikipedia.org/wiki/Special:Search?search=Evidence%20Pack)** = Artifacts that prove a GO/NO-GO decision.

---

## Problem and Purpose
- **Problem:** People read technical docs out of order, miss context, and apply the wrong fix. 📉
- **Purpose:** Enforce one clear reading path from user journey to recovery and verification. 🏁

### 📖 The Rationale

Technical documentation is often treated as a "reference" where people jump to a random command they found via grep. In a complex SRE environment, this is dangerous. If you run a restore command without reading the "Evidence Pack" chapter, you might destroy a crime scene that contains the only clue to the root cause.

**Lemme explain:**
This chapter is the "Agreement" you sign before entering the city. You agree to follow the path, capture the evidence, and never skip a gate. 🛡️

---

## End User Flow

```text
 [ ⚡ START HERE ] ────> [ 🗺️ system/docs/flow.md ] ────> [ 📖 lane chapter ]
                                                        |
                                                        v
 [ ✅ GO / NO-GO ] <──── [ 📂 evidence ] <──── [ 🛠️ runbook ]
```

---

## How It Works

PolyMoly docs follow a specific "Maturity Ladder". You cannot understand Kubernetes (Level 6) if you don't understand how the Gateway (Level 1) sends traffic to it.

```text
    8. [ 📂 Backlog & Evidence ]
    7. [ ⚖️ Governance & Rules ]
    6. [ ☸️ Kubernetes & Scale ]
    5. [ 📊 Observability & Incidents ]
    4. [ 💾 Memory & Backing Data ]
    3. [ ⚙️ Runtime & State ]
    2. [ 🛡️ Security Controls ]
    1. [ 🏰 User Entry & Edge ]
    0. [ 📍 CHAPTER ZERO ] <--- (You are here)
```

---

## How It Fails

Common failure pattern: an upstream dependency is healthy in isolation but fails under real traffic because one routing, trust, capacity, or timeout assumption is broken.

Failure signal examples: elevated 4xx/5xx, timeout growth, or mismatch between expected and observed request path.

## How To Fix

If you find a broken link or a command that doesn't produce the expected "Evidence Pack", you are required to fix it or flag it.

### Exact Runbook Commands

```bash
# Check doc health
task docs:governance

# Verify all internal links are valid
task docs:links
```

### 📂 Evidence Pack (Collect before state-changing actions)

Before you change any state (restart, delete, scale), you must have these in your terminal buffer or a log file:

- 📸 **Metrics snapshot** for impacted user flow.
- 📝 **Logs export** for the impacted service window.
- 🧬 **Minimum 3 trace IDs** (if tracing exists).

---

## Pass Signals and Hard Stops
- ✅ **Pass signals:** Chapter order is followed, required gates pass, evidence is captured.
- 🛑 **Hard Stop Rules:** No gate pass evidence = No deploy. No rollback path = No deploy.

---

## 📖 READING ORDER CARD

```text
  ┌─────────────────────────────────────────────────────────────┐
  │  1) Open system/docs/flow.md                                       │
  │  2) Pick the lane that matches the task                     │
  │  3) Read the chapter top block first (Problem/Flow/Fix)     │
  │  4) Run required commands                                   │
  │  5) Capture artifacts                                       │
  │  6) Decide GO/NO-GO                                        │
  └─────────────────────────────────────────────────────────────┘
```

## What Did We Learn
- Every task starts from `system/docs/flow.md`, not from random deep links.
- The top chapter block is the mandatory contract.
- GO/NO-GO without evidence is invalid and must be treated as NO-GO.

👉 Next Chapter: **[01-user-entry-and-routing.md](../architecture/gateway-and-edge/01-user-entry-and-routing.md)**
