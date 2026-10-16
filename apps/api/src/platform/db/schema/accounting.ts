import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
  check,
  date,
  decimal,
  index,
  int,
  mysqlTable,
  text,
  tinyint,
  uniqueIndex,
  varchar,
  type AnyMySqlColumn,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';
import { payments } from './payments';
import { users } from './users';

export const ACCOUNT_TYPES = ['asset', 'liability', 'equity', 'income', 'expense'] as const;
export type AccountType = (typeof ACCOUNT_TYPES)[number];

export const ACCOUNT_CONTROL_ROLES = [
  'ar',
  'ap',
  'unearned_membership',
  'unearned_pt',
  'output_cgst',
  'output_sgst',
  'output_igst',
  'input_tax',
  'discounts',
  'inventory',
] as const;
export type AccountControlRole = (typeof ACCOUNT_CONTROL_ROLES)[number];

export const ACCOUNTING_PERIOD_STATUSES = ['open', 'locked'] as const;
export type AccountingPeriodStatus = (typeof ACCOUNTING_PERIOD_STATUSES)[number];

export const ITEM_KINDS = ['service', 'goods'] as const;
export type ItemKind = (typeof ITEM_KINDS)[number];

export const JOURNAL_SOURCE_TYPES = [
  'sales_invoice',
  'sales_receipt',
  'credit_note',
  'purchase_bill',
  'expense_voucher',
  'payment_voucher',
  'debit_note',
  'revenue_recognition',
  'manual',
  'opening_balance',
  'journal_reversal',
  'sales_adjustment',
  'recognition_forfeit',
  'fund_transfer',
  'counter_sale',
  'counter_sale_return',
  'stock_adjustment',
] as const;
export type JournalSourceType = (typeof JOURNAL_SOURCE_TYPES)[number];

export const ACCOUNTING_DOCUMENT_STATUSES = ['draft', 'posted', 'void'] as const;
export type AccountingDocumentStatus = (typeof ACCOUNTING_DOCUMENT_STATUSES)[number];

/** Single-row counters — same shape as `invoice_number_counters`. */
export const journalNumberCounters = mysqlTable('journal_number_counters', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number', unsigned: true }).notNull(),
});

export const purchaseBillNumberCounters = mysqlTable('purchase_bill_number_counters', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number', unsigned: true }).notNull(),
});

export const expenseVoucherNumberCounters = mysqlTable('expense_voucher_number_counters', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number', unsigned: true }).notNull(),
});

export const paymentVoucherNumberCounters = mysqlTable('payment_voucher_number_counters', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number', unsigned: true }).notNull(),
});

export const creditNoteNumberCounters = mysqlTable('credit_note_number_counters', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number', unsigned: true }).notNull(),
});

export const debitNoteNumberCounters = mysqlTable('debit_note_number_counters', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number', unsigned: true }).notNull(),
});

export const fundTransferNumberCounters = mysqlTable('fund_transfer_number_counters', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number', unsigned: true }).notNull(),
});

export type FundTransferNumberCounter = typeof fundTransferNumberCounters.$inferSelect;
export type NewFundTransferNumberCounter = typeof fundTransferNumberCounters.$inferInsert;

export const accounts = mysqlTable(
  'accounts',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    code: varchar('code', { length: 32 }).notNull(),
    name: varchar('name', { length: 150 }).notNull(),
    account_type: varchar('account_type', { length: 16 }).notNull(),
    parent_id: bigint('parent_id', { mode: 'number', unsigned: true }).references(
      (): AnyMySqlColumn => accounts.id,
    ),
    is_active: boolean('is_active').notNull().default(true),
    is_bank: boolean('is_bank').notNull().default(false),
    is_control: boolean('is_control').notNull().default(false),
    control_role: varchar('control_role', { length: 32 }),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('accounts_code_unique').on(table.code),
    index('accounts_account_type_idx').on(table.account_type),
    index('accounts_is_active_idx').on(table.is_active),
    index('accounts_control_role_idx').on(table.control_role),
  ],
);

export type Account = typeof accounts.$inferSelect;
export type NewAccount = typeof accounts.$inferInsert;

