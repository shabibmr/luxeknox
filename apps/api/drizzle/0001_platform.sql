-- Hand-authored SQL migration: 0001_platform.sql
-- Module 0 Platform Tables: roles, permissions, role_permissions, users, sessions, gym_settings, audit_logs
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci

CREATE TABLE IF NOT EXISTS `roles` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `slug` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `is_system` BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  CONSTRAINT `roles_slug_unique` UNIQUE (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `permissions` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `module` VARCHAR(50) NOT NULL,
  `action` VARCHAR(50) NOT NULL,
  `slug` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `created_at` DATETIME(3) NOT NULL,
  CONSTRAINT `permissions_slug_unique` UNIQUE (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `role_permissions` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `role_id` BIGINT UNSIGNED NOT NULL,
  `permission_id` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME(3) NOT NULL,
  CONSTRAINT `role_permissions_role_id_roles_id_fk` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `role_permissions_permission_id_permissions_id_fk` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `role_permissions_role_id_permission_id_unique` UNIQUE (`role_id`, `permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `users` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `email` VARCHAR(255) NULL,
  `phone_number` VARCHAR(32) NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `user_type` ENUM('member', 'trainer', 'employee', 'admin') NOT NULL,
  `role_id` BIGINT UNSIGNED NOT NULL,
  `avatar_url` VARCHAR(1024) NULL,
  `status` ENUM('active', 'inactive', 'suspended') NOT NULL DEFAULT 'active',
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  CONSTRAINT `users_role_id_roles_id_fk` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `users_email_unique` UNIQUE (`email`),
  CONSTRAINT `users_phone_number_unique` UNIQUE (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `sessions` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `user_type` ENUM('member', 'trainer', 'employee', 'admin') NOT NULL,
  `profile_id` BIGINT UNSIGNED NULL,
  `family_id` VARCHAR(64) NOT NULL,
  `access_token_hash` VARCHAR(64) NOT NULL,
  `refresh_token_hash` VARCHAR(64) NOT NULL,
  `revoked_at` DATETIME(3) NULL,
  `expires_at` DATETIME(3) NOT NULL,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  CONSTRAINT `sessions_user_id_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX `sessions_access_token_hash_idx` (`access_token_hash`),
  INDEX `sessions_refresh_token_hash_idx` (`refresh_token_hash`),
  INDEX `sessions_family_id_idx` (`family_id`),
  INDEX `sessions_user_id_revoked_at_idx` (`user_id`, `revoked_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `gym_settings` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `setting_key` VARCHAR(100) NOT NULL,
  `setting_value` TEXT NOT NULL,
  `description` VARCHAR(255) NULL,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  CONSTRAINT `gym_settings_setting_key_unique` UNIQUE (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `audit_logs` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `actor_user_id` BIGINT UNSIGNED NULL,
  `action` VARCHAR(100) NOT NULL,
  `entity_name` VARCHAR(100) NOT NULL,
  `entity_id` BIGINT UNSIGNED NULL,
  `before_state` JSON NULL,
  `after_state` JSON NULL,
  `ip_address` VARCHAR(45) NULL,
  `created_at` DATETIME(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
