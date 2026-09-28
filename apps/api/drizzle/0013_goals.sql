-- Hand-authored SQL migration: 0013_goals.sql
-- Vertical 12 GOAL: goal_metrics, goals, goal_histories, measurements,
-- measurement_values, progress_photos, progress_notes.
-- Depends on 0004_people.sql (members, users).
-- Engine: PostgreSQL 17

CREATE TABLE IF NOT EXISTS goal_metrics (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  unit_of_measure VARCHAR(32) NOT NULL,
  category VARCHAR(64) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL
);

CREATE INDEX goal_metrics_category_idx ON goal_metrics (category);

CREATE INDEX goal_metrics_is_active_idx ON goal_metrics (is_active);

CREATE INDEX goal_metrics_name_idx ON goal_metrics (name);

CREATE TABLE IF NOT EXISTS goals (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  member_id BIGINT NOT NULL,
  metric_id BIGINT NOT NULL,
  baseline_value DOUBLE PRECISION NOT NULL,
  target_value DOUBLE PRECISION NOT NULL,
  current_value DOUBLE PRECISION NOT NULL,
  start_date DATE NOT NULL,
  target_date DATE NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'in_progress',
  row_version INT NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT goals_member_id_fk FOREIGN KEY (member_id) REFERENCES members (id),
  CONSTRAINT goals_metric_id_fk FOREIGN KEY (metric_id) REFERENCES goal_metrics (id)
);

CREATE INDEX goals_member_id_idx ON goals (member_id);

CREATE INDEX goals_metric_id_idx ON goals (metric_id);

CREATE INDEX goals_status_idx ON goals (status);

CREATE INDEX goals_member_status_idx ON goals (member_id, status);

CREATE TABLE IF NOT EXISTS goal_histories (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  goal_id BIGINT NOT NULL,
  recorded_value DOUBLE PRECISION NOT NULL,
  recorded_date DATE NOT NULL,
  notes TEXT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT goal_histories_goal_id_fk FOREIGN KEY (goal_id) REFERENCES goals (id)
);

CREATE INDEX goal_histories_goal_id_idx ON goal_histories (goal_id);

CREATE INDEX goal_histories_recorded_date_idx ON goal_histories (recorded_date);

CREATE TABLE IF NOT EXISTS measurements (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  member_id BIGINT NOT NULL,
  recorded_by_user_id BIGINT NOT NULL,
  recorded_at TIMESTAMPTZ(3) NOT NULL,
  notes TEXT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT measurements_member_id_fk FOREIGN KEY (member_id) REFERENCES members (id),
  CONSTRAINT measurements_recorded_by_user_id_fk FOREIGN KEY (recorded_by_user_id) REFERENCES users (id)
);

CREATE INDEX measurements_member_id_idx ON measurements (member_id);

CREATE INDEX measurements_recorded_at_idx ON measurements (recorded_at);

CREATE INDEX measurements_member_recorded_at_idx ON measurements (member_id, recorded_at);

CREATE TABLE IF NOT EXISTS measurement_values (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  measurement_id BIGINT NOT NULL,
  metric_id BIGINT NOT NULL,
  value DOUBLE PRECISION NOT NULL,
  CONSTRAINT measurement_values_measurement_id_fk FOREIGN KEY (measurement_id) REFERENCES measurements (id),
  CONSTRAINT measurement_values_metric_id_fk FOREIGN KEY (metric_id) REFERENCES goal_metrics (id)
);

CREATE UNIQUE INDEX measurement_values_measurement_metric_unique ON measurement_values (measurement_id, metric_id);

CREATE INDEX measurement_values_metric_id_idx ON measurement_values (metric_id);

CREATE TABLE IF NOT EXISTS progress_photos (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  member_id BIGINT NOT NULL,
  photo_url VARCHAR(512) NOT NULL,
  pose VARCHAR(32) NOT NULL,
  taken_date DATE NOT NULL,
  is_private BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT progress_photos_member_id_fk FOREIGN KEY (member_id) REFERENCES members (id)
);

CREATE INDEX progress_photos_member_id_idx ON progress_photos (member_id);

CREATE INDEX progress_photos_taken_date_idx ON progress_photos (taken_date);

CREATE INDEX progress_photos_member_taken_date_idx ON progress_photos (member_id, taken_date);

CREATE TABLE IF NOT EXISTS progress_notes (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  member_id BIGINT NOT NULL,
  author_user_id BIGINT NOT NULL,
  note_text TEXT NOT NULL,
  note_type VARCHAR(32) NOT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT progress_notes_member_id_fk FOREIGN KEY (member_id) REFERENCES members (id),
  CONSTRAINT progress_notes_author_user_id_fk FOREIGN KEY (author_user_id) REFERENCES users (id)
);

CREATE INDEX progress_notes_member_id_idx ON progress_notes (member_id);

CREATE INDEX progress_notes_author_id_idx ON progress_notes (author_user_id);

CREATE INDEX progress_notes_created_at_idx ON progress_notes (created_at);

CREATE INDEX progress_notes_member_created_at_idx ON progress_notes (member_id, created_at);
