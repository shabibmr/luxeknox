-- IL-32: optional supplier_invoice_no on purchase_bills.
-- Forward migration so DBs that already recorded 0025 still get the column.
-- Uniqueness among non-void bills is enforced in PurchaseBillsService (partial unique).

DROP PROCEDURE IF EXISTS `__migrate_0029_ensure`;

DELIMITER $$
CREATE PROCEDURE `__migrate_0029_ensure`(
  IN p_table VARCHAR(64),
  IN p_kind VARCHAR(16),   -- 'column' | 'index'
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
  END IF;

  IF v_exists = 0 THEN
    SET @__migrate_0029_ddl = CONCAT('ALTER TABLE `', p_table, '` ', p_ddl);
    PREPARE __migrate_0029_stmt FROM @__migrate_0029_ddl;
    EXECUTE __migrate_0029_stmt;
    DEALLOCATE PREPARE __migrate_0029_stmt;
  END IF;
END$$
DELIMITER ;

CALL `__migrate_0029_ensure`(
  'purchase_bills',
  'column',
  'supplier_invoice_no',
  'ADD COLUMN `supplier_invoice_no` VARCHAR(64) NULL AFTER `due_date`'
);

CALL `__migrate_0029_ensure`(
  'purchase_bills',
  'index',
  'purchase_bills_vendor_supplier_invoice_idx',
  'ADD KEY `purchase_bills_vendor_supplier_invoice_idx` (`vendor_id`, `supplier_invoice_no`)'
);

DROP PROCEDURE IF EXISTS `__migrate_0029_ensure`;
