-- Hand-authored SQL migration: 0006_memberships.sql
-- Vertical 4: Memberships & products (MEMB) — membership_products, memberships,
-- membership_freezes, membership_extensions, membership_histories.
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci

CREATE TABLE IF NOT EXISTS `membership_products` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `code` VARCHAR(32) NOT NULL,
  `description` TEXT NULL,
  `duration_days` INT NOT NULL,
  `base_price` DECIMAL(10,2) NOT NULL,
  `tax_percentage` DECIMAL(5,2) NOT NULL DEFAULT '0.00',
  `max_freeze_days` INT NOT NULL DEFAULT 0,
  `pt_sessions_included` INT NOT NULL DEFAULT 0,
  `access_facilities` JSON NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `membership_products_code_unique` (`code`),
  KEY `membership_products_is_active_idx` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `memberships` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `remaining_pt_sessions` INT NOT NULL DEFAULT 0,
  `status` VARCHAR(16) NOT NULL DEFAULT 'active',
  `locker_number` VARCHAR(16) NULL,
  `auto_renew` BOOLEAN NOT NULL DEFAULT FALSE,
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `memberships_member_id_idx` (`member_id`),
  KEY `memberships_status_idx` (`status`),
  KEY `memberships_end_date_idx` (`end_date`),
  KEY `memberships_locker_number_idx` (`locker_number`),
  CONSTRAINT `memberships_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `memberships_product_id_fk` FOREIGN KEY (`product_id`) REFERENCES `membership_products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `membership_freezes` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `membership_id` BIGINT UNSIGNED NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `total_freeze_days` INT NOT NULL,
  `reason` TEXT NULL,
  `status` VARCHAR(16) NOT NULL DEFAULT 'pending',
  `reviewed_by_user_id` BIGINT UNSIGNED NULL,
  `reviewed_at` DATETIME(3) NULL,
  `created_at` DATETIME(3) NOT NULL,
  KEY `membership_freezes_membership_id_idx` (`membership_id`),
  KEY `membership_freezes_status_idx` (`status`),
  CONSTRAINT `membership_freezes_membership_id_fk` FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`id`),
  CONSTRAINT `membership_freezes_reviewed_by_user_id_fk` FOREIGN KEY (`reviewed_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `membership_extensions` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `membership_id` BIGINT UNSIGNED NOT NULL,
  `days_extended` INT NOT NULL,
  `reason` TEXT NULL,
  `granted_by_user_id` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME(3) NOT NULL,
  KEY `membership_extensions_membership_id_idx` (`membership_id`),
  CONSTRAINT `membership_extensions_membership_id_fk` FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`id`),
  CONSTRAINT `membership_extensions_granted_by_user_id_fk` FOREIGN KEY (`granted_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `membership_histories` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `membership_id` BIGINT UNSIGNED NOT NULL,
  `action` VARCHAR(16) NOT NULL,
  `old_end_date` DATE NULL,
  `new_end_date` DATE NULL,
  `performed_by_user_id` BIGINT UNSIGNED NOT NULL,
  `timestamp` DATETIME(3) NOT NULL,
  KEY `membership_histories_membership_id_idx` (`membership_id`),
  CONSTRAINT `membership_histories_membership_id_fk` FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`id`),
  CONSTRAINT `membership_histories_performed_by_user_id_fk` FOREIGN KEY (`performed_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
