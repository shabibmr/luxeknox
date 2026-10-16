-- Repair: IL-01 pieces that were edited into 0025_accounting.sql in place.
--
-- migrate.ts skips any filename already recorded in __drizzle_migrations, so an
-- already-applied pre-IL-01 0025 never re-runs. 0027_inventory.sql also does not
-- add uoms, item_categories, the new items columns, debit_note_lines, or widen
-- purchase_bill_lines.quantity.
--
-- Idempotent: safe when the edited 0025 already created these objects (no-op),
-- and safe on a DB that still has the old items shape. uom_id is added nullable,
-- backfilled to PCS, then set NOT NULL so seed WHERE uom_id IS NULL can match
-- during the nullable window and every item ends with a UOM.

DROP PROCEDURE IF EXISTS `__migrate_0028_ensure`;
DROP PROCEDURE IF EXISTS `__migrate_0028_modify_column`;

DELIMITER $$
CREATE PROCEDURE `__migrate_0028_ensure`(
  IN p_table VARCHAR(64),
  IN p_kind VARCHAR(16),   -- 'column' | 'index' | 'constraint'
  IN p_name VARCHAR(64),
  IN p_ddl TEXT
)
BEGIN
  DECLARE v_exists INT DEFAULT 0;

  IF p_kind = 'column' THEN
    SELECT COUNT(*) INTO v_exists FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_name;
  ELSEIF p_kind = 'index' THEN
    SELECT COUNT(*) INTO v_exists FROM information_schema.STATISTICS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND INDEX_NAME = p_name;
  ELSEIF p_kind = 'constraint' THEN
    SELECT COUNT(*) INTO v_exists FROM information_schema.TABLE_CONSTRAINTS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND CONSTRAINT_NAME = p_name;
  END IF;

  IF v_exists = 0 THEN
    SET @__migrate_0028_ddl = CONCAT('ALTER TABLE `', p_table, '` ', p_ddl);
    PREPARE __migrate_0028_stmt FROM @__migrate_0028_ddl;
    EXECUTE __migrate_0028_stmt;
    DEALLOCATE PREPARE __migrate_0028_stmt;
  END IF;
END$$

CREATE PROCEDURE `__migrate_0028_modify_column`(
  IN p_table VARCHAR(64),
  IN p_column VARCHAR(64),
  IN p_wanted_type VARCHAR(64),
  IN p_wanted_nullable VARCHAR(3),  -- 'YES' | 'NO'
  IN p_ddl TEXT                     -- full MODIFY COLUMN clause
)
BEGIN
  DECLARE v_type VARCHAR(64);
  DECLARE v_nullable VARCHAR(3);

  SELECT COLUMN_TYPE, IS_NULLABLE
    INTO v_type, v_nullable
    FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = p_table
     AND COLUMN_NAME = p_column
   LIMIT 1;

  IF v_type IS NOT NULL AND (v_type <> p_wanted_type OR v_nullable <> p_wanted_nullable) THEN
    SET @__migrate_0028_ddl = CONCAT('ALTER TABLE `', p_table, '` ', p_ddl);
    PREPARE __migrate_0028_stmt FROM @__migrate_0028_ddl;
    EXECUTE __migrate_0028_stmt;
    DEALLOCATE PREPARE __migrate_0028_stmt;
  END IF;
END$$
DELIMITER ;

