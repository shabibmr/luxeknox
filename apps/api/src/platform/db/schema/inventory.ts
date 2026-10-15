import {
  bigint,
  date,
  decimal,
  index,
  int,
  mysqlTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { accounts, items, journalEntries, taxCodes } from './accounting';
import { members } from './members';
import { paymentMethods } from './payments';

export const COUNTER_SALE_STATUSES = ['posted'] as const;
export type CounterSaleStatus = (typeof COUNTER_SALE_STATUSES)[number];

export const SALES_RETURN_STATUSES = ['posted'] as const;
export type SalesReturnStatus = (typeof SALES_RETURN_STATUSES)[number];

export const STOCK_ADJUSTMENT_REASONS = ['opening', 'count', 'damage', 'expiry', 'other'] as const;
export type StockAdjustmentReason = (typeof STOCK_ADJUSTMENT_REASONS)[number];

export const STOCK_ADJUSTMENT_STATUSES = ['draft', 'posted'] as const;
export type StockAdjustmentStatus = (typeof STOCK_ADJUSTMENT_STATUSES)[number];

export const STOCK_MOVEMENT_SOURCE_TYPES = [
  'purchase_bill',
  'debit_note',
  'counter_sale',
  'counter_sale_return',
  'stock_adjustment',
] as const;
export type StockMovementSourceType = (typeof STOCK_MOVEMENT_SOURCE_TYPES)[number];

export const counterSaleNumberCounters = mysqlTable('counter_sale_number_counters', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number', unsigned: true }).notNull(),
});

export const salesReturnNumberCounters = mysqlTable('sales_return_number_counters', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number', unsigned: true }).notNull(),
});

export const stockAdjustmentNumberCounters = mysqlTable('stock_adjustment_number_counters', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number', unsigned: true }).notNull(),
});

export const itemStock = mysqlTable(
  'item_stock',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    item_id: bigint('item_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => items.id),
    qty_on_hand: decimal('qty_on_hand', { precision: 14, scale: 3 }).notNull().default('0.000'),
    stock_value: decimal('stock_value', { precision: 12, scale: 2 }).notNull().default('0.00'),
    avg_cost: decimal('avg_cost', { precision: 14, scale: 4 }).notNull().default('0.0000'),
    row_version: int('row_version').notNull().default(1),
  },
  (table) => [uniqueIndex('item_stock_item_id_unique').on(table.item_id)],
);

export type ItemStock = typeof itemStock.$inferSelect;
export type NewItemStock = typeof itemStock.$inferInsert;

export const stockMovements = mysqlTable(
  'stock_movements',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    item_id: bigint('item_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => items.id),
    movement_date: date('movement_date', { mode: 'string' }).notNull(),
    source_type: varchar('source_type', { length: 32 }).notNull(),
    source_id: bigint('source_id', { mode: 'number', unsigned: true }).notNull(),
    source_line_id: bigint('source_line_id', { mode: 'number', unsigned: true }),
    qty_in: decimal('qty_in', { precision: 14, scale: 3 }).notNull().default('0.000'),
    qty_out: decimal('qty_out', { precision: 14, scale: 3 }).notNull().default('0.000'),
    unit_cost: decimal('unit_cost', { precision: 14, scale: 4 }).notNull(),
    value: decimal('value', { precision: 12, scale: 2 }).notNull(),
    balance_qty: decimal('balance_qty', { precision: 14, scale: 3 }).notNull(),
    balance_value: decimal('balance_value', { precision: 12, scale: 2 }).notNull(),
    created_at: utcDatetime('created_at').notNull(),
  },
  (table) => [
    index('stock_movements_item_id_movement_date_idx').on(table.item_id, table.movement_date),
    index('stock_movements_source_idx').on(table.source_type, table.source_id),
  ],
);

export type StockMovement = typeof stockMovements.$inferSelect;
export type NewStockMovement = typeof stockMovements.$inferInsert;

export const counterSales = mysqlTable(
  'counter_sales',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    sale_number: varchar('sale_number', { length: 32 }).notNull(),
    sale_date: date('sale_date', { mode: 'string' }).notNull(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true }).references(() => members.id),
    customer_name: varchar('customer_name', { length: 150 }),
    subtotal: decimal('subtotal', { precision: 12, scale: 2 }).notNull().default('0.00'),
    discount_amount: decimal('discount_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    tax_amount: decimal('tax_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    total_amount: decimal('total_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    cogs_amount: decimal('cogs_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    status: varchar('status', { length: 16 }).notNull().default('posted'),
    journal_entry_id: bigint('journal_entry_id', { mode: 'number', unsigned: true }).references(
      () => journalEntries.id,
    ),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('counter_sales_sale_number_unique').on(table.sale_number),
    index('counter_sales_sale_date_idx').on(table.sale_date),
    index('counter_sales_member_id_idx').on(table.member_id),
  ],
);

export type CounterSale = typeof counterSales.$inferSelect;
export type NewCounterSale = typeof counterSales.$inferInsert;

