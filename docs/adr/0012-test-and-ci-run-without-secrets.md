# 0012. Test and CI run without secrets

## Status

Accepted

## Date

2026-11-21

## Context

Tests and CI must run on a fresh clone and on a clean runner without access to secrets. Split from ADR 0002 (see ADR 0008); the decision is unchanged.

## Decision

- Test and CI need no secrets; external services are stubbed.

## Alternatives considered

- None recorded in ADR 0002 for this decision.

## Consequences

A fresh clone runs without secrets except the local ones each developer provides.
