# envs/

Per-environment configuration. Files here are committed and contain no secrets.

| File | Purpose |
|---|---|
| `secrets.env.example` | Template for a secrets file (outside the repo) |
| `local.env` | Local development |
| `test.env` | Test run; CI uses it too |
| `staging.env`, `production.env` | Deployed environments |

## Secrets

- `local`: `$(SECRETS_DIR)/local.env`, outside the repo. `SECRETS_DIR` defaults to `~/.config/car_agent`. Start from `secrets.env.example`.
- `test`: no secrets; external services are stubbed. The database is disposable, so its password sits in `envs/test.env`. CI secrets, if needed, come from GitHub Secrets.
- `staging`, `production`: injected at deploy time from the platform secret store. No secret files on disk. A local run of the prod image may read `$(SECRETS_DIR)/<env>.env`.

## Load order

`envs/<env>.env` → `$(SECRETS_DIR)/<env>.env` (if present) → environment variables of CI or the orchestrator.

```
make <target> ENV=<env>          (default: local)
   │
   ├── envs/<env>.env                  required, in git, non-secret
   └── $(SECRETS_DIR)/<env>.env        optional, outside git, secrets
          │
          ├──▶ docker compose --env-file   → ${VAR} in compose files (postgres gets POSTGRES_* from DB_*)
          └──▶ app env_file                → container environment → php-fpm (clear_env = no) → env()
```

There is no `.env` in the application root.

## Local setup

1. Copy the secrets template:
   ```sh
   mkdir -p ~/.config/car_agent
   cp envs/secrets.env.example ~/.config/car_agent/local.env
   ```
2. Fill in the secrets:

   | Key | How to get |
   |---|---|
   | `DB_PASSWORD` | any value, e.g. `openssl rand -base64 24`; set before the first `make up` |
   | `APP_KEY` | `make artisan CMD="key:generate --show"` after the first `make up`, then `make up` again |

3. `make build`, `make composer CMD=install`, `make up`