export const fiscalYears = mysqlTable(
  'fiscal_years',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    label: varchar('label', { length: 64 }).notNull(),
    starts_on: date('starts_on', { mode: 'string' }).notNull(),
    ends_on: date('ends_on', { mode: 'string' }).notNull(),
  },
  (table) => [uniqueIndex('fiscal_years_label_unique').on(table.label)],
);

export type FiscalYear = typeof fiscalYears.$inferSelect;
export type NewFiscalYear = typeof fiscalYears.$inferInsert;

export const accountingPeriods = mysqlTable(
  'accounting_periods',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    fiscal_year_id: bigint('fiscal_year_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => fiscalYears.id),
    starts_on: date('starts_on', { mode: 'string' }).notNull(),
    ends_on: date('ends_on', { mode: 'string' }).notNull(),
    status: varchar('status', { length: 16 }).notNull().default('open'),
    closed_at: utcDatetime('closed_at'),
    closed_by_user_id: bigint('closed_by_user_id', { mode: 'number', unsigned: true }).references(
      () => users.id,
    ),
  },
  (table) => [
    uniqueIndex('accounting_periods_fiscal_year_starts_on_unique').on(
      table.fiscal_year_id,
      table.starts_on,
    ),
    index('accounting_periods_status_idx').on(table.status),
  ],
);

export type AccountingPeriod = typeof accountingPeriods.$inferSelect;
export type NewAccountingPeriod = typeof accountingPeriods.$inferInsert;

export const taxCodes = mysqlTable(
  'tax_codes',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    name: varchar('name', { length: 100 }).notNull(),
    code: varchar('code', { length: 32 }).notNull(),
    rate_percent: decimal('rate_percent', { precision: 5, scale: 2 }).notNull(),
    is_active: boolean('is_active').notNull().default(true),
  },
  (table) => [uniqueIndex('tax_codes_code_unique').on(table.code)],
);

export type TaxCode = typeof taxCodes.$inferSelect;
export type NewTaxCode = typeof taxCodes.$inferInsert;

