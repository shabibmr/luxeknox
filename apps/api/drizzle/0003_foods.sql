-- Hand-authored SQL migration: 0003_foods.sql
-- Vertical 2: Food Library (FR-DIET-001, docs/adr/0007-first-delivery-vertical.md)
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci

CREATE TABLE IF NOT EXISTS `foods` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `serving_unit` VARCHAR(50) NOT NULL,
  `serving_size` DOUBLE NULL,
  `calories` DOUBLE NULL,
  `protein_grams` DOUBLE NULL,
  `carbs_grams` DOUBLE NULL,
  `fat_grams` DOUBLE NULL,
  `fiber_grams` DOUBLE NULL,
  `is_verified` BOOLEAN NOT NULL DEFAULT FALSE,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `foods_is_active_is_verified_idx` (`is_active`, `is_verified`),
  KEY `foods_name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
