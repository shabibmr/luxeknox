-- Repeatable migration: apply least-privilege grants to the application user.
-- Runs as DB_ADMIN_USER on every migrate, after all numbered migrations.
-- audit_logs is append-only (NFR-003, ADR-0002): SELECT + INSERT, never UPDATE/DELETE.

DELIMITER $$

DROP PROCEDURE IF EXISTS `apply_app_grants`$$

CREATE PROCEDURE `apply_app_grants`(IN app_user VARCHAR(64), IN db_name VARCHAR(64))
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE tbl VARCHAR(64);
  DECLARE cur CURSOR FOR
    SELECT TABLE_NAME
      FROM information_schema.TABLES
     WHERE TABLE_SCHEMA = db_name
       AND TABLE_TYPE = 'BASE TABLE';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  -- 1. Drop the database-level grant created by the MySQL entrypoint.
  --    1141/1147 mean it is already gone; any other error is real and must propagate.
  BEGIN
    DECLARE CONTINUE HANDLER FOR 1141, 1147 BEGIN END;
    SET @sql := CONCAT('REVOKE ALL PRIVILEGES ON `', db_name, '`.* FROM ''', app_user, '''@''%''');
    PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;
  END;

  -- 2. Re-issue DML per table. audit_logs is the exception.
  OPEN cur;
  grant_loop: LOOP
    FETCH cur INTO tbl;
    IF done = 1 THEN LEAVE grant_loop; END IF;

    IF tbl = 'audit_logs' THEN
      SET @sql := CONCAT('GRANT SELECT, INSERT ON `', db_name, '`.`', tbl,
                         '` TO ''', app_user, '''@''%''');
    ELSE
      SET @sql := CONCAT('GRANT SELECT, INSERT, UPDATE, DELETE ON `', db_name, '`.`', tbl,
                         '` TO ''', app_user, '''@''%''');
    END IF;
    PREPARE s FROM @sql; EXECUTE s; DEALLOCATE PREPARE s;
  END LOOP;
  CLOSE cur;
END$$

CALL `apply_app_grants`('${DB_USER}', '${DB_NAME}')$$

DROP PROCEDURE IF EXISTS `apply_app_grants`$$

DELIMITER ;
