#!/usr/bin/env python3
# check-complexity-budget.py — Agent Harness Complexity Budget Enforcer
# Fails if governance entropy exceeds thresholds.

import os
import sys
import json

OUTPUT_DIR = ".agents/management/evidence/generated"

def check_budget(target_dir="."):
    entropy_path = os.path.join(target_dir, OUTPUT_DIR, "governance-entropy.json")
    if not os.path.exists(entropy_path):
        print("❌ ERROR: governance-entropy.json missing. Run compile-governance.py first.")
        sys.exit(1)
        
    with open(entropy_path, 'r') as f:
        entropy = json.load(f)
        
    dead_rules = len(entropy.get("dead_rules", []))
    duplicate_rules = len(entropy.get("duplicate_rules", []))
    
    # Thresholds
    MAX_DEAD = 5
    MAX_DUPLICATE = 0
    
    errors = []
    
    if dead_rules > MAX_DEAD:
        errors.append(f"BLOCKER: Dead rules ({dead_rules}) exceed threshold ({MAX_DEAD}). Clean up abandoned governance.")
        
    if duplicate_rules > MAX_DUPLICATE:
        errors.append(f"BLOCKER: Duplicate rules ({duplicate_rules}) exceed threshold ({MAX_DUPLICATE}). Resolve ID collisions.")
        
    if errors:
        print("❌ Governance Complexity Budget EXCEEDED:")
        for e in errors:
            print(f"  - {e}")
        sys.exit(1)
    else:
        print("✅ Governance Complexity Budget PASSED.")
        sys.exit(0)

if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "."
    check_budget(target)
