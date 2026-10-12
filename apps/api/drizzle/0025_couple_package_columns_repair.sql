-- Repair: couple / package columns that 0006 and 0020 declare but were missing
-- from live DBs (CREATE TABLE IF NOT EXISTS skipped when older tables already existed).
--
-- Idempotent: every change is applied only if it is not already present, so this file works on
-- both an old DB (columns missing -> added) and a fresh DB (0006/0020 already created them -> no-op),
-- and can be re-run after a partial failure. MySQL has no ADD COLUMN/KEY/CONSTRAINT IF NOT EXISTS,
-- so a temporary helper procedure checks information_schema first.

DROP PROCEDURE IF EXISTS `__migrate_0025_ensure`;

DELIMITER $$
CREATE PROCEDURE `__migrate_0025_ensure`(
  IN p_table VARCHAR(64),
  IN p_kind VARCHAR(16),   -- 'column' | 'index' | 'constraint'
  IN p_name VARCHAR(64),
  IN p_ddl TEXT            -- the ALTER TABLE clause, e.g. 'ADD COLUMN ...'
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
    SET @__migrate_0025_ddl = CONCAT('ALTER TABLE `', p_table, '` ', p_ddl);
    PREPARE __migrate_0025_stmt FROM @__migrate_0025_ddl;
    EXECUTE __migrate_0025_stmt;
    DEALLOCATE PREPARE __migrate_0025_stmt;
  END IF;
END$$
DELIMITER ;

-- membership_products.package_type
CALL `__migrate_0025_ensure`('membership_products', 'column', 'package_type',
  'ADD COLUMN `package_type` VARCHAR(16) NOT NULL DEFAULT ''single'' AFTER `access_facilities`');
CALL `__migrate_0025_ensure`('membership_products', 'constraint', 'membership_products_package_type_check',
  'ADD CONSTRAINT `membership_products_package_type_check` CHECK (`package_type` IN (''single'', ''couple''))');

-- memberships.partner_membership_id
CALL `__migrate_0025_ensure`('memberships', 'column', 'partner_membership_id',
  'ADD COLUMN `partner_membership_id` BIGINT UNSIGNED NULL AFTER `auto_renew`');
CALL `__migrate_0025_ensure`('memberships', 'index', 'memberships_partner_membership_id_idx',
  'ADD KEY `memberships_partner_membership_id_idx` (`partner_membership_id`)');
CALL `__migrate_0025_ensure`('memberships', 'constraint', 'memberships_partner_membership_id_fk',
  'ADD CONSTRAINT `memberships_partner_membership_id_fk` FOREIGN KEY (`partner_membership_id`) REFERENCES `memberships` (`id`)');

-- membership_freezes.paired_freeze_id
CALL `__migrate_0025_ensure`('membership_freezes', 'column', 'paired_freeze_id',
  'ADD COLUMN `paired_freeze_id` BIGINT UNSIGNED NULL AFTER `reviewed_at`');
CALL `__migrate_0025_ensure`('membership_freezes', 'index', 'membership_freezes_paired_freeze_id_idx',
  'ADD KEY `membership_freezes_paired_freeze_id_idx` (`paired_freeze_id`)');
CALL `__migrate_0025_ensure`('membership_freezes', 'constraint', 'membership_freezes_paired_freeze_id_fk',
  'ADD CONSTRAINT `membership_freezes_paired_freeze_id_fk` FOREIGN KEY (`paired_freeze_id`) REFERENCES `membership_freezes` (`id`)');

-- pt_products.package_type
CALL `__migrate_0025_ensure`('pt_products', 'column', 'package_type',
  'ADD COLUMN `package_type` VARCHAR(16) NOT NULL DEFAULT ''single'' AFTER `tax_percentage`');
CALL `__migrate_0025_ensure`('pt_products', 'constraint', 'pt_products_package_type_check',
  'ADD CONSTRAINT `pt_products_package_type_check` CHECK (`package_type` IN (''single'', ''couple''))');

-- pt_subscriptions.partner_subscription_id / is_primary
CALL `__migrate_0025_ensure`('pt_subscriptions', 'column', 'partner_subscription_id',
  'ADD COLUMN `partner_subscription_id` BIGINT UNSIGNED NULL AFTER `renewed_from_id`');
CALL `__migrate_0025_ensure`('pt_subscriptions', 'column', 'is_primary',
  'ADD COLUMN `is_primary` BOOLEAN NOT NULL DEFAULT TRUE AFTER `partner_subscription_id`');
CALL `__migrate_0025_ensure`('pt_subscriptions', 'index', 'pt_subscriptions_partner_subscription_id_idx',
  'ADD KEY `pt_subscriptions_partner_subscription_id_idx` (`partner_subscription_id`)');
CALL `__migrate_0025_ensure`('pt_subscriptions', 'constraint', 'pt_subscriptions_partner_subscription_id_fk',
  'ADD CONSTRAINT `pt_subscriptions_partner_subscription_id_fk` FOREIGN KEY (`partner_subscription_id`) REFERENCES `pt_subscriptions` (`id`)');

DROP PROCEDURE `__migrate_0025_ensure`;

-- Catalog-hidden membership bundled with PT (ADR-0012); skipped if PT-BUNDLE already exists.
INSERT INTO `membership_products`
  (`name`, `code`, `description`, `duration_days`, `base_price`, `tax_percentage`, `max_freeze_days`,
   `pt_sessions_included`, `access_facilities`, `package_type`, `is_active`, `created_at`)
SELECT 'PT Bundled', 'PT-BUNDLE', 'Gym membership included with a Personal Training package.', 1, 0.00, 0.00, 0,
       0, NULL, 'single', FALSE, UTC_TIMESTAMP(3)
WHERE NOT EXISTS (SELECT 1 FROM `membership_products` WHERE `code` = 'PT-BUNDLE');
