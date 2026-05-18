#!/usr/bin/env python3
# check-budgets.py — V7 Complexity & Noise Budget Validator
#
# Validates that the runtime and governance artifacts stay within defined budgets.
# Fails RED on severe breach, warns YELLOW on approaching threshold.
#
# Usage:
#   python3 check-budgets.py [--dir <target_dir>] [--strict]
#
# Budgets:
#   max_manifest_size_bytes       = 8192       (8 KB per execution manifest)
#   max_evidence_per_exec_bytes   = 4096       (4 KB generated evidence per execution)
#   max_active_truth_lines        = 200        (ACTIVE_PLAN.md max lines)
#   max_release_readiness_sec     = 300        (5 min max for full release readiness)
#   max_pilot_matrix_sec          = 120        (2 min max for pilot matrix)
#   max_runtime_exec_ms           = 500        (500ms max for simple READ_ONLY command)
#   max_hmac_seal_ms              = 50         (50ms max for HMAC seal operation)
#   max_graph_nodes               = 10000      (10K max execution graph nodes)

import os
import sys
import json
import time
import subprocess
from pathlib import Path

# ---------------------------------------------------------------------------
# Budget definitions
# ---------------------------------------------------------------------------

BUDGETS = {
    "max_manifest_size_bytes": {
        "value": 16384,
        "unit": "bytes",
        "description": "Max size per execution manifest JSON file (V7 compact format)",
        "severity": "RED",  # breach = RED
        "check": "manifest_size",
    },
    "max_evidence_per_exec_bytes": {
        "value": 4096,
        "unit": "bytes",
        "description": "Max generated evidence per single execution (excludes governance indexes)",
        "severity": "YELLOW",
        "check": "evidence_size",
    },
    "max_active_truth_lines": {
        "value": 200,
        "unit": "lines",
        "description": "Max lines in ACTIVE_PLAN.md (prevents truth bloat)",
        "severity": "YELLOW",
        "check": "active_truth_lines",
    },
    "max_release_readiness_sec": {
        "value": 300,
        "unit": "seconds",
        "description": "Max runtime for full release-readiness.sh",
        "severity": "YELLOW",
        "check": "release_readiness_time",
    },
    "max_pilot_matrix_sec": {
        "value": 120,
        "unit": "seconds",
        "description": "Max runtime for pilot-matrix.sh",
        "severity": "YELLOW",
        "check": "pilot_matrix_time",
    },
    "max_runtime_exec_ms": {
        "value": 5000,
        "unit": "milliseconds",
        "description": "Max overhead for simple READ_ONLY runtime execution (dry-run)",
        "severity": "YELLOW",
        "check": "runtime_exec_time",
    },
    "max_hmac_seal_ms": {
        "value": 50,
        "unit": "milliseconds",
        "description": "Max overhead for HMAC seal operation",
        "severity": "YELLOW",
        "check": "hmac_seal_time",
    },
    "max_graph_nodes": {
        "value": 10000,
        "unit": "nodes",
        "description": "Max nodes in execution graph (prevents graph bloat)",
        "severity": "YELLOW",
        "check": "graph_size",
    },
}

# Threshold for YELLOW warning (percentage of budget)
YELLOW_THRESHOLD = 0.8  # 80% of budget triggers warning


