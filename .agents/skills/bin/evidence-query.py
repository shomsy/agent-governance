#!/usr/bin/env python3
# evidence-query.py — V6 Evidence Lineage Query Tool
#
# Query the machine-readable evidence lineage graph.
#
# Usage:
#   evidence-query.py graph [--output PATH]
#   evidence-query.py lineage <exec_id>
#   evidence-query.py list [--session SESSION_ID]
#   evidence-query.py orphans

import os
import sys
import json

_BIN_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _BIN_DIR)

from execution_analysis import build_execution_graph

EVIDENCE_DIR = ".agents/management/evidence"
EXECUTION_DIR = os.path.join(EVIDENCE_DIR, "execution")
GENERATED_DIR = os.path.join(EVIDENCE_DIR, "generated")
SECURITY_DIR = os.path.join(EVIDENCE_DIR, "security")


def cmd_graph(target_dir, output_path=None):
    """Build and output the evidence lineage graph."""
    graph = build_execution_graph(target_dir)

    # V6: Enrich with approval records
    approval_path = os.path.join(target_dir, GENERATED_DIR, "approval-records.jsonl")
    if os.path.exists(approval_path):
        with open(approval_path, "r") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    record = json.loads(line)
                    exec_id = record.get("execution_id")
                    if exec_id and exec_id in graph.get("nodes", {}):
                        graph["nodes"][exec_id]["approval"] = {
                            "decision": record.get("decision"),
                            "danger_class": record.get("danger_class"),
                        }
                except Exception:
                    pass

    # V6: Enrich with session data
    session_path = os.path.join(target_dir, GENERATED_DIR, "session-registry.jsonl")
    if os.path.exists(session_path):
        sessions = {}
        with open(session_path, "r") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    rec = json.loads(line)
                    sessions[rec["execution_id"]] = rec.get("session_id")
                except Exception:
                    pass
        for exec_id, node in graph.get("nodes", {}).items():
            if exec_id in sessions:
                node["session_id"] = sessions[exec_id]

    if output_path:
        out = os.path.join(target_dir, output_path)
        os.makedirs(os.path.dirname(out) or ".", exist_ok=True)
        with open(out, "w") as f:
            json.dump(graph, f, indent=2)
        print(f"Graph written to: {out}")
    else:
        print(json.dumps(graph, indent=2))

    return 0


def cmd_lineage(target_dir, exec_id):
    """Show the full lineage for a specific execution."""
    manifest_path = os.path.join(target_dir, EXECUTION_DIR, f"execution-manifest-{exec_id}.json")
    if not os.path.exists(manifest_path):
        print(f"Manifest not found: {exec_id}", file=sys.stderr)
        return 1

    with open(manifest_path, "r") as f:
        manifest = json.load(f)

    print(f"Execution: {exec_id}")
    print(f"  State: {manifest.get('lifecycle_state')}")
    print(f"  Tier: {manifest.get('trust_tier')}")
    print(f"  Danger: {manifest.get('telemetry', {}).get('danger_class')}")

    lineage = manifest.get("authority_lineage", {})
    if lineage:
        print(f"  Lineage:")
        for k, v in lineage.items():
            print(f"    {k}: {v}")

    replay_contract = manifest.get("replay_contract", {})
    if replay_contract:
        print(f"  Replay Contract: {replay_contract.get('contract_id')}")

    # Check for replay manifests
    replay_count = 0
    if os.path.exists(os.path.join(target_dir, EXECUTION_DIR)):
        for fname in os.listdir(os.path.join(target_dir, EXECUTION_DIR)):
            if fname.startswith("replay-manifest-"):
                try:
                    with open(os.path.join(target_dir, EXECUTION_DIR, fname)) as f:
                        rm = json.load(f)
                    if rm.get("execution_id") == exec_id:
                        replay_count += 1
                        print(f"  Replay: {rm.get('replay_id')} ({rm.get('reproducibility_score')})")
                except Exception:
                    pass

    if replay_count == 0:
        print("  Replay: none")

    return 0


