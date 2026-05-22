# 01_CodingRules - Universal AI / Agent Coding Rules

These rules are project-agnostic. Project-specific contracts belong in the project state or design documents.

## Work Style

- Understand the request, boundaries, and relevant call chain before changing files.
- Before changing code, documentation, configuration, assets, project state, or workflow rules, explain the planned approach, files, boundaries, and risks, then wait for explicit user confirmation.
- Prefer small, single-purpose changes that are verifiable and easy to review.
- Do not do opportunistic large refactors unless the user asks for them or they are required to complete the task safely.
- If information is missing, state assumptions and risks clearly.
- Protect user or teammate changes: never revert unrelated edits you did not make.

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
