# 0013. Staging and production secrets injected at deploy time

## Status

Accepted

## Date

2026-11-21

## Context

Secrets for deployed environments must stay out of the repository and off disk. Split from ADR 0002 (see ADR 0008); the decision is unchanged.

## Decision

- Staging and production secrets are injected by the platform at deploy time; no secret files on disk.

## Alternatives considered

- None recorded in ADR 0002 for this decision.

## Consequences

Secrets for deployed environments depend on the platform's secret store.
