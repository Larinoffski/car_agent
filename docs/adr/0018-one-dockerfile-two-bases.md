# 0018. One Dockerfile, two PHP bases, dev and prod targets

## Status

Accepted

## Date

2026-11-22

## Context

Everything runs in Docker (ADR 0002), and the image must serve several PHP runtimes in both development and production. Split from ADR 0004 (see ADR 0008); the decision is unchanged.

## Decision

- One Dockerfile on Debian (official `php` images). Two bases: NTS for php-fpm, Swoole and RoadRunner; ZTS for FrankenPHP. Runtime stages build on a base; each has a `dev` target (Composer, Xdebug, code mounted from the host) and a `prod` target (code in the image, `composer install --no-dev`, OPcache). Compose overlays select the target.

## Alternatives considered

- Alpine images: smaller, but musl causes extension build and DNS issues.
- Laravel Sail: development only, its own Dockerfiles, does not fit the per-environment layout.

## Consequences

Two bases mean two builds, in exchange for adding FrankenPHP without reworking the image.
