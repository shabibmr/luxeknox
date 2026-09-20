import {
  bigint,
  boolean,
  date,
  index,
  mysqlTable,
  text,
  uniqueIndex,
  varchar,
} from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { users } from './users';
import { trainers } from './trainers';

/**
 * Single-row counter for membership_number allocation.
 * Allocate inside the person-create TX with `SELECT … FOR UPDATE`, then
 * format as `M` + 8 zero-padded digits (M00000001, …). Immutable after insert
 * on `members.membership_number` (API must not update the column).
 */
export const membershipNumberCounters = mysqlTable('membership_number_counters', {
  id: bigint('id', { mode: 'number', unsigned: true }).primaryKey(),
  next_value: bigint('next_value', { mode: 'number', unsigned: true }).notNull(),
});

export const members = mysqlTable(
  'members',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    user_id: bigint('user_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => users.id),
    membership_number: varchar('membership_number', { length: 16 }).notNull(),
    first_name: varchar('first_name', { length: 100 }).notNull(),
    last_name: varchar('last_name', { length: 100 }).notNull(),
    gender: varchar('gender', { length: 32 }),
    date_of_birth: date('date_of_birth', { mode: 'string' }),
    address: text('address'),
    assigned_trainer_id: bigint('assigned_trainer_id', { mode: 'number', unsigned: true }).references(
      () => trainers.id,
    ),
    joined_date: date('joined_date', { mode: 'string' }).notNull(),
    notes: text('notes'),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('members_user_id_unique').on(table.user_id),
    uniqueIndex('members_membership_number_unique').on(table.membership_number),
    index('members_assigned_trainer_id_idx').on(table.assigned_trainer_id),
  ],
);

export type Member = typeof members.$inferSelect;
export type NewMember = typeof members.$inferInsert;

export const emergencyContacts = mysqlTable(
  'emergency_contacts',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    user_id: bigint('user_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => users.id),
    contact_name: varchar('contact_name', { length: 150 }).notNull(),
    relationship: varchar('relationship', { length: 100 }),
    phone_primary: varchar('phone_primary', { length: 32 }).notNull(),
    phone_secondary: varchar('phone_secondary', { length: 32 }),
    is_primary: boolean('is_primary').notNull().default(false),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [index('emergency_contacts_user_id_idx').on(table.user_id)],
);

export type EmergencyContact = typeof emergencyContacts.$inferSelect;
export type NewEmergencyContact = typeof emergencyContacts.$inferInsert;
