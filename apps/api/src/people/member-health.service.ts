import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import { NotFoundError } from '../platform/errors/app-error';
import type { MemberHealth } from '../platform/db/schema/member-health';
import { MemberRepository } from './member.repository';
import { MemberHealthRepository } from './member-health.repository';
import type { MemberHealthRecordDto, MemberHealthWriteDto } from './member-health.dto';
import { requireScopedMember } from './require-scoped-member';

@Injectable()
export class MemberHealthService {
  constructor(
    private readonly healthRepository: MemberHealthRepository,
    private readonly memberRepository: MemberRepository,
    private readonly auditService: AuditService,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toDto(row: MemberHealth): MemberHealthRecordDto {
    return {
      id: row.id,
      member_id: row.member_id,
      blood_group: row.blood_group ?? null,
      height_cm: row.height_cm ?? null,
      baseline_weight_kg: row.baseline_weight_kg ?? null,
      allergies: row.allergies ?? null,
      dietary_preferences: row.dietary_preferences ?? null,
      physician_name: row.physician_name ?? null,
      physician_phone: row.physician_phone ?? null,
      recorded_at: row.recorded_at.toISOString(),
    };
  }

  async list(
    memberId: number,
    query: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<MemberHealthRecordDto>> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const pagination = await this.paginationHelper.normalizeParams(query);
    const offset = pagination.offset ?? 0;
    const { rows, total } = await this.healthRepository.findManyByMemberId(memberId, {
      limit: pagination.limit,
      offset,
    });
    return createPaginatedResponse({
      items: rows.map((r) => this.toDto(r)),
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async create(
    memberId: number,
    dto: MemberHealthWriteDto,
    actor: AuthenticatedUser,
  ): Promise<MemberHealthRecordDto> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const now = new Date();
    const id = await this.healthRepository.insertRecord({
      member_id: memberId,
      blood_group: dto.blood_group ?? null,
      height_cm: dto.height_cm ?? null,
      baseline_weight_kg: dto.baseline_weight_kg ?? null,
      allergies: dto.allergies ?? null,
      dietary_preferences: dto.dietary_preferences ?? null,
      physician_name: dto.physician_name ?? null,
      physician_phone: dto.physician_phone ?? null,
      recorded_at: now,
      created_at: now,
    });

    const created = await this.healthRepository.findByIdAndMemberId(id, memberId);
    if (!created) {
      throw new NotFoundError('Member health record not found after creation');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'member_health.recorded',
      entityName: 'member_health',
      entityId: id,
      afterState: created,
    });

    return this.toDto(created);
  }
}
