import { Injectable } from '@nestjs/common';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { AuditService } from '../platform/audit/audit.service';
import type { Facility, NewFacility } from '../platform/db/schema/scheduling';
import { ConflictError, NotFoundError } from '../platform/errors/app-error';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import type { FacilityUpdateDto, FacilityWriteDto } from './facility.dto';
import { FacilityRepository } from './facility.repository';

@Injectable()
export class FacilityService {
  constructor(
    private readonly repository: FacilityRepository,
    private readonly paginationHelper: PaginationHelper,
    private readonly auditService: AuditService,
  ) {}

  async list(rawQuery: Record<string, unknown>): Promise<PaginatedResponse<Facility>> {
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;
    const { rows, total } = await this.repository.findMany(pagination.limit, offset);
    return createPaginatedResponse({ items: rows, limit: pagination.limit, offset, total });
  }

  async getById(id: number): Promise<Facility> {
    const row = await this.repository.findById(id);
    if (!row) {
      throw new NotFoundError('Facility not found');
    }
    return row;
  }

  async create(dto: FacilityWriteDto, actor: AuthenticatedUser): Promise<Facility> {
    const existing = await this.repository.findByName(dto.name);
    if (existing) {
      throw new ConflictError(`Facility "${dto.name}" already exists`);
    }

    const now = new Date();
    const id = await this.repository.insertFacility({
      name: dto.name,
      capacity: dto.capacity ?? 1,
      location_details: dto.location_details ?? null,
      is_active: dto.is_active ?? true,
      created_at: now,
      updated_at: null,
    });

    const created = await this.repository.findById(id);
    if (!created) {
      throw new NotFoundError('Facility not found after create');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'facility.created',
      entityName: 'facilities',
      entityId: id,
      afterState: created,
    });

    return created;
  }

  async update(id: number, dto: FacilityUpdateDto, actor: AuthenticatedUser): Promise<Facility> {
    const before = await this.repository.findById(id);
    if (!before) {
      throw new NotFoundError('Facility not found');
    }

    if (dto.name !== undefined && dto.name !== before.name) {
      const existing = await this.repository.findByName(dto.name);
      if (existing) {
        throw new ConflictError(`Facility "${dto.name}" already exists`);
      }
    }

    const values: Partial<NewFacility> = { updated_at: new Date() };
    if (dto.name !== undefined) values.name = dto.name;
    if (dto.capacity !== undefined) values.capacity = dto.capacity;
    if (dto.location_details !== undefined) values.location_details = dto.location_details;
    if (dto.is_active !== undefined) values.is_active = dto.is_active;

    await this.repository.updateFacility(id, values);

    const after = await this.repository.findById(id);
    if (!after) {
      throw new NotFoundError('Facility not found after update');
    }

    await this.auditService.recordAudit({
      actorUserId: actor.id,
      action: 'facility.updated',
      entityName: 'facilities',
      entityId: id,
      beforeState: before,
      afterState: after,
    });

    return after;
  }
}
