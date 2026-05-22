# 07_UpdateWorktreeFromMainBranch - Sync Branch With Main, Commit, Push, And Merge Back Workflow

> Skill: 从主分支合并最新修改并提交推送合并到主分支
> File id: `07_UpdateWorktreeFromMainBranch`
> This Markdown file defines a project-local AI workflow skill for updating an active worktree branch from the project's main development branch, committing and pushing the active branch's work, then merging that branch back into the main branch and pushing the main branch after verification.

This workflow is for feature, hotfix, or experiment worktree branches that should first absorb the latest main-branch changes, then commit and push their own branch contents, and finally publish those changes back to the main development branch.

It is not a file-copy workflow. Do not copy files between worktree directories by hand.

## Trigger

Use this workflow when the user asks to update a branch from main, commit and push the current branch, then merge it back to main; sync a feature or hotfix branch with main before publishing; or let a worktree branch contribute its committed changes back to the main branch.

Typical user prompts:

- `让 Project_Feature 拉取 main 的内容，然后合回 main`
- `从主分支合并最新修改并提交推送合并到主分支`
- `把 hotfix/fix-bugs 同步 main，提交推送后合回主分支`
- `Project_BugFix 先更新主分支，再提交推送本分支，最后合到 main`

## Required Entry

Before any repository-state operation, follow the repository entry rules in `Docs/AI_WORKFLOW/00_START_HERE.md`.

Update / commit / push / merge-back work is high risk repository-state work. If the turn begins from a compression resume, escalate from `Docs/AI_ENTRY/01_压缩恢复.md` to the full project entry in `Docs/AI_STATE/00_PROJECT_ENTRY.md` before running Git state-changing commands.

This workflow modifies repository state and may create commits, push the current branch, merge into main, and push the remote main branch. Follow the user confirmation gate before running `fetch`, `pull`, `merge`, `rebase`, `reset`, `stash`, conflict resolution, commit, or push commands.

## Preconditions

Identify and report:

- Current worktree path.
- Current branch.
- Main worktree path.
- Main branch name, normally `main` or the repository's actual primary branch.
- Remote name and upstream refs for the current branch and main branch.
- Current `git worktree list`.
- `git status --short` in the current worktree, including which changes are intended for the current branch commit.
- `git status --short` in the main worktree.
- Ahead/behind relationship for the current branch against the selected main branch.
- Ahead/behind relationship for the current branch against its remote upstream, if it has one.
- Ahead/behind relationship for the local main branch against its remote upstream.

Stop before changing repository state if:

- The current worktree has uncommitted changes that the user has not explicitly agreed to include in the branch commit.
- The main worktree has uncommitted changes.
- The current branch is the main branch.
- The main branch name is unclear.
- The main worktree path cannot be identified.
- The current branch has no upstream and the target remote branch name is unclear.
- The operation would require a destructive command.
- The operation would require a force push.
- The user asks for rebase, reset, stash, or force update without explicitly confirming that strategy.

## Main Branch Selection

Default main branch:

- Use `main` when it exists locally.
- If the repository's actual primary branch is `develop`, use `develop` and report the branch choice.
- Use the matching remote ref, usually `origin/main` or `origin/develop`.

Do not assume a stale local main branch is current. The workflow must first fetch the remote and update the local main branch.

## Workflow Phases

### Phase 1: Update Main From Remote

After reporting the plan and receiving explicit confirmation:

1. Run `git fetch origin`.
2. In the main worktree, verify `git status --short` is still clean.
3. Update the local main branch from its remote upstream with a fast-forward-only command, such as:
   - `git pull --ff-only origin main`
   - or `git merge --ff-only origin/main`

If the main branch cannot fast-forward, stop and report the situation. Do not create a merge commit on main just to update it from remote unless the user explicitly confirms that strategy.

### Phase 2: Merge Latest Main Into Current Branch

After local main is up to date:

1. In the current worktree, verify `git status --short` is clean.
2. Merge the updated local main branch into the current branch, for example:
   - `git merge main`
   - or `git merge develop` when the primary branch is `develop`
3. Do not rebase by default.
4. Do not copy files from the main worktree into the current worktree.

