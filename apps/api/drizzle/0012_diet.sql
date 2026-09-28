-- Hand-authored SQL migration: 0012_diet.sql
-- Vertical 11 DIT: diet_plans, diet_plan_versions, diet_plan_meals,
-- diet_plan_foods, diet_histories.
-- Depends on 0002_foods.sql (foods), 0004_people.sql (members, trainers).
-- Engine: PostgreSQL 17

CREATE TABLE IF NOT EXISTS diet_plans (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  description TEXT NULL,
  member_id BIGINT NULL,
  trainer_id BIGINT NULL,
  daily_calorie_target INT NULL,
  protein_target_g DOUBLE PRECISION NULL,
  carbs_target_g DOUBLE PRECISION NULL,
  fat_target_g DOUBLE PRECISION NULL,
  is_template BOOLEAN NOT NULL DEFAULT FALSE,
  status VARCHAR(16) NOT NULL DEFAULT 'draft',
  row_version INT NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT diet_plans_member_id_fk FOREIGN KEY (member_id) REFERENCES members (id),
  CONSTRAINT diet_plans_trainer_id_fk FOREIGN KEY (trainer_id) REFERENCES trainers (id)
);

CREATE INDEX diet_plans_member_id_idx ON diet_plans (member_id);

CREATE INDEX diet_plans_trainer_id_idx ON diet_plans (trainer_id);

CREATE INDEX diet_plans_status_idx ON diet_plans (status);

CREATE INDEX diet_plans_is_template_idx ON diet_plans (is_template);

-- Replaces the MySQL stored generated column + UNIQUE KEY workaround (ADR-0009; FR-WORK-006/014, FR-DIET-004).
CREATE UNIQUE INDEX diet_plans_active_assigned_member_id_unique ON diet_plans (member_id) WHERE status = 'active' AND is_template = FALSE;

CREATE TABLE IF NOT EXISTS diet_plan_versions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  diet_plan_id BIGINT NOT NULL,
  version_number INT NOT NULL,
  changelog TEXT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT diet_plan_versions_diet_plan_id_fk FOREIGN KEY (diet_plan_id) REFERENCES diet_plans (id)
);

CREATE UNIQUE INDEX diet_plan_versions_plan_id_version_unique ON diet_plan_versions (diet_plan_id, version_number);

CREATE INDEX diet_plan_versions_diet_plan_id_idx ON diet_plan_versions (diet_plan_id);

CREATE TABLE IF NOT EXISTS diet_plan_meals (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  diet_plan_version_id BIGINT NOT NULL,
  meal_name VARCHAR(100) NOT NULL,
  scheduled_time VARCHAR(16) NULL,
  target_calories INT NULL,
  notes TEXT NULL,
  order_index INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT diet_plan_meals_version_id_fk FOREIGN KEY (diet_plan_version_id) REFERENCES diet_plan_versions (id)
);

CREATE INDEX diet_plan_meals_version_idx ON diet_plan_meals (diet_plan_version_id);

CREATE INDEX diet_plan_meals_version_order_idx ON diet_plan_meals (diet_plan_version_id, order_index);

CREATE TABLE IF NOT EXISTS diet_plan_foods (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  diet_plan_meal_id BIGINT NOT NULL,
  food_id BIGINT NOT NULL,
  quantity DOUBLE PRECISION NOT NULL,
  serving_unit VARCHAR(50) NULL,
  order_index INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ(3) NOT NULL,
  CONSTRAINT diet_plan_foods_meal_id_fk FOREIGN KEY (diet_plan_meal_id) REFERENCES diet_plan_meals (id),
  CONSTRAINT diet_plan_foods_food_id_fk FOREIGN KEY (food_id) REFERENCES foods (id)
);

CREATE INDEX diet_plan_foods_meal_idx ON diet_plan_foods (diet_plan_meal_id);

CREATE INDEX diet_plan_foods_food_idx ON diet_plan_foods (food_id);

CREATE TABLE IF NOT EXISTS diet_histories (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  member_id BIGINT NOT NULL,
  diet_plan_id BIGINT NULL,
  logged_date DATE NOT NULL,
  total_calories_consumed DOUBLE PRECISION NOT NULL DEFAULT 0,
  adherence_score DOUBLE PRECISION NULL,
  water_intake_ml INT NULL,
  member_notes TEXT NULL,
  created_at TIMESTAMPTZ(3) NOT NULL,
  updated_at TIMESTAMPTZ(3) NULL,
  CONSTRAINT diet_histories_member_id_fk FOREIGN KEY (member_id) REFERENCES members (id),
  CONSTRAINT diet_histories_diet_plan_id_fk FOREIGN KEY (diet_plan_id) REFERENCES diet_plans (id)
);

CREATE INDEX diet_histories_member_id_idx ON diet_histories (member_id);

CREATE INDEX diet_histories_logged_date_idx ON diet_histories (logged_date);

CREATE UNIQUE INDEX diet_histories_member_logged_date_unique ON diet_histories (member_id, logged_date);
