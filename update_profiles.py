import os
import glob

REQUIRED_SECTIONS = [
    "Validation Expectations",
    "Testing Expectations",
    "Static Analysis Expectations",
    "Security Expectations",
    "Release Expectations",
    "Evidence Expectations",
    "Common Failure Patterns",
    "Review Expectations",
    "Dependency Rules",
    "Formatting Rules",
    "Runtime Assumptions",
    "Operational Expectations"
]

def update_profile(filepath, profile_type, profile_name):
    if not os.path.exists(filepath):
        print(f"Creating new profile: {filepath}")
        content = f"# {profile_type.capitalize()} Profile: {profile_name}\n\nVersion: 1.0.0\nStatus: Normative\n\n## Scope\n\nDefines expectations for {profile_name}.\n\n"
    else:
        with open(filepath, 'r') as f:
            content = f.read()

    appended = False
    for section in REQUIRED_SECTIONS:
        if f"## {section}" not in content:
            content += f"\n## {section}\n\n- (To be defined: {section.lower()} for {profile_name})\n"
            appended = True

    if appended:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Updated {filepath}")

profile_dirs = {
    "languages": ["php", "go", "nodejs", "javascript", "typescript"],
    "project-types": ["framework", "library", "web-app", "cli", "monorepo", "infrastructure", "api-service"],
    "overlays": ["strict-security", "high-performance", "experimental", "enterprise-regulated"]
}

base_dir = "/home/shomsy/projects/agent-harness/.agents/governance/profiles"

for ptype, profiles in profile_dirs.items():
    d = os.path.join(base_dir, ptype)
    os.makedirs(d, exist_ok=True)
    for p in profiles:
        filepath = os.path.join(d, f"{p}.md")
        update_profile(filepath, ptype, p)

print("Profile updates complete.")
