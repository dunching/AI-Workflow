# 11 — Local Loop Circuit Breaker

## Trigger conditions
- Three unsuccessful modification/verification cycles on the same root problem (default review threshold, not a promise of success).
- Two changes with repeating regressions (`fix A, break B`) or rising blast radius.
- No causal evidence after repeated patches, or implementation time exceeds the agreed budget.
- A new viable approach materially changes the assumptions behind the selected design.

## Actions
1. Stop repetitive speculative patching. Preserve changes, failures, logs and the last known-good revision; do not auto-reset worktrees.
2. Reconstruct the causal chain, reproduction and failing acceptance test. Distinguish product requirement from implementation choice.
3. Offer at least two alternatives: narrowed fix, architecture substitution, requirement simplification, spike or temporary deferral.
4. Compare cost, user impact, rollback and acceptance criteria. Request user approval for a changed design or expanded scope.
5. Resume with one falsifiable hypothesis and a capped verification budget.

## Exceptions
Critical data-loss, security or production outage issues require immediate containment, not indefinite shutdown. Read-only diagnosis and evidence collection continue during the breaker. Do not use a rigid attempt count to refuse a justified, low-risk fix.

## Review artifact
Symptom; attempt history; what evidence falsified; competing hypotheses; alternative decision; next experiment; stop condition.
