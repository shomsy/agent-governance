#!/usr/bin/env python3
# runtime_subprocess.py — V6 Programmatic Execution API
#
# Routes Python subprocess calls through execution_runtime.py.
# Other Python tools should import this instead of calling subprocess directly.
#
# Usage:
#     from runtime_subprocess import runtime_exec
#     success, result = runtime_exec("echo hello", tier="READ_ONLY", scope="security")
#
#     # Dry run
#     success, result = runtime_exec("rm -rf /tmp/test", tier="READ_ONLY", dry_run=True)

import os
import sys

_BIN_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _BIN_DIR)

from execution_runtime import ExecutionRuntime


def runtime_exec(
    command: str,
    tier: str = "READ_ONLY",
    scope: str = "security",
    task: str = "programmatic",
    target_dir: str = ".",
    dry_run: bool = False,
    parent_token: dict = None,
) -> tuple:
    """Execute a command through the full execution runtime.

    Returns (success: bool, result: str).
    result is the execution_id on success, or an error message on failure.
    """
    runtime = ExecutionRuntime(target_dir=target_dir)
    return runtime.execute(
        task=task,
        tier=tier,
        domain_scope=scope,
        task_command=command,
        parent_token_dict=parent_token,
        dry_run=dry_run,
    )


def runtime_status(target_dir: str = ".") -> str:
    """Get execution substrate health status."""
    runtime = ExecutionRuntime(target_dir=target_dir)
    return runtime.status()


def runtime_replay(exec_id: str, target_dir: str = ".") -> tuple:
    """Replay a past execution and verify integrity."""
    runtime = ExecutionRuntime(target_dir=target_dir)
    return runtime.replay_execution(exec_id)


def runtime_classify(command: str) -> dict:
    """Classify a command's danger level without executing."""
    from execution_runtime import DangerClassifier
    return DangerClassifier.classify(command)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: runtime_subprocess.py <command>")
        print("  Routes command through execution runtime.")
        sys.exit(1)

    cmd = " ".join(sys.argv[1:])
    success, result = runtime_exec(cmd)
    if success:
        print(f"SUCCESS: {result}")
        sys.exit(0)
    else:
        print(f"FAILED: {result}", file=sys.stderr)
        sys.exit(1)
