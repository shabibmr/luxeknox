-- f038f75 made password_hash nullable in the Drizzle schema (passwordless user creation)
-- but shipped no migration, so inserts without a password failed with
-- "Column 'password_hash' cannot be null". MODIFY is idempotent.
ALTER TABLE `users` MODIFY COLUMN `password_hash` varchar(255) NULL;
