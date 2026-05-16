import os

profiles_to_polish = [
    ("/home/shomsy/projects/agent-harness/.agents/governance/profiles/languages/php.md", "PHP"),
    ("/home/shomsy/projects/agent-harness/.agents/governance/profiles/languages/go.md", "Go"),
    ("/home/shomsy/projects/agent-harness/.agents/governance/profiles/languages/nodejs.md", "NodeJS"),
    ("/home/shomsy/projects/agent-harness/.agents/governance/profiles/languages/javascript.md", "JavaScript"),
    ("/home/shomsy/projects/agent-harness/.agents/governance/profiles/languages/typescript.md", "TypeScript")
]

for filepath, name in profiles_to_polish:
    if os.path.exists(filepath):
        with open(filepath, 'r') as f:
            content = f.read()
        
        # Replace placeholders with slightly better defaults
        content = content.replace("- (To be defined: validation expectations for " + name.lower() + ")", "- use standard build/compile/lint commands as validation")
        content = content.replace("- (To be defined: testing expectations for " + name.lower() + ")", "- 100% pass rate on canonical test suites")
        content = content.replace("- (To be defined: static analysis expectations for " + name.lower() + ")", "- Zero errors at level 5/standard for " + name)
        content = content.replace("- (To be defined: security expectations for " + name.lower() + ")", "- No high/critical vulnerabilities in dependencies")
        content = content.replace("- (To be defined: release expectations for " + name.lower() + ")", "- Artifacts must be versioned and published to private/public registries")
        content = content.replace("- (To be defined: evidence expectations for " + name.lower() + ")", "- Validation logs must be attached to release packs")
        content = content.replace("- (To be defined: common failure patterns for " + name.lower() + ")", "- dependency version mismatch, missing lockfiles")
        content = content.replace("- (To be defined: review expectations for " + name.lower() + ")", "- strict review for breaking API changes")
        content = content.replace("- (To be defined: dependency rules for " + name.lower() + ")", "- pin all dependencies; no wildcards")
        content = content.replace("- (To be defined: formatting rules for " + name.lower() + ")", "- follow " + name + " community standard formatting")
        content = content.replace("- (To be defined: runtime assumptions for " + name.lower() + ")", "- assumes stable runtime version " + name)
        content = content.replace("- (To be defined: operational expectations for " + name.lower() + ")", "- process must handle SIGTERM/SIGINT gracefully")

        with open(filepath, 'w') as f:
            f.write(content)

print("Polished profiles.")
