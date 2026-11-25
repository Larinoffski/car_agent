# 0019. nginx in front of every runtime

## Status

Accepted

## Date

2026-11-22

## Context

The project supports several PHP runtimes and needs one web entry point for all of them. Split from ADR 0004 (see ADR 0008); the decision is unchanged.

## Decision

- nginx in front of every runtime. php-fpm first; Octane runtimes are added as stages later.

## Alternatives considered

- None recorded in ADR 0004 for this decision.

## Consequences

The web entry point stays the same across runtimes.
