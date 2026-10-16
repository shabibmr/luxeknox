-- Drop accounts.code; uniqueness moves to accounts.name.
-- Idempotent: safe when code is already gone / name unique already exists.

DROP PROCEDURE IF EXISTS `__migrate_0031_ensure`;

DELIMITER $$
CREATE PROCEDURE `__migrate_0031_ensure`(
  IN p_table VARCHAR(64),
  IN p_kind VARCHAR(16),   -- 'column' | 'index' | 'drop_index' | 'drop_column'
  IN p_name VARCHAR(64),
  IN p_ddl TEXT
)
BEGIN
  DECLARE v_exists INT DEFAULT 0;

  IF p_kind = 'column' THEN
    SELECT COUNT(*) INTO v_exists FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_name;
  ELSEIF p_kind = 'index' OR p_kind = 'drop_index' THEN
    SELECT COUNT(*) INTO v_exists FROM information_schema.STATISTICS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND INDEX_NAME = p_name;
  ELSEIF p_kind = 'drop_column' THEN
    SELECT COUNT(*) INTO v_exists FROM information_schema.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_name;
  END IF;

  IF p_kind = 'drop_index' THEN
    IF v_exists > 0 THEN
      SET @__migrate_0031_ddl = CONCAT('ALTER TABLE `', p_table, '` ', p_ddl);
      PREPARE __migrate_0031_stmt FROM @__migrate_0031_ddl;
      EXECUTE __migrate_0031_stmt;
      DEALLOCATE PREPARE __migrate_0031_stmt;
    END IF;
  ELSEIF p_kind = 'drop_column' THEN
    IF v_exists > 0 THEN
      SET @__migrate_0031_ddl = CONCAT('ALTER TABLE `', p_table, '` ', p_ddl);
      PREPARE __migrate_0031_stmt FROM @__migrate_0031_ddl;
      EXECUTE __migrate_0031_stmt;
      DEALLOCATE PREPARE __migrate_0031_stmt;
    END IF;
  ELSE
    IF v_exists = 0 THEN
      SET @__migrate_0031_ddl = CONCAT('ALTER TABLE `', p_table, '` ', p_ddl);
      PREPARE __migrate_0031_stmt FROM @__migrate_0031_ddl;
      EXECUTE __migrate_0031_stmt;
      DEALLOCATE PREPARE __migrate_0031_stmt;
    END IF;
  END IF;
END$$
DELIMITER ;

CALL `__migrate_0031_ensure`(
  'accounts',
  'index',
  'accounts_name_unique',
  'ADD UNIQUE KEY `accounts_name_unique` (`name`)'
);

CALL `__migrate_0031_ensure`(
  'accounts',
  'drop_index',
  'accounts_code_unique',
  'DROP INDEX `accounts_code_unique`'
);

CALL `__migrate_0031_ensure`(
  'accounts',
  'drop_column',
  'code',
  'DROP COLUMN `code`'
);

DROP PROCEDURE IF EXISTS `__migrate_0031_ensure`;
