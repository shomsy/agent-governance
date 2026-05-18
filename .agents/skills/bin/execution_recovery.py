#!/usr/bin/env python3
# execution_recovery.py — V6 Failure & Interruption Recovery
#
# Detects and recovers from partial executions, orphan evidence,
# and crashed runtime processes.
#
# Usage:
#   execution_recovery.py scan [--dir DIR]
#   execution_recovery.py mark-failed --exec-id ID [--dir DIR]
#   execution_recovery.py cleanup --older-than SECONDS [--dir DIR]

import os
import sys
import json
import time

OUTPUT_DIR = ".agents/management/evidence/execution"
GENERATED_DIR = ".agents/management/evidence/generated"
SECURITY_DIR = ".agents/management/evidence/security"

STALE_STATES = {"EXECUTING", "PLANNED", "CREATED"}


def scan_stale(target_dir="."):
    """Find incomplete manifests from crashed executions."""
    exec_dir = os.path.join(target_dir, OUTPUT_DIR)
    if not os.path.exists(exec_dir):
        print("No execution directory found.")
        return []

    stale = []
    for fname in os.listdir(exec_dir):
        if not fname.startswith("execution-manifest-"):
            continue
        fpath = os.path.join(exec_dir, fname)
        try:
            with open(fpath, "r", encoding="utf-8") as f:
                manifest = json.load(f)
            state = manifest.get("lifecycle_state", "")
            if state in STALE_STATES:
                ts = None
                history = manifest.get("lifecycle_history", [])
                if history:
                    ts = history[-1].get("timestamp")
                stale.append({
                    "execution_id": manifest.get("execution_id"),
                    "file": fpath,
                    "stale_state": state,
                    "last_timestamp": ts,
                    "age_seconds": time.time() - ts if ts else None,
                })
        except Exception as e:
            stale.append({
                "execution_id": None,
                "file": fpath,
                "stale_state": "CORRUPT",
                "error": str(e),
            })
    return stale


def mark_failed(target_dir, exec_id):
    """Mark a stale execution as FAILED."""
    fpath = os.path.join(target_dir, OUTPUT_DIR, f"execution-manifest-{exec_id}.json")
    if not os.path.exists(fpath):
        print(f"Manifest not found: {exec_id}", file=sys.stderr)
        return False

    with open(fpath, "r", encoding="utf-8") as f:
        manifest = json.load(f)

    if manifest.get("lifecycle_state") not in STALE_STATES:
        print(f"Execution {exec_id} is not stale (state: {manifest.get('lifecycle_state')})")
        return False

    manifest["lifecycle_state"] = "FAILED"
    manifest["lifecycle_history"].append({
        "state": "FAILED",
        "timestamp": time.time(),
        "recovery_reason": "marked_failed_by_recovery_tool",
    })

    tmp_path = fpath + ".tmp"
    with open(tmp_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)
    os.replace(tmp_path, fpath)

    print(f"Marked {exec_id} as FAILED")
    return True


def cleanup_old(target_dir, older_than_sec):
    """Remove stale entries older than the given seconds."""
    stale = scan_stale(target_dir)
    cleaned = 0
    for s in stale:
        age = s.get("age_seconds")
        if age is not None and age > older_than_sec:
            if s.get("execution_id"):
                mark_failed(target_dir, s["execution_id"])
                cleaned += 1
    print(f"Cleaned {cleaned} stale execution(s) older than {older_than_sec}s")
    return cleaned


def cmd_scan(target_dir):
    stale = scan_stale(target_dir)
    if stale:
        print(f"Found {len(stale)} stale execution(s):")
        for s in stale:
            age = s.get("age_seconds")
            age_str = f"{age:.0f}s ago" if age else "unknown age"
            print(f"  {s['execution_id'] or 'CORRUPT'}  state={s['stale_state']}  age={age_str}")

        # Write stale report
        report_path = os.path.join(target_dir, GENERATED_DIR, "stale-executions.json")
        os.makedirs(os.path.dirname(report_path), exist_ok=True)
        with open(report_path, "w") as f:
            json.dump({"stale": stale, "count": len(stale), "scanned_at": time.time()}, f, indent=2)
        print(f"Report: {report_path}")
    else:
        print("No stale executions detected.")
    return 0 if not stale else 2


def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  execution_recovery.py scan [--dir DIR]")
        print("  execution_recovery.py mark-failed --exec-id ID [--dir DIR]")
        print("  execution_recovery.py cleanup --older-than SECONDS [--dir DIR]")
        return 1

    subcmd = sys.argv[1]
    target_dir = "."

    for i, arg in enumerate(sys.argv):
        if arg == "--dir" and i + 1 < len(sys.argv):
            target_dir = sys.argv[i + 1]
            break

    if subcmd == "scan":
        return cmd_scan(target_dir)
    elif subcmd == "mark-failed":
        exec_id = None
        for i, arg in enumerate(sys.argv):
            if arg == "--exec-id" and i + 1 < len(sys.argv):
                exec_id = sys.argv[i + 1]
        if not exec_id:
            print("--exec-id required", file=sys.stderr)
            return 1
        ok = mark_failed(target_dir, exec_id)
        return 0 if ok else 1
    elif subcmd == "cleanup":
        older_than = None
        for i, arg in enumerate(sys.argv):
            if arg == "--older-than" and i + 1 < len(sys.argv):
                older_than = int(sys.argv[i + 1])
        if older_than is None:
            print("--older-than SECONDS required", file=sys.stderr)
            return 1
        cleanup_old(target_dir, older_than)
        return 0
    else:
        print(f"Unknown command: {subcmd}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
