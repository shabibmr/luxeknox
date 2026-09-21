import { bigint, boolean, index, pgTable, varchar } from 'drizzle-orm/pg-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';

export const memberPhotos = pgTable(
  'member_photos',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    member_id: bigint('member_id', { mode: 'number' })
      .notNull()
      .references(() => members.id),
    /** Object key from MEDIA (ADR-0008); never a BLOB. */
    photo_url: varchar('photo_url', { length: 1024 }).notNull(),
    is_current_avatar: boolean('is_current_avatar').notNull().default(false),
    captured_at: utcDatetime('captured_at').notNull(),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  // Partial unique index `one_current_avatar_per_member` (BR-PEOPLE-004) added in PG-17 —
  // see 0006_partial_unique_indexes.sql.
  (table) => [index('member_photos_member_id_idx').on(table.member_id)],
);

export type MemberPhoto = typeof memberPhotos.$inferSelect;
export type NewMemberPhoto = typeof memberPhotos.$inferInsert;
