# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@AGENTS.md

## Claude Code

- Subagents: `.claude/agents/`.
- Skills: `.claude/skills/`, shared checklists: `.claude/references/` (shared with Codex via the `.agents/skills` and `.agents/references` symlinks).
- Permissions and hooks: `.claude/settings.json`; hook scripts in `.claude/hooks/`.

### Models

The main session model is chosen by the user (`/model`). Cheaper work is routed to subagents; the model is pinned in each subagent's `model:` frontmatter.

| Task | Model |
|---|---|
| Search across many files, going through web results, mechanical text/config edits | Haiku |
| Docs/config edits from a given wording, implementing a well-defined task, tests, code review | Sonnet |
| Architecture, planning, hard debugging, orchestration, final cross-check | Opus (main session) |
| Large cross-checks and audits — only on explicit user request, never by default; fallback Opus | Fable |

Delegate bulky or multi-file work. Do one-line edits in place: a subagent starts with an empty context and costs more than the edit itself.
