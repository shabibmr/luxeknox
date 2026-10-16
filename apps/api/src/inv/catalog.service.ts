import { Injectable } from '@nestjs/common';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import { catalogFilterQuerySchema, type ItemCategoryDto, type UomDto } from './catalog.dto';
import { InventoryCatalogRepository } from './catalog.repository';

@Injectable()
export class InventoryCatalogService {
  constructor(
    private readonly repository: InventoryCatalogRepository,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  async listUoms(rawQuery: Record<string, unknown>): Promise<PaginatedResponse<UomDto>> {
    const filters = catalogFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;
    const { rows, total } = await this.repository.findUoms({
      isActive: filters.is_active,
      limit: pagination.limit,
      offset,
    });
    return createPaginatedResponse({
      items: rows.map((row) => ({
        id: row.id,
        code: row.code,
        name: row.name,
        decimal_places: Number(row.decimal_places),
        is_active: Boolean(row.is_active),
      })),
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async listCategories(
    rawQuery: Record<string, unknown>,
  ): Promise<PaginatedResponse<ItemCategoryDto>> {
    const filters = catalogFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const offset = pagination.offset ?? 0;
    const { rows, total } = await this.repository.findCategories({
      isActive: filters.is_active,
      limit: pagination.limit,
      offset,
    });
    return createPaginatedResponse({
      items: rows.map((row) => ({
        id: row.id,
        name: row.name,
        parent_id: row.parent_id ?? null,
        is_active: Boolean(row.is_active),
      })),
      limit: pagination.limit,
      offset,
      total,
    });
  }
}
