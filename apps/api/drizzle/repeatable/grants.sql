-- Repeatable migration: apply least-privilege grants to the application user.
-- Runs as DB_ADMIN_USER on every migrate, after all numbered migrations.
-- audit_logs is append-only (NFR-003, ADR-0002/0009): SELECT + INSERT, never UPDATE/DELETE/TRUNCATE.
--
-- DDL/DML Boundary Audit (HARDEN-07):
-- 1. Explicitly REVOKE CREATE on SCHEMA public to ensure no DDL privilege (no CREATE TABLE, DROP TABLE, ALTER TABLE).
-- 2. Only grant USAGE on SCHEMA public.
-- 3. Only grant DML privileges (SELECT, INSERT, UPDATE, DELETE) on tables.
-- 4. REVOKE UPDATE, DELETE, TRUNCATE on audit_logs from app user for append-only immutability.
-- 5. Only grant USAGE, SELECT on SEQUENCES for identity/sequence generation.
-- 6. ALTER DEFAULT PRIVILEGES maintains these exact boundaries for future objects created by DB_ADMIN_USER.

REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM ${DB_USER};
GRANT USAGE ON SCHEMA public TO ${DB_USER};

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM ${DB_USER};
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO ${DB_USER};

REVOKE UPDATE, DELETE, TRUNCATE ON audit_logs FROM ${DB_USER};

REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM ${DB_USER};
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ${DB_USER};

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  REVOKE ALL ON TABLES FROM ${DB_USER};
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ${DB_USER};

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  REVOKE ALL ON SEQUENCES FROM ${DB_USER};
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO ${DB_USER};
