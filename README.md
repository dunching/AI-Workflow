# AI Workflow Templates

Reusable AI / Agent workflow templates shared across projects.

## Contents

- `PROJECT_README.md`: template for a project's `Docs/README.md` bootstrap entry.
- `AI_ENTRY/`: short user-facing AI session entry prompts.
- `AI_WORKFLOW/`: reusable workflow policy files.
- `Scripts/Sync-AIWorkflowToProject.ps1`: PowerShell sync helper for copying template files into a project.

## Project-Specific State Boundary

Do not put project state in this repository.

Project-specific state belongs in each project's own `Docs/AI_STATE/` directory, including handoff, todo, API contracts, code overview, design docs, known issues, technical debt, archives, images, and generated status files.

The sync script intentionally refuses to write into `Docs/AI_STATE/`.

