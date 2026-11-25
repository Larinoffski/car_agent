# 0028. Agents read committed env files

## Status

Accepted

## Date

2026-11-25

## Context

ADR 0014 banned agents from reading even the committed non-secret `envs/<env>.env` files. It guarded a blurred boundary: back then a secret could plausibly sit in any env file, and the line between secret and non-secret was kept only by attention. That boundary is now mechanical: everything secret lives in one directory, `envs/secrets/` (ADR 0011), and the committed env files are plain reviewable configuration (ADR 0010) whose variables are checked by compose (ADR 0025). The full ban kept paying costs without the risk it priced in: an agent could not verify the config it was asked to reason about. This decision supersedes ADR 0014.

## Decision

- Agents read the committed `envs/<env>.env` files freely.
- Agents edit an env file only with the developer's explicit permission, asked for per change — a prior discussion of the change does not stand in for the ask.
- Everything secret stays off-limits: `envs/secrets/`, `.env`, `.env.*`, private keys. `*.example` templates remain readable and editable.
- Enforcement follows the rule: `.claude/settings.json` denies reading only `envs/secrets/**` and `.env*`; the PreToolUse hook `.claude/hooks/guard.sh` blocks only secret paths. Other agents rely on this rule in `AGENTS.md`.

## Alternatives considered

- Keep the full ban of ADR 0014: protects a boundary that no longer exists and leaves the agent proposing variables blindly while a human copies them over.
- Read and edit freely: an env file change alters the runtime of every service; the per-change permission keeps the human in that loop.

## Consequences

Agents can verify and discuss environment configuration instead of guessing at it. A secret mistakenly pasted into a committed env file becomes visible to agents; the guards against that are the `envs/secrets/` discipline (ADR 0011) and the gitleaks job in CI, not agent blindness. Env file edits stay a deliberate, human-approved step.
