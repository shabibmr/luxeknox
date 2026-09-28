-- Hand-authored SQL migration: 0012_diet.sql
-- Vertical 11 DIT: diet_plans, diet_plan_versions, diet_plan_meals,
-- diet_plan_foods, diet_histories.
-- Depends on 0002_foods.sql (foods), 0004_people.sql (members, trainers).
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci

CREATE TABLE IF NOT EXISTS `diet_plans` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(150) NOT NULL,
  `description` TEXT NULL,
  `member_id` BIGINT UNSIGNED NULL,
  `trainer_id` BIGINT UNSIGNED NULL,
  `daily_calorie_target` INT NULL,
  `protein_target_g` DOUBLE NULL,
  `carbs_target_g` DOUBLE NULL,
  `fat_target_g` DOUBLE NULL,
  `is_template` BOOLEAN NOT NULL DEFAULT FALSE,
  `status` VARCHAR(16) NOT NULL DEFAULT 'draft',
  `row_version` INT NOT NULL DEFAULT 1,
  `active_assigned_member_id` BIGINT UNSIGNED GENERATED ALWAYS AS (
    CASE WHEN `status` = 'active' AND `is_template` = FALSE THEN `member_id` ELSE NULL END
  ) STORED,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `diet_plans_member_id_idx` (`member_id`),
  KEY `diet_plans_trainer_id_idx` (`trainer_id`),
  KEY `diet_plans_status_idx` (`status`),
  KEY `diet_plans_is_template_idx` (`is_template`),
  UNIQUE KEY `diet_plans_active_assigned_member_id_unique` (`active_assigned_member_id`),
  CONSTRAINT `diet_plans_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `diet_plans_trainer_id_fk` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `diet_plan_versions` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `diet_plan_id` BIGINT UNSIGNED NOT NULL,
  `version_number` INT NOT NULL,
  `changelog` TEXT NULL,
  `created_at` DATETIME(3) NOT NULL,
  UNIQUE KEY `diet_plan_versions_plan_id_version_unique` (`diet_plan_id`, `version_number`),
  KEY `diet_plan_versions_diet_plan_id_idx` (`diet_plan_id`),
  CONSTRAINT `diet_plan_versions_diet_plan_id_fk` FOREIGN KEY (`diet_plan_id`) REFERENCES `diet_plans` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `diet_plan_meals` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `diet_plan_version_id` BIGINT UNSIGNED NOT NULL,
  `meal_name` VARCHAR(100) NOT NULL,
  `scheduled_time` VARCHAR(16) NULL,
  `target_calories` INT NULL,
  `notes` TEXT NULL,
  `order_index` INT NOT NULL DEFAULT 0,
  `created_at` DATETIME(3) NOT NULL,
  KEY `diet_plan_meals_version_idx` (`diet_plan_version_id`),
  KEY `diet_plan_meals_version_order_idx` (`diet_plan_version_id`, `order_index`),
  CONSTRAINT `diet_plan_meals_version_id_fk` FOREIGN KEY (`diet_plan_version_id`) REFERENCES `diet_plan_versions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `diet_plan_foods` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `diet_plan_meal_id` BIGINT UNSIGNED NOT NULL,
  `food_id` BIGINT UNSIGNED NOT NULL,
  `quantity` DOUBLE NOT NULL,
  `serving_unit` VARCHAR(50) NULL,
  `order_index` INT NOT NULL DEFAULT 0,
  `created_at` DATETIME(3) NOT NULL,
  KEY `diet_plan_foods_meal_idx` (`diet_plan_meal_id`),
  KEY `diet_plan_foods_food_idx` (`food_id`),
  CONSTRAINT `diet_plan_foods_meal_id_fk` FOREIGN KEY (`diet_plan_meal_id`) REFERENCES `diet_plan_meals` (`id`),
  CONSTRAINT `diet_plan_foods_food_id_fk` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `diet_histories` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `diet_plan_id` BIGINT UNSIGNED NULL,
  `logged_date` DATE NOT NULL,
  `total_calories_consumed` DOUBLE NOT NULL DEFAULT 0,
  `adherence_score` DOUBLE NULL,
  `water_intake_ml` INT NULL,
  `member_notes` TEXT NULL,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `diet_histories_member_id_idx` (`member_id`),
  KEY `diet_histories_logged_date_idx` (`logged_date`),
  UNIQUE KEY `diet_histories_member_logged_date_unique` (`member_id`, `logged_date`),
  CONSTRAINT `diet_histories_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `diet_histories_diet_plan_id_fk` FOREIGN KEY (`diet_plan_id`) REFERENCES `diet_plans` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
