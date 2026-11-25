# 0010. Non-secret configuration in committed env files

## Status

Accepted

## Date

2026-11-21

## Context

Non-secret configuration of each environment must stay reviewable. Split from ADR 0002 (see ADR 0008); the decision is unchanged.

## Decision

- Non-secret configuration per environment lives in `envs/<env>.env` and is committed.

## Alternatives considered

- Single `.env` in the repo root, git-ignored: secrets sit inside the agent's working directory and config changes are not reviewed.

## Consequences

Configuration changes go through review like code.