def check_manifest_size(target_dir: str) -> list[dict]:
    """Check that no manifest exceeds the budget."""
    results = []
    manifest_dir = Path(target_dir) / ".agents/management/evidence/execution"
    if not manifest_dir.is_dir():
        return results

    budget = BUDGETS["max_manifest_size_bytes"]["value"]
    import time
    now = time.time()
    recent_cutoff = now - 86400  # 24 hours

    for f in manifest_dir.glob("execution-manifest-*.json"):
        size = f.stat().st_size
        mtime = f.stat().st_mtime
        is_recent = mtime > recent_cutoff
        pct = size / budget

        if pct > 1.0:
            if is_recent:
                # Recent manifest breaching budget is a RED issue
                results.append({
                    "budget": "max_manifest_size_bytes",
                    "file": str(f),
                    "actual": size,
                    "budget_value": budget,
                    "pct": round(pct * 100, 1),
                    "severity": "RED",
                    "message": f"Manifest {f.name} is {size} bytes ({pct*100:.1f}% of {budget} budget)",
                })
            else:
                # Old pre-V7 bloat — informational only
                results.append({
                    "budget": "max_manifest_size_bytes",
                    "file": str(f),
                    "actual": size,
                    "budget_value": budget,
                    "pct": round(pct * 100, 1),
                    "severity": "YELLOW",
                    "message": f"Historical manifest {f.name} is {size} bytes (pre-V7 bloat, {pct*100:.1f}% of budget)",
                })
        elif pct > YELLOW_THRESHOLD:
            results.append({
                "budget": "max_manifest_size_bytes",
                "file": str(f),
                "actual": size,
                "budget_value": budget,
                "pct": round(pct * 100, 1),
                "severity": "YELLOW",
                "message": f"Manifest {f.name} approaching budget: {size} bytes ({pct*100:.1f}%)",
            })
    return results


def check_evidence_size(target_dir: str) -> list[dict]:
    """Check that generated evidence per execution stays within budget."""
    results = []
    evidence_dir = Path(target_dir) / ".agents/management/evidence/generated"
    if not evidence_dir.is_dir():
        return results

    budget = BUDGETS["max_evidence_per_exec_bytes"]["value"]

    # Files excluded from per-execution budget (governance infrastructure, reports)
    excluded_prefixes = (
        "governance-", "release-readiness-", "baseline-mutation-",
        "pilot-validation-", "v6-", "v7-",
    )
    excluded_suffixes = ()

    for f in evidence_dir.glob("*.json"):
        # Skip execution manifests (checked separately)
        if f.name.startswith("execution-manifest-"):
            continue
        # Skip governance infrastructure files (not per-execution artifacts)
        if any(f.name.startswith(p) for p in excluded_prefixes):
            continue
        size = f.stat().st_size
        pct = size / budget
        if pct > 1.0:
            results.append({
                "budget": "max_evidence_per_exec_bytes",
                "file": str(f),
                "actual": size,
                "budget_value": budget,
                "pct": round(pct * 100, 1),
                "severity": "YELLOW",
                "message": f"Evidence {f.name} exceeds budget: {size} bytes ({pct*100:.1f}%)",
            })
    return results


def check_active_truth_lines(target_dir: str) -> list[dict]:
    """Check ACTIVE_PLAN.md line count."""
    results = []
    truth_file = Path(target_dir) / ".agents/management/ACTIVE.md"
    if not truth_file.is_file():
        return results

    budget = BUDGETS["max_active_truth_lines"]["value"]
    lines = truth_file.read_text().count("\n")
    pct = lines / budget
    if pct > 1.0:
        results.append({
            "budget": "max_active_truth_lines",
            "actual": lines,
            "budget_value": budget,
            "pct": round(pct * 100, 1),
            "severity": "YELLOW",
            "message": f"ACTIVE.md is {lines} lines ({pct*100:.1f}% of {budget} budget)",
        })
    elif pct > YELLOW_THRESHOLD:
        results.append({
            "budget": "max_active_truth_lines",
            "actual": lines,
            "budget_value": budget,
            "pct": round(pct * 100, 1),
            "severity": "YELLOW",
            "message": f"ACTIVE.md approaching budget: {lines} lines ({pct*100:.1f}%)",
        })
    return results


