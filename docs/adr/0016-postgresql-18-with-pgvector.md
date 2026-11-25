# 0016. PostgreSQL 18 with pgvector

## Status

Accepted

## Date

2026-11-22

## Context

The project needs a database and a vector store, on a stable version. Split from ADR 0004 (see ADR 0008); the decision is unchanged.

## Decision

- PostgreSQL 18, latest minor, with pgvector: the primary database and the default vector store.

## Alternatives considered

- PostgreSQL 19: release candidate only. PostgreSQL 16–17: older than needed.
- A dedicated vector database as primary (Qdrant, Pinecone): a second source of truth, no shared transactions, filters and similarity search split across systems.

## Consequences

The primary database and the vector store share transactions and filters.
