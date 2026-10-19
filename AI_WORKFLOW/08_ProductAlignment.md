# 08 — Product Alignment and Value Gate

## Purpose
Do not confuse successful implementation with a valuable product outcome. Before committing to a major task, identify its connection to the project's own product vision, intended users, and current release milestone. Universal workflow must **not** hardcode any particular game's genre or commercial goals.

## When to apply
- L1 (small, known, reversible): concise check; do not delay straightforward fixes.
- L2 (cross-system feature): explicitly describe user value, priority and acceptance.
- L3 (new architecture, major investment, high uncertainty or irreversible decision): separate decision review before implementation, including alternatives and approval.

## Required questions
1. What user/player outcome is improved? How does it support the project's documented core pillars or essential correctness?
2. What happens if we do not do it now?
3. What is the smallest testable slice? What is explicitly out of scope?
4. What observable evidence would confirm or falsify its value?
5. Is this more important than the currently committed release blockers?
6. What are the stop conditions and review date?

## Priority discipline
- Distinguish product leverage from safety/reliability: security, data integrity, server authority and release-breaking defects may be essential even when they are not marketable features.
- Mark questionable value as `VALUE-REVIEW`, never automatically prescribe mocks or hardcoding.
- Prototype shortcuts must be clearly isolated, non-production and removable. Never mock authoritative permissions, persistence or economic transactions in released flows.
- Present product critique as a recommendation, not an unauthorized change of task scope.
- If vision or milestone is missing, say so and ask for the minimal necessary clarification; do not invent market certainty.

## Decision output for L2/L3
Product hypothesis; alignment; expected benefit and evidence; time/cost constraints (estimates marked as estimates); risks; alternatives (including postpone); recommendation; approval gate.
