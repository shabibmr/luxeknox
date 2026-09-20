import { Inject, Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import { DRIZZLE_DB_TOKEN } from '../platform/db/drizzle.module';
import type { DrizzleDb } from '../platform/db/client';
import { runInTransaction } from '../platform/db/transaction-context';
import type { MemberPhoto } from '../platform/db/schema/member-photos';
import { NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { MemberRepository } from './member.repository';
import { MemberPhotoRepository } from './member-photo.repository';
import type { MemberPhotoWriteDto } from './member-photo.dto';
import { requireScopedMember } from './require-scoped-member';

@Injectable()
export class MemberPhotoService {
  constructor(
    private readonly memberRepository: MemberRepository,
    private readonly photoRepository: MemberPhotoRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
    @Inject(DRIZZLE_DB_TOKEN)
    private readonly db: DrizzleDb<any>,
  ) {}

  async list(
    memberId: number,
    rawQuery: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<MemberPhoto>> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.photoRepository.findManyForMember(
      memberId,
      pagination.limit,
      offset,
    );

    return createPaginatedResponse({
      items: rows,
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async create(
    memberId: number,
    dto: MemberPhotoWriteDto,
    actor: AuthenticatedUser,
  ): Promise<MemberPhoto> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const now = new Date();
    const id = await this.photoRepository.insertPhoto({
      member_id: memberId,
      photo_url: dto.photo_url,
      is_current_avatar: false,
      captured_at: now,
      created_at: now,
      updated_at: null,
    });
    const created = await this.photoRepository.findById(id);
    if (!created) throw new NotFoundError('Photo not found after create');

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'member_photo.created',
      entityName: 'member_photos',
      entityId: id,
      afterState: created,
    });

    return created;
  }

  async setAvatar(
    memberId: number,
    photoId: number,
    actor: AuthenticatedUser,
  ): Promise<MemberPhoto> {
    const member = await requireScopedMember(this.memberRepository, memberId, actor);
    const photo = await this.photoRepository.findByIdForMember(photoId, memberId);
    if (!photo) {
      throw new NotFoundError('Photo not found');
    }

    const now = new Date();
    await runInTransaction(this.db, async () => {
      await this.photoRepository.clearCurrentAvatars(memberId, now);
      await this.photoRepository.markCurrentAvatar(photoId, now);
      // App avatar lives on users.avatar_url; store object key / relative media reference.
      await this.photoRepository.setUserAvatarUrl(member.user_id, photo.photo_url, now);
    });

    const after = await this.photoRepository.findById(photoId);
    if (!after) throw new NotFoundError('Photo not found after avatar set');

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'member_photo.avatar_set',
      entityName: 'member_photos',
      entityId: photoId,
      afterState: after,
    });

    return after;
  }
}
