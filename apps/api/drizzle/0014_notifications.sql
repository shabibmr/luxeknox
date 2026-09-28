-- Hand-authored SQL migration: 0014_notifications.sql
-- Vertical 13 NOTIF: notification_types, notifications, user_devices, notification_deliveries.
-- Depends on 0001_platform.sql (roles) and 0004_people.sql (users).
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci

CREATE TABLE IF NOT EXISTS `notification_types` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `type_code` VARCHAR(64) NOT NULL,
  `template_text` TEXT NOT NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `notification_types_type_code_unique` (`type_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `notifications` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `notification_type_id` BIGINT UNSIGNED NULL,
  `title` VARCHAR(255) NOT NULL,
  `message` TEXT NOT NULL,
  `data_payload` JSON NULL,
  `sender_user_id` BIGINT UNSIGNED NULL,
  `is_broadcast` BOOLEAN NOT NULL DEFAULT FALSE,
  `broadcast_audience` ENUM('all_members', 'assigned_clients', 'role') NULL,
  `created_at` DATETIME(3) NOT NULL,
  KEY `notifications_sender_user_id_idx` (`sender_user_id`),
  KEY `notifications_notification_type_id_idx` (`notification_type_id`),
  KEY `notifications_is_broadcast_created_at_idx` (`is_broadcast`, `created_at`),
  CONSTRAINT `notifications_notification_type_id_fk` FOREIGN KEY (`notification_type_id`) REFERENCES `notification_types` (`id`),
  CONSTRAINT `notifications_sender_user_id_fk` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `user_devices` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `device_token` VARCHAR(512) NOT NULL,
  `device_platform` ENUM('ios', 'android', 'web') NOT NULL,
  `last_active_at` DATETIME(3) NOT NULL,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `user_devices_token_unique` (`device_token`),
  KEY `user_devices_user_id_idx` (`user_id`),
  CONSTRAINT `user_devices_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `notification_deliveries` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `notification_id` BIGINT UNSIGNED NOT NULL,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `status` ENUM('pending', 'sent', 'failed') NOT NULL DEFAULT 'pending',
  `failure_reason` TEXT NULL,
  `retry_count` BIGINT NOT NULL DEFAULT 0,
  `is_read` BOOLEAN NOT NULL DEFAULT FALSE,
  `read_at` DATETIME(3) NULL,
  `delivered_at` DATETIME(3) NULL,
  `created_at` DATETIME(3) NOT NULL,
  UNIQUE KEY `notification_deliveries_notif_user_unique` (`notification_id`, `user_id`),
  KEY `notification_deliveries_user_read_created_idx` (`user_id`, `is_read`, `created_at`),
  KEY `notification_deliveries_status_retry_idx` (`status`, `retry_count`),
  CONSTRAINT `notification_deliveries_notification_id_fk` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`),
  CONSTRAINT `notification_deliveries_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
