# 00_START_HERE - Universal AI / Agent Workflow Entry

This directory contains reusable AI / Agent workflow rules. It is intended to be copied between projects.

## Mandatory Startup

For any new AI / Agent session that touches project code, documentation, design, tasks, or repository state:

1. Read every Markdown file in this directory, sorted by filename.
2. Treat this directory as workflow policy, not project state.
3. After reading all workflow rules, read the project-specific state entry file:
   - Default path: `Docs/AI_STATE/00_PROJECT_ENTRY.md`
   - If that file does not exist, read the repository README and clearly report the missing state entry.

General short entry prompts live in `Docs/AI_ENTRY/`. For same-thread compression resume, do not automatically repeat the full startup read. Read `Docs/AI_ENTRY/01_压缩恢复.md` first, then follow its light resume read order. Escalate to the full startup path above when the resume entry requires it, when state is uncertain, or when the user explicitly asks for the full entry rules.

## Text Encoding Rule

- Treat repository Markdown and source text as UTF-8 unless the project explicitly says otherwise.
- When using a shell or tool that does not reliably auto-detect UTF-8, pass the encoding explicitly.
- On Windows PowerShell, prefer `Get-Content -Encoding UTF8` for Markdown or other non-ASCII text.

## Read-Only Rule

- Files in `Docs/AI_WORKFLOW/` are read-only for normal AI / Agent work.
- Do not modify, rewrite, reformat, rename, or move these files unless the user explicitly asks to change the AI workflow itself.
- When normal implementation work discovers a process problem, record it in the project state area or mention it to the user; do not silently edit the workflow rules.

## Project State Area

Project-specific and changeable AI/Agent working files belong outside this directory.

Recommended default:

```text
Docs/AI_STATE/
```

That area may contain handoff, current todo, task summary, decisions, known issues, API contracts, project status, and other mutable collaboration records.

Short AI entry prompts belong in `Docs/AI_ENTRY/`, not in project state. They select how to resume or proceed; they do not store project facts, handoff, todo, or implementation status.

## Post-Read Convergence Gate

After reading workflow rules and project state files, distinguish file roles before planning work:

- Workflow files define behavior rules. They do not define the current implementation task.
- Project entry files define read order. They do not expand the task by themselves.
- Current handoff and current todo files define the active task unless the user explicitly changes direction.
- API contracts, code overviews, decisions, known issues, and technical debt files are supporting context. Use them to check boundaries, risks, and conflicts; do not let them automatically expand the modification scope.

Before proposing edits, reduce the task to the intersection of:

1. The latest relevant handoff.
2. The current todo or status entry.
3. The real source call chain or project file path confirmed for this turn.

Reading broadly is required for context. Modifying broadly is not allowed unless that broader scope is explicitly required by the current task and confirmed with the user.

If supporting context suggests additional files may need updates, list them separately as conditional follow-ups instead of adding them to the default modification plan.

## Required Response Format

Every project-related reply must begin with a very short plain-text status sentence, followed by a blank line, then a two-part body:

1. Fixed response content.
2. Actual reply.

Use this shape as normal prose, not as a Markdown heading, table, quote, separator, or code block:

```text
项目状态：入口已读，状态已确认；本轮边界和风险已说明。

1. 固定回复内容
   - 项目状态
     - ...
   - 已读文件
     - ...
   - 交接与 Todo
     - ...
   - 源码确认
     - ...
   - 修改计划
     - ...
   - Workflow skills
     - ...

2. 实际回复
   - ...
```

Rules:

