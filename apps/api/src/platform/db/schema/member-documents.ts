import { bigint, index, mysqlEnum, mysqlTable, varchar } from 'drizzle-orm/mysql-core';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';
import { users } from './users';

export const DOCUMENT_TYPES = ['id_proof', 'waiver', 'medical_cert'] as const;
export type DocumentType = (typeof DOCUMENT_TYPES)[number];

export const memberDocuments = mysqlTable(
  'member_documents',
  {
    id: bigint('id', { mode: 'number', unsigned: true }).primaryKey().autoincrement(),
    member_id: bigint('member_id', { mode: 'number', unsigned: true })
      .notNull()
      .references(() => members.id),
    document_type: mysqlEnum('document_type', DOCUMENT_TYPES).notNull(),
    title: varchar('title', { length: 255 }),
    /** Object key from MEDIA (ADR-0008); never a BLOB. */
    file_url: varchar('file_url', { length: 1024 }).notNull(),
    file_size: bigint('file_size', { mode: 'number', unsigned: true }),
    verified_by_user_id: bigint('verified_by_user_id', { mode: 'number', unsigned: true }).references(
      () => users.id,
    ),
    verified_at: utcDatetime('verified_at'),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [index('member_documents_member_id_idx').on(table.member_id)],
);

export type MemberDocument = typeof memberDocuments.$inferSelect;
export type NewMemberDocument = typeof memberDocuments.$inferInsert;
