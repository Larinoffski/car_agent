# AGENTS.md

Guidance for AI coding agents (Claude Code, Codex, Cursor) and humans working in this repository.

## Overview

TBD: one-paragraph project description.

## Commands

Everything runs in Docker. Nothing is installed on the host: no language runtimes, package managers or build tools.

- Run commands via `make <target>` or `docker compose exec app <cmd>`.
- `make help` lists the available targets.
- `make lint` (Pint check and PHPStan) must pass before a change is reported as done; `make format` formats code.
- PHPStan runs at level 10 on `app`, `database` and `routes`. Do not lower the level, add ignores or a baseline without asking.
- `make psalm` is a second, advisory analyser; its findings do not block a merge.

## Project structure

TBD

## Conventions

- Everything committed to the repo is in English: code, comments, commit messages, docs.
- A new file follows the pattern of its neighbours: structure, naming scheme, headings. File names without spaces.
- DRY: knowledge lives in one place; similar-looking code is not duplication by itself.
- Simplest code that passes the tests; no abstraction, option or layer without a current use.
- An interface only where there are two implementations or a deliberate swap point recorded in an ADR.
- One class, one responsibility; depend on contracts bound in the container, not on concrete classes.
- Follow `CONTRIBUTING.md`: commit messages, branches, PRs.
- Architecture decisions are recorded in `docs/adr/` (copy `docs/adr/template.md`).

## Testing

- Test first: write a failing test, then the code that makes it pass.
- Run tests via `make test` (the stack must be up); a subset: `make test ARGS="--filter=Name"`.
- Tests are written with Pest. `tests/Feature` holds tests that boot the application (bound to `Tests\TestCase` in `tests/Pest.php`); `tests/Unit` holds tests that need no framework.
- Tests run against the `car_agent_test` database. `tests/TestCase.php` refuses any database whose name does not end in `_test`; do not weaken that check.
- Settings that switch the local stack into test mode live in `phpunit.xml` as `<server>` entries, not `<env>`.

## Security

- Never read, print or edit environment files: `envs/secrets/` (local secrets), `.env`, `.env.*`, `envs/*.env`. Propose the variables and where they go; a human edits the files. `*.example` templates are fine to read and edit.
- TBD
