# 0007. CI runs the test environment

## Status

Accepted

## Date

2026-11-23

## Context

ADR 0002 lists five environments: local, test, CI, staging, production. `test` and `ci` had identical overlays and configuration, and both run Laravel in the same mode, `APP_ENV=testing`. Everything specific to CI is set in the workflow, not in an environment file: secrets from GitHub Secrets, build cache, compose profiles (ADR 0005).

This decision amends ADR 0002.

## Decision

- Four environments: `local`, `test`, `staging`, `production`. The `ci` environment is removed.
- CI runs the `test` environment: `make <target> ENV=test`.
- Environments are named by purpose, not by who runs them. Each maps to one Laravel mode: `local`, `testing`, `staging`, `production`.

## Alternatives considered

- Keep `ci`, remove `test`: the name describes the runner; it becomes wrong as soon as the same stack is run anywhere else.
- Keep both: justified only if CI runs a prebuilt image instead of mounted code. Not planned.

## Consequences

One overlay and one env file fewer to keep in sync. The required status check `compose (ci)` is removed from the `main` ruleset. If CI later needs a different stack, a `ci` environment is added back by a new ADR.
