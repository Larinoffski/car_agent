# 0002. Environments and secrets layout

## Status

Superseded by 0009, 0010, 0011, 0012, 0013

## Date

2026-11-21

## Context

The project runs in several environments (local, test, CI, staging, production) and must keep secrets out of the repository and out of reach of AI agents working in the repo, while keeping non-secret configuration reviewable.

## Decision

- Docker Compose: a base `compose.yaml` plus one overlay per environment, `compose.<env>.yaml`. `make` assembles them by `ENV` (default `local`).
- Non-secret configuration per environment lives in `envs/<env>.env` and is committed.
- Local secrets live outside the repository in `~/.config/car_agent/<env>.env`; `make` passes the file only if it exists. Claude Code enforces this with deny rules and a PreToolUse hook (`.claude/hooks/guard.sh`); other agents rely on the rule in `AGENTS.md`.
- Test and CI need no secrets; external services are stubbed.
- Staging and production secrets are injected by the platform at deploy time; no secret files on disk.

## Alternatives considered

- Single `.env` in the repo root, git-ignored: secrets sit inside the agent's working directory and config changes are not reviewed.
- Secrets in git, encrypted (SOPS, git-crypt): adds key management to every clone; overkill for this project.

## Consequences

Configuration changes go through review like code. A fresh clone runs without secrets except the local ones each developer provides. Secrets for deployed environments depend on the platform's secret store.
