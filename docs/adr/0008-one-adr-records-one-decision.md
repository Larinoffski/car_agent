# 0008. One ADR records one decision

## Status

Accepted

## Date

2026-11-25

## Context

ADR 0002 and ADR 0004 bundle several decisions in one file. When one bundled decision changed, no status fit the file as a whole: the ADR was neither accepted nor superseded, and an amendment had to describe which part it touched. A status is only precise when it covers exactly one decision, and the existing bundles block further work on individual decisions.

## Decision

- One ADR holds one decision and one status.
- A set of related decisions becomes several ADRs that reference each other, not one bundled file.
- A changed decision gets a new ADR; the old ADR's Status section changes to `Superseded by NNNN` and nothing else in it is edited.
- The existing bundled ADRs 0002–0006 are split into one-decision files (0009–0024) with their decision texts kept verbatim; the originals are marked superseded by their split.

## Alternatives considered

- Per-decision statuses inside a bundled ADR: statuses split, but Context, Alternatives and Consequences stay shared across decisions, and a reference like "ADR 0002" still points at several decisions at once.
- Leaving bundles as they are until a decision changes: every future change starts with working out what exactly is superseded — the problem this ADR removes.

## Consequences

More and smaller ADR files, with cross-references instead of one shared context. A status change is atomic, and a reference names exactly one decision.
