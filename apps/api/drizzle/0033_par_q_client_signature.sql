-- PAR-Q+ member signature (issue #48). Idempotent if the column already exists.

DROP PROCEDURE IF EXISTS `__migrate_0033_ensure`;

DELIMITER $$
CREATE PROCEDURE `__migrate_0033_ensure`(
  IN p_table VARCHAR(64),
  IN p_name VARCHAR(64),
  IN p_ddl TEXT
)
BEGIN
  DECLARE v_exists INT DEFAULT 0;
  SELECT COUNT(*) INTO v_exists FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_name;
  IF v_exists = 0 THEN
    SET @__migrate_0033_ddl = CONCAT('ALTER TABLE `', p_table, '` ', p_ddl);
    PREPARE __migrate_0033_stmt FROM @__migrate_0033_ddl;
    EXECUTE __migrate_0033_stmt;
    DEALLOCATE PREPARE __migrate_0033_stmt;
  END IF;
END$$
DELIMITER ;

CALL `__migrate_0033_ensure`('par_q_screenings', 'client_signature',
  'ADD COLUMN `client_signature` text');

DROP PROCEDURE `__migrate_0033_ensure`;
