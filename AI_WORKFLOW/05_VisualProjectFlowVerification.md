# 05_VisualProjectFlowVerification - Visual Project Flow Verification Workflow

> Skill: 以可视化的方式验证项目流程的正确性
> File id: `05_VisualProjectFlowVerification`
> This Markdown file defines a project-local AI workflow skill for end-to-end visual verification of project flows.

This file defines the project-local workflow for automatically driving a real user-facing project flow and checking whether the expected business visuals actually appear in a real client window.

This workflow is not merely "record a smoke test". It must verify the visible correctness of the project flow and its key business states.

Use this workflow for end-to-end visual evidence. For a narrow non-visual feature smoke, use `04_ImplementedFlowVerification.md`.

## Trigger

Use this workflow when the user asks to visually test a project flow, inspect game flow with screen evidence, verify UI/game-view correctness, diagnose missing visual business behavior, diagnose black screen or invisible UE windows, or confirm that a recorded flow shows the intended project window and business state.

Typical user prompts:

- `用视觉的方式测试游戏流程`
- `可视化检查从 Board 到 InGame`
- `以可视化方式验证项目流程`
- `自动跑完整流程看看业务表现是否正常`
- `进入平台选择后平台预览是不是生成了`
- `确认 OBS 路径是否正常`
- `为什么录屏是黑的`

## Current Default Visual Evidence Path

For this project, the current default visual evidence path is **UE process-internal checkpoint screenshots** captured by the real client process. This default applies before considering OBS, FFmpeg, desktop capture, or any external window recorder.

When using this default UE checkpoint screenshot path, automated visual runs should launch the client with `-RenderOffScreen`. This keeps default AI / Agent visual checks independent from desktop windows and reduces interference between parallel sessions.

OBS and FFmpeg are not default verification paths. Use them only when:

- The user explicitly asks for video evidence.
- The task is specifically about OBS, FFmpeg, black-screen recording, window binding, or external capture diagnostics.
- UE checkpoint screenshots were attempted or planned and cannot capture the required evidence for this run.

Historical OBS records and `RunObs*` scripts are still useful as older evidence or exception-path diagnostics, but they do not override this current default.

Important: `-RenderOffScreen` is only the default for UE process-internal screenshot runs. If the run uses OBS, FFmpeg, desktop/window capture, or human live inspection, launch a real visible window instead and use fixed window geometry such as `-windowed -WinX=<x> -WinY=<y> -ResX=<w> -ResY=<h>`.

## Default Full Project Flow Target

Unless the user narrows the scope, the default visual project flow is:

```text
Start Board client
  -> click Single Player
  -> launch local Dedicated Server
  -> join Lobby / platform selection
  -> verify platform selection UI and selected platform preview are visible
  -> ready / start gameplay travel
  -> enter GameplayMap
  -> verify the first Gameplay server phase and local mode
  -> verify InGame platform, HUD, phase UI, and key gameplay visuals
  -> verify each implemented Gameplay phase or local mode that the current flow is expected to cover
```

If the current automation script only starts at Lobby or only proves `PASS GameplayReplication`, report that as partial coverage. Do not call it full project-flow visual verification.

Current project target:

```text
Board
  -> Single Player
  -> local Dedicated Server
  -> Lobby / platform selection / platform preview
  -> GameplayMap
  -> ServerPhase.Trade as the first Gameplay phase
  -> verify SunCoin >= 500, merchant interaction, first purchase, and Backpack/equipment access in Trade
  -> ServerPhase.InGame
  -> verify BattleObjective selection under InGame, battle HUD, movement, and attribute changes
  -> return to Trade or proceed to Settlement/Spectator according to the flow being tested
```

## Verification Principles

Visual verification supports, but does not replace, logs, builds, authority checks, replication checks, or smoke pass signals.

For this project, the default visual evidence path is **UE process-internal checkpoint screenshots** captured by the real client process during the flow. This is the preferred path because multiple AI / Agent sessions may run visual checks on the same machine at the same time. Each run must isolate its port, run id, screenshot directory, log path, and render size so visual evidence cannot be overwritten or mixed with another agent's run.

