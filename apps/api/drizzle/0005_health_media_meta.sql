-- Hand-authored SQL migration: 0005_health_media_meta.sql
-- Vertical 3: member_health / member_documents / member_photos (URL/key only — FR-API-013)
-- Do NOT create health_conditions or medical_histories (deferred).
-- Engine: PostgreSQL 17

CREATE TYPE "document_type" AS ENUM ('id_proof', 'waiver', 'medical_cert');

CREATE TABLE IF NOT EXISTS member_health (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  member_id BIGINT NOT NULL,
  blood_group VARCHAR(16) NULL,
  height_cm DOUBLE PRECISION NULL,
  baseline_weight_kg DOUBLE PRECISION NULL,
  allergies TEXT NULL,
  dietary_preferences TEXT NULL,
  physician_name VARCHAR(150) NULL,
  physician_phone VARCHAR(32) NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT member_health_member_id_unique UNIQUE (member_id),
  CONSTRAINT member_health_member_id_members_id_fk FOREIGN KEY (member_id) REFERENCES members (id)
);

CREATE TABLE IF NOT EXISTS member_documents (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  member_id BIGINT NOT NULL,
  document_type document_type NOT NULL,
  title VARCHAR(255) NULL,
  file_url VARCHAR(1024) NOT NULL,
  file_size BIGINT NULL,
  verified_by_user_id BIGINT NULL,
  verified_at TIMESTAMPTZ(3) NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT member_documents_member_id_members_id_fk FOREIGN KEY (member_id) REFERENCES members (id),
  CONSTRAINT member_documents_verified_by_user_id_users_id_fk FOREIGN KEY (verified_by_user_id) REFERENCES users (id),
  -- Decision 5 (ADR-0009): re-assert the lost UNSIGNED domain meaning explicitly.
  CONSTRAINT member_documents_file_size_check CHECK (file_size >= 0)
);

CREATE INDEX member_documents_member_id_idx ON member_documents (member_id);

CREATE TABLE IF NOT EXISTS member_photos (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  member_id BIGINT NOT NULL,
  photo_url VARCHAR(1024) NOT NULL,
  is_current_avatar BOOLEAN NOT NULL DEFAULT FALSE,
  captured_at TIMESTAMPTZ(3) NOT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT member_photos_member_id_members_id_fk FOREIGN KEY (member_id) REFERENCES members (id)
);

CREATE INDEX member_photos_member_id_idx ON member_photos (member_id);
