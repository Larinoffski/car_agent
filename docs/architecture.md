# Architecture

## Context

TODO

## Components

```
            browser / curl
                 │  :8080
                 ▼
┌──────────────────────────┐   FastCGI :9000   ┌─────────────────────────┐
│ nginx                    │ ────────────────▶ │ app (php-fpm)           │
│ HTTP in, every request   │                   │ Laravel, code in        │
│ goes to index.php        │                   │ /var/www/html           │
└──────────────────────────┘                   └────────────┬────────────┘
                                                            │ :5432
                                                            ▼
                                               ┌─────────────────────────┐
                                               │ postgres + pgvector     │
                                               └─────────────────────────┘
         (local only) swagger-ui :8081 reads openapi/openapi.yaml
```

| Service | Image | Role |
|---|---|---|
| `nginx` | `nginx` | Terminates HTTP and forwards every request to the Laravel front controller over FastCGI. Holds no application code. |
| `app` | `docker/php/Dockerfile` | php-fpm running Laravel. The `dev` target mounts code from the host; the `prod` target bakes it into the image. |
| `postgres` | `pgvector/pgvector` | Primary database and default vector store (ADR 0004). |
| `swagger-ui` | `swaggerapi/swagger-ui` | Local only: renders the API contract from `openapi/openapi.yaml`. |

## Images

`docker/php/Dockerfile`, multi-stage; compose selects the target by `APP_RUNTIME` and environment.

```
                 base-nts  (PHP, extensions, php.ini, fpm.conf)
                 ┌───┴────────────────┐
                 ▼                    ▼
             fpm-dev               fpm-prod
   local, test                  staging, production
   code mounted from host       code and vendor in the image
   Xdebug, Composer             no Composer, OPcache without timestamp checks
```

## Environments

`make <target> ENV=<env>` runs `compose.yaml` + `compose.<env>.yaml`.

```
compose.yaml          app, nginx, postgres (healthcheck, pgdata volume, init.sql: CREATE EXTENSION vector)
  + compose.local.yaml        dev target, code mount, ports on 127.0.0.1, Xdebug switch, swagger-ui
  + compose.test.yaml         dev target, code mount, no ports; CI uses it too
  + compose.staging.yaml      prod target
  + compose.production.yaml   prod target
```

| Port (local) | Service |
|---|---|
| 8080 | nginx |
| 8081 | swagger-ui |
| 5432 | postgres |

Xdebug: off by default, `make up XDEBUG_MODE=debug` turns it on.

## Configuration

No `.env` in the application root (ADR 0004). The same files feed compose and the container:

```
envs/<env>.env ──┐
                 ├──▶ make ──▶ docker compose --env-file   → ${VAR} in compose files (e.g. POSTGRES_* from DB_*)
~/.config/       │
car_agent/       └──▶ compose.<env>.yaml env_file          → app container environment
<env>.env (optional, secrets)
                                                             │
                                                             ▼
                                         php-fpm workers (clear_env = no) → Laravel env()
```

Details: [envs/README.md](../envs/README.md).

## Data flow

1. A request reaches nginx on port 8080.
2. nginx passes it to php-fpm in `app` over FastCGI, always with `public/index.php` as the script.
3. Laravel handles it and reads or writes PostgreSQL.

Decisions behind this design are recorded in [adr/](adr/).
