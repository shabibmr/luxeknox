import {
  bigint,
  boolean,
  check,
  doublePrecision,
  jsonb,
  numeric,
  pgTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';
import { utcDatetime } from '../utc-datetime';
import { users } from './users';

export const trainers = pgTable(
  'trainers',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    user_id: bigint('user_id', { mode: 'number' })
      .notNull()
      .references(() => users.id),
    first_name: varchar('first_name', { length: 100 }).notNull(),
    last_name: varchar('last_name', { length: 100 }).notNull(),
    bio: text('bio'),
    /** JSON array of strings. */
    specializations: jsonb('specializations').$type<string[]>(),
    /** Money: NUMERIC(12,2) as string (OpenAPI Money). */
    hourly_rate: numeric('hourly_rate', { precision: 12, scale: 2 }),
    rating: doublePrecision('rating'),
    max_clients_capacity: bigint('max_clients_capacity', { mode: 'number' }),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('trainers_user_id_unique').on(table.user_id),
    // Decision 5 (ADR-0009): PostgreSQL has no unsigned integers. Where unsignedness carried
    // domain meaning, re-assert it explicitly.
    check('trainers_max_clients_capacity_check', sql`${table.max_clients_capacity} >= 0`),
  ],
);

export type Trainer = typeof trainers.$inferSelect;
export type NewTrainer = typeof trainers.$inferInsert;
