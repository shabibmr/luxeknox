-- Hand-authored SQL migration: 0025_accounting.sql
-- Double-entry accounting: chart, periods, tax, vendors, items, journals,
-- purchase/expense/payment vouchers, credit/debit notes, revenue recognition,
-- document number counters, and FK columns on payment_methods / products.
-- Depends on 0015_payments.sql, 0006_memberships.sql, 0020_personal_training.sql.
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci

-- ---------------------------------------------------------------------------
-- Number counters (single-row, same shape as invoice_number_counters)
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `journal_number_counters` (
  `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
  `next_value` BIGINT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `purchase_bill_number_counters` (
  `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
  `next_value` BIGINT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `expense_voucher_number_counters` (
  `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
  `next_value` BIGINT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `payment_voucher_number_counters` (
  `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
  `next_value` BIGINT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `credit_note_number_counters` (
  `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
  `next_value` BIGINT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `debit_note_number_counters` (
  `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
  `next_value` BIGINT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `journal_number_counters` (`id`, `next_value`) VALUES (1, 1);
INSERT INTO `purchase_bill_number_counters` (`id`, `next_value`) VALUES (1, 1);
INSERT INTO `expense_voucher_number_counters` (`id`, `next_value`) VALUES (1, 1);
INSERT INTO `payment_voucher_number_counters` (`id`, `next_value`) VALUES (1, 1);
INSERT INTO `credit_note_number_counters` (`id`, `next_value`) VALUES (1, 1);
INSERT INTO `debit_note_number_counters` (`id`, `next_value`) VALUES (1, 1);

-- ---------------------------------------------------------------------------
-- Masters
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(32) NOT NULL,
  `name` VARCHAR(150) NOT NULL,
  `account_type` VARCHAR(16) NOT NULL,
  `parent_id` BIGINT UNSIGNED NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `is_bank` BOOLEAN NOT NULL DEFAULT FALSE,
  `is_control` BOOLEAN NOT NULL DEFAULT FALSE,
  `control_role` VARCHAR(32) NULL,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `accounts_code_unique` (`code`),
  KEY `accounts_account_type_idx` (`account_type`),
  KEY `accounts_is_active_idx` (`is_active`),
  KEY `accounts_control_role_idx` (`control_role`),
  CONSTRAINT `accounts_parent_id_fk` FOREIGN KEY (`parent_id`) REFERENCES `accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `fiscal_years` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `label` VARCHAR(64) NOT NULL,
  `starts_on` DATE NOT NULL,
  `ends_on` DATE NOT NULL,
  UNIQUE KEY `fiscal_years_label_unique` (`label`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `accounting_periods` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `fiscal_year_id` BIGINT UNSIGNED NOT NULL,
  `starts_on` DATE NOT NULL,
  `ends_on` DATE NOT NULL,
  `status` VARCHAR(16) NOT NULL DEFAULT 'open',
  `closed_at` DATETIME(3) NULL,
  `closed_by_user_id` BIGINT UNSIGNED NULL,
  UNIQUE KEY `accounting_periods_fiscal_year_starts_on_unique` (`fiscal_year_id`, `starts_on`),
  KEY `accounting_periods_status_idx` (`status`),
  CONSTRAINT `accounting_periods_fiscal_year_id_fk` FOREIGN KEY (`fiscal_year_id`) REFERENCES `fiscal_years` (`id`),
  CONSTRAINT `accounting_periods_closed_by_user_id_fk` FOREIGN KEY (`closed_by_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `tax_codes` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `code` VARCHAR(32) NOT NULL,
  `rate_percent` DECIMAL(5,2) NOT NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  UNIQUE KEY `tax_codes_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `tax_code_components` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `tax_code_id` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  `rate_percent` DECIMAL(5,2) NOT NULL,
  `output_account_id` BIGINT UNSIGNED NOT NULL,
  `input_account_id` BIGINT UNSIGNED NOT NULL,
  KEY `tax_code_components_tax_code_id_idx` (`tax_code_id`),
  CONSTRAINT `tax_code_components_tax_code_id_fk` FOREIGN KEY (`tax_code_id`) REFERENCES `tax_codes` (`id`),
  CONSTRAINT `tax_code_components_output_account_id_fk` FOREIGN KEY (`output_account_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `tax_code_components_input_account_id_fk` FOREIGN KEY (`input_account_id`) REFERENCES `accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `vendors` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `phone` VARCHAR(32) NULL,
  `email` VARCHAR(255) NULL,
  `gstin` VARCHAR(20) NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  KEY `vendors_is_active_idx` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `items` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(150) NOT NULL,
  `item_kind` VARCHAR(16) NOT NULL,
  `inventory_tracked` BOOLEAN NOT NULL DEFAULT FALSE,
  `income_account_id` BIGINT UNSIGNED NOT NULL,
  `expense_account_id` BIGINT UNSIGNED NOT NULL,
  `tax_code_id` BIGINT UNSIGNED NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  KEY `items_is_active_idx` (`is_active`),
  KEY `items_item_kind_idx` (`item_kind`),
  CONSTRAINT `items_income_account_id_fk` FOREIGN KEY (`income_account_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `items_expense_account_id_fk` FOREIGN KEY (`expense_account_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `items_tax_code_id_fk` FOREIGN KEY (`tax_code_id`) REFERENCES `tax_codes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------------
-- Journals
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `journal_entries` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `journal_number` VARCHAR(32) NOT NULL,
  `entry_date` DATE NOT NULL,
  `accounting_period_id` BIGINT UNSIGNED NOT NULL,
  `source_type` VARCHAR(32) NOT NULL,
  `source_id` BIGINT UNSIGNED NOT NULL,
  `memo` TEXT NULL,
  `posted_at` DATETIME(3) NOT NULL,
  `posted_by_user_id` BIGINT UNSIGNED NULL,
  `reverses_journal_id` BIGINT UNSIGNED NULL,
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `journal_entries_journal_number_unique` (`journal_number`),
  UNIQUE KEY `journal_entries_source_type_source_id_unique` (`source_type`, `source_id`),
  KEY `journal_entries_entry_date_idx` (`entry_date`),
  KEY `journal_entries_accounting_period_id_idx` (`accounting_period_id`),
  CONSTRAINT `journal_entries_accounting_period_id_fk` FOREIGN KEY (`accounting_period_id`) REFERENCES `accounting_periods` (`id`),
  CONSTRAINT `journal_entries_posted_by_user_id_fk` FOREIGN KEY (`posted_by_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `journal_entries_reverses_journal_id_fk` FOREIGN KEY (`reverses_journal_id`) REFERENCES `journal_entries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `journal_lines` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `journal_entry_id` BIGINT UNSIGNED NOT NULL,
  `account_id` BIGINT UNSIGNED NOT NULL,
  `debit` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `credit` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `memo` TEXT NULL,
  `member_id` BIGINT UNSIGNED NULL,
  `vendor_id` BIGINT UNSIGNED NULL,
  KEY `journal_lines_journal_entry_id_idx` (`journal_entry_id`),
  KEY `journal_lines_account_id_idx` (`account_id`),
  CONSTRAINT `journal_lines_journal_entry_id_fk` FOREIGN KEY (`journal_entry_id`) REFERENCES `journal_entries` (`id`),
  CONSTRAINT `journal_lines_account_id_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `journal_lines_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `journal_lines_vendor_id_fk` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------------
-- Purchases, expenses, money out
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `purchase_bills` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `bill_number` VARCHAR(32) NOT NULL,
  `vendor_id` BIGINT UNSIGNED NOT NULL,
  `bill_date` DATE NOT NULL,
  `due_date` DATE NULL,
  `status` VARCHAR(16) NOT NULL DEFAULT 'draft',
  `subtotal` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `tax_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `total_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `journal_entry_id` BIGINT UNSIGNED NULL,
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `purchase_bills_bill_number_unique` (`bill_number`),
  KEY `purchase_bills_vendor_id_idx` (`vendor_id`),
  KEY `purchase_bills_status_idx` (`status`),
  CONSTRAINT `purchase_bills_vendor_id_fk` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`),
  CONSTRAINT `purchase_bills_journal_entry_id_fk` FOREIGN KEY (`journal_entry_id`) REFERENCES `journal_entries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `purchase_bill_lines` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `purchase_bill_id` BIGINT UNSIGNED NOT NULL,
  `item_id` BIGINT UNSIGNED NULL,
  `account_id` BIGINT UNSIGNED NOT NULL,
  `description` VARCHAR(255) NULL,
  `quantity` DECIMAL(12,2) NOT NULL DEFAULT '1.00',
  `rate` DECIMAL(12,2) NOT NULL,
  `tax_code_id` BIGINT UNSIGNED NULL,
  `net_amount` DECIMAL(12,2) NOT NULL,
  `tax_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  KEY `purchase_bill_lines_purchase_bill_id_idx` (`purchase_bill_id`),
  CONSTRAINT `purchase_bill_lines_purchase_bill_id_fk` FOREIGN KEY (`purchase_bill_id`) REFERENCES `purchase_bills` (`id`),
  CONSTRAINT `purchase_bill_lines_item_id_fk` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `purchase_bill_lines_account_id_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `purchase_bill_lines_tax_code_id_fk` FOREIGN KEY (`tax_code_id`) REFERENCES `tax_codes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `expense_vouchers` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `expense_number` VARCHAR(32) NOT NULL,
  `vendor_id` BIGINT UNSIGNED NULL,
  `payee_name` VARCHAR(150) NULL,
  `expense_date` DATE NOT NULL,
  `paid_from_account_id` BIGINT UNSIGNED NULL,
  `status` VARCHAR(16) NOT NULL DEFAULT 'draft',
  `subtotal` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `tax_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `total_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `journal_entry_id` BIGINT UNSIGNED NULL,
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `expense_vouchers_expense_number_unique` (`expense_number`),
  KEY `expense_vouchers_status_idx` (`status`),
  CONSTRAINT `expense_vouchers_vendor_id_fk` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`),
  CONSTRAINT `expense_vouchers_paid_from_account_id_fk` FOREIGN KEY (`paid_from_account_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `expense_vouchers_journal_entry_id_fk` FOREIGN KEY (`journal_entry_id`) REFERENCES `journal_entries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `expense_voucher_lines` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `expense_voucher_id` BIGINT UNSIGNED NOT NULL,
  `account_id` BIGINT UNSIGNED NOT NULL,
  `description` VARCHAR(255) NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `tax_code_id` BIGINT UNSIGNED NULL,
  `tax_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  KEY `expense_voucher_lines_expense_voucher_id_idx` (`expense_voucher_id`),
  CONSTRAINT `expense_voucher_lines_expense_voucher_id_fk` FOREIGN KEY (`expense_voucher_id`) REFERENCES `expense_vouchers` (`id`),
  CONSTRAINT `expense_voucher_lines_account_id_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `expense_voucher_lines_tax_code_id_fk` FOREIGN KEY (`tax_code_id`) REFERENCES `tax_codes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `payment_vouchers` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `voucher_number` VARCHAR(32) NOT NULL,
  `payment_date` DATE NOT NULL,
  `bank_account_id` BIGINT UNSIGNED NOT NULL,
  `total_amount` DECIMAL(12,2) NOT NULL,
  `memo` TEXT NULL,
  `status` VARCHAR(16) NOT NULL DEFAULT 'draft',
  `journal_entry_id` BIGINT UNSIGNED NULL,
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `payment_vouchers_voucher_number_unique` (`voucher_number`),
  KEY `payment_vouchers_status_idx` (`status`),
  CONSTRAINT `payment_vouchers_bank_account_id_fk` FOREIGN KEY (`bank_account_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `payment_vouchers_journal_entry_id_fk` FOREIGN KEY (`journal_entry_id`) REFERENCES `journal_entries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `payment_allocations` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `payment_voucher_id` BIGINT UNSIGNED NOT NULL,
  `purchase_bill_id` BIGINT UNSIGNED NULL,
  `expense_voucher_id` BIGINT UNSIGNED NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  KEY `payment_allocations_payment_voucher_id_idx` (`payment_voucher_id`),
  CONSTRAINT `payment_allocations_payment_voucher_id_fk` FOREIGN KEY (`payment_voucher_id`) REFERENCES `payment_vouchers` (`id`),
  CONSTRAINT `payment_allocations_purchase_bill_id_fk` FOREIGN KEY (`purchase_bill_id`) REFERENCES `purchase_bills` (`id`),
  CONSTRAINT `payment_allocations_expense_voucher_id_fk` FOREIGN KEY (`expense_voucher_id`) REFERENCES `expense_vouchers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------------
-- Credit / debit notes + revenue recognition
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `credit_notes` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `credit_note_number` VARCHAR(32) NOT NULL,
  `payment_id` BIGINT UNSIGNED NOT NULL,
  `credit_note_date` DATE NOT NULL,
  `reason` TEXT NULL,
  `subtotal` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `tax_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `total_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `status` VARCHAR(16) NOT NULL DEFAULT 'draft',
  `journal_entry_id` BIGINT UNSIGNED NULL,
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `credit_notes_credit_note_number_unique` (`credit_note_number`),
  KEY `credit_notes_payment_id_idx` (`payment_id`),
  KEY `credit_notes_status_idx` (`status`),
  CONSTRAINT `credit_notes_payment_id_fk` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`),
  CONSTRAINT `credit_notes_journal_entry_id_fk` FOREIGN KEY (`journal_entry_id`) REFERENCES `journal_entries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `debit_notes` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `debit_note_number` VARCHAR(32) NOT NULL,
  `purchase_bill_id` BIGINT UNSIGNED NOT NULL,
  `debit_note_date` DATE NOT NULL,
  `reason` TEXT NULL,
  `subtotal` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `tax_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `total_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `status` VARCHAR(16) NOT NULL DEFAULT 'draft',
  `journal_entry_id` BIGINT UNSIGNED NULL,
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `debit_notes_debit_note_number_unique` (`debit_note_number`),
  KEY `debit_notes_purchase_bill_id_idx` (`purchase_bill_id`),
  KEY `debit_notes_status_idx` (`status`),
  CONSTRAINT `debit_notes_purchase_bill_id_fk` FOREIGN KEY (`purchase_bill_id`) REFERENCES `purchase_bills` (`id`),
  CONSTRAINT `debit_notes_journal_entry_id_fk` FOREIGN KEY (`journal_entry_id`) REFERENCES `journal_entries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `revenue_recognition_schedules` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `payment_id` BIGINT UNSIGNED NOT NULL,
  `unearned_account_id` BIGINT UNSIGNED NOT NULL,
  `income_account_id` BIGINT UNSIGNED NOT NULL,
  `total_amount` DECIMAL(12,2) NOT NULL,
  `recognized_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `starts_on` DATE NOT NULL,
  `ends_on` DATE NOT NULL,
  KEY `revenue_recognition_schedules_payment_id_idx` (`payment_id`),
  UNIQUE KEY `revenue_recognition_schedules_payment_id_unique` (`payment_id`),
  CONSTRAINT `revenue_recognition_schedules_payment_id_fk` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`),
  CONSTRAINT `revenue_recognition_schedules_unearned_account_id_fk` FOREIGN KEY (`unearned_account_id`) REFERENCES `accounts` (`id`),
  CONSTRAINT `revenue_recognition_schedules_income_account_id_fk` FOREIGN KEY (`income_account_id`) REFERENCES `accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `revenue_recognition_lines` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `schedule_id` BIGINT UNSIGNED NOT NULL,
  `accounting_period_id` BIGINT UNSIGNED NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `journal_entry_id` BIGINT UNSIGNED NULL,
  UNIQUE KEY `revenue_recognition_lines_schedule_period_unique` (`schedule_id`, `accounting_period_id`),
  KEY `revenue_recognition_lines_schedule_id_idx` (`schedule_id`),
  CONSTRAINT `revenue_recognition_lines_schedule_id_fk` FOREIGN KEY (`schedule_id`) REFERENCES `revenue_recognition_schedules` (`id`),
  CONSTRAINT `revenue_recognition_lines_accounting_period_id_fk` FOREIGN KEY (`accounting_period_id`) REFERENCES `accounting_periods` (`id`),
  CONSTRAINT `revenue_recognition_lines_journal_entry_id_fk` FOREIGN KEY (`journal_entry_id`) REFERENCES `journal_entries` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------------
-- Alters on existing tables (nullable FKs; existing rows stay valid)
-- ---------------------------------------------------------------------------

ALTER TABLE `payment_methods`
  ADD COLUMN `account_id` BIGINT UNSIGNED NULL AFTER `is_active`,
  ADD KEY `payment_methods_account_id_idx` (`account_id`),
  ADD CONSTRAINT `payment_methods_account_id_fk` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`);

ALTER TABLE `membership_products`
  ADD COLUMN `income_account_id` BIGINT UNSIGNED NULL AFTER `access_facilities`,
  ADD KEY `membership_products_income_account_id_idx` (`income_account_id`),
  ADD CONSTRAINT `membership_products_income_account_id_fk` FOREIGN KEY (`income_account_id`) REFERENCES `accounts` (`id`);

ALTER TABLE `pt_products`
  ADD COLUMN `income_account_id` BIGINT UNSIGNED NULL AFTER `tax_percentage`,
  ADD KEY `pt_products_income_account_id_idx` (`income_account_id`),
  ADD CONSTRAINT `pt_products_income_account_id_fk` FOREIGN KEY (`income_account_id`) REFERENCES `accounts` (`id`);
