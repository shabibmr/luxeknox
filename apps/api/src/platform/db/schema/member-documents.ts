import { bigint, check, index, pgEnum, pgTable, varchar } from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';
import { utcDatetime } from '../utc-datetime';
import { members } from './members';
import { users } from './users';

export const DOCUMENT_TYPES = ['id_proof', 'waiver', 'medical_cert'] as const;
export type DocumentType = (typeof DOCUMENT_TYPES)[number];

export const documentTypeEnum = pgEnum('document_type', DOCUMENT_TYPES);

export const memberDocuments = pgTable(
  'member_documents',
  {
    id: bigint('id', { mode: 'number' }).primaryKey().generatedAlwaysAsIdentity(),
    member_id: bigint('member_id', { mode: 'number' })
      .notNull()
      .references(() => members.id),
    document_type: documentTypeEnum('document_type').notNull(),
    title: varchar('title', { length: 255 }),
    /** Object key from MEDIA (ADR-0008); never a BLOB. */
    file_url: varchar('file_url', { length: 1024 }).notNull(),
    file_size: bigint('file_size', { mode: 'number' }),
    verified_by_user_id: bigint('verified_by_user_id', { mode: 'number' }).references(
      () => users.id,
    ),
    verified_at: utcDatetime('verified_at'),
    created_at: utcDatetime('created_at').notNull(),
    updated_at: utcDatetime('updated_at'),
  },
  (table) => [
    index('member_documents_member_id_idx').on(table.member_id),
    // Decision 5 (ADR-0009): re-assert the lost UNSIGNED domain meaning explicitly.
    check('member_documents_file_size_check', sql`${table.file_size} >= 0`),
  ],
);

export type MemberDocument = typeof memberDocuments.$inferSelect;
export type NewMemberDocument = typeof memberDocuments.$inferInsert;