- The project status sentence must be the first paragraph.
- Keep the status sentence to one short line whenever possible.
- The response body should be split into `1. 固定回复内容` and `2. 实际回复`.
- `1. 固定回复内容` should use hierarchical bullets so fixed facts are easy to scan.
- `2. 实际回复` should contain the direct answer, analysis, plan, command result, review findings, or completion summary requested by the user.
- Do not put a `---` line directly after the project status sentence. Markdown treats the previous line as a heading in that shape and makes the font larger.
- Do not put exact paths, commands, class names, branch names, Todo ids, or long file lists in the project status sentence.
- Put exact paths, commands, identifiers, detailed read lists, Todo ids, and verification details in `1. 固定回复内容` or `2. 实际回复` instead.
- Do not use `#` headings, bold labels, horizontal rules, or multi-line title blocks for the project status sentence.
- Do not wrap the whole status sentence or normal Chinese explanation in backticks.
- Use inline code style only in the answer body, and only for exact paths, commands, class names, variables, or literal identifiers.
- Every project-related reply body must include the available workflow skills under `1. 固定回复内容` -> `Workflow skills`.
- Keep the available-skills content out of the project status sentence, and do not wrap the whole skill list in code style.
- The default available workflow skills are: 环境检查、文档业务源码分析、单个功能 smoke 测试、以可视化的方式验证项目流程的正确性、合并 worktree 内容到本分支、从主分支合并最新修改并提交推送合并到主分支。
- If a specific workflow skill is used in the current turn, state it under `Workflow skills` in addition to listing the available workflow skills.
- For compression resume replies, the fixed content may be compact: include read mode, understanding state, current task, source confirmation / confirmation gate, and risk. In compact mode, list only the workflow skill used this turn unless the user asks for the full skill list.
- Do not omit source confirmation or context risk; include them under `1. 固定回复内容` even when the result is "not applicable" or "incomplete".
- Source confirmation, context risk, workflow notes, and key-memory notes may be summarized in the short status sentence and expanded in the fixed response content.
- If context is incomplete, say so in the first sentence instead of pretending the state is fully known.

## Reply Layout Rules

Default project replies should keep typography calm and readable in the Codex chat area.

- Use numbered top-level sections exactly for the two required body parts: `1. 固定回复内容` and `2. 实际回复`.
- Under `1. 固定回复内容`, use stable second-level bullet labels when relevant: `项目状态`, `已读文件`, `交接与 Todo`, `源码确认`, `修改计划`, `边界`, `风险`, `Workflow skills`.
- Under each fixed bullet label, use nested bullets for the actual facts. Keep nested content concise.
- Omit a fixed bullet only when it is clearly unrelated to the user's request; for project code/document/config/state changes, include all confirmation-gate bullets.
- For very small replies, keep each fixed bullet to one short nested bullet rather than expanding into prose, but preserve the two-part shape.
- For compression resume, prefer the compact fixed labels from `Docs/AI_ENTRY/01_压缩恢复.md` over a full confirmation-gate expansion when no edit is being proposed.
- Put the user's requested answer in `2. 实际回复`; do not bury the actual answer inside the fixed response content.
- Avoid large headings, bold labels, full-block code fences, and tables unless they genuinely improve readability.
- Use inline code style only for paths, commands, class names, function names, tags, log keys, and other exact symbols that need precision.
- Use fenced code blocks only when showing commands, code, structured output, or multi-line text that benefits from exact formatting.
- Avoid formatting choices that make text appear to jump between very large and very small sizes.

## Before Changing Project Files

Before editing code, configuration, assets, project documents, project state, or workflow rules, report:

1. Files actually read.
2. Current understanding level.
3. Previous handoff status.
4. Current highest-priority task.
5. Source confirmation result: real entry points, call chain, data sources, matching or conflicting documentation.
6. The read scope versus the proposed modification scope.
7. Planned files to modify, limited by the post-read convergence gate.
8. Boundaries that will not be touched.
9. Context risks or missing information.

After reporting the plan, wait for explicit user confirmation before modifying files. A general task request is not enough to skip this confirmation gate unless the user has explicitly authorized the listed changes.

## Source Confirmation Rule

Reading documentation is not enough to understand the real code architecture.

Before code changes, bug fixes, refactors, or new feature integration, confirm the relevant source call chain:

- Expected architecture or entry points from docs.
- Real source entry functions/classes/subsystems/controllers/components/config readers.
- Key path from UI/controller/subsystem/framework layer to business/domain/plugin layer.
- Data facts such as config, data assets, tags, replicated fields, RPCs, delegates, blueprints, world settings, or generated assets.
- Where docs match code.
- Where docs conflict with code, are stale, or remain unconfirmed.
- The actual file scope for this turn.

If source confirmation is incomplete, only do documentation understanding, plan analysis, or risk reporting.

## Session End

When a task is completed or needs handoff:

- Update the project state handoff file.
- Update current todo/status files if task status changed.
- Update task summary if the result is worth preserving.
- Update project contracts/known issues/technical debt if the change affects them.
