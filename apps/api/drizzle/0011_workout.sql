-- Hand-authored SQL migration: 0011_workout.sql
-- Vertical 10 WRK: workout_plans, workout_plan_versions, workout_plan_exercises,
-- workout_sessions, workout_session_exercises.
-- Depends on 0002_exercises.sql (exercises), 0004_people.sql (members, trainers).
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci

CREATE TABLE IF NOT EXISTS `workout_plans` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(150) NOT NULL,
  `description` TEXT NULL,
  `member_id` BIGINT UNSIGNED NULL,
  `trainer_id` BIGINT UNSIGNED NULL,
  `target_goal` VARCHAR(64) NULL,
  `difficulty` VARCHAR(32) NULL,
  `duration_weeks` INT NULL,
  `is_template` BOOLEAN NOT NULL DEFAULT FALSE,
  `status` VARCHAR(16) NOT NULL DEFAULT 'draft',
  `row_version` INT NOT NULL DEFAULT 1,
  `active_assigned_member_id` BIGINT UNSIGNED GENERATED ALWAYS AS (
    CASE WHEN `status` = 'active' AND `is_template` = FALSE THEN `member_id` ELSE NULL END
  ) STORED,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `workout_plans_member_id_idx` (`member_id`),
  KEY `workout_plans_trainer_id_idx` (`trainer_id`),
  KEY `workout_plans_status_idx` (`status`),
  KEY `workout_plans_is_template_idx` (`is_template`),
  UNIQUE KEY `workout_plans_active_assigned_member_id_unique` (`active_assigned_member_id`),
  CONSTRAINT `workout_plans_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `workout_plans_trainer_id_fk` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `workout_plan_versions` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `workout_plan_id` BIGINT UNSIGNED NOT NULL,
  `version_number` INT NOT NULL,
  `changelog` TEXT NULL,
  `created_at` DATETIME(3) NOT NULL,
  UNIQUE KEY `workout_plan_versions_plan_id_version_unique` (`workout_plan_id`, `version_number`),
  KEY `workout_plan_versions_workout_plan_id_idx` (`workout_plan_id`),
  CONSTRAINT `workout_plan_versions_workout_plan_id_fk` FOREIGN KEY (`workout_plan_id`) REFERENCES `workout_plans` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `workout_plan_exercises` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `workout_plan_version_id` BIGINT UNSIGNED NOT NULL,
  `exercise_id` BIGINT UNSIGNED NOT NULL,
  `day_number` INT NOT NULL,
  `order_index` INT NOT NULL,
  `target_sets` INT NOT NULL DEFAULT 3,
  `target_reps` VARCHAR(32) NOT NULL DEFAULT '10',
  `target_weight_kg` DECIMAL(6,2) NULL,
  `rest_seconds` INT NOT NULL DEFAULT 60,
  `notes` TEXT NULL,
  KEY `workout_plan_exercises_version_day_order_idx` (`workout_plan_version_id`, `day_number`, `order_index`),
  KEY `workout_plan_exercises_exercise_id_idx` (`exercise_id`),
  CONSTRAINT `workout_plan_exercises_version_id_fk` FOREIGN KEY (`workout_plan_version_id`) REFERENCES `workout_plan_versions` (`id`),
  CONSTRAINT `workout_plan_exercises_exercise_id_fk` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `workout_sessions` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `workout_plan_id` BIGINT UNSIGNED NULL,
  `workout_plan_version_id` BIGINT UNSIGNED NULL,
  `trainer_id` BIGINT UNSIGNED NULL,
  `started_at` DATETIME(3) NOT NULL,
  `completed_at` DATETIME(3) NULL,
  `total_volume_kg` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  `duration_minutes` INT NULL,
  `client_feedback_rating` INT NULL,
  `notes` TEXT NULL,
  `active_session_member_id` BIGINT UNSIGNED GENERATED ALWAYS AS (
    CASE WHEN `completed_at` IS NULL THEN `member_id` ELSE NULL END
  ) STORED,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `workout_sessions_member_id_idx` (`member_id`),
  KEY `workout_sessions_started_at_idx` (`started_at`),
  UNIQUE KEY `workout_sessions_active_session_member_id_unique` (`active_session_member_id`),
  CONSTRAINT `workout_sessions_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `workout_sessions_workout_plan_id_fk` FOREIGN KEY (`workout_plan_id`) REFERENCES `workout_plans` (`id`),
  CONSTRAINT `workout_sessions_workout_plan_version_id_fk` FOREIGN KEY (`workout_plan_version_id`) REFERENCES `workout_plan_versions` (`id`),
  CONSTRAINT `workout_sessions_trainer_id_fk` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `workout_session_exercises` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `workout_session_id` BIGINT UNSIGNED NOT NULL,
  `exercise_id` BIGINT UNSIGNED NOT NULL,
  `set_number` INT NOT NULL,
  `reps_completed` INT NOT NULL DEFAULT 0,
  `weight_lifted_kg` DECIMAL(6,2) NOT NULL DEFAULT '0.00',
  `rpe_score` DECIMAL(3,1) NULL,
  `is_completed` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  KEY `workout_session_exercises_session_idx` (`workout_session_id`),
  KEY `workout_session_exercises_exercise_idx` (`exercise_id`),
  KEY `workout_session_exercises_session_exercise_set_idx` (`workout_session_id`, `exercise_id`, `set_number`),
  CONSTRAINT `workout_session_exercises_session_id_fk` FOREIGN KEY (`workout_session_id`) REFERENCES `workout_sessions` (`id`),
  CONSTRAINT `workout_session_exercises_exercise_id_fk` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
