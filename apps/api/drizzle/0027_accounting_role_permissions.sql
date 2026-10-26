-- Accounting permissions exist in the seed catalog but were never written to
-- databases seeded before that catalog. Insert them and grant them to
-- super_admin and admin. Idempotent.
INSERT IGNORE INTO `permissions` (`module`, `action`, `slug`, `description`, `created_at`) VALUES
  ('ACCT', 'read', 'accounting.read', 'View accounts, journals, documents and reports', UTC_TIMESTAMP(3)),
  ('ACCT', 'accounts_write', 'accounting.accounts_write', 'Create and update chart of accounts, tax codes and items', UTC_TIMESTAMP(3)),
  ('ACCT', 'vendors_write', 'accounting.vendors_write', 'Create and update vendors', UTC_TIMESTAMP(3)),
  ('ACCT', 'purchases_write', 'accounting.purchases_write', 'Create and post purchase bills and debit notes', UTC_TIMESTAMP(3)),
  ('ACCT', 'expenses_write', 'accounting.expenses_write', 'Create and post expense vouchers', UTC_TIMESTAMP(3)),
  ('ACCT', 'payments_write', 'accounting.payments_write', 'Create and post payment vouchers', UTC_TIMESTAMP(3)),
  ('ACCT', 'journals_write', 'accounting.journals_write', 'Create manual journals and opening balances', UTC_TIMESTAMP(3)),
  ('ACCT', 'periods_close', 'accounting.periods_close', 'Lock and unlock accounting periods', UTC_TIMESTAMP(3)),
  ('ACCT', 'posting_toggle', 'accounting.posting_toggle', 'Enable or disable automatic accounting posting', UTC_TIMESTAMP(3));

INSERT IGNORE INTO `role_permissions` (`role_id`, `permission_id`, `created_at`)
SELECT r.id, p.id, UTC_TIMESTAMP(3)
FROM `roles` r
JOIN `permissions` p ON p.slug IN (
  'accounting.read',
  'accounting.accounts_write',
  'accounting.vendors_write',
  'accounting.purchases_write',
  'accounting.expenses_write',
  'accounting.payments_write',
  'accounting.journals_write',
  'accounting.periods_close',
  'accounting.posting_toggle'
)
WHERE r.slug IN ('super_admin', 'admin');
