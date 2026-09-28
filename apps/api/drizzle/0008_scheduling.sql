-- Hand-authored SQL migration: 0008_scheduling.sql
-- Vertical 07 SCHED: schedule_types, facilities, schedules, schedule_participants,
-- trainer_availabilities, schedule_histories.
-- Depends on 0005_people.sql (trainers, members), 0001_platform.sql (users).
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci

CREATE TABLE IF NOT EXISTS `schedule_types` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `color_code` VARCHAR(16) NULL,
  `default_duration_minutes` INT NOT NULL DEFAULT 60,
  `requires_trainer` BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `schedule_types_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `facilities` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `capacity` INT NOT NULL DEFAULT 1,
  `location_details` TEXT NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `facilities_name_unique` (`name`),
  KEY `facilities_is_active_idx` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `schedules` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `series_id` BIGINT UNSIGNED NULL,
  `schedule_type_id` BIGINT UNSIGNED NOT NULL,
  `facility_id` BIGINT UNSIGNED NULL,
  `trainer_id` BIGINT UNSIGNED NULL,
  `title` VARCHAR(255) NOT NULL,
  `start_time` DATETIME(3) NOT NULL,
  `end_time` DATETIME(3) NOT NULL,
  `max_capacity` INT NOT NULL DEFAULT 1,
  `status` VARCHAR(16) NOT NULL DEFAULT 'scheduled',
  `notes` TEXT NULL,
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `schedules_start_time_idx` (`start_time`),
  KEY `schedules_end_time_idx` (`end_time`),
  KEY `schedules_trainer_id_start_idx` (`trainer_id`, `start_time`),
  KEY `schedules_facility_id_start_idx` (`facility_id`, `start_time`),
  KEY `schedules_series_id_idx` (`series_id`),
  KEY `schedules_status_idx` (`status`),
  KEY `schedules_type_id_idx` (`schedule_type_id`),
  CONSTRAINT `schedules_schedule_type_id_fk` FOREIGN KEY (`schedule_type_id`) REFERENCES `schedule_types` (`id`),
  CONSTRAINT `schedules_facility_id_fk` FOREIGN KEY (`facility_id`) REFERENCES `facilities` (`id`),
  CONSTRAINT `schedules_trainer_id_fk` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `schedule_participants` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `schedule_id` BIGINT UNSIGNED NOT NULL,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `booking_status` VARCHAR(16) NOT NULL DEFAULT 'booked',
  `attended` BOOLEAN NULL,
  `booked_at` DATETIME(3) NOT NULL,
  `marked_at` DATETIME(3) NULL,
  UNIQUE KEY `schedule_participants_schedule_member_unique` (`schedule_id`, `member_id`),
  KEY `schedule_participants_member_id_idx` (`member_id`),
  KEY `schedule_participants_schedule_id_idx` (`schedule_id`),
  CONSTRAINT `schedule_participants_schedule_id_fk` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`),
  CONSTRAINT `schedule_participants_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `trainer_availabilities` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `trainer_id` BIGINT UNSIGNED NOT NULL,
  `day_of_week` TINYINT UNSIGNED NULL,
  `start_time` VARCHAR(8) NOT NULL,
  `end_time` VARCHAR(8) NOT NULL,
  `is_recurring` BOOLEAN NOT NULL DEFAULT TRUE,
  `override_date` DATE NULL,
  `is_available` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `trainer_availabilities_trainer_id_idx` (`trainer_id`),
  KEY `trainer_availabilities_trainer_day_idx` (`trainer_id`, `day_of_week`),
  KEY `trainer_availabilities_trainer_override_idx` (`trainer_id`, `override_date`),
  CONSTRAINT `trainer_availabilities_trainer_id_fk` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `schedule_histories` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `schedule_id` BIGINT UNSIGNED NOT NULL,
  `action` VARCHAR(32) NOT NULL,
  `changed_by_user_id` BIGINT UNSIGNED NOT NULL,
  `notes` TEXT NULL,
  `timestamp` DATETIME(3) NOT NULL,
  KEY `schedule_histories_schedule_id_idx` (`schedule_id`),
  CONSTRAINT `schedule_histories_schedule_id_fk` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`),
  CONSTRAINT `schedule_histories_changed_by_user_id_fk` FOREIGN KEY (`changed_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
