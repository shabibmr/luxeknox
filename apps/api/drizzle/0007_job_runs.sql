CREATE TABLE `job_runs` (
	`id` bigint unsigned AUTO_INCREMENT NOT NULL,
	`job_name` varchar(150) NOT NULL,
	`status` enum('success','failure','running') NOT NULL,
	`started_at` datetime(3) NOT NULL,
	`finished_at` datetime(3),
	`error_message` text,
	`retry_count` int NOT NULL DEFAULT 0,
	`created_at` datetime(3) NOT NULL,
	CONSTRAINT `job_runs_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE INDEX `job_runs_job_name_idx` ON `job_runs` (`job_name`);--> statement-breakpoint
CREATE INDEX `job_runs_status_finished_at_idx` ON `job_runs` (`status`,`finished_at`);