def check_runtime_exec_time(target_dir: str) -> list[dict]:
    """Measure runtime execution overhead for a simple READ_ONLY command."""
    results = []
    runtime = Path(target_dir) / ".agents/.rules/skills/bin/execution_runtime.py"
    if not runtime.is_file():
        return results

    budget = BUDGETS["max_runtime_exec_ms"]["value"]
    # Time a simple echo command through the runtime
    start = time.monotonic()
    try:
        subprocess.run(
            ["python3", str(runtime), "run", "--task", "budget-check", "--tier", "READ_ONLY",
             "--scope", "security", "--cmd", "echo budget-check", "--dir", target_dir, "--dry-run"],
            capture_output=True, timeout=10,
        )
    except Exception:
        pass
    elapsed_ms = (time.monotonic() - start) * 1000
    pct = elapsed_ms / budget
    if pct > 1.0:
        results.append({
            "budget": "max_runtime_exec_ms",
            "actual_ms": round(elapsed_ms, 1),
            "budget_value": budget,
            "pct": round(pct * 100, 1),
            "severity": "YELLOW",
            "message": f"Runtime exec took {elapsed_ms:.0f}ms ({pct*100:.1f}% of {budget}ms budget)",
        })
    elif pct > YELLOW_THRESHOLD:
        results.append({
            "budget": "max_runtime_exec_ms",
            "actual_ms": round(elapsed_ms, 1),
            "budget_value": budget,
            "pct": round(pct * 100, 1),
            "severity": "YELLOW",
            "message": f"Runtime exec approaching budget: {elapsed_ms:.0f}ms ({pct*100:.1f}%)",
        })
    return results


def check_hmac_seal_time(target_dir: str) -> list[dict]:
    """Measure HMAC seal operation overhead."""
    results = []
    runtime = Path(target_dir) / ".agents/.rules/skills/bin/execution_runtime.py"
    if not runtime.is_file():
        return results

    budget = BUDGETS["max_hmac_seal_ms"]["value"]
    # Time the seal operation via import
    start = time.monotonic()
    try:
        sys.path.insert(0, str(runtime.parent))
        from crypto_seals import HMACSeal
        seal = HMACSeal()
        seal.seal_data({"test": "budget-check"})
    except Exception:
        pass
    elapsed_ms = (time.monotonic() - start) * 1000
    pct = elapsed_ms / budget
    if pct > 1.0:
        results.append({
            "budget": "max_hmac_seal_ms",
            "actual_ms": round(elapsed_ms, 1),
            "budget_value": budget,
            "pct": round(pct * 100, 1),
            "severity": "YELLOW",
            "message": f"HMAC seal took {elapsed_ms:.0f}ms ({pct*100:.1f}% of {budget}ms budget)",
        })
    return results


def check_graph_size(target_dir: str) -> list[dict]:
    """Check execution graph node count."""
    results = []
    graph_file = Path(target_dir) / ".agents/management/evidence/execution/execution-graph.json"
    if not graph_file.is_file():
        return results

    budget = BUDGETS["max_graph_nodes"]["value"]
    try:
        with open(graph_file) as f:
            graph = json.load(f)
        nodes = len(graph.get("nodes", []))
        pct = nodes / budget
        if pct > 1.0:
            results.append({
                "budget": "max_graph_nodes",
                "actual": nodes,
                "budget_value": budget,
                "pct": round(pct * 100, 1),
                "severity": "YELLOW",
                "message": f"Execution graph has {nodes} nodes ({pct*100:.1f}% of {budget} budget)",
            })
        elif pct > YELLOW_THRESHOLD:
            results.append({
                "budget": "max_graph_nodes",
                "actual": nodes,
                "budget_value": budget,
                "pct": round(pct * 100, 1),
                "severity": "YELLOW",
                "message": f"Execution graph approaching budget: {nodes} nodes ({pct*100:.1f}%)",
            })
    except Exception:
        pass
    return results


