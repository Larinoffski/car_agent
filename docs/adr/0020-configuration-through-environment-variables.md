# 0020. Configuration through environment variables

## Status

Accepted

## Date

2026-11-22

## Context

Configuration comes from the environment, not from files in the working tree (ADR 0014). Split from ADR 0004 (see ADR 0008); the decision is unchanged.

## Decision

- Configuration is passed as environment variables through compose `env_file`; there is no `.env` in the application root. `APP_KEY` is generated with `key:generate --show` and stored by a human.

## Alternatives considered

- None recorded in ADR 0004 for this decision.

## Consequences

The application reads configuration only from the container environment.
