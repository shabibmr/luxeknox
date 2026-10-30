CREATE TABLE `pt_progress_reviews` (
	`id` bigint unsigned AUTO_INCREMENT NOT NULL,
	`member_id` bigint unsigned NOT NULL,
	`trainer_id` bigint unsigned NOT NULL,
	`review_period_start` date NOT NULL,
	`review_period_end` date NOT NULL,
	`body_metrics_snapshot` json,
	`performance_markers_snapshot` json,
	`progress_highlights` json,
	`highlights_other_text` text,
	`trainer_summary` text,
	`client_feedback` text,
	`next_phase_goal` text,
	`next_phase_training_focus` text,
	`next_review_date` date,
	`review_checklist` json,
	`final_review_notes` text,
	`client_signed_at` datetime(3),
	`trainer_signed_at` datetime(3),
	`manager_user_id` bigint unsigned,
	`manager_signed_at` datetime(3),
	`status` varchar(32) NOT NULL DEFAULT 'draft',
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	CONSTRAINT `pt_progress_reviews_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `par_q_screenings` (
	`id` bigint unsigned AUTO_INCREMENT NOT NULL,
	`member_id` bigint unsigned NOT NULL,
	`version` varchar(32) NOT NULL DEFAULT '2024.1',
	`q1_heart_condition` boolean NOT NULL DEFAULT false,
	`q1_details` text,
	`q2_chest_pain_activity` boolean NOT NULL DEFAULT false,
	`q2_details` text,
	`q3_chest_pain_rest` boolean NOT NULL DEFAULT false,
	`q3_details` text,
	`q4_dizziness_consciousness` boolean NOT NULL DEFAULT false,
	`q4_details` text,
	`q5_bone_joint_problem` boolean NOT NULL DEFAULT false,
	`q5_details` text,
	`q6_medication_condition` boolean NOT NULL DEFAULT false,
	`q6_details` text,
	`q7_other_reason` boolean NOT NULL DEFAULT false,
	`q7_details` text,
	`has_positive_answer` boolean NOT NULL,
	`trainer_screening_notes` text,
	`referral_required` boolean NOT NULL,
	`referral_reason` text,
	`declaration_accepted` boolean NOT NULL DEFAULT false,
	`client_signed_at` datetime(3),
	`trainer_signed_at` datetime(3),
	`trainer_user_id` bigint unsigned,
	`clearance_status` varchar(32) NOT NULL,
	`cleared_at` datetime(3),
	`cleared_by_user_id` bigint unsigned,
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	CONSTRAINT `par_q_screenings_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `member_lifestyle_intakes` (
	`id` bigint unsigned AUTO_INCREMENT NOT NULL,
	`member_id` bigint unsigned NOT NULL,
	`activity_level` varchar(32),
	`training_history` text,
	`current_pain_discomfort` text,
	`sleep_hours_typical` decimal(3,1),
	`stress_level` int,
	`work_activity_demands` text,
	`typical_daily_steps` int,
	`nutrition_approach` text,
	`hydration_habits` text,
	`recovery_habits` text,
	`other_notes` text,
	`lifestyle_priorities` json,
	`conducted_by_trainer_id` bigint unsigned,
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	CONSTRAINT `member_lifestyle_intakes_id` PRIMARY KEY(`id`),
	CONSTRAINT `member_lifestyle_intakes_member_id_unique` UNIQUE(`member_id`)
);
--> statement-breakpoint
ALTER TABLE `members` ADD `next_review_date` date;--> statement-breakpoint
ALTER TABLE `members` ADD `preferred_training_days_times` varchar(255);--> statement-breakpoint
ALTER TABLE `members` ADD `exercise_preferences` text;--> statement-breakpoint
ALTER TABLE `members` ADD `coaching_notes` text;--> statement-breakpoint
ALTER TABLE `pt_subscription_changes` ADD `handover_continuity_notes` text;--> statement-breakpoint
ALTER TABLE `schedule_participants` ADD `client_verified_at` datetime(3);--> statement-breakpoint
ALTER TABLE `workout_plan_exercises` ADD `target_rir` decimal(3,1);--> statement-breakpoint
ALTER TABLE `workout_plan_exercises` ADD `target_duration_seconds` int;--> statement-breakpoint
ALTER TABLE `workout_plans` ADD `primary_objective_12w` text;--> statement-breakpoint
ALTER TABLE `workout_plans` ADD `milestone_4w` text;--> statement-breakpoint
ALTER TABLE `workout_plans` ADD `sessions_per_week` int;--> statement-breakpoint
ALTER TABLE `workout_plans` ADD `target_session_duration_minutes` int;--> statement-breakpoint
ALTER TABLE `workout_plans` ADD `split_type` varchar(64);--> statement-breakpoint
ALTER TABLE `workout_plans` ADD `cardio_protocol` text;--> statement-breakpoint
ALTER TABLE `workout_plans` ADD `mobility_protocol` text;--> statement-breakpoint
ALTER TABLE `workout_plans` ADD `progression_methods` json;--> statement-breakpoint
ALTER TABLE `workout_plans` ADD `main_success_measure` varchar(255);--> statement-breakpoint
ALTER TABLE `workout_plans` ADD `trainer_programming_notes` text;--> statement-breakpoint
ALTER TABLE `workout_session_exercises` ADD `actual_rir` decimal(3,1);--> statement-breakpoint
ALTER TABLE `workout_session_exercises` ADD `actual_duration_seconds` int;--> statement-breakpoint
-- 0027_workout_session_exercise_notes.sql already adds this column.
DROP PROCEDURE IF EXISTS `__migrate_0032_wse_notes`;
DELIMITER $$
CREATE PROCEDURE `__migrate_0032_wse_notes`()
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'workout_session_exercises'
      AND COLUMN_NAME = 'notes'
  ) THEN
    ALTER TABLE `workout_session_exercises` ADD `notes` text;
  END IF;
