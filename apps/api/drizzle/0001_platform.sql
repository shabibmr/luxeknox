-- Hand-authored SQL migration: 0001_platform.sql
-- Module 0 Platform Tables: roles, permissions, role_permissions, users, sessions, gym_settings, audit_logs
-- Engine: PostgreSQL 17
-- Encoding: UTF8 (set at initdb)

CREATE TYPE "user_type" AS ENUM ('member', 'trainer', 'employee', 'admin');
CREATE TYPE "user_status" AS ENUM ('active', 'inactive', 'suspended');

CREATE TABLE IF NOT EXISTS roles (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) NOT NULL,
  description TEXT NULL,
  is_system BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT roles_slug_unique UNIQUE (slug)
);

CREATE TABLE IF NOT EXISTS permissions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  module VARCHAR(50) NOT NULL,
  action VARCHAR(50) NOT NULL,
  slug VARCHAR(100) NOT NULL,
  description TEXT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT permissions_slug_unique UNIQUE (slug)
);

CREATE TABLE IF NOT EXISTS role_permissions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  role_id BIGINT NOT NULL,
  permission_id BIGINT NOT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT role_permissions_role_id_roles_id_fk FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT role_permissions_permission_id_permissions_id_fk FOREIGN KEY (permission_id) REFERENCES permissions (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT role_permissions_role_id_permission_id_unique UNIQUE (role_id, permission_id)
);

CREATE TABLE IF NOT EXISTS users (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email VARCHAR(255) NULL,
  phone_number VARCHAR(32) NULL,
  password_hash VARCHAR(255) NOT NULL,
  user_type user_type NOT NULL,
  role_id BIGINT NOT NULL,
  avatar_url VARCHAR(1024) NULL,
  status user_status NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT users_role_id_roles_id_fk FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT users_email_unique UNIQUE (email),
  CONSTRAINT users_phone_number_unique UNIQUE (phone_number),
  -- Decision 2 (ADR-0009): app already normalizes to lowercase via normalizeEmail() before
  -- every write; this makes the invariant engine-enforced instead of assumed.
  CONSTRAINT users_email_lowercase_check CHECK (email = lower(email))
);

CREATE TABLE IF NOT EXISTS sessions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL,
  user_type user_type NOT NULL,
  profile_id BIGINT NULL,
  family_id VARCHAR(64) NOT NULL,
  access_token_hash VARCHAR(64) NOT NULL,
  refresh_token_hash VARCHAR(64) NOT NULL,
  revoked_at TIMESTAMPTZ(3) NULL,
  expires_at TIMESTAMPTZ(3) NOT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT sessions_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX sessions_access_token_hash_idx ON sessions (access_token_hash);
CREATE INDEX sessions_refresh_token_hash_idx ON sessions (refresh_token_hash);
CREATE INDEX sessions_family_id_idx ON sessions (family_id);
CREATE INDEX sessions_user_id_revoked_at_idx ON sessions (user_id, revoked_at);

CREATE TABLE IF NOT EXISTS gym_settings (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  setting_key VARCHAR(100) NOT NULL,
  setting_value TEXT NOT NULL,
  description VARCHAR(255) NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT gym_settings_setting_key_unique UNIQUE (setting_key)
);

CREATE TABLE IF NOT EXISTS audit_logs (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  actor_user_id BIGINT NULL,
  action VARCHAR(100) NOT NULL,
  entity_name VARCHAR(100) NOT NULL,
  entity_id BIGINT NULL,
  before_state JSONB NULL,
  after_state JSONB NULL,
  ip_address VARCHAR(45) NULL,
  created_at TIMESTAMPTZ(3) NOT NULL
);