Default UE checkpoint screenshot runs should use `-RenderOffScreen`. Do not use `-RenderOffScreen` for OBS, FFmpeg, desktop/window capture, or live human inspection runs, because those exception paths need a visible window to capture or observe.

Hard gate: do not start with OBS, FFmpeg, desktop capture, or external window recording as the primary visual evidence path. Before using any external capture path, the AI / Agent must first try the UE checkpoint screenshot path, or explicitly report why that UE path cannot produce the needed artifact for this run. If the UE path is missing a needed checkpoint, prefer adding or using a targeted UE screenshot checkpoint before falling back to OBS. External capture can supplement UE screenshots, but it must not silently replace them.

For continuous motion, trails, particles, transient VFX, animation, or timing-sensitive effects, the primary evidence should still be UE process-internal screenshots captured at meaningful before / during / after checkpoints. OBS video may be added as supporting evidence only after those UE checkpoints are planned or attempted, or after the limitation is reported clearly.

Order of preference:

1. Read current handoff, Todo, API contracts, and code overview.
2. Identify the project flow to verify, including user-facing steps and expected business visuals.
3. Confirm the real source/script entry for that flow.
4. Prefer an automation path that drives the real user path with mouse and keyboard input, such as clicking Board Single Player, clicking Ready, pressing Backpack/Trade/Settlement buttons, and using normal movement keys, rather than jumping directly into a later map or invoking hidden debug shortcuts.
5. Capture UE process-internal screenshots from the real project client at meaningful checkpoints.
6. Generate or inspect a checkpoint screenshot set and contact sheet before claiming success.
7. Compare visual artifacts against the expected business assertions for each checkpoint.
8. Use OBS or FFmpeg only as a documented exception: user explicitly asks for video evidence, window-capture diagnostics are the target, or UE process-internal screenshots were attempted/planned and cannot capture the required evidence.

Do not accept a log PASS alone as visual evidence. Do not accept "the window was recorded" as proof that the business flow is correct.

## Player Input Automation Rule

Visual project-flow verification should simulate a real player as much as the local automation environment allows.

Default preference:

1. Use mouse clicks for visible UI actions, including Board menu selection, Lobby platform cards, Ready/start buttons, merchant interaction UI, Backpack actions, Settlement buttons, and return/restart actions.
2. Use keyboard input for normal player actions, including movement, UI hotkeys such as Backpack, confirm/cancel, rotation, escape/back, and other bound gameplay inputs.
3. Wait for visible UI or gameplay state changes after each input before continuing.
4. Keep the real client window focused and record the same window that receives the input.
5. Treat command-line flags, console commands, direct RPC smoke hooks, forced phase changes, and state injection as helper mechanisms, not as replacements for player-path coverage.

Allowed helper use:

- Use launch flags to configure the test fixture, such as port, timeout, deterministic smoke mode, run id, screenshot directory, window geometry, or optional recording output paths.
- Use console commands, RPC smoke hooks, or direct state changes only when the target step cannot yet be driven reliably by mouse/keyboard, when the UI for that step is not implemented, or when a narrow internal assertion is needed after the visible player path has reached the relevant state.
- When helpers are used, report exactly which flow segments were not driven by mouse/keyboard and why.
- If a critical user-facing step is bypassed by a helper, do not call the result a full real-user visual flow pass. Classify it as partial coverage or explicitly document the automation limitation.

Mouse/keyboard input is not a substitute for authority, replication, build, or log checks. It is the preferred way to drive the visible user path before those supporting checks are interpreted.

## Targeted Visual Camera Rule

When the verification target is a local mesh or presentation detail, the default player camera may be the wrong evidence angle.

Examples include generated enemy meshes, enemy spawn height, platform placement height, platform preview alignment, mounted component visuals, drag/install previews, range decals, item drops, and VFX that need a close or stable view.

For these checks, the automation may create or use a temporary verification camera and switch the client view to it before capturing checkpoints. The camera should be positioned to make the target readable, with explicit distance, angle, field of view, framing, and follow/lock behavior when relevant.

