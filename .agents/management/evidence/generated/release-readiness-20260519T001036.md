# Release Readiness Report

**Timestamp:** 20260519T001036
**Status:** RED

## Summary

- Total: 39
- Passed: 29
- Failed: 7
- Warnings: 6

## Blocking Failures

- verify-governance.sh: exit_code=14, output=🔍 [KERNEL] Verifying Agent Harness Governance at /home/shomsy/projects/agent-harness...
🔍 [KERNEL] Checking Anti-Bloat Policy...
✅ [KERNEL] Anti-Bloat Gates Passed.
🔍 [KERNEL] Detecting Orphan/Noise E
- pilot-matrix.sh: exit_code=1, output==============================================
AGENT HARNESS — CI PILOT MATRIX
=============================================
Timestamp: 20260519T001036
Temp root: /tmp/agent-harness-pilot-matrix
Harnes
- leakage-scan: api-service-20260519T001036 (nodejs): exit_code=1, output==============================================
PROFILE LEAKAGE SCANNER v2
=============================================
Pilot:   /tmp/agent-harness-pilot-matrix/api-service-20260519T001036/
Language: n
- leakage-scan: clean-empty-repo-20260519T001036 (unknown): exit_code=1, output==============================================
PROFILE LEAKAGE SCANNER v2
=============================================
Pilot:   /tmp/agent-harness-pilot-matrix/clean-empty-repo-20260519T001036/
Langua
- leakage-scan: conflicting-governance-20260519T001036 (php): exit_code=1, output==============================================
PROFILE LEAKAGE SCANNER v2
=============================================
Pilot:   /tmp/agent-harness-pilot-matrix/conflicting-governance-20260519T001036/

- leakage-scan: node-cli-20260519T001036 (nodejs): exit_code=1, output==============================================
PROFILE LEAKAGE SCANNER v2
=============================================
Pilot:   /tmp/agent-harness-pilot-matrix/node-cli-20260519T001036/
Language: node
- leakage-scan: php-library-20260519T001036 (php): exit_code=1, output==============================================
PROFILE LEAKAGE SCANNER v2
=============================================
Pilot:   /tmp/agent-harness-pilot-matrix/php-library-20260519T001036/
Language: p
