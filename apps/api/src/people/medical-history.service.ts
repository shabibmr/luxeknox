import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import { NotFoundError } from '../platform/errors/app-error';
import type { MedicalHistory } from '../platform/db/schema/medical-histories';
import { MemberRepository } from './member.repository';
import { MedicalHistoryRepository } from './medical-history.repository';
import type {
  MedicalHistoryDto,
  MedicalHistoryUpdateDto,
  MedicalHistoryWriteDto,
} from './medical-history.dto';
import { requireScopedMember } from './require-scoped-member';

@Injectable()
export class MedicalHistoryService {
  constructor(
    private readonly repository: MedicalHistoryRepository,
    private readonly memberRepository: MemberRepository,
    private readonly auditService: AuditService,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toDto(row: MedicalHistory): MedicalHistoryDto {
    return {
      id: row.id,
      member_id: row.member_id,
      condition_id: row.condition_id ?? null,
      title: row.title,
      description: row.description ?? null,
      diagnosed_date: row.diagnosed_date ?? null,
      clearance_status: row.clearance_status ?? null,
      document_url: row.document_key ?? null,
    };
  }

  async list(
    memberId: number,
    query: Record<string, unknown>,
    actor: AuthenticatedUser,
  ): Promise<PaginatedResponse<MedicalHistoryDto>> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const pagination = await this.paginationHelper.normalizeParams(query);
    const offset = pagination.offset ?? 0;
    const { rows, total } = await this.repository.findManyByMemberId(memberId, {
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
    dto: MedicalHistoryWriteDto,
    actor: AuthenticatedUser,
  ): Promise<MedicalHistoryDto> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const now = new Date();
    const id = await this.repository.insertHistory({
      member_id: memberId,
      condition_id: dto.condition_id ?? null,
      title: dto.title,
      description: dto.description ?? null,
      diagnosed_date: dto.diagnosed_date ?? null,
      clearance_status: dto.clearance_status ?? null,
      document_key: null,
      created_at: now,
      updated_at: now,
    });

    const created = await this.repository.findByIdAndMemberId(id, memberId);
    if (!created) {
      throw new NotFoundError('Medical history record not found after creation');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'medical_history.created',
      entityName: 'medical_histories',
      entityId: id,
      afterState: created,
    });

    return this.toDto(created);
  }

  async update(
    memberId: number,
    historyId: number,
    dto: MedicalHistoryUpdateDto,
    actor: AuthenticatedUser,
  ): Promise<MedicalHistoryDto> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const before = await this.repository.findByIdAndMemberId(historyId, memberId);
    if (!before) {
      throw new NotFoundError('Medical history record not found');
    }

    const now = new Date();
    await this.repository.updateHistory(historyId, memberId, {
      condition_id: dto.condition_id !== undefined ? dto.condition_id : before.condition_id,
      title: dto.title !== undefined ? dto.title : before.title,
      description: dto.description !== undefined ? dto.description : before.description,
      diagnosed_date: dto.diagnosed_date !== undefined ? dto.diagnosed_date : before.diagnosed_date,
      clearance_status: dto.clearance_status !== undefined ? dto.clearance_status : before.clearance_status,
      updated_at: now,
    });

    const after = await this.repository.findByIdAndMemberId(historyId, memberId);
    if (!after) {
      throw new NotFoundError('Medical history record not found after update');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'medical_history.updated',
      entityName: 'medical_histories',
      entityId: historyId,
      beforeState: before,
      afterState: after,
    });

    return this.toDto(after);
  }

  async delete(
    memberId: number,
    historyId: number,
    actor: AuthenticatedUser,
  ): Promise<void> {
    await requireScopedMember(this.memberRepository, memberId, actor);
    const before = await this.repository.findByIdAndMemberId(historyId, memberId);
    if (!before) {
      throw new NotFoundError('Medical history record not found');
    }

    await this.repository.deleteHistory(historyId, memberId);

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'medical_history.deleted',
      entityName: 'medical_histories',
      entityId: historyId,
      beforeState: before,
    });
  }
}
