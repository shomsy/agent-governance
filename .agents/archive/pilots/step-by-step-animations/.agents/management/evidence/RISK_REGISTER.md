# Risk Register

Tracks active and accepted risks.

## Entry Format

- `id`:
- `severity`: low | medium | high | critical
- `likelihood`: low | medium | high
- `impact`:
- `mitigation`:
- `owner`:
- `status`: open | accepted | mitigated | closed

## Active Risks

1. `R-001`
   - severity: low
   - likelihood: low
   - impact: lesson text could be rendered unsafely if trust model changes
   - mitigation: review sanitization policy and runtime rendering guardrails
   - owner: unassigned
   - status: open
