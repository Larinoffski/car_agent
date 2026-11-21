# envs/

Per-environment configuration. Files here are committed and contain no secrets.

| File | Purpose |
|---|---|
| `local.env.example` | Template for local secrets (outside the repo) |
| `local.env` | Local development |
| `test.env` | Test run |
| `ci.env` | GitHub Actions; same as `test` for now, diverges for CI-only services and caching |
| `staging.env`, `production.env` | Deployed environments |

## Secrets

- `local`: `$(SECRETS_DIR)/local.env`, outside the repo. `SECRETS_DIR` defaults to `~/.config/car_agent`. Start from `local.env.example`.
- `test`, `ci`: no secrets; external services are stubbed. CI secrets, if needed, come from GitHub Secrets.
- `staging`, `production`: injected at deploy time from the platform secret store. No secret files on disk.

## Load order

`envs/<env>.env` → `$(SECRETS_DIR)/<env>.env` (if present) → environment variables of CI or the orchestrator.

TODO: wire files into containers via `env_file` in the compose overlays.
