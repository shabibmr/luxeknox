CREATE TABLE `idempotency_keys` (
	`id` bigint unsigned AUTO_INCREMENT NOT NULL,
	`idempotency_key` varchar(128) NOT NULL,
	`method` varchar(16) NOT NULL,
	`path` varchar(255) NOT NULL,
	`user_id` bigint unsigned,
	`request_hash` varchar(64) NOT NULL,
	`response_status` int NOT NULL,
	`response_body` text NOT NULL,
	`created_at` datetime(3) NOT NULL,
	`expires_at` datetime(3) NOT NULL,
	CONSTRAINT `idempotency_keys_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
ALTER TABLE `idempotency_keys` ADD CONSTRAINT `idempotency_keys_user_id_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX `idempotency_keys_key_method_path_unique` ON `idempotency_keys` (`idempotency_key`,`method`,`path`);--> statement-breakpoint
CREATE INDEX `idempotency_keys_expires_at_idx` ON `idempotency_keys` (`expires_at`);
