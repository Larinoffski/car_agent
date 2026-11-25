# 0006. One compose project for all environments

## Status

Superseded by 0023, 0024

## Date

2026-11-23

## Context

ADR 0002 gives each environment its own compose overlay. All of them share the compose project name `car_agent`, so they share containers, volumes and the image name. Until there is a real deployment the environments differ only in connections and secrets; the code and the stack are the same.

## Decision

- One compose project for every `ENV`. Environments are not run side by side locally.
- Tests run in the local stack against a separate database, `car_agent_test`, in the same PostgreSQL container.
- CI runs its own stack on a clean runner and needs no separate database.
- A project, image and volume per environment are introduced with the first real deployment (AWS, Terraform), not before.

## Alternatives considered

- A project per environment (`docker compose -p car_agent_<env>`): separate images, containers and volumes, environments can run at the same time. Not needed for the MVP; it doubles local builds and databases for no current use.
- A separate PostgreSQL container for tests: isolates test data fully, but adds a service for what a second database already gives.

## Consequences

`make up ENV=<env>` replaces the running stack instead of starting another one. Building the `prod` target overwrites the local `dev` image; run `make build` afterwards. The `vector` extension is created per database, so the test database needs its own `CREATE EXTENSION`.