Rules:

- Use the normal player path to reach the state being inspected whenever practical, then switch to the verification camera for the targeted visual assertion.
- Report that the artifact comes from a verification camera, not the normal player view.
- Do not treat a verification-camera pass as proof that the effect is readable from the default player camera. If the task is about player-facing readability, also capture the normal player camera or classify the result as targeted visual coverage only.
- Restore the normal view or clearly report that the camera remains switched for the rest of the test.
- If the camera is spawned through a helper command, RPC smoke hook, test actor, or debug path, classify that part as helper-driven coverage and document why it was needed.

## Business Visual Assertions

A complete visual project-flow verification must define and check business visual assertions before it runs.

Minimum assertions for the current project flow:

- Board:
  - Board/start screen is visible in the real project client.
  - Single Player entry is visible and can be activated through a mouse click or a clearly documented player-equivalent input path.
  - After activation, the UI enters an expected waiting/loading/launching state rather than doing nothing.
- Local Dedicated Server launch:
  - The client does not become a Listen Server as the formal path.
  - The visible client transitions toward Lobby after the local server is ready.
- Lobby / platform selection:
  - Lobby or platform selection UI is visible.
  - Platform selection and Ready/start should be driven by mouse click or normal UI input when those controls are implemented and reachable.
  - The selected platform identity is visible or inferable from UI/state.
  - The selected platform preview must be generated and visible. If the platform preview is missing, the visual verification fails even if logs pass.
  - Ready/start action is visible or the automation has a documented equivalent.
- Gameplay travel:
  - Transition/loading/travel state is visible or documented.
  - The client reaches GameplayMap visually, not only through a log line.
- InGame:
  - Player platform/Pawn is visible in the game view.
  - HUD and server phase/local mode UI are visible.
  - Movement and common interaction checks should use the same input path a player uses, such as keyboard movement keys and visible UI/hotkey commands, unless a helper limitation is reported.
  - For each implemented phase or local mode covered by the script, check its expected UI and business visual state.
  - Battle should show the expected battle HUD/objective context and gameplay view.
  - Trade is the merged preparation phase for the current target flow: it should allow merchant purchase and Backpack/equipment access.
  - Rest is legacy/compatibility coverage only unless the current task explicitly asks to validate it.
  - InGame should expose or reflect the selected child BattleObjective, not just the parent ServerPhase.InGame tag.
  - Settlement should show the expected end-state/settlement context if the flow covers it.

The assertions should be adapted to the current task. If a phase is not reachable by the current automation, report it as not verified instead of implying coverage.

## Coverage Classification

Classify the result explicitly:

- Full visual flow pass: the automation drove the intended user path and all declared business visual assertions passed.
- Full real-user visual flow pass: the automation drove every critical user-facing step with mouse/keyboard or equivalent bound player input, and all declared business visual assertions passed.
- Partial visual pass: only part of the flow was covered, such as Lobby -> Gameplay, and the missing coverage is listed.
- Visual business failure: the flow ran but a required business visual was absent or wrong, such as a missing platform preview.
- Capture failure: the business flow may or may not have run, but the recording artifact is black, wrong-window, stale, occluded, or missing.
- Log-only pass: logs passed but visual artifacts are insufficient; this is not a visual pass.

## Required Pre-Run Report

Before running a visual verification that launches UE, captures screenshots or video, or consumes ports, report:

