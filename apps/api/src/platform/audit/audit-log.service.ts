import { Injectable } from '@nestjs/common';
import type { AuditLog } from '../db/schema/audit-logs';
import { createPaginatedResponse, PaginationHelper } from '../http/pagination';
import type { PaginatedResponse } from '../http/pagination.dto';
import type { AuditLogFilterQueryDto } from './audit-log.dto';
import { AuditLogRepository } from './audit-log.repository';

@Injectable()
export class AuditLogService {
  constructor(
    private readonly repository: AuditLogRepository,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  async list(
    rawQuery: Record<string, unknown>,
    filter: AuditLogFilterQueryDto,
  ): Promise<PaginatedResponse<AuditLog>> {
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);

    const { rows, total } = await this.repository.findManyFiltered({
      actorUserId: filter.actor_user_id,
      entityName: filter.entity_name,
      entityId: filter.entity_id,
      action: filter.action,
      from: filter.from,
      to: filter.to,
      cursorId: pagination.mode === 'cursor' ? pagination.cursor?.id : undefined,
      limit: pagination.limit,
    });

    return createPaginatedResponse({
      items: rows,
      total,
      limit: pagination.limit,
      requestCursor: pagination.mode === 'cursor' ? filter.cursor ?? null : null,
      cursorExtractor: (item) => ({ createdAt: item.created_at.toISOString(), id: item.id }),
    });
  }
}