CREATE TABLE IF NOT EXISTS `uoms` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(16) NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  `decimal_places` TINYINT NOT NULL DEFAULT 0,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `uoms_code_unique` (`code`),
  CONSTRAINT `uoms_decimal_places_chk` CHECK (`decimal_places` BETWEEN 0 AND 3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `item_categories` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `parent_id` BIGINT UNSIGNED NULL,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  `created_at` DATETIME(3) NOT NULL,
  `updated_at` DATETIME(3) NULL,
  UNIQUE KEY `item_categories_name_unique` (`name`),
  KEY `item_categories_parent_id_idx` (`parent_id`),
  CONSTRAINT `item_categories_parent_id_fk` FOREIGN KEY (`parent_id`) REFERENCES `item_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- items: IL-01 columns. uom_id and created_at start nullable so existing rows can be backfilled.
CALL `__migrate_0028_ensure`('items', 'column', 'sku',
  'ADD COLUMN `sku` VARCHAR(64) NULL');
CALL `__migrate_0028_ensure`('items', 'column', 'hsn_sac',
  'ADD COLUMN `hsn_sac` VARCHAR(16) NULL');
CALL `__migrate_0028_ensure`('items', 'column', 'category_id',
  'ADD COLUMN `category_id` BIGINT UNSIGNED NULL');
CALL `__migrate_0028_ensure`('items', 'column', 'uom_id',
  'ADD COLUMN `uom_id` BIGINT UNSIGNED NULL');
CALL `__migrate_0028_ensure`('items', 'column', 'sale_rate',
  'ADD COLUMN `sale_rate` DECIMAL(12,2) NULL');
CALL `__migrate_0028_ensure`('items', 'column', 'purchase_rate',
  'ADD COLUMN `purchase_rate` DECIMAL(12,2) NULL');
CALL `__migrate_0028_ensure`('items', 'column', 'reorder_level',
  'ADD COLUMN `reorder_level` DECIMAL(14,3) NULL');
CALL `__migrate_0028_ensure`('items', 'column', 'inventory_account_id',
  'ADD COLUMN `inventory_account_id` BIGINT UNSIGNED NULL');
CALL `__migrate_0028_ensure`('items', 'column', 'cogs_account_id',
  'ADD COLUMN `cogs_account_id` BIGINT UNSIGNED NULL');
CALL `__migrate_0028_ensure`('items', 'column', 'row_version',
  'ADD COLUMN `row_version` INT NOT NULL DEFAULT 1');
CALL `__migrate_0028_ensure`('items', 'column', 'created_at',
  'ADD COLUMN `created_at` DATETIME(3) NULL');
CALL `__migrate_0028_ensure`('items', 'column', 'updated_at',
  'ADD COLUMN `updated_at` DATETIME(3) NULL');

INSERT INTO `uoms` (`code`, `name`, `decimal_places`, `is_active`, `created_at`)
SELECT 'PCS', 'Pieces', 0, TRUE, UTC_TIMESTAMP(3)
WHERE NOT EXISTS (SELECT 1 FROM `uoms` WHERE `code` = 'PCS');

UPDATE `items`
   SET `created_at` = UTC_TIMESTAMP(3)
 WHERE `created_at` IS NULL;

UPDATE `items` AS i
  JOIN (SELECT `id` AS pcs_id FROM `uoms` WHERE `code` = 'PCS' LIMIT 1) AS p
   SET i.`uom_id` = p.pcs_id
 WHERE i.`uom_id` IS NULL;

CALL `__migrate_0028_modify_column`(
  'items', 'created_at', 'datetime(3)', 'NO',
  'MODIFY COLUMN `created_at` DATETIME(3) NOT NULL');
CALL `__migrate_0028_modify_column`(
  'items', 'uom_id', 'bigint(20) unsigned', 'NO',
  'MODIFY COLUMN `uom_id` BIGINT UNSIGNED NOT NULL');

CALL `__migrate_0028_ensure`('items', 'index', 'items_sku_unique',
  'ADD UNIQUE KEY `items_sku_unique` (`sku`)');
CALL `__migrate_0028_ensure`('items', 'index', 'items_category_id_idx',
  'ADD KEY `items_category_id_idx` (`category_id`)');
CALL `__migrate_0028_ensure`('items', 'constraint', 'items_category_id_fk',
  'ADD CONSTRAINT `items_category_id_fk` FOREIGN KEY (`category_id`) REFERENCES `item_categories` (`id`)');
CALL `__migrate_0028_ensure`('items', 'constraint', 'items_uom_id_fk',
  'ADD CONSTRAINT `items_uom_id_fk` FOREIGN KEY (`uom_id`) REFERENCES `uoms` (`id`)');
CALL `__migrate_0028_ensure`('items', 'constraint', 'items_inventory_account_id_fk',
  'ADD CONSTRAINT `items_inventory_account_id_fk` FOREIGN KEY (`inventory_account_id`) REFERENCES `accounts` (`id`)');
CALL `__migrate_0028_ensure`('items', 'constraint', 'items_cogs_account_id_fk',
  'ADD CONSTRAINT `items_cogs_account_id_fk` FOREIGN KEY (`cogs_account_id`) REFERENCES `accounts` (`id`)');

CREATE TABLE IF NOT EXISTS `debit_note_lines` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `debit_note_id` BIGINT UNSIGNED NOT NULL,
  `purchase_bill_line_id` BIGINT UNSIGNED NOT NULL,
  `quantity` DECIMAL(14,3) NOT NULL,
  `net_amount` DECIMAL(12,2) NOT NULL,
  `tax_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  KEY `debit_note_lines_debit_note_id_idx` (`debit_note_id`),
  KEY `debit_note_lines_purchase_bill_line_id_idx` (`purchase_bill_line_id`),
  CONSTRAINT `debit_note_lines_debit_note_id_fk` FOREIGN KEY (`debit_note_id`) REFERENCES `debit_notes` (`id`),
  CONSTRAINT `debit_note_lines_purchase_bill_line_id_fk` FOREIGN KEY (`purchase_bill_line_id`) REFERENCES `purchase_bill_lines` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CALL `__migrate_0028_modify_column`(
  'purchase_bill_lines', 'quantity', 'decimal(14,3)', 'NO',
  'MODIFY COLUMN `quantity` DECIMAL(14,3) NOT NULL DEFAULT ''1.000''');

DROP PROCEDURE `__migrate_0028_ensure`;
DROP PROCEDURE `__migrate_0028_modify_column`;
