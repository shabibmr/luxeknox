-- Hand-authored SQL migration: 0004_people.sql
-- Vertical 3: PEOPLE profiles (members / trainers / employees) + emergency_contacts
-- + membership_number_counters (gap-free FOR UPDATE allocation).
-- Engine: PostgreSQL 17

CREATE TYPE "employee_status" AS ENUM ('active', 'on_probation', 'suspended', 'terminated');

CREATE TABLE IF NOT EXISTS trainers (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  bio TEXT NULL,
  specializations JSONB NULL,
  hourly_rate NUMERIC(12, 2) NULL,
  rating DOUBLE PRECISION NULL,
  max_clients_capacity BIGINT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT trainers_user_id_unique UNIQUE (user_id),
  CONSTRAINT trainers_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES users (id),
  -- Decision 5 (ADR-0009): re-assert the lost UNSIGNED domain meaning explicitly.
  CONSTRAINT trainers_max_clients_capacity_check CHECK (max_clients_capacity >= 0)
);

CREATE TABLE IF NOT EXISTS employees (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  job_title VARCHAR(150) NOT NULL,
  department VARCHAR(150) NULL,
  hire_date DATE NULL,
  status employee_status NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT employees_user_id_unique UNIQUE (user_id),
  CONSTRAINT employees_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS members (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL,
  membership_number VARCHAR(16) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  gender VARCHAR(32) NULL,
  date_of_birth DATE NULL,
  address TEXT NULL,
  assigned_trainer_id BIGINT NULL,
  joined_date DATE NOT NULL,
  notes TEXT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT members_user_id_unique UNIQUE (user_id),
  CONSTRAINT members_membership_number_unique UNIQUE (membership_number),
  CONSTRAINT members_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES users (id),
  CONSTRAINT members_assigned_trainer_id_trainers_id_fk FOREIGN KEY (assigned_trainer_id) REFERENCES trainers (id)
);

CREATE INDEX members_assigned_trainer_id_idx ON members (assigned_trainer_id);

-- Single-row counter: allocate with SELECT … FOR UPDATE inside person-create TX,
-- then format membership_number as 'M' + LPAD(next_value, 8, '0'). Not an identity/SEQUENCE —
-- a SEQUENCE is not gap-free or rollback-safe, and membership numbers are member-facing.
CREATE TABLE IF NOT EXISTS membership_number_counters (
  id BIGINT PRIMARY KEY,
  next_value BIGINT NOT NULL
);

INSERT INTO membership_number_counters (id, next_value)
VALUES (1, 1)
ON CONFLICT (id) DO NOTHING;

CREATE TABLE IF NOT EXISTS emergency_contacts (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NOT NULL,
  contact_name VARCHAR(150) NOT NULL,
  relationship VARCHAR(100) NULL,
  phone_primary VARCHAR(32) NOT NULL,
  phone_secondary VARCHAR(32) NULL,
  is_primary BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT emergency_contacts_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE INDEX emergency_contacts_user_id_idx ON emergency_contacts (user_id);
