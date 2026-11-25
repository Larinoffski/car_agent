# 0026. CI secrets come from GitHub Environments

## Status

Accepted

## Date

2026-11-25

## Context

With every variable required (ADR 0025), the CI jobs that validate the staging and production configs need secret values on the runner. Local secrets live in `envs/secrets/` and never leave the machine (ADR 0011); test needs no secrets (ADR 0012); staging and production secrets belong to the platform (ADR 0013). GitHub Actions offers environment-scoped secrets for exactly this.

## Decision

- GitHub Environments `staging` and `production` (created by `scripts/github/environments.sh`) each hold their own values under the same secret names: `APP_KEY`, `DB_PASSWORD` — the keys of `envs/secrets.env.example`. A human puts the values in.
- A CI job gets them by declaring `environment: ${{ matrix.env }}` and mapping `${{ secrets.<NAME> }}` into its `env`; the `compose` job in `.github/workflows/ci.yml` validates `staging` and `production` this way.
- `test` is a separate job (`compose-test`) without a GitHub environment: its values come from the committed `envs/test.env`.
- `local` does not exist in GitHub: its secrets are only the file `envs/secrets/local.env`.
- Non-secret variables are never duplicated into GitHub (neither secrets nor environment variables): the runner gets them from the committed `envs/<env>.env` at checkout.
- Deployment branch policies and protection rules on the environments are switched on only together with a real deployment: enabled earlier, they would cut PR branches off from the secrets the validation jobs need.

## Alternatives considered

- Repository-level secrets with `STAGING_`/`PRODUCTION_` prefixes: works, but the split is a naming convention with no protection rules, and the workflow hard-codes prefixed names instead of one mapping.
- Dummy values hard-coded in the workflow: validation stops meaning anything — a missing real secret is exactly what the jobs must catch.

## Consequences

CI fails when a secret is missing in GitHub, which also makes CI the check that the environments are configured. Secret values exist in three places by design — GitHub Environments, the platform store at deploy time (ADR 0013), and a developer's `envs/secrets/` for local runs — and a rotation touches all of them. New keys in `envs/secrets.env.example` mean new secrets in both GitHub environments.
