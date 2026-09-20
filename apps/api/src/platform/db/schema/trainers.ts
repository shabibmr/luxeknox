import {
  bigint,
  boolean,
  decimal,
  double,
  json,
  mysqlTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { users } from './users';

export const trainers = mysqlTable(
  'trainers',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    user_id: bigint('user_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => users.id),
    first_name: varchar('first_name', { length: 100 }).notNull(),
    last_name: varchar('last_name', { length: 100 }).notNull(),
    bio: text('bio'),
    /** JSON array of strings; MariaDB may persist as TEXT — normalize on read like secondary_muscles. */
    specializations: json('specializations').$type<string[]>(),
    /** Money: DECIMAL(12,2) as string (OpenAPI Money). */
    hourly_rate: decimal('hourly_rate', { precision: 12, scale: 2 }),
    rating: double('rating'),
    max_clients_capacity: bigint('max_clients_capacity', { mode: 'number', unsigned: true }),
    is_active: boolean('is_active').notNull().default(true),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [uniqueIndex('trainers_user_id_unique').on(table.user_id)],
);

export type Trainer = typeof trainers.$inferSelect;
export type NewTrainer = typeof trainers.$inferInsert;
