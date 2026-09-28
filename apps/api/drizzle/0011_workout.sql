-- Hand-authored SQL migration: 0011_workout.sql
-- Vertical 10 WRK: workout_plans, workout_plan_versions, workout_plan_exercises,
-- workout_sessions, workout_session_exercises.
-- Depends on 0002_exercises.sql (exercises), 0004_people.sql (members, trainers).
-- Engine: PostgreSQL 17

CREATE TABLE IF NOT EXISTS workout_plans (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  description TEXT NULL,
  member_id BIGINT NULL,
  trainer_id BIGINT NULL,
  target_goal VARCHAR(64) NULL,
  difficulty VARCHAR(32) NULL,
  duration_weeks INT NULL,
  is_template BOOLEAN NOT NULL DEFAULT FALSE,
  status VARCHAR(16) NOT NULL DEFAULT 'draft',
  row_version INT NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT workout_plans_member_id_fk FOREIGN KEY (member_id) REFERENCES members (id),
  CONSTRAINT workout_plans_trainer_id_fk FOREIGN KEY (trainer_id) REFERENCES trainers (id)
);

CREATE INDEX workout_plans_member_id_idx ON workout_plans (member_id);

CREATE INDEX workout_plans_trainer_id_idx ON workout_plans (trainer_id);

CREATE INDEX workout_plans_status_idx ON workout_plans (status);

CREATE INDEX workout_plans_is_template_idx ON workout_plans (is_template);

-- Replaces the MySQL stored generated column + UNIQUE KEY workaround (ADR-0009; FR-WORK-006/014, FR-DIET-004).
CREATE UNIQUE INDEX workout_plans_active_assigned_member_id_unique ON workout_plans (member_id) WHERE status = 'active' AND is_template = FALSE;

CREATE TABLE IF NOT EXISTS workout_plan_versions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  workout_plan_id BIGINT NOT NULL,
  version_number INT NOT NULL,
  changelog TEXT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT workout_plan_versions_workout_plan_id_fk FOREIGN KEY (workout_plan_id) REFERENCES workout_plans (id)
);

CREATE UNIQUE INDEX workout_plan_versions_plan_id_version_unique ON workout_plan_versions (workout_plan_id, version_number);

CREATE INDEX workout_plan_versions_workout_plan_id_idx ON workout_plan_versions (workout_plan_id);

CREATE TABLE IF NOT EXISTS workout_plan_exercises (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  workout_plan_version_id BIGINT NOT NULL,
  exercise_id BIGINT NOT NULL,
  day_number INT NOT NULL,
  order_index INT NOT NULL,
  target_sets INT NOT NULL DEFAULT 3,
  target_reps VARCHAR(32) NOT NULL DEFAULT '10',
  target_weight_kg NUMERIC(6,2) NULL,
  rest_seconds INT NOT NULL DEFAULT 60,
  notes TEXT NULL,
  CONSTRAINT workout_plan_exercises_version_id_fk FOREIGN KEY (workout_plan_version_id) REFERENCES workout_plan_versions (id),
  CONSTRAINT workout_plan_exercises_exercise_id_fk FOREIGN KEY (exercise_id) REFERENCES exercises (id)
);

CREATE INDEX workout_plan_exercises_version_day_order_idx ON workout_plan_exercises (workout_plan_version_id, day_number, order_index);

CREATE INDEX workout_plan_exercises_exercise_id_idx ON workout_plan_exercises (exercise_id);

CREATE TABLE IF NOT EXISTS workout_sessions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  member_id BIGINT NOT NULL,
  workout_plan_id BIGINT NULL,
  workout_plan_version_id BIGINT NULL,
  trainer_id BIGINT NULL,
  started_at TIMESTAMPTZ(3) NOT NULL,
  completed_at TIMESTAMPTZ(3) NULL,
  total_volume_kg NUMERIC(10,2) NOT NULL DEFAULT '0.00',
  duration_minutes INT NULL,
  client_feedback_rating INT NULL,
  notes TEXT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT workout_sessions_member_id_fk FOREIGN KEY (member_id) REFERENCES members (id),
  CONSTRAINT workout_sessions_workout_plan_id_fk FOREIGN KEY (workout_plan_id) REFERENCES workout_plans (id),
  CONSTRAINT workout_sessions_workout_plan_version_id_fk FOREIGN KEY (workout_plan_version_id) REFERENCES workout_plan_versions (id),
  CONSTRAINT workout_sessions_trainer_id_fk FOREIGN KEY (trainer_id) REFERENCES trainers (id)
);

CREATE INDEX workout_sessions_member_id_idx ON workout_sessions (member_id);

CREATE INDEX workout_sessions_started_at_idx ON workout_sessions (started_at);

-- Replaces the MySQL stored generated column + UNIQUE KEY workaround (ADR-0009; FR-WORK-006/014, FR-DIET-004).
CREATE UNIQUE INDEX workout_sessions_active_session_member_id_unique ON workout_sessions (member_id) WHERE completed_at IS NULL;

CREATE TABLE IF NOT EXISTS workout_session_exercises (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  workout_session_id BIGINT NOT NULL,
  exercise_id BIGINT NOT NULL,
  set_number INT NOT NULL,
  reps_completed INT NOT NULL DEFAULT 0,
  weight_lifted_kg NUMERIC(6,2) NOT NULL DEFAULT '0.00',
  rpe_score NUMERIC(3,1) NULL,
  is_completed BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT workout_session_exercises_session_id_fk FOREIGN KEY (workout_session_id) REFERENCES workout_sessions (id),
  CONSTRAINT workout_session_exercises_exercise_id_fk FOREIGN KEY (exercise_id) REFERENCES exercises (id)
);

CREATE INDEX workout_session_exercises_session_idx ON workout_session_exercises (workout_session_id);

CREATE INDEX workout_session_exercises_exercise_idx ON workout_session_exercises (exercise_id);

CREATE INDEX workout_session_exercises_session_exercise_set_idx ON workout_session_exercises (workout_session_id, exercise_id, set_number);
