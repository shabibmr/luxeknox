-- Hand-authored SQL migration: 0008_scheduling.sql
-- Vertical 07 SCHED: schedule_types, facilities, schedules, schedule_participants,
-- trainer_availabilities, schedule_histories.
-- Depends on 0005_people.sql (trainers, members), 0001_platform.sql (users).
-- Engine: PostgreSQL 17

CREATE TABLE IF NOT EXISTS schedule_types (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  color_code VARCHAR(16) NULL,
  default_duration_minutes INT NOT NULL DEFAULT 60,
  requires_trainer BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL
);

CREATE UNIQUE INDEX schedule_types_name_unique ON schedule_types (name);

CREATE TABLE IF NOT EXISTS facilities (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  capacity INT NOT NULL DEFAULT 1,
  location_details TEXT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL
);

CREATE UNIQUE INDEX facilities_name_unique ON facilities (name);

CREATE INDEX facilities_is_active_idx ON facilities (is_active);

CREATE TABLE IF NOT EXISTS schedules (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  series_id BIGINT NULL,
  schedule_type_id BIGINT NOT NULL,
  facility_id BIGINT NULL,
  trainer_id BIGINT NULL,
  title VARCHAR(255) NOT NULL,
  start_time TIMESTAMPTZ(3) NOT NULL,
  end_time TIMESTAMPTZ(3) NOT NULL,
  max_capacity INT NOT NULL DEFAULT 1,
  status VARCHAR(16) NOT NULL DEFAULT 'scheduled',
  notes TEXT NULL,
  row_version INT NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT schedules_schedule_type_id_fk FOREIGN KEY (schedule_type_id) REFERENCES schedule_types (id),
  CONSTRAINT schedules_facility_id_fk FOREIGN KEY (facility_id) REFERENCES facilities (id),
  CONSTRAINT schedules_trainer_id_fk FOREIGN KEY (trainer_id) REFERENCES trainers (id)
);

CREATE INDEX schedules_start_time_idx ON schedules (start_time);

CREATE INDEX schedules_end_time_idx ON schedules (end_time);

CREATE INDEX schedules_trainer_id_start_idx ON schedules (trainer_id, start_time);

CREATE INDEX schedules_facility_id_start_idx ON schedules (facility_id, start_time);

CREATE INDEX schedules_series_id_idx ON schedules (series_id);

CREATE INDEX schedules_status_idx ON schedules (status);

CREATE INDEX schedules_type_id_idx ON schedules (schedule_type_id);

CREATE TABLE IF NOT EXISTS schedule_participants (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  schedule_id BIGINT NOT NULL,
  member_id BIGINT NOT NULL,
  booking_status VARCHAR(16) NOT NULL DEFAULT 'booked',
  attended BOOLEAN NULL,
  booked_at TIMESTAMPTZ(3) NOT NULL,
  marked_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT schedule_participants_schedule_id_fk FOREIGN KEY (schedule_id) REFERENCES schedules (id),
  CONSTRAINT schedule_participants_member_id_fk FOREIGN KEY (member_id) REFERENCES members (id)
);

CREATE UNIQUE INDEX schedule_participants_schedule_member_unique ON schedule_participants (schedule_id, member_id);

CREATE INDEX schedule_participants_member_id_idx ON schedule_participants (member_id);

CREATE INDEX schedule_participants_schedule_id_idx ON schedule_participants (schedule_id);

CREATE TABLE IF NOT EXISTS trainer_availabilities (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  trainer_id BIGINT NOT NULL,
  day_of_week SMALLINT NULL,
  start_time VARCHAR(8) NOT NULL,
  end_time VARCHAR(8) NOT NULL,
  is_recurring BOOLEAN NOT NULL DEFAULT TRUE,
  override_date DATE NULL,
  is_available BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT trainer_availabilities_trainer_id_fk FOREIGN KEY (trainer_id) REFERENCES trainers (id),
  CONSTRAINT trainer_availabilities_day_of_week_check CHECK (day_of_week >= 0)
);

CREATE INDEX trainer_availabilities_trainer_id_idx ON trainer_availabilities (trainer_id);

CREATE INDEX trainer_availabilities_trainer_day_idx ON trainer_availabilities (trainer_id, day_of_week);

CREATE INDEX trainer_availabilities_trainer_override_idx ON trainer_availabilities (trainer_id, override_date);

CREATE TABLE IF NOT EXISTS schedule_histories (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  schedule_id BIGINT NOT NULL,
  action VARCHAR(32) NOT NULL,
  changed_by_user_id BIGINT NOT NULL,
  notes TEXT NULL,
  timestamp TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT schedule_histories_schedule_id_fk FOREIGN KEY (schedule_id) REFERENCES schedules (id),
  CONSTRAINT schedule_histories_changed_by_user_id_fk FOREIGN KEY (changed_by_user_id) REFERENCES users (id)
);

CREATE INDEX schedule_histories_schedule_id_idx ON schedule_histories (schedule_id);
