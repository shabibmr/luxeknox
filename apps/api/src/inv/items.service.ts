import { Injectable } from '@nestjs/common';
import { mapItemDto } from '../acct/items.mapper';
import type { AuthenticatedUser } from '../auth/auth.guard';
import { NotFoundError } from '../platform/errors/app-error';
import {
  createPaginatedResponse,
  PaginationHelper,
  type PaginatedResponse,
} from '../platform/http/pagination';
import {
  inventoryItemFilterQuerySchema,
  type InventoryItemDto,
} from './items.dto';
import { InventoryItemsRepository, type InventoryItemRow } from './items.repository';
import { StockRepository } from './stock.repository';

@Injectable()
export class InventoryItemsService {
  constructor(
    private readonly repository: InventoryItemsRepository,
    private readonly stockRepository: StockRepository,
    private readonly paginationHelper: PaginationHelper,
  ) {}

  toDto(row: InventoryItemRow, hasMovements: boolean): InventoryItemDto {
    return {
      ...mapItemDto(row),
      category_name: row.category_name ?? null,
      uom_code: row.uom_code,
      uom_decimal_places: Number(row.uom_decimal_places),
      has_movements: hasMovements,
    };
  }

  async list(
    rawQuery: Record<string, unknown>,
    _actor?: AuthenticatedUser,
  ): Promise<PaginatedResponse<InventoryItemDto>> {
    const filters = inventoryItemFilterQuerySchema.parse(rawQuery);
    const pagination = await this.paginationHelper.normalizeParams(rawQuery);
    const requestCursor = typeof rawQuery.cursor === 'string' ? rawQuery.cursor : null;
    const filterParams = {
      itemKind: filters.item_kind,
      search: filters.search,
      categoryId: filters.category_id,
      isActive: filters.is_active,
      inventoryTracked: filters.inventory_tracked,
    };

    if (pagination.mode === 'cursor' && pagination.cursor) {
      const { rows, total } = await this.repository.findMany({
        ...filterParams,
        limit: pagination.limit + 1,
        cursor: pagination.cursor,
      });

      const withMovements = await this.stockRepository.findItemIdsWithMovements(
        rows.map((row) => row.id),
      );

      return createPaginatedResponse({
        items: rows.map((row) => this.toDto(row, withMovements.has(row.id))),
        limit: pagination.limit,
        requestCursor,
        total,
        cursorExtractor: (item) => ({
          createdAt:
            item.created_at instanceof Date
              ? item.created_at.toISOString()
              : String(item.created_at),
          id: item.id,
        }),
      });
    }

    const offset = pagination.offset ?? 0;
    const { rows, total } = await this.repository.findMany({
      ...filterParams,
      limit: pagination.limit,
      offset,
    });

    const withMovements = await this.stockRepository.findItemIdsWithMovements(
      rows.map((row) => row.id),
    );

    return createPaginatedResponse({
      items: rows.map((row) => this.toDto(row, withMovements.has(row.id))),
      limit: pagination.limit,
      offset,
      total,
    });
  }

  async getById(id: number, _actor?: AuthenticatedUser): Promise<InventoryItemDto> {
    const item = await this.repository.findReadById(id);
    if (!item) {
      throw new NotFoundError(`Item ${id} was not found`);
    }
    const withMovements = await this.stockRepository.findItemIdsWithMovements([id]);
    return this.toDto(item, withMovements.has(id));
  }
}
