# 04_ImplementedFlowVerification - Single Feature Smoke Test Workflow

> Skill: 单个功能 smoke 测试
> File id: `04_ImplementedFlowVerification`
> This Markdown file defines a project-local AI workflow skill for focused smoke tests of already implemented features.

This file defines the project-local workflow for checking whether one already implemented feature, subsystem, or narrow gameplay loop still works.

Use this workflow for focused smoke coverage. For visual end-to-end project flow verification, use `05_VisualProjectFlowVerification.md`.

## Trigger

Use this workflow when the user asks to run a smoke test, verify one implemented feature, check a specific completed behavior, validate a script-backed feature loop, or diagnose a failure in an existing non-visual flow.

Typical user prompts:

- `跑一下 StickyMarble smoke`
- `验证 ShieldCounter`
- `确认 Backpack 属性面板 smoke 是否正常`
- `检查单个已实现功能`
- `跑最小 smoke`

## Verification Principles

Use the narrowest meaningful verification first.

Order of preference:

1. Read current handoff, Todo, API contracts, and code overview.
2. Identify the exact completed feature or gameplay loop.
3. Confirm the real source/script entry for that feature.
4. Check local environment if needed by `02_EnvironmentCheck.md`.
5. Run static checks before expensive runtime checks when useful.
6. Run the smallest smoke script that directly covers the feature.
7. Stop after the requested feature is verified unless the failure points to a smaller prerequisite check.

Do not run every test in the repository by default. Select tests based on the current handoff, completed-feature claims, and the user's requested scope.

## Required Pre-Run Report

Before running tests that may take time, launch UE processes, or consume ports, report:

- Target feature or smoke loop to verify.
- Commands to run.
- Expected pass signal.
- Required tools and known paths.
- Port numbers if applicable.
- Whether a UE client/server process will be launched.
- Estimated risk: time, machine load, flaky environment, port conflict, missing cooked assets, or stale content assets.

If the user already gave explicit permission to run the listed tests, proceed. Otherwise ask for confirmation before starting long-running UE smoke tests.

## Standard Checks

Use these checks when they are relevant to the flow:

```powershell
Scripts/CheckIncludeOrder.ps1
git diff --check
```

For Python scripts changed or used as part of the flow:

```powershell
python -m py_compile <script.py>
```

For C++ changes or runtime verification, use the project-known Unreal build path that exists locally, for example:

```powershell
& "D:\WorkSpace\UE\UnrealEngine\Engine\Build\BatchFiles\Build.bat" ProjectEditor Win64 Development "D:\WorkSpace\ProjectTest\Project.uproject" -WaitMutex -NoHotReloadFromIDE
```

If the known path does not exist, check `D:\UE\UnrealEngine\Engine\Build\BatchFiles\Build.bat` before reporting UE build unavailable.

## Known Smoke Entrypoints

Use current docs and scripts as the final source, but these are common verified entrypoints:

```powershell
Scripts/RunDedicatedLobbyGameplayTravelSmoke.ps1 -Port <free-port> -SmokeTimeoutSeconds 120 -RunGameplayReplicationSmoke
Scripts/RunDedicatedLobbyGameplayTravelSmoke.ps1 -Port <free-port> -SmokeTimeoutSeconds 120 -RunBackpackAttributeSmoke
Scripts/RunDedicatedLobbyGameplayTravelSmoke.ps1 -Port <free-port> -SmokeTimeoutSeconds 120 -RunServerPhaseSetNextSmoke
Scripts/RunDedicatedLobbyGameplayTravelSmoke.ps1 -Port <free-port> -SmokeTimeoutSeconds 120 -RunSeededClearSmoke
Scripts/RunDedicatedLobbyGameplayTravelSmoke.ps1 -Port <free-port> -SmokeTimeoutSeconds 120 -RunStickyMarbleSmoke
Scripts/RunDedicatedLobbyGameplayTravelSmoke.ps1 -Port <free-port> -SmokeTimeoutSeconds 120 -RunShieldCounterSmoke
Scripts/RunDedicatedLobbyGameplayTravelSmoke.ps1 -Port <free-port> -SmokeTimeoutSeconds 120 -RunAuthorityModeSmoke
Scripts/RunDedicatedLobbyPlatformSmoke.ps1 -Port <free-port> -SmokeTimeoutSeconds 120
Scripts/RunBoardSingleLocalDedicatedSmoke.ps1 -Port <free-port> -SmokeTimeoutSeconds 120
Scripts/RunBoardMultiplayerRoomSmoke.ps1 -Port <free-port> -SmokeTimeoutSeconds 120
```

Choose a free port and report it.

## Visual Boundary

This workflow does not require visual recording by default.

If the user asks to verify a whole project flow visually, inspect UI/game-view correctness, prove a captured screen is correct, or diagnose black-screen/window-capture issues, switch to `05_VisualProjectFlowVerification.md`.

If a single feature smoke also has a specific visual acceptance requirement, first run the narrow smoke pass here, then use the visual workflow for the visual evidence.

## Failure Reporting

If a check fails, stop expanding scope and report:

- Exact command.
- Exit code.
- Key error lines.
- Which expected pass signal was missing.
- Likely cause based on logs.
- Whether the failure is environment, build, script, runtime, content asset, networking, or unknown.
- Smallest recommended next investigation.

Do not hide partial execution. If a command was interrupted, say which command may have partially run and check for leftover UE/server processes when relevant.

## Completion Report

End with:

- Feature or smoke loop verified.
- Commands run and outcomes.
- Pass log key lines.
- Artifacts generated, such as logs.
- Features not verified and why.
- Residual risk.

If verification changes project state documents, that is a file edit and must follow the confirmation gate.
