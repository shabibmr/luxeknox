import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { MemberRepository } from '../people/member.repository';
import { assertMemberAccess } from '../people/row-scope';
import { AuditService } from '../platform/audit/audit.service';
import type { NewProgressPhoto, ProgressPhoto } from '../platform/db/schema/goals';
import { ForbiddenError, NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import type {
  ProgressPhotoComparisonQueryDto,
  ProgressPhotoFilterQueryDto,
  ProgressPhotoWriteDto,
} from './goal.dto';
import { ProgressPhotoRepository } from './progress-photo.repository';

export interface ProgressPhotoComparisonResult {
  date1: string;
  date2: string;
  date1_photos: ProgressPhoto[];
  date2_photos: ProgressPhoto[];
  comparison_by_pose: {
    front?: { date1?: ProgressPhoto; date2?: ProgressPhoto };
    side?: { date1?: ProgressPhoto; date2?: ProgressPhoto };
    back?: { date1?: ProgressPhoto; date2?: ProgressPhoto };
  };
}

@Injectable()
export class ProgressPhotoService {
  constructor(
    private readonly repository: ProgressPhotoRepository,
    private readonly memberRepo: MemberRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
  ) {}

  async canViewPrivatePhotos(actor: AuthenticatedUser, memberId: number): Promise<boolean> {
    if (actor.userType === 'member' && actor.profileId === memberId) {
      return true;
    }
    if (actor.userType === 'trainer') {
      const member = await this.memberRepo.findById(memberId);
      return member?.assigned_trainer_id === actor.profileId;
    }
    if (actor.userType === 'admin') {
      return true;
    }
    return false;
  }

  async listPhotos(
    memberId: number,
    rawQuery: Record<string, unknown>,
    filter: ProgressPhotoFilterQueryDto,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<ProgressPhoto>> {
    await assertMemberAccess(this.memberRepo, actor, memberId);
    const includePrivate = await this.canViewPrivatePhotos(actor, memberId);

    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findManyByMemberId(memberId, {
      pose: filter.pose,
      includePrivate,
      limit: pagination.limit,
      offset,
    });

    return createPaginatedResponse({
      items: rows,
      total,
      limit: pagination.limit,
      offset,
    });
  }

  async createPhoto(
    memberId: number,
    dto: ProgressPhotoWriteDto,
    actor: AuthenticatedUser,
  ): Promise<ProgressPhoto> {
    await assertMemberAccess(this.memberRepo, actor, memberId);

    if (actor.userType === 'member' && actor.profileId !== memberId) {
      throw new ForbiddenError('Cannot upload photos for another member');
    }

    const now = new Date();
    const takenDate = dto.taken_date ?? now.toISOString().slice(0, 10);

    const newPhoto: NewProgressPhoto = {
      member_id: memberId,
      photo_url: dto.photo_url,
      pose: dto.pose,
      taken_date: takenDate,
      is_private: dto.is_private ?? false,
      created_at: now,
    };

    const created = await this.repository.create(newPhoto);

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'create',
      entityName: 'progress_photos',
      entityId: created.id,
      afterState: created,
    });

    return created;
  }

  async deletePhoto(photoId: number, actor: AuthenticatedUser): Promise<void> {
    const photo = await this.repository.findById(photoId);
    if (!photo) {
      throw new NotFoundError(`Progress photo with id ${photoId} not found`);
    }

    // Member can delete own, or admin can moderate/delete
    const isOwner = actor.userType === 'member' && actor.profileId === photo.member_id;
    const isAdmin = actor.userType === 'admin';

    if (!isOwner && !isAdmin) {
      throw new ForbiddenError('Only the owner or an admin may delete progress photos');
    }

    await this.repository.deleteById(photoId);

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'delete',
      entityName: 'progress_photos',
      entityId: photoId,
      beforeState: photo,
    });
  }

  async getComparison(
    memberId: number,
    query: ProgressPhotoComparisonQueryDto,
    actor: AuthenticatedUser,
  ): Promise<ProgressPhotoComparisonResult> {
    await assertMemberAccess(this.memberRepo, actor, memberId);
    const includePrivate = await this.canViewPrivatePhotos(actor, memberId);

    const photos = await this.repository.findComparisonByDates(
      memberId,
      query.date1,
      query.date2,
      includePrivate,
    );

    const date1Photos = photos.filter((p) => p.taken_date === query.date1);
    const date2Photos = photos.filter((p) => p.taken_date === query.date2);

    const comparisonByPose: ProgressPhotoComparisonResult['comparison_by_pose'] = {
      front: {
        date1: date1Photos.find((p) => p.pose === 'front'),
        date2: date2Photos.find((p) => p.pose === 'front'),
      },
      side: {
        date1: date1Photos.find((p) => p.pose === 'side'),
        date2: date2Photos.find((p) => p.pose === 'side'),
      },
      back: {
        date1: date1Photos.find((p) => p.pose === 'back'),
        date2: date2Photos.find((p) => p.pose === 'back'),
      },
    };

    return {
      date1: query.date1,
      date2: query.date2,
      date1_photos: date1Photos,
      date2_photos: date2Photos,
      comparison_by_pose: comparisonByPose,
    };
  }
}
