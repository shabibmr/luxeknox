-- Hand-authored SQL migration: 0020_personal_training.sql
-- Personal Training (PT) packages, subscriptions, and trainer/slot change audit.
-- A PT subscription pins one same-gender trainer to a fixed recurring 1-hour slot
-- (chosen weekdays) for the package duration; each occurrence is materialised as a
-- `schedules` row linked back via `schedules.pt_subscription_id`.
-- Depends on 0004_people.sql, 0006_memberships.sql, 0008_scheduling.sql, 0015_payments.sql.
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci

CREATE TABLE IF NOT EXISTS `pt_products` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `code` VARCHAR(32) NOT NULL,
  `description` TEXT NULL,
  `duration_days` INT NOT NULL,
  `sessions_per_week` TINYINT UNSIGNED NOT NULL,
  `base_price` DECIMAL(10,2) NOT NULL,
  `tax_percentage` DECIMAL(5,2) NOT NULL DEFAULT '0.00',
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `pt_products_code_unique` (`code`),
  KEY `pt_products_is_active_idx` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `pt_subscriptions` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `pt_product_id` BIGINT UNSIGNED NOT NULL,
  `trainer_id` BIGINT UNSIGNED NOT NULL,
  `membership_id` BIGINT UNSIGNED NULL,
  `renewed_from_id` BIGINT UNSIGNED NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `weekdays` JSON NOT NULL,
  `slot_start` VARCHAR(8) NOT NULL,
  `status` VARCHAR(16) NOT NULL DEFAULT 'scheduled',
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `pt_subscriptions_member_id_idx` (`member_id`),
  KEY `pt_subscriptions_trainer_id_idx` (`trainer_id`),
  KEY `pt_subscriptions_status_idx` (`status`),
  KEY `pt_subscriptions_end_date_idx` (`end_date`),
  CONSTRAINT `pt_subscriptions_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `pt_subscriptions_pt_product_id_fk` FOREIGN KEY (`pt_product_id`) REFERENCES `pt_products` (`id`),
  CONSTRAINT `pt_subscriptions_trainer_id_fk` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`id`),
  CONSTRAINT `pt_subscriptions_membership_id_fk` FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`id`),
  CONSTRAINT `pt_subscriptions_renewed_from_id_fk` FOREIGN KEY (`renewed_from_id`) REFERENCES `pt_subscriptions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `pt_subscription_changes` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `pt_subscription_id` BIGINT UNSIGNED NOT NULL,
  `change_type` VARCHAR(16) NOT NULL,
  `effective_date` DATE NOT NULL,
  `old_trainer_id` BIGINT UNSIGNED NULL,
  `new_trainer_id` BIGINT UNSIGNED NULL,
  `old_weekdays` JSON NULL,
  `new_weekdays` JSON NULL,
  `old_slot_start` VARCHAR(8) NULL,
  `new_slot_start` VARCHAR(8) NULL,
  `reason` TEXT NULL,
  `changed_by_user_id` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME(3) NOT NULL,
  KEY `pt_subscription_changes_subscription_idx` (`pt_subscription_id`),
  CONSTRAINT `pt_subscription_changes_subscription_fk` FOREIGN KEY (`pt_subscription_id`) REFERENCES `pt_subscriptions` (`id`),
  CONSTRAINT `pt_subscription_changes_user_fk` FOREIGN KEY (`changed_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE `payments`
  ADD COLUMN `pt_subscription_id` BIGINT UNSIGNED NULL AFTER `membership_id`,
  ADD KEY `payments_pt_subscription_id_idx` (`pt_subscription_id`),
  ADD CONSTRAINT `payments_pt_subscription_id_fk` FOREIGN KEY (`pt_subscription_id`) REFERENCES `pt_subscriptions` (`id`);

ALTER TABLE `schedules`
  ADD COLUMN `pt_subscription_id` BIGINT UNSIGNED NULL AFTER `series_id`,
  ADD KEY `schedules_pt_subscription_id_idx` (`pt_subscription_id`),
  ADD CONSTRAINT `schedules_pt_subscription_id_fk` FOREIGN KEY (`pt_subscription_id`) REFERENCES `pt_subscriptions` (`id`);

INSERT IGNORE INTO `schedule_types` (`name`, `color_code`, `default_duration_minutes`, `requires_trainer`, `created_at`)
VALUES ('Personal Training', '#C9A227', 60, TRUE, UTC_TIMESTAMP(3));
