# 0004. Application stack

## Status

Superseded by 0015, 0016, 0017, 0018, 0019, 0020, 0021

## Date

2026-11-22

## Context

The project needs a framework, a database, a search engine and a container layout. Versions should be stable rather than the newest, and upgradable in a controlled way. Everything runs in Docker (ADR 0002); configuration comes from the environment, not from files in the working tree (ADR 0003).

## Decision

- Laravel 12 on PHP 8.4. Each version is set in one place: PHP by the `PHP_VERSION` build argument in the Dockerfile, Laravel by the constraint in `composer.json`. An upgrade is a separate PR: change the version, rebuild, run the tests.
- PostgreSQL 18, latest minor, with pgvector: the primary database and the default vector store.
- Full-text search: Elasticsearch through Laravel Scout. The Scout driver and the Elasticsearch version are chosen by what installs on Laravel 12.
- One Dockerfile on Debian (official `php` images). Two bases: NTS for php-fpm, Swoole and RoadRunner; ZTS for FrankenPHP. Runtime stages build on a base; each has a `dev` target (Composer, Xdebug, code mounted from the host) and a `prod` target (code in the image, `composer install --no-dev`, OPcache). Compose overlays select the target.
- nginx in front of every runtime. php-fpm first; Octane runtimes are added as stages later.
- Configuration is passed as environment variables through compose `env_file`; there is no `.env` in the application root. `APP_KEY` is generated with `key:generate --show` and stored by a human.
- API-first, no frontend build: Vite and `package.json` are removed. A thin Livewire page may be added later for an agent chat demo.

## Alternatives considered

- Laravel 13, PHP 8.5+: newest, but a stable base plus an explicit upgrade later is the goal.
- PostgreSQL 19: release candidate only. PostgreSQL 16–17: older than needed.
- Alpine images: smaller, but musl causes extension build and DNS issues.
- Laravel Sail: development only, its own Dockerfiles, does not fit the per-environment layout.
- A dedicated vector database as primary (Qdrant, Pinecone): a second source of truth, no shared transactions, filters and similarity search split across systems.
- Inertia with React: a separate frontend project that adds little to a backend showcase.

## Consequences

Upgrades are explicit and reviewable. Two bases mean two builds, in exchange for adding FrankenPHP without reworking the image. Elasticsearch needs 1–2 GB of memory, so it runs behind a compose profile. No Node toolchain is needed.
