# 0003. Agents do not edit environment files

## Status

Accepted

## Date

2026-11-22

## Context

ADR 0002 keeps non-secret configuration in committed `envs/<env>.env` files and local secrets outside the repository. It protects secrets from AI agents but leaves open whether agents may read or edit the non-secret files.

The line between secret and non-secret values is kept by people, not by tooling: a key pasted into the wrong file stays there until someone notices. An agent that reads or edits env files can print such a value into its output or spread it into other files. A rule that depends on judging each file is hard to follow and hard to enforce.

This decision extends ADR 0002.

## Decision

- AI agents never read, print or edit environment files: `~/.config/car_agent/`, `.env`, `.env.*`, `envs/*.env`.
- When a change needs configuration, the agent lists the variables, their values and the target file; a human edits the file.
- `*.example` templates hold keys without values; agents may read and edit them to keep the list of required keys current.
- Claude Code enforces the rule with deny rules in `.claude/settings.json` and the PreToolUse hook `.claude/hooks/guard.sh`, which blocks these paths in shell commands, file reads and searches. Other agents rely on the rule in `AGENTS.md`.

## Alternatives considered

- Agents edit committed `envs/<env>.env`, since they hold no secrets by design: faster, but a mistakenly committed secret becomes readable, and the boundary depends on attention.
- Agents read but do not edit env files: still exposes a mistakenly placed secret.

## Consequences

Every configuration change needs a manual step; agents hand over ready-to-paste blocks. The `*.example` templates remain the single list of required keys. Enforcement is pattern-based: the hook checks command text, and Codex and Cursor follow the rule only as written.
