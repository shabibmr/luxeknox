-- Hand-authored SQL migration: 0006_memberships.sql
-- Vertical 4: Memberships & products (MEMB) — membership_products, memberships,
-- membership_freezes, membership_extensions, membership_histories.
-- Engine: PostgreSQL 17

CREATE TABLE IF NOT EXISTS membership_products (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  code VARCHAR(32) NOT NULL,
  description TEXT NULL,
  duration_days INT NOT NULL,
  base_price NUMERIC(10,2) NOT NULL,
  tax_percentage NUMERIC(5,2) NOT NULL DEFAULT '0.00',
  max_freeze_days INT NOT NULL DEFAULT 0,
  pt_sessions_included INT NOT NULL DEFAULT 0,
  access_facilities JSONB NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL
);

CREATE UNIQUE INDEX membership_products_code_unique ON membership_products (code);

CREATE INDEX membership_products_is_active_idx ON membership_products (is_active);

CREATE TABLE IF NOT EXISTS memberships (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  member_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  remaining_pt_sessions INT NOT NULL DEFAULT 0,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  locker_number VARCHAR(16) NULL,
  auto_renew BOOLEAN NOT NULL DEFAULT FALSE,
  row_version INT NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT memberships_member_id_fk FOREIGN KEY (member_id) REFERENCES members (id),
  CONSTRAINT memberships_product_id_fk FOREIGN KEY (product_id) REFERENCES membership_products (id)
);

CREATE INDEX memberships_member_id_idx ON memberships (member_id);

CREATE INDEX memberships_status_idx ON memberships (status);

CREATE INDEX memberships_end_date_idx ON memberships (end_date);

CREATE INDEX memberships_locker_number_idx ON memberships (locker_number);

CREATE TABLE IF NOT EXISTS membership_freezes (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  membership_id BIGINT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_freeze_days INT NOT NULL,
  reason TEXT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'pending',
  reviewed_by_user_id BIGINT NULL,
  reviewed_at TIMESTAMPTZ(3) NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT membership_freezes_membership_id_fk FOREIGN KEY (membership_id) REFERENCES memberships (id),
  CONSTRAINT membership_freezes_reviewed_by_user_id_fk FOREIGN KEY (reviewed_by_user_id) REFERENCES users (id)
);

CREATE INDEX membership_freezes_membership_id_idx ON membership_freezes (membership_id);

CREATE INDEX membership_freezes_status_idx ON membership_freezes (status);

CREATE TABLE IF NOT EXISTS membership_extensions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  membership_id BIGINT NOT NULL,
  days_extended INT NOT NULL,
  reason TEXT NULL,
  granted_by_user_id BIGINT NOT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT membership_extensions_membership_id_fk FOREIGN KEY (membership_id) REFERENCES memberships (id),
  CONSTRAINT membership_extensions_granted_by_user_id_fk FOREIGN KEY (granted_by_user_id) REFERENCES users (id)
);

CREATE INDEX membership_extensions_membership_id_idx ON membership_extensions (membership_id);

CREATE TABLE IF NOT EXISTS membership_histories (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  membership_id BIGINT NOT NULL,
  action VARCHAR(16) NOT NULL,
  old_end_date DATE NULL,
  new_end_date DATE NULL,
  performed_by_user_id BIGINT NOT NULL,
  timestamp TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT membership_histories_membership_id_fk FOREIGN KEY (membership_id) REFERENCES memberships (id),
  CONSTRAINT membership_histories_performed_by_user_id_fk FOREIGN KEY (performed_by_user_id) REFERENCES users (id)
);

CREATE INDEX membership_histories_membership_id_idx ON membership_histories (membership_id);
