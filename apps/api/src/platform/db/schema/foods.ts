import {
  bigint,
  boolean,
  double,
  index,
  mysqlTable,
  varchar,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';

export const foods = mysqlTable(
  'foods',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    name: varchar('name', { length: 150 }).notNull(),
    serving_unit: varchar('serving_unit', { length: 50 }).notNull(),
    serving_size: double('serving_size'),
    calories: double('calories'),
    protein_grams: double('protein_grams'),
    carbs_grams: double('carbs_grams'),
    fat_grams: double('fat_grams'),
    fiber_grams: double('fiber_grams'),
    is_verified: boolean('is_verified').notNull().default(false),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('foods_is_active_is_verified_idx').on(table.is_active, table.is_verified),
    index('foods_name_idx').on(table.name),
  ],
);

export type Food = typeof foods.$inferSelect;
export type NewFood = typeof foods.$inferInsert;
