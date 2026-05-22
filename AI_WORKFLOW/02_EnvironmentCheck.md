# 02_EnvironmentCheck - Project Environment Check Workflow

> Skill: 环境检查
> File id: `02_EnvironmentCheck`
> This Markdown file defines a project-local AI workflow skill for environment and tooling checks.

This file defines the project-local workflow for checking whether the current machine can run the common AI / Agent tooling used by this Unreal Engine project.

## Trigger

Use this workflow when the user asks to check the local environment, verify tooling, prepare for automated tests, prepare for visual recording, or diagnose why scripts/builds cannot run.

Typical user prompts:

- `检查环境`
- `检查本地是否有 py、node、git、UE、OBS、ffmpeg`
- `确认自动测试环境是否齐全`
- `准备跑 UE smoke / OBS 可视化录屏`

## Scope

This workflow is read-only by default.

Allowed actions:

- Read executable locations and versions.
- Read likely Unreal Engine install paths.
- Read repository configuration needed to locate scripts or `.uproject`.
- Report missing tools and exact commands or paths that were checked.

Do not:

- Install tools.
- Modify `PATH`, registry, shell profile, project files, engine files, or Python/Node packages.
- Start long-running builds or smoke tests unless the user explicitly asks after the environment report.

## Required Checks

Run narrow checks and report path plus version when available:

```powershell
Get-Command python -ErrorAction SilentlyContinue
python --version

Get-Command py -ErrorAction SilentlyContinue
py --version

Get-Command node -ErrorAction SilentlyContinue
node --version

Get-Command npm -ErrorAction SilentlyContinue
npm --version

Get-Command git -ErrorAction SilentlyContinue
git --version

Get-Command obs64 -ErrorAction SilentlyContinue

Get-Command ffmpeg -ErrorAction SilentlyContinue
ffmpeg -version
```

UE process-internal checkpoint screenshots are the default visual evidence path for this project. OBS is an exception-path or diagnostic external capture tool, but the environment check should still report whether OBS is available for video requests, window-capture diagnostics, or fallback evidence. If `obs64` is not in `PATH`, check the common install locations:

```powershell
Test-Path "${env:ProgramFiles}\obs-studio\bin\64bit\obs64.exe"
Test-Path "${env:ProgramFiles(x86)}\obs-studio\bin\64bit\obs64.exe"
```

If OBS is found, report the absolute `obs64.exe` path. If practical, verify OBS can be launched by scripts through the path, but do not start OBS or create a recording during a read-only environment check unless the user explicitly asks.

Also check the OBS WebSocket expectation:

```text
OBS Studio 28+ includes OBS WebSocket by default. OBS exception-path automation expects a reachable OBS WebSocket endpoint and graceful shutdown through WebSocket.
```

If `ffmpeg` is not in `PATH`, check this project-known Python package fallback:

```text
C:\Users\PC\AppData\Roaming\Python\Python313\site-packages\imageio_ffmpeg\binaries\
```

If an `ffmpeg*.exe` is found there, report it as usable by absolute path and verify:

```powershell
& "<ffmpeg exe path>" -version
```

## Unreal Engine Checks

Confirm the project file and likely engine build entry:

```powershell
Test-Path Project.uproject
Test-Path D:\WorkSpace\UE\UnrealEngine\Engine\Build\BatchFiles\Build.bat
Test-Path D:\UE\UnrealEngine\Engine\Build\BatchFiles\Build.bat
```

If both known Build.bat paths are absent, search only a small set of likely roots before reporting unknown:

```powershell
Get-ChildItem -Path D:\WorkSpace,D:\UE,D:\ -Filter Build.bat -Recurse -ErrorAction SilentlyContinue
```

Avoid expensive full-drive searches unless the user explicitly asks.

## Output Requirements

Report:

1. Tool availability table: `tool`, `status`, `path`, `version`.
2. Unreal Engine path status and which `Build.bat` should be used.
3. FFmpeg status: `PATH` command or absolute fallback path.
4. OBS status: `PATH` command or known absolute path, plus whether OBS WebSocket should be available.
5. Missing tools and concrete impact on this project.
6. Whether the environment is sufficient for:
   - Python scripts.
   - Node-based tooling.
   - Git operations.
   - UE C++ build.
   - Dedicated smoke scripts.
   - UE checkpoint screenshot visual evidence.
   - OBS exception-path visual recording and Window Capture.
   - FFmpeg fallback visual recording when UE screenshots and OBS are unavailable or unsuitable.

For project-flow visual verification readiness, report UE checkpoint screenshot capability first. Report OBS and FFmpeg availability as exception/fallback capture readiness, not as the default visual verification path.

## Project Response Format

Project-related replies must still begin with the short project status sentence required by `00_START_HERE.md`, and the body must state the available workflow skills.

For environment-only checks, use:

```text
源码确认：未确认源码；本轮为环境检查，不涉及源码调用链。
```
