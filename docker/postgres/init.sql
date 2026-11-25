-- Runs once, when the data directory is initialised.
-- The image has already created the database named in POSTGRES_DB; this script runs inside it.
CREATE EXTENSION IF NOT EXISTS vector;

-- Test database (ADR 0006). Conditional: in the test environment POSTGRES_DB is already car_agent_test.
SELECT 'CREATE DATABASE car_agent_test'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'car_agent_test')\gexec

\connect car_agent_test
CREATE EXTENSION IF NOT EXISTS vector;
