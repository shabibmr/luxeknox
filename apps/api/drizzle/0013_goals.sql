-- Hand-authored SQL migration: 0013_goals.sql
-- Vertical 12 GOAL: goal_metrics, goals, goal_histories, measurements,
-- measurement_values, progress_photos, progress_notes.
-- Depends on 0004_people.sql (members, users).
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci

CREATE TABLE IF NOT EXISTS `goal_metrics` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `unit_of_measure` VARCHAR(32) NOT NULL,
  `category` VARCHAR(64) NOT NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `goal_metrics_category_idx` (`category`),
  KEY `goal_metrics_is_active_idx` (`is_active`),
  KEY `goal_metrics_name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `goals` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `metric_id` BIGINT UNSIGNED NOT NULL,
  `baseline_value` DOUBLE NOT NULL,
  `target_value` DOUBLE NOT NULL,
  `current_value` DOUBLE NOT NULL,
  `start_date` DATE NOT NULL,
  `target_date` DATE NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'in_progress',
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `goals_member_id_idx` (`member_id`),
  KEY `goals_metric_id_idx` (`metric_id`),
  KEY `goals_status_idx` (`status`),
  KEY `goals_member_status_idx` (`member_id`, `status`),
  CONSTRAINT `goals_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `goals_metric_id_fk` FOREIGN KEY (`metric_id`) REFERENCES `goal_metrics` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `goal_histories` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `goal_id` BIGINT UNSIGNED NOT NULL,
  `recorded_value` DOUBLE NOT NULL,
  `recorded_date` DATE NOT NULL,
  `notes` TEXT NULL,
  `created_at` DATETIME(3) NOT NULL,
  KEY `goal_histories_goal_id_idx` (`goal_id`),
  KEY `goal_histories_recorded_date_idx` (`recorded_date`),
  CONSTRAINT `goal_histories_goal_id_fk` FOREIGN KEY (`goal_id`) REFERENCES `goals` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `measurements` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `recorded_by_user_id` BIGINT UNSIGNED NOT NULL,
  `recorded_at` DATETIME(3) NOT NULL,
  `notes` TEXT NULL,
  `created_at` DATETIME(3) NOT NULL,
  KEY `measurements_member_id_idx` (`member_id`),
  KEY `measurements_recorded_at_idx` (`recorded_at`),
  KEY `measurements_member_recorded_at_idx` (`member_id`, `recorded_at`),
  CONSTRAINT `measurements_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `measurements_recorded_by_user_id_fk` FOREIGN KEY (`recorded_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `measurement_values` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `measurement_id` BIGINT UNSIGNED NOT NULL,
  `metric_id` BIGINT UNSIGNED NOT NULL,
  `value` DOUBLE NOT NULL,
  UNIQUE KEY `measurement_values_measurement_metric_unique` (`measurement_id`, `metric_id`),
  KEY `measurement_values_metric_id_idx` (`metric_id`),
  CONSTRAINT `measurement_values_measurement_id_fk` FOREIGN KEY (`measurement_id`) REFERENCES `measurements` (`id`),
  CONSTRAINT `measurement_values_metric_id_fk` FOREIGN KEY (`metric_id`) REFERENCES `goal_metrics` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `progress_photos` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `photo_url` VARCHAR(512) NOT NULL,
  `pose` VARCHAR(32) NOT NULL,
  `taken_date` DATE NOT NULL,
  `is_private` BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` DATETIME(3) NOT NULL,
  KEY `progress_photos_member_id_idx` (`member_id`),
  KEY `progress_photos_taken_date_idx` (`taken_date`),
  KEY `progress_photos_member_taken_date_idx` (`member_id`, `taken_date`),
  CONSTRAINT `progress_photos_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `progress_notes` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `author_user_id` BIGINT UNSIGNED NOT NULL,
  `note_text` TEXT NOT NULL,
  `note_type` VARCHAR(32) NOT NULL,
  `created_at` DATETIME(3) NOT NULL,
  KEY `progress_notes_member_id_idx` (`member_id`),
  KEY `progress_notes_author_id_idx` (`author_user_id`),
  KEY `progress_notes_created_at_idx` (`created_at`),
  KEY `progress_notes_member_created_at_idx` (`member_id`, `created_at`),
  CONSTRAINT `progress_notes_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `progress_notes_author_user_id_fk` FOREIGN KEY (`author_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
