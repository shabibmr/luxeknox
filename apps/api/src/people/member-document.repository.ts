import { Inject, Injectable } from '@nestjs/common';
import { and, count, eq, ne, type SQL } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  memberDocuments,
  type MemberDocument,
  type NewMemberDocument,
} from '../platform/db/schema/member-documents';

export interface MemberDocumentListOptions {
  memberId: number;
  /** When true, exclude id_proof rows (BR-HEALTH-001 trainers). */
  hideIdProof: boolean;
  limit: number;
  offset: number;
}

@Injectable()
export class MemberDocumentRepository extends BaseRepository<
  typeof memberDocuments,
  MemberDocument,
  NewMemberDocument
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, memberDocuments);
  }

  private listWhere(memberId: number, hideIdProof: boolean): SQL {
    if (hideIdProof) {
      return and(
        eq(memberDocuments.member_id, memberId),
        ne(memberDocuments.document_type, 'id_proof'),
      ) as SQL;
    }
    return eq(memberDocuments.member_id, memberId);
  }

  async findManyForMember(
    opts: MemberDocumentListOptions,
  ): Promise<{ rows: MemberDocument[]; total: number }> {
    const db = this.getDb() as any;
    const where = this.listWhere(opts.memberId, opts.hideIdProof);
    const [rows, countRows] = await Promise.all([
      db
        .select()
        .from(memberDocuments)
        .where(where)
        .limit(opts.limit)
        .offset(opts.offset),
      db.select({ value: count() }).from(memberDocuments).where(where),
    ]);
    return {
      rows: rows as MemberDocument[],
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  async findByIdForMember(id: number, memberId: number): Promise<MemberDocument | null> {
    const row = await this.findById(id);
    if (!row || row.member_id !== memberId) return null;
    return row;
  }

  async insertDocument(values: NewMemberDocument): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  async markVerified(
    id: number,
    verifiedByUserId: number,
    at: Date,
  ): Promise<void> {
    await this.update(eq(memberDocuments.id, id), {
      verified_by_user_id: verifiedByUserId,
      verified_at: at,
      updated_at: at,
    });
  }

  async deleteDocument(id: number): Promise<void> {
    await (this.getDb() as any).delete(memberDocuments).where(eq(memberDocuments.id, id));
  }
}
