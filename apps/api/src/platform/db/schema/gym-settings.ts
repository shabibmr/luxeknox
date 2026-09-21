import { bigint, pgTable, text, uniqueIndex, varchar } from 'drizzle-orm/pg-core';
import { utcDatetime } from '../utc-datetime';

export const gymSettings = pgTable(
  'gym_settings',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    setting_key: varchar('setting_key', { length: 100 }).notNull(),
    setting_value: text('setting_value').notNull(),
    description: varchar('description', { length: 255 }),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    uniqueIndex('gym_settings_setting_key_unique').on(table.setting_key),
  ],
);

export type GymSetting = typeof gymSettings.$inferSelect;
export type NewGymSetting = typeof gymSettings.$inferInsert;
