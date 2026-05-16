# Active Bugs

This file captures active defects, regressions, and hotfixes.
It feeds planning when a bug needs active implementation work.

## Update Rules

- keep newest items at the top
- describe the visible failure first
- describe what the user should see when the bug is fixed
- if the bug affects lesson UX, keep the user goal and step-by-step learning path visible
- use `YYYY-MM-DD HH:MM` timestamps so age and urgency are visible
- add `owner`, `estimate`, `blocked_by`, and `acceptance` when the bug needs active work
- move implementation work into `.agents/management/evidence/TODO.md` when the fix becomes actionable
- move closed bugs into `.agents/management/evidence/CHANGELOG.md`

## Current Items

1. `[bug][low] 2026-03-27 15:15 - Razmotriti sanitizaciju tagText pre innerHTML` - `system/animator-engine/play-lesson/02-follow-lesson/show-current-step.js:28` koristi `innerHTML` sa lesson podacima. Za sada prihvatljivo jer su lesson fajlovi pod kontrolom developera.