- Target project flow to verify.
- Whether the run is intended to be full or partial coverage.
- Commands to run.
- Mouse/keyboard input plan: which visible UI/gameplay steps will be clicked or keyed, which window must be focused, and which steps, if any, use helpers instead.
- Expected log pass signal.
- Business visual assertions to check.
- Camera plan: whether the run uses the normal player camera, a temporary verification camera, or both; if a verification camera is used, report target actor/mesh, location or attachment strategy, angle, distance, FOV, switch timing, and restore behavior.
- Visual capture tool and capture mode. Default to UE process-internal checkpoint screenshots. If proposing OBS, FFmpeg, or any external recorder, include the exact reason UE checkpoint screenshots are insufficient or unavailable for this run, and whether UE screenshots will still be captured as primary evidence.
- Port numbers if applicable.
- UE server/client launch plan.
- Run isolation plan: `RunId`, screenshot directory, log paths, port, render mode, and render size. For default UE checkpoint screenshots, state that the client will use `-RenderOffScreen`; for OBS/FFmpeg/window capture, state the visible client window geometry instead.
- Output screenshot, contact-sheet, summary JSON, video, and frame locations when predictable.
- Known capture risk: black screen, stale frame, screenshot command not implemented, wrong client process, occlusion for fallback capture, multi-project window overlap, missing OBS WebSocket, or FFmpeg desktop contamination.
- Known automation risk: script starts too late in the flow, does not click the real UI path, cannot keep the client focused, cannot drive a control by mouse/keyboard, cannot assert a visual checkpoint, or cannot reach all InGame phases.

If the user already gave explicit permission to run the listed visual test, proceed. Otherwise ask for confirmation before starting long-running UE or recording processes.

## Default UE Checkpoint Screenshot Path

For this project, UE process-internal checkpoint screenshots are the default capture path for visual project-flow verification.

Required behavior:

1. Launch the real UE client with deterministic, isolated run parameters.
2. Use a unique `RunId` per visual run, such as `<Flow>_<Port>_<Timestamp>` or a GUID.
3. Use a unique port per run and never reuse another active agent's port.
4. Use a unique screenshot directory per run, for example `Saved/AutomationScreenshots/<RunId>/`.
5. Use a unique log path per run.
6. Launch the client with `-RenderOffScreen` and an explicit render size, for example `-RenderOffScreen -ResX=<w> -ResY=<h>`. This is the default for UE process-internal checkpoint screenshots.
7. Capture named checkpoint screenshots from inside the UE client process after visible business states are reached.
8. Print a log line for every captured checkpoint, including checkpoint name and absolute or project-relative screenshot path.
9. Generate a contact sheet from the checkpoint screenshots at the end of the run.
10. Reject black/blank/empty screenshots, stale screenshots, wrong-size screenshots, or screenshots that do not show the intended client state.
11. Keep the client open until the final checkpoint has been captured and written.
12. If a screenshot checkpoint is missing, do not replace it with a log PASS. Classify the run as log-only or partial visual coverage.

Recommended project launch parameters for screenshot-enabled visual smoke:

```text
-ProjectVisualSmokeRunId=<RunId>
-ProjectVisualSmokeScreenshotDir=<absolute-or-project-relative-output-dir>
-RenderOffScreen
-NoObs
-ResX=<w> -ResY=<h>
```

If the run is explicitly using OBS, FFmpeg, desktop/window capture, or human live inspection, do not use `-RenderOffScreen`. Use a visible window with fixed geometry instead:

```text
-NoObs
-windowed -WinX=<x> -WinY=<y> -ResX=<w> -ResY=<h>
```

Recommended checkpoint artifact names:

```text
01_board_initial.png
02_board_launch_waiting.png
03_lobby_platform_preview.png
04_gameplay_entered.png
05_ingame_battle_ready.png
06_feature_specific_state.png
contact_sheet.jpg
summary.json
```

Recommended script output summary:

```json
{
  "runId": "<RunId>",
  "coverage": "partial visual pass | full visual flow pass | visual business failure | capture failure | log-only pass",
  "logPath": "...",
  "screenshotDir": "...",
  "contactSheet": "...",
  "checkpoints": [
    { "name": "ingame_battle_ready", "path": "...", "status": "passed" }
  ],
  "visualRisks": []
}
```

The implementation may use UE screenshot APIs or equivalent project helpers. The important contract is that screenshots are produced by the real client process at declared checkpoints and stored in the run's isolated output directory.

## OBS Window Capture Path

