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

## UE 分层验证与构建批次

- 修改前明确本批验收行为、相关反例和受影响的调用方。验证方案应覆盖完整的已授权功能边界，保留既有负向断言；不能通过删测试、放宽断言或改变业务负载消除失败。
- 按成本和证明范围逐层验证：文档或脚本静态检查、已有独立纯逻辑测试、受影响翻译单元的语法检查、必要的 UHT / UBT 构建、目标原生测试与 smoke，最后按需求验证真实渲染、内容资源、客户端或 Dedicated Server。仅文档修改通常无需启动 UE 构建。
- 优先复用现有测试入口和与真实构建一致的工具链配置，不为流程完整新建测试框架。语法检查不能替代 UHT、链接或运行验证；反射、模块依赖、生成代码和资源变更需要对应的真实验证。
- 将同一接口的必要代码、调用方和测试迁移作为一个闭合批次。低成本检查通过后再启动必要的完整构建及相关回归；不要为每个文件、每条断言或可合并的诊断修正分别完整构建。
- 需要验证修复前失败时，先集中运行本批反例，确认失败发生在目标行为断言，而非启动、输入或夹具准备阶段；修复后集中验证这些反例及相关回归。保留原始失败记录，不能用静态分析代替要求的运行证据。
- 复用同一有效构建运行所需测试，测试参数不同不自动要求重建。测试集合可扩大到已变更契约的消费者；只有新修改、新失败、覆盖缺口或明确要求才重复或扩大验证。
- 最终构建前按项目要求完成格式化与检查，再冻结最终验证输入。若验证期间修改了相关源码、脚本、配置或资源，重新确认受影响的验证结论；不同源码、引擎或程序版本的结果不得混用。

## UE 启动条件与失败分类

启动前按本次验证层级一次核对所需项，已有且未变化的检查结果可以复用：

- 构建时确认引擎根目录、目标项目、构建目标、配置和平台；运行时核对实际启动程序及其构建身份，确认包含待测修改。
- 测试入口是否真实存在，所需输入文件、目录、资源和协议版本是否满足；通过前缀扩大测试集合时，单独识别需要专用参数或捕获输入的用例。
- 启动脚本是否支持所用参数；场景或功能开关、客户端 / 服务端角色、端口、超时和资源占用是否符合测试要求。
- 用例是否依赖真实 RHI、渲染、Niagara、窗口或内容资源；无渲染模式仅用于明确支持该模式的用例。
- 预期通过信号、预期失败断言和证据目录是否明确；正向控制必须实际进入目标行为。

按证据区分以下结果：

- 启动、输入或环境不满足：保留失败，说明目标行为尚未被验证，修正运行条件后复验；不计作目标行为通过，也不直接归为产品回归。
- 编译、生成代码或链接失败：依据实际工具错误定位构建链问题，后续运行测试不视为已执行。
- 已进入目标行为后断言失败：按产品实现或测试契约问题调查，先确认夹具是否有效，再修改实现。
- 超时、崩溃、取消或原因未知：保留原日志和已完成部分，核对进程与现场，不能推定通过或凭猜测归因。

修复轮次应归并同一根因下已确认的问题，每次完整构建前复核相关调用方和启动条件。记录实际构建耗时、测试耗时与重复运行原因；没有测量时不编造耗时占比或节省承诺。反复失败时使用 [11_CircuitBreaker.md](11_CircuitBreaker.md)，保留因果证据并缩小下一轮验证目标。

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
