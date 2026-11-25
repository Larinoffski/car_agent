# 0017. Full-text search through Laravel Scout and Elasticsearch

## Status

Accepted

## Date

2026-11-22

## Context

The project needs a full-text search engine that works with the chosen framework. Split from ADR 0004 (see ADR 0008); the decision is unchanged.

## Decision

- Full-text search: Elasticsearch through Laravel Scout. The Scout driver and the Elasticsearch version are chosen by what installs on Laravel 12.

## Alternatives considered

- None recorded in ADR 0004 for this decision.

## Consequences

Elasticsearch needs 1–2 GB of memory, so it runs behind a compose profile.
