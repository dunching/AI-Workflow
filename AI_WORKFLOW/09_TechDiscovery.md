# 09 — Technical Discovery and Time-boxed Spike

## Trigger
Run discovery before committing to expensive, novel, performance-sensitive or poorly understood architecture (e.g. large crowds, navigation, replication, data pipelines), or when repeated implementation attempts reveal a flawed assumption. Do **not** trigger solely on changed lines of code.

## Discovery procedure
1. State the measurable product constraint and the target environment (engine/tool versions, platform, network topology, target hardware).
2. Search existing engine features, official documentation, mature libraries, open-source implementations and prior project code. Do not claim a search was done if tools are unavailable.
3. For 2–3 viable approaches (reuse, adapt, build, and optionally defer), evaluate behavior fit, development cost, license/attribution obligations, compatibility, maintenance activity, integration, multiplayer authority and performance risks.
4. Separate source-backed facts from estimates and assumptions; link concrete repositories/docs and note their revision dates when possible.
5. Design the smallest falsifiable benchmark with equal workload and acceptance criteria. Time-box the spike; do not build the production implementation during research.
6. Recommend one option with explicit failure conditions and a fallback. For L3, obtain the user's design approval before implementation.

## Disqualifiers
Never claim performance ceilings without comparable measurements. A rendering technique is not automatically navigation, simulation or replication. A repository existing is not proof it is supported or license-compatible. No forced outside search for routine, deterministic fixes.

## Deliverable
Decision question | options and credible sources | tradeoffs | benchmark | recommendation | uncertainty | approval needed.
