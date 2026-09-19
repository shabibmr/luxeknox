-- Hand-authored SQL migration: 0002_exercises.sql
-- Vertical 1: Exercise Library (FR-WORK-001, FR-WORK-002, docs/adr/0007-first-delivery-vertical.md)
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci

CREATE TABLE IF NOT EXISTS `exercises` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `primary_muscle_group` VARCHAR(100) NULL,
  `secondary_muscles` JSON NULL,
  `equipment_needed` VARCHAR(150) NULL,
  `instructions` TEXT NULL,
  `video_url` VARCHAR(500) NULL,
  `gif_url` VARCHAR(500) NULL,
  `difficulty_level` VARCHAR(50) NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `exercises_is_active_primary_muscle_group_idx` (`is_active`, `primary_muscle_group`),
  KEY `exercises_name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
