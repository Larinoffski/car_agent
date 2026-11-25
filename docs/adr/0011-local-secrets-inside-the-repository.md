# 0011. Local secrets inside the repository

## Status

Accepted

## Date

2026-11-25

## Context

ADR 0002 kept local secrets outside the repository in `~/.config/car_agent/<env>.env`. That makes the project depend on a hidden per-machine path: a fresh clone is not self-contained, backups and moves of the project folder miss the secrets, and the location differs between machines. ADR 0014 bans agents from reading env files; the ban must follow the secrets wherever they live. This decision replaces the local-secrets part of ADR 0002 (split per ADR 0008).

## Decision

- Local secrets live in `envs/secrets/<env>.env`, inside the repository.
- The directory is ignored by git (`envs/secrets/*`); only `envs/secrets/.gitkeep` is tracked, so the directory exists in every clone.
- `SECRETS_DIR` in the Makefile defaults to `envs/secrets` and stays overridable via the environment or `make SECRETS_DIR=...`.
- The agent read-ban moves with the files: `envs/secrets/` is denied in `.claude/settings.json` and blocked by `.claude/hooks/guard.sh`; `AGENTS.md` names the new path (ADR 0014).

## Alternatives considered

- Keep `~/.config/car_agent/`: structurally immune to an accidental commit, but the project is not self-contained and the path is per-machine.
- Secrets in git, encrypted (SOPS, git-crypt): adds key management to every clone; rejected when ADR 0002 was accepted and nothing changed since.

## Consequences

The project folder carries everything, including secrets: backups and repo-scanning tools now see them, and the gitignore entry is the only thing between the secrets and a commit (`git add .` skips ignored files; `git add -f` would not). `.dockerignore` already excludes `envs` from the build context. Tools that scan the working tree must honour the ban on `envs/secrets/`.