export const taxCodeComponents = mysqlTable(
  'tax_code_components',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    tax_code_id: bigint('tax_code_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => taxCodes.id),
    name: varchar('name', { length: 64 }).notNull(),
    rate_percent: decimal('rate_percent', { precision: 5, scale: 2 }).notNull(),
    output_account_id: bigint('output_account_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accounts.id),
    input_account_id: bigint('input_account_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accounts.id),
  },
  (table) => [index('tax_code_components_tax_code_id_idx').on(table.tax_code_id)],
);

export type TaxCodeComponent = typeof taxCodeComponents.$inferSelect;
export type NewTaxCodeComponent = typeof taxCodeComponents.$inferInsert;

export const vendors = mysqlTable(
  'vendors',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    name: varchar('name', { length: 150 }).notNull(),
    phone: varchar('phone', { length: 32 }),
    email: varchar('email', { length: 255 }),
    gstin: varchar('gstin', { length: 20 }),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [index('vendors_is_active_idx').on(table.is_active)],
);

export type Vendor = typeof vendors.$inferSelect;
export type NewVendor = typeof vendors.$inferInsert;

export const uoms = mysqlTable(
  'uoms',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    code: varchar('code', { length: 16 }).notNull(),
    name: varchar('name', { length: 64 }).notNull(),
    decimal_places: tinyint('decimal_places').notNull().default(0),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [uniqueIndex('uoms_code_unique').on(table.code)],
);

export type Uom = typeof uoms.$inferSelect;
export type NewUom = typeof uoms.$inferInsert;

export const itemCategories = mysqlTable(
  'item_categories',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    name: varchar('name', { length: 100 }).notNull(),
    parent_id: bigint('parent_id', { mode: 'number', unsigned: true }).references(
      (): AnyMySqlColumn => itemCategories.id,
    ),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('item_categories_name_unique').on(table.name),
    index('item_categories_parent_id_idx').on(table.parent_id),
  ],
);

export type ItemCategory = typeof itemCategories.$inferSelect;
export type NewItemCategory = typeof itemCategories.$inferInsert;

export const items = mysqlTable(
  'items',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    name: varchar('name', { length: 150 }).notNull(),
    sku: varchar('sku', { length: 64 }),
    hsn_sac: varchar('hsn_sac', { length: 16 }),
    item_kind: varchar('item_kind', { length: 16 }).notNull(),
    category_id: bigint('category_id', { mode: 'number', unsigned: true }).references(
      () => itemCategories.id,
    ),
    uom_id: bigint('uom_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => uoms.id),
    inventory_tracked: boolean('inventory_tracked').notNull().default(false),
    sale_rate: decimal('sale_rate', { precision: 12, scale: 2 }),
    purchase_rate: decimal('purchase_rate', { precision: 12, scale: 2 }),
    reorder_level: decimal('reorder_level', { precision: 14, scale: 3 }),
    income_account_id: bigint('income_account_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accounts.id),
    expense_account_id: bigint('expense_account_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accounts.id),
    inventory_account_id: bigint('inventory_account_id', {
      mode: 'number',
      unsigned: true,
    }).references(() => accounts.id),
    cogs_account_id: bigint('cogs_account_id', { mode: 'number', unsigned: true }).references(
      () => accounts.id,
    ),
    tax_code_id: bigint('tax_code_id', { mode: 'number', unsigned: true }).references(
      () => taxCodes.id,
    ),
    is_active: boolean('is_active').notNull().default(true),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('items_sku_unique').on(table.sku),
    index('items_is_active_idx').on(table.is_active),
    index('items_item_kind_idx').on(table.item_kind),
    index('items_category_id_idx').on(table.category_id),
    check('items_item_kind_chk', sql`${table.item_kind} IN ('service', 'goods')`),
  ],
);

export type Item = typeof items.$inferSelect;
export type NewItem = typeof items.$inferInsert;

export const journalEntries = mysqlTable(
  'journal_entries',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    journal_number: varchar('journal_number', { length: 32 }).notNull(),
    entry_date: date('entry_date', { mode: 'string' }).notNull(),
    accounting_period_id: bigint('accounting_period_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accountingPeriods.id),
    source_type: varchar('source_type', { length: 32 }).notNull(),
    source_id: bigint('source_id', { mode: 'number', unsigned: true }).notNull(),
    memo: text('memo'),
    posted_at: utcDatetime('posted_at').notNull(),
    posted_by_user_id: bigint('posted_by_user_id', { mode: 'number', unsigned: true }).references(
      () => users.id,
    ),
    reverses_journal_id: bigint('reverses_journal_id', { mode: 'number', unsigned: true }).references(
      (): AnyMySqlColumn => journalEntries.id,
    ),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('journal_entries_journal_number_unique').on(table.journal_number),
    uniqueIndex('journal_entries_source_type_source_id_unique').on(
      table.source_type,
      table.source_id,
    ),
    index('journal_entries_entry_date_idx').on(table.entry_date),
    index('journal_entries_accounting_period_id_idx').on(table.accounting_period_id),
  ],
);

export type JournalEntry = typeof journalEntries.$inferSelect;
export type NewJournalEntry = typeof journalEntries.$inferInsert;

export const journalLines = mysqlTable(
  'journal_lines',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    journal_entry_id: bigint('journal_entry_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => journalEntries.id),
    account_id: bigint('account_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accounts.id),
    debit: decimal('debit', { precision: 12, scale: 2 }).notNull().default('0.00'),
    credit: decimal('credit', { precision: 12, scale: 2 }).notNull().default('0.00'),
    memo: text('memo'),
    member_id: bigint('member_id', { mode: 'number', unsigned: true }).references(() => members.id),
    vendor_id: bigint('vendor_id', { mode: 'number', unsigned: true }).references(() => vendors.id),
  },
  (table) => [
    index('journal_lines_journal_entry_id_idx').on(table.journal_entry_id),
    index('journal_lines_account_id_idx').on(table.account_id),
  ],
);

export type JournalLine = typeof journalLines.$inferSelect;
export type NewJournalLine = typeof journalLines.$inferInsert;

export const purchaseBills = mysqlTable(
  'purchase_bills',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    bill_number: varchar('bill_number', { length: 32 }).notNull(),
    vendor_id: bigint('vendor_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => vendors.id),
    bill_date: date('bill_date', { mode: 'string' }).notNull(),
    due_date: date('due_date', { mode: 'string' }),
    /** Vendor's invoice number; uniqueness among non-void bills is enforced in the service. */
    supplier_invoice_no: varchar('supplier_invoice_no', { length: 64 }),
    status: varchar('status', { length: 16 }).notNull().default('draft'),
    subtotal: decimal('subtotal', { precision: 12, scale: 2 }).notNull().default('0.00'),
    tax_amount: decimal('tax_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    total_amount: decimal('total_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    journal_entry_id: bigint('journal_entry_id', { mode: 'number', unsigned: true }).references(
      () => journalEntries.id,
    ),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('purchase_bills_bill_number_unique').on(table.bill_number),
    index('purchase_bills_vendor_id_idx').on(table.vendor_id),
    index('purchase_bills_status_idx').on(table.status),
    index('purchase_bills_vendor_supplier_invoice_idx').on(
      table.vendor_id,
      table.supplier_invoice_no,
    ),
  ],
);

export type PurchaseBill = typeof purchaseBills.$inferSelect;
export type NewPurchaseBill = typeof purchaseBills.$inferInsert;

export const purchaseBillLines = mysqlTable(
  'purchase_bill_lines',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    purchase_bill_id: bigint('purchase_bill_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => purchaseBills.id),
    item_id: bigint('item_id', { mode: 'number', unsigned: true }).references(() => items.id),
    account_id: bigint('account_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accounts.id),
    description: varchar('description', { length: 255 }),
    quantity: decimal('quantity', { precision: 14, scale: 3 }).notNull().default('1.000'),
    rate: decimal('rate', { precision: 12, scale: 2 }).notNull(),
    tax_code_id: bigint('tax_code_id', { mode: 'number', unsigned: true }).references(
      () => taxCodes.id,
    ),
    net_amount: decimal('net_amount', { precision: 12, scale: 2 }).notNull(),
    tax_amount: decimal('tax_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
  },
  (table) => [index('purchase_bill_lines_purchase_bill_id_idx').on(table.purchase_bill_id)],
);

export type PurchaseBillLine = typeof purchaseBillLines.$inferSelect;
export type NewPurchaseBillLine = typeof purchaseBillLines.$inferInsert;

export const expenseVouchers = mysqlTable(
  'expense_vouchers',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    expense_number: varchar('expense_number', { length: 32 }).notNull(),
    vendor_id: bigint('vendor_id', { mode: 'number', unsigned: true }).references(() => vendors.id),
    payee_name: varchar('payee_name', { length: 150 }),
    expense_date: date('expense_date', { mode: 'string' }).notNull(),
    paid_from_account_id: bigint('paid_from_account_id', { mode: 'number', unsigned: true }).references(
      () => accounts.id,
    ),
    status: varchar('status', { length: 16 }).notNull().default('draft'),
    subtotal: decimal('subtotal', { precision: 12, scale: 2 }).notNull().default('0.00'),
    tax_amount: decimal('tax_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    total_amount: decimal('total_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    journal_entry_id: bigint('journal_entry_id', { mode: 'number', unsigned: true }).references(
      () => journalEntries.id,
    ),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('expense_vouchers_expense_number_unique').on(table.expense_number),
    index('expense_vouchers_status_idx').on(table.status),
  ],
);

export type ExpenseVoucher = typeof expenseVouchers.$inferSelect;
export type NewExpenseVoucher = typeof expenseVouchers.$inferInsert;

export const expenseVoucherLines = mysqlTable(
  'expense_voucher_lines',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    expense_voucher_id: bigint('expense_voucher_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => expenseVouchers.id),
    account_id: bigint('account_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accounts.id),
    description: varchar('description', { length: 255 }),
    amount: decimal('amount', { precision: 12, scale: 2 }).notNull(),
    tax_code_id: bigint('tax_code_id', { mode: 'number', unsigned: true }).references(
      () => taxCodes.id,
    ),
    tax_amount: decimal('tax_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
  },
  (table) => [index('expense_voucher_lines_expense_voucher_id_idx').on(table.expense_voucher_id)],
);

export type ExpenseVoucherLine = typeof expenseVoucherLines.$inferSelect;
export type NewExpenseVoucherLine = typeof expenseVoucherLines.$inferInsert;

export const paymentVouchers = mysqlTable(
  'payment_vouchers',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    voucher_number: varchar('voucher_number', { length: 32 }).notNull(),
    payment_date: date('payment_date', { mode: 'string' }).notNull(),
    bank_account_id: bigint('bank_account_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accounts.id),
    total_amount: decimal('total_amount', { precision: 12, scale: 2 }).notNull(),
    memo: text('memo'),
    status: varchar('status', { length: 16 }).notNull().default('draft'),
    journal_entry_id: bigint('journal_entry_id', { mode: 'number', unsigned: true }).references(
      () => journalEntries.id,
    ),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('payment_vouchers_voucher_number_unique').on(table.voucher_number),
    index('payment_vouchers_status_idx').on(table.status),
  ],
);

export type PaymentVoucher = typeof paymentVouchers.$inferSelect;
export type NewPaymentVoucher = typeof paymentVouchers.$inferInsert;

export const paymentAllocations = mysqlTable(
  'payment_allocations',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    payment_voucher_id: bigint('payment_voucher_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => paymentVouchers.id),
    purchase_bill_id: bigint('purchase_bill_id', { mode: 'number', unsigned: true }).references(
      () => purchaseBills.id,
    ),
    expense_voucher_id: bigint('expense_voucher_id', { mode: 'number', unsigned: true }).references(
      () => expenseVouchers.id,
    ),
    amount: decimal('amount', { precision: 12, scale: 2 }).notNull(),
  },
  (table) => [index('payment_allocations_payment_voucher_id_idx').on(table.payment_voucher_id)],
);

export type PaymentAllocation = typeof paymentAllocations.$inferSelect;
export type NewPaymentAllocation = typeof paymentAllocations.$inferInsert;

export const creditNotes = mysqlTable(
  'credit_notes',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    credit_note_number: varchar('credit_note_number', { length: 32 }).notNull(),
    payment_id: bigint('payment_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => payments.id),
    credit_note_date: date('credit_note_date', { mode: 'string' }).notNull(),
    reason: text('reason'),
    subtotal: decimal('subtotal', { precision: 12, scale: 2 }).notNull().default('0.00'),
    tax_amount: decimal('tax_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    total_amount: decimal('total_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    status: varchar('status', { length: 16 }).notNull().default('draft'),
    journal_entry_id: bigint('journal_entry_id', { mode: 'number', unsigned: true }).references(
      () => journalEntries.id,
    ),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('credit_notes_credit_note_number_unique').on(table.credit_note_number),
    index('credit_notes_payment_id_idx').on(table.payment_id),
    index('credit_notes_status_idx').on(table.status),
  ],
);

export type CreditNote = typeof creditNotes.$inferSelect;
export type NewCreditNote = typeof creditNotes.$inferInsert;

export const debitNotes = mysqlTable(
  'debit_notes',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    debit_note_number: varchar('debit_note_number', { length: 32 }).notNull(),
    purchase_bill_id: bigint('purchase_bill_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => purchaseBills.id),
    debit_note_date: date('debit_note_date', { mode: 'string' }).notNull(),
    reason: text('reason'),
    subtotal: decimal('subtotal', { precision: 12, scale: 2 }).notNull().default('0.00'),
    tax_amount: decimal('tax_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    total_amount: decimal('total_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    status: varchar('status', { length: 16 }).notNull().default('draft'),
    journal_entry_id: bigint('journal_entry_id', { mode: 'number', unsigned: true }).references(
      () => journalEntries.id,
    ),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('debit_notes_debit_note_number_unique').on(table.debit_note_number),
    index('debit_notes_purchase_bill_id_idx').on(table.purchase_bill_id),
    index('debit_notes_status_idx').on(table.status),
  ],
);

export type DebitNote = typeof debitNotes.$inferSelect;
export type NewDebitNote = typeof debitNotes.$inferInsert;

export const debitNoteLines = mysqlTable(
  'debit_note_lines',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    debit_note_id: bigint('debit_note_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => debitNotes.id),
    purchase_bill_line_id: bigint('purchase_bill_line_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => purchaseBillLines.id),
    quantity: decimal('quantity', { precision: 14, scale: 3 }).notNull(),
    net_amount: decimal('net_amount', { precision: 12, scale: 2 }).notNull(),
    tax_amount: decimal('tax_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
  },
  (table) => [
    index('debit_note_lines_debit_note_id_idx').on(table.debit_note_id),
    index('debit_note_lines_purchase_bill_line_id_idx').on(table.purchase_bill_line_id),
  ],
);

export type DebitNoteLine = typeof debitNoteLines.$inferSelect;
export type NewDebitNoteLine = typeof debitNoteLines.$inferInsert;

export const REVENUE_RECOGNITION_STATUSES = ['open', 'paused', 'closed'] as const;
export type RevenueRecognitionStatus = (typeof REVENUE_RECOGNITION_STATUSES)[number];

export const revenueRecognitionSchedules = mysqlTable(
  'revenue_recognition_schedules',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    payment_id: bigint('payment_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => payments.id),
    unearned_account_id: bigint('unearned_account_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accounts.id),
    income_account_id: bigint('income_account_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accounts.id),
    total_amount: decimal('total_amount', { precision: 12, scale: 2 }).notNull(),
    recognized_amount: decimal('recognized_amount', { precision: 12, scale: 2 })
      .notNull()
      .default('0.00'),
    starts_on: date('starts_on', { mode: 'string' }).notNull(),
    ends_on: date('ends_on', { mode: 'string' }).notNull(),
    recognized_through: date('recognized_through', { mode: 'string' }).notNull(),
    status: varchar('status', { length: 16 }).notNull().default('open'),
    paused_from: date('paused_from', { mode: 'string' }),
  },
  (table) => [
    index('revenue_recognition_schedules_payment_id_idx').on(table.payment_id),
    uniqueIndex('revenue_recognition_schedules_payment_id_unique').on(table.payment_id),
    index('revenue_recognition_schedules_status_idx').on(table.status),
  ],
);

export type RevenueRecognitionSchedule = typeof revenueRecognitionSchedules.$inferSelect;
export type NewRevenueRecognitionSchedule = typeof revenueRecognitionSchedules.$inferInsert;

export const revenueRecognitionLines = mysqlTable(
  'revenue_recognition_lines',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    schedule_id: bigint('schedule_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => revenueRecognitionSchedules.id),
    accounting_period_id: bigint('accounting_period_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accountingPeriods.id),
    amount: decimal('amount', { precision: 12, scale: 2 }).notNull(),
    journal_entry_id: bigint('journal_entry_id', { mode: 'number', unsigned: true }).references(
      () => journalEntries.id,
    ),
  },
  (table) => [
    uniqueIndex('revenue_recognition_lines_schedule_period_unique').on(
      table.schedule_id,
      table.accounting_period_id,
    ),
    index('revenue_recognition_lines_schedule_id_idx').on(table.schedule_id),
  ],
);

export type RevenueRecognitionLine = typeof revenueRecognitionLines.$inferSelect;
export type NewRevenueRecognitionLine = typeof revenueRecognitionLines.$inferInsert;

export const FUND_TRANSFER_STATUSES = ['draft', 'posted'] as const;
export type FundTransferStatus = (typeof FUND_TRANSFER_STATUSES)[number];

export const fundTransfers = mysqlTable(
  'fund_transfers',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    transfer_number: varchar('transfer_number', { length: 32 }).notNull(),
    transfer_date: date('transfer_date', { mode: 'string' }).notNull(),
    from_account_id: bigint('from_account_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accounts.id),
    to_account_id: bigint('to_account_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => accounts.id),
    amount: decimal('amount', { precision: 12, scale: 2 }).notNull(),
    fee_amount: decimal('fee_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    fee_account_id: bigint('fee_account_id', { mode: 'number', unsigned: true }).references(
      () => accounts.id,
    ),
    memo: text('memo'),
    status: varchar('status', { length: 16 }).notNull().default('draft'),
    journal_entry_id: bigint('journal_entry_id', { mode: 'number', unsigned: true }).references(
      () => journalEntries.id,
    ),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('fund_transfers_transfer_number_unique').on(table.transfer_number),
    index('fund_transfers_from_account_id_idx').on(table.from_account_id),
    index('fund_transfers_to_account_id_idx').on(table.to_account_id),
    index('fund_transfers_fee_account_id_idx').on(table.fee_account_id),
    index('fund_transfers_status_idx').on(table.status),
  ],
);

export type FundTransfer = typeof fundTransfers.$inferSelect;
export type NewFundTransfer = typeof fundTransfers.$inferInsert;
