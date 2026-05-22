# 03_DocsCodeAnalysis - Docs, Business, And Source Analysis Workflow

> Skill: 文档业务源码分析
> File id: `03_DocsCodeAnalysis`
> This Markdown file defines a project-local AI workflow skill for docs, business, and source analysis.

This file defines the project-local workflow for analyzing whether documentation, business intent, and real source implementation agree.

## Trigger

Use this workflow when the user asks to analyze project status, understand a feature, compare docs and code, inspect a workflow, continue from handoff, or decide what to implement next.

Typical user prompts:

- `分析当前项目`
- `分析文档业务和代码实现`
- `确认文档和源码是否一致`
- `继续上一轮交接`
- `先不要改代码，帮我确认调用链`

## Required Entry

Start from the repository entry rules in `Docs/AI_WORKFLOW/00_START_HERE.md`.

- For a new session or uncertain state, use the full entry path in `Docs/AI_STATE/00_PROJECT_ENTRY.md`.
- For same-thread compression resume, use `Docs/AI_ENTRY/01_压缩恢复.md` and escalate to the full entry when that file requires it.

Do not use old handoff text, historical task logs, or memory as the primary fact source when current state files exist.

## Analysis Convergence

After reading broad context, narrow the task to the intersection of:

1. Latest relevant handoff.
2. Current Todo or status entry.
3. Real source entry points confirmed in this turn.

Supporting docs can suggest follow-ups, but they must not automatically expand the modification scope.

## Source Confirmation

For any code-facing conclusion, confirm the real source chain. Documentation is not enough.

Report using this fixed template:

- `Docs expected`: expected architecture, behavior, or entry points from docs.
- `Source entry`: real source entry functions, classes, subsystems, components, scripts, assets, or config readers.
- `Call chain`: path from UI/controller/subsystem/framework layer to business/domain/plugin layer.
- `Data source`: GameplayTags, DataAssets, ItemDefine, config, RPC, replication, StateTree, command line flags, scripts, generated assets, WorldSettings, or other runtime facts.
- `Runtime verification`: smoke, build, screenshot, log, Editor check, or explicit reason why runtime verification is not applicable yet.
- `Docs mismatch`: where docs match source, conflict with source, are stale, or remain unconfirmed.
- `Actual file scope`: files that are relevant to the current task.

Prefer `rg` / `rg --files` for source discovery.

## Output Shape

Every analysis response must begin with the short project status sentence required by `00_START_HERE.md`, and the body must state the available workflow skills.

Then provide:

1. Files actually read.
2. Previous handoff status.
3. Current highest-priority task.
4. Real source confirmation result.
5. Docs/source consistency summary.
6. Proposed next action.
7. If edits are needed: planned files, boundaries, impact, and risks.

If source confirmation is incomplete, say so and limit the answer to analysis or a plan. Do not implement from documentation alone.

## Before Edits

Before changing code, documentation, configuration, assets, or project state, report the modification plan and wait for explicit user confirmation.

A broad request such as `继续`, `修一下`, or `自动处理` authorizes investigation and planning only. It does not authorize file edits until the listed scope is confirmed.
