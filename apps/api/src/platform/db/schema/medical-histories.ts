import { bigint, index, mysqlTable, text, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';

export const medicalHistories = mysqlTable(
  'medical_histories',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id, { onDelete: 'cascade' }),
    condition_id: bigint('condition_id', { mode: 'number', unsigned: true }),
    title: varchar('title', { length: 255 }).notNull(),
    description: text('description'),
    diagnosed_date: varchar('diagnosed_date', { length: 10 }),
    clearance_status: varchar('clearance_status', { length: 64 }),
    document_key: varchar('document_key', { length: 255 }),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('medical_histories_member_id_idx').on(table.member_id),
  ],
);

export type MedicalHistory = typeof medicalHistories.$inferSelect;
export type NewMedicalHistory = typeof medicalHistories.$inferInsert;