If a conflict occurs, follow the Conflict Handling section and stop.

### Phase 3: Verify Current Branch Before Commit

After the current branch has successfully absorbed the latest main content:

1. Run `git status --short`.
2. Run `git log --oneline --decorate -n 5`.
3. If source files, assets, scripts, or workflow rules changed, choose the narrowest relevant verification from the project workflows.
4. If verification is skipped because only Git metadata changed or the user explicitly asked to skip it, report why.

Do not continue to commit, push, or merge back into main if verification fails.

### Phase 4: Commit Current Branch

After the current branch is verified:

1. Report `git status --short` and the exact files that will be included.
2. Confirm the commit message with the user, unless the user already supplied one.
3. Stage only the agreed current-branch changes.
4. Create a normal commit on the current branch.
5. Run `git status --short` and `git log --oneline --decorate -n 5`.

Do not stage unrelated files unless the user explicitly asks to include all local changes. Do not amend an existing commit unless the user explicitly asks for amend.

### Phase 5: Push Current Branch

After the current branch commit is created:

1. Push the current branch to its upstream.
2. If the current branch has no upstream, report the intended remote branch and wait for explicit confirmation before using `git push -u`.
3. Do not force push.

Do not continue to merge back into main if pushing the current branch fails.

### Phase 6: Merge Current Branch Back Into Main

After the current branch is committed and pushed:

1. Switch context to the main worktree.
2. Verify `git status --short` in the main worktree is clean.
3. Merge the current branch into main, for example:
   - `git merge feature/new-content`
   - `git merge hotfix/fix-bugs`
4. Do not use `--no-verify`, force options, or destructive recovery commands unless the user explicitly confirms them.

If a conflict occurs on main, follow the Conflict Handling section and stop.

### Phase 7: Verify And Push Main

After the current branch has been merged into main:

1. Run `git status --short` in the main worktree.
2. Run `git log --oneline --decorate -n 5`.
3. Run the narrowest relevant verification if the merge introduced source, asset, script, or workflow-rule changes that were not already verified.
4. Push the main branch to its upstream, for example:
   - `git push origin main`
   - or `git push origin develop` when the primary branch is `develop`

Push the main branch only after the merge-back is verified.

## Pre-Operation Report

Before running any fetch, pull, merge, commit, stage, or push commands, report:

1. Files actually read.
2. Current worktree path and branch.
3. Main worktree path and branch.
4. Selected main branch and remote ref.
5. Current and main worktree cleanliness.
6. Planned commands by phase.
7. Expected result: already up to date, fast-forward, merge commit, possible conflict, or push.
8. Boundaries that will not be touched.
9. Commit scope and proposed commit message when a branch commit will be created.
10. Risks, including binary asset conflicts, stale local main, remote divergence, UE generated files, unrelated uncommitted work, accidental inclusion of generated files, or push/merge permission failures.

Wait for explicit user confirmation before running update, stage, commit, current-branch push, merge-back, or main push commands.

## Conflict Handling

If a conflict occurs:

1. Stop immediately.
2. Report the worktree where the conflict occurred.
3. Report `git status --short`.
4. List conflicted files with `git diff --name-only --diff-filter=U`.
5. Do not auto-resolve conflicts unless the user explicitly confirms the resolution plan.
6. Do not abort the merge unless the user asks, or unless aborting is explicitly confirmed.

For Unreal binary assets (`.uasset`, `.umap`, `.ubulk`, `.uexp`), do not invent a semantic merge. Report the conflict and ask which side should win or whether the asset should be manually resolved in Unreal Editor.

## Output Requirements

Report:

- Current worktree and branch.
- Main worktree and branch.
- Commands executed.
- Main update result.
- Current branch update result.
- Current branch verification result.
- Current branch commit hash, if a commit was created.
- Current branch push result.
- Main merge-back result.
- Main push result.
- Conflicts, if any.
- Whether anything remains uncommitted.
- Whether the current feature or hotfix branch was pushed.

Project-related replies must still begin with the short project status sentence required by `00_START_HERE.md`, and the body must state the available workflow skills.
