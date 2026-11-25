# 0027. main builds the staging image

## Status

Accepted

## Date

2026-11-25

## Context

There is one long-lived branch, `main`, and no deployment yet (ADR 0023 defers it). CI on pull requests runs the test environment (ADR 0007) and validates the other configs, but nothing exercises the deployable artifact — the `prod`-target image — with a real environment's configuration. Until a `staging` branch exists, `main` is the closest thing to staging.

## Decision

- Every push to `main` — in practice, every merged PR, since direct pushes are blocked — builds the staging image: the `build-staging` job in `.github/workflows/ci.yml` runs `make build ENV=staging` under `environment: staging` with its secrets (ADR 0026).
- The job runs only on `push`, not on pull requests, and is not a required status check.
- When a `staging` branch is introduced, `main` switches to building production and the `staging` branch takes the staging build; that change comes as its own ADR.

## Alternatives considered

- Build the staging image on every PR: doubles the heaviest CI step for changes that may never merge; the merged state is what would be deployed.
- No staging build until a real deployment: a broken `prod` target or staging config is then discovered at the worst moment — during the first deploy.

## Consequences

A merged PR proves the deployable image builds with the staging configuration. The image is built and discarded: nothing is pushed to a registry until a deployment exists. A red `build-staging` on `main` signals a broken prod target, staging config or GitHub secret, without blocking merges.