export const counterSaleLines = mysqlTable(
  'counter_sale_lines',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    counter_sale_id: bigint('counter_sale_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => counterSales.id),
    item_id: bigint('item_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => items.id),
    quantity: decimal('quantity', { precision: 14, scale: 3 }).notNull(),
    rate: decimal('rate', { precision: 12, scale: 2 }).notNull(),
    discount_amount: decimal('discount_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    tax_code_id: bigint('tax_code_id', { mode: 'number', unsigned: true }).references(() => taxCodes.id),
    net_amount: decimal('net_amount', { precision: 12, scale: 2 }).notNull(),
    tax_amount: decimal('tax_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    unit_cost: decimal('unit_cost', { precision: 14, scale: 4 }),
    cost_amount: decimal('cost_amount', { precision: 12, scale: 2 }),
  },
  (table) => [
    index('counter_sale_lines_counter_sale_id_idx').on(table.counter_sale_id),
    index('counter_sale_lines_item_id_idx').on(table.item_id),
  ],
);

export type CounterSaleLine = typeof counterSaleLines.$inferSelect;
export type NewCounterSaleLine = typeof counterSaleLines.$inferInsert;

export const counterSaleTenders = mysqlTable(
  'counter_sale_tenders',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    counter_sale_id: bigint('counter_sale_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => counterSales.id),
    payment_method_id: bigint('payment_method_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => paymentMethods.id),
    amount: decimal('amount', { precision: 12, scale: 2 }).notNull(),
    reference: varchar('reference', { length: 150 }),
  },
  (table) => [index('counter_sale_tenders_counter_sale_id_idx').on(table.counter_sale_id)],
);

export type CounterSaleTender = typeof counterSaleTenders.$inferSelect;
export type NewCounterSaleTender = typeof counterSaleTenders.$inferInsert;

export const salesReturns = mysqlTable(
  'sales_returns',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    return_number: varchar('return_number', { length: 32 }).notNull(),
    counter_sale_id: bigint('counter_sale_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => counterSales.id),
    return_date: date('return_date', { mode: 'string' }).notNull(),
    reason: text('reason'),
    subtotal: decimal('subtotal', { precision: 12, scale: 2 }).notNull().default('0.00'),
    tax_amount: decimal('tax_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    total_amount: decimal('total_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    cogs_amount: decimal('cogs_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    status: varchar('status', { length: 16 }).notNull().default('posted'),
    journal_entry_id: bigint('journal_entry_id', { mode: 'number', unsigned: true }).references(
      () => journalEntries.id,
    ),
    row_version: int('row_version').notNull().default(1),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('sales_returns_return_number_unique').on(table.return_number),
    index('sales_returns_counter_sale_id_idx').on(table.counter_sale_id),
    index('sales_returns_return_date_idx').on(table.return_date),
  ],
);

export type SalesReturn = typeof salesReturns.$inferSelect;
export type NewSalesReturn = typeof salesReturns.$inferInsert;

export const salesReturnLines = mysqlTable(
  'sales_return_lines',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    sales_return_id: bigint('sales_return_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => salesReturns.id),
    counter_sale_line_id: bigint('counter_sale_line_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => counterSaleLines.id),
    quantity: decimal('quantity', { precision: 14, scale: 3 }).notNull(),
    net_amount: decimal('net_amount', { precision: 12, scale: 2 }).notNull(),
    tax_amount: decimal('tax_amount', { precision: 12, scale: 2 }).notNull().default('0.00'),
    cost_amount: decimal('cost_amount', { precision: 12, scale: 2 }),
  },
  (table) => [
    index('sales_return_lines_sales_return_id_idx').on(table.sales_return_id),
    index('sales_return_lines_counter_sale_line_id_idx').on(table.counter_sale_line_id),
  ],
);

export type SalesReturnLine = typeof salesReturnLines.$inferSelect;
export type NewSalesReturnLine = typeof salesReturnLines.$inferInsert;

export const salesReturnTenders = mysqlTable(
  'sales_return_tenders',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    sales_return_id: bigint('sales_return_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => salesReturns.id),
    payment_method_id: bigint('payment_method_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => paymentMethods.id),
    amount: decimal('amount', { precision: 12, scale: 2 }).notNull(),
    reference: varchar('reference', { length: 150 }),
  },
  (table) => [index('sales_return_tenders_sales_return_id_idx').on(table.sales_return_id)],
);

export type SalesReturnTender = typeof salesReturnTenders.$inferSelect;
export type NewSalesReturnTender = typeof salesReturnTenders.$inferInsert;

export const stockAdjustments = mysqlTable(
  'stock_adjustments',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    adjustment_number: varchar('adjustment_number', { length: 32 }).notNull(),
    adjustment_date: date('adjustment_date', { mode: 'string' }).notNull(),
    reason: varchar('reason', { length: 16 }).notNull(),
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
    uniqueIndex('stock_adjustments_adjustment_number_unique').on(table.adjustment_number),
    index('stock_adjustments_adjustment_date_idx').on(table.adjustment_date),
    index('stock_adjustments_status_idx').on(table.status),
  ],
);

export type StockAdjustment = typeof stockAdjustments.$inferSelect;
export type NewStockAdjustment = typeof stockAdjustments.$inferInsert;

export const stockAdjustmentLines = mysqlTable(
  'stock_adjustment_lines',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    stock_adjustment_id: bigint('stock_adjustment_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => stockAdjustments.id),
    item_id: bigint('item_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => items.id),
    qty_delta: decimal('qty_delta', { precision: 14, scale: 3 }).notNull(),
    unit_cost: decimal('unit_cost', { precision: 14, scale: 4 }),
    value: decimal('value', { precision: 12, scale: 2 }).notNull(),
  },
  (table) => [
    index('stock_adjustment_lines_stock_adjustment_id_idx').on(table.stock_adjustment_id),
    index('stock_adjustment_lines_item_id_idx').on(table.item_id),
  ],
);

export type StockAdjustmentLine = typeof stockAdjustmentLines.$inferSelect;
export type NewStockAdjustmentLine = typeof stockAdjustmentLines.$inferInsert;
