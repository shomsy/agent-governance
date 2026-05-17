#!/usr/bin/env python3
# compile-governance.py — Agent Harness Governance Compiler
# Parses governance contracts, builds a machine-readable graph, and detects entropy.

import os
import sys
import json
import hashlib
import re

GOVERNANCE_DIR = ".agents/governance"
OUTPUT_DIR = ".agents/management/evidence/generated"

def extract_frontmatter(content):
    frontmatter = {}
    if content.startswith("---"):
        parts = content.split("---", 2)
        if len(parts) >= 3:
            lines = parts[1].strip().split('\n')
            for line in lines:
                if ':' in line:
                    k, v = line.split(':', 1)
                    frontmatter[k.strip()] = v.strip()
    return frontmatter

def compile_governance(target_dir="."):
    gov_path = os.path.join(target_dir, GOVERNANCE_DIR)
    
    index = {"files": {}, "graph": {}, "duplicate_rules": [], "dead_rules": []}
    rule_ids = {}

    if not os.path.exists(gov_path):
        return index

    for root, _, files in os.walk(gov_path):
        for file in files:
            if not file.endswith(".md"):
                continue
            
            filepath = os.path.join(root, file)
            rel_path = os.path.relpath(filepath, target_dir)
            
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            frontmatter = extract_frontmatter(content)
            
            # Extract links to build dependency graph
            links = re.findall(r"\[.*?\]\((.*?\.md)\)", content)
            
            # Simple rule ID extraction (e.g., **Rule ID**: RULE-123)
            ids = re.findall(r"\*\*ID\*\*\s*:\s*([A-Z0-9\-]+)", content, re.IGNORECASE)
            
            file_data = {
                "path": rel_path,
                "frontmatter": frontmatter,
                "links": links,
                "rule_ids": ids,
                "checksum": hashlib.sha256(content.encode('utf-8')).hexdigest()
            }
            
            index["files"][rel_path] = file_data
            index["graph"][rel_path] = links
            
            for rid in ids:
                if rid in rule_ids:
                    index["duplicate_rules"].append(rid)
                else:
                    rule_ids[rid] = rel_path

            if frontmatter.get("status") in ["abandoned", "deprecated"]:
                index["dead_rules"].append(rel_path)

    # Parse root entrypoints for incoming links
    entrypoints = ["AGENTS.md", os.path.join(".agents", "AGENTS.md")]
    for ep in entrypoints:
        ep_path = os.path.join(target_dir, ep)
        if os.path.exists(ep_path):
            with open(ep_path, 'r', encoding='utf-8') as f:
                ep_content = f.read()
                links = re.findall(r"\[.*?\]\((.*?\.md)\)", ep_content)
                index["graph"][ep] = links
                
    # Calculate unreferenced files
    all_targets = set()
    for source, links in index["graph"].items():
        base_dir = os.path.dirname(source)
        for link in links:
            if link.startswith("http"):
                continue
            resolved = os.path.normpath(os.path.join(base_dir, link))
            all_targets.add(resolved)
            
    unreferenced_rules = []
    for filepath in index["files"].keys():
        if filepath not in all_targets and not filepath.endswith("README.md"):
            unreferenced_rules.append(filepath)
            
    index["unreferenced_rules"] = unreferenced_rules

    return index

if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "."
    os.makedirs(os.path.join(target, OUTPUT_DIR), exist_ok=True)
    
    print("⚙️ Compiling Governance...")
    index = compile_governance(target)
    
    graph_hash = hashlib.sha256(json.dumps(index["graph"], sort_keys=True).encode('utf-8')).hexdigest()
    index["graph_sha"] = graph_hash
    
    with open(os.path.join(target, OUTPUT_DIR, "governance-index.json"), "w") as f:
        json.dump(index, f, indent=2)
        
    with open(os.path.join(target, OUTPUT_DIR, "governance-dependency-graph.json"), "w") as f:
        json.dump({"sha": graph_hash, "graph": index["graph"]}, f, indent=2)
        
    with open(os.path.join(target, OUTPUT_DIR, "governance-entropy.json"), "w") as f:
        json.dump({
            "dead_rules": index["dead_rules"], 
            "duplicate_rules": index["duplicate_rules"],
            "unreferenced_rules": index["unreferenced_rules"]
        }, f, indent=2)

    print(f"✅ Compilation complete. Graph SHA: {graph_hash}")
    print(f"📊 Processed {len(index['files'])} files. Found {len(index['duplicate_rules'])} duplicates, {len(index['dead_rules'])} dead rules, {len(index['unreferenced_rules'])} unreferenced rules.")
