import { bigint, doublePrecision, pgTable, text, uniqueIndex, varchar } from 'drizzle-orm/pg-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';

export const memberHealth = pgTable(
  'member_health',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    member_id: bigint('member_id', { mode: 'number' })
      .notNull()
      .references(() => members.id),
    blood_group: varchar('blood_group', { length: 16 }),
    height_cm: doublePrecision('height_cm'),
    baseline_weight_kg: doublePrecision('baseline_weight_kg'),
    allergies: text('allergies'),
    dietary_preferences: text('dietary_preferences'),
    physician_name: varchar('physician_name', { length: 150 }),
    physician_phone: varchar('physician_phone', { length: 32 }),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [uniqueIndex('member_health_member_id_unique').on(table.member_id)],
);

export type MemberHealth = typeof memberHealth.$inferSelect;
export type NewMemberHealth = typeof memberHealth.$inferInsert;
