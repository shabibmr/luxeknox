CREATE TABLE `invoice_number_counters` (
	`id` bigint unsigned NOT NULL,
	`next_value` bigint unsigned NOT NULL,
	CONSTRAINT `invoice_number_counters_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `payment_methods` (
	`id` bigint unsigned AUTO_INCREMENT NOT NULL,
	`method_name` varchar(100) NOT NULL,
	`is_digital` boolean NOT NULL DEFAULT false,
	`is_active` boolean NOT NULL DEFAULT true,
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	CONSTRAINT `payment_methods_id` PRIMARY KEY(`id`),
	CONSTRAINT `payment_methods_method_name_unique` UNIQUE(`method_name`)
);
--> statement-breakpoint
CREATE TABLE `payments` (
	`id` bigint unsigned AUTO_INCREMENT NOT NULL,
	`invoice_number` varchar(32) NOT NULL,
	`member_id` bigint unsigned NOT NULL,
	`membership_id` bigint unsigned,
	`payment_method_id` bigint unsigned,
	`subtotal` decimal(12,2) NOT NULL,
	`tax_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
	`discount_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
	`total_amount` decimal(12,2) NOT NULL,
	`amount_paid` decimal(12,2) NOT NULL DEFAULT '0.00',
	`status` varchar(16) NOT NULL DEFAULT 'pending',
	`transaction_reference` varchar(150),
	`cashier_user_id` bigint unsigned,
	`payment_date` datetime(3) NOT NULL,
	`row_version` int NOT NULL DEFAULT 1,
	`created_at` datetime(3) NOT NULL,
	`updated_at` datetime(3),
	CONSTRAINT `payments_id` PRIMARY KEY(`id`),
	CONSTRAINT `payments_invoice_number_unique` UNIQUE(`invoice_number`)
);
--> statement-breakpoint
CREATE TABLE `payment_histories` (
	`id` bigint unsigned AUTO_INCREMENT NOT NULL,
	`payment_id` bigint unsigned NOT NULL,
	`payment_method_id` bigint unsigned,
	`action` varchar(32) NOT NULL,
	`amount` decimal(12,2) NOT NULL,
	`notes` text,
	`timestamp` datetime(3) NOT NULL,
	CONSTRAINT `payment_histories_id` PRIMARY KEY(`id`)
);
--> statement-breakpoint
CREATE TABLE `payment_receipts` (
	`id` bigint unsigned AUTO_INCREMENT NOT NULL,
	`payment_id` bigint unsigned NOT NULL,
	`receipt_number` varchar(32) NOT NULL,
	`receipt_pdf_url` varchar(512),
	`generated_at` datetime(3) NOT NULL,
	CONSTRAINT `payment_receipts_id` PRIMARY KEY(`id`),
	CONSTRAINT `payment_receipts_payment_id_unique` UNIQUE(`payment_id`),
	CONSTRAINT `payment_receipts_receipt_number_unique` UNIQUE(`receipt_number`)
);
--> statement-breakpoint
ALTER TABLE `payments` ADD CONSTRAINT `payments_member_id_members_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `payments` ADD CONSTRAINT `payments_membership_id_memberships_id_fk` FOREIGN KEY (`membership_id`) REFERENCES `memberships`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `payments` ADD CONSTRAINT `payments_payment_method_id_payment_methods_id_fk` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `payments` ADD CONSTRAINT `payments_cashier_user_id_users_id_fk` FOREIGN KEY (`cashier_user_id`) REFERENCES `users`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `payment_histories` ADD CONSTRAINT `payment_histories_payment_id_payments_id_fk` FOREIGN KEY (`payment_id`) REFERENCES `payments`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `payment_histories` ADD CONSTRAINT `payment_histories_payment_method_id_payment_methods_id_fk` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE `payment_receipts` ADD CONSTRAINT `payment_receipts_payment_id_payments_id_fk` FOREIGN KEY (`payment_id`) REFERENCES `payments`(`id`) ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE INDEX `payment_methods_is_active_idx` ON `payment_methods` (`is_active`);--> statement-breakpoint
CREATE INDEX `payments_member_id_idx` ON `payments` (`member_id`);--> statement-breakpoint
CREATE INDEX `payments_status_idx` ON `payments` (`status`);--> statement-breakpoint
CREATE INDEX `payments_payment_date_idx` ON `payments` (`payment_date`);--> statement-breakpoint
CREATE INDEX `payment_histories_payment_id_idx` ON `payment_histories` (`payment_id`);--> statement-breakpoint
INSERT INTO `invoice_number_counters` (`id`, `next_value`) VALUES (1, 1);
