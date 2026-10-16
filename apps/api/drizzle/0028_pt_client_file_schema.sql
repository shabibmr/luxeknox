-- 1. Create par_q_screenings table
CREATE TABLE IF NOT EXISTS `par_q_screenings` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `version` VARCHAR(32) NOT NULL DEFAULT '2024.1',
  `q1_heart_condition` BOOLEAN NOT NULL DEFAULT FALSE,
  `q1_details` TEXT NULL,
  `q2_chest_pain_activity` BOOLEAN NOT NULL DEFAULT FALSE,
  `q2_details` TEXT NULL,
  `q3_chest_pain_rest` BOOLEAN NOT NULL DEFAULT FALSE,
  `q3_details` TEXT NULL,
  `q4_dizziness_consciousness` BOOLEAN NOT NULL DEFAULT FALSE,
  `q4_details` TEXT NULL,
  `q5_bone_joint_problem` BOOLEAN NOT NULL DEFAULT FALSE,
  `q5_details` TEXT NULL,
  `q6_medication_condition` BOOLEAN NOT NULL DEFAULT FALSE,
  `q6_details` TEXT NULL,
  `q7_other_reason` BOOLEAN NOT NULL DEFAULT FALSE,
  `q7_details` TEXT NULL,
  `has_positive_answer` BOOLEAN NOT NULL DEFAULT FALSE,
  `trainer_screening_notes` TEXT NULL,
  `referral_required` BOOLEAN NOT NULL DEFAULT FALSE,
  `referral_reason` TEXT NULL,
  `declaration_accepted` BOOLEAN NOT NULL DEFAULT FALSE,
  `client_signed_at` DATETIME(3) NULL,
  `trainer_signed_at` DATETIME(3) NULL,
  `trainer_user_id` BIGINT UNSIGNED NULL,
  `clearance_status` VARCHAR(32) NOT NULL DEFAULT 'passed',
  `cleared_at` DATETIME(3) NULL,
  `cleared_by_user_id` BIGINT UNSIGNED NULL,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  CONSTRAINT `par_q_screenings_member_id_members_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `par_q_screenings_trainer_user_id_users_id_fk` FOREIGN KEY (`trainer_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `par_q_screenings_cleared_by_user_id_users_id_fk` FOREIGN KEY (`cleared_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
--> statement-breakpoint
CREATE INDEX `par_q_screenings_member_id_idx` ON `par_q_screenings` (`member_id`);
--> statement-breakpoint
CREATE INDEX `par_q_screenings_clearance_status_idx` ON `par_q_screenings` (`clearance_status`);
--> statement-breakpoint

-- 2. Create member_lifestyle_intakes table
CREATE TABLE IF NOT EXISTS `member_lifestyle_intakes` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `activity_level` VARCHAR(32) NULL,
  `training_history` TEXT NULL,
  `current_pain_discomfort` TEXT NULL,
  `sleep_hours_typical` DECIMAL(3, 1) NULL,
  `stress_level` INT NULL,
  `work_activity_demands` TEXT NULL,
  `typical_daily_steps` INT NULL,
  `nutrition_approach` TEXT NULL,
  `hydration_habits` TEXT NULL,
  `recovery_habits` TEXT NULL,
  `other_notes` TEXT NULL,
  `lifestyle_priorities` JSON NULL,
  `conducted_by_trainer_id` BIGINT UNSIGNED NULL,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  CONSTRAINT `member_lifestyle_intakes_member_id_unique` UNIQUE (`member_id`),
  CONSTRAINT `member_lifestyle_intakes_member_id_members_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `member_lifestyle_intakes_conducted_by_trainer_id_trainers_id_fk` FOREIGN KEY (`conducted_by_trainer_id`) REFERENCES `trainers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
--> statement-breakpoint

-- 3. Create pt_progress_reviews table
CREATE TABLE IF NOT EXISTS `pt_progress_reviews` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `member_id` BIGINT UNSIGNED NOT NULL,
  `trainer_id` BIGINT UNSIGNED NOT NULL,
  `review_period_start` DATE NOT NULL,
  `review_period_end` DATE NOT NULL,
  `body_metrics_snapshot` JSON NULL,
  `performance_markers_snapshot` JSON NULL,
  `progress_highlights` JSON NULL,
  `highlights_other_text` TEXT NULL,
  `trainer_summary` TEXT NULL,
  `client_feedback` TEXT NULL,
  `next_phase_goal` TEXT NULL,
  `next_phase_training_focus` TEXT NULL,
  `next_review_date` DATE NULL,
  `review_checklist` JSON NULL,
  `final_review_notes` TEXT NULL,
  `client_signed_at` DATETIME(3) NULL,
  `trainer_signed_at` DATETIME(3) NULL,
  `manager_user_id` BIGINT UNSIGNED NULL,
  `manager_signed_at` DATETIME(3) NULL,
  `status` VARCHAR(32) NOT NULL DEFAULT 'draft',
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  CONSTRAINT `pt_progress_reviews_member_id_members_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `pt_progress_reviews_trainer_id_trainers_id_fk` FOREIGN KEY (`trainer_id`) REFERENCES `trainers` (`id`),
  CONSTRAINT `pt_progress_reviews_manager_user_id_users_id_fk` FOREIGN KEY (`manager_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
--> statement-breakpoint
CREATE INDEX `pt_progress_reviews_member_id_idx` ON `pt_progress_reviews` (`member_id`);
--> statement-breakpoint
CREATE INDEX `pt_progress_reviews_trainer_id_idx` ON `pt_progress_reviews` (`trainer_id`);
--> statement-breakpoint
CREATE INDEX `pt_progress_reviews_status_idx` ON `pt_progress_reviews` (`status`);
--> statement-breakpoint

-- 4. Alter workout_plans
ALTER TABLE `workout_plans`
  ADD COLUMN `primary_objective_12w` TEXT NULL,
  ADD COLUMN `milestone_4w` TEXT NULL,
  ADD COLUMN `sessions_per_week` INT NULL,
  ADD COLUMN `target_session_duration_minutes` INT NULL,
  ADD COLUMN `split_type` VARCHAR(64) NULL,
  ADD COLUMN `cardio_protocol` TEXT NULL,
  ADD COLUMN `mobility_protocol` TEXT NULL,
  ADD COLUMN `progression_methods` JSON NULL,
  ADD COLUMN `main_success_measure` VARCHAR(255) NULL,
  ADD COLUMN `trainer_programming_notes` TEXT NULL;
--> statement-breakpoint

-- 5. Alter workout_plan_exercises
ALTER TABLE `workout_plan_exercises`
  ADD COLUMN `target_rir` DECIMAL(3, 1) NULL,
  ADD COLUMN `target_duration_seconds` INT NULL;
--> statement-breakpoint

-- 6. Alter workout_sessions
ALTER TABLE `workout_sessions`
  ADD COLUMN `session_focus` VARCHAR(120) NULL,
  ADD COLUMN `warmup_protocol` TEXT NULL,
  ADD COLUMN `cooldown_protocol` TEXT NULL,
  ADD COLUMN `effort_rating` INT NULL,
  ADD COLUMN `satisfaction_rating` INT NULL,
  ADD COLUMN `pain_discomfort_score` INT NULL,
  ADD COLUMN `pain_notes` TEXT NULL,
  ADD COLUMN `trainer_notes` TEXT NULL,
  ADD COLUMN `next_session_plan` TEXT NULL,
  ADD COLUMN `client_signed_at` DATETIME(3) NULL,
  ADD COLUMN `trainer_signed_at` DATETIME(3) NULL;
--> statement-breakpoint

-- 7. Alter workout_session_exercises
ALTER TABLE `workout_session_exercises`
  ADD COLUMN `actual_rir` DECIMAL(3, 1) NULL,
  ADD COLUMN `actual_duration_seconds` INT NULL;
--> statement-breakpoint

-- 8. Alter members
ALTER TABLE `members`
  ADD COLUMN `next_review_date` DATE NULL,
  ADD COLUMN `preferred_training_days_times` VARCHAR(255) NULL,
  ADD COLUMN `exercise_preferences` TEXT NULL,
  ADD COLUMN `coaching_notes` TEXT NULL;
--> statement-breakpoint
CREATE INDEX `members_next_review_date_idx` ON `members` (`next_review_date`);
--> statement-breakpoint

-- 9. Alter pt_subscription_changes
ALTER TABLE `pt_subscription_changes`
  ADD COLUMN `handover_continuity_notes` TEXT NULL;
--> statement-breakpoint

-- 10. Alter schedule_participants
ALTER TABLE `schedule_participants`
  ADD COLUMN `client_verified_at` DATETIME(3) NULL;
