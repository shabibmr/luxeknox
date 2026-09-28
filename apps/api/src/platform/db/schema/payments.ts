import {
  bigint,
  boolean,
  index,
  integer,
  numeric,
  pgTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/pg-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';
import { memberships } from './memberships';
import { users } from './users';

export const PAYMENT_STATUSES = ['pending', 'partial', 'paid', 'refunded'] as const;
export type PaymentStatus = (typeof PAYMENT_STATUSES)[number];

export const PAYMENT_HISTORY_ACTIONS = ['payment_received', 'refunded', 'adjusted'] as const;
export type PaymentHistoryAction = (typeof PAYMENT_HISTORY_ACTIONS)[number];

/** Single-row counter for invoice numbers (PAY-003), mirrors membership_number_counters. */
export const invoiceNumberCounters = pgTable('invoice_number_counters', {
  id: bigint('id', { mode: 'number' }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number' }).notNull(),
});

/** Single-row counter for receipt numbers (PAY-011). */
export const receiptNumberCounters = pgTable('receipt_number_counters', {
  id: bigint('id', { mode: 'number' }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number' }).notNull(),
});

export const paymentMethods = pgTable(
  'payment_methods',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    method_name: varchar('method_name', { length: 100 }).notNull(),
    is_digital: boolean('is_digital').notNull().default(false),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('payment_methods_method_name_unique').on(table.method_name),
    index('payment_methods_is_active_idx').on(table.is_active),
  ],
);

export type PaymentMethod = typeof paymentMethods.$inferSelect;
export type NewPaymentMethod = typeof paymentMethods.$inferInsert;

export const payments = pgTable(
  'payments',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    invoice_number: varchar('invoice_number', { length: 32 }).notNull(),
    member_id: bigint('member_id', { mode: 'number' })
      .notNull()
      .references(() => members.id),
    membership_id: bigint('membership_id', { mode: 'number' }).references(
      () => memberships.id,
    ),
    payment_method_id: bigint('payment_method_id', { mode: 'number' }).references(
      () => paymentMethods.id,
    ),
    subtotal: numeric('subtotal', { precision: 12, scale: 2 }).notNull(),
    tax_amount: numeric('tax_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    discount_amount: numeric('discount_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    total_amount: numeric('total_amount', { precision: 12, scale: 2 }).notNull(),
    amount_paid: numeric('amount_paid', { precision: 12, scale: 2 }).notNull().default('0.00'),
    status: varchar('status', { length: 16 }).notNull().default('pending'),
    transaction_reference: varchar('transaction_reference', { length: 150 }),
    cashier_user_id: bigint('cashier_user_id', { mode: 'number' }).references(
      () => users.id,
    ),
    payment_date: utcDatetime('payment_date').notNull(),
    row_version: integer('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('payments_invoice_number_unique').on(table.invoice_number),
    index('payments_member_id_idx').on(table.member_id),
    index('payments_status_idx').on(table.status),
    index('payments_payment_date_idx').on(table.payment_date),
  ],
);

export type Payment = typeof payments.$inferSelect;
export type NewPayment = typeof payments.$inferInsert;

export const paymentHistories = pgTable(
  'payment_histories',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    payment_id: bigint('payment_id', { mode: 'number' })
      .notNull()
      .references(() => payments.id),
    payment_method_id: bigint('payment_method_id', { mode: 'number' }).references(
      () => paymentMethods.id,
    ),
    action: varchar('action', { length: 32 }).notNull(),
    amount: numeric('amount', { precision: 12, scale: 2 }).notNull(),
    notes: text('notes'),
    timestamp: utcDatetime('timestamp').notNull(),
  },
  (table) => [index('payment_histories_payment_id_idx').on(table.payment_id)],
);

export type PaymentHistory = typeof paymentHistories.$inferSelect;
export type NewPaymentHistory = typeof paymentHistories.$inferInsert;

export const paymentReceipts = pgTable(
  'payment_receipts',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    payment_id: bigint('payment_id', { mode: 'number' })
      .notNull()
      .references(() => payments.id),
    receipt_number: varchar('receipt_number', { length: 32 }).notNull(),
    receipt_pdf_url: varchar('receipt_pdf_url', { length: 512 }),
    generated_at: utcDatetime('generated_at').notNull(),
  },
  (table) => [
    uniqueIndex('payment_receipts_payment_id_unique').on(table.payment_id),
    uniqueIndex('payment_receipts_receipt_number_unique').on(table.receipt_number),
  ],
);

export type PaymentReceipt = typeof paymentReceipts.$inferSelect;
export type NewPaymentReceipt = typeof paymentReceipts.$inferInsert;
