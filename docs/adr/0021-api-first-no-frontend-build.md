# 0021. API-first, no frontend build

## Status

Accepted

## Date

2026-11-22

## Context

The project is a backend showcase and does not need a frontend toolchain. Split from ADR 0004 (see ADR 0008); the decision is unchanged.

## Decision

- API-first, no frontend build: Vite and `package.json` are removed. A thin Livewire page may be added later for an agent chat demo.

## Alternatives considered

- Inertia with React: a separate frontend project that adds little to a backend showcase.

## Consequences

No Node toolchain is needed.
