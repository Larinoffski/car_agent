# 0025. All environment variables are required

## Status

Accepted

## Date

2026-11-25

## Context

ADR 0020 passes configuration as environment variables. With `${VAR:-}` defaults in the compose files, a missing or empty variable surfaced late and silently: `make config` passed, the stack failed only at runtime — postgres refusing to initialise without a password, the application failing to authenticate. There is no marked distinction between required and optional variables; in practice every variable is required. This decision extends ADR 0020.

## Decision

- Every variable interpolated in `compose.yaml` and the overlays uses `${VAR:?}`: unset or empty fails any compose command — `make config`, `make build`, `make up` — naming the variable, locally and in CI alike.
- Variables that reach the container only through `env_file` are not validated by compose, so required ones are listed explicitly in the service's `environment:` block as `VAR: ${VAR:?}` (`APP_KEY` in the local, staging and production overlays).
- Required-ness is declared where the variable is used: `:?` means required, `:-` with a default means optional. Required means a developer must define it, and the single source of that list is the committed `envs/<env>.env` files plus `envs/secrets.env.example`. A variable with a sane library default (such as `XDEBUG_MODE`, defaulted to `off` in `compose.local.yaml`) stays `:-` and is listed in no env or example file.
- `test` needs no secrets (ADR 0012): its values come from the committed `envs/test.env`, and `APP_KEY` is generated per run by `tests/TestCase.php`, so the `APP_KEY` check lives in the other overlays, not in `compose.yaml`.

## Alternatives considered

- Keep `${VAR:-}` and validate at application start: the failure moves inside the container, after images are built and services are up — later and harder to read than a one-line interpolation error.
- A separate manifest of required variables checked by a script: a second source of truth next to the compose files; the `:?`/`:-` syntax already carries the same information in place.

## Consequences

Any compose invocation without the full variable set fails, including `make down` and `make ps` on a fresh clone: the secrets file comes first, then any make command (except `ENV=test`). Compose may report only part of the missing variables per run, so filling them is iterative. New variables are born required by default.
