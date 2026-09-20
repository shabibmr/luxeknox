import { bigint, boolean, index, mysqlTable, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';

export const memberPhotos = mysqlTable(
  'member_photos',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id),
    /** Object key from MEDIA (ADR-0008); never a BLOB. */
    photo_url: varchar('photo_url', { length: 1024 }).notNull(),
    is_current_avatar: boolean('is_current_avatar').notNull().default(false),
    captured_at: utcDatetime('captured_at').notNull(),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [index('member_photos_member_id_idx').on(table.member_id)],
);

export type MemberPhoto = typeof memberPhotos.$inferSelect;
export type NewMemberPhoto = typeof memberPhotos.$inferInsert;
