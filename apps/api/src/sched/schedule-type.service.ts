import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import type { NewScheduleType, ScheduleType } from '../platform/db/schema/scheduling';
import { ConflictError, NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import type { ScheduleTypeUpdateDto, ScheduleTypeWriteDto } from './schedule-type.dto';
import { ScheduleTypeRepository } from './schedule-type.repository';

@Injectable()
export class ScheduleTypeService {
  constructor(
    private readonly repository: ScheduleTypeRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
  ) {}

  async list(rawQuery: Record<string, unknown>): Promise<PaginatedResponse<ScheduleType>> {
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;
    const { rows, total } = await this.repository.findMany(pagination.limit, offset);
    return createPaginatedResponse({ items: rows, limit: pagination.limit, offset, total });
  }

  async getById(id: number): Promise<ScheduleType> {
    const row = await this.repository.findById(id);
    if (!row) {
      throw new NotFoundError('Schedule type not found');
    }
    return row;
  }

  async create(dto: ScheduleTypeWriteDto, actor: AuthenticatedUser): Promise<ScheduleType> {
    const existing = await this.repository.findByName(dto.name);
    if (existing) {
      throw new ConflictError(`Schedule type "${dto.name}" already exists`);
    }

    const now = new Date();
    const id = await this.repository.insertType({
      name: dto.name,
      color_code: dto.color_code ?? null,
      default_duration_minutes: dto.default_duration_minutes ?? 60,
      requires_trainer: dto.requires_trainer ?? false,
      created_at: now,
      updated_at: null,
    });

    const created = await this.repository.findById(id);
    if (!created) {
      throw new NotFoundError('Schedule type not found after create');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'schedule_type.created',
      entityName: 'schedule_types',
      entityId: id,
      afterState: created,
    });

    return created;
  }

  async update(
    id: number,
    dto: ScheduleTypeUpdateDto,
    actor: AuthenticatedUser,
  ): Promise<ScheduleType> {
    const before = await this.repository.findById(id);
    if (!before) {
      throw new NotFoundError('Schedule type not found');
    }

    if (dto.name !== undefined && dto.name !== before.name) {
      const existing = await this.repository.findByName(dto.name);
      if (existing) {
        throw new ConflictError(`Schedule type "${dto.name}" already exists`);
      }
    }

    const values: Partial<NewScheduleType> = { updated_at: new Date() };
    if (dto.name !== undefined) values.name = dto.name;
    if (dto.color_code !== undefined) values.color_code = dto.color_code;
    if (dto.default_duration_minutes !== undefined) {
      values.default_duration_minutes = dto.default_duration_minutes;
    }
    if (dto.requires_trainer !== undefined) values.requires_trainer = dto.requires_trainer;

    await this.repository.updateType(id, values);

    const after = await this.repository.findById(id);
    if (!after) {
      throw new NotFoundError('Schedule type not found after update');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'schedule_type.updated',
      entityName: 'schedule_types',
      entityId: id,
      beforeState: before,
      afterState: after,
    });

    return after;
  }
}
