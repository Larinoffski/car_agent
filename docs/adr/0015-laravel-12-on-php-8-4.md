# 0015. Laravel 12 on PHP 8.4

## Status

Accepted

## Date

2026-11-22

## Context

The project needs a framework and language versions that are stable rather than the newest, and upgradable in a controlled way. Split from ADR 0004 (see ADR 0008); the decision is unchanged.

## Decision

- Laravel 12 on PHP 8.4. Each version is set in one place: PHP by the `PHP_VERSION` build argument in the Dockerfile, Laravel by the constraint in `composer.json`. An upgrade is a separate PR: change the version, rebuild, run the tests.

## Alternatives considered

- Laravel 13, PHP 8.5+: newest, but a stable base plus an explicit upgrade later is the goal.

## Consequences

Upgrades are explicit and reviewable.
