-- Hand-authored SQL migration: 0004_people.sql
-- Vertical 3: PEOPLE profiles (members / trainers / employees) + emergency_contacts
-- + membership_number_counters (MariaDB-safe FOR UPDATE allocation).
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci
-- MariaDB verification hosts: apply manually with utf8mb4_unicode_ci and record
-- __drizzle_migrations (same pattern as 0003_foods.sql).

CREATE TABLE IF NOT EXISTS `trainers` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `bio` TEXT NULL,
  `specializations` JSON NULL,
  `hourly_rate` DECIMAL(12, 2) NULL,
  `rating` DOUBLE NULL,
  `max_clients_capacity` BIGINT UNSIGNED NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `trainers_user_id_unique` (`user_id`),
  CONSTRAINT `trainers_user_id_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `employees` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `job_title` VARCHAR(150) NOT NULL,
  `department` VARCHAR(150) NULL,
  `hire_date` DATE NULL,
  `status` ENUM('active', 'on_probation', 'suspended', 'terminated') NOT NULL DEFAULT 'active',
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `employees_user_id_unique` (`user_id`),
  CONSTRAINT `employees_user_id_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `members` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `membership_number` VARCHAR(16) NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `gender` VARCHAR(32) NULL,
  `date_of_birth` DATE NULL,
  `address` TEXT NULL,
  `assigned_trainer_id` BIGINT UNSIGNED NULL,
  `joined_date` DATE NOT NULL,
  `notes` TEXT NULL,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `members_user_id_unique` (`user_id`),
  UNIQUE KEY `members_membership_number_unique` (`membership_number`),
  KEY `members_assigned_trainer_id_idx` (`assigned_trainer_id`),
  CONSTRAINT `members_user_id_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `members_assigned_trainer_id_trainers_id_fk` FOREIGN KEY (`assigned_trainer_id`) REFERENCES `trainers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Single-row counter: allocate with SELECT … FOR UPDATE inside person-create TX,
-- then format membership_number as 'M' + LPAD(next_value, 8, '0').
CREATE TABLE IF NOT EXISTS `membership_number_counters` (
  `id` BIGINT UNSIGNED PRIMARY KEY,
  `next_value` BIGINT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `membership_number_counters` (`id`, `next_value`)
VALUES (1, 1)
ON DUPLICATE KEY UPDATE `id` = `id`;

CREATE TABLE IF NOT EXISTS `emergency_contacts` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `contact_name` VARCHAR(150) NOT NULL,
  `relationship` VARCHAR(100) NULL,
  `phone_primary` VARCHAR(32) NOT NULL,
  `phone_secondary` VARCHAR(32) NULL,
  `is_primary` BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `emergency_contacts_user_id_idx` (`user_id`),
  CONSTRAINT `emergency_contacts_user_id_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
