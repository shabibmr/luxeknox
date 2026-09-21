-- Hand-authored SQL migration: 0002_exercises.sql
-- Vertical 1: Exercise Library (FR-WORK-001, FR-WORK-002, docs/adr/0007-first-delivery-vertical.md)
-- Engine: PostgreSQL 17

CREATE TABLE IF NOT EXISTS exercises (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  primary_muscle_group VARCHAR(100) NULL,
  secondary_muscles JSONB NULL,
  equipment_needed VARCHAR(150) NULL,
  instructions TEXT NULL,
  video_url VARCHAR(500) NULL,
  gif_url VARCHAR(500) NULL,
  difficulty_level VARCHAR(50) NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL
);

CREATE INDEX exercises_is_active_primary_muscle_group_idx ON exercises (is_active, primary_muscle_group);
CREATE INDEX exercises_name_idx ON exercises (name);
