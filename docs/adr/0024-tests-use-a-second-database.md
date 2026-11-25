# 0024. Tests use a second database in the same PostgreSQL

## Status

Accepted

## Date

2026-11-23

## Context

Tests need isolated data, and the project runs one compose project for all environments (ADR 0023). Split from ADR 0006 (see ADR 0008); the decision is unchanged.

## Decision

- Tests run in the local stack against a separate database, `car_agent_test`, in the same PostgreSQL container.

## Alternatives considered

- A separate PostgreSQL container for tests: isolates test data fully, but adds a service for what a second database already gives.

## Consequences

The `vector` extension is created per database, so the test database needs its own `CREATE EXTENSION`.
