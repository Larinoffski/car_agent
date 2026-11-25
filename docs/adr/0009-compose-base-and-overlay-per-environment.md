# 0009. Compose base file and one overlay per environment

## Status

Accepted

## Date

2026-11-21

## Context

The project runs in several environments (local, test, CI, staging, production), and Docker Compose needs a layout that keeps their differences small and reviewable. Split from ADR 0002 (see ADR 0008); the decision is unchanged.

## Decision

- Docker Compose: a base `compose.yaml` plus one overlay per environment, `compose.<env>.yaml`. `make` assembles them by `ENV` (default `local`).

## Alternatives considered

- None recorded in ADR 0002 for this decision.

## Consequences

Overlays are reviewed like code.
