ALTER TABLE `member_health` ADD COLUMN `recorded_at` datetime(3) NULL;
UPDATE `member_health` SET `recorded_at` = `created_at` WHERE `recorded_at` IS NULL;
ALTER TABLE `member_health` MODIFY COLUMN `recorded_at` datetime(3) NOT NULL;
ALTER TABLE `member_health` ADD INDEX `member_health_member_id_idx` (`member_id`);
ALTER TABLE `member_health` DROP INDEX `member_health_member_id_unique`;
ALTER TABLE `member_health` DROP COLUMN `updated_at`;
