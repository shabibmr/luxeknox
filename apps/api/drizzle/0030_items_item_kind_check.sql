-- IL-R8: constrain items.item_kind to service|goods (matches ITEM_KINDS).
-- Idempotent: safe when the constraint already exists.

DROP PROCEDURE IF EXISTS `__migrate_0030_ensure`;

DELIMITER $$
CREATE PROCEDURE `__migrate_0030_ensure`(
  IN p_table VARCHAR(64),
  IN p_kind VARCHAR(16),   -- 'constraint'
  IN p_name VARCHAR(64),
  IN p_ddl TEXT
)
BEGIN
  DECLARE v_exists INT DEFAULT 0;

  IF p_kind = 'constraint' THEN
    SELECT COUNT(*) INTO v_exists FROM information_schema.TABLE_CONSTRAINTS
      WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND CONSTRAINT_NAME = p_name;
  END IF;

  IF v_exists = 0 THEN
    SET @__migrate_0030_ddl = CONCAT('ALTER TABLE `', p_table, '` ', p_ddl);
    PREPARE __migrate_0030_stmt FROM @__migrate_0030_ddl;
    EXECUTE __migrate_0030_stmt;
    DEALLOCATE PREPARE __migrate_0030_stmt;
  END IF;
END$$
DELIMITER ;

CALL `__migrate_0030_ensure`(
  'items',
  'constraint',
  'items_item_kind_chk',
  'ADD CONSTRAINT `items_item_kind_chk` CHECK (`item_kind` IN (''service'', ''goods''))'
);

DROP PROCEDURE IF EXISTS `__migrate_0030_ensure`;