OBS Studio Window Capture through OBS WebSocket is no longer the default path. It is an exception path and supporting evidence path. Do not use OBS as the first or primary evidence path unless the user explicitly asks for video evidence, the task is specifically diagnosing window-capture/rendering problems, or the UE process-internal screenshot path has already been attempted/planned and cannot capture the required evidence.

For continuous timing, motion trails, animation, particles, or short-lived VFX, first plan UE checkpoint screenshots at the relevant moments. Use OBS only to supplement those checkpoints or after reporting why the UE checkpoint path is not sufficient for the target effect.

OBS requires a real visible client window. Do not launch the client with `-RenderOffScreen` for OBS Window Capture runs; use fixed visible window geometry instead.

Do not use OBS as a shared global recorder for multiple concurrent agents on the same desktop. A single OBS instance has global scenes, sources, recording state, and WebSocket configuration; concurrent agents can overwrite each other's capture target or output. OBS is acceptable for concurrent work only when each agent has a separately isolated desktop/user session or explicitly isolated OBS profile/WebSocket port/output directory.

Do not use FFmpeg as the first fallback if UE checkpoint screenshots are available. Use FFmpeg only when process-internal screenshots are unavailable and OBS is unavailable/unreliable, or when the user explicitly asks for FFmpeg.

Required behavior:

1. Capture the UE project client window, not the whole desktop.
2. Bind the source to the `UnrealEditor.exe` project window, for example `Project ... :UnrealWindow:UnrealEditor.exe`.
3. Run a preflight `SaveSourceScreenshot` or equivalent screenshot before recording.
4. Reject black/blank preflight output before starting a long recording.
5. Start recording only after the source is bound and the preflight is valid.
6. Keep the UE client open until the post-pass recording hold completes.
7. Capture or extract meaningful checkpoints, not only a single post-pass frame.
8. Stop recording through OBS WebSocket.
9. Close OBS gracefully; do not force-kill `obs64.exe` unless explicitly accepting the next-start recovery-dialog risk.

Current reusable entrypoints may include:

```powershell
Scripts/RunObsBoardToInGameVisualSmoke.ps1 -Port <free-port> -SmokeTimeoutSeconds 180 -PostPassRecordSeconds 2 -RunInGameFlowVerification
Scripts/RunObsLobbyToGameplayVisualSmoke.ps1 -Port <free-port> -ServerReadyTimeoutSeconds 300 -SmokeTimeoutSeconds 140 -PostPassRecordSeconds 6
Scripts/StopObsGracefully.ps1
```

Use current docs and scripts as the final source.

Important: if the current OBS script only verifies Lobby -> Gameplay, state that it is partial and recommend or implement a fuller Board -> InGame automation path when the task requires full project-flow verification.

## FFmpeg Fallback Path

If UE checkpoint screenshots are unavailable and OBS Window Capture is unavailable or unreliable, FFmpeg can be used as a fallback.

Before using FFmpeg, state why UE checkpoint screenshots cannot be used in this run. If the issue is only that OBS is unavailable, prefer the UE checkpoint screenshot path over FFmpeg.

FFmpeg desktop/window capture requires a real visible client window. Do not launch the client with `-RenderOffScreen` for FFmpeg capture runs; use fixed visible window geometry instead.

Rules:

1. Prefer recording a fixed region that exactly matches the UE client window.
2. Launch the UE client with fixed geometry, for example `-windowed -WinX=<x> -WinY=<y> -ResX=<w> -ResY=<h>`.
3. Record the matching desktop region with `gdigrab` or the local equivalent.
4. Do not treat whole-desktop capture as long-term evidence when project-window isolation matters.
5. For concurrent agents, assign non-overlapping fixed regions per project and run id.
6. Keep the UE client open until recording finishes.
7. Extract frames or a contact sheet and inspect them.

FFmpeg fallback is more vulnerable to occlusion, wrong-window capture, and multi-project overlap than OBS Window Capture.

## Visual Acceptance Criteria

A visual verification is valid only if the inspected artifact shows the intended project flow and the required business visuals.

Reject or clearly qualify the result if the checkpoint screenshots, video, or contact sheet show:

