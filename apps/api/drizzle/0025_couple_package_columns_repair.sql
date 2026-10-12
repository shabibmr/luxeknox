-- Repair: couple / package columns that 0006 and 0020 declare but were missing
-- from live DBs (CREATE TABLE IF NOT EXISTS skipped when older tables already existed).
-- Safe to run once; migrate runner records the file name after success.

ALTER TABLE `membership_products`
  ADD COLUMN `package_type` VARCHAR(16) NOT NULL DEFAULT 'single' AFTER `access_facilities`;

ALTER TABLE `membership_products`
  ADD CONSTRAINT `membership_products_package_type_check`
  CHECK (`package_type` IN ('single', 'couple'));

ALTER TABLE `memberships`
  ADD COLUMN `partner_membership_id` BIGINT UNSIGNED NULL AFTER `auto_renew`,
  ADD KEY `memberships_partner_membership_id_idx` (`partner_membership_id`),
  ADD CONSTRAINT `memberships_partner_membership_id_fk`
    FOREIGN KEY (`partner_membership_id`) REFERENCES `memberships` (`id`);

ALTER TABLE `membership_freezes`
  ADD COLUMN `paired_freeze_id` BIGINT UNSIGNED NULL AFTER `reviewed_at`,
  ADD KEY `membership_freezes_paired_freeze_id_idx` (`paired_freeze_id`),
  ADD CONSTRAINT `membership_freezes_paired_freeze_id_fk`
    FOREIGN KEY (`paired_freeze_id`) REFERENCES `membership_freezes` (`id`);

ALTER TABLE `pt_products`
  ADD COLUMN `package_type` VARCHAR(16) NOT NULL DEFAULT 'single' AFTER `tax_percentage`;

ALTER TABLE `pt_products`
  ADD CONSTRAINT `pt_products_package_type_check`
  CHECK (`package_type` IN ('single', 'couple'));

ALTER TABLE `pt_subscriptions`
  ADD COLUMN `partner_subscription_id` BIGINT UNSIGNED NULL AFTER `renewed_from_id`,
  ADD COLUMN `is_primary` BOOLEAN NOT NULL DEFAULT TRUE AFTER `partner_subscription_id`,
  ADD KEY `pt_subscriptions_partner_subscription_id_idx` (`partner_subscription_id`),
  ADD CONSTRAINT `pt_subscriptions_partner_subscription_id_fk`
    FOREIGN KEY (`partner_subscription_id`) REFERENCES `pt_subscriptions` (`id`);

-- Catalog-hidden membership bundled with PT (ADR-0012); INSERT IGNORE is idempotent.
INSERT IGNORE INTO `membership_products`
  (`name`, `code`, `description`, `duration_days`, `base_price`, `tax_percentage`, `max_freeze_days`,
   `pt_sessions_included`, `access_facilities`, `package_type`, `is_active`, `created_at`)
VALUES
  ('PT Bundled', 'PT-BUNDLE', 'Gym membership included with a Personal Training package.', 1, 0.00, 0.00, 0,
   0, NULL, 'single', FALSE, UTC_TIMESTAMP(3));
