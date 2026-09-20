import { Inject, Injectable } from '@nestjs/common';
import { count, eq } from 'drizzle-orm';
import { BaseRepository } from '../platform/db/base.repository';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import {
  memberPhotos,
  type MemberPhoto,
  type NewMemberPhoto,
} from '../platform/db/schema/member-photos';
import { users } from '../platform/db/schema/users';

@Injectable()
export class MemberPhotoRepository extends BaseRepository<
  typeof memberPhotos,
  MemberPhoto,
  NewMemberPhoto
> {
  constructor(@Inject(DRIZZLE_DB_TOKEN) db: DrizzleDb<any>) {
    super(db, memberPhotos);
  }

  async findManyForMember(
    memberId: number,
    limit: number,
    offset: number,
  ): Promise<{ rows: MemberPhoto[]; total: number }> {
    const db = this.getDb() as any;
    const where = eq(memberPhotos.member_id, memberId);
    const [rows, countRows] = await Promise.all([
      db.select().from(memberPhotos).where(where).limit(limit).offset(offset),
      db.select({ value: count() }).from(memberPhotos).where(where),
    ]);
    return {
      rows: rows as MemberPhoto[],
      total: Number(countRows[0]?.value ?? 0),
    };
  }

  async findByIdForMember(id: number, memberId: number): Promise<MemberPhoto | null> {
    const row = await this.findById(id);
    if (!row || row.member_id !== memberId) return null;
    return row;
  }

  async insertPhoto(values: NewMemberPhoto): Promise<number> {
    const result = await this.create(values);
    return Number(result?.[0]?.insertId ?? 0);
  }

  /** Clears all current-avatar flags for the member (call inside a TX). */
  async clearCurrentAvatars(memberId: number, at: Date): Promise<void> {
    await (this.getDb() as any)
      .update(memberPhotos)
      .set({ is_current_avatar: false, updated_at: at })
      .where(eq(memberPhotos.member_id, memberId));
  }

  async markCurrentAvatar(photoId: number, at: Date): Promise<void> {
    await (this.getDb() as any)
      .update(memberPhotos)
      .set({ is_current_avatar: true, updated_at: at })
      .where(eq(memberPhotos.id, photoId));
  }

  async setUserAvatarUrl(userId: number, avatarUrl: string, at: Date): Promise<void> {
    await (this.getDb() as any)
      .update(users)
      .set({ avatar_url: avatarUrl, updated_at: at })
      .where(eq(users.id, userId));
  }
}
