#!/usr/bin/env python3
# lint-governance.py — Agent Harness Governance Linter
# Enforces machine-executable governance rules against the compiled index.

import os
import sys
import json

OUTPUT_DIR = ".agents/management/evidence/generated"

def lint_governance(target_dir="."):
    index_path = os.path.join(target_dir, OUTPUT_DIR, "governance-index.json")
    if not os.path.exists(index_path):
        print("❌ ERROR: governance-index.json missing. Run compile-governance.py first.")
        sys.exit(1)
        
    with open(index_path, 'r') as f:
        index = json.load(f)
        
    errors = []
    
    # 1. Duplicate Rule Check
    if index.get("duplicate_rules"):
        for dr in index["duplicate_rules"]:
            errors.append(f"BLOCKER: Duplicate Rule ID found: {dr}")
            
    # 2. Dead Links Check
    graph = index.get("graph", {})
    files = index.get("files", {})
    for filepath, links in graph.items():
        base_dir = os.path.dirname(filepath)
        for link in links:
            if link.startswith("http"):
                continue
            # Basic relative resolution
            resolved = os.path.normpath(os.path.join(base_dir, link))
            if not os.path.exists(os.path.join(target_dir, resolved)):
                errors.append(f"HIGH: Broken governance link in {filepath} -> {link}")
                
    # 3. Required Frontmatter
    for filepath, data in files.items():
        if "governance/core" in filepath and "status" not in data.get("frontmatter", {}):
            errors.append(f"MEDIUM: Missing required 'status' frontmatter in core governance: {filepath}")

    if errors:
        print("❌ Governance Linting FAILED:")
        for e in errors:
            print(f"  - {e}")
        sys.exit(1)
    else:
        print("✅ Governance Linting PASSED.")
        sys.exit(0)

if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "."
    lint_governance(target)
