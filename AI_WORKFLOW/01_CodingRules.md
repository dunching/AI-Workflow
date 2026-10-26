# 01_CodingRules - Universal AI / Agent Coding Rules

These rules are project-agnostic. Project-specific contracts belong in the project state or design documents.

## Work Style

- Understand the request, boundaries, and relevant call chain before changing files.
- Before changing code, documentation, configuration, assets, project state, or workflow rules, explain the planned approach, files, boundaries, and risks, then wait for explicit user confirmation.
- Prefer small, single-purpose changes that are verifiable and easy to review.
- Do not do opportunistic large refactors unless the user asks for them or they are required to complete the task safely.
- If information is missing, state assumptions and risks clearly.
- Protect user or teammate changes: never revert unrelated edits you did not make.

## UE 开发批次与协作效率

- 以一个可独立验证的行为或事务边界划分修改批次。单批保持单一目的，同时覆盖该接口必需的生产调用方、适配层和测试夹具；不要把“改动小”理解为每改一处就运行完整构建，也不要为减少构建次数合并无关功能。
- 跨模块或状态协议调整前，沿实际调用链核对初始化、能力安装、运行时更新、出生与离场、序列化、恢复及最终消费入口。列出受影响的类型、版本、工厂和调用方，集中完成已授权范围内的必要迁移；测试夹具与生产代码使用同一份接口契约。
- 调整执行顺序、状态生效时序或并行模型时，先用可验证的串行路径明确读取版本、独占写集合、提交点和失败重试语义，再以相同计算路径验证并行实现。比较完整结果与生命周期行为，避免同时更换算法和调度方式导致差异无法归因；已有等价参考时直接复用。
- 同一组共享文件明确唯一写入方。构建或运行验证期间，冻结项目规定范围内的源码、工具和输入；变更后重新确认构建与测试身份。等待期间可进行不改变验证输入的只读分析，协作隔离方式遵循项目和用户授权。
- 审查聚焦本批实际差异、接口边界和未验证风险。已有且仍适用的检查结论应保留并复用，出现新修改、新失败或身份变化时再补查；避免无依据地重读全部上下文、重复交接或重复审查。
- 进度汇报说明实际完成的行为、当前阻断、下一轮验证要证明什么。交接和状态文档在里程碑或关键决策变化时同步，失败根因与范围变化及时记录；不要把计划、静态审查或构建启动写成实现或运行通过。
- 构建和验证批次按 [04_ImplementedFlowVerification.md](04_ImplementedFlowVerification.md) 选择；同一根因反复失败时，按 [11_CircuitBreaker.md](11_CircuitBreaker.md) 收敛假设并调整验证方式。

## Editing Rules

- Follow existing project style, architecture, naming, formatting, and local helper APIs.
- Use structured parsers or project APIs for structured data when available.
- Add abstractions only when they remove real complexity, reduce meaningful duplication, or match an established local pattern.
- Keep comments concise and useful: explain intent, lifecycle, boundary, side effects, or non-obvious constraints.
- Do not add empty comments that merely repeat the code.

## Code Review Stance

When asked for a review:

- Lead with findings, ordered by severity.
- Ground findings in file and line references.
- Focus on bugs, regressions, missing tests, race conditions, security, data loss, and broken contracts.
- Keep summaries secondary.
- If no issues are found, say so clearly and note residual risk or unrun tests.

## Source And Runtime Facts

- Treat source code, configuration, assets, generated files, and runtime entry points as the final implementation facts.
- Treat documentation as a map that must be checked against source before code changes.
- If docs and source conflict, report the difference and propose the smallest correction before broad changes.
- Do not invent missing architecture from docs alone.

## Verification

- Run the narrowest meaningful verification for the change: static check, unit test, build, script, smoke test, or manual validation.
- For visual, UI, animation, game-view, particle/effect, layout, or interaction changes, prefer a visual self-check in addition to logs and automated pass/fail signals when the local environment supports it.
- For this project, use UE process-internal checkpoint screenshots as the default visual evidence path for project-flow visual checks. External recording tools such as OBS Studio Window Capture or FFmpeg are exception paths, not defaults.
- Do not start with OBS, FFmpeg, desktop capture, or external window recording unless the user explicitly asks for video evidence, the task is diagnosing external capture/window behavior, or the UE checkpoint screenshot path was attempted/planned and cannot capture the required evidence.
- UE checkpoint screenshots must come from the real client process at meaningful business checkpoints, use isolated run ids/directories/logs/ports, and be inspected as screenshots or a contact sheet before claiming visual correctness.
- External video or frame capture is supporting evidence, not a replacement for UE checkpoint screenshots, builds, automated tests, runtime logs, authority checks, or replication checks.
- A visual evidence self-check must confirm that the artifact shows the intended application content, not a black screen, desktop background, hidden window, occluded window, stale frame, wrong project, or post-test empty area after the app was closed.
- Keep the application open until the final checkpoint or approved external recording finishes; do not close the client immediately after a log PASS if visual evidence still needs to capture the validated state.
- If UE checkpoint screenshots are unavailable or unreliable, report why and use the narrowest concrete fallback artifact, such as targeted engine automation screenshots, rendered frame dumps, OBS, or FFmpeg, with the limitation clearly stated.
- If verification cannot run, explain exactly why.
- If verification fails, stop expanding scope and fix or report the failure.
- Record important verification results in project state when the workflow requires it, including paths to videos, screenshots, extracted frames, or contact sheets when they are part of the evidence.

## Documentation And State Updates

- Update project state documents when task status, handoff, contracts, decisions, known issues, or technical debt change.
- Documentation and state updates are file edits and must follow the same explicit-confirmation gate as code changes.
- 当仓库或用户上下文以中文为主时，面向项目成员阅读的文档应尽量用中文描述；代码符号、文件路径、命令、类/函数名、ItemTag、日志字段和外部专有名词保留原文，方便搜索和准确引用。
- Do not update reusable workflow rules during normal implementation work.
- If a reusable workflow rule needs to change, the user must explicitly ask for a workflow change.

## Final Response

- Keep the final answer concise and focused on what changed, what was verified, and what remains.
- Mention files changed when useful.
- Mention verification commands and outcomes.
- For visual self-checks, mention the captured artifact path, the frame/contact-sheet check, and any remaining visual risk.
- Mention anything not done or not verified.
