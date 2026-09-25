import { Injectable } from '@nestjs/common';
import type { Permission } from '../platform/db/schema/permissions';
import { createPaginatedResponse, PaginationHelper } from '../platform/http/pagination';
import type { PaginatedResponse } from '../platform/http/pagination.dto';
import { PermissionRepository } from './permission.repository';

@Injectable()
export class PermissionService {
  constructor(
    private readonly repository: PermissionRepository,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  async list(rawQuery: Record<string, unknown>): Promise<PaginatedResponse<Permission>> {
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;

    const { rows, total } = await this.repository.findManyPaged(pagination.limit, offset);

    return createPaginatedResponse({
      items: rows,
      total,
      limit: pagination.limit,
      offset,
    });
  }
}
