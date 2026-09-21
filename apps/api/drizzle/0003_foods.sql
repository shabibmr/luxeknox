-- Hand-authored SQL migration: 0003_foods.sql
-- Vertical 2: Food Library (FR-DIET-001, docs/adr/0007-first-delivery-vertical.md)
-- Engine: PostgreSQL 17

CREATE TABLE IF NOT EXISTS foods (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  serving_unit VARCHAR(50) NOT NULL,
  serving_size DOUBLE PRECISION NULL,
  calories DOUBLE PRECISION NULL,
  protein_grams DOUBLE PRECISION NULL,
  carbs_grams DOUBLE PRECISION NULL,
  fat_grams DOUBLE PRECISION NULL,
  fiber_grams DOUBLE PRECISION NULL,
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL
);

CREATE INDEX foods_is_active_is_verified_idx ON foods (is_active, is_verified);
CREATE INDEX foods_name_idx ON foods (name);
