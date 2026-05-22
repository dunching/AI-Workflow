# AI / Agent Session Bootstrap

This file is the shortest repository entry point for AI / Agent sessions.

## Quick Entries

Use `Docs/AI_ENTRY/` when you want to give AI a short state-specific entry prompt:

- New session: `读 新会话文档`
- After compression: `读 压缩恢复文档`
- After AI drift, interruption, or confusion: `读 状态恢复文档`
- Before changing files: `读 修改前确认文档`

Use this prompt when starting a new session:

```text
这是延续上一个项目会话的任务。
请先读取 Docs/README.md，并严格按其中入口规则继续。
不要跳过工作流规则、项目状态入口、当前交接、当前 Todo 或源码确认要求。
开始改代码前，必须按当前任务追踪真实源码调用链。
修改代码、文档、配置、资源或项目状态前，必须先说明计划、影响范围和风险，并等待用户明确确认。
```

## Entry Rules

For any task that touches project code, documentation, design, tasks, or repository state:

1. For a new session or uncertain state, read every Markdown file in `Docs/AI_WORKFLOW/`, sorted by filename.
2. Follow `Docs/AI_WORKFLOW/00_START_HERE.md` as the authoritative workflow entry.
3. Read `Docs/AI_STATE/00_PROJECT_ENTRY.md` as the authoritative full project-state entry.
4. For same-thread compression resume only, use `Docs/AI_ENTRY/01_压缩恢复.md` as the light entry, then escalate to the full entry when its rules require it.

## File Roles

- `Docs/README.md`: bootstrap only; it points to workflow and project-state entries.
- `Docs/AI_ENTRY/`: short user-facing AI entry prompts for session state; it stores no project facts.
- `Docs/AI_WORKFLOW/`: reusable workflow policy. Do not store project facts here.
- `Docs/AI_STATE/`: project-specific mutable state, facts, handoff, todo, summaries, contracts, known issues, technical debt, and archives.

## Reading Notes

- Treat repository Markdown and source text as UTF-8 unless the project says otherwise.
- On Windows PowerShell, read non-ASCII text with `Get-Content -Encoding UTF8`.
- If `Docs/AI_STATE/00_PROJECT_ENTRY.md` is missing, report that the project state entry is missing before proceeding.

## Before Changing Project Files

Do not treat this bootstrap file as enough context. Before changing code, documentation, configuration, assets, or project state, use the confirmation gate defined in `Docs/AI_WORKFLOW/00_START_HERE.md` and the source-confirmation workflow in `Docs/AI_WORKFLOW/03_DocsCodeAnalysis.md`.