def cmd_list(target_dir, session_id=None):
    """List executions, optionally filtered by session."""
    session_path = os.path.join(target_dir, GENERATED_DIR, "session-registry.jsonl")
    summary_path = os.path.join(target_dir, GENERATED_DIR, "execution-summary.jsonl")

    # Prefer summary for quick listing
    if os.path.exists(summary_path):
        with open(summary_path, "r") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    rec = json.loads(line)
                    if session_id:
                        # Need to cross-reference with session registry
                        pass
                    print(f"{rec['exec_id']}  {rec['status']:12s}  {rec['danger_class']:12s}  {rec['tier']:20s}  {rec['duration_ms']:.1f}ms")
                except Exception:
                    pass
        return 0

    # Fallback: scan manifests
    exec_dir = os.path.join(target_dir, EXECUTION_DIR)
    if not os.path.exists(exec_dir):
        print("No executions found.")
        return 0

    for fname in sorted(os.listdir(exec_dir)):
        if not fname.startswith("execution-manifest-"):
            continue
        try:
            with open(os.path.join(exec_dir, fname)) as f:
                m = json.load(f)
            eid = m.get("execution_id", "")
            if session_id:
                sid = m.get("session_id", "")
                if sid != session_id:
                    continue
            print(f"{eid}  {m.get('lifecycle_state', 'unknown'):12s}  {m.get('trust_tier', 'unknown'):20s}")
        except Exception:
            pass

    return 0


def cmd_orphans(target_dir):
    """Detect orphan evidence."""
    orphans = []

    exec_dir = os.path.join(target_dir, EXECUTION_DIR)
    if not os.path.exists(exec_dir):
        print("No execution directory found.")
        return 0

    # Load audit chain entries
    chain_entries = set()
    chain_path = os.path.join(target_dir, SECURITY_DIR, "hmac-audit-chain.jsonl")
    if os.path.exists(chain_path):
        with open(chain_path, "r") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    entry = json.loads(line)
                    chain_entries.add(entry.get("execution_id"))
                except Exception:
                    pass

    # Check each manifest
    for fname in os.listdir(exec_dir):
        if not fname.startswith("execution-manifest-"):
            continue
        fpath = os.path.join(exec_dir, fname)
        try:
            with open(fpath) as f:
                m = json.load(f)
            eid = m.get("execution_id")
            if eid and eid not in chain_entries:
                orphans.append({
                    "type": "manifest_not_in_chain",
                    "execution_id": eid,
                    "file": fpath,
                })
        except Exception:
            orphans.append({
                "type": "corrupt_manifest",
                "file": fpath,
            })

    # Check for approval records without matching executions
    approval_path = os.path.join(target_dir, GENERATED_DIR, "approval-records.jsonl")
    exec_ids = set()
    if os.path.exists(exec_dir):
        for fname in os.listdir(exec_dir):
            if fname.startswith("execution-manifest-"):
                try:
                    with open(os.path.join(exec_dir, fname)) as f:
                        exec_ids.add(json.load(f).get("execution_id"))
                except Exception:
                    pass

    if os.path.exists(approval_path):
        with open(approval_path, "r") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    rec = json.loads(line)
                    eid = rec.get("execution_id")
                    if eid and eid not in exec_ids:
                        orphans.append({
                            "type": "approval_without_execution",
                            "execution_id": eid,
                        })
                except Exception:
                    pass

    if orphans:
        print(f"Found {len(orphans)} orphan(s):")
        for o in orphans:
            print(f"  [{o['type']}] {o.get('execution_id', o.get('file', ''))}")
        # Write orphan report
        report_path = os.path.join(target_dir, GENERATED_DIR, "orphan-report.json")
        os.makedirs(os.path.dirname(report_path), exist_ok=True)
        with open(report_path, "w") as f:
            json.dump({"orphans": orphans, "count": len(orphans)}, f, indent=2)
        print(f"Report written to: {report_path}")
    else:
        print("No orphan evidence detected.")

    return 0


def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  evidence-query.py graph [--output PATH]")
        print("  evidence-query.py lineage <exec_id>")
        print("  evidence-query.py list [--session SESSION_ID]")
        print("  evidence-query.py orphans")
        return 1

    subcmd = sys.argv[1]
    target_dir = "."

    # Check for --dir flag
    for i, arg in enumerate(sys.argv):
        if arg == "--dir" and i + 1 < len(sys.argv):
            target_dir = sys.argv[i + 1]
            break

    if subcmd == "graph":
        output = None
        for i, arg in enumerate(sys.argv):
            if arg == "--output" and i + 1 < len(sys.argv):
                output = sys.argv[i + 1]
        return cmd_graph(target_dir, output)
    elif subcmd == "lineage":
        if len(sys.argv) < 3:
            print("Usage: evidence-query.py lineage <exec_id>", file=sys.stderr)
            return 1
        return cmd_lineage(target_dir, sys.argv[2])
    elif subcmd == "list":
        session_id = None
        for i, arg in enumerate(sys.argv):
            if arg == "--session" and i + 1 < len(sys.argv):
                session_id = sys.argv[i + 1]
        return cmd_list(target_dir, session_id)
    elif subcmd == "orphans":
        return cmd_orphans(target_dir)
    else:
        print(f"Unknown command: {subcmd}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
