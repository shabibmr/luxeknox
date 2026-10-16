import { Injectable } from '@nestjs/common';
import type { ItemKind } from '../acct/items.dto';
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
      id: row.id,
      name: row.name,
      sku: row.sku ?? null,
      hsn_sac: row.hsn_sac ?? null,
      item_kind: row.item_kind as ItemKind,
      category_id: row.category_id ?? null,
      category_name: row.category_name ?? null,
      uom_id: row.uom_id,
      uom_code: row.uom_code,
      uom_decimal_places: Number(row.uom_decimal_places),
      sale_rate: row.sale_rate ?? null,
      purchase_rate: row.purchase_rate ?? null,
      tax_code_id: row.tax_code_id ?? null,
      income_account_id: row.income_account_id,
      expense_account_id: row.expense_account_id,
      inventory_account_id: row.inventory_account_id ?? null,
      cogs_account_id: row.cogs_account_id ?? null,
      inventory_tracked: Boolean(row.inventory_tracked),
      reorder_level: row.reorder_level ?? null,
      has_movements: hasMovements,
      is_active: Boolean(row.is_active),
      row_version: row.row_version,
      created_at: row.created_at,
      updated_at: row.updated_at ?? null,
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
