CREATE TABLE `attendance_histories` (
	`id` bigint unsigned AUTO_INCREMENT NOT NULL,
	`date` date NOT NULL,
	`total_member_checkins` int NOT NULL DEFAULT 0,
	`total_trainer_checkins` int NOT NULL DEFAULT 0,
	`peak_hour` int,
	`peak_count` int,
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	CONSTRAINT `attendance_histories_id` PRIMARY KEY(`id`),
	CONSTRAINT `attendance_histories_date_unique` UNIQUE(`date`)
);
--> statement-breakpoint
CREATE TABLE `attendances` (
	`id` bigint unsigned AUTO_INCREMENT NOT NULL,
	`user_id` bigint unsigned NOT NULL,
	`check_in_time` datetime(3) NOT NULL,
	`check_out_time` datetime(3),
	`method` varchar(32) NOT NULL,
	`gate_identifier` varchar(100),
	`verified_by_user_id` bigint unsigned,
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	CONSTRAINT `attendances_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `device_credentials` (
	`id` bigint unsigned AUTO_INCREMENT NOT NULL,
	`device_name` varchar(150) NOT NULL,
	`key_hash` varchar(255) NOT NULL,
	`is_active` boolean NOT NULL DEFAULT true,
	`location_details` text,
	`last_used_at` datetime(3),
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	CONSTRAINT `device_credentials_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
ALTER TABLE `attendances` ADD CONSTRAINT `attendances_user_id_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `attendances` ADD CONSTRAINT `attendances_verified_by_user_id_users_id_fk` FOREIGN KEY (`verified_by_user_id`) REFERENCES `users`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX `attendances_user_id_check_in_idx` ON `attendances` (`user_id`,`check_in_time`);--> statement-breakpoint
CREATE INDEX `attendances_check_in_time_idx` ON `attendances` (`check_in_time`);--> statement-breakpoint
CREATE INDEX `attendances_gate_identifier_idx` ON `attendances` (`gate_identifier`);--> statement-breakpoint
CREATE INDEX `device_credentials_is_active_idx` ON `device_credentials` (`is_active`);