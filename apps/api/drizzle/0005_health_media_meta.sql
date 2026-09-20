-- Hand-authored SQL migration: 0005_health_media_meta.sql
-- Vertical 3: member_health / member_documents / member_photos (URL/key only — FR-API-013)
-- Do NOT create health_conditions or medical_histories (deferred).
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci
-- MariaDB verification hosts: apply manually with utf8mb4_unicode_ci and record
-- __drizzle_migrations (same pattern as 0004_people.sql).

CREATE TABLE IF NOT EXISTS `member_health` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `blood_group` VARCHAR(16) NULL,
  `height_cm` DOUBLE NULL,
  `baseline_weight_kg` DOUBLE NULL,
  `allergies` TEXT NULL,
  `dietary_preferences` TEXT NULL,
  `physician_name` VARCHAR(150) NULL,
  `physician_phone` VARCHAR(32) NULL,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `member_health_member_id_unique` (`member_id`),
  CONSTRAINT `member_health_member_id_members_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `member_documents` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `document_type` ENUM('id_proof', 'waiver', 'medical_cert') NOT NULL,
  `title` VARCHAR(255) NULL,
  `file_url` VARCHAR(1024) NOT NULL,
  `file_size` BIGINT UNSIGNED NULL,
  `verified_by_user_id` BIGINT UNSIGNED NULL,
  `verified_at` DATETIME(3) NULL,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `member_documents_member_id_idx` (`member_id`),
  CONSTRAINT `member_documents_member_id_members_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `member_documents_verified_by_user_id_users_id_fk` FOREIGN KEY (`verified_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `member_photos` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `photo_url` VARCHAR(1024) NOT NULL,
  `is_current_avatar` BOOLEAN NOT NULL DEFAULT FALSE,
  `captured_at` DATETIME(3) NOT NULL,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `member_photos_member_id_idx` (`member_id`),
  CONSTRAINT `member_photos_member_id_members_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
