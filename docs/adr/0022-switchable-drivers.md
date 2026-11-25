# 0022. Switchable drivers

## Status

Accepted

## Date

2026-11-22

## Context

Several concerns have more than one reasonable technology. The project starts with the minimum, must be able to switch without code changes, and compares some options directly (runtime benchmarks). Split from ADR 0005 (see ADR 0008); the decision is unchanged.

## Decision

- Every swap point is selected by one environment variable; code does not change.
- Services for non-default options run as compose profiles enabled through `COMPOSE_PROFILES`.
- Where Laravel has a driver system, it is used as is (queue, cache, session, mail, logging, filesystem, Scout). Elsewhere the application defines a contract and binds the implementation selected by config in a service provider.
- An option without an implementation exists as a stub that fails loudly when called.
- Defaults are minimal: the first `make up` starts no optional services.

| Concern | Variable | Default | Options |
|---|---|---|---|
| Web runtime | `APP_RUNTIME` | `fpm` | `frankenphp`, `swoole`, `roadrunner` |
| Queue | `QUEUE_CONNECTION` | `database` | `redis` (Horizon), `rabbitmq`, `sync` in tests |
| Cache, sessions | `CACHE_STORE`, `SESSION_DRIVER` | `database` | `redis` |
| Full-text search | `SCOUT_DRIVER` | `database` | `elasticsearch` |
| Vector store | `VECTOR_STORE` | `pgvector` | `elasticsearch`, `qdrant` (stubs) |
| Domain events | `EVENT_BUS_DRIVER` | `log` | `rabbitmq` |
| LLM | `LLM_PROVIDER` | `fake` | `anthropic`, `openai` |
| Mail | `MAIL_MAILER` | `log` | `smtp` (Mailpit) |
| Logs | `LOG_CHANNEL` | `stderr` | `stack` |
| Files | `FILESYSTEM_DISK` | `local` | `s3` |

## Alternatives considered

- One fixed technology per concern: simpler, but a switch becomes a refactor and comparisons are impossible.
- A branch per technology: branches drift, and no two options can be compared on the same code.

## Consequences

Each swap point needs a test that the configured implementation is bound. Code must be safe under every runtime: no per-request state in singletons or static properties; Swoole-only Octane APIs (`Octane::table`, the `octane` cache, task workers) stay isolated. The configuration surface grows, and every option is listed here.