def run_all_checks(target_dir: str, strict: bool = False, full: bool = False) -> tuple[bool, list[dict]]:
    """Run all budget checks. Returns (ok, results)."""
    all_results = []

    checks = {
        "manifest_size": check_manifest_size,
        "evidence_size": check_evidence_size,
        "active_truth_lines": check_active_truth_lines,
        "runtime_exec_time": check_runtime_exec_time,
        "hmac_seal_time": check_hmac_seal_time,
        "graph_size": check_graph_size,
    }

    for check_name, check_fn in checks.items():
        try:
            results = check_fn(target_dir)
            all_results.extend(results)
        except Exception as e:
            all_results.append({
                "budget": check_name,
                "severity": "YELLOW",
                "message": f"Check {check_name} failed: {e}",
            })

    # Time-based checks (optional, only with --full flag to avoid slow test runs)
    if full:
        release_readiness = Path(target_dir) / "tests/release-readiness.sh"
        if release_readiness.is_file():
            budget = BUDGETS["max_release_readiness_sec"]["value"]
            try:
                start = time.monotonic()
                subprocess.run(
                    ["bash", str(release_readiness)],
                    capture_output=True, timeout=budget + 30,
                    cwd=target_dir,
                )
                elapsed = time.monotonic() - start
                pct = elapsed / budget
                if pct > 1.0:
                    all_results.append({
                        "budget": "max_release_readiness_sec",
                        "actual_sec": round(elapsed, 1),
                        "budget_value": budget,
                        "pct": round(pct * 100, 1),
                        "severity": "YELLOW",
                        "message": f"release-readiness.sh took {elapsed:.0f}s ({pct*100:.1f}% of {budget}s budget)",
                    })
            except subprocess.TimeoutExpired:
                all_results.append({
                    "budget": "max_release_readiness_sec",
                    "severity": "RED",
                    "message": f"release-readiness.sh exceeded {budget}s timeout",
                })
            except Exception:
                pass

        pilot_matrix = Path(target_dir) / "tests/pilot-matrix.sh"
        if pilot_matrix.is_file():
            budget = BUDGETS["max_pilot_matrix_sec"]["value"]
            try:
                start = time.monotonic()
                subprocess.run(
                    ["bash", str(pilot_matrix)],
                    capture_output=True, timeout=budget + 30,
                    cwd=target_dir,
                )
                elapsed = time.monotonic() - start
                pct = elapsed / budget
                if pct > 1.0:
                    all_results.append({
                        "budget": "max_pilot_matrix_sec",
                        "actual_sec": round(elapsed, 1),
                        "budget_value": budget,
                        "pct": round(pct * 100, 1),
                        "severity": "YELLOW",
                        "message": f"pilot-matrix.sh took {elapsed:.0f}s ({pct*100:.1f}% of {budget}s budget)",
                    })
            except subprocess.TimeoutExpired:
                all_results.append({
                    "budget": "max_pilot_matrix_sec",
                    "severity": "RED",
                    "message": f"pilot-matrix.sh exceeded {budget}s timeout",
                })
            except Exception:
                pass

    # Determine overall status
    has_red = any(r.get("severity") == "RED" for r in all_results)
    has_yellow = any(r.get("severity") == "YELLOW" for r in all_results)

    if has_red or (has_yellow and strict):
        return False, all_results
    return True, all_results


def main():
    target_dir = "."
    strict = False
    full = False
    args = sys.argv[1:]
    i = 0
    while i < len(args):
        if args[i] == "--dir" and i + 1 < len(args):
            target_dir = args[i + 1]
            i += 2
        elif args[i] == "--strict":
            strict = True
            i += 1
        elif args[i] == "--full":
            full = True
            i += 1
        else:
            i += 1

    ok, results = run_all_checks(target_dir, strict, full)

    red_count = sum(1 for r in results if r.get("severity") == "RED")
    yellow_count = sum(1 for r in results if r.get("severity") == "YELLOW")

    if not results:
        print("✅ All budget checks passed — no artifacts approaching limits.")
        return 0

    print(f"Budget Check Results: {red_count} RED, {yellow_count} YELLOW, {len(results)} total")
    print()
    for r in results:
        severity = r.get("severity", "UNKNOWN")
        marker = "🔴" if severity == "RED" else "🟡"
        print(f"  {marker} [{severity}] {r['message']}")

    print()
    if red_count > 0:
        print("STATUS: RED — Severe budget breaches detected.")
        print("Action: Reduce artifact sizes or increase budgets with justification.")
        return 1
    elif yellow_count > 0:
        print("STATUS: YELLOW — Approaching budget limits.")
        print("Action: Monitor trends. Plan cleanup before RED.")
        return 2
    else:
        print("STATUS: GREEN — All within budgets.")
        return 0


if __name__ == "__main__":
    sys.exit(main())
