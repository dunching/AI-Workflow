# 06_MergeWorktreeIntoCurrentBranch - Merge Worktree Into Current Branch Workflow

> Skill: 合并 worktree 内容到本分支
> File id: `06_MergeWorktreeIntoCurrentBranch`
> This Markdown file defines a project-local AI workflow skill for merging changes from another Git worktree into the current branch.

This workflow is for taking completed work from one existing Git worktree branch and integrating it into the branch checked out in the current worktree.

## Trigger

Use this workflow when the user asks to merge, bring in, integrate, sync, or apply content from another worktree or branch into the current branch.

Typical user prompts:

- `把 Project_BugFix 合并到当前分支`
- `合并 worktree 的内容到本分支`
- `把 feature worktree 的改动合进 main`
- `把 hotfix/fix-bugs merge 回当前分支`

## Required Entry

Before any merge operation, follow the repository entry rules in `Docs/AI_WORKFLOW/00_START_HERE.md`.

Merge work is high risk repository-state work. If the turn begins from a compression resume, escalate from `Docs/AI_ENTRY/01_压缩恢复.md` to the full project entry in `Docs/AI_STATE/00_PROJECT_ENTRY.md` before running Git state-changing commands.

This workflow modifies repository state. Follow the user confirmation gate before running merge, cherry-pick, rebase, reset, stash, commit, push, or conflict-resolution commands.

## Preconditions

Identify and report:

- Current worktree path.
- Current branch.
- Source worktree path and branch.
- `git worktree list`.
- `git status --short` in the current worktree.
- `git status --short` in the source worktree.
- Whether current branch and source branch have an upstream.
- Whether the source branch is ahead of, behind, or diverged from the current branch.

Stop and ask for confirmation if:

- The current worktree has uncommitted changes.
- The source worktree has uncommitted changes.
- The source path is not a Git worktree.
- The target branch is unclear.
- The source branch is already checked out in the current worktree.
- The user asked to overwrite, discard, or force changes without explicitly confirming the destructive action.

## Merge Strategy

Default strategy:

1. Use Git history integration, not filesystem copying.
2. Prefer `git merge <source-branch>` when the source worktree represents a branch meant to be integrated.
3. Use `git cherry-pick <commit>` only when the user asks for specific commits or the source branch contains unrelated work.
4. Do not use `git reset --hard`, `git checkout -- <path>`, force push, or destructive cleanup unless the user explicitly requests and confirms the exact action.

Do not copy project files from one worktree into another as a substitute for a Git merge. Copying may bypass rename detection, delete tracking, conflict markers, Git history, and binary asset conflict handling.

## Pre-Merge Report

Before running the merge, report:

1. Files actually read.
2. Current branch and source branch.
3. Current and source worktree cleanliness.
4. Planned command, such as `git merge hotfix/fix-bugs`.
5. Expected result: fast-forward, merge commit, or possible conflict.
6. Boundaries that will not be touched.
7. Risks, including binary asset conflicts, UE generated files, or stale source worktree state.

Wait for explicit user confirmation before running the merge command.

## Conflict Handling

If a merge conflict occurs:

1. Stop immediately.
2. Report `git status --short`.
3. List conflicted files with `git diff --name-only --diff-filter=U`.
4. Do not auto-resolve conflicts unless the user explicitly confirms the resolution plan.
5. Do not abort the merge unless the user asks, or unless the planned merge cannot proceed and aborting is explicitly confirmed.

For Unreal binary assets (`.uasset`, `.umap`, `.ubulk`, `.uexp`), do not invent a semantic merge. Report the conflict and ask which side should win or whether the asset should be manually resolved in Unreal Editor.

## Post-Merge Verification

After a successful merge:

1. Run `git status --short`.
2. Run `git log --oneline --decorate -n 5`.
3. If project files changed, choose the narrowest relevant verification from other project workflows, such as include checks, static scripts, build, smoke, or visual verification.
4. If no source files changed or verification is intentionally skipped, report why.

Do not push automatically unless the user asks to push.

## Output Requirements

Report:

- Source worktree and branch.
- Target worktree and branch.
- Merge command executed.
- Merge result.
- Conflicts, if any.
- Verification commands and outcomes.
- Whether anything remains uncommitted.
- Suggested next commands, such as pushing the current branch or deleting a fully merged worktree, only when useful.

Project-related replies must still begin with the short project status sentence required by `00_START_HERE.md`, and the body must state the available workflow skills.
