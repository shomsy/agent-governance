# Hook Runtime

These scripts are the reusable runtime entrypoints that connect the governance
contracts to real client hook systems.

## Baseline Scripts

- `session-start.sh` initializes session state and context budget files
- `pre-tool-use.sh` enforces trust-tier and dangerous-operation checks
- `post-tool-use.sh` appends tool observations for the learning system

The scripts accept CLI flags and environment variables so different agent
clients can adapt them without rewriting the core logic.
