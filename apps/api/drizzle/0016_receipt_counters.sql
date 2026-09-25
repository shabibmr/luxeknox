CREATE TABLE `receipt_number_counters` (
	`id` bigint unsigned NOT NULL,
	`next_value` bigint unsigned NOT NULL,
	CONSTRAINT `receipt_number_counters_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
INSERT INTO `receipt_number_counters` (`id`, `next_value`) VALUES (1, 1);