- Black or blank frames.
- Desktop or tool windows instead of the project window.
- A different UE project.
- A stale frame from a previous run.
- The client after it was closed.
- A covering window or unrelated overlay hiding the target content.
- Missing required business visuals, such as missing platform preview in platform selection.
- Only a log PASS without visual evidence.

For UE checkpoint screenshots, reject or qualify the result if required checkpoint files are missing, not updated during the run, have the wrong dimensions, or cannot be traced to the declared `RunId`.

Report the exact artifact inspected, such as screenshot directory, checkpoint PNG paths, contact sheet path, summary JSON path, video path, or frames directory.

## Known Project Flow Pattern

For this project, local visual verification usually uses uncooked Editor processes.

Full Board-start flow should begin from the visible Board URL:

```text
UnrealEditor.exe <Project.uproject> /Game/Maps/StartMap_?game=/Script/Gameplay.ProjectBoardGameMode -game -windowed ...
```

The expected user path then activates the Board Single Player entry, which should launch the local dedicated server and join Lobby.

Later-stage helper scripts may use uncooked Editor processes directly:

```text
UnrealEditor.exe <Project.uproject> /Game/Maps/LobbyMap -server -game -port=<port> ... -NullRHI
UnrealEditor.exe <Project.uproject> 127.0.0.1:<port>/Game/Maps/StartMap_ -game -windowed ...
```

Do not expect cooked `ProjectServer.exe` / packaged client unless the user explicitly asks to test packaged builds.

## Failure Reporting

If a visual check fails, stop expanding scope and report:

- Exact command.
- Exit code.
- Key error or log lines.
- Expected pass signal missing or present.
- Which visual checkpoint failed.
- Which business visual assertion failed.
- Whether the visual artifact was black, wrong window, stale, occluded, desktop-contaminated, missing, or showed an actual business failure.
- Whether the likely cause is UE screenshot capture, OBS/WebSocket, FFmpeg capture, UE rendering, uncooked/cooked mismatch, window binding, environment, networking, automation coverage, UI/business logic, content asset, or unknown.
- Smallest recommended next investigation.

Check for leftover UE/server/OBS processes when relevant.

If the failure is a business visual failure, do not hide it behind a log PASS. State clearly that the project flow is visually incorrect at that checkpoint.

## Completion Report

End with:

- Project flow verified.
- Coverage classification: full pass, partial pass, visual business failure, capture failure, or log-only pass.
- Commands run and outcomes.
- Business visual assertions checked and results.
- Camera evidence used: normal player view, verification camera, or both; include the verification camera target/framing and whether normal-view readability was also checked.
- Pass log key lines.
- Screenshot directory, checkpoint PNG paths, contact sheet path, summary JSON path, and any video/frame paths.
- Visual inspection result.
- Run isolation values used: `RunId`, port, log paths, screenshot directory, render mode, and render size. If OBS/FFmpeg/window capture was used, also report visible window geometry.
- Whether OBS/FFmpeg was used and closed cleanly.
- Flow segments or phases not verified and why.
- Residual visual risk.
- Whether the project business-flow fact source was updated with the verification result.

## Business Flow Documentation Sync

End-to-end visual project-flow verification changes project knowledge, even when no source code changes.

After a visual flow run completes, update the project's business-flow fact source with the result. The entry should include:

- Date and verification tool/script.
- Coverage classification.
- Flow segments covered.
- Business visual assertions that passed.
- Business visual assertions that failed.
- Run id, port, screenshot directory, checkpoint PNGs, contact sheet, summary JSON, optional video/frame artifacts, and log paths used as evidence.
- Flow segments or phases not covered.
- Recommended next investigation or fix.

For this project, the default business-flow fact source is:

```text
Docs/AI_STATE/PROJECT_DESIGN/07_EndToEndProjectFlow.md
```

If a project uses a different business-flow fact source, use that project's documented path instead. If no such fact source exists, report that gap and propose creating one before treating the verification record as complete.

Updating the business-flow fact source is a project document edit and must follow the confirmation gate.