END$$
DELIMITER ;
CALL `__migrate_0032_wse_notes`();
DROP PROCEDURE IF EXISTS `__migrate_0032_wse_notes`;
--> statement-breakpoint
ALTER TABLE `workout_sessions` ADD `session_focus` varchar(120);--> statement-breakpoint
ALTER TABLE `workout_sessions` ADD `warmup_protocol` text;--> statement-breakpoint
ALTER TABLE `workout_sessions` ADD `cooldown_protocol` text;--> statement-breakpoint
ALTER TABLE `workout_sessions` ADD `effort_rating` int;--> statement-breakpoint
ALTER TABLE `workout_sessions` ADD `satisfaction_rating` int;--> statement-breakpoint
ALTER TABLE `workout_sessions` ADD `pain_discomfort_score` int;--> statement-breakpoint
ALTER TABLE `workout_sessions` ADD `pain_notes` text;--> statement-breakpoint
ALTER TABLE `workout_sessions` ADD `trainer_notes` text;--> statement-breakpoint
ALTER TABLE `workout_sessions` ADD `next_session_plan` text;--> statement-breakpoint
ALTER TABLE `workout_sessions` ADD `client_signed_at` datetime(3);--> statement-breakpoint
ALTER TABLE `workout_sessions` ADD `trainer_signed_at` datetime(3);--> statement-breakpoint
ALTER TABLE `pt_progress_reviews` ADD CONSTRAINT `pt_progress_reviews_member_id_members_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `pt_progress_reviews` ADD CONSTRAINT `pt_progress_reviews_trainer_id_trainers_id_fk` FOREIGN KEY (`trainer_id`) REFERENCES `trainers`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `pt_progress_reviews` ADD CONSTRAINT `pt_progress_reviews_manager_user_id_users_id_fk` FOREIGN KEY (`manager_user_id`) REFERENCES `users`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `par_q_screenings` ADD CONSTRAINT `par_q_screenings_member_id_members_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `par_q_screenings` ADD CONSTRAINT `par_q_screenings_trainer_user_id_users_id_fk` FOREIGN KEY (`trainer_user_id`) REFERENCES `users`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `par_q_screenings` ADD CONSTRAINT `par_q_screenings_cleared_by_user_id_users_id_fk` FOREIGN KEY (`cleared_by_user_id`) REFERENCES `users`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `member_lifestyle_intakes` ADD CONSTRAINT `member_lifestyle_intakes_member_id_members_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `member_lifestyle_intakes` ADD CONSTRAINT `member_lifestyle_intakes_conducted_by_trainer_id_trainers_id_fk` FOREIGN KEY (`conducted_by_trainer_id`) REFERENCES `trainers`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX `pt_progress_reviews_member_id_idx` ON `pt_progress_reviews` (`member_id`);--> statement-breakpoint
CREATE INDEX `pt_progress_reviews_trainer_id_idx` ON `pt_progress_reviews` (`trainer_id`);--> statement-breakpoint
CREATE INDEX `pt_progress_reviews_status_idx` ON `pt_progress_reviews` (`status`);--> statement-breakpoint
CREATE INDEX `par_q_screenings_member_id_idx` ON `par_q_screenings` (`member_id`);--> statement-breakpoint
CREATE INDEX `par_q_screenings_clearance_status_idx` ON `par_q_screenings` (`clearance_status`);--> statement-breakpoint
CREATE INDEX `members_next_review_date_idx` ON `members` (`next_review_date`);