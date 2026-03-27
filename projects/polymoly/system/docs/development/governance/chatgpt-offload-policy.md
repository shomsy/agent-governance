---
scope: system/tools/poly/**,.github/workflows/**,Taskfile.yml,system/docs/development/governance/**
contract_ref: v1
status: stable
---

# ChatGPT Offload Policy (PolyMoly)

Version: 1.1.0
Status: Normative / Enforced
Scope: non-implementation auxiliary tasks

---

## 1) Purpose

Reduce Codex execution load without lowering engineering rigor.

---

## 2) Recommended Offload Targets

1. PR/release note drafting.
2. CI log summarization and triage text.
3. Checklist and acceptance criteria drafting.
4. Alternative option comparison before coding.
5. Heavy external review passes generated from `go run ./system/tools/poly/cmd/poly review pack <target-dir>`.

---

## 3) Model Routing Contract

- `instant`: tiny formatting/short rewrites.
- `auto`: default routine support tasks.
- `thinking`: tradeoff analysis/planning.
- `extended thinking`: high-stakes architecture/security decisions.

For review-pack offload:

1. Generate one merged text bundle with `go run ./system/tools/poly/cmd/poly review pack <target-dir>`.
2. Keep Markdown, env, YAML, and other text files in that bundle by default.
3. Every completed execution pass should refresh that merged bundle before the final user report, even when offload is only optional.
4. Use the narrowest coherent target directory; use repo root when the pass touches governance files, evidence files, or multiple lanes.
5. Prefer `thinking` for normal scoped review.
6. Prefer `extended thinking` for deep code review, security review, release-risk review, or large repository reasoning.

---

## 4) Mandatory User-Facing Note

When useful, include:

`ChatGPT Offload Note: <task> | model: <model> | reason: <short reason>`

If not useful:

`ChatGPT Offload Note: No offload recommended for this step.`
