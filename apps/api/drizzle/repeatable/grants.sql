-- Repeatable migration: apply least-privilege grants to the application user.
-- Runs as DB_ADMIN_USER on every migrate, after all numbered migrations.
-- audit_logs is append-only (NFR-003, ADR-0002/0009): SELECT + INSERT, never UPDATE/DELETE.
--
-- Three traps this file exists to avoid (ADR-0009):
-- 1. GRANT ... ON ALL SEQUENCES is mandatory — identity columns draw from sequences, and
--    without USAGE every insert by the app user fails. MySQL has no analogue.
-- 2. PostgreSQL 15+ no longer grants schema CREATE/USAGE to PUBLIC by default, so the app
--    role needs an explicit GRANT USAGE ON SCHEMA public.
-- 3. ALTER DEFAULT PRIVILEGES must be run by the role that will CREATE future tables
--    (DB_ADMIN_USER) or new tables land ungranted after the next migration.

GRANT USAGE ON SCHEMA public TO ${DB_USER};

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM ${DB_USER};

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO ${DB_USER};

REVOKE UPDATE, DELETE ON audit_logs FROM ${DB_USER};

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ${DB_USER};

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ${DB_USER};

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO ${DB_USER};
