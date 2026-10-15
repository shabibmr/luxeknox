-- Hand-authored SQL migration: 0027_inventory.sql
-- Inventory documents: stock ledger, counter sales, sales returns, stock adjustments,
-- and SAL / SRN / ADJ number counters.
-- Depends on 0025_accounting.sql (items, accounts, journals, tax codes) and payment_methods.
-- Engine: MySQL 8.4 (InnoDB)
-- Collation: utf8mb4_0900_ai_ci

CREATE TABLE IF NOT EXISTS `counter_sale_number_counters` (
  `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
  `next_value` BIGINT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `sales_return_number_counters` (
  `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
  `next_value` BIGINT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `stock_adjustment_number_counters` (
  `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
  `next_value` BIGINT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `counter_sale_number_counters` (`id`, `next_value`) VALUES (1, 1);
INSERT INTO `sales_return_number_counters` (`id`, `next_value`) VALUES (1, 1);
INSERT INTO `stock_adjustment_number_counters` (`id`, `next_value`) VALUES (1, 1);

CREATE TABLE IF NOT EXISTS `item_stock` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `item_id` BIGINT UNSIGNED NOT NULL,
  `qty_on_hand` DECIMAL(14,3) NOT NULL DEFAULT '0.000',
  `stock_value` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `avg_cost` DECIMAL(14,4) NOT NULL DEFAULT '0.0000',
  `row_version` INT NOT NULL DEFAULT 1,
  UNIQUE KEY `item_stock_item_id_unique` (`item_id`),
  CONSTRAINT `item_stock_item_id_fk` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `stock_movements` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `item_id` BIGINT UNSIGNED NOT NULL,
  `movement_date` DATE NOT NULL,
  `source_type` VARCHAR(32) NOT NULL,
  `source_id` BIGINT UNSIGNED NOT NULL,
  `source_line_id` BIGINT UNSIGNED NULL,
  `qty_in` DECIMAL(14,3) NOT NULL DEFAULT '0.000',
  `qty_out` DECIMAL(14,3) NOT NULL DEFAULT '0.000',
  `unit_cost` DECIMAL(14,4) NOT NULL,
  `value` DECIMAL(12,2) NOT NULL,
  `balance_qty` DECIMAL(14,3) NOT NULL,
  `balance_value` DECIMAL(12,2) NOT NULL,
  `created_at` DATETIME(3) NOT NULL,
  KEY `stock_movements_item_id_movement_date_idx` (`item_id`, `movement_date`),
  KEY `stock_movements_source_idx` (`source_type`, `source_id`),
  CONSTRAINT `stock_movements_item_id_fk` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `stock_movements_source_type_chk` CHECK (`source_type` IN (
    'purchase_bill', 'debit_note', 'counter_sale', 'counter_sale_return', 'stock_adjustment'
  ))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `counter_sales` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `sale_number` VARCHAR(32) NOT NULL,
  `sale_date` DATE NOT NULL,
  `member_id` BIGINT UNSIGNED NULL,
  `customer_name` VARCHAR(150) NULL,
  `subtotal` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `discount_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `tax_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `total_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `cogs_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `status` VARCHAR(16) NOT NULL DEFAULT 'posted',
  `journal_entry_id` BIGINT UNSIGNED NULL,
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `counter_sales_sale_number_unique` (`sale_number`),
  KEY `counter_sales_sale_date_idx` (`sale_date`),
  KEY `counter_sales_member_id_idx` (`member_id`),
  CONSTRAINT `counter_sales_member_id_fk` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `counter_sales_journal_entry_id_fk` FOREIGN KEY (`journal_entry_id`) REFERENCES `journal_entries` (`id`),
  CONSTRAINT `counter_sales_status_chk` CHECK (`status` IN ('posted'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `counter_sale_lines` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `counter_sale_id` BIGINT UNSIGNED NOT NULL,
  `item_id` BIGINT UNSIGNED NOT NULL,
  `quantity` DECIMAL(14,3) NOT NULL,
  `rate` DECIMAL(12,2) NOT NULL,
  `discount_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `tax_code_id` BIGINT UNSIGNED NULL,
  `net_amount` DECIMAL(12,2) NOT NULL,
  `tax_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `unit_cost` DECIMAL(14,4) NULL,
  `cost_amount` DECIMAL(12,2) NULL,
  KEY `counter_sale_lines_counter_sale_id_idx` (`counter_sale_id`),
  KEY `counter_sale_lines_item_id_idx` (`item_id`),
  CONSTRAINT `counter_sale_lines_counter_sale_id_fk` FOREIGN KEY (`counter_sale_id`) REFERENCES `counter_sales` (`id`),
  CONSTRAINT `counter_sale_lines_item_id_fk` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `counter_sale_lines_tax_code_id_fk` FOREIGN KEY (`tax_code_id`) REFERENCES `tax_codes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `counter_sale_tenders` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `counter_sale_id` BIGINT UNSIGNED NOT NULL,
  `payment_method_id` BIGINT UNSIGNED NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `reference` VARCHAR(150) NULL,
  KEY `counter_sale_tenders_counter_sale_id_idx` (`counter_sale_id`),
  CONSTRAINT `counter_sale_tenders_counter_sale_id_fk` FOREIGN KEY (`counter_sale_id`) REFERENCES `counter_sales` (`id`),
  CONSTRAINT `counter_sale_tenders_payment_method_id_fk` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `sales_returns` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `return_number` VARCHAR(32) NOT NULL,
  `counter_sale_id` BIGINT UNSIGNED NOT NULL,
  `return_date` DATE NOT NULL,
  `reason` TEXT NULL,
  `subtotal` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `tax_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `total_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `cogs_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `status` VARCHAR(16) NOT NULL DEFAULT 'posted',
  `journal_entry_id` BIGINT UNSIGNED NULL,
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `sales_returns_return_number_unique` (`return_number`),
  KEY `sales_returns_counter_sale_id_idx` (`counter_sale_id`),
  KEY `sales_returns_return_date_idx` (`return_date`),
  CONSTRAINT `sales_returns_counter_sale_id_fk` FOREIGN KEY (`counter_sale_id`) REFERENCES `counter_sales` (`id`),
  CONSTRAINT `sales_returns_journal_entry_id_fk` FOREIGN KEY (`journal_entry_id`) REFERENCES `journal_entries` (`id`),
  CONSTRAINT `sales_returns_status_chk` CHECK (`status` IN ('posted'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `sales_return_lines` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `sales_return_id` BIGINT UNSIGNED NOT NULL,
  `counter_sale_line_id` BIGINT UNSIGNED NOT NULL,
  `quantity` DECIMAL(14,3) NOT NULL,
  `net_amount` DECIMAL(12,2) NOT NULL,
  `tax_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `cost_amount` DECIMAL(12,2) NULL,
  KEY `sales_return_lines_sales_return_id_idx` (`sales_return_id`),
  KEY `sales_return_lines_counter_sale_line_id_idx` (`counter_sale_line_id`),
  CONSTRAINT `sales_return_lines_sales_return_id_fk` FOREIGN KEY (`sales_return_id`) REFERENCES `sales_returns` (`id`),
  CONSTRAINT `sales_return_lines_counter_sale_line_id_fk` FOREIGN KEY (`counter_sale_line_id`) REFERENCES `counter_sale_lines` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `sales_return_tenders` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `sales_return_id` BIGINT UNSIGNED NOT NULL,
  `payment_method_id` BIGINT UNSIGNED NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `reference` VARCHAR(150) NULL,
  KEY `sales_return_tenders_sales_return_id_idx` (`sales_return_id`),
  CONSTRAINT `sales_return_tenders_sales_return_id_fk` FOREIGN KEY (`sales_return_id`) REFERENCES `sales_returns` (`id`),
  CONSTRAINT `sales_return_tenders_payment_method_id_fk` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `stock_adjustments` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `adjustment_number` VARCHAR(32) NOT NULL,
  `adjustment_date` DATE NOT NULL,
  `reason` VARCHAR(16) NOT NULL,
  `memo` TEXT NULL,
  `status` VARCHAR(16) NOT NULL DEFAULT 'draft',
  `journal_entry_id` BIGINT UNSIGNED NULL,
  `row_version` INT NOT NULL DEFAULT 1,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `stock_adjustments_adjustment_number_unique` (`adjustment_number`),
  KEY `stock_adjustments_adjustment_date_idx` (`adjustment_date`),
  KEY `stock_adjustments_status_idx` (`status`),
  CONSTRAINT `stock_adjustments_journal_entry_id_fk` FOREIGN KEY (`journal_entry_id`) REFERENCES `journal_entries` (`id`),
  CONSTRAINT `stock_adjustments_reason_chk` CHECK (`reason` IN ('opening', 'count', 'damage', 'expiry', 'other')),
  CONSTRAINT `stock_adjustments_status_chk` CHECK (`status` IN ('draft', 'posted'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `stock_adjustment_lines` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `stock_adjustment_id` BIGINT UNSIGNED NOT NULL,
  `item_id` BIGINT UNSIGNED NOT NULL,
  `qty_delta` DECIMAL(14,3) NOT NULL,
  `unit_cost` DECIMAL(14,4) NULL,
  `value` DECIMAL(12,2) NOT NULL,
  KEY `stock_adjustment_lines_stock_adjustment_id_idx` (`stock_adjustment_id`),
  KEY `stock_adjustment_lines_item_id_idx` (`item_id`),
  CONSTRAINT `stock_adjustment_lines_stock_adjustment_id_fk` FOREIGN KEY (`stock_adjustment_id`) REFERENCES `stock_adjustments` (`id`),
  CONSTRAINT `stock_adjustment_lines_item_id_fk` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  CONSTRAINT `stock_adjustment_lines_qty_delta_chk` CHECK (`qty_delta` <> 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
