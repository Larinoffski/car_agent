# 0001. Record architecture decisions

## Status

Accepted

## Date

2026-11-21

## Context

Architecture decisions need to be visible to everyone working on the project, people and AI agents alike, together with the reasoning behind them.

## Decision

Record every significant architecture decision as an ADR in `docs/adr/`, using `template.md`. Files are numbered sequentially: `NNNN-short-title.md`. An accepted ADR is not rewritten; a changed decision gets a new ADR that supersedes the old one.

## Alternatives considered

- No written records: reasoning is lost and decisions get re-debated.
- Wiki outside the repo: drifts from the code and is not visible to agents.

## Consequences

Decisions and their reasoning live next to the code and are reviewed like code. Writing an ADR adds a small cost to each significant decision.